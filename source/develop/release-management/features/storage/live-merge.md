---
title: Live Merge
category: feature
authors: aglitke, gpadgett
status: Released in oVirt 3.5.1
feature_name: Live Merge
feature_modules: engine,vdsm
feature_status: Released in oVirt 3.5.1
---

# Live Merge

## Summary

Live merge makes it possible to delete virtual machine disk snapshots that are no longer needed while the virtual machine continues to run.

## Owners

*   Name: Adam Litke (<alitke@redhat.com>)
*   Name: Greg Padgett (<gpadgett@redhat.com>)

## Current status

Released in oVirt 3.5.1

## Detailed Description

The user presentation of the live merge feature is simple - the only noticeable change is that the 'Remove' snapshot command is no longer disabled when a virtual machine is running. Behind the scenes, however, the flow is quite complex. Live merge is an asynchronous operation, and maintaining the consistency of management meta data and actual virtual machine storage requires delicate handling of many different error scenarios. The following is a detailed description of the flow and processes that need to be in place on both the engine and on VDSM. See the flow diagram below for a graphical overview of the processes.

A live merge is initiated when a user clicks the 'Remove' command associated with a disk snapshot. If the virtual machine is down, the existing cold merge flow is followed. If the virtual machine is up, a live merge is attempted. The engine calls the VDSM merge() verb on the host on which the virtual machine is running. First, VDSM associates a new `blockJob` record with the virtual machine. This record is initially populated with placeholder values so that it can serve as a record that a job is just beginning. Next, VDSM calls the libvirt `virDomainBlockCommit` API to start the merge. This libvirt call is asynchronous and its completion is signaled by an event (ignored by VDSM) and the job being no longer reported by the `virDomainBlockJobInfo` API. Finally, VDSM returns success to engine. Some considerations regarding race conditions with reporting block job information via the virtual machine Stats mechanism will appear later in this page.

The next phase of live merge is a polling phase conducted by the engine. As long as the VDSM `getAllVmStats` API reports a job with a matching jobID, the job is assumed to be ongoing and engine just waits. VDSM is careful to save a record of the block job in the virtual machine recovery file so that polling will maintain consistency over VDSM restarts. Because the block job is part of the qemu process, any action that causes a virtual machine to go down will abort all block jobs for that virtual machine. Once the job is no longer reported, the engine enters the final phase of the job, which resolves what happened and cleans up.

On the VDSM side, the live merge operation is performed by the running qemu process and is monitored by libvirt for completion. If it completes, qemu rewrites the qcow headers in the volume chain to reflect the new situation. For example, if the original chain was A<--B<--C where A was the base image and C was the active layer and B was merged into A, then qemu would update the qcow header of C to change the base image from B to A. Until this header change is atomically applied, the merge is considered to have not happened at all (even though some data may have been copied from B into A). VDSM determines what synchronization is required based on how the volume chain reported by libvirt in the domain's live XML has changed. For example, if a volume has been removed from the chain, it should be removed from the VDSM representations of that chain. It should be noted that as soon as a merge begins (and until the merge is successful), the snapshot being merged into cannot be previewed or reverted to. The engine must take care to track this limitation to prevent data corruption. When a block job ends successfully, VDSM must synchronize its internal state with qemu and the new image chain. On the virt side, we must update the virtual machine conf to reflect the new volume chain. We do this by checking the volume chain as reported by libvirt in the live domain XML. On the storage side, we must update the volume chain metadata that is maintained on the storage itself.

The command must be resolved after the job is reported to have ended. Engine resolves the command by retrieving the `VmDefinition` from VDSM and examining the volume chain. Engine will perform a membership test for the snapshot volume UUID against the VDSM returned list to see if the snapshot has been removed from the volume chain. If not, then the merge is marked failed and the disk snapshot will be unlocked by engine. If the snapshot has been removed from the chain then the engine submits one final delete command to VDSM to remove the no longer needed volume from storage before returning successfully.

### Special case: Merge the active layer into its parent

The logic for active layer commit is a bit more complex than the basic case of merging an internal snapshot. For active commit, libvirt manages a two phase process. In the first phase, qemu copies data from the active layer into its parent. It also mirrors disk writes to both the active layer and its parent. The completion of this phase can be observed when the libvirt block job 'cur' cursor value equals the 'end' cursor value and the block job type is active commit. The second phase is triggered automatically by VDSM which issues a special `virDomainBlockJobAbort` call. Phase 2 ends as normal when the block job is no longer reported.

### Special case: Extend internal sparse block volumes during live merge

If the virtual machine disk resides on block storage and the volume where data is being merged is sparse, then it may be necessary to extend this volume periodically during live merge. This operation is an extension of the normal SPM Mailbox driven flow which up to now has only extended the active layer. Candidate volumes are found by using VDSM's cached block job information. If the remaining space is too small, then a resize request is sent to the SPM. Note that the formal libvirt API for this has not yet been defined but it should be soon.

### Detecting if Live Merge can be supported

### Flow Diagram

This diagram is a bit out-dated. Please bear with the developers until they can update it. ![](/images/wiki/Live-merge-flow.png)

### Special considerations for ovirt-engine

*   When a Live Merge is performed, engine's `RemoveSnapshotCommand` branches and calls `RemoveSnapshotSingleDiskLiveCommand`. This new command uses a new command-execution infrastructure which allows for the coordination of HSM Async Tasks by polling for the expected end state after a job is completed, rather than relying on the SPM to maintain a list of jobs. See [`CommandCoordinator`'s feature page](/develop/release-management/features/infra/commandcoordinator.html) for further details.
*   Care is taken to prevent race conditions when tracking Live Merge jobs executed by VDSM. For SPM jobs, a job placeholder is inserted into the database before the job is started on VDSM. This is reversed in the case of Live Merge, where the block job placeholder is stored in the database only after the call to VDSM to start the job has returned. Accordingly, a virtual machine job may accidentally be discovered by the polling thread, but the polling thread will not accidentally remove a job that has not yet started. Only after a job is in the database is the polling thread is allowed to update or remove it. This simplifies the control flow and ensures that the thread starting the job has an opportunity to finish any tasks before handing off control to the monitoring thread.
*   Upon command completion, engine updates the database records to reflect the current state of the images. If the merge and deletion steps were successful, the deleted image is removed from the database along with the deleted snapshot. If the merge succeeded but deletion failed, the virtual machine's volume chain is corrected in the database, and the now-orphaned image is marked illegal and associated with the defunct snapshot. If merging failed, the volume chain remains intact but the images involved are marked illegal. The state of the database records after these failure scenarios make it possible for the command to be retried, where upon success the database will be cleaned up as if no failure had occurred..

### Special considerations for VDSM

*   The list of active block jobs is gathered and cached by VDSM using the `VmStatsThread`. This improves efficiency by reducing the number of libvirt calls needed and by reusing an existing engine-host polling mechanism. Unfortunately it creates some potential race conditions between engine and the host. We must guarantee that the stats contain the new job as soon as we return success to engine regarding creation of the live merge job. Otherwise engine could mistakenly think the job has ended. Engine also needs to disregard any stats that it has cached prior to executing the live merge command because those stats will not contain the block job information either. We are thinking of using the virtual machine generation ID to serialize this.
*   Once a block job has completed, we need to correct the VDSM volume chain metadata on storage. Unfortunately the rules for updating the volume chain differ depending if the storage is on a `BlockSD` or a `FileSD`. For `FileSD`, we must update the chain from the HSM host that is running the virtual machine. For `BlockSD`, the SPM must perform the update since the chain is stored in the LVM metadata. So, when handling block job completions, we will always mark the volume illegal and we will also correct the storage metadata if allowed. The `deletelVolumes` verb is an SPM operation and it will delete the volume and also correct the volume chain metadata if dealing with block storage.

## Benefit to oVirt

This feature hides the complexity of the Live Merge flow behind a simple "Delete" button in the user interface. This results in symmetric create/delete snapshot operations regardless of whether the virtual machine is running or not. This feature has been actively requested by users.

## Dependencies / Related Features

### Libvirt

*   [live snapshot merge (commit) of the active layer](https://bugzilla.redhat.com/show_bug.cgi?id=1062142)
*   [Returning the watermark for all the images opened for writing](https://bugzilla.redhat.com/show_bug.cgi?id=1041569)
*   [virDomainBlockCommit fails with live snapshots on oVirt block storage](https://bugzilla.redhat.com/show_bug.cgi?id=1102881)

### Engine

*   [CommandCoordinator](/develop/release-management/features/infra/commandcoordinator.html)

## Documentation / External references

*   [libvirt blockCommit API](https://libvirt.org/html/libvirt-libvirt-domain.html#virDomainBlockCommit)

## Testing

### IMPORTANT: Special environment setup

Some of the libvirt and qemu features required to enable live merge in oVirt are not yet present in official releases. Vdsm will refuse to perform a merge unless a fully featured kvm stack is installed. To try this on your system, please update your Fedora 20 system according to the following instructions:

*   Enable the virt-preview repository on Fedora (instructions [here](http://fedoraproject.org/wiki/Virtualization_Preview_Repository).
*   Update libvirt and qemu packages from the virt-preview repo.
*   Restart libvirtd
*   Restart vdsmd

### Caveats for block storage

We have an [open blocker bug](https://bugzilla.redhat.com/show_bug.cgi?id=1041569) for returning internal volume high write watermark information from libvirt. Until this is fixed, vdsm will refuse to initiate live merges for disks on block storage. For now, please test with file-based storage.

Due to [this bug](https://bugzilla.redhat.com/show_bug.cgi?id=1102881), libvirt will fail to perform live merges due to a problem with the SELinux policy. To work around the problem, set your host to permissive mode (`setenforce 0`).

### Positive flow (Create and remove a snapshot while a VM runs)

*   In webadmin, start a VM and create a new snapshot
*   Navigate to the VM's disks and for each disk, select the snapshot that was created and click the Remove button
*   After a few seconds, the snapshots should be removed from the list

### Negative flow (engine restart during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate ovirt-engine
*   Wait for the operation to complete by using `vdsClient getAllVmStats | grep vmJobs` on the virt host and watching for the entry to disappear
*   Restart engine
*   The command coordinator should resume the engine-side flows which should complete successfully
*   In webadmin, confirm that the snapshot is removed after a few seconds.
*   Check that the volume associated with the snapshot has been removed from storage

### Negative flow (vdsm restart during live merge)

*   Start in webadmin by selecting a running VM and creating a new snapshot and wait for it to finish.
*   From within the VM, write about 100M of data to the disk (this ensures that a live merge will not complete too quickly for this test).
*   Remove the snapshot you just creates (as in the positive flow) then immediately terminate vdsm
*   Wait for the host to go unresponsive in the webadmin
*   Restart vdsm and wait for the host to return to Up status. Engine will resume monitoring the merge progress.
*   In webadmin, confirm that the snapshot is removed after some time passes.
*   Check that the volume associated with the snapshot has been removed from storage

### Negative flow (VM crashes during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate the VM
*   A live merge failure event should appear in the audit log and the snapshot should remain in the list




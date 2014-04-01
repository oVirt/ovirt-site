---
title: LiveMerge
authors: aglitke
wiki_title: LiveMerge
wiki_revision_count: 20
wiki_last_updated: 2014-04-09
feature_name: Live Merge
feature_modules: engine,vdsm
feature_status: Development
---

# Live Merge

### Summary

Live merge makes it possible to delete VM disk snapshots that are no longer needed while the VM continues to run.

### Owners

*   Name: [ Adam Litke](User:AdamLitke) <alitke@redhat.com>
*   Name: [ Greg Padgett](User:GregPadgett) <gpadgett@redhat.com>

### Current status

Design and Development underway

Patches:

*   [LiveMerge: Add Image.getVolumeChain API](http://gerrit.ovirt.org/#/c/25918/)

<!-- -->

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

The user presentation of the live merge feature is simple. The only noticeable change is that the 'Remove' snapshot command will no longer be disabled when a VM is running. Behind the scenes the flow is quite complex. Live merge is an asynchronous operation and maintaining the consistency of management metadata and actual VM storage requires delicate handling of many different error scenarios. The following is a detailed description of the flow and processes that will need to be in place on both the engine and on vdsm. See the flow diagram below for a graphical overview of the processes.

Live merge is initiated when a user clicks the 'Remove' command associated with a single disk snapshot. If the VM is down then the existing Merge Snapshot flow will be followed. If the VM is up then this new Live Merge Snapshot flow will be followed. A new bll command (henceforth called LiveMergeSnapshotCommand) that relates to the existing RemoveSnapshotCommand will be called by the UI to begin the process. This command determines the host on which the VM is running and executes a VDSCommand on that host in order to start the live merge. When vdsm receives this command it executes the libvirt blockCommit API. If successful, vdsm updates its VM configuration structure to indicate that a block job is now running on the selected VM disk. An engine supplied job UUID is saved so that this block job can be correlated back to the engine initiated operation. A placeholder block job is added to vdsm's VM statistics structure so that engine will be aware of the active job immediately. See the special considerations section for more information on avoiding races with cached block job information. The vdsm VM stats thread will periodically poll libvirt for block job status on any vm disks that are annotated with an engine supplied job UUID. At this point, control returns to the engine upon successful initiation of the live merge operation.

The second part of LiveMergeSnapshotCommand is to begin tracking the live merge using a new TransientTask object. TransientTasks are a new concept within ovirt and are being designed to handle future asynchronous operations without the complexity and rigidity of the current SPMAsyncTasks. Transient Tasks have two key properties: 1) there is a well-defined way to check if the task is running or not running, and 2) if the task is not running, there is a well-defined way to check if the operation succeeded or failed. These two things are defined for a LiveMergeTransientTask as follows: 1) The task is running if and only if the engine-supplied job UUID appears in the list of block jobs that has been collected from the most recently run getAllVmStats VDSCommand. 2) The task succeeded if the disk snapshot volume UUID no longer appears in the volume chain of the relevant VM Disk. The goal is to leverage as much of the existing SPMAsyncTask and AsyncTaskManager code within the engine as possible when providing the TransientTask implementation. This is especially true for persisting command parameters in the DB so that the task polling and task resolution operations have the context they need to perform their checks. The exact nature of refactoring to be done to the task management infrastructure is yet to be determined.

On the vdsm side, the live merge operation is performed by the running qemu process and is monitored by libvirt for completion. If it completes, qemu rewrites the qcow headers in the volume chain to reflect the new situation. For example, if the original chain was A<--B<--C where A was the base image and C was the active layer and B was merged into A, then qemu would update the qcow header of C to change the base image from B to A. Until this header change is atomically applied the merge is considered to not have happened at all (even though some data may have been copied from B into A). When a block job ends successfully, vdsm must synchronize its internal state with qemu and the new image chain. On the virt side, we must update the VM conf to reflect the new volume chain. On the storage side, we must mark the merged volume as ready to be deleted and update the volume chain metadata that is maintained on the storage itself.

If vdsm misses a block job completion event (because it was stopped or restarting) it will be able to resolve the status of the live merge by checking if the qemu volume chain matches vdsm's volume chain. When vdsm starts up and restores its state with respect to currently running VMs, it will check for any job UUIDs in VM disks (which indicate that a block job was or is running for that disk). It will then query libvirt for block job information and resume normally. Any block jobs which have stopped since vdsm was down will be handled as if they have completed at this time.

Once the TransientTask is found by engine to be finished, a new GetVolumeChainVDSCommand will be executed to resolve the task as successful or failed. This command asks vdsm for the actual volume chain for a VM disk. Vdsm will respond differently depending if the VM is running or not. If the VM is running, vdsm can return its cached version of the volume chain because it will have already synchronized with qemu as explained earlier. If the VM is down, the qemu-img command will be run on the underlying volumes directly in order to get the qcow volume chain. Engine will perform a membership test for the snapshot volume UUID against the vdsm returned list to see if the snapshot has been removed from the volume chain. If not, then the merge is marked failed and no further action is necessary. If the snapshot has been removed from the chain then the engine submits one final VDSCommand (called DeleteIllegalVolume) to remove the no longer needed volume from storage before returning successfully.

DeleteIllegalVolume is a special vdsm command that will remove a volume from storage only if it has been previously marked illegal. This protects against accidentally deleting snapshots that haven't finished merging.

#### Flow Diagram

![](live-merge-flow.png "live-merge-flow.png")

#### Special considerations for ovirt-engine

*   Greg, please note any additional special considerations I may have missed.

#### Special considerations for vdsm

*   The list of active block jobs is gathered and cached by vdsm using the VmStatsThread. This improves efficiency by reducing the number of libvirt calls needed and by reusing an existing engine->host polling mechanism. Unfortunately it creates some potential race conditions between engine and the host. We must guarantee that the stats contain the new job as soon as we return success to engine regarding creation of the live merge job. Otherwise engine could mistakenly think the job has ended. Engine also needs to disregard any stats that it has cached prior to executing the live merge command because those stats will not contain the block job information either. We are thinking of using the VM generation ID to serialize this.
*   Once a block job has completed, we need to do two things on the storage: 1) Mark the merged volume illegal, and 2) correct the vdsm volume chain metadata. It is always possible for an HSM host to mark volumes illegal so #1 will not present a problem. Unfortunately the rules for updating the volume chain differ depending if the storage is on a BlockSD or a FileSD. For FileSD, we must update the chain from the HSM host that is running the VM. For BlockSD, the SPM must perform the update since the chain is stored in the LVM metadata. So, when handling block job completions, we will always mark the volume illegal and we will also correct the storage metadata if allowed. The deleteIllegalVolume verb is an SPM operation and it will delete the volume if it is marked illegal but it will also correct the volume chain metadata if dealing with block storage.

### Benefit to oVirt

This feature hides the complexity of the Live Merge flows behind a simple clickable "Delete" button in the UI. This results in a symmetric create/delete snapshot operations regardless of whether the VM is running or not. This feature has been actively requested by users.

### Dependencies / Related Features

#### Libvirt

*   [live snapshot merge (commit) of the active layer](https://bugzilla.redhat.com/show_bug.cgi?id=1062142)

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

#### Positive flow (Create and remove a snapshot while a VM runs)

*   In webadmin, start a VM and create a new snapshot
*   Navigate to the VM's disks and for each disk, select the snapshot that was created and click the Remove button
*   After a few seconds, the snapshots should be removed from the list

#### Negative flow (engine restart during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate ovirt-engine
*   Wait for the operation to complete by using 'vdsClient getVolumeChain' on the virt host and watching for the volume to disappear
*   Restart engine
*   In webadmin, confirm that the snapshot is removed
*   Check that the volume associated with the snapshot has been removed from storage

#### Negative flow (vdsm restart during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate vdsm
*   Wait for the host to go unresponsive in the webadmin
*   Restart vdsm and wait for the host to return to Up status
*   In webadmin, confirm that the snapshot is removed
*   Check that the volume associated with the snapshot has been removed from storage

#### Negative flow (VM crashes during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate the VM
*   A live merge failure event should appear in the audit log and the snapshot should remain in the list

### Comments and Discussion

*   Refer to <Talk:LiveMerge>

<Category:Feature> <Category:Template>

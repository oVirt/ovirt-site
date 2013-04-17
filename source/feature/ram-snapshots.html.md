---
title: RAM Snapshots
category: feature
authors: arik
wiki_category: Feature
wiki_title: Features/RAM Snapshots
wiki_revision_count: 23
wiki_last_updated: 2013-11-21
---

# RAM Snapshots

### Summary

Save memory state in live snapshots.

### Owner

*   Name: [ Arik](User:Arik)
*   Email: <ahadas@redhat.com>

### Current status

*   Status: design
*   Targeted: oVirt-3.3 (proposed)
*   Last updated: ,

### Detailed Description

This feature will make it possible to save the memory state of a VM when creating live snapshot, and restore that memory state when running a VM which was just created from such snapshot or just reverted to such snapshot.

In version 1.0.1 an option that allows us to specify where the memory state should be saved as part of live snapshot was added to libvirt [1]. it allows us to specify external file in which the memory state will be saved. We will use this functionality to save the memory state to a file when we're taking a live snapshot of a VM (in a similar way to how it is done when suspending/hibernating VM), and restore that memory state when running a VM that was just created from/reverted to such snapshot (the same way it is done when running a suspended/hibernated VM).

The affected operations in the system are:

#### Create snapshot

Since taking a memory snapshot makes the guest VM unresponsive for some period of time, the user will have an option whether to have memory state or not when creating live snapshot. If the memory state was saved when the snapshot was created, the snapshot configuration will contain the volumes in which this state is saved.

#### Delete snapshot

Deletion of a snapshot that has memory state, should remove the memory state volumes as well.

#### Create VM from snapshot

In case a VM is created from snapshot that includes memory state, the user will be able to choose whether to restore the saved memory state from the snapshot when running the VM or not (in that case the VM will boot from disks).

#### Preview snapshot

In case a VM is set to preview a snapshot that includes memory state, the user will choose whether to use the saved memory state as described above.

#### Run VM

If there is memory state defined in the configuration of the VM, the saved memory state will be restored (instead of boot from the disks) the same way hibernated VM is restored.

The memory state volumes will be cleared from the VM configuration if the VM is not running in stateless mode.

Note: it is our responsibility to ensure that the disks state is the same as it was when the live snapshot was taken, when restoring memory state that was saved during the live snapshot. there is no validation in libvirt for that, and it may cause data corruption. So it is important to clear the memory state when there is a chance that the disks or the memory state was changed.

#### Import VM

If the collapse snapshots option was not selected, each snapshot will be imported with its memory state, if exists. If the collapse snapshots option was selected, no memory state will be imported (the active snapshot cannot have memory state).

#### Export VM

Each snapshot will be exported with its memory state, if exists.

### Benefit to oVirt

Currently, snapshot in oVirt includes the states of VM's disks only, and therefore in order to run a VM which is based on a snapshot the VM must boot from disk and start with fresh memory state.

This feature introduces new functionality for oVirt users that will allow them to save the memory state as part of live snapshots. That way, if a VM is run for the first time after being created from/reverted to a snapshot with memory state, it will be possible to restore the memory as it was at the moment the snapshot was taken. That means that the running applications will be the ones that ran at the moment the snapshot was taken, the clipboard content will be the same as it was at the moment the snapshot was taken, and so on.

### Dependencies / Related Features

*   The functionality of saving the memory state as part of live snapshot creation was introduced in libvirt 1.0.1, therefore it will require libvirt > 1.0.1.

### Design

#### Database changes

*   Add a column to the 'snapshots' table that will contain the memory state location
*   Add stored procedure which removes the memory state of a given snapshot
*   Add stored procedure which returns all the snapshots containing a given memory state location

#### Backend changes

##### Commands

*   CreateAllSnapshotCommand
    -   The parameters will include a memory state flag which indicates whether to take memory snapshot or not
    -   Execute stage
        -   If the VM is running and the memory state flag is on, an image will be created for the memory
        -   if the VM is not running and the memory state flag is on, turn off the memory state flag
    -   End-action stage
        -   If the VM is running + memory state flag is on + all tasks finished successfully, turn on the memory state flag for SnapshotVdsCommand
        -   If the VM is **NOT** running + memory state flag is on + all tasks finished successfully, remove the memory state image
        -   If the memory state flag is on + *NOT*' all tasks finished successfully, remove the memory state image

<!-- -->

*   SnapshotVdsCommand
    -   The parameters will include a memory state flag which indicates whether to take memory snapshot or not
    -   If cluster level < 3.3, send only two parameters for the vmSnapshot verb with the VM id and disk information
    -   If cluster level >= 3.3
        -   If the memory state flag is off, send a map with "mode:disks_only" mapping as the third parameter for the vmSnapshot verb
        -   If the memory state flag is on, send a map with "mode:disks_memory" mapping + information about the place to store the memory state as the third parameter for the vmSnapshot verb
        -   Note: the information about the place where to store the memory state will be similar to the way it is represented in HotPlugDiskVDSCommand. that way, it will allow us to represent locations in external disks as well. in the first stage, only domain-pool-image-volume quartet will be used as memory state image will be created as the image is created in HibernateVmCommand

<!-- -->

*   RemoveSnapshotCommand
    -   If the snapshot to be removed contains memory state, check if there're other snapshot that use that memory state. if there are no other snapshots pointing to the memory state, delete the memory state as well

<!-- -->

*   AddVmFromSnapshotCommand
    -   The parameters will include an indication whether to use the memory state from the snapshot or not
    -   If the use memory state indication is on, set the active snapshot of the created VM to point to the original snapshot's memory state location

<!-- -->

*   TryBackToAllSnapshotsOfVmCommand
    -   The parameters will include an indication whether to use the memory state from the snapshot or not
    -   If the use memory state indication is on, set memory state location of the newly added active snapshot to point to the original snapshot's memory state location

<!-- -->

*   RunVmCommand
    -   If the VM is not paused and its active snapshot contains memory state
        -   The created VM will contain the memory state location taken from the active snapshot
            -   The memory state location will be stored in the hibernation-vol-handle field of the VM
            -   The memory state will be cleared from the active snapshot
    -   If the VM is running as stateless, the memory state from the active snapshot will be copied to the newly added active snapshot

<!-- -->

*   ImportVmCommand
    -   If the collapse snapshots option is on
        -   If the active snapshot contains memory state then import its memory state file as well
    -   If the collapse snapshots option is off
        -   For every snapshot of the VM, if the snapshot contains memory state then import its memory state file as well

<!-- -->

*   ExportVmCommand
    -   For every snapshot of the VM, if the snapshot contains memory state then export the memory state file as well

##### OVF files

The snapshot section in OVF file of VM will include the place where the memory state is stored.

##### backward compitability

*   This feature will be enabled for cluster version 3.3 and above.
*   For cluster level less than 3.3, SnapshotVdsCommand will call vmSnapshot verb without the third parameter.
*   On db-upgrade, existing snapshots will have empty value in the memory state volumes field.

#### VDSM changes

*   Default parameter will be added to vmSnapshot verb that maps string to string.
    -   The map will include two keys for now:
        -   'mode' that can be mapped to 'disks_only' or 'disks_memory' to indicate if memory state should be saved.
        -   'memVol' that will be mapped to a string that represent the two volums that will be used to save the memory state and the VM configuration.
    -   The default map will include the mapping of 'mode':'disks_only' only.
*   If the 'mode' value in the map decribed above is 'disks_memory' the first volume in 'memVol' will be passed to libvirt in order to dump the memory to it, and the second volume in 'memVol' will be used to save the VM configuration (the same way it is done for hibernate operation).

#### User Interface changes

TBD

#### REST API changes

TBD

### Documentation / External references

[1] [libvirt's snapshot XML format](http://libvirt.org/formatsnapshot.html)

### Comments and Discussion

*   Refer to <Talk:RAM_Snapshot>

<Category:Feature>

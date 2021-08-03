---
title: RAM Snapshots
category: feature
authors: arik
---

# RAM Snapshots

## Summary

Save memory state in live snapshots.

## Owner

* Name: Arik Hadas
* Email: ahadas@redhat.com

## Current status

* Status: Merged
* Target Release: 3.3

## Detailed Description

This feature will make it possible to save the memory state of a VM when creating live snapshot, and restore memory state when running a VM that previews or has been committed to such snapshot.

In version 1.0.1 an option that allows to specify where the memory state should be saved as part of live snapshot was added to libvirt [[1](#1)]. It allows us to specify external file in which the memory state will be saved. We will use this option to save the memory state to file when we're taking a live snapshot of a VM in a similar way to how it is done when suspending/hibernating VM, and restore the memory state when running a VM that was set to preview or committed to snapshot that contains memory state, in a similar way to the way it is done when running a suspended/hibernated VM.

The affected operations in the system are:

### Create snapshot

The user will be able to choose whether to save the memory state or not when taking live snapshot. If a snapshot contains memory, its configuration will contain the volumes in which the memory related data (memory dump and configuration of the VM at the moment the snapshot was taken) are saved.

During live snapshot with memory creation, the VM will be locked to prevent it from being changed. When the memory dump is being saved, the VM will be switched to 'paused' state.

The user will have indication whether snapshot contains memory or not.

### Remove snapshot

Removing a snapshot that contains memory state will remove the memory state volumes as well.

### Create VM from snapshot

**Update:** when creating VM from snapshot that contains memory, the VM will be created without the saved memory.

### Preview/Revert to snapshot

In case a VM is set to preview or revert to a snapshot that includes memory, the user will be able to choose whether to restore the saved memory or not.

### Commit snapshot

Commit to snapshot operation will preserve the memory state of the previewed VM.

If snapshots are being removed during the commit operation (snapshots which are newer than the snapshot we commit to), their memory states will also be removed (if exists).

### Run VM

When running a VM that was set to preview or was committed to snapshot that contains memory, that memory will be restored (instead of regular boot), in the same way hibernated VM is restored.

Note that it holds only for the first time the VM is being run after it was set to preview or was committed to the snapshot if the VM is not stateless. For stateless VM, the memory will be restored on each run.

Note: it is our responsibility to ensure that the disks state is the same as it was when the live snapshot was taken, when restoring memory state that was saved during the live snapshot. There is no validation in libvirt for that, and it may cause data corruption. So it is important to clear the memory state when there is a chance that the disks or the memory state was changed.

### Import VM

**Update:** each snapshot will be imported with its memory state, if exists.

* Notes:
 - including the active snapshot.
 - not including snapshots that were collapsed.
 - only when the import is not set to 'import as clone'

### Export VM

Each snapshot will be exported with its memory state, if exists.

## Benefit to oVirt

Currently, snapshot in oVirt includes the states of VM's disks only, and therefore in order to run a VM which is based on a snapshot the VM must boot and start with fresh memory state.

This feature introduces new functionality for oVirt users that will allow them to save the memory state as part of live snapshots. That way, if a VM is run for the first time after being reverted to a snapshot with memory state, it will be possible to restore the memory as it was at the moment the snapshot was taken. That means that the running applications will be the ones that ran at the moment the snapshot was taken, the clipboard content will be the same as it was at the moment the snapshot was taken, and so on.

## Dependencies / Related Features

* The functionality of saving the memory state as part of live snapshot creation was introduced in libvirt 1.0.1, therefore it will require libvirt > 1.0.1.
* If there is spice console connected to the VM while the snapshot is being taken, it will be closed in the process. The spice session should remain open, see: [https://bugzilla.redhat.com/show_bug.cgi?id=1010670](https://bugzilla.redhat.com/show_bug.cgi?id=1010670).

## Design

### Database changes

* Add a column to the 'snapshots' table that will contain the memory volume
* Add stored procedure which removes the memory state of a given snapshot
* Add stored procedure which returns all the snapshots containing a given memory state volume
* Add stored procedure which returns a snapshot by id of VM, snapshot type and snapshot status

### Backend changes

#### Commands

* CreateAllSnapshotCommand
 - The parameters will include a memory state flag which indicates whether to take memory snapshot or not
 - Execute stage
   - If the VM is running and the memory state flag is on, a volume will be created to store the memory
 - End-action stage
   - if the cluster compatibility level is 3.3 and above, pass the memory volume to the SnapshotVdsCommand or pass empty volume representation if the volume was not created
   - if the cluster compatibility level is lower than 3.3, don't pass the memory volume (keep it null)
   - if the live snapshot wasn't triggered, remove the memory volume

* SnapshotVdsCommand
 - The parameters will include memory volume
 - If the memory volume is not set (null), invoke the snapshot verb with vm id and disks as parameters only
 - Otherwise, invoke the snapshot verb with vm id, disks and the memory volume

Note: the volume representation will be comma-separated string, like the format used for hibernate verb

* RemoveSnapshotCommand
 - If the snapshot to be removed contains memory volume and there is no other snapshot pointing to the same memory volume, delete the memory volume as well

* TryBackToAllSnapshotsOfVmCommand
 - The parameters will include an indication whether to use the memory from the snapshot or not
 - If the indication to use memory from snapshot is on, set the memory volume of the newly active snapshot to point to the memory volume in the snapshot

* RestoreAllSnapshotsCommand
 - The memory volume of the newly active snapshot will point to the memory volume of the snapshot that is restored

* RunVmCommand
 - If the VM is not paused and not suspended, set the initial memory of the VM to be the memory from its active snapshot
   - The memory volume will be set in the hibernation-vol-handle field of the VM
   - The memory volume might be empty string if the active snapshot doesn't contain memory
   - VmInfoBuilderBase will pass the hibernation-vol-handle to the create verb not only when the current status of the VM is suspended (also when it is down)
 - Once the create verb return with successful result, the memory volume will be cleared from the active snapshot of the vm
   - If no other snapshot contains the same memory volume, the volume will be deleted
 - If the VM is running as stateless, the memory volume of the newly added active snapshot will point to the memory volume of the previous active snapshot, and then behave as described above

* ImportVmCommand
 - For each snapshot of the VM that contains memory, its memory volume will also be imported
 - If the option to import as clone is selected, the active snapshot of the imported VM won't have memory volume and no memory volume will be imported

* ExportVmCommand
 - For each snapshot of the VM that contains memory, its memory volume will be exported as well

#### OVF files

The snapshot section in OVF file of VM will include the memory volume of the snapshot, if exists

#### backward compitability

* This feature will be enabled for cluster version 3.3 and above.
* For cluster level less than 3.3, SnapshotVdsCommand calls vmSnapshot verb without the third parameter.
* On db-upgrade, existing snapshots will have empty value in the memory volume field.

### VDSM changes

* vmSnapshot
 - Default parameter will be added to vmSnapshot verb representing the memory volume.
   - **Update:** The memory volume parameter will be of type string
     - Memory volume is represented by comma-separated string of 4 elements: domain, pool, image, volume
     - The parameter can be an empty string if no memory volume is set
 - The default value of the new parameter will be empty string (backward compatibility)
 - If the memory volume parameter is not empty string, it would be parsed as file path and will be passes to libvirt in order to dump the memory to this file
 - Note: parsing comma-separated string of four elements to volume path will be added

* vmCreate
 - The given 'hiberVolHandle' can now represent one volume. In that case there will be 4 components in the string instead of 6, and it will be parsed as it is parsed in the vmSnapshot verb
 - If the given 'hiberVolHandle' is composed of 4 components
   - Use the volume represented by the string for the 'restoreState' parameter
 - Note: no need to update vm configuration from configuration file as the configuration is stored as part of the memory state file

* getVmStats
 - **Update:** If the VM is restoring memory state that was taken from snapshot, after the "Restoring State" status the VM will reports status "Up" (without the logic that reports "Powering Up" for 1 minute in case the guest agent is not responding)

### User Interface changes

* Create snapshot popup
 - A checkbox that allows the user to choose whether to save the memory state of the VM or not will be added
 - The memory state checkbox will be visible only if the VM is running

![](/images/wiki/Create_snapshot_screenshot.png)

* Snapshots tab
 - Memory column will be added that includes checkboxes indicating whether the snapshot contains memory or not

![](/images/wiki/Memory_column.png)

* Clone VM from snapshot popup
 - If the snapshot contains memory, a warning saying that the snapshot's memory will be discarded will be shown

* Import VM popup
 - If import as clone is selected and the active snapshot contains memory, a warning saying that the initial memory of the VM won't be imported will be shown

* Preview snapshot popup
 - New popup will be presented when choosing to preview a snapshot that contains memory
 - The new popup will have a checkbox that allows the user to choose whether to restore the memory state from the snapshot or not

![](/images/wiki/Preview_snapshot_screenshot.png)

### REST API changes

* A boolean flag indicating whether to take snapshot for the memory or not will be added to the snapshot creation request
* A boolean flag will be added to the snapshot representation indicating whether it contains memory or not

## Testing

### Snapshot creations

#### Test case 1

* Run VM
* Open 'create snapshot' dialog
* Select 'Save Memory' option and press OK
* Check that the created snapshot contains memory (it should appear in the snapshots subtab)

#### Test case 2

* Run VM
* Open 'create snapshot' dialog
* Do not select 'Save Memory' option and press OK
* Check that the created snapshot does not contain memory (it should appear in the snapshots subtab)

#### Test case 3

* This test should be made on cluster with compatibility version which is less that 3.3
* Run VM
* Open 'create snapshot' dialog
* Check that there is no 'Save Memory' option in the dialog and press OK
* Check that the created snapshot does not contain memory (it should appear in the snapshots subtab)

### Preview snapshot

#### Test case 1

* Open 'preview' dialog for snapshot with memory
* Select 'Restore Memory' option and press ok
* Run the VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)

#### Test case 2

* Open 'preview' dialog for snapshot with memory
* Do not select 'Restore Memory' option and press ok
* Run the VM
* Check that the initial status is 'powering up' and then 'up'
* Connect to the VM and check that it looks like it should be after boot

#### Test case 3

* This test should be made on cluster with compatibility version which is less that 3.3
* Open 'preview' dialog for snapshot with memory
* Check that there is no 'Restore Memory' option in the dialog and press ok
* Run the VM
* Check that the initial status is 'powering up' and then 'up'
* Connect to the VM and check that it looks like it should be after boot

### Commit to snapshot

#### Test case 1

* Open 'preview' dialog for snapshot with memory
* Select 'Restore Memory' option and press ok
* Select 'commit' from the snapshots subtab
* Check that the active snapshot appears with memory in the snapshots subtab
* Run the VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)

#### Test case 2

* Open 'preview' dialog for snapshot with memory
* Do not select 'Restore Memory' option and press ok
* Select 'commit' from the snapshots subtab
* Check that the active snapshot appears without memory in the snapshots subtab
* Run the VM
* Check that the initial status is 'powering up' and then 'up'
* Connect to the VM and check that it looks like it should be after boot

### Run VM

#### Test case 1

* Open 'preview' dialog for snapshot with memory
* Select 'Restore Memory' option and press ok
* Select 'commit' from the snapshots subtab
* Run the VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)
* Stop VM
* Run the VM
* Check that the initial status is 'powering up' and then 'up'
* Connect to the VM and check that it looks like it should be after boot

#### Test case 2

* Open 'preview' dialog for snapshot with memory
* Select 'Restore Memory' option and press ok
* Select 'commit' from the snapshots subtab
* Run the VM in stateless mode
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)
* Stop VM
* Run the VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)

### Export-Import VM

#### Test case 1

* Run VM
* Create live snapshot with memory
* Stop VM
* Preview the snapshot
* Commit to the snapshot
* Export the VM
* Remove the VM
* Import the VM
* Check that there are two snapshots with memory in the snapshots subtab
* Run VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)

#### Test case 2

* Run VM
* Create live snapshot with memory
* Stop VM
* Preview the snapshot
* Commit to the snapshot
* Export the VM
* Import the VM as clone (that's the only way to do so, as the VM already exists)
* Check that there is only one snapshot (the active snapshot) with no memory in the snapshots subtab
* Run VM
* Check that the initial status is 'powering up' and then 'up'
* Connect to the VM and check that it looks like it should be after boot

#### Test case 3

* On NFS storage:
* Run VM
* Create live snapshot with memory
* Stop VM
* Preview the snapshot
* Commit to the snapshot
* Export the VM
* On block-based storage:
* Import the VM
* Run VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)

#### Test case 4

As previous test case, but do the first steps on block-based storage and the latest on file based storage

#### Test case 5

* Run VM
* Create live snapshot with memory
* Stop VM
* Preview the snapshot
* Commit to the snapshot
* Export the VM using 'Collapse Snapshots'
* Remove the VM
* Import the VM
* Check that there is only the active snapshot with memory
* Run VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)

#### Test case 6

* Run VM
* Create live snapshot with memory
* Stop VM
* Preview the snapshot
* Commit to the snapshot
* Export the VM
* Remove the VM
* Import the VM using 'Collapse Snapshots'
* Check that there is only the active snapshot with memory
* Run VM
* Check that the initial status is 'restoring state' and then 'up'
* Connect to the VM and check that the previous state was restored (opened applications, clipboard content, etc)

## Future enhancements

* Memory state is going to be represented by the standard pool-domain-image-volume quartet. That is OK for now since that is the representation of images we create. When we'll support creation of images on lun or local path, the memory volume representation should be changed to support such locations.
* Not to save the memory configuration in the moment the snapshot is taken in a different volume. The configuration can be retrieve by the engine and then to be sent to vdsm.
* Until the enhancement above is implemented, the saving of the vm configuration saving in vdsm should be made as oop
* Use the snapshot's memory, if exists, for cloned VM from snapshot.
* Use the active snapshot's memory, if exists, for VM that was imported as clone.

## Documentation / External references

<a name="1">[1]</a> [libvirt's snapshot XML format](http://libvirt.org/formatsnapshot.html)




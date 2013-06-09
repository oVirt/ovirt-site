---
title: Read Only Disk
category: feature
authors: sgotliv, vered
wiki_category: Feature
wiki_title: Features/Read Only Disk
wiki_revision_count: 41
wiki_last_updated: 2014-07-03
---

# Read Only Disk

### Summary

VDSM already has a read-only disk capability. This feature adds that functionality to the engine as well.

### Owner

*   Name: [Vered Volansky](User:vvolansk)
*   Email: vered@redhat.com

### Current status

*   Target Release: 3.3
*   Status: work in progress
*   Last updated: ,

### Detailed Description

When adding/attaching a disk to a vm, add a property of RO. The RO property is not a disk property. It's a property of the VM-Disk relationship, and therefore is persisted through VMDevice (vm_device in the DB).
A shareable disk could be attached to one VM as RO, and to another as RW. This is the case as long as the disk is not qCow. qCow disks currently cannot be shared. When that'll change, it shouldn't be allowed to attach a RW qCow disk to one VM while attaching it as RO to another.
Floating disks are always RW and shouldn't be handled any differently than previously.
A disk cannot be switched from or to RO while active.

#### DB

vm_device table already has a is_readonly column. No update to the DB is needed.

#### Backend

*   The following commands need amending in order to process read-only setting:

AddDiskCommand (done, verified), AttachDiskToVmCommand (done) - Add the read-only property using params object and propagate until VMDevice creation.
All relating Parameters classes should now contain this info, either using the Disk diskInfo object (if set), or a new readOnly data member (if diskInfo set to null).
ImagesHandler.addDiskToVm() - will get the RO data and propagate it.
UpdateVmDiskCommand (step 2) - new disk read-only state is being read correctly at this point (verified), but vm_device is not updated at this point. The proper update should be added to the command at second phase.

*   The following commands don't need any changes, but it should be verified that they don't affect the read-only setting:

HotPlugDiskToVmCommand
DetachDiskFromVmCommand - verify that attach after detach is consistent with read-only value before detaching.
AddVmTemplateDevice - verify new disk's read-only state is the same as template's.
AddVmFromTemplateCommand - verify disk's read-only state in new vm is the same as template's.
AddVmFromSnapshotCommand - verify disk's read-only state in new vm is the same as snapshot's.
AddVmAndCloneImageCommand - verify new disk's read-only state is the same as original disk.
CreateSnapshotFromTemplate - verify disk's read-only state in new vm is the same as template's.
TryBackToAllSnapshotsOfVmCommand -(preview snapshot) - verify disk's read-only state is the same as snapshot's.
RestoreAllSnapshotsCommand (undo & commit snapshot).
RunVmCommand - verify read-only disks are indeed so (done).

*   import, export:

OvfReader.readVmDevice() (already reads the readOnly property).
OvfWriter.writeVmDeviceInfo() (already writes the readOnly property).
 ImagesHandler.addDiskToVm() - will get the RO data and propagate it.

##### Templates

Currently templates will maintain the current disk RO property value with editing option.
When creating a VM from template, it's disks will inherit the disk RO property value.
Disks properties can be changed when creating a vm from template as it is.

##### Snapshots

There's no need to save the images of RO disk to the images table.
There is, however, a need to update the ovf file so that it does include the RO disks (images).
Verified - the OvfReader does read the RO property, so no changes need to be made to snapshots uses.

#### UI

Changes will have to be made to RESTapi and uicommon in order to get the RO property value from the user.
In UI, this will be done by adding a ui item that reflects the user's choice, that will then be propagated to the backend (through the relevant command's parameters class) . This will affect VmDiskListModel and UpdateVMDiskCommand (Less urgent to implement, since unplug-plug can be used instead, but is easier to implement straight ahead due yo the common VmDiskOperationParameterBase class).

In RESTapi, this will be done by injecting the proper value to a new element to be added to the command action. This will then, as in the UI, be propagated to the backend.

#### Search

Add RO disk search capability

### Benefit to oVirt

This features allows the usage of read only disks. This is useful where we'd like to expose the data but don't want it to be altered. This is a new feature in the engine, allowing the attachment of a disk to a VM to be done with read only rights. A shareable disk could be attached to one VM as RO, and to another as RW.

### Comments and Discussion

*   Refer to [Talk:Features/Read Only Disk](Talk:Features/Read Only Disk)

<Category:Feature>

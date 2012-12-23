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

*   Target Release: 3.2
*   Status: work in progress
*   Last updated: 06:05, 23 December 2012 (GMT)

### Detailed Description

When adding/attaching a disk to a vm, add a property of RO. The RO property is not a disk property. It's a property of the VM-Disk relationship, and therefore is persisted through VMDevice (vm_device in the DB). A shareable disk could be attached to one VM as RO, and to another as RW. This is the case as long as the disk is not qCow. qCow disks currently cannot be shared. When that'll change, it shouldn't be allowed to attach a RW qCow disk to one VM while attaching it as RO to another.

#### DB

vm_device table already has a read_only column. No update to the DB is needed.

#### Backend

AddDiskCommand, AttachDiskToVmCommand - Add the RO property and propagate until VMDevice creation.
All relating Parameters classes should now contain this info. Therefore, VmDiskOperationParameterBase will be added a new readOnly data member.
ImagesHandler.addDiskToVm() - will get the RO data and propagate it.
 No changes need in:
HotPlugDiskToVmCommand
UpdateVmDiskCommand
DetachDiskFromVmCommand
CreateCloneOfTemplateCommand
AddVmTemplateDevice
AddVmFromTemplateCommand
CreateSnapshotFromTemplate
AddVmFromSnapshotCommand
AddVmAndCloneImageCommand
OvfReader.readVmDevice() (already reads the readOnly property).
OvfWriter.writeVmDeviceInfo() (already writes the readOnly property).

##### Templates

Currently templates will maintain the current disk RO property value with no editing option.
When creating a VM from template, it's disks will inherit the disk RO property value with no editing option.
Editing options to both phases can be added later on.
This is an open issue, please comment if you think this should be dealt with in another way.

##### Snapshots

There's no need to save the images of RO disk to the images table.
There is, however, a need to update the ovf file so that it does include the RO disks' (images).
Verified - the OvfReader does read the RO property, so no problem with snapshots uses.

#### UI

Changes will have to be made to RESTapi and uicommon in order to get the RO property value from the user.

### Benefit to oVirt

This features allows the usage of read only disks. This is useful where we'd like to expose the data but don't want it to be altered. This is a new feature in the engine, allowing the attachment of a disk to a VM to be done with read only rights. A shareable disk could be attached to one VM as RO, and to another as RW.

### Comments and Discussion

*   Refer to [Talk:Features/Read Only Disk](Talk:Features/Read Only Disk)

<Category:Feature>

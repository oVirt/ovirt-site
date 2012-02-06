---
title: DetailedSharedRawDisk
category: feature
authors: abaron, derez, mlipchuk, sandrobonazzola
wiki_category: Feature|SharedRawDisk
wiki_title: Features/DetailedSharedRawDisk
wiki_revision_count: 77
wiki_last_updated: 2015-01-16
wiki_warnings: list-item?
---

# Detailed Shared Raw Disk

## Shared Raw Disk

### Summary

The shared raw disk feature enables to share disks through multiple VMs in the Data Center.

### Owner

*   Feature owner: [ Maor Lipchuk](User:mlipchuk)

    * GUI Component owner: [ Daniel Erez](User:derez)

    * REST Component owner: [ Michael Pasternak](User:mpasternak)

    * Engine Component owner: [ Maor Lipchuk](User:mlipchuk)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: mlipchuk@redhat.com

### Current status

*   Target Release:
*   Status: Design Stage
*   Last updated date: Wed November 10 2011

### Detailed Description

The shared raw disk feature should provide the ability to attach a disk to multiple VMs that can handle concurrent access to a shared disk without risk of corruption,
The disk should behave as a flexible independent entity, that can be reflected as a standalone entity that is not shared between VMs(see <http://www.ovirt.org/wiki/Features/FloatingDisk>),
 or as a shared entity between multiple of VMs,. With this feature oVirt will be more compatible to support external cluster application, or shared data warehouse.

#### Entity Description

##### Disk

*   Disk should have an indication field for shared/not shared disk.

#### Functionality

*   The synchronization/clustering of shared raw disk between VMs is the responsibility of the guests. Unaware guests will lead to corruption of the shared disk.
*   Each VM which has attached shared raw disk, can R/W to the shared raw disk.
*   Shared raw disk will become floating disk when the disk will not be attached to any VMs in the Data Center.
*   When attaching shared raw disk the disk will be unplugged in the destination VM.
*   Shared raw disk is configured the same as a regular disk, but with a shared flag marked as true.
*   The shared raw disk can be removed if all the VMs that are using it are in status down or VMs which are in status up but the shared raw disk is unplugged.

Templates

*   When creating a template from a VM which one of its disks are shared, the shared raw disk will not be part of the template creation.
*   Template disks should not be shared.
*   VM disks which are created from template with thin provisioning, should not be referenced as shared raw disk.

Export/Import

*   When exporting a VM, only the disks which are not shared will be exported.

Move disk

*   Moving a shared raw disk is permitted only when all the attached VMs status are down, or all the disks which are attached to active VMs are unplugged.

Move VM

*   When moving a VM the shared raw disk should not be moved.

Snapshot

*   when taking a vm snapshot, a snapshot of the shared disk will not be taken.

Stateless VM

*   When running stateless VM, the shared raw disk will not be handle as stateless, the user should get a warning message indicating that the disk will not be handled as stateless.

VM pools

*   Since VM from pool is stateless, The same behaviour as stateless VM should be implemented here. shared raw disk will not be stateless in a stateless VM, and a warning message will be performed.

#### User Experience

*   Display shared disk
    -   The shared disks will be displayed in the 'disks' main tab.
    -   As part of the shared disk details, it will also be presented the number of VMs which are connected to the shared raw disk.
*   Adding shared disk
    -   Creating/Editing a shared raw disk is available through the new/edit disk dialog from the disks sub tab in the VM main tab.
         The add/edit disk dialog box will have a check box indicating the disk is shared or not.
        When a user wants to configure a regular disk to be shared disk, he will edit the disk and mark the checkbox as shared.
    -   User can also attach/detach shared disk through the disks sub tab of the VMs main tab,
    -   The administrator can attach/detach shared raw disk from the disks main tab.
*   Delete shared disk
    -   User will be able to delete a shared disk from the disks sub tab in the VMs sub tab.

#### Installation/Upgrade

*   Disk name should be calculated automatically counting on the vm name and disk number in the VM. Description will be empty.
*   New disk should enforce the user to enter a name for the disk.

#### User work-flows

The Administrator Portal should allow the following operations:

*   User will be able to view all shared raw disks from the disks main tab.
*   Regular disk can become a shared raw disk, by editing the existing disk and mark the share disk property type.
*   When removing a VM with shared raw disk attached to it, the shared disk will not be deleted.
*   If no other VMs are being attached to the shared disk then it will become floating disk.
*   Attach/Detach of shared raw disk can be performed only when the VM is in status down.
*   Shared raw disk must be formatted with raw type, and does not support OS disks (system bootable disks).

The Power User Portal should allow the following operations:

*   Attach, detach disks to VM.
*   View shared disks in the Data Center which the power user can attach/detach
*   The power user will not have permissions to create a shared disk from the user portal.

The following UI mockups contain guidelines for the different screens and wizards:

![](grid_vmvdisks.png "grid_vmvdisks.png")

![](attach_dialogue.png "attach_dialogue.png")

![](new_disk.png "new_disk.png")

### Dependencies / Related Features and Projects

Attaching shared disk will not consume new Quota resource. Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

Quota has to be taken in consideration, for every new feature that will involve consumption of resources managed by it.
Floating disk - Shared raw disk will be considered to be floating when the shared disk will not be attach to any VM.

### Documentation / External references

<http://www.ovirt.org/wiki/Features/SharedRawDisk>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/SharedRAWDisk>

### Future Work

*   Permissions should be added for disk entity

### Open Issues

[Category: Feature](Category: Feature)

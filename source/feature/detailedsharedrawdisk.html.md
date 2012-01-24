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

The shared raw disk feature should provide the ability to attach disk to many VMs with safe concurrent access,
The disk should behave as a flexible independent entity, that can be reflected as a standalone entity that is not shared between VMs(see <http://www.ovirt.org/wiki/Features/FloatingDisk>),
 or as a shared entity between multiple of VMs,. With this feature oVirt will be more compatible to support external cluster application, or shared data warehouse.

#### Entity Description

##### Disk

*   Disk should have an indication field for shared/not shared disk.
*   Disk entity will be added with three more properties: Disk Name, Description, Date created.

#### Functionality

*   The synchronization/clustering of shared disk between VMs will be managed in the file system.
*   Shared disk will become floating disk when the disk will not be attached to any VMs in the Data Center.
*   Shared disk can be moved from one VM to another.
*   Shared raw disk is configured the same as a regular disk, but with a shared flag marked as true.

#### User Experience

*   Display shared disk
    -   The shared disks will be displayed in a new 'shared disk' sub tab in the 'storage' tab.
    -   All the shared raw disk for each storage should be in the storage tab as a sub tab
*   Adding shared disk
    -   Creating/Editing a shared raw disk is available through the new/edit disk dialog from the disks sub tab in the VM main tab.
    -   User can also attach/detach shared disk through the disks sub tab of the VMs main tab, the add/edit disk dialog box will have a check box indicating the disk is shared or not.
         When a user wants to configure a regular disk to be shared disk, he will edit the disk and mark the checkbox as shared.
    -   Attach for new shared disk to a VM, will also be done from the dialog box in the VM tab under disk sub tab.
    -   User can attach/detach shared disk to VM through the VMs main tab (top action bar or right click context menu).
*   Delete shared disk
    -   User will be able to delete a shared disk from the storage domain tab in the disks sub tab.

#### Installation/Upgrade

*   Disk name should be calculated automatically counting on the vm name and disk number in the VM. the creation date should be the day of the upgrade, and the description will be "Automatically generated disk name".
*   New disk should enforce the user to enter a name and description for the disk.

#### User work-flows

The Administrator Portal should allow the following operations:

*   View all shared disk from the disks sub tab in the storage domain main tab
*   User can remove a disk entirely from the Data Center, without regarding whether there are attached VMs to it
*   A shared raw disk can also be created from regular disk, when editing existing disk and mark the disk as a shared one.
*   Each VM with shared disk attached to it, can R/W the shared RAW disk.
*   When removing a VM with shared disk attached to it, the shared disk will not be deleted and will become floating disk.
*   The shared raw disk can only be removed if all the VMs that are using it are in status down or in status up but have the disk as unplugged.
*   The user will be able the attach/detach share disk to/from a VM, only when the VM is in status down.
*   Consider that the shared disk must be formatted as raw type, and does not support OS disks (system bootable disks).

The Power User Portal should allow the following operations:

*   Attach, detach disks to VM.
*   View shared disks for storage domain in the Data Center the power user can attach/detach
*   The power user will not have permissions to create a shared disk from the user portal.

The following UI mockups contain guidelines for the different screens and wizards:

![](grid_vmvdisks.png "grid_vmvdisks.png")

![](grid_storageshared_virtual_disks.png "grid_storageshared_virtual_disks.png")

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

### Documentation / External references

<http://www.ovirt.org/wiki/Features/SharedRawDisk>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/SharedRAWDisk>

### Future Work

*   Permissions should be added for disk entity

### Open Issues

*   Floating disks presentation from the shared disks sub tab at the storage main tab.

[Category: Feature](Category: Feature)

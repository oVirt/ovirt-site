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

The shared raw disk feature enables to share disks between multiple VMs in the Data Center.

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

The shared disk feature should provide the ability to attach a disk to multiple VMs. It is the user's responsibility to make sure that the VMs do not corrupt disk data.
Users should be able to easily manage disks as standalone entities which are not shared between VMs (see <http://www.ovirt.org/wiki/Features/FloatingDisk>),
 or as entities which are shared between multiple VMs, and be able to switch between the two states. This feature will enable oVirt users to more easily run external cluster applications, or shared data warehouses on VMs.

#### Entity Description

##### Disk

*   Disk should have a field indicating whether it is shared or not.

#### Functionality

General

*   Currently only Raw disks can be shared
*   The synchronization/clustering of data access to shared disks is the responsibility of the guests. Attaching a shared disk to non-cluster aware guests will lead to corruption of the data on the disk.
*   Shared disks are attached with R/W permissions.
*   When detaching a disk from all VMs in the Data Center., the disk will become 'floating'

Attach Shared Disk

*   When attaching a shared disk to a VM, by default the disk will be logically connected to the VM but it will be 'unplugged'. To make the disk 'visible' to the guest, the user will have to explicitly 'plug' the disk.
*   Shared raw disk is configured the same as a regular disk, but with a shared flag marked as true.

Remove Shared Disk

*   The shared raw disk can only be removed once it is either unplugged from all VMs to which it is attached or these VMs are all shut down (or any combination of the two).

Copy Shared Disk

*   The shared raw disk can only be copied once it is either unplugged from all VMs to which it is attached or these VMs are all shut down (or any combination of the two).

Templates

*   When creating a template from a VM which has one or more shared disks, the shared disks will not be part of the resulting template.
*   Template disks should not be shared.
*   VM disks which are thinly provisioned, should not be referenced as shared raw disk.

Export/Import

*   When exporting a VM, only the disks which are not shared will be exported.

Move disk

*   Moving a shared raw disk is permitted only when all the attached VMs statuses are down, or all the disks which are attached to active VMs are unplugged.

Move VM

*   When moving a VM the shared raw disk should not be moved.

Snapshot

*   when taking a vm snapshot, a snapshot of the shared disk should not be taken, although it will be part of the VM snapshot configuration and the disk will appear as unplugged.

Stateless VM

*   When running stateless VM, the shared raw disk will not be handled as stateless, the user should get a warning message indicating that the disk will not be handled as stateless.

VM pools

*   Since VM from pool is stateless, The same behaviour as stateless VM should be implemented here. shared raw disk will not be stateless in a stateless VM, and a warning message will be performed.

#### User Experience

*   Display shared disk
    -   The shared disks will be displayed in the 'disks' main tab.
    -   The shared disk details tab will include the number of VMs to which it is connected.
*   Adding shared disk
    -   Creating/Editing a shared disk is available through the new/edit disk dialog from the disks sub tab in the VM main tab.
         The add/edit disk dialog box will have a check box indicating whether the disk is shared or not.
        When a user wants to configure a regular disk to be a shared disk, she will edit the disk and mark the checkbox as shared.
    -   User will also be able to attach/detach a shared disk through the disks sub tab of the VMs main tab,
    -   The administrator can attach/detach a shared raw disk from the disks main tab.
*   Delete shared disk
    -   User will be able to delete a shared disk from the disks sub tab in the VMs sub tab.

#### Installation/Upgrade

*   Disk name should be generated automatically based on the vm name and disk number in the VM. Description will be empty.
*   New disk should enforce the user to enter a name for the disk.

#### User work-flows

The Administrator Portal should allow the following operations:

*   User will be able to view all shared raw disks from the disks main tab.
*   Regular disk can become a shared raw disk, by editing the existing disk and marking the 'share disk' property type.
*   When removing a VM with shared disks attached to it, the shared disks will not be deleted.
*   If the shared disk is not attached to any other VMs then it will become a 'floating' disk.
*   Attach/Detach of a shared disk can be performed only when the VM is in status 'down'.

The Power User Portal should allow the following operations:

*   Attach/detach disks to/from a VM.
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

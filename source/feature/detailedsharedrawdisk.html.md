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

*   Shared raw disk is configured the same as a regular disk, but with a shared flag marked as true.
*   Currently only raw disks without snapshot can be shared.
*   Shared disks are attached with R/W permissions.
*   The synchronization/clustering of data access to shared disks is the responsibility of the guests. Attaching a shared disk to non-cluster aware guests will lead to corruption of the data on the disk.
*   When detaching a shared disk from all VMs in the Data Center. the disk will become 'floating'.

Attach Shared Disk

*   When attaching a shared disk to a VM, the disk will be logically connected to the VM and will be activated (hot plug VDSM command will be send), if the activation will fail the disk will become unplugged.

Remove Shared Disk

*   The shared raw disk can only be removed once it is either not activated in all the VMs which is attached to, or VMs are all shut down (or any combination of the two).

Copy Shared Disk

*   The shared raw disk can only be copied once it is either not activated in all the VMs which is attached to, or VMs are all shut down (or any combination of the two).

Templates

*   When creating a template from a VM which has one or more shared disks, the creation will fail and a message will be displayed explaining why the template cannot be created.
    The message will be as follow:

      VM ${VM_NAME} contains a shared disk. In order to make a template from this VM, either detach the shared disk from the VM or make it un-shareable by removing its "shareable" attribute.

*   Template disks should not be shared.

VM pool

*   Shared disk should not be supported with VM from pool, since VM pool is based on a template which does not support shared disk.

Export/Import

*   When exporting a VM which has one or more shared disks, the creation will fail and a message will be displayed explaining why the template cannot be created.
    The message will be as follow:

      VM ${VM_NAME} contains a shared disk. In order to export this VM, either detach the shared disk from the VM or make it un-shareable by removing its "shareable" attribute.

*   Exported disks (Whether with VMs or Templates) should not be shared.

Move disk

*   Moving a shared raw disk is permitted only when all the attached VMs statuses are down, or all the VMs which the disks are attached to are not active.

Snapshot

*   When taking a vm snapshot, a snapshot of the shared disk should not be taken, although it will be part of the VM snapshot configuration and the disk will appear as not activated.

Stateless VM

*   When running stateless VM, the shared raw disk will not be handled as stateless, the user should get a warning message indicating that the disk will not be handled as stateless.

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
*   Remove shared disk
    -   User will be able to remove a shared disk from the disks sub tab in the VMs sub tab.

#### Installation/Upgrade

*   Disk name should be generated automatically based on the vm name and disk number in the VM, as follow

<VM-name>`_`<Disk-name>`" ("`<Disk-name" = "Disk" + internal_drive_mapping) . Description will be empty. )
* New disk will present a calculated default disk name which the user can change.

=== User work-flows ===
<!-- Describe the high-level work-flows relevant to this feature. -->

The Administrator Portal should allow the following operations:

*   Search should provide the user to view all shared raw disks from the disks main tab.
*   Regular disk can become a shared raw disk, by editing the existing disk and marking the 'share disk' property type.
*   When removing a VM with shared disks attached to it, the shared disks will not be removed.
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

Quota - Same as regular disk, shared raw disk will need to be attached to quota, he will consume from. Attach and detach should not affect the quota consumption.
Floating disk - Shared raw disk will be considered to be floating when the shared disk will not be attach to any VM.
Disk permissions - Manage permissions for creating/removing/configuring shared disk.
History Data Warehouse

### Documentation / External references

<http://www.ovirt.org/wiki/Features/SharedRawDisk>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/SharedRAWDisk>

### Future Work

### Open Issues

[Category: Feature](Category: Feature)

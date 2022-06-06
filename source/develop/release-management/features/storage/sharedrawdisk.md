---
title: SharedRawDisk
category: feature
authors:
  - abaron
  - derez
  - mlipchuk
  - sandrobonazzola
---

# Shared Raw Disk

### Summary

The shared raw disk feature enables to share disks between multiple VMs in the Data Center.

### Owner

*   Feature owner: Maor Lipchuk (mlipchuk)

    * GUI Component owner: Daniel Erez (derez)

    * REST Component owner: Michael Pasternak (mpasternak)

    * Engine Component owner: Maor Lipchuk (mlipchuk)

    * QA Owner: Yaniv Kaul (ykaul)


### Detailed Description

The shared disk feature should provide the ability to attach a disk to multiple VMs. It is the user's responsibility to make sure that the VMs do not corrupt disk data.
Users should be able to easily manage disks as standalone entities which are not shared between VMs
(see [Features/FloatingDisk](/develop/release-management/features/storage/floatingdisk.html)),
 or as entities which are shared between multiple VMs, and be able to switch between the two states. This feature will enable oVirt users to more easily run external cluster applications, or shared data warehouses on VMs.

#### Entity Description

##### Disk

*   Disk should have a field indicating whether it is shareable or not.

#### Functionality

General

*   Shareable raw disk is configured the same as a regular disk, but with a shareable flag will be marked as true.
*   Currently only raw disks without snapshot can be shareable.
*   Shareable disks are attached with R/W permissions.
*   The synchronization/clustering of data access to shareable disks is the responsibility of the guests. Attaching a shareable disk to non-cluster aware guests will lead to corruption of the data on the disk.
*   When detaching a shareable disk from all VMs in the Data Center. the disk will become 'floating'.

Attach Shareable Disk

*   When attaching a shareable disk to a VM, the disk will be logically connected to the VM and will be activated (hot plug VDSM command will be send), if the activation will fail the disk not be activated.

Remove Shareable Disk

*   User can remove the shareable raw disk entirely from the setup, whether the disk is inactive in all the VMs which are attached to it, or all the VMs which the disk attached to, are in status down (or any combination of the two).
     When disk will be removed a warning message should display the user the following message :

      Removing the shareable disk will remove it from all the VMs which are associated with it.

Remove VM

*   When VM will be removed the shareable disk will be detached from the VM.

Templates

*   When creating a template from a VM which has one or more shareable disks, the creation will of the template will be without the shareable disk.
*   Template disks should not be shareable.

VM pool

*   Shareable disk should not be supported with VM from pool, since VM pool is based on a template which does not support shareable disk.

Export/Import

*   When exporting a VM which has one or more shareable disks, the VM will be exported without its shareable disks.
*   Exported disks (Whether with VMs or Templates) should not be shareable.

Move disk

*   Moving a shareable disk is permitted only when all the attached VMs statuses are down, or all the VMs which the disks are attached to are inactive.

Snapshot

*   When taking a vm snapshot, a snapshot of the shareable disk should not be taken and should not be part of the VM snapshot configuration.

Stateless VM

*   When running stateless VM, the shareable raw disk will not be handled as stateless, the user should get a warning message indicating that the disk will not be handled as stateless.

#### User Experience

*   Display shareable disk
    -   The shareable disks will be displayed in the 'disks' main tab.
    -   The shareable disk details tab will include the number of VMs to which it is connected.
*   Adding shareable disk
    -   Creating/Editing a shareable disk is available through the new/edit disk dialog from the disks sub tab in the VM main tab.
         The add/edit disk dialog box will have a check box indicating whether the disk is shareable or not.
        When a user wants to configure a regular disk to be a shareable disk, he will edit the disk and mark the checkbox as shareable.
    -   User will also be able to attach/detach a shareable disk through the disks sub tab of the VMs main tab,
*   Remove shareable disk
    -   User will be able to remove a shareable disk from the disks main tab.
    -   When user will try to remove a shareable disk which is attached to only one VM from the disks sub tab, the user will be able to choose whether to remove the disk permanently from the storage or only detach it from the VM.
    -   When user will try to remove a shareable disk which is attached to more then one VM from the disks sub tab, the disk should only be detached from the VM, and not removed permanently.

#### API

*   User can set a disk to be shareable or not through the API, by setting the shareable property in the disk entity appropriately.
*   Shareable disk entity should provide a list of VMs which the disk is associated with (Will be provided soon as disk root rest implementation will be provided).

#### Installation/Upgrade

*   Disk name should be generated automatically based on the vm name and disk number in the VM, as follow:
`<VM-name>_<Disk-name>` ("<Disk-name" = "Disk" + internal_drive_mapping) . Description will be empty. 

* New disk will present a calculated default disk name which the user can change.

=== User work-flows ===

The Administrator Portal should allow the following operations:

*   Search should provide the user to view all sharebale raw disks from the disks main tab.
*   Regular disk can become a shareable raw disk, by editing the existing disk and marking the 'shareable' property type.
*   When removing a VM with shareable disks attached to it, the shareable disks will not be removed.
*   If the shareable disk is not attached to any other VMs then it will become a 'floating' disk.
*   Attach/Detach of a shareable disk can be performed only when the VM is in status 'down'.

The Power User Portal should allow the following operations:

*   Attach/detach disks to/from a VM.
*   View shareable disks in the Data Center which the power user can attach/detach
*   The power user will not have permissions to create a shareable disk from the user portal.

The following UI mockups contain guidelines for the different screens and wizards:

![](/images/wiki/Grid_vmvdisks.png)

![](/images/wiki/Attach_dialogue.png)

![](/images/wiki/New_disk.png)

### Dependencies / Related Features and Projects

Attaching shareable disk will not consume new Quota resource. Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal
*   History Data Warehouse
*   VDSM

Quota has to be taken in consideration, for every new feature that will involve consumption of resources managed by it.

*   Quota - Same as regular disk, shareable raw disk will need to be attached to quota, he will consume from. Attach and detach should not affect the quota consumption.
*   Floating Disk - Shareable raw disk will be considered to be floating when the shareable disk will not be attach to any VM.
*   Disk Permissions - Manage permissions for creating/removing/configuring shareable disk.

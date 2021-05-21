---
title: DetailedFloatingDisk
category: feature
authors:
  - derez
  - mlipchuk
---

# Detailed Floating Disk

## Floating Disk

### Summary

Floating disk - a disk that is not attached to any VM.
This feature covers the management and usage of disks in floating state.

### Owner

*   Feature owner: Daniel Erez (derez)

    * GUI Component owner: Daniel Erez (derez)

    * REST Component owner: Michael Pasternak (mpasternak)

    * Engine Component owner: Maor Lipchuk (mlipchuk)

    * QA Owner: Yaniv Kaul (ykaul)

*   Email: derez@redhat.com

### Current status

*   Target Release:
*   Status: Released
*   Last updated date: Sun January 25 2011

### Detailed Description

The feature introduces a significant improvement to oVirt compatibility and flexabilty regarding disks usage. It provides administration and management functionalities for floating disks.
A floating disk should behave as a flexible independent entity that can be attached to any VM. Any virtual disk can be in a floating state - by unattaching the disk from the VM/s.
Supporting a floating state for disks is essential to derived features (e.g. 'Shared RAW Disk' and 'Direct LUN Disk') and dependent implementations (e.g. application clustering, shared data warehouse).

#### Entity Description

##### Disk

*   Floating state should be added to disk entity - floating / not floating.
*   Name and Description should be added to disk entity.
*   Disk must be a searchable entity for providing search/sort/display capabilities under 'Virtual Disks' main tab.
*   Open issue: adding an indication whether the disk is originated from a VM or a template (useful for filtering 'Virtual Disks' sub-tabs).

#### Functionality

*   A floating disk can be attached to any VM (or multiple VMs in case of a Shared Disk).
*   Detaching a disk from a VM will result in a floating disk creation (i.e. the disk's state will be updated to 'floating').
*   A disk that is based on a thinly provisioned template can't be detached (i.e. 'floating' is not applicable state for it).
*   A floating disk can be moved between storage domains.
*   Export/Import - currently not supported.

#### Installation/Upgrade

*   Installation
    -   New/Edit disk:
        -   Should enforce the user to enter a unique (in VM context) name.
        -   New optional field - Description.
*   Upgrade
    -   Disk description should remain empty.

#### User Experience

##### Administrator Portal

*   CRUD - Introducing a new 'Virtual Disks' main tab
    -   Contains a list of all the disks in the system (except templates disk) - sortable/searchable by Floating/Shared/Managed attributes.
    -   Actions - at first stage, only a few actions will be included (first subset will probably include 'Remove Disk')
    -   Includes the following sub-tabs:
        -   General
            -   Additional info on the selected Disk (type/interface/etc).
        -   Virtual Machines (visible for disks that reside in VMs):
            -   List of Virtual Machines to which the selected Disk is attached.
            -   Actions:
                -   Attach - dialog with a list of available VMs.
                -   Detach - detaches the selected Disk from the selected VM.
    -   Each row is composed of the following columns:

      VM, Name, Storage Domain, Description, Size, Actual Size, Allocation,Creation Date, Floating(Yes/No), Shared(Yes/No), Managed(Yes/No). 

*   VMs -> Disks sub-tab
    -   Attach/Detach all shared and/or floating disks.
    -   Edit/Remove disks (need to warn user in case disk is attached to more VMs).
    -   Move disks between storage domains.
*   Open Issue: Tree
    -   'Resources' link under 'Storage' node - invokes a search of all the Floating/Shared disks in the Data Center.
    -   'Free Disks' link under a new 'Resources' node - invokes a search of all the Floating/Shared non-managed (i.e. direct-luns) disks.

##### User Portal

The Power User Portal should allow the following operations:

*   Attach/Detach only floating disks to a VM (through disks sub-tab).

       Note:
        For now, premissions for disk entities will *not* be supported.
        Consequently, availabilty of disks will be deterimined by their type (i.e. users can attach only floating disks).

#### Search

Search of disks should retrieve the following fields:

*   VM Name (For floating will return detached)
*   Disk Name
*   Description
*   Size
*   Actual Size
*   Creation Date
*   Bootable (True / False)
*   Shared (True / False)
*   quota name?
*   quota id?

Should consider adding the optional fields:

*   Direct LUN?
*   Interface?
*   Allocation?

The return value should be sorted by VM Name and Disk Name.
Search auto completion will be supporting the following properties:

*   Disk name
*   VM name
*   bootable by searching for bootable = true
*   shared by searching for shared = true
*   floating disks by searching for floating = true

##### Mockups

The following UI mockups contain guidelines for the different screens and wizards:

![](/images/wiki/VirtualDisks_MainTab_VMs.png)

![](/images/wiki/VirtualDisks_MainTab_General.png)

![](/images/wiki/Attach_disk_maintab_dialogue.png)

![](/images/wiki/disks_subtab.png)

![](/images/wiki/Disks_subtab_attach_disk_dialogue.png)

### Engine

*   Add disk
    -   When adding a disk, the vm id should be optional, if the id of the VM is provided and the VM is down then the disk should be attached(plugged) to the VM, but if the vm is up, the operation should be blocked.
    -   The disk should be locked when adding it, until the create process is ended in VDSM.

<!-- -->

*   Remove Disk
    -   When removing a disk, the disk should be locked.

<!-- -->

*   Activate/Deactivate disk
    -   Disk should not be locked when activate deactivate a disk same for attach detach

<!-- -->

*   move/copy
    -   Currently floating disk should not be moved.
    -   Disk should be locked while move or copy.

### Dependencies / Related Features and Projects

Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

Quota should be taken into consideration for every new feature that involves consumption of resources.
Shared raw disk will be dependent on floating disk.

### Documentation / External references

[Features/FloatingDisk](/develop/release-management/features/storage/floatingdisk.html)



### Future Work

*   Consider adding permissions support to disks entities.
*   Adding templates disks to main tab.

### Open Issues

*   Detaching a disk with a snapshot history: blocked to the user or collapsing and marking the snapshot as broken ?
*   Disks main tab -> VMs sub-tab - should it include Plugged/UnPlugged status column ?
*   Permissions for actions on disks - who is permitted to invoke: Attach/Detach/Edit/Delete/Move ?
*   More actions should be added to Disks main tab: New/Edit/Remove/Move/etc.

[Category: Feature](Category: Feature)

---
title: DetailedFloatingDisk
category: feature
authors: derez, mlipchuk
wiki_category: Feature
wiki_title: Features/DetailedFloatingDisk
wiki_revision_count: 35
wiki_last_updated: 2014-07-13
wiki_warnings: list-item?
---

# Detailed Floating Disk

## Floating Disk

### Summary

Floating disk - a disk that is not attached to any VM.
This feature covers the management and usage of disks in floating state.

### Owner

*   Feature owner: [ Daniel Erez](User:derez)

    * GUI Component owner: [ Daniel Erez](User:derez)

    * REST Component owner: [ Michael Pasternak](User:mpasternak)

    * Engine Component owner: [ Maor Lipchuk](User:mlipchuk)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: derez@redhat.com

### Current status

*   Target Release:
*   Status: Design Stage
*   Last updated date: Sun January 25 2011

### Detailed Description

The feature introduces a significant improvement to oVirt compatibility and flexabilty regarding disks usage. It provides administration and management functionalities for floating disks.
A floating disk should behave as a flexible independent entity that can be attached to any VM. Any virtual disk can be in a floating state - by unattaching the disk from the VM/s.
Supporting a floating state for disks is essential to derived features (e.g. 'Shared RAW Disk' and 'Direct LUN Disk') and dependent implementations (e.g. application clustering, shared data warehouse).

#### Entity Description

##### Disk

*   Floating state should be added to disk entity - floating / not floating.
*   Name and Description should be added to disk entity (disk name ought to be unique for search and display purposes).
*   Disk must be a searchable entity for providing search/sort/display capabilities under 'Virtual Disks' main tab.
*   Open issue: adding an indication whether the disk is originated from a VM or a template (useful for filtering 'Virtual Disks' sub-tabs).

#### Functionality

*   A floating disk can be attached to any VM (or multiple VMs in case of a Shared Disk).
*   Detaching a disk from a VM will result in a floating disk creation (i.e. the disk's state will be updated to 'floating').
*   A floating disk can be moved between storage domains.
*   Export/Import - not supported.

#### Installation/Upgrade

*   Installation
    -   New/Edit disk:
        -   Should enforce the user to enter a unique name.
        -   New optional field - Description.
*   Upgrade
    -   Disk name should be generated automatically - in order to maintain uniqueness.
    -   Disk description should remain empty.

#### User Experience

##### Administrator Portal

*   CRUD - Introducing a new 'Virtual Disks' main tab
    -   Contains a list of all the disks in the system - sortable by Floating/Shared/Managed attributes.
    -   Actions - at first stage, only a few actions will be included (first subset will probably include 'Remove Disk')
    -   Includes the following sub-tabs.
        -   Storage:
            -   List of Storage Domains in which the selected Disk resides.
        -   Templates (visible for disks that reside in templates):
            -   List of Templates to which the selected Disk is attached.
        -   Virtual Machines (visible for disks that reside in VMs):
            -   List of Virtual Machines to which the selected Disk is attached.
            -   Should include Plugged/UnPlugged status column.
            -   Actions:
                -   Attach - dialog with a list of available VMs (all VMs with 'Down' status within the disk's Data Center).
                -   Detach - detaches the selected Disk from the selected VM.
    -   Each row is composed of the following columns:

      Name (unique), Description, Size, Actual Size, Type, Allocation, Interface, Creation Date, Floating(Yes/No), Shared(Yes/No), Managed(Yes/No). 

*   VMs -> Disks sub-tab
    -   Attach/Detach disks.
    -   Edit/Remove disks.
    -   Move disks between storage domains.
*   Open Issue - Tree
    -   'Resources' link under 'Storage' node - invokes a search of all the Floating/Shared disks in the Data Center.
    -   'Free Disks' link under a new 'Resources' node - invokes a search of all the Floating/Shared/DirectLUN disks in the Data Center.

##### User Portal

The Power User Portal should allow the following operations:

*   Attach/Detach only managed shared disks to a VM (through disks sub-tab).

       Note:
        For now, premissions for disk entities will *not* be supported.
        Consequently, availabilty of disks will be deterimined by their type (i.e. users can attach only shared disks).

##### Mockups

The following UI mockups contain guidelines for the different screens and wizards:

![](virtualDisks_MainTab.png "virtualDisks_MainTab.png")

![](attach_disk_maintab_dialogue.png "attach_disk_maintab_dialogue.png")

![](disks_subtab.png "disks_subtab.png")

![](disks_subtab_attach_disk_dialogue.png "disks_subtab_attach_disk_dialogue.png")

### Dependencies / Related Features and Projects

Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

Quota should be taken into consideration for every new feature that involves consumption of resources.
Shared raw disk will be dependent on floating disk.BR>

### Documentation / External references

<http://www.ovirt.org/wiki/Features/FloatingDisk>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/FloatingDisk>

### Future Work

*   More actions should be added to Disks main tab: New/Edit/Remove/Move/Copy/etc.
*   Consider adding permissions support to disks entities.

### Open Issues

[Category: Feature](Category: Feature)

---
title: ImportMoreThanOnce
category: feature
authors: derez, ekohl, gchaplik
wiki_category: Feature
wiki_title: Features/ImportMoreThanOnce
wiki_revision_count: 16
wiki_last_updated: 2014-07-13
wiki_warnings: list-item?
---

# Import VM or Template More than Once Feature

### Owner

*   Name: [ Gilad Chaplik](User:gchaplik)
*   Email: <gchaplik@redhat.com>

### Summary

Adding the functionality to import VMs and Templates that are already exist in setup, in fact this feature consist of changing the identifiers of a imported VM.

### Current status

*   Design Stage
*   Last updated date: Sun Feb Wed Nov 19 2012

#### Affected oVirt projects:

*   Core
*   Webadmin
*   API/CLI

### Design

note: unless specified 'entity' may refer both to VM and Template oVirt Entities.

#### Core:

*   Add to ImportEntityParameter parameter class boolean member that indicates whether this entity should be cloned, the default value is false.
*   Alter ImportEntityCommand in case clone parameter field is set to true:

    * Set the VM with a new identifier (the new name already placed in the vm - concat of vm and suffix).

    * Set the disks target with a new identifier.

    * For all VM's nics, allocate new MAC address.

    * (in import VM) Collape all snapshots must be true.

*   detailed design will be added in the near future.

#### webadmin

Only the ImportEntity dialog will be affected:

*   Add 'Already Exists in Setup' column to import entity dialog:

    * Run multiple queries for get_entity_by_id to check wheater the imported entities exists in the setup.

*   Add 'clone all entities' check box to Import Entity Dialog

    * (in import VM) In case it's checked the 'collapse all snapshots' checkbox should be checked and disabled.

    * In case it's checked a suffix textbox should be added (the suffix will be added to all VMs names).

*   Add 'clone only existing entities' check box to Import Entity Dialog:

    * (in import VM) In case it's checked a label will be shown to user that marks that the cloned VMs snapshots will be collapsed.

    * In case it's checked a suffix textbox should be added (the suffix will be added to all VMs names).

    * If 'clone all entities' is checked 'clone only existing entities' will be checked and disabled.

##### mockups

![](Clonedimport.png "Clonedimport.png")

#### CLI/API

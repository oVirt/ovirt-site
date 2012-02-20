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

Adding the functionality to import VMs and Templates that already exist in setup, in fact this feature consists of changing the identifiers of an imported VM/Template.

### Current status

*   Design Stage
*   Last updated date: Mon Feb 20 2012

#### Affected oVirt projects:

*   Core
*   Webadmin
*   API/CLI

### Design

note: unless specified 'entity' may refer both to VM and Template oVirt Entities.

#### Core

*   Add to ImportEntityParameter parameter class boolean member that indicates whether this entity should be cloned, the default value is false.
*   Alter ImportEntityCommand in case clone parameter field is set to true:

    * Set the VM with a new identifier (the new name already placed in the vm - concat of vm and suffix, see webadmin).

    * Set the disks target with a new identifier.

    * For all VM's NICs, allocate new MAC addresses.

    * (in import VM) Collape all snapshots must be 'true'.

*   detailed design will be added in the near future.

#### webadmin

Only the ImportEntity dialog will be affected:

*   Add 'Already Exists in Setup' column to import entity dialog:

    * Run multiple queries for get_entity_by_id to check whether the imported entities exist in the setup.

*   Add 'clone all entities' check box to Import Entity Dialog

    * In case checked:

        * (in import VM) The 'collapse all snapshots' checkbox should be checked and disabled.

        * A suffix textbox should be added (the suffix will be added to all VMs' names).

*   Add 'clone only existing entities' check box to Import Entity Dialog:

    * In case checked:

        * (in import VM) A label will be shown to user that indicates that the cloned VMs' snapshots will be collapsed.

        * A suffix textbox should be added (the suffix will be added to all VMs names).

    * If 'clone all entities' is checked, 'clone only existing entities' will be checked and disabled.

*   the suffix text box will be shown only when one of the above check-boxes is checked (it is relevant only for importing an entity as clone).

##### mockups

note: the following mockups are of ImportVM, in ImportTemplate the 'Collapse Snapshot' check box is hidden, and also any label that is relevant to it.

*   in case no entity exists in the system, this is the default view of the dialog:

![](Nothing_selected.png "Nothing_selected.png")

*   in case one of the entities already exists- the duplicate check box will be shown. its default is 'true':

![](Only_dup_selected.png "Only_dup_selected.png")

*   when selecting 'clone all' the duplicate check box (if shown) will be check and disabled:

![](Clone_all_selected.png "Clone_all_selected.png")

#### CLI/API

Adding 'clone' parameter (not madnatory) and then getting it from Action.java in BackendStorageDomainVmResource-->doImport(), then setting in ImportVmParameters and before sending to Backend (if it's null, this means false).

For import VM:

`   `[`http://localhost:8080/api/storagedomains/19290426-6681-479b-bd8e-76b54d1b1489/vms/we958723498579234/import`](http://localhost:8080/api/storagedomains/19290426-6681-479b-bd8e-76b54d1b1489/vms/we958723498579234/import)
         
`   `<action>
`      `<cluster id="afsdasdf"/>
`      `<storage_domain id="5@#$^234634^"/>
            `<clone>`true`</clone>`     //This is the new value
         `</action>` 

Same for template in: BackendStorageDomainTemplateResource

And finally, add in RSDL (rsdl_metadata_v-3.1.yaml): optionalArguments: {action.clone: 'xs:boolean'} (for both VM and Template import command)

*   SDK and CLI should be automatically updated, as they are auto-generated from REST-API.

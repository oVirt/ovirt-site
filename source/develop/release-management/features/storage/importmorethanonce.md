---
title: ImportMoreThanOnce
category: feature
authors: derez, ekohl, gchaplik
feature_name: Import VM or Template More than Once
feature_modules: engine
feature_status: Released
---

# Import VM or Template More than Once Feature

## Owner

*   Name: Gilad Chaplik (gchaplik)

## Summary

Adding the functionality to import VMs and Templates that already exist in setup, in fact this feature consists of changing the identifiers of an imported VM/Template.

### Current status

*   Merged to upstream: vm & template- gui & backend.
*   Development Stage: REST for both.
*   Last updated date: Fri May 18 2012.

### Affected oVirt projects:

*   Core
*   Webadmin
*   API/CLI

### Limitations

*   Cannot import VM without collapsing its snapshots.

## Design

note: unless specified 'entity' may refer both to VM and Template oVirt Entities.

### webadmin

Only the ImportEntity dialog will be affected:

*   Add 'Already Exists in Setup' column to import entity dialog:

    * Run one search query for all vms (by id) to check whether the imported entities exist in the setup (if search is not supported to id, I will implement it).

*   Add 'clone all entities' check box to Import Entity Dialog

    * In case checked:

        * (in import VM) The 'collapse all snapshots' checkbox should be checked and disabled.

        * A suffix textbox should be added (the suffix will be added to all VMs' names).

*   Add 'clone only existing entities' check box to Import Entity Dialog:

    * In case checked:

        * (in import VM) A label will be shown to user that indicates that the cloned VMs' snapshots will be collapsed.

        * A suffix textbox should be added (the suffix will be added to all VMs names).

    * If 'clone all entities' is checked, 'clone only existing entities' will be checked and disabled.

*   Needs high level (user level) summary. For example, what does it mean that a VM already exist in the setup? If I had a VM with 10GB

disk, without an OS installed, then exported it, then installed an OS into it now the disk is a bit full, as opposed to the emptied exported one). Does it means that an identical entity already exist in the setup or not? (think of overwriting files).

*   the suffix text box will be shown only when one of the above check-boxes is checked (it is relevant only for importing an entity as clone).

#### mockups

note: the following mockups are of ImportVM, in ImportTemplate the 'Collapse Snapshot' check box is hidden, and also any label that is relevant to it.

*   in case no entity exists in the system, this is the default view of the dialog:

![](/images/wiki/Nothing_selected.png)

*   in case one of the entities already exists- the duplicate check box will be shown. its default is 'true':

![](/images/wiki/Only_dup_selected.png)

*   when selecting 'clone all' the duplicate check box (if shown) will be check and disabled:

![](/images/wiki/Clone_all_selected.png)

### Engine

*   Add to ImportEntityParameter parameter class boolean member, named importAsNewEntity, that indicates whether this entity should be cloned, the default value is false.
*   Alter ImportEntityCommand in case importAsNewEntity parameter field is set to true:

    * Set the VM with a new identifier (the new name already placed in the vm - concat of vm and suffix, see webadmin).

    * Set the disks target with a new identifier.

    * For all VM's NICs, allocate new MAC addresses.

    * (in import VM) Collape all snapshots must be 'true'.

*   detailed design will be added in the near future.

### CLI/API

Adding 'importAsNewEntity' parameter (not madnatory) and then getting it from Action.java in BackendStorageDomainVmResource-->doImport(), then setting in ImportVmParameters and before sending to Backend (if it's null, this means false).

For import VM:

`http://localhost:8080/api/storagedomains/your_storage_domain_id/vms/your_vm_id/import`


```xml
<action>
  <cluster id="afsdasdf"/>
  <storage_domain id="111111111"/>
  <importAsNewEntity>true`/importAsNewEntity>   //This is the new value
  <vm>
    <name>new_name</name>
  </vm>
</action>
```

Same for template in: BackendStorageDomainTemplateResource

And finally, add in RSDL (rsdl_metadata_v-3.1.yaml): optionalArguments: {action.importAsNewEntity: 'xs:boolean'} (for both VM and Template import command)

*   SDK and CLI should be automatically updated, as they are auto-generated from REST-API.


---
title: Multiple storage domains
category: feature
authors: derez, jumper45, mkublin
---

# Design for multiple storage domains

### Multiple Storage Domains

## User Stories

*   **Add VM** - As a RHEV-M user, when I create a VM using the GUI/REST API, I want to be able to select different storage domains for each disk in the VM so that I can make efficient use of my storage. I know the feature works when I can create a VM with 3 disks each on different storage domains.
*   **Import VM** - As a RHEV-M user, when I import a VM using the GUI/REST API, I want to be able to select different storage domains for each disk in the VM so that I can make efficient use of my storage. I know the feature works when I can import a VM with 3 disks each on different storage domains.
*   **Add Disk to VM** - As a RHEV-M user, when I add a disk to a VM using the GUI/REST API, I can select which storage domain to associate with it so that I can make more efficient use of my storage. I know the feature works when I can add a disk to a VM and put it on a storage domain not already in use by the VM.
*   **Import VM template** - As a RHEV-M user, when I import a VM template using the GUI/REST API, I want to be able to select different storage domains for each disk in the template so that I can make efficient use of my storage. I know the feature works when I can import a template with 3 disks each on different storage domains.
*   **Move Disk** - As a RHEV-M user, I want to be able to use the GUI/REST API to move a disk from one storage domain to another so that I can make efficient use of my storage. I know the feature works when I can move a disk to an existing storage domain not already in use by the VM.
*   **Create VM from template** - As a RHEV-M user, I want to be able to use the GUI/REST API to create a VM from a template and be able to specify on which storage domain each disk should be created. I know the feature works when I can create a VM from a template that has 3 disks and I can put each disk on a separate storage domain.
*   **Create Template from VM** - As a RHEV-M user, I want to be able to use the GUI/REST API to create a template from a VM and be able to specify which storage domain should hold its disks. I know the feature works when I can create a template on a different storage domain than the one the VM resides on.
*   **Clone Template** - As a RHEV-M user, I want to be able to use the GUI/REST API to clone a template and be able to specify which storage domain should hold its disks. I know the feature works when I can clone a template on a different storage domain than the one the source template resides on.

## Acceptance Tests

Will be based on the "I know the feature works..." in the user stories.

### Additional functionality to verify

*   create snapshots
*   delete disk
*   delete VM
*   start VM
*   hibernate VM

## Overall design

The main change that needs to happen is to have each image associated with its own storage domain.

### GUI

#### General Changes

##### Virtual Machines Tab

*   The Virtual Disks tab need to have a Storage Domain column added

##### Storage Tab

*   The Virtual Machines tab need to have some columns removed
*   There needs to be a new tab for Virtual Disks so that users can view which disks are on which domains.

#### Workflow Changes

*   Add a VM
*   Import a VM
*   Add Disk to VM
*   Import VM Template
*   Move Disk
*   Create VM from Template
*   Create template from VM
*   Clone template

##### User Experience

The following UI mockups contain guidelines for the different screens and wizards:

![](/images/wiki/VM_from_template_single.png)

![](/images/wiki/VM_from_template_multi.png)

![](/images/wiki/import_vm_single.png)

![](/images/wiki/import_vm_multi.png)

![](/images/wiki/import_template_single.png)

![](/images/wiki/import_template_multi.png)

![](/images/wiki/disks_subtab.png)

![](/images/wiki/new_move_disk_dialog.png)

![](/images/wiki/storage_vms_subtab.png)

![](/images/wiki/new_template.png)

![](/images/wiki/templates_storage_subtab.png)

![](/images/wiki/templates_vms_subtab.png)

### REST Design (Modeling)

This section describes the REST design for this feature.

*   Add a VM
*   Import a VM
*   Add Disk to VM
*   Import VM Template
*   Move Disk
*   Create VM from Template
*   Create template from VM
*   Clone template

The changes will be done at java code, by processing passed parameters from client

### Backend

There should not be any changes to the database or the object model to support this feature. Many of the command classes will need their logic changes to handle processing each disk individually by their storage domain instead of handling them all at once.

## VDSM

Vdsm already supports this feature; it has no limitation on the location of disk images. Any storage domain for any VM disk will do.

## Open Issues

1.  Need to consider negative cases when some storage domains fail, etc.
2.  Need to determine which flows will need additional transactionality due to multiple storage domains.
3.  Need to figure out how hibernation will work

## Known Issues / Risks

Being developed in parallel with quotas. Can't anticipate changes needed to work with quotas.

## Needed documentation

The docs will need to be updated with new screenshots showing adding a disk to a VM and selecting the storage domain there.


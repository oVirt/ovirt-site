---
title: Edit Running VM
authors: ofrenkel
---

# Edit Running Vm

## Summary

We would like to have ability to edit VM configuration, even while it is running.
Today, updating running vm is not clear:
Updating some fields is allowed, and makes sense (applied immediately):

* description
* comment
* HA
* ...

Updating some fields is blocked, since some of the configuration values are not applicable when the vm is running:

* memory
* monitors
* usb-policy
* ...

Updating some fields is allowed, but might be confusing, as it will be applied only on next run:

* cd-rom - does not perform live change-cd in the machine
* boot sequence - if rebooting the guest (not stop+start) the order will not change
* guaranteed memory - will only be applied on next run
* ...

## Owner

* Name: Omer Frenkel
* Email: ofrenkel@redhat.com

## Current Status

* Status: Design
* Target release: 3.5
* updated: March 3rd, 2014

## Detailed Description

This feature will allow updating vm configuration on any vm status except 'Locked'.

* Changes that doesn't affect the run of the vm, will be editable as today (for example: name, description, comment..)

* If change is not immediately applicable (memory, boot sequence), a warning will be displayed to the user (UI only), notifying him changes will be applied only on next run.

* If change affect running vm, and require special operation (like hot-plug cpu), the user could select if to apply immediately or only on the next run.

All vm configuration, as it is returned to the user today (using search and queries, -> what is shown in the vm main tab) will always be the current configuration.
If there is a different configuration for the next run for a vm, an icon will appear next to the VM in the grid the detailed configuration would appear in the 'edit vm' dialog.

## Implementation

### Backend
if vm is edited, and is not in down state, all changes that can be applied immediately will be saved to the vm_static table (and to 'running' snapshot if exists).

if there are other changes, create/update a special 'running' snapshot with all information.

when vm goes down, if 'running' snapshot exists, apply the configuration to the vm_static table.

### DB
Add to VM object and view an indicator if a 'running' snapshot exists, for UI and REST use.

### UI
On Edit Vm, if 'running' snapshot exists, load it to the edit dialog.

Show warning to the user if anything changed that require restart.

Allow the user to choose if to apply now changes that can be applied.

![](/images/wiki/Edit_running_vm.png)

On VM main grid, add an icon notifying there is a running configuration for each vm with this field true.

### REST API
Add corresponding element for vm to notify for each vm if there is a running configuration for it.

Add a URL-parameter, 'next_run', to get vm, in order to be able to get the 'running' configuration for a VM,
and also in update vm, to allow the user to decide if to apply changes now for applicable changes.

Usage:
 `http://<server>/ovirt-engine/api/vms/vm_id;next_run`

## Open Issues

*   what about changing cd rom ? will it do live change cd, or like today?

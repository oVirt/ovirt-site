---
title: DiskPermissions
category: feature
authors:
  - amureini
  - derez
  - lpeer
  - moti
  - ofrenkel
  - smelamud
---

# Disk Permissions

## Summary

The Disk Permissions feature is supplementary for Disk related features (Floating Disk, Shared Raw Disk, Direct LUN). It enables permissions management on a Disk.

## Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

## Design

Disk inherits permissions from the VM it is attached to and from the storage domain it resides on (if there is one)
When granting a user 'Create VM' permission, the user will be able to create a VM without creating Disks.
Creating disks requires specific permissions for that, on the storage domain or the storage pool.
Add permissions command will support adding permissions which are already existing in the system without failing the command in can-do-action as done today.
It will serve the client when the user decide not to use permissions nor quota for Disk creation.
When disk is created, 'DISK_OPERATOR' role is given to the user which created the Disk.
When creating VM from template, the user should get VM_OPERATOR permissions for the VM (as is now) and DISK_OPERATOR for the VM Disks.

### Disk Permissions and Quota

When Quota is enabled, Disk consumption will be enforced by the Quota, regardless the user's permissions on the Storage entities.
When Quota is disabled for the Data Center, User must have permissions on Storage domain for disk operations requiring quota(create/move).
Therefore when Quota is set as disabled for the Data Center, the GUI will suggest to add DISK_CREATOR permissions on the relevant storage domains to everyone.
 The following section describes permissions for Disk entities.

### Disk Actions

Required permissions for Disk related actions:

*   Create disk - requires permissions on the Storage Domain.
*   Attach disk to VM - requires permissions on the Disk and on the VM (applies for shared disk as well).
*   Detach disk from VM - requires permissions on the VM only. (Unlike attach disk that requires permissions on the VM and on the Disk).
*   Activate/Deactivate disk on VM (also Hot Plug) - requires permission on the VM.
*   Remove disk (from Disk tab)- permissions on the Disk.
*   Update disk - permissions on the Disk.
*   Move or copy disk - requires permissions on the Disk and on the target Storage Domain.
*   Add disk to VM - requires both permissions on the VM and on the storage domain (same as adding disk and attaching to VM).
    -   Create - on storage domain
    -   Attach - on disk and VM
    -   Activate - on VM
*   Remove VM - we'll extend the command to support either deleting disks from the system (the current behavior) or only detach the disks, permissions goes as follows:
    -   If disks are marked for deletion - requires permissions on the removed Disks and on the VM.
    -   If disks aren't marked for deletion - the disks are detached, therefore no permissions required for the Disk, only for removing VM.

### Roles

#### New Action Groups for Disk Object Type

       CREATE_DISK - AddDisk, AddDiskToVm
       EDIT_DISK_PROPERTIES - UpdateDisk, UpdateVM, Activate/Deactivate
       ATTACH_DISK - AttachDiskToVm
       CONFIGURE_DISK_STORAGE - MoveOrCopyDisk
       DELETE_DISK - RemoveDisk, RemoveVm

#### New Roles

New predefined user role for disks **DISK_OPERATOR** will be given to user when creating a Disk (either from Disk tab or from VM's disk sub-tab).
DISK_OPERATOR will be associated with the following action groups: CREATE_DISK, EDIT_DISK_PROPERTIES, ATTACH_DISK, CONFIGURE_DISK_STORAGE and DELETE_DISK.

` Add new role to `*`PredefinedRoles.java`*
       Add new upgrade script for new roles and updating existing roles.

#### Updated Roles

SuperUser, ENGINEPowerUser, ClusterAdmin, DataCenterAdmin, StorageAdmin and VmOperator should be extended with action groups of Disks (CREATE_DISK, EDIT_DISK_PROPERTIES, ATTACH_DISK, DELETE_DISK).
Currently attach/detach is being executed as part of the UpdateVm action.

       Existing roles are Update by upgrade script.
       Extend `*`VdcObjectType`*` with Disk.

### DB Changes

       Modify create_functions.sql:
       Add support for Disk to `*`fn_get_entity_parents`*` stored-procedure.
       Add support for Disk to `*`fn_get_entity_name`*` stored-procedure.

### Upgrade DB

DB Upgrade should handle the following:

*   Add "Disk Operator" actions to the following predefined roles:
    -   SuperUser, ENGINEPowerUser, ClusterAdmin, DataCenterAdmin, VmOperator and StorageAdmin.

<!-- -->

*   Add "Disk Operator" permissions on the relevant Disks to:
    -   "VM Operator" users (applies to users with permissions on \*VM\* with \*Disks\* attached to it).

<!-- -->

*   Permissions will be given on storage domains to users with CREATE_VM action group for the storage domains where the VM disks reside on (DISK_CREATOR role).
    -   CREATE_VM on Cluster will allow creating Disks on the Storage Domains of the Data Center which the Cluster belongs to.
    -   CREATE_VM on Data Center will allow creating Disks on the Storage Domains of the Data Center.
    -   CREATE_VM on System will allow creating Disks on all Storage Domains in the System.

### UI Changes

Add Permissions sub-tab under Disks main tab
Add Disk Operator role to Roles Tree in:
 *frontend/webadmin/modules/uicommonweb/src/main/java/org/ovirt/engine/ui/uicommonweb/models/configure/roles_ui/RoleTreeView.java*

` `*`frontend/webadmin/modules/uicompat/src/main/java/org/ovirt/engine/ui/uicompat/Enums.java`*
` `*`frontend/webadmin/modules/uicompat/src/main/resources/org/ovirt/engine/ui/uicompat/Enums.properties`*

## Benefit to oVirt

Permission management for Disks enhances the Disk functionality, provides flexibility to users and protects it from misuse.
Granting permissions on Disk to user is done via the Administrator Portal or using RESTful API.

## Dependencies / Related Features

The Disk Permissions is dependent on the following features:

*   SharedRawDisk
*   Floating Disk
*   Direct LUN

Affected oVirt projects:

*   Engine-core
*   Admin Portal

## Open issues

*   Direct LUN - Add/Remove Direct LUN disk has its own commands or share the same Disk Add/Remove ? If share, need to distinguish the required permission by the Disk in the *CommandBase.getPermissionCheckSubjects*

## Documentation / External references



[Category: Feature](Category: Feature)

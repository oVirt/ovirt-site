---
title: DiskPermissions
category: feature
authors: amureini, derez, lpeer, moti, ofrenkel
wiki_category: Feature
wiki_title: Features/DiskPermissions
wiki_revision_count: 40
wiki_last_updated: 2014-07-13
---

# Disk Permissions

### Summary

The Disk Permissions feature is supplementary for Disk related features (Floating Disk, Shared Raw Disk, Direct LUN). It enables permissions management on a Disk.

### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

### Current status

*   Status: Design Stage
*   Last updated date: Wed Mar 13 2012

### Design

Disk inherits permissions from the VM it is attached to and from the storage domain he resides on (if there is one)
The following section describes permissions for Disk entities.

#### Disk Actions

Floating disk requires permission for storage domain if lives inside a storage domain, else if disk is Direct LUN it requires permission for System.
Required permissions for Disk related actions:

*   Create disk - requires Storage Domain permissions, (can't assume Quota is sufficient to permit user creating the disk on the Storage Domain, as Quota might be disabled).
*   Attach disk to VM - requires permissions for the Disk and for the VM (applies for shared disk as well).
*   Detach disk from VM - requires permissions on the VM only. (Unlike attach disk that requires permissions for the VM and for the Disk).
*   Activate/Deactivate disk on VM (also Hot Plug) - requires permission for the VM.
*   Remove disk - permissions for the Disk.
*   Move or copy disk - requires permissions for the source Disk and for the target Storage Domain.
*   Add disk to VM - requires both permissions for the VM and for the Disk to be added.
    -   Create - for storage domain
    -   Attach - for disk and VM
    -   Activate - for VM
*   Remove VM - could be set to remove the VM and its Disks:
    -   If disks are marked for deletion, requires permissions on the removed Disks.
    -   If disks aren't marked for deletion, the disks are detached, therefore no permissions required for the Disk.

#### Roles

##### New Roles

New predefined role for disks DISK_OPERATOR should be given to user when creating a Disk.

` Add new role to `*`PredefinedRoles.java`*
` Add new role to `*`backend/manager/dbscripts/insert_predefined_roles.sql`*
       Add upgrade script to update role name

##### Updated Roles

VM Operator should be extended with permissions on Disk (attach/detach Disk, activate/deactivate Disk).

       Existing roles are Update by upgrade script.
       Extend `*`VdcObjectType`*` with Disk.

#### DB Changes

       Add support for Disk to `*`fn_get_entity_parents`*` stored-procedure.

#### UI Changes

       Add Disk Operator role to Roles Tree in:
`  `*`frontend/webadmin/modules/uicommonweb/src/main/java/org/ovirt/engine/ui/uicommonweb/models/configure/roles_ui/RoleTreeView.java`*

### Benefit to oVirt

Permission management for Disks enhances the Disk functionality, provides flexibility to users and protects it from misuse.
Granting permissions on Disk to user is done via the Administrator Portal or using RESTful API.

### Dependencies / Related Features

The Disk Permissions is dependent on the following features:

*   SharedRawDisk
*   Floating Disk
*   Direct LUN

Affected oVirt projects:

*   Engine-core
*   Admin Portal

### Open issues

*   DB Upgrade should add ownership for the Disks by the VM users.
*   Direct LUN - Add/Remove/Move(?) Direct LUN disk has its own commands or share the same Disk Add/Remove ? If share, need to distinguish the required permission by the Disk in the *CommandBase.getPermissionCheckSubjects*

### Documentation / External references

### Comments and Discussion

*   See <Talk:Features/DiskPermissions>

[Category: Feature](Category: Feature)

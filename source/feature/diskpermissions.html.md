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

Disk inherits permissions from the VM it is attached to and from the storage domain it resides on (if there is one)
The following section describes permissions for Disk entities.

#### Disk Actions

Required permissions for Disk related actions:

*   Create disk - requires permissions on the Storage Domain, (can't assume Quota is sufficient to permit user creating the disk on the Storage Domain, as Quota might be disabled).
*   Attach disk to VM - requires permissions on the Disk and on the VM (applies for shared disk as well).
*   Detach disk from VM - requires permissions on the VM only. (Unlike attach disk that requires permissions on the VM and on the Disk).
*   Activate/Deactivate disk on VM (also Hot Plug) - requires permission on the VM.
*   Remove disk - permissions on the Disk.
*   Move or copy disk - requires permissions on the Disk and on the target Storage Domain.
*   Add disk to VM - requires both permissions on the VM and on the storage domain (same as adding disk and attaching to VM).
    -   Create - on storage domain
    -   Attach - on disk and VM
    -   Activate - on VM
*   Remove VM - we'll extend the command to support either deleting disks from the system (the current behaviour) or only detach the disks, permissions goes as follows:
    -   If disks are marked for deletion - requires permissions on the removed Disks and on the VM.
    -   If disks aren't marked for deletion - the disks are detached, therefore no permissions required for the Disk, only for removing VM.

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
*   Direct LUN - Add/Remove Direct LUN disk has its own commands or share the same Disk Add/Remove ? If share, need to distinguish the required permission by the Disk in the *CommandBase.getPermissionCheckSubjects*

### Documentation / External references

### Comments and Discussion

*   See <Talk:Features/DiskPermissions>

[Category: Feature](Category: Feature)

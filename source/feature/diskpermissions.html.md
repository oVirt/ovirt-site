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

#### Disk Permissions and Quota

When Quota is enabled an automatic permissions will be created for the Storage Domains to users:
\* For each Quota that is associated with the Storage pool grant to any of the quota users

*   -   For each Storage Domain of the Quota
        -   Grant user permissions on Storage Domain (- new role will be created that contains CREATE_DISK action group)

When editing Quota:

*   when adding SD to the quota - add (automatic) permissions on the new storage domain to all of the quota users
*   when removing SD from the quota - remove (automatic) permissions from the storage domain to all of the quota users
*   when adding User to the quota - add (automatic) permissions on all the storage domains of the quota to the user
*   when removing User from the quota - remove (automatic) permissions on the storage domains of the quota from the user

Global quota - means on all domains of the storage pool:

*   automatic permission will be added/removed on the storage pool

The automatic permissions will be marked with 'automatic' grant-mode to notate the permission method creation.
The automatic permission will be reflected to the user and could be removed. However upon removal of an automatic permission,
a warning message will be presented to the user, as it might affect the ability of the user to add disk on that domain.
If a 'manual' permission was already granted to the user, an automatic permission will not be created.
If an 'automatic' permission was already granted to the user, the permission will change to be 'manual'
 When Quota is disabled, the automatic permissions will enable the same user experience regardless the need to define permissions explicitly on the Disk entities.

The following section describes permissions for Disk entities.

#### Disk Actions

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

#### Roles

##### New Action Groups for Disk Object Type

       CREATE_DISK - AddDisk, AddDiskToVm
       EDIT_DISK_PROPERTIES - UpdateDisk, UpdateVM, Activate/Deactivate
       ATTACH_DISK - AttachDiskToVm
       CONFIGURE_DISK_STORAGE - MoveOrCopyDisk
       DELETE_DISK - RemoveDisk, RemoveVm

##### New Roles

New predefined user role for disks **DISK_OPERATOR** will be given to user when creating a Disk (either from Disk tab or from VM's disk sub-tab).
DISK_OPERATOR will be associated with the following action groups: CREATE_DISK, EDIT_DISK_PROPERTIES, ATTACH_DISK, CONFIGURE_DISK_STORAGE and DELETE_DISK.

` Add new role to `*`PredefinedRoles.java`*
` Add new role to `*`backend/manager/dbscripts/insert_predefined_roles.sql`*
       Add upgrade script to update role name

##### Updated Roles

SuperUser, ENGINEPowerUser, ClusterAdmin, DataCenterAdmin and VmOperator should be extended with action groups of Disks (CREATE_DISK, EDIT_DISK_PROPERTIES, ATTACH_DISK, DELETE_DISK).
Currently attach/detach is being executed as part of the UpdateVm action.

       Existing roles are Update by upgrade script.
       Extend `*`VdcObjectType`*` with Disk.

#### DB Changes

       Add support for Disk to `*`fn_get_entity_parents`*` stored-procedure.

#### Upgrade DB

DB Upgrade should handle the following:

*   Add Disk Operator role to users that have VM Operators to allow permissions on Disks (to VM users having Disks attached to the VMs).
*   Add all disk related operations to the system administrator.
*   Update all permissions grant-mode to 'manual'

#### UI Changes

Extend permission sub-view with grant-mode field (automatic/manual)
Add Permissions sub-tab under Disks main tab
Add Disk Operator role to Roles Tree in:
 *frontend/webadmin/modules/uicommonweb/src/main/java/org/ovirt/engine/ui/uicommonweb/models/configure/roles_ui/RoleTreeView.java*

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

*   Direct LUN - Add/Remove Direct LUN disk has its own commands or share the same Disk Add/Remove ? If share, need to distinguish the required permission by the Disk in the *CommandBase.getPermissionCheckSubjects*

### Documentation / External references

### Comments and Discussion

*   See <Talk:Features/DiskPermissions>

[Category: Feature](Category: Feature)

---
title: Action Permissions overview
authors: moti, ofrenkel, roy, smelamud
---

# Action Permissions Overview

## Abstract

This is an overview and a how-to for developers.
It should give a good idea about how permissions are built into the engine architecture and how to add/update authorization to commands and entities.

## Terminology

*   **Permission**

The main building block of authorization. Permissions are stored in `permissions` table (`Permission` class).

Permission is composed of the target Object (`object_type_id`, `object_id`), User (`ad_element_id`), and Role (`role_id`).

            Permission
           /     |     \
        Object  User   Role

That means that the user has right to act in that particular role in relation to that particular object (for example, he has right to act as `UserVmManager` for a particular VM).

*   **Object (or Entity or Managed Entity)**

The target object on which we want to enforce authorization. The object is described by type and ID. Most of the types in `VdcObjectType` enum are managed by authorization and that's why they are sometimes referred to as "managed entities" in the this context. **VM**, **VmPool** etc are managed entities, while **Tags** and **Bookmarks** are not.

*   **User**

A logged-in user (or group of users) which is performing the command and is managed in a Directory Server (IPA, Active Directory, IBM Tivoli Server). User is identified by ID. Special ID `Guid.EVERYONE` means all authenticated users.

*   **Role**

Role is a set of one or several Action Groups. All roles are listed in `roles` table (`Role` class), link between roles and Action Groups - in `roles_groups` table. Also each role has a type - USER or ADMIN (see `RoleType` enum). ADMIN roles can contain any Action Groups, USER roles can contain only USER Action Groups.

Roles are identified by ID, by some IDs are predefined and have names associated to them (see below).

*   **Pre-Defined Roles**

`SuperUser` and `DataCenterAdmin` are examples of predefined roles inserted to the DB during installation. They can be edited. For the full list of predefined roles see `PredefinedRoles` enum and the `data/00500_insert_roles.sql`, `data/00600_insert_permissions.sql` and `data/00700_insert_roles_groups.sql` scripts.

*   **Action Group**

Group of actions - used for grouping similar actions (commands), for example `RUN_VM` action group allows execution of `RunVm` and `RunOnce` commands. All Action Groups are listed in `ActionGroup` enum. The type of the Action Group - USER or ADMIN - is also set here.

*   **Action**

The basic building block. Every **Command** in the engine is an action and has a unique ID given in `VdcActionType` enum. The corresponding Action Group for each action is also given here.

*   **MLA**

Multi Level Administration. To make a long story short, it was the initial name of the permission feature in the engine. At first there was no authorization on actions so a special UI was designed to enforce it and its name was "Multi Level Administration Portal".

*   **Admin**

User having at least one permission that contains ADMIN role. Only super user can give permissions with ADMIN role.

### Entities Hierarchy

*   Permissions are inherited in the entities hierarchy, for example:
    -   the following permission: `('User1', 'vm1', 'UserRole')` means that *User1* has *UserRole* on *vm1* only;
    -   but `('User1', 'cluster1', 'UserRole')` means that *User1* has *UserRole* on the *cluster1* cluster and all objects in it (VMs, Hosts...).

&nbsp;

       Data Center
        |
        +--- Cluster
        |        |
        |        +--- Host
        |        |
        |        +--- VM
        |        |     |
        |        |     +--- Disk
        |        |
        |        +--- VM Pool
        |        |
        |        +--- Gluster Volume
        |
        +--- Storage Domain
        |        |
        |        +--- Disk
        |
        +--- Quota
        |
        +--- Template
        |
        +--- Network

*   Special object ID `Guid.SYSTEM` is root of all hierarchies and used to give global permissions.
*   The hierarchy is defined in the DB, specifically in `fn_get_entity_parents` DB function.

### Setting command permissions

Every command checks permissions required to run it in CommandBase.isUserAuthorizedToRunAction() method. It calls getPermissionCheckSubjects() method to get list of command-specific permissions. Actual check is performed by CommandBase.checkUserAuthorization() method.

*   Each permission that command requires is represented by `PermissionSubject` object, containing target object, Action Group that's required and message that should be displayed if the permission is absent.
*   List of permissions that command requires is returned by `CommandBase.getPermissionCheckSubjects()` method.
    -   for example, `RunVmCommand` requires `ActionGroup.RUN_VM` on the VM passed to it in the params and `ActionGroup.CHANGE_VM_CUSTOM_PROPERTIES` on the same VM, if custom properties are to be changed.
*   As special case, if `CommandBase.getPermissionCheckSubjects()` returns null or empty list, access is denied. This can be used to deny user from calling some commands directly.
*   Internal commands do not check permissions - they rely on the permission check performed by their caller. That means that external command must check not only the permissions it requires for itself, but also the permissions required by its subcommands.
*   Actual check is performed by `CommandBase.checkPermissions()` method. It is possible to override this method for more advanced usage and modification of the logic of the permission check. `checkSinglePermission()` can be used as building block here to check single `PermissionSubject`.
*   The whole authorization logic is coded in `CommandBase.isUserAuthorizedToRunAction()` method. Low-level work is performed by `CommandBase.checkUserAuthorization()` method.

### More Info

*   [User queries](/develop/release-management/features/infra/user-portal-permissions.html)
*   [Network permissions](/develop/release-management/features/network/networkpermissions.html)
*   [Disk permissions](/develop/release-management/features/storage/diskpermissions.html)


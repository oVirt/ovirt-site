---
title: Action Permissions overview
authors: moti, roy
wiki_title: Action Permissions overview
wiki_revision_count: 5
wiki_last_updated: 2012-10-31
---

# Action Permissions overview

## Abstract

This is an overview and a how-to for developers. It should give a good idea about how
permissions are built into the engine architecture and how to add/update authorization to commands and entities.

## Terminology

*   **Permission**

The building block in authorization which is composed from the target Object, User, and Role Ids.

            Permission
           /     |     \
        Object  User   Role

*   **Object or Entity or Manage Entity**

The target object on which we want to enforce authorization. Most of the members in `**\1**` are
managed by authorization and that's why they are some times refered to as "managed entities" in the this context.
**VM**, **VmPool** etc are a managed entities while **Tags** and **Bookmarks** are not.

*   **User**

A logged-in user (or group of users) which is performing the command and is managed in a Directory Server (IPA, Active Directory, IBM Tivoly Server).

*   **Role**

Role is Action groups container. A role can also be associated as a USER/ADMIN type.
ADMIN roles have any Action Groups, USER roles can have only USER Action Groups.

*   **Pre-Defined Roles**

`SuperUser` and ` DataCenterAdmin ` are examples of predefined roles inserted during installation to DB. They could be edited.
for the list of full predefind roles see `**\1**` and `**\1**`

*   **Action Group**

Group of Actions - used for grouping multiple actions (commands), for example RUN_VM action group allows exexuting RunVm and RunOnce

*   **Action**

The basic building block. Every **Command** in the engine is an action and has a unique ID given in `**\1**`

*   **MLA** - multi level administration.

To make a long story short it was the initial name of the permission feature in the engine. At first there was no
authorization on actions (woohoo!) so a special UI was designed to enforce it and its name was "Multi Level Administration Portal"

*   **Admin** - User with a permission that contains admin role.

Permissions delegation - only super user can give permission with admin role.

#### Entities Hierarchy

*   Permissions are inherited in the entities hierarchy, for example:
    -   Giving the following permission: ('User1', 'vm1', 'UserRole') => this means that User1 has userRole on vm1 only.
    -   and: ('User1', 'cluster1', 'UserRole') => othis means that User1 has userRole on the cluster and all objects in this cluster (VMs, Hosts..).

       Data Center
        |
        +--- Cluster
        |        |
        |        +--- Host
        |        |
        |        +--- VM
        |        |     |
        |        |     +--- Disk
        |        |
        |        +--- VM Pool
        |        |
        |        +--- Gluster Volume
        |
        +--- Storage Domain
        |        |
        |        +--- Disk
        |
        +--- Quota
        |
        +--- Template
        |
        +--- Network

*   The hierarchy is defined in the db, specifically in fn_get_entity_parents db-function

### Setting command permissions

*   Every command defines what action group is needed and on what object in order for it to run, using the getPermissionCheckSubjects() method.
    -   for example: RunVmCommand requires ActionGroup.RUN_VM on the vm that sent in the params and CHANGE_VM_CUSTOM_PROPERTIES on the vm if custom props were changed.
*   it is also possible to override the checkPermissions() method for more advanced usage and modifying the logic of permissions check.

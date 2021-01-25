---
title: NetworkPermissions
category: feature
authors: danken, lpeer, moti
---

# Network Permissions

## Summary

The Network Permissions feature is supplementary for network related actions in the system.
It enables permissions management on a Network to control which user is allowed to perform what action when it relates to network.
Please refer to [Action Permissions overview](/develop/developer-guide/action-permissions-overview.html) for further information about Multi-Level-Administration (MLA).

## Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

## Current status

*   Status: Design Stage
*   Last updated date: Tue Oct 23 2012

## High Level Feature Description

### Admin

*   For creating a network in a DC you need to be **SuperUser** or **DataCenterAdmin** or **NetworkAdmin** on the DC.
*   After creating the network you can manipulate the network if you are a **DataCenterAdmin** or **NetworkAdmin** on the relevant network (or the whole DC).
*   For attaching the network to cluster user needs to be **NetworkAdmin** on the network (no requirement to have permission on the cluster)
*   **ClusterAdmin** cannot attach/detach a network from the cluster, the motivation for this is that as long as the network is not attached to the cluster it is not part of the cluster resources thus can not be managed by the cluster administrator.
    -   The **ClusterAdmin** can change a network from required to non-required for controlling the impact of the network within the cluster.
*   For setting or manipulating a network on the host you need to be host administrator on the host and you don't need to be network administrator.

### User

*   For attaching a network to a Vnic in the VM you need to have the role of **NetworkUser** on the network and **UserVmManager** on the VM.
*   In user portal - the list of shown network for a user will include only the list of networks the user is allowed to attach to its vnics (instead of all cluster's networks) or those which are currently attached to its VM.
*   In RESTFul API the user will be able to see the networks which he has permissions on or those which are attached to its VM.

#### Port-mirroring

*   For configuring in the VM port mirroring you need to have the role of **NetworkAdmin** on the network and **UserVmManager** on the VM.

## Detailed Design

The following section describes the permissions on Network entities.

### Network's Actions

The **existing Action Groups** and their associated Actions:

*   CONFIGURE_STORAGE_POOL_NETWORK (admin role, requires permissions on VdcObjectType.StoragePool) for actions:
    -   AddNetwork
    -   RemoveNetwork
    -   UpdateNetwork
*   CONFIGURE_CLUSTER_NETWORK (admin role, on VdcObjectType.VdsGroups) for actions:
    -   AttachNetworkToVdsGroup
    -   DetachNetworkToVdsGroup
    -   UpdateNetworkOnCluster
*   EDIT_CLUSTER_CONFIGURATION (admin role, on VdcObjectType.VdsGroups) for actions:
    -   UpdateDisplayToVdsGroup - deprecated.
*   CONFIGURE_HOST_NETWORK (admin role, on VdcObjectType.VDS) for actions:
    -   SetupNetworks
    -   AddBond
    -   RemoveBond
    -   AttachNetworkToVdsInterface
    -   DetachNetworkFromVdsInterface
    -   UpdateNetworkToVdsInterface
    -   CommitNetworkChanges
*   CONFIGURE_VM_NETWORK (user role, on VdcObjectType.VM) for actions:
    -   ActivateDeactivateVmNic
    -   AddVmInterface
    -   RemoveVmInterface
    -   UpdateVmInterface
*   CONFIGURE_TEMPLATE_NETWORK (user role, on VdcObjectType.VmTemplate) for actions:
    -   AddVmTemplateInterface
    -   RemoveVmTemplateInterface
    -   UpdateVmTemplateInterface
*   PORT_MIRRORING (admin role, on VdcObjectType.VmInterface) for actions:
    -   AddVmInterface
    -   UpdateVmInterface

**VmInterface** entity is defined and in use for Port Mirroring.

#### New Action Groups

*   **ASSIGN_CLUSTER_NETWORK** (admin role, on VdcObjectType.Network) will be defined for actions:
    -   AttachNetworkToVdsGroup
    -   DetachNetworkToVdsGroup

<!-- -->

*   **CREATE_STORAGE_POOL_NETWORK** (admin role, on VdcObjectType.StoragePool) will be defined for actions:
    -   AddNetworkCommand
*   **DELETE_STORAGE_POOL_NETWORK** (admin role, on VdcObjectType.Network) will be defined for actions:
    -   UpdateNetworkCommand

### Roles and Action Groups

#### New Roles

*   **NetworkUser** a new user role to be associated with the following groups: CONFIGURE_VM_NETWORK and CONFIGURE_TEMPLATE_NETWORK.
    -   It should allow the user to create vnics attached to the subjected network or to update an existing vnic network.

#### Updated Roles

*   **NetworkAdmin** is currently attached to groups MANIPUTLATE_HOST, CONFIGURE_HOST_NETWORK and CONFIGURE_CLUSTER_NETWORK. It will be changed as follow:
    -   Removed action groups:
        -   MANIPUTLATE_HOST - it has nothing to do with networking, therefore should be omitted from the aforementioned list.
    -   Added action groups:
        -   CREATE_STORAGE_POOL_NETWORK - to allow add networks to the Data-Center.
        -   DELETE_STORAGE_POOL_NETWORK - to allow remove networks from the Data-Center.
        -   CONFIGURE_STORAGE_POOL_NETWORK - to allow update networks of the Data-Center.
        -   ASSIGN_CLUSTER_NETWORK - new action group for attach/detach network from cluster.
    -   Attaching a network to host's nic will not require permission on the attached network, rather on the host only.
    -   PORT_MIRRORING - allows to define a network as port-mirroring

#### Updated Action Groups

*   **PORT_MIRRORING** should require permissions on both the Vm and the target Network.
    -   Required permissions:
        -   Permission on the network with PORT_MIRRORING action group.
        -   Permission on the VM with CONFIGURE_VM_NETWORK action group.

<!-- -->

*   **CONFIGURE_CLUSTER_NETWORK** (admin role, on VdcObjectType.VdsGroups) will be restricted for action:
    -   UpdateNetworkOnCluster - since ClusterAdmin is not allowed to control the Network resource.

<!-- -->

*   **SUPER_USER** is extended to include **ASSIGN_CLUSTER_NETWORK**.
*   **DATA_CENTER_ADMIN** is extended to include **ASSIGN_CLUSTER_NETWORK**.

#### Updated Entities Hierarchy

A new **Network** entity will be added as a child of **Data-Center**
 cleanup:
The **VmInterface** should be removed from the the hierarchy.
It is not in used today and we see no reason to keep it around.

### DB Changes

Modify create_functions.sql:

       Add support for Network to `*`fn_get_entity_parents`*` stored-procedure.
       Add support for Network to `*`fn_get_entity_name`*` stored-procedure.
       Remove VmInterface from `*`fn_get_entity_name`*` and `*`fn_get_entity_parents`*` stored-procedure.

Add new view:

       user_network_permissions_view
       A join of users to networks which the user has a permission on, united with permissions a user have for the Data-Center.

#### Updated Queries

The following queries will be modified to be filtered by the user:

      GetAllNetworksByClusterIdQuery - when filter is set the query returns the networks that the User has permission on or attached to the User's VM.

#### Upgrade DB

DB Upgrade should handle the following:

*   Permissions on VmNetworkInterface should be deleted from the setup (if any).
*   Permission on Data Center with PORT_MIRRORING action group will be replaced with:
    -   Permission on All the networks in the DC with PORT_MIRRORING action group.

<!-- -->

*   Permission with **NetworkUser** role will be granted to 'everyone' for each network in the system.

bug fix:
Remove MANIPUTLATE_HOST action group from NetworkAdmin role.

### UI Changes

Add Permissions sub-tab under Networks main tab
Add Network as an entity of both User/Admin role dialog.
![](/images/wiki/Network-permissions-dialog.png)

Add Network User role to Roles Tree in:

*`frontend/webadmin/modules/uicommonweb/src/main/java/org/ovirt/engine/ui/uicommonweb/models/configure/roles_ui/RoleTreeView.java`*
*`frontend/webadmin/modules/uicompat/src/main/java/org/ovirt/engine/ui/uicompat/Enums.java`*
*`frontend/webadmin/modules/uicompat/src/main/resources/org/ovirt/engine/ui/uicompat/Enums.properties`*

On 'New Logical Network' dialog a new option will be added as check box with message: "Allow all users to use this Network"
Checking this option will grant 'everyone' permissions of the created network with 'VmNetworkUser' role.

User Portal should be modified to use the updated query.

## Benefit to oVirt

Permission management for Networks enhances the Network functionality, provides flexibility to users and protects it from misuse.
Granting permissions on Network to user is done via the Administrator Portal or using RESTful API.

## Dependencies / Related Features

The Network Permissions is dependent on the following features:

*   Network Main Tab

Affected oVirt projects:

*   Engine-core
*   Admin Portal


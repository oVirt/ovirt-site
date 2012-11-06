---
title: NetworkPermissions
category: feature
authors: danken, lpeer, moti
wiki_category: Feature
wiki_title: Feature/NetworkPermissions
wiki_revision_count: 77
wiki_last_updated: 2013-04-18
---

# Network Permissions

### Summary

The Network Permissions feature is supplementary for network related actions in the system.
It enables permissions management on a Network to control which user is allowed to perform what action when it relates to network.
Please refer to [Action Permissions overview](http://wiki.ovirt.org/wiki/Action_Permissions_overview) for further information about Multi-Level-Administration (MLA).

### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

### Current status

*   Status: Design Stage
*   Last updated date: Tue Oct 23 2012

### High Level Feature Description

#### Admin

*   For creating a network in a DC you need to be **SuperUser** or **DataCenterAdmin** or **NetworkAdmin** on the DC.
*   After creating the network you can manipulate the network if you are a **DataCenterAdmin** or **NetworkAdmin** on the relevant network (or the whole DC).
*   For attaching the network to cluster user needs to be **NetworkAdmin** on the network (no requirement to have permission on the cluster)
*   **ClusterAdmin** cannot attach/detach a network from the cluster, the motivation for this is that as long as the network is not attached to the cluster it is not part of the cluster resources thus can not be managed by the cluster administrator.
    -   The **ClusterAdmin** can change a network from required to non-required for controlling the impact of the network within the cluster.
*   For setting a network on the host you need to be host administrator on the host and you don't need to be network administrator.

#### User

*   For attaching a network to a Vnic in the VM you need to have the role of **VmNetworkUser** on the network and **VmAdmin** on the VM.

##### Port-mirroring

*   For configuring in the VM port mirroring you need to have the role of **VmAdvancedNetworkUser** on the network and **VmAdmin** on the VM.
    -   **VmAdvancedNetworkUser** includes all the **VmNetworkUser** actions and in addition the port mirroring action.

### Detailed Design

The following section describes the permissions on Network entities.

#### Network's Actions

The **existing Action Groups** and their associated Actions:

*   CONFIGURE_STORAGE_POOL_NETWORK (admin role, requires permissions on VdcObjectType.StoragePool) for actions:
    -   AddNetwork
    -   RemoveNetwork
    -   UpdateNetwork
*   CONFIGURE_CLUSTER_NETWORK (admin role, on VdcObjectType.VdsGroups) for actions:
    -   AttachNetworkToVdsGroup
    -   DetachNetworkToVdsGroup
    -   UpdateNetworkOnCluster
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

#### Roles and Action Groups

##### New Roles

*   **VmNetworkUser** a new user role to be associated with the following groups: CONFIGURE_VM_NETWORK and CONFIGURE_TEMPLATE_NETWORK.
    -   It should allow the user to create vnics attached to the subjected network or to update an existing vnic network.
*   **VmAdvancedNetworkUser** a new role will include the same action groups as **VmNetworkUser** and in addition the PORT_MIRRORING action group.

##### Updated Roles

*   **NetworkAdmin** is currently attached to groups MANIPUTLATE_HOST, CONFIGURE_HOST_NETWORK and CONFIGURE_CLUSTER_NETWORK. It will be changed as follow:
    -   Removed action groups:
        -   MANIPUTLATE_HOST - it has nothing to do with networking, therefore should be omitted from the aforementioned list.
    -   Added action groups:
        -   CONFIGURE_STORAGE_POOL_NETWORK - to allow add/remove/update of networks to the Data-Center.
        -   MANAGE_CLUSTER_NETWORK - new action group.
    -   Attaching a network to host's nic will not require permission on the attached network, rather on the host only.

##### Updated Action Groups

*   **PORT_MIRRORING** should require permissions on both the Vm and the target Network.
    -   The action group will be modified from Admin role type to a User role type.
    -   Required permissions:
        -   Permission on the network with PORT_MIRRORING action group.
        -   Permission on the VM with CONFIGURE_VM_NETWORK action group.
    -   When permissions are given to the user, the user will be able to configure when the port mirroring should be enabled or disabled.

<!-- -->

*   **CONFIGURE_CLUSTER_NETWORK** (admin role, on VdcObjectType.VdsGroups) will be restricted for action:
    -   UpdateNetworkOnCluster - since ClusterAdmin is not allowed to control the Network resource.

<!-- -->

*   **SUPER_USER** is extended to include **MANAGE_CLUSTER_NETWORK**.
*   **DATA_CENTER_ADIM** is extended to include **MANAGE_CLUSTER_NETWORK**.

##### New Action Groups

*   **MANAGE_CLUSTER_NETWORK** (admin role, on VdcObjectType.Network) will be defined for actions:
    -   AttachNetworkToVdsGroup
    -   DetachNetworkToVdsGroup

##### Updated Entities Hierarchy

The **VmInterface** should be removed from the the hierarchy. User having permission on VmInterface will have a permission on the VM instead as part of the upgrade script.
A new **Network** entity will be added as a child of **Data-Center**

#### DB Changes

Modify create_functions.sql:

       Add support for Network to `*`fn_get_entity_parents`*` stored-procedure.
       Add support for Network to `*`fn_get_entity_name`*` stored-procedure.
       Remove VmInterface from `*`fn_get_entity_name`*` and `*`fn_get_entity_parents`*` stored-procedure.

Add new view:

       user_network_permissions_view
       A join of users to networks which the user has a permission on, united with permissions a user have for the Data-Center.

##### Updated Queries

The following queries will be modified to be filtered by the user:

      GetAllNetworksByClusterIdQuery - when filter is set the query returns the networks that the User has permission on.

##### Upgrade DB

DB Upgrade should handle the following:

*   Permissions on all Data Center's Networks should be granted to any user owns permissions on Data-Center (having action group CONFIGURE_STORAGE_POOL_NETWORK).
*   Permissions on all Cluster's Networks should be granted to any user owns permissions on the Cluster (having action group CONFIGURE_CLUSTER_NETWORK).
*   Permissions on VmNetworkInterface should be replaced with permissions on the VM ().
*   Permission on VM Network Interface with PORT_MIRRORING action group will be replaced by a permission on the Network and on the VM with PORT_MIRRORING action group.
*   NetworkAdmin role will be updated:
    -   include CONFIGURE_STORAGE_POOL_NETWORK
    -   exclude MANIPULATE_HOST_STATUS

In order to remove MANIPUTLATE_HOST action group from NetworkAdmin role, there is a need to create new predefined role named **HostOperator**.
\* **HostOperator** will be associated with MANIPUTLATE_HOST action group.

*   **HostOperator** will be assigned to any user have the NetworkAdmin role.

#### UI Changes

Add Permissions sub-tab under Networks main tab
Add Network User role to Roles Tree in:
 *frontend/webadmin/modules/uicommonweb/src/main/java/org/ovirt/engine/ui/uicommonweb/models/configure/roles_ui/RoleTreeView.java*

` `*`frontend/webadmin/modules/uicompat/src/main/java/org/ovirt/engine/ui/uicompat/Enums.java`*
` `*`frontend/webadmin/modules/uicompat/src/main/resources/org/ovirt/engine/ui/uicompat/Enums.properties`*

### Behavioural Change

*   Edit/Remove network from the Data Center will require permission on the Network.
*   Assigning network to cluster will require permission on the Cluster and on the Network.
*   Setting VM Network Interface for port mirroring will require permission on the Network with role contains PORT_MIRRORING action group.

<!-- -->

*   In user portal - the list of shown network for a user will include only the list of networks the user is allowed to attach to its vnics (instead of all cluster's networks).
*   A user should have permission on network in order to attach it to its nics, e.g. **VmNetworkUser** role.

<!-- -->

*   **NetworkAdmin** role will not allow the user to perform any of MANIPUTLATE_HOST actions (host fencing, maintenance)
*   **NetworkAdmin** role will be extended to allow users to create new networks on Data-Center level, update or remove them.

### Benefit to oVirt

Permission management for Networks enhances the Network functionality, provides flexibility to users and protects it from misuse.
Granting permissions on Network to user is done via the Administrator Portal or using RESTful API.

### Dependencies / Related Features

The Network Permissions is dependent on the following features:

*   Network Main Tab

Affected oVirt projects:

*   Engine-core
*   Admin Portal

### Open issues

*   Network SLA - this feature should consider network permission when implemented.

### Documentation / External references

### Comments and Discussion

[Category: Feature](Category: Feature)

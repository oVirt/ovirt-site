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

The Network Permissions feature is supplementary for network related actions in the system. It enables permissions management on a Network to control which user is allowed to perform what action when it relates to network.

### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

### Current status

*   Status: Design Stage
*   Last updated date: Tue Oct 23 2012

### Design

The following section describes the permissions on Network entities.

#### Network Actions

Current Action Groups and their associated Actions:

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

VdcObjectType.VmInterface is already defined and in use by Port Mirroring

#### Roles

##### New Action Groups for Network Object Type

##### New Roles

*   **VmNetworkUser** a new user role to be associated with the following groups: CONFIGURE_VM_NETWORK and CONFIGURE_TEMPLATE_NETWORK.
    -   It should allow the user to create vnics attached to the subjected network or to update an existing vnic network.

##### Updated Roles

*   **NetworkAdmin** attached to groups MANIPUTLATE_HOST, CONFIGURE_HOST_NETWORK and CONFIGURE_CLUSTER_NETWORK.
    -   MANIPUTLATE_HOST has nothing to do with networking, therefore should be omitted from the aforementioned list.
    -   CONFIGURE_STORAGE_POOL_NETWORK should be added to the NetworkAdmin groups.
    -   The actions should be modified to require permission on Network and the main entity of each group (On Data Center and Cluster and on Network)

**Question 1**: Do we need a permission on Network when we attach it to Host? If a user is the Host owner, he might be able to configure the network on host directly.
**Question 2**: How do we handle if at all 'unmanaged networks' ? (as they have no representing Network entity in the system)

##### Updated Action Groups

*   **PORT_MIRRORING** should require permissions on both the Vm and the Network for creating or updating a VM nic.

The **VmInterface** should be removed from the VdcObjectType, since this is too granular entity (Add/Update Vm Interface should be modified accordingly).

#### DB Changes

       Modify create_functions.sql:
       Add support for Network to `*`fn_get_entity_parents`*` stored-procedure.
       Add support for Network to `*`fn_get_entity_name`*` stored-procedure.

#### Upgrade DB

DB Upgrade should handle the following:

If decided to add an explicit Network network:

*   Permissions on Network should be granted to any user owns permissions on Data-Center.
*   Permissions on VmNetworkInterface should be replaced with permissions on the VM.

#### UI Changes

Add Permissions sub-tab under Networks main tab
Add Network User role to Roles Tree in:
 *frontend/webadmin/modules/uicommonweb/src/main/java/org/ovirt/engine/ui/uicommonweb/models/configure/roles_ui/RoleTreeView.java*

` `*`frontend/webadmin/modules/uicompat/src/main/java/org/ovirt/engine/ui/uicompat/Enums.java`*
` `*`frontend/webadmin/modules/uicompat/src/main/resources/org/ovirt/engine/ui/uicompat/Enums.properties`*

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

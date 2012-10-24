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

The following section describes permissions for Network entities.

#### Network Actions

Current Action Groups and their associated Actions:

*   CONFIGURE_STORAGE_POOL_NETWORK (on VdcObjectType.StoragePool) for actions:
    -   AddNetwork
    -   RemoveNetwork
    -   UpdateNetwork
*   CONFIGURE_CLUSTER_NETWORK (on VdcObjectType.VdsGroups) for actions:
    -   AttachNetworkToVdsGroup
    -   DetachNetworkToVdsGroup
    -   UpdateNetworkOnCluster
*   CONFIGURE_HOST_NETWORK (on VdcObjectType.VDS) for actions:
    -   SetupNetworks
    -   AddBond
    -   RemoveBond
    -   AttachNetworkToVdsInterface
    -   DetachNetworkFromVdsInterface
    -   UpdateNetworkToVdsInterface
    -   CommitNetworkChanges
*   CONFIGURE_VM_NETWORK (on VdcObjectType.VM) for actions:
    -   ActivateDeactivateVmNic
    -   AddVmInterface
    -   RemoveVmInterface
    -   UpdateVmInterface
*   CONFIGURE_TEMPLATE_NETWORK (on VdcObjectType.VmTemplate) for actions:
    -   AddVmTemplateInterface
    -   RemoveVmTemplateInterface
    -   UpdateVmTemplateInterface
*   PORT_MIRRORING (on VdcObjectType.VmInterface) for actions:
    -   AddVmInterface
    -   UpdateVmInterface

VdcObjectType.VmInterface already defined and in use by Port Mirroring

#### Roles

##### New Action Groups for Network Object Type

##### New Roles

An existing role "NETWORK_ADMIN" attached to groups MANIPUTLATE_HOST, CONFIGURE_HOST_NETWORK and CONFIGURE_CLUSTER_NETWORK. It is defined as administrator role having permission for all operations on a specific Logical Network.

##### Updated Roles

#### DB Changes

       Modify create_functions.sql:
       Add support for Network to `*`fn_get_entity_parents`*` stored-procedure.
       Add support for Network to `*`fn_get_entity_name`*` stored-procedure.

#### Upgrade DB

DB Upgrade should handle the following:

#### UI Changes

Add Permissions sub-tab under Networks main tab
Add Network Operator role to Roles Tree in:
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

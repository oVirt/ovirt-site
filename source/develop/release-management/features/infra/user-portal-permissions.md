---
title: User Portal Permissions
category: feature
authors: amureini, ekohl, lpeer, ovedo
---

# User Portal Permissions

## Summary

This page details how the User Portal decides what objects to display, specifically in relation to create permissions.

## Owner

* Name: Allon Mureinik
* Email: amureini@redhat.com

## Current status

* Status: Released in oVirt 3.1

## Detailed Description

### Query Permissions and Integration with MLA

For each query the engine will manage `queryType`, which can be either an Admin query or a User query. Admin query means only admins can execute the query, while User query means that any user can execute the query (administrators included). In addition to the `queryType` a parameter, an `isFiltered` parameter will be added to the `VdcQueryParametersBase` class. This parameter will govern if the query is executed in filtered mode (and should return only the objects the user has user permissions on) or not (and as such should return all the objects). The default is that `isFiltered` is set to `false`, due to backwards compatibility considerations.

Permission checking will be done in two levels:

1. Authorization - before executing the query: validating a user is an administrator (i.e., has at least one administrator role) if the query is an Admin query or if `isFiltered` is set to `false`.
2. Filtering - as part of the query execution: joining the "business logic" of the query to a permissions view, providing a single point of entry to managing permission logic.

### `VdcQueryType` enum

A property `queryType` will be added to the enum. Most queries are not available to users so the default will be `admin`.

### `VdcQueryParametersBase`

From now on, it will be possible to specify if the query should be executed in admin or in filtered mode. The default will be to execute as admin, for backwards compatibility reasons.

### Running a Query

In case of an admin query (be it due to the query's internal type or to a request to run as an admin), the query will perform a minimal authorization check to see if the user may execute such queries.

### DAOs

Each method used by a user query will be overloaded with two additional parameters - `userID` and `isFiltered`. E.g., we would like to have a filtered version of `GetVmInterfacesByVmIdQuery`, which uses `VmNetworkInterfaceDAO.getAllForVm(Guid vmID)`, so we will overload this method and create `VmNetworkInterfaceDAO.getAllForVm(Guid vmID, Guid userID, boolean isFiltered)`.

#### Hibernate DAO implementations

Currently, will not be supported. If necessary, an additional method that throws `UnsupportedOperationException`, and a test that verifies this exception is thrown so when the Hibernate DAO will be implemented that test will break, and the implementor will remember to implement this method too.

### Permissions Views

A set of n flat views (one per entity type) will be created. The view will hold the `user_id` and `entity_id` and fields will implement the flattened logic of permissions. E.g., if it's decided that permissions on pool grant read permissions on the VMs inside it, this will be exposed in the `vm_permissions_view` view. Each query implementation will be responsible for joining with the appropriate permissions view. Thus, permission-checking logic will only be implemented in a single place (per type, unfortunately) instead of inside each query.

### Stored Procedures

Each stored procedure used by a user query will have two parameters added to it - `user_id (UUID)` and `is_filtered (boolean)`.

### Inheriting Permissions

Today, the User Portal exposes all the objects under an entity if any permission is given on that entity or on the reflecting entities (add link to explanation what is reflecting entities). This behaviour is correct for "manipulate" and "use" permission, but not for "create" permissions. E.g. If a user has the permissions to create a VM in a cluster, he should not be able to see all the VMs in that cluster.

In the suggested solution, an additional column, `allows_viewing_children` (`boolean`) will be added to the `roles_groups` table. Only action groups with `allows_viewing_children=true` will provide permissions on the objects contained in the object they are granted on.

Following is a detailed description of the behavior for each entity type.

*   Data Center - Create VM/Template permission will not grant the ability to view VMs/Templates in the DC.
*   Cluster - Create VM/Template permission will not grant the ability to view VMs/Templates in the cluster.
*   Storage Domain - Create VM/Template/Disk permission will not grant the ability to view objects contained in the storage domain.

#### Creator Roles

Two new predefined roles should be added - VM Creator and Template Creator, which only contain the action groups for adding VMs/Templates, respectively, and do not allow users to manipulate existing entities. These new roles will be the way administrators will grant their users the ability to create new VMs/Templates without exposing existing ones. For disks, the existing role Disk Creator will be used.

#### Operator Roles

For the modification of an existing templates/vms/disks the VM ADMIN, TEMPLATE ADMIN and DISK ADMIN roles should be given to a user who issues a CreateVMTempalteCommand on the template he created.

### Entity Description

No new entities are required for this feature.

### CRUD

No new entities are required for this feature.

### User Experience

See Inheriting Permissions.

### Installation/Upgrade

The three new predefined roles should be created.

### User work-flows

#### Adding a VM

1. The admin grants the VM Creator permission to a user on a host/cluster
2. The user can create a new VM on the host/cluster
3. Once the user creates the VM, he becomes a VM Operator on this VM

### Events

No new events are added.

## Dependencies / Related Features and Projects

### REST API

As part of the user level queries changes, we also added user-level API capabilities to the REST API.
Before these changes, only administrators could login to the API. Now, you can logic as a regular user as well, by specifying the "filter: true" HTTP header.
For example, as a user, in order to get all your VMs through the API you can do the following:

`curl http://engine-address:engine-port/api/vms -u "user@domain":password -H` **`"filter: true"`**

The following endpoints are supported:

* /api
* /api/vms
* /api/clusters
* /api/datacenters
* /api/roles
* /api/storagedomains
* /api/templates
* /api/domains
* /api/capabilities

## Documentation / External references

[Writing A New User
Query](/develop/developer-guide/engine/writing-a-new-user-query.html)



## Open Issues

* Should Create Host permissions be inherited for viewing?
* Should we grant VM/Template Creator to any user who is a VM/Template Admin?
* How do Disk Permissions integrate with this solution?


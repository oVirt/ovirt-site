---
title: User Portal Permissions
category: template
authors: amureini, ekohl, lpeer, ovedo
wiki_category: Template
wiki_title: Features/User Portal Permissions
wiki_revision_count: 14
wiki_last_updated: 2012-12-05
---

The actual name of your feature page should look something like: "Your feature name". Use natural language to name the pages.

### User Portal Permissions

#### Summary

This page details how the User Portal decides what objects to display, specifically in relation to create permissions.

#### Owner

*   Name: [Allon Mureinik](User:Amureini)
*   Email: amureini@redhat.com

#### Current status

*   Target Release: 3.1
*   Status: work in progress
*   Last updated date: 01/05/2012

#### Detailed Description

##### Inheriting Permissions

Today, the User Portal exposes all the objects under an entity if any permission is given on that entity. This behaviour is correct for "manipulate" and "use" permission, but not for "create" permissions. E.g. If a user has the permissions to create a VM in a cluster, he sould not be able to see all the VMs in the cluster.

Following is a detailed description of the behavior for each entity type.

*   Data Center - Create VM/Template/Pool permission will not grant the ability to view objcets contained in the DC.
*   Cluster - Create VM/Template/Pool permission will not grant the ability to view objcets contained in the cluser.
*   Storage Domain - Create VM/Template/Disk permission will not grant the ability to view objcets contained in the storage domain.

##### Creartor Roles

Two new predefined roles should be added - VM Creator and Tempalate Creator, which only contain the action groups for adding VMs/Templates, respectively, and do not allow users to manipulate existing entities. These new roles will be the way administrators will grant their users the ability to create new VMs/Templates without exposing existing ones.

##### Template Operator Roles

A new predifined role should be added - Template Operator. This role will allow the modification of an existing template, and would be given to a user who issues a CreateVMTempalteCommand on the template he created.

##### Entity Description

No new entities are required for this feature.

##### CRUD

No new entities are required for this feature.

##### User Experience

See Inheriting Permissions.

##### Installation/Upgrade

The three new predifined roles should be created.

##### User work-flows

###### Adding a VM

1. The admin grants the VM Creator permission to a user on a host/cluster 2. The user can create a new VM on the host/cluster 3. Once the user creates the VM, he becomes a VM Operator on this VM

##### Events

No new events are added.

#### Dependencies / Related Features and Projects

N / A

#### Documentation / External references

N / A

#### Comments and Discussion

[Talk:Features/User Portal Permissions](Talk:Features/User Portal Permissions)

#### Open Issues

*   Should Create Host permissions be inherited for viewing?
*   Should we grant VM/Template Creator to any user who is a VM/Template Admin?
*   How do Disk Permissions integrate with this solution?

# Query Permissions

### Current Situation

Today, MLA is implemented only for Actions, not for queries. A user that is not an administrator won't be able to log into the webadmin URL but in the userprortal any user can query any object, regardless of permissions.

### Suggested solution

#### In A Nutshell

For each query the engine will manage \`queryType\`, which can be either an Admin query or a User query. Admin query means only admins can execute the query, while User query means that any user can execute the query (administrators included). In addition to the \`queryType\` a parameter, an \`isFiltered\` parameter will be added to the \`VdcQueryParametersBase\` class. This parameter will govern if the query is executed in filtered mode (and should return only the objects the user has user permissions on) or not (and as such should return all the objects). The default is that \`isFiltered\` is set to \`false\`, due to backwards compatibility considerations.

Note: if the \`quryType\` is set to Admin query then \`isFiltered\` property is ignored.

Permission checking will be done in 2 levels:

      ` 1. Before executing the query: validating a user is administrator if the query is Admin query or if `isFiltered` is set to false. `
      2. Part of the query execution: joining the "business logic" of the query to a permissions view, providing a single point of entry to managing permission logic.

#### VdcQueryType enum

A property \`queryType\` will be added to the enum. Most queries are not available to users so the default will be \`admin\`.

#### VdcQueryParametersBase

From now on, it will be possible to specify if the query should be executed in admin or in filtered mode. The default will be to execute as admin, for backwards compatibility reasons.

#### Running a Query

In case of an admin query (be it due to the query's internal type or to a request to run as an admin), the query will perform a minimal autorization check to see if the user may execute such queries. Psuedocode:

#### DAOs

Each method used by a user query will be overloaded with two additional parameters - userID and isFiltered. We would like to have a filtered version of \`GetVmInterfacesByVmIdQuery\`, which uses \`VmNetworkInterfaceDAO.getAllForVm(Guid vmID)\`. We will overload this method and create \`VmNetworkInterfaceDAO.getAllForVm(Guid vmID, Guid userID, boolean isFiltered)\`.

##### Hibernate DAO implementations

Currently, will not be supported. If necessary, an additional method that throws \`UnsupportedOperationException\`, and a test that verifies this exception is thrown so when the Hibernate DAO will be implemented that test will break, and the implementor will remember to implement this method too.

#### Permissions Views

A set of n flat views (one per entity type) will be created. The view will hold the userid and entity_id and fields will implement the flattened logic of permissions. E.g., if it's decided that permissions on pool grant read permissions on the VMs inside it, this will be exposed in the \`vm_permissions_view\` view. Each query implementation will be responsible for joining with the appropriate permissions view. Thus, permissioning logic will only be implemented in a single place (per type, unfortunately) instead of inside each query.

#### Stored Procedures

Each stored procedure used by a user query will have two parameters added to it - user_id (UUID) and is_filtered (boolean).

### Additional Considerations

#### UI

The UI will now have to pass the context (\`runAsUser\`) differently for webadmin and userportal UIs.

#### Admin Login

Can (and should be) cancelled. Hallelujah.

<Category:Template> <Category:DetailedFeature>

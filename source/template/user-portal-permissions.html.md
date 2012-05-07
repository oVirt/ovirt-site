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

Today, the User Portal exposes all the objects under an entity if any permission is given on that entity or on the reflecting entities (add link to explanation what is reflecting entities). This behaviour is correct for "manipulate" and "use" permission, but not for "create" permissions. E.g. If a user has the permissions to create a VM in a cluster, he sould not be able to see all the VMs in that cluster.

Following is a detailed description of the behavior for each entity type.

*   Data Center - Create VM/Template permission will not grant the ability to view VMs/Templates in the DC.
*   Cluster - Create VM/Template permission will not grant the ability to view VMs/Templates in the cluser.
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

<<TableOfContents>>

# Writing a New User Query

### What Are User Queries?

User queries are, in a nutshell, queries that can be run a regular user, without requiring admin permissions.

### The General Case

In the general case, your query will call one of the DAOs, which, in turn, will call a stored procedure in the database. When writing a User Query, there are several aspects you must address.

#### Permission View

Each entity with managed permissions has its own flattened view of user permissions called user_OBJECT_NAME_permissions_view (e.g., VM permissions are listed in user_vm_permissions_view). Notes:

      1. The view only lists `**`user`**` permissions.  A user that has administrator permissions on an object will not be represented here.
      1. The view flattens object hierarchies. E.g., if a user should be able to query a VM since he has permissions on the Storage Pool containing it, that user permission will appear in the VM view. You do not have to handle it yourself.
      1. The view flattens group hierarchies. E.g., if a user should be able to query a VM since a group he's contained in has permissions on the VM, that user permission will appear in the VM view. You do not have to handle it yourself.

#### Stored Procedure

The stored procedure should, besides the parameters involved in the query's logic, contain two more parameters - (UUID) and a BOOLEAN flag. If is only the objects the user has permissions on should be returned. If it's , the should be ignored.

The query inside the stored procedure should have a part of the where clause which represents this, as follows:

#### DAO

The DAO should contain two overloaded methods - one with the and parameters and one without, which assumes its run as an administrator and passes and , respectively, to the first flavor.

e..g:

#### Query

The parameter is available by the method. The parameter is available from the query paramters by the method.

e.g.:

#### VdcQueryType

In order for your new query to be treated as a User Query, add a new entry for it in the VdcQueryType enum, with the optional parameter. e.g.:

##### Testing your Query

A test case should be written for each new query. You should extend , and thus recieve the following services:

      1. `` - returns the query to use in the test, with a mocked up user
      1. `` - return `**`a` `mock`**` parameter object the query was constructed with. You can add additional behavior to it using `` statements.
      1. `` - returns the mocked user running the query
      1. `` - returns a power-mocked instance of ``. You can add additional behavior to it (e.g., adding mocks for specific DAOs) using `` statements.
      1. `` - tests your query was indeed marked as a user query. Is run from the base class, and does not need to be called explicitly.

### Queries with a User ID as a parameter

These queries essentially filter their results according to user ID in any case, so no special database treatment is needed. However, there is a mechanism that assures a user that does not have admin permissions could not initiate such a query with a different user's ID,

#### Query

Simply extend the class. It's already implements the logic detailed above, so you should not override it. Instead, it provides two methods for this logic:

      1. getPrivilegedQueryReturnValue() - the value the query returns in case the user has privileges to execute it (i.e., is an admin or is querying his own objects). Should be implemented in your query.
      1. getUnprivilegedQueryReturnValue()  - the value the query returns in case the user does not have privileges to execute it (i.e., isn't an admin and isn't querying his own objects). The default implementation returns an empty list.

e.g.:

------------------------------------------------------------------------

      . CategoryRhevmBackend

<Category:Template> <Category:DetailedFeature>

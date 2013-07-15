---
title: Gluster Hooks Management
category: feature
authors: kmayilsa, prasanth, sahina, shireesh
wiki_category: Feature
wiki_title: Features/Gluster Hooks Management
wiki_revision_count: 28
wiki_last_updated: 2014-12-22
---

# Gluster Hooks Management

### Summary

This feature allows the user to manage the gluster hooks(Volume lifecycle extensions) from oVirt Engine. With this the user can view the list of hooks available in the hosts along with their statuses. The user will be able to enable or disable hooks and view the content s of them.

To read more about gluster hooks <http://www.gluster.org/community/documentation/index.php/Features/Hooks>

### Owner

*   Feature owner: Shireesh Anjal <sanjal@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Sahina Bose<sabose@redhat.com>
    -   VDSM Component owner: Balamurugan Arumugam <barumuga@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

### Current Status

*   Status: In Development
*   Last updated: ,

### Design

#### Entity Description

##### GlusterHook

GlusterHook is the entity that represents the gluster hook in the cluster. It has the following properties

1.  Gluster command
2.  Stage
3.  Hook name (script name)
4.  Hook status (Enabled, Disabled, Missing)
5.  Content type (Binary/Text)
6.  Checksum
7.  Content text (Stored in base64 encoded format)
8.  Conflict Status

Conflict Status is a 3 bit representation of the conflicts found between servers for the hook.

*   Bit 1 - set if there's conflict in content
*   Bit 2 - set if there's conflict in status
*   Bit 3 - set if the hook script is missing in one of the servers

##### GlusterServerHook

GlusterServerHook entity represents the hook's properties in each server of the cluster. Properties :

1.  Hook Id
2.  Server Id
3.  Hook Status
4.  Content type
5.  Checksum

Note that the content of each server's hook is not stored in the engine. It is retrieved from the server when required (while resolving conflicts betweek hook scripts)

#### CRUD

*   Gluster Hooks are added whenever a cluster is imported. The hooks that exist in the cluster will be added to the database.
*   Gluster Hooks are also added as part of a routine sync operation. There will be a periodic job that looks for new hooks in cluster. If found, the database will be updated with the new hook details
*   'GlusterHooksRefreshRate' configuration will determine the frequency of the hooks sync operation (Defaults to 1 Hr).
*   Engine copy of the hooks will be treated as master copy while searching for/resolving conflicts

#### User Experience

##### Hooks Tab

![](Gluster-Hooks-table.png "Gluster-Hooks-table.png")

##### Resolving Conflicts

![](Gluster-Hooks-conflicts.png "Gluster-Hooks-conflicts.png")

#### Installation/Upgrade

#### User work-flows

*   On click of a gluster supported cluster, a Gluster Hooks sub-tab is shown which lists the hooks in the cluster.
*   An admin should be able to enable/disable a hook on all nodes in the cluster by selecting it.
*   Content of the hook can be viewed by clicking the 'View Contents' button if the hook content type is 'Text'.
*   An 'Exclamation' against a hook denotes, either there is a conflict in hook content/status across the servers in the cluster or the hook script is missing in one or more servers.
*   If there are conflicts in hook scripts across the servers in the cluster, administrator will have the option to resolve it. This will open a new window for conflict resolution.

#### Resolving the Conflicts

As the hooks present in the servers are periodically synchronized with engine database, there may be a chance of conflicts of the following types

*   Content Conflict - content of the hook is different across servers
*   Status Conflict - status of the hook is different across servers
*   Content + Status Conflict - both content and status of the hook is different across servers
*   Missing - One or more servers of the cluster doesn't have the hook

#### Events

*   Periodic polling for hooks will report changes in hook and new hook scripts found in the events manager

### Dependencies / Related Features and Projects

### Documentation / External references

<http://www.gluster.org/community/documentation/index.php/Features/Hooks>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/Gluster_Hooks_Management>

### Open Issues

### Test Cases

**\1**

*   Manually create one or more hooks in the RHS servers from its back-end.
*   Click on "Clusters" and select a <Cluster>
*   Click on the "Gluster Hooks" sub-tab which will list all the hooks in the cluster.
*   Select any disabled Hook and click on "Enable"

'' Expected Results: ''

1.  Enable button/option should be seen (for disabled hooks) when viewing the list of hooks
2.  Should be able to click on enable button/option so that the hook is enabled on all nodes in the cluster
3.  Event message should be generated for the above action
4.  The status of the Hook should now be changed to "Enabled"

**\1**

*   Create and Enable one or more hooks using the step [3] in Setup
*   Click on "Clusters" and select a <Cluster>
*   Click on the "Gluster Hooks" sub-tab and it lists the hooks in the cluster
*   Select any Hook and click on "Disable"

'' Expected Results: ''

1.  Disable button should be seen (for enabled hooks) when viewing the list of hooks
2.  Should get a confirmation pop-up window
3.  Event message should be generated for the above action
4.  The status of the Hook should now be changed to "Disabled"

**\1**

*   Click on "Clusters" and select a <Cluster>
*   Click on the "Gluster Hooks" sub-tab and it lists the hooks in the cluster
*   Select the created Hook with type 'Text' and click on "View Content"

'' Expected Results: ''

1.  Content of the hook can be viewed in a pop-up ONLY if the hook content type is 'Text'.

*' \* Test case 4- Resolve Conflicts : Missing (Copy the hook to all the servers)*'

'' Expected Results: ''

**\1**

**\1**

**\1**

**\1**

**\1**

**\1**

**\1**

**\1**

**\1**

**\1**

**\1**

**\1**

*' \* Test case 11:- Try to DISABLE a hook in a cluster having atleast one server in UP state*'

**\1**

*' \* Test case 12:- Try to ENABLE a hook in a cluster having atleast one server in UP state*'

**\1**

*' \* Test case 13:- Resolve Conflicts : Missing (Remove the missing hook)*'

**\1**

*' \* Test case 14:- Create all 3 Conflicts: Content + Status + Missing*'

**\1**

*' \* Test case 15:- Resolve all 3 Conflicts: Content + Status + Missing*'

**\1**

<Category:Feature>

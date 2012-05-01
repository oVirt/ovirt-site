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

# User Portal Permissions

### Summary

This page details how the User Portal decides what objects to display, specifically in relation to create permissions.

### Owner

*   Name: [Allon Mureinik](User:Amureini)
*   Email: amureini@redhat.com

### Current status

*   Target Release: 3.1
*   Status: work in progress
*   Last updated date: 01/05/2012

### Detailed Description

#### Inheriting Permissions

Today, the User Portal exposes all the objects under an entity if any permission is given on that entity. This behaviour is correct for "manipulate" and "use" permission, but not for "create" permissions. E.g. If a user has the permissions to create a VM in a cluster, he sould not be able to see all the VMs in the cluster.

Following is a detailed description of the behavior for each entity type.

*   Data Center - Create VM/Template/Pool permission will not grant the ability to view objcets contained in the DC.
*   Cluster - Create VM/Template/Pool permission will not grant the ability to view objcets contained in the cluser.
*   Storage Domain - Create VM/Template/Disk permission will not grant the ability to view objcets contained in the storage domain.

#### Creartor Roles

Two new predefined roles should be added - VM Creator and Tempalate Creator, which only contain the action groups for adding VMs/Templates, respectively, and do not allow users to manipulate existing entities. These new roles will be the way administrators will grant their users the ability to create new VMs/Templates without exposing existing ones.

### Template Operator Roles

A new predifined role should be added - Template Operator. This role will allow the modification of an existing template, and would be given to a user who issues a CreateVMTempalteCommand on the template he created.

#### Entity Description

No new entities are required for this feature.

#### CRUD

No new entities are required for this feature.

#### User Experience

See Inheriting Permissions.

#### Installation/Upgrade

The three new predifined roles should be created.

#### User work-flows

===== Adding a VM ==== 1. The admin grants the VM Creator permission to a user on a host/cluster 2. The user can create a new VM on the host/cluster 3. Once the user creates the VM, he becomes a VM Operator on this VM

#### Events

No new events are added.

### Dependencies / Related Features and Projects

N / A

### Documentation / External references

N / A

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

*   Should Create Host permissions be inherited for viewing?
*   Should we grant VM/Template Creator to any user who is a VM/Template Admin?
*   How do Disk Permissions integrate with this solution?

<Category:Template> <Category:DetailedFeature>

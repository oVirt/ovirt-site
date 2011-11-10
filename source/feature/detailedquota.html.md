---
title: DetailedQuota
category: feature
authors: amureini, jumper45, lpeer, mlipchuk, ovedo, sandrobonazzola
wiki_category: Feature|Quota
wiki_title: Features/DetailedQuota
wiki_revision_count: 129
wiki_last_updated: 2015-01-16
wiki_warnings: list-item?
---

# Detailed Quota

## Quota

### Summary

Quota provides a way for the Administrator to limit the resource usage in the System.

### Owner

*   Feature owner: [ Maor Lipchuk](User:mlipchuk)

    * GUI Component owner: [ Gilad Chaplik](User:gchaplik)

    * REST Component owner: [ Michael Pasternak](User:mpasternak)

    * Engine Component owner: [ Maor Lipchuk](User:mlipchuk)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: mlipchuk@redhat.com

### Current status

*   Target Release:
*   Status: Design Stage
*   Last updated date: Wed November 10 2011

### Detailed Description

Today, when consuming resources from the Data Center, such as storage (when creating a new virtual disk) and virtual CPUs/RAM (when running VMs), the user is only limited by the available resources. Thus, there is no way to limit the resources that can be used by a user. This limitation is problematic, especially in multi-tenant environments.

Quota provides the administrator a mechanism for managing resources allocation for users and groups in the Data Center.
This mechanism allows the administrator to manage, share and monitor the resources in the Data Center.

#### Entity Description

##### Quota

Quota is a new (searchable) object in the system, which contains the following properties:

1.  Name
2.  Description
3.  Data Center which is referenced to.
4.  List of unlimited number of specific rules, where each rule should specify a resource and resource limitation parameters.
5.  List of Users/Groups that have permission to use the Quota, i.e. assign it to VMs/disks

For example, the following Quota configuration, is for R&D team:

1.  Name: DevelQuota
2.  Description: Quota configured for R&D team
3.  Data Center: Devel_Data_Center
4.  Resource limitations:
    -   VCPU/Memory limitations:
        -   Cluster1: 6 VCPUs, 9GB RAM
        -   Cluster2: 8 VCPUs, 12GB RAM
    -   Storage Limitations:
        -   Storage Domain1: 20GB
        -   Storage Domain1: 10GB
        -   Storage Domain3: 50GB

5.  List of Users/Groups:
    -   developers
    -   team_leaders
    -   new_developer

The limitation on a resource can be specified either on a specific resource (see example above) or globally.
The global resource defines limitation on the Data Center for a specific type of resource (storage or runtime).

For example, The following limitations, are indicating global limitation on the Cluster and the Storage:

*   Global Cluster: 14 VCPUs, 21GB RAM
*   Global Storage: 80GB

A Quota limitation can be also set to unlimited (both globally, or on a specific resource).
The following Quota is an example with unlimited limitation on both global and specific resources:

*   Global Cluster: Unlimited
*   Storage Domain1: Unlimited
*   Storage Domain2: 50GB
*   Storage Domain3: Unlimited

##### Data Center

The Quota object is in the data center scope. Also, a Data Center must be related to at least one Quota object.
Each Data Center entity is configured with one of the following operation modes:

1.  Disable - The Data Center would not be subjected to Quota restrictions.
2.  Audit - Only warning messages would be performed when Quota restrictions will be violated.
3.  Enforce - Will be enforced the restrictions completely and should prevent the command from executing.

#### CRUD

*   Quota object can be removed only if there are no entities such as VM or Template that are referencing it.
*   Quota object can be edited; When a Quota is edited, the change should apply to all the entities that are assigned to this Quota.
*   Quota object parameters modifications can result in exceeding the resource limitations:

    * reducing the disk limitation of some storage domain

    * reducing CPU/RAM limitation

    * removing a user from the list of users permitted to use the quota

All the above will not cause a violation. However, no one will be able to consume more resources from the quota. Even when resources are released to follow the Quota limitation, no user will be able to exceed the Quota resources again.

Also, if a user was removed from a list of permitted user it also won't cause a violation. However, that user won't be able to use this quota again, unless permitted to.

#### User Experience

*   The Administrator will be able to create/edit a Quota using a wizard.
    The wizard should allow administrators to configure Cluster Quota parameters, storage Quota parameters, and assign users which will be able to consume the Quota resources.
*   For supporting definition of Quota per user, the Quota can be cloned.
    Such a clone procedure should copy all the Quota properties except of the name and the description.
*   Users assigned to the Quota would need a power user permission on the consumable resources (for example when add/edit a VM). The wizard should enable automatic addition of these permissions.
    However, no permissions will be removed when removing resources from the Quota, but an alert message will be presented as follow:

*`Attention,` `Quota` `${QuotaName}` `resources` `have` `been` `changed.` `If` `needed,` `update` `relevant` `permissions` `accordingly`*`.`

*   Note, that the user who created the Quota object would not necessarily have permissions, to consume from it.
    Administrator should also have an aggregated view of defined Quotas vs actual storage space used/free.

![](/tmp/dc.png "/tmp/dc.png")

#### Installation/Upgrade

*   Upon upgrade or new installation, each Data Center should be assigned with an unlimited Quota.
*   For each Data Center, all objects (disks and VM's) in the DC will be assigned to the unlimited Quota, and all the users in the setup will be permitted to use it.
*   The new/upgraded Data Center, will be set with disabled mode by default (which means it won't be subjected to the quota restrictions).
*   When the administrator choose to use the Quota mechanism, he should change the Data Center Quota mode to audit or enforce.
*   After the administrator configure new quotas for the DC, he should remove permissions from the unlimited quota to avoid users consuming resources for it.

#### User work-flows

The Administrator Portal should allow the following operations:

*   View/edit/create Quota's
*   View/edit/create the User's roles and Quotas
*   View Quota per resource (User/Storage domain etc.)

The Power User Portal should allow the following operations:

*   View Quota's defined/used for himself
*   Use Quota upon resource usage (runtime and storage)

#### Enforcement

*   Quota runtime limitation should be enforced during VM execution.
*   Quota storage limitation should be enforced upon any disk creation.
*   When dealing with QCOW disks (which is not pre-allocated, like templates or stateless VM) the Quota should consume the total maximum size of the disk, since it is the potential size that can be used.
*   In the future Quota should also have enforcement for network usage and storage throughput.

#### Notification

*   Quota will have a threshold configured to alert when the Quota is about to be full.
*   The threshold will be configured for the Administrator and for the User.
*   The default value for administrators is 60%, and for regular users is 75%.
*   When Quota reaches the threshold limit, an audit log notification should be performed to the Administrator or the User.
*   User audit log should be:

*`Attention,` `Quota` `$(Quota_Nmae)` `threshold` `limit` `$(Quota_Threshold_User)` `has` `been` `reached,` `please` `advise` `the` `Administrator` `for` `further` `action.`*

*   Administrator audit log should be:

*`Attention,` `Quota` `$(Quota_Nmae)` `threshold` `limit` `$(Quota_Threshold_User)` `has` `been` `reached.`*

Quota will also have a configurable grace percentage, for the user to have a chance to consume resources even if the Quota has exceeded the limit.
The configured default grace should be 20% of the Quota resources limitations,
When user starts to use the grace percentage, a notification event should be triggered both to the administrator, and the user which exceeded this limit.
When Quota reaches its resources limit, it will be able to consume resources depending on the grace percentage configured in it.
An audit log warning message should be performed to the User and the Administrator, as follows:
 *Quota $(Quota_Name) has been reached its resource limit. User {UserName} using the grace for the following resource parameters ${resource}.*

#### Events

The Administrator, will be able to set an email event, when Quota resources exceeded their limit.

### Dependencies / Related Features and Projects

*   Quota is not depended on outside features, and should be managed only in the engine core scope.
*   When handling plug/unplug disks or attach/detach disks, the entity will still consume resources from its configured original Quota it was created on.

### Documentation / External references

<http://www.ovirt.org/wiki/Features/Quota>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/Quota>

### Open Issues

*   There should be a new business entity which will represent a group of storage domains as one unit.
    The new business entity will be named, Virtual Storage Group, and should be referenced in the quota as a business entity and have storage restrictions on it.
*   Enforcement of network usage and storage throughput using the Quota entity.
*   Add historic Quota utilization to history database.

---
title: DetailedQuota
category: feature
authors: amureini, jumper45, lpeer, mlipchuk, ovedo, sandrobonazzola
---

# Detailed Quota

## Quota

### Summary

Quota provides a way for the Administrator to limit the resource usage in the System.

### Owner

*   Feature owner: Maor Lipchuk (mlipchuk)

    * GUI Component owner: Gilad Chaplik (gchaplik)

    * REST Component owner: Michael Pasternak (mpasternak)

    * Engine Component owner: Maor Lipchuk (mlipchuk)

    * QA Owner: Yaniv Kaul (ykaul)

*   Email: mlipchuk@redhat.com

### Current status

*   Target Release:
*   Status: Design Stage
*   Last updated date: Wed November 10 2011

### Detailed Description

Today, when consuming resources from the Data Center, such as storage (when creating a new virtual disk) and virtual CPUs/RAM (when running VMs), the user is only limited by the available resources. Thus, there is no way to limit the resources that can be used by a user. This limitation is problematic, especially in multi-tenant environments.

Quota provides the administrator a logic mechanism for managing resources allocation for users and groups in the Data Center.
This mechanism allows the administrator to manage, share and monitor the resources in the Data Center from the engine core point of view.

#### Entity Description

##### Quota

Quota is a new searchable object in the system, which contains the following properties:

1.  Name
2.  Description
3.  Data Center, for which the quota applies.
4.  List of unlimited number of rules, where each rule should specify a resource and resource limitation parameters.
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

For example the following limitations represent global limitation on the Cluster and the Storage:

*   Global Cluster: 14 VCPUs, 21GB RAM
*   Global Storage: 80GB

A Quota limitation can be also set to unlimited (both globally, or on a specific resource).
The following Quota is an example of unlimited quota on both global and specific resources:

*   Global Cluster: Unlimited
*   Storage Domain1: Unlimited
*   Storage Domain2: 50GB
*   Storage Domain3: Unlimited

##### Data Center

The Quota object is in the data center scope. Also, a Data Center must be related to at least one Quota object.
Each Data Center entity is configured with one of the following operation modes:

1.  Disable - The Data Center would not be subject to Quota restrictions.
2.  Soft Limit - Only warning messages would be issued when Quota restrictions are violated.
3.  Hard Limit - Enforced the restrictions completely and prevent the resource allocation.

See more info in the [Installation/Upgrade](#installationupgrade) section

#### CRUD

*   Quota object can be removed only if there are no entities such as VM or Template that are referencing it.
*   Quota object can be edited; When a Quota is edited, the change should apply to all the entities that are assigned to this Quota, but only for future allocations of resources.

Quota object parameters modifications can result in exceeding the resource limitations:

    * reducing the disk limitation of some storage domain

    * reducing CPU/RAM limitation

    * removing a user from the list of users permitted to use the quota

All the above will not cause a resource deallocation. However, users will not be able to exceed the Quota limitations again after the resources are released.

Also, if a user was removed from the list of permitted users it won't result in an immediate interruptive action. However, that user won't be able to use this quota again, unless permitted to.

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

The following UI mockups contain guidelines for the different screens and wizards:

![](/images/wiki/Dc.png)

![](/images/wiki/New_quota_on_clusters_add.png)

![](/images/wiki/New_quotaon_clusters.png)

![](/images/wiki/New_quotaon_clusters_statistics.png)

![](/images/wiki/New_quotaon_dc.png)

![](/images/wiki/New_quotaon_dcadd.png)

![](/images/wiki/Quota.png)

![](/images/wiki/Statistic.png)

![](/images/wiki/Users.png)

#### Installation/Upgrade

*   For a new/upgraded Data Center, the default operation mode will be 'disabled' (which means it won't be subject to any quota restrictions).
*   For a new/upgraded Data Center an unlimited Quota will implictly be created and attached to all the objects in it. All the users will be permitted to use it.
*   When the administrator chooses to enable the Quota mechanism he should consider removing the permission of the unlimited quota. In addition, the existing resources will consume the unlimited quota, the administrator should consider changing that as well.
*   On upgrade, an automatic Default Quota for each DC will be created, with permissions for everyone, and unlimited space for storage and cluster use.
    When the Data Center is at disabled mode, the Default Quota will be the one that all the resources consumed from, and when the DC will become active, this default quota will behave as a regular quota.
    User can edit the default quota only when the Data Center quota mode is not disabled. When a user will edit the Default Quota, the quota will loose its default flag, and the user will need to change the quota name prefix.
    When the user will change the Data Center back to disabled, there will be a check whether default quota was changed or not.
    If the Default Quota was not changed then the default quota will stay the same and permission for Everyone will be added to it.
    If no default quota was found, which means the default quota was changed during when the Data Ceneter was not disabled, then a new default quota should be created with a default name.

#### User work-flows

The Administrator Portal should allow the following operations:

*   View/edit/create Quota's
*   View Quota per resource (User/Storage domain etc.)

The Power User Portal should allow the following operations:

*   View Quota's defined/used for himself
*   Consume Quota upon resource usage (runtime and storage)

#### Enforcement

*   Quota runtime limitation should be enforced during VM execution.
*   Quota storage limitation should be enforced upon any requirement for storage allocation.
*   When dealing with QCOW disks (which is not pre-allocated, like templates or stateless VM) the Quota should consume the total maximum size of the disk, since it is the potential size that can be used.
*   In the future Quota can be extended to have enforcement for network usage, storage throughput etc.

#### Notification

*   Quota will have a threshold configured to alert when the Quota is about to be full.

    * The threshold will be configured for the administrator and for the User. The default value for administrators is 60%, and for regular users is 75%.

    * When Quota reaches the threshold limit, an audit log notification should be issued to the Administrator or the User.

    * User audit log should be:

*`Usage` `on` `resource` `$(Resource)` `in` `Quota` `$(Quota_Name)` `has` `reached` `the` `configured` `threshold` `${Threshold_User_Percentage}.` `Please` `contact` `your` `system` `administrator.`*

    * Administrator audit log should be:

*`Usage` `on` `resource` `$(Resource)` `in` `Quota` `$(Quota_Name)` `has` `reached` `the` `configured` `threshold` `${Threshold_Admin_Percentage}.`*

*   Quota will also have a configurable grace percentage, for the user to have a chance to consume resources even if the Quota has exceeded the limit.

    * The configured default grace should be 20% of the Quota resources limitations.

    * When user starts to use the grace percentage, a notification event should be triggered both to the administrator, and the user which exceeded this limit.

    * When Quota reaches its resources limit, it will be able to consume resources depending on the grace percentage configured in it.

    * An audit log warning message should be issued to the User and the administrator:

*`Usage` `on` `resource` `$(Resource)` `in` `Quota` `$(Quota_Name)` `has` `reached` `its` `limit` `due` `to` `an` `action` `made` `by` `user` `${UserName}.`*

#### Events

The Administrator, will be able to set an email event, when Quota resources exceeded their limit.

### Dependencies / Related Features and Projects

*   Quota is not depended on outside features, and should be managed only in the engine core scope.
*   When handling plug/unplug disks or attach/detach disks, the entity will still consume resources from its configured original Quota it was created on.

Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

### Documentation / External references

[Features/Quota](/develop/release-management/features/sla/quota.html)



### Future Work

*   There should be a new business entity which will represent a group of storage domains as one unit.
    The new business entity will be named, Virtual Storage Group, and should be referenced in the quota as a business entity and have storage restrictions on it.
*   Enforcement of network usage and storage throughput using the Quota entity.
*   Add historic Quota utilization to history database.

### Open Issues

*   Grace Limit - Grace limit should be relinquish for now, since the threshold property should be good enough, for the alert functionality, the administrator needs.
*   Email Notifications - The administrator will use the notification service for the Quota threshold event messages, to configure which users, will get notification email on Quota that exceeded the threshold. (We should consider using postponed notifications, to avoid flood).
*   Quota Feature Scope - Just to clarify, Quota is designed from the billing POV and not from the hardware point of view, It will only be managed in the ovirt-engine scope.


---
title: Quota
category: sla
authors: doron, gchaplik, jumper45, lpeer, mlipchuk, ovedo, sandrobonazzola
wiki_category: SLA
wiki_title: Features/Quota
wiki_revision_count: 32
wiki_last_updated: 2015-05-10
wiki_warnings: list-item?
---

# Quota

### Summary

Quota provides a way for the Administrator to limit the resource usage in the System.

### Owner

*   Feature owner: [ Gilad Chaplik](User:gchaplik)

    * GUI Component owner: [ Gilad Chaplik](User:gchaplik)

    * REST Component owner: [ Michael Pasternak](User:mpasternak)

    * Engine Component owner: [ Gilad Chaplik](User:gchaplik)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: gchaplik@redhat.com

### Current status

*   Target Release:
*   Status: Development Stage
*   Last updated date: Tue July 17 2012

### Detailed Description

Today, when consuming resources from the Data Center, such as storage (when creating a new virtual disk) and virtual CPUs/RAM (when running VMs), the user is only limited by the available resources. Thus, there is no way to limit the resources that can be used by a user. This limitation is problematic, especially in multi-tenant environments.

Quota provides the administrator a logic mechanism for managing resources allocation for users and groups in the Data Center.
This mechanism allows the administrator to manage, share and monitor the resources in the Data Center from the engine core point of view. When working with quota, you still need to set the permissions.
The quota will only limit the usage of the DC resources.
For example:

*   If you want a user to be able to create VMs, disks and etc., you need to give him VmCreator in the relevant DC.
*   If you want to limit him to a certain cluster, you will have to give him VmCreator in this cluster, and DiskCreator in relevant DCs/SDs.
*   If you want to further limit the resource consumption, you'll have to enable quota in the DC, create the relevant quota, and define the user as a quota consumer (in the consumers sub tab).
*   Defining the user as a quota consumer only, won't allow him to login to UP (as the underlined implementation for the Quota Consumption is done via roles, and the relevant role doesn't have login permissions).

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

See more info in the [Installation/Upgrade](#Installation/Upgrade) section

#### CRUD

*   Quota object can be removed only if there are no entities such as VM, Template or Disks that are referencing it.
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
*   Since quota is an entity in data center scope, the quota main tab will be visible only when selecting a data center in the tree navigation panel.

The following UI mockups contain guidelines for the different screens and wizards:

![](dc.png "dc.png")

![](new_quota_on_clusters_add.png "new_quota_on_clusters_add.png")

![](new_quotaon_clusters.png "new_quotaon_clusters.png")

![](new_quotaon_clusters_statistics.png "new_quotaon_clusters_statistics.png")

![](new_quotaon_dc.png "new_quotaon_dc.png")

![](new_quotaon_dcadd.png "new_quotaon_dcadd.png")

![](quota.png "quota.png")

![](statistic.png "statistic.png")

![](users.png "users.png")

#### Installation/Upgrade

*   For a new/upgraded Data Center, the default operation mode will be 'disabled' (which means it won't be subject to any quota restrictions).

<!-- -->

*   When the administrator chooses to enable the Quota mechanism, He needs to reference all existing objects in Data Center to a valid quota, in Audit (/permissive/soft limit) mode, the administrator will still be allowed to work without quota, but in order to move to enforce mode, all the objects should refer to a quota.

#### User work-flows

The Administrator Portal should allow the following operations:

*   View/edit/create Quota's
*   View Quota per resource (User/Storage domain etc.)

The Power User Portal should allow the following operations:

*   View Quota's defined/used for himself
*   Consume Quota upon resource usage (runtime and storage)

In order to assign a Quota to multiple entities (VM/Disk), one can select multiple lines from the VM/Disk grid, and use the 'Assign Quota' button in the main button panel (the button is available only when selecting a Quota enabled Data Center in the tree pane).

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

<http://www.ovirt.org/wiki/Features/Quota>
<http://www.ovirt.org/wiki/Features/Design/Quota>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/Quota>

### Future Work

*   UI - would be handled in a following patch (the information is accessible through REST)
*   possibly further inspection of permissions

### Open Issues

*   Email Notifications.
*   Copy template disk, the quota will be counted only one time.
*   Snapshots: snapshots won't be taken into account when checking remaining storage quota.

### Acronyms / Abbreviation

*   DC: Data Center
*   SD: Storage Domain
*   UP: User Portal

<Category:SLA> [Category: Feature](Category: Feature)

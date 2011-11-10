---
title: DetailedQuota
category: feature
authors: amureini, jumper45, lpeer, mlipchuk, ovedo, sandrobonazzola
wiki_category: Feature|Quota
wiki_title: Features/DetailedQuota
wiki_revision_count: 129
wiki_last_updated: 2015-01-16
---

# Detailed Quota

## Quota

### Summary

Quota provides a way for the Administrator to limit the resource usage in the System. [ Quota](Features/Quota)

### Owner

*   Feature owner: [ Maor Lipchuk](User:mlipchuk)

`* GUI Component owner: `[ `Gilad` `Chaplik`](User:gchaplik)
`* REST Component owner: `[ `Michael` `Pasternak`](User:mpasternak)
`* Engine Component owner: `[ `Maor` `Lipchuk`](User:mlipchuk)
      * QA Owner: `[ `Yaniv` `Kaul`](User:ykaul)` 

*   Email: mlipchuk@redhat.com

### Current status

*   Target Release:
*   Status: Design Stage
*   Last updated date: Wed Nob 9 2011

### Detailed Description

When a User consume resources in the Data Center, such as creating a new virtual Disk on Storage Domain, or running VM with number of VCPU on a Host,
the User is not limited, and can consume the maximum limit of the resources, by doing that, other users will be choked from using resources in the Data Center.

Quota is a feature which should provide the Administrator a better management way, for managing resources for different Users.
The feature allows the Administrator to manage and share the resources in the Data Center, more appropriately, and observe the resources in a more convenient way.

#### Entity Description

The Quota is a new (searchable) Object in the system, which contains the following properties:

1.  Name
2.  Description
3.  Data Center which is referenced to.
4.  List of unlimited number of specific rules, where each rule should specify a resource and resource limitation parameters.
5.  List of Users/Groups that have permission to use the Quota, i.e. assign it to VMs/disks

The following configuration is an example of R&D Quota:

*   *Name*: DevelQuota
*   *Description*: Quota configured for R&D team
*   *Data Center*: Devel_Data_Center

*VCPU/Memory limitations:*

*   Cluster1: 6 VCPUs, 9GB RAM
*   Cluster2: 8 VCPUs, 12GB RAM

*Storage Limitations:*

*   Storage Domain1: 20GB
*   Storage Domain1: 10GB
*   Storage Domain3: 50GB

*List of Users/Groups:*

*   user1
*   group2

A limitation on a resource, can be specified, like specific Cluster or Storage Data, although the limitation can also be defined for global resource as well.
The global resource defines limitation on the Data Center for a specific type (Storage or runtime).
Note that runtime resources, can be referenced as one entity to limit. (Although, for now, Storage Domains will not be supported).

For example, The following limitations, are indicating global limitation on the Cluster and the Storage:

*   Global Cluster: 14 VCPUs, 21GB RAM
*   Global Storage - 80GB

A Quota, can be indicated as an *unlimited* Quota, when it is configured with global resources with no specific limit.
The following limitations are an example of an unlimited Quota:

*   Global Cluster: Unlimited
*   Global Storage - Unlimited

Quota is dedicated to a single Data Center, but each Data Center can be related to at least one Quota.
Each Data Center entity, configured with the verification strategy, it should enforce by the Quotas related to it.
<<Anchor(DataCenterQuotaStages)>> The verification strategy is configured in the Data Center entity, and has three stages:

1.  Disable - The Data Center would not be subjected to Quota restrictions.
2.  Audit - Only warning messages would be performed when Quota restrictions will be violated.
3.  Enforce - Will be enforced the restrictions completely and should prevent the command from executing.

The VM Properties (like number of VCPU and memory consumption) are enforced during VM execution.

#### CRUD

*   Quota can be removed only if there are no entities such as VM or Template, that are referenced to this Quota.
*   Quota can be edited; When a Quota is edited, the change should apply to all the entities and users that are assigned to this Quota.
*   Quota parameters can be edited, in a way resulting, exceeding the resources limitation (for example, reducing the disk limitation of some storage domain). This case will not result violation. However, once resources will be released to follow the Quota limitation, no user will be able to exceed the Quota resources again.

#### User Experience

*   the Administrator will be able to create/edit a Quota using a wizard, to configure Cluster Quota parameters, Storage Quota parameters, and Users which will be able to consume those Quota resources.
*   For supporting definition of Quota per User, the Quota can be cloned.
     Such a clone procedure should copy all the Quota properties except of the name and the description.
*   Since the Users assigned to the Quota, would need a power user permission on the Data Center to add/edit a VM, the Administrator should be able to add these permissions automatically, if he desires to.
     This automatic assignment, should only be affective when adding resources for limitation;
    When reducing resources for limitation, an alert message will be presented as follow:
     *Attention, Quota resources have been changed. Please update the Quota Users permissions on the following resources if needed* .
    Note, that the User, created a Quota, would not necessarily, have permissions, to create/edit entities for using it.
     Administrator should also have an aggregated view of defined Quotas vs actual storage space used/free.

#### Installation/Upgrade

*   Upon upgrade or new installation, each Data Center should be assigned with an unlimited Quota.
*   For each Data Center, all objects (disks and VM's) in the DC will be assigned to the unlimited Quota, and all the users in the setup will be assigned to it as well.
*   The new/upgraded Data Center, will be set with the default mode, which is the disabled mode (which means it won't be subjected to the quota restrictions).
*   When the Administrator choose to use Quota, he should change the Data Center Quota mode to audit or enforce(see Enforcement section)
*   After the Administrator configure the new quotas he desires for the DC, and assign all the objects and users to the new quotas, he should remove permissions from the unlimited quota to avoid users consuming resources for it.

#### User work-flows

The Administrator Portal should allow the following operations:

*   View/edit/create Quota's
*   View/edit /create the User's roles and Quotas
*   View Quota per resource (User/Storage domain etc.)

The Power User Portal should allow the following operations:

*   View Quota's defined/used for himself

#### Enforcement

*   Quota resources should be forced upon creation of disks (new disk, disk from template, plug/unplug attach/detach).
*   Upon plug/unplug or attach/detach disks, the entity will still consume resources from its configured quota.
*   Even in case the VM uses a QCOW disk (which is not pre-allocated), the total maximum size of the disk is taken from its quota, as he may need to use it all.
*   In the future quota should also have enforcement for network usage and storage throughput.

#### Notification

Quota will have a threshold configured to alert when the Quota is about to be full.
The threshold will be configured for the Administrator and for the User.
The default value for the Adminstrator is 60% and the Users will be 75%.
When Quota reaches the threshold limit, an audit log notification should be performed to the Administrator or the User.

*   User audit log should be:

*`Attention,` `Quota` `$(Quota_Nmae)` `threshold` `limit` `$(Quota_Threshold_User)` `has` `been` `reached,` `please` `advise` `the` `Administrator` `for` `further` `action.`*

*   Administrator audit log should be:

*`Attention,` `Quota` `$(Quota_Nmae)` `threshold` `limit` `$(Quota_Threshold_User)` `has` `been` `reached.`*

Quota will also have a configurable grace percentage, for the user to have a chance to consume resources even if the Quota has exceeded the limit.
The configured default grace should be 20% of the Quota resources limitations,
When User starts to use the grace percentage, a notification message, should be performed to the Administrator, and the User which exceeded this limit.
When Quota reaches its resources limit, it will be able to consume resources depending on the grace percentage configured in it.
An audit log warning message should be performed to the User and the Administrator, as follows:
 *Quota $(Quota_Nmae) has been reached its resource limit. User {UserName} using the grace for the following resource parameters ${resource}.*

#### Events

The Administrator, will be able to set an email event, when Quota resources exceeded their limit.

### Dependencies / Related Features and Projects

Quota is not depended on outside features, and should be managed only in the engine core scope.

### Documentation / External references

<http://www.ovirt.org/wiki/Features/Quota>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/Quota>

### Open Issues

*   There should be a new business entity which will represent a group of storage domains as one unit.

The new business entity will be named, Virtual Storage Group, and should be referenced in the quota as a business entity and have storage restrictions on it.

*   Enforcement of network usage and storage throughput using the Quota entity.
*   Add historic Quota utilization to history database.

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

#### Entity Description

The Quota is a new (searchable) Object in the system, A Quota contains the following properties:

1.  Name
2.  Description
3.  Data Center which is referenced to.
4.  A list of unlimited number of specific rules, where each rule should specify a resource and resource limitation parameters.

For example, check the following Quota object, with the following properties: VCPU/Memory limitations:

*   Cluster1: 6 VCPUs, 9GB RAM
*   Cluster2: 8 VCPUs, 12GB RAM

Storage Limitations:

*   Storage Domain1: 20GB
*   Storage Domain1: 10GB
*   Storage Domain3: 50GB

List of Users/Groups that have permission to use the Quota, i.e. assign it to VMs/disks

*   user1
*   group2

The resource to limit, can be specific like Cluster or Storage Data, and can also be defined as a global resource. The global resource define limitation on the Data Center for a specific type. Note that run time resources, can be referenced as one entity to limit. (Although for Storage Domains it will not be supported for now).

For example, a Quota object, with global limitation on the cluster and the storage: VCPU/Memory limitations:

*   Global Cluster: 14 VCPUs, 21GB RAM

Storage Limitations:

*   Global Storage - 80GB

#### CRUD

Quota can be removed only if there are no VMs/Templates that are pointing to this quota. Quota can be edited; When a Quota is edited, the change should apply to all the users that have this quota. Quota parameters can be edited in a way resulting in exceeding it (for example, reducing the disk limitation of some storage domain). This case will not result in a violation. However, once resources will be released to follow the Quota limitation, the user won't be able to exceed the Quota again.

the Administrator will be able to create/edit a quota using a wizard, to configure cluster quota parameters, storage quota parameters, and users which will be able to consume those quota resources.

#### User Experience

User can use more than one Quota Quota should not be defined per user, to support definition of Quota per user, the quota can be cloned.
Such a clone procedure should copy all the quota properties except of the name and the description.
Since the users added to the Quota would need a permission of power user on the DC to add/edit a VM, the Administrator can choose whether to add these permissions automatically.
The automatic assignment would only be affective when adding a limitation on a resource new to the Quota; When removing resources from the Quota, an alert message will be presented.
Note that the user that created the Quota would not necessarily have the permissions to create/edit resources that use it.
 The Administrator Portal should allow the following operations:

         View/edit/create Quota's
         View/edit /create the User's roles and Quotas
         View Quota per resource (User/Storage domain etc.)
         The Power User Portal should allow the following operations:
         View Quota's defined/used for himself 

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

#### Events

What events should be reported when using this feature.

### Dependencies / Related Features and Projects

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.

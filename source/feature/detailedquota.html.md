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

The Quota is a new (searchable) Object in the system, A Quota should contains the following properties:

         1. Name
         2. Description
         3. Data Center which is referenced to.

         4. A list of unlimited number of specific rules, which each rule should specify a resource and resource limitation parameters.
         The limitation is logically separated into different types.
         Each object type has set of rules, according to its type :
         Example for the described list of cluster type:

             [ Cluster1: 6 VCPUs, 9GB RAM - IntelCluster
             Cluster2: 8 VCPUs, 12GB RAM – AmdCluster
             Note that the limitations can be configured for each cluster or a group of clusters.
             For data Quota type object, we will have three different set of rules:
             Unlimited - Indicates on that DC there will be no limitation on data storage,

             Limit per storage - for example:
                 Storage Domain1: 20GB
                 Storage Domain2: 10GB
                 Storage Domain3: 5GB ] 
             Global limitation - Indicates global limitation of storage on that DC (not on specific DS) (example: Global: 100GB) 
         List of Users/Groups that have permission to use the Quota, i.e. assign it to VMs/disks 

Note - Quota should not be supported for 2.2 VM's

#### Entity Description

New entities and changes in existing entities.

#### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

#### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

Describe the high-level work-flows relevant to this feature.

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

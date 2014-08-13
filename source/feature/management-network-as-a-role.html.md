---
title: Management Network As A Role
category: feature
authors: moti, sandrobonazzola, yevgenyz
wiki_category: Feature
wiki_title: Features/Management Network As A Role
wiki_revision_count: 40
wiki_last_updated: 2014-12-08
feature_name: Management network as a role
feature_modules: Networking
feature_status: WIP
---

# Management network as a role

### Summary

This feature is about defining the management network role and attaching it to an arbitrary network in a cluster.

### Owner

*   Name: [ Yevgeny Zaspitsky](User:Yevgenyz)
*   Email: <yzaspits@redhat.com>
*   IRC: yzaspits @ #ovirt (irc.oftc.net)

### Current status

*   Target Release: 3.6
*   Status: design
*   Last updated: -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

#### Motivation

Allow assigning different VLANs to management networks in different clusters under same data center.

#### Entity Description

*   No new entities
*   Management boolean field will be added to NetworkCluster entity.

#### User Experience

The existing "Manage network(s)" screens will be updated with the new column "Management Network". User will be able to change the management network assignement through the screens in the similar way like it's currently done for display network.

#### Installation/Upgrade

*   During the upgrade the new field will be added to *NETWORK_CLUSTER* table and will be populated by
*   The following DB objects will be updated with the new field:
    -   *NETWORK_CLUSTER_VIEW*
    -   Stored procedures:
        -   *GetAllNetworkByClusterId*
        -   *Insertnetwork_cluster*
        -   *Updatenetwork_cluster*
*   New stored procedure *set_network_exclusively_as_management* will be created

<Category:DetailedFeature>

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
feature_status: design
---

# Management network as a role

### Summary

This feature is about attaching the management network role to an arbitrary network in a cluster.

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
*   *Management* boolean field will be added to NetworkCluster entity. *True* value will indicate that the network is the menagement one in the given cluster (similarly like it been done ofr display networks).

#### User Experience

##### UI

1.  The existing "Manage network(s)" screens will be updated with the new column "Management Network". User will be able to change the management network assignement through the screens in the similar way like it's currently done for display network.
2.  The default management network name will be changed from "ovirmgmt" to "Management". That will be used for creating the first default network in a new created data center (the existing 'ovirtmgmt' networks will remain AS IS).
3.  The new mandatory parameter (management network) will be added in "New cluster" screen.

##### RESTful API

1.  As mentioned before NetworkCluster entity will be extended by the new field. That will be reflected through the RESTful API.
2.  The new mandatory parameter (management network) will be added for creating a new cluster API call.

#### Installation/Upgrade

*   During the upgrade the new field (*is_management*) will be added to *NETWORK_CLUSTER* table and will be populated by *true* value for ovirtmgmt networks and *false* for all other networks.
*   The following DB objects will be updated with the new field:
    -   *NETWORK_CLUSTER_VIEW*
    -   Stored procedures:
        -   *GetAllNetworkByClusterId*
        -   *Insertnetwork_cluster*
        -   *Updatenetwork_cluster*
*   New stored procedure *set_network_exclusively_as_management* will be created

### Open Issues

Creating new cluster would have to receive the new parameter (management network). That will break the API backward compatibility.

<Category:DetailedFeature>

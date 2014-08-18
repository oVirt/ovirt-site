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

# Management Network As A Role

## Summary

This feature is about attaching the management network role to an arbitrary network in a cluster.

## Detailed Description

### Motivation

Allow assigning different VLANs to management networks in different clusters under same data center.

### Entity Description

*   No new entities
*   *Management* boolean field will be added to NetworkCluster entity. *True* value will indicate that the network is the management one in the given cluster (similarly like it been done for display networks).

### User Experience

#### UI

1.  The existing "Manage network(s)" screens will be updated with the new column "Management Network". User will be able to change the management network assignement through the screens in the similar way like it's currently done for display network. Choosing a network as the mangement one will make it requiered for that cluster and required field will become disabled while the network is chosen as the management one.
    ![](Manage network.png "fig:Manage network.png")
2.  In order to make sure that every cluster will continue having a management network 2 approaches could be taken:
    1.  The new parameter (management network) will be added in "New cluster" screen. The parameter will have the default value of *ovirtmgmt* and the user will be able to choose any other network as the management one. In case that isn't exist it will be created. According to this approach no network has to be created upon a DC creation.
        ![](Create cluster.jpg "fig:Create cluster.jpg")
    2.  *ovirtmgmt* network will be created upon DC creation and its delting will be forbidden. That way will make sure that the network will exist and will use that upon a cluster creation as the management network in the cluster.

#### RESTful API

1.  As mentioned before NetworkCluster entity will be extended by the new field. That will be reflected through the RESTful API.
2.  A request that will make a management network non-required will fail.
3.  The new optional parameter (management network) will be added for creating a new cluster API call (depends on the approach taken in [point 2 of UI](#UI))

Optionally: the default management network name will be changed from "ovirmgmt" to "Management". That will be used for creating the first default network in a new created data center (the existing 'ovirtmgmt' networks will remain AS IS).

### User work-flows

Here are the work flows that will be affected by implementing the feature:

*   Appointing a network as the management network will make the network required in the given cluster.
*   Changing the management network in a cluster (through one of the options metioned earlier). Possible scenarios are (in the order of preference):

1.  Issuing "setup networks" command for every host in the cluster.
2.  Report the hosts as out-of-sync. This approach requires a Vdsm-side change - it would need to report which of its network is the default route.

*   Moving a host from a cluster to another one.
    -   As soon as the mangement network is a required one, the flow will be covered by the current behavior - in case the cluster management network isn't defined on the host, it'll become "Non-operational", otherwise it'll remain in the same status it was.
    -   **Note**: in case that the new management network is defined on the host, but the engine could not access the NIC it defined on, the host will become "Non-responsive" (covered by the current behavior).
*   Moving a cluster from a DC to another one. Possible scenarios are:
    -   Keeping current management network.
    -   Assign default management network (*Management*) to the cluster.
    -   In both cases: create the mangement network if it doesn't exist in the new DC.

### Installation/Upgrade

*   During the upgrade the new field (*is_management*) will be added to *NETWORK_CLUSTER* table and will be populated by *true* value for ovirtmgmt networks and *false* for all other networks.
*   The following DB objects will be updated with the new field:
    -   *NETWORK_CLUSTER_VIEW*
    -   Stored procedures:
        -   *GetAllNetworkByClusterId*
        -   *Insertnetwork_cluster*
        -   *Updatenetwork_cluster*
*   New stored procedure *set_network_exclusively_as_management* will be created

<Category:DetailedFeature>

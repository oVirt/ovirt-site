---
title: Management Network As A Role
category: feature
authors:
  - danken
  - moti
  - sandrobonazzola
  - yevgenyz
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

*   The existing "Manage network(s)" screens will be updated with the new column "Management Network". User will be able to change the management network assignment through the screens in the similar way like it's currently done for display network. Only a required network could be chosen as the management one.
    -   Networks assignments for a single cluster
        -   The management **radio button** will be disabled for non-required networks.
            ![](/images/wiki/Manage_networks.png)
    -   A single network assignments for all clusters in the DC
        -   The management **checkbox** will be disabled for non-required networks.
            ![](/images/wiki/Manage_network.png)
    -   The "required" checkbox will become disabled while the network is chosen as the management one and will turn to enabled once it stops being the management network.
*   The new parameter (management network) will be added in "New cluster" screen. The parameter will have the default value of *ovirtmgmt* if that is present in the DC and the user will be able to choose any other network as the management one.
    ![](/images/wiki/Create_cluster.png)

#### RESTful API

*   The new valid value (*MANAGEMENT*) will be added to Network.Usages collection.
    -   NetworkUsage enum will be extended with the new *MANAGEMENT* value.
*   A request that will make a management network non-required will fail.
*   The new optional parameter (management network) will be added for creating a new cluster API call (see [point 1 of User work-flows](#user-work-flows))

### User work-flows

Here are the work flows that will be affected by implementing the feature:

*   In order to make sure that every cluster will continue having a management network the new parameter (management network) will be added to creating new cluster flow.
    -   The parameter will have the default value of *ovirtmgmt* and the user will be able to choose any other network as the management one.
    -   *ovirtmgmt* network will continue to be created upon a DC creation.
    -   In case of *ovirtmgmt* isn't present (was removed) and another single network is present in the DC it will be taken as the default management network.
    -   In case of *ovirtmgmt* isn't present (was removed) and number of network in the DC **isn't one** the cluster creating operation will fail.
*   *ovirtmgmt* will be created upon creating a new DC. That will be done in order to keep backward compatibility to the current system behavior.
*   Only a required network could be chosen as the management one.
*   It will be possible to remove a network (and yes, *ovirtmgmt* too) as soon as it stops serving as the management network of any cluster (same rules applied like prior the feature implementation).
*   Changing the management network in a cluster (through one of the options mentioned earlier) will be enabled for an empty cluster only.
*   Moving a host from a cluster to another one will be enabled only in case where the source and destination management networks are the same one.
*   All hard-coded usages of ovirtmgmt network will be changed to the cluster management one:
    -   A new added host will be setup with the cluster management network.
    -   The cluster management network will be used as display and/or migration network fallback (e.g. in case of removing a network from a cluser/host).
    -   The management network will be used by VDSM as the host default route.

### Feature restrictions

Most of the feature restrictions are intended to prevent changing the management network on a host after inital "setup networks" operation (a part of a host installation process). Changing the management network might lead to loosing connectivity to the host that the connection to it is defined on the IP it was initially installed with in oVirt and the security certificate that was issued with that IP. Changing the mangement network after the host was installed might cause changing the IP that will be assigned to the new management network. Then accessing the host through that new IP will be impossible as the certifacate will not match the new IP address.
Resolving the certifiacate limitation (e.g. by making possible its changing) will make possible changing the management network after inital "setup networks" operation (a part of a host installation process) , which will enable removing most of the feature restrictions.

## Documentation

The high level feature description could be found [here](/develop/release-management/features/network/detailedmanagementnetworkasarole.html).

## Open Issues

*   What should be done with the host certificate that was issued for a specific IP? If changing certificate was possible most of the feature restriction could've been removed.
*   Moving a cluster from a DC to another one. The scenario is possible only after a DC force removal. At that stage al old DC networks are removed. The possible scenarios are:
    -   The operation will be forbidden. That will push the user to copy the cluster manually:
        -   create an empty cluster under the destination DC
        -   remove all old cluster hosts from oVirt and add them back under the new created cluster in the destination DC
        -   remove the old cluster from the system
    -   Let the user to choose one of the destination DC networks as the management one for the moved cluster (like it is done in creating a new cluster). The user should be warned that the management traffic to the cluster hosts will remain AS IS until "setup host networks" operation will be successfully completed on each one of the hosts.
*   How the new "management network" parameter will be represented in "Create new cluster" dialog in UI (see [the second bullet of UI section](#ui))?


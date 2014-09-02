---
title: DetailedManagementNetworkAsARole
category: detailedfeature
authors: yevgenyz
wiki_category: DetailedFeature
wiki_title: Features/DetailedManagementNetworkAsARole
wiki_revision_count: 8
wiki_last_updated: 2014-09-15
feature_name: Management network as a role - Detailed
feature_modules: Networking
feature_status: WIP
---

# Detailed Management Network As A Role

## Summary

This page describes the implementation details of the ["Management network as a role" feature](Features/Management_Network_As_A_Role).

### Entity Description

*   No new entities
*   *Management* boolean field will be added to NetworkCluster entity. *True* value will indicate that the network is the management one in the given cluster (similarly like it been done for display networks).

## Installation/Upgrade

*   During the upgrade the new field (*is_management*) will be added to *NETWORK_CLUSTER* table and will be populated by *true* value for ovirtmgmt networks and *false* for all other networks.
*   The following DB objects will be updated with the new field:
    -   *NETWORK_CLUSTER_VIEW*
    -   Stored procedures:
        -   *GetAllNetworkByClusterId*
        -   *Insertnetwork_cluster*
        -   *Updatenetwork_cluster*
*   New stored procedure *set_network_exclusively_as_management* will be created

## Planned code changes

### UI

The UI layer will be updated according to the [feature page](Features/Management_Network_As_A_Role). More details to come...

### Backend

#### NetworkUtils

*isManagementNetwork* methods will be moved to a new *ManagementNetworkUtils* class that will reside in *bll* project. The new class will implement the following methods:

*   boolean isManagementNetwork(Guid networkId)
*   boolean isManagementNetwork(String networkName, Guid clusterId)
*   Network getManagementNetwork(Guid clusterId)

#### DAO

Optionally: a new *getManagementNetwork* method will be added to *NetworkDao*

#### Command classes

The following classes will be affected by the feature:

*   org.ovirt.engine.core.bll.AddVdsGroupCommand
*   org.ovirt.engine.core.bll.InstallVdsInternalCommand
*   org.ovirt.engine.core.bll.UpdateVdsGroupCommand
*   org.ovirt.engine.core.bll.VdsDeploy
*   org.ovirt.engine.core.bll.network.NetworkConfigurator
*   org.ovirt.engine.core.bll.network.cluster.UpdateNetworkOnClusterCommand
*   org.ovirt.engine.core.bll.network.dc.UpdateNetworkCommand
*   org.ovirt.engine.core.bll.network.host.AttachNetworkToVdsInterfaceCommand
*   org.ovirt.engine.core.bll.network.host.UpdateNetworkToVdsInterfaceCommand
*   org.ovirt.engine.core.bll.network.host.SetupNetworksHelper
*   org.ovirt.engine.core.bll.network.RemoveNetworkParametersBuilder
*   org.ovirt.engine.core.bll.network.cluster.AttachNetworkToVdsGroupCommand
*   org.ovirt.engine.core.bll.network.cluster.UpdateNetworkOnClusterCommand
*   org.ovirt.engine.core.bll.network.host.AddBondCommand
*   org.ovirt.engine.core.bll.storage.UpdateStoragePoolCommand
*   org.ovirt.engine.core.bll.validator.NetworkValidator
*   org.ovirt.engine.core.vdsbroker.vdsbroker.CollectVdsNetworkDataVDSCommand
*   org.ovirt.engine.core.vdsbroker.vdsbroker.SetupNetworksVDSCommand

## Events

TBD

## Open Issues

1.  ManagementNetworkUtils project - the right place for that kind of logic is *bll*. However, the logic is needed by *vdsbroker*, but *bll* is dependent on the earlier apparently. 😠
2.  UpdateVdsGroupCommand

<Category:DetailedFeature> <Category:Networking>

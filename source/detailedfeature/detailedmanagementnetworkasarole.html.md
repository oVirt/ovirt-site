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

#### ManagementNetworkFinder

*ManagementNetworkFinder* class will be introduced. The class will implement heuristic logic of finding the management network either it was supplied by the user or not.

#### AddVdsGroupCommand

In addition to what it already does the class will determine what management network should be (using *ManagementNetworkFinder*) and will:

*   attach it to the new cluster
*   make it management and required

#### UpdateVdsGroupCommand

In the case when the management network is to be updated:

##### canDoAction

The following checks will be added:

*   the new management network is required
*   no hosts are attached to the cluster

##### executeCommand

Same as AddVdsGroupCommand

#### AddEmptyStoragePoolCommand

Creating *ovirtmgmt* network logic will be added in ''executeCommand' method'

#### NetworkUtils

*isManagementNetwork* methods will be moved to a new *ManagementNetworkUtils* class that will reside in *bll* project. The new class will implement the following methods:

*   boolean isManagementNetwork(Guid networkId)
*   boolean isManagementNetwork(String networkName, Guid clusterId)
*   Network getManagementNetwork(Guid clusterId)

#### DAO

Optionally: a new *getManagementNetwork* method will be added to *NetworkClusterDao*

#### Command classes

The following classes will be affected by the feature:

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

According to the new validations.

## Open Issues

1.  ManagementNetworkUtils project - the right place for that kind of logic is *bll*. However, the logic is needed by *vdsbroker*, but *bll* is dependent on the earlier apparently. 😠
2.  UpdateVdsGroupCommand - when moving the cluster back into a DC, need to add its management network.

*   -   Which network should be assigned as the management one?
    -   What should be done with the host of the cluster?

<Category:DetailedFeature> <Category:Networking>

---
title: Remove-DC-Entity-Network
category: feature
authors: alkaplan
wiki_category: Feature
wiki_title: Feature/Remove-DC-Entity-Network
wiki_revision_count: 15
wiki_last_updated: 2015-12-13
feature_name: Eliminate DC entity (Network aspects)
feature_modules: engine, api
feature_status: Design
---

# Remove-DC-Entity-Network

## Eliminate DC entity (Network aspects)

### Summary

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Introduction

In 4.0 oVirt is planned to be integrated with 'cloud open'. Since the most top level entity in 'cloud open' is cluster, there is a need to eliminate DC from oVirt.

#### High Level Feature Description

All the network flows that are involved with DC should move to the cluster or system level.

#### DB Tables/ Entities

*   Network
    -   'storage_pool_id' column should be removed.
    -   'cluster_id' column should be added.
    -   NetworkCluster table should be removed, all its properties should be moved to the network table.
*   Upgrade scripts
    -   Each 'network' in the 'network' table should be copied to the number of 'networkCluster' instances it has.
    -   The 'networkCluster' data should be copied to the relevant copy of the network.

#### Affected Flows

##### Network

*   AddNetworkCommand/UpdateNetworkCommand
    -   Should also persist 'required', 'management', 'display', 'migration' and 'gluster' properties.
    -   Should execute SetupNetworkNetworks command on the relevant cluster hosts (according to the label changes, same as AttachNetworkToVdsGroup did).
    -   When attaching host qos, should check the network's cluster compatibility version support host qos.
*   RemoveNetworkCommand
    -   Should execute SetupNetworkNetworks command on the relevant cluster hosts (according to the label changes, same as DetachNetworkToVdsGroup did).
    -   Should block removing the cluster's management network.
*   AttachNetworkToVdsGroupCommand/AttachNetworkToClusterInternalCommand
    -   Should be removed
    -   Its logic should be combined to 'Add/UpdateNetworkCommand'.
*   DetachNetworkToVdsGroupCommand/DetachNetworkFromClusterInternalCommand
    -   Should be removed.
    -   Its logic should be combined to 'RemoveNetworkCommand'.
*   ManageNetworkClustersCommand
    -   Should be removed.
*   ManagementNetworkUtil
    -   'boolean isManagementNetwork(Guid networkId);' should be removed.

##### vNic profile

*   AddVnicProfileCommand/UpdateVnicProfileCommand/RemoveVnicProfileCommand
    -   Vnic profile is related to a specific network. Therefore it will become cluster level entity.
    -   Seems that the DC removal is transparent to the 'vnic proifle' and shouldn't affect its flows.
    -   When attaching vm qos, should check the network's cluster compatibility version support vm qos.

##### Host Network QoS

*   AddHostNetworkQoSCommand/UpdateHostNetworkQoSCommand/RemoveHostNetworkQoSCommand
    -   Host network qos should become system level entity.

##### Vm Network QoS

*   AddNetworkQoSCommand/UpdateNetworkQoSCommand/RemoveNetworkQoSCommand
    -   VM network qos should become system level entity.

#### User Experience

##### Network main tab

##### Network-> Vnic profiles sub tab

##### DC-> Networks sub tab

##### Host qos

*   Should be moved to the system tab (configure window).

##### VM qos

*   Should be moved to the system tab (configure window).

##### Cluster->Logical network sub tab

*   Add/Edit network
    -   remove 'The Network will be added to the Data Center 'dc name' as well' from the dialog.
    -   Add 'required', 'management', 'display', 'migration' and 'gluster' properties.
*   Manage networks
    -   Remove this dialog ('required', 'management', 'display', 'migration' and 'gluster' properties will be moved to the Add/Edit network dialog).
*   Copy network
    -   Create a copy of the network in the selected clusters
    -   A new dialog that will contain a table with two columns- (1) 'copy to' checkbox (2) all the clusters in the system (Compatibility version?).

#### REST API

### Benefit to oVirt

*   Reduce complexity.
*   Allow integration to 'cloud open' (in which the most high level entity is cluster).

### Future features

### Dependencies / Related Features

### Documentation / External references

### Open issues

<Category:Feature> <Category:Networking>

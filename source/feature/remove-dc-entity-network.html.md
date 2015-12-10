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
    -   

*   RemoveNetworkCommand
*   AttachNetworkToVdsGroupCommand/AttachNetworkToClusterInternalCommand
    -   Should be removed
    -   Its logic should be combined to 'Add/UpdateNetworkCommand'
*   DetachNetworkToVdsGroupCommand/DetachNetworkFromClusterInternalCommand
    -   Should be removed
    -   Its logic should be combined to 'RemoveNetworkCommand'
*   ManageNetworkClustersCommand

##### vNic profile

*   AddVnicProfileCommand
*   UpdateVnicProdileCommand
*   RemoveVnicProfileCommand

##### Host Network QoS

*   AddHostNetworkQoSCommand
*   UpdateHostNetworkQoSCommand
*   RemoveHostNetworkQoSCommand

##### Vm Network QoS

*   AddNetworkQoSCommand
*   UpdateNetworkQoSCommand
*   RemoveNetworkQoSCommand

#### User Experience

*   Network main tab
*   Network-> Vnic profiles sub tab
*   DC-> Networks sub tab
*   DC-> Host qos sub tab
*   DC-> VM qos sub tab
*   Cluster->Logical network sub tab
    -   Add/Edit network
        -   remove 'The Network will be added to the Data Center 'dc name' as well' from the dialog.
        -   Add 'required', 'management', 'display', 'migration' and 'gluster' properties.
    -   Manage networks
        -   Remove this dialog ('required', 'management', 'display', 'migration' and 'gluster' properties will be moved to the Add/Edit network dialog).
    -   Copy network
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

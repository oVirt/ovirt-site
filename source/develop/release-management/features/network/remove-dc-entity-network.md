---
title: Remove-DC-Entity-Network
category: feature
authors: alkaplan
---

# Remove-DC-Entity-Network

## Eliminate DC entity (Network aspects)

### Summary

### Owner

*   Name: Alona Kaplan (alkaplan)
*   Email: <alkaplan@redhat.com>

### Introduction

In 4.0 oVirt is planned to be integrated with 'cloud open'. Since the most top level entity in 'cloud open' is cluster, there is a need to eliminate DC from oVirt.

#### High Level Feature Description

All the network flows that are involved with DC should move to the cluster or system level.

#### DB Tables/ Entities

*   Network
    -   `storage_pool_id` column should be removed.
    -   `cluster_id` column should be added.
    -   `NetworkCluster` table should be removed, all its properties should be moved to the `network` table.
*   Upgrade scripts
    -   Each `network` in the `network` table should be copied to the number of `networkCluster` instances it has.
    -   The `networkCluster` data should be copied to the relevant copy of the network.

#### Affected Flows

##### Network

*   `AddNetworkCommand`/`UpdateNetworkCommand`
    -   Should also persist `required`, `management`, `display`, `migration` and `gluster` properties.
    -   Should execute `SetupNetworkNetworks` command on the relevant cluster hosts (according to the label changes, same as `AttachNetworkToVdsGroup` did).
    -   When attaching host qos, should check the network's cluster compatibility version support host qos.
*   `RemoveNetworkCommand`
    -   Should execute SetupNetworkNetworks command on the relevant cluster hosts (according to the label changes, same as DetachNetworkToVdsGroup did).
    -   Should block removing the cluster's management network.
*   `AttachNetworkToVdsGroupCommand`/`AttachNetworkToClusterInternalCommand`
    -   Should be removed
    -   Its logic should be combined to 'Add/UpdateNetworkCommand'.
*   `DetachNetworkToVdsGroupCommand`/`DetachNetworkFromClusterInternalCommand`
    -   Should be removed.
    -   Its logic should be combined to `RemoveNetworkCommand`.
*   `ManageNetworkClustersCommand`
    -   Should be removed.
*   `ManagementNetworkUtil`
    -   `boolean isManagementNetwork(Guid networkId);` should be removed.

##### vNic profile

*   `AddVnicProfileCommand`/`UpdateVnicProfileCommand`/`RemoveVnicProfileCommand`
    -   Vnic profile is related to a specific network. Therefore it will become cluster level entity.
    -   Seems that the DC removal is transparent to the 'vnic proifle' and shouldn't affect its flows.
    -   When attaching vm qos, should check the network's cluster compatibility version support vm qos.

##### Host Network QoS

*   `AddHostNetworkQoSCommand`/`UpdateHostNetworkQoSCommand`/`RemoveHostNetworkQoSCommand`
    -   Host network qos should become cluster level entity.
    -   The reason it should become cluster level and not system level entity is that updating a specific host network qos, should affect only the host in the cluster and not potentially all the host in the system.
*   Copy to cluster action should be added.

##### Vm Network QoS

*   `AddNetworkQoSCommand`/`UpdateNetworkQoSCommand`/`RemoveNetworkQoSCommand`
    -   VM network qos should become cluster level entity.
*   Copy to cluster action should be added.

#### User Experience

##### Network main tab

*   Data Center Column should be removed.
*   Cluster column should be added.

##### Network-> Vnic profiles sub tab

*   No changes.

##### DC-> Networks sub tab

*   Should be removed.

##### Host qos

*   Should be moved to the system tab (configure window).
*   Copy to cluster button should be added.

##### VM qos

*   Should be moved to the system tab (configure window).
*   Copy to cluster butoon should be added.

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

##### `/ovirt-engine/api/networks`

*   `<data_center href ..>` should be removed.
*   `<cluster href ...>` should be added.

##### `/ovirt-engine/api/datacenters/<dc_id>/networks`

*   This sub collection should be removed/

##### `/ovirt-engine/api/clusters/<cluster_id>/networks`

*   Network properties should be added
    -   name
    -   description
    -   stp
    -   mtu
    -   vlan
    -   usages
    -   href permissions
    -   href vnicprofiles
    -   href labels

##### `/ovirt-engine/api/vnicprofiles`

*   no changes

##### `/ovirt-engine/api/networks/<network_id>/permissions`

*   no changes

##### `/ovirt-engine/api/datacenters/<dc_id>/qoss`

*   Should become cluster level collection- `/ovirt-engine/api/qoss`
*   Copy to cluster action should be added.

### Benefit to oVirt

*   Reduce complexity.
*   Allow integration to 'cloud open' (in which the most high level entity is cluster).

### Future features

### Dependencies / Related Features

### Documentation / External references

### Open issues

*   Mocks for the new expanded network dialog (that will contain the regular properties and the cluster properties).
*   Should manage networks dialog and command be removed. It means there will be no possibility to change the roles of multiple network at the same time.


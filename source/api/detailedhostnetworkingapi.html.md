---
title: DetailedHostNetworkingApi
category: api
authors: moti, sandrobonazzola
wiki_category: Networking
wiki_title: Features/DetailedHostNetworkingApi
wiki_revision_count: 12
wiki_last_updated: 2014-12-08
feature_name: Host Networking API
feature_modules: Networking
feature_status: Design
---

# Detailed Host Networking Api

## Owner

*   Name: [ Moti Asayag](User:masayag)
*   Email: masayag@redhat.com

## Detailed Description

#### Entity Description

A new entity named NetworkConnection will be added to the system. The NetworkConnection will represent a network which is configured on a host.
The NetworkConnection can be attached to a network interface or not. If not attached to a network interface, the network is considered a nic-less network. A new table **network_connections** will be added :

<span style="color:Teal">**NETWORK_CONNECTIONS**</span> Describes a network configured on a host:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |id ||UUID ||not null ||The network connection ID |- |network_id ||UUID ||not null ||The configured network ID |- |external ||Boolean ||not null ||Indicates if the network is external |- |nic_id ||UUID ||null ||The network interface id on which the network is configured (nic or bond) |- |boot_protocol ||String ||null ||The network boot protocol |- |ip_address ||String ||null ||The desired network ip address |- |netmask ||String ||null ||The desired network netmask |- |gateway ||String ||null ||The desired network gateway |- |properties ||Text ||null ||The desired network properties |- |}

The entity will allow to differentiate between the desired network configuration to what is actually configured on the host.
By that the engine will have a better capability to report more cases of network out-of-sync.

## Detailed Design

#### New commands

**AddNetworkConnectionCommand** - adds a network connection to a host
**UpdateNetworkConnectionCommand** - updates network connection on a host
**RemoveNetworkConnectionCommand** - removes a network connection from the host
**GetNetworkConnectionByIdQuery** - returns network connection by its id
**GetNetworkConnectionsByNicIdQuery** - returns all network connections which are configured on top of a given nic
**GetNetworkConnectionsByHostIdQuery** - returns all network connections which are configured on top of a given host
**SetupNicsCommand** - performs multiple network connections changes on a host at once

#### Updated commands

**SetupNetworksCommand** - In case 'checkConnnectivity' is set, compensation for network connections should be triggered in case of a failure. If 'checkConnnectivity' is unset, no compensation is required for network connections.

<Category:Networking> <Category:DetailedFeature>

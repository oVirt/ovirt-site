---
title: DetailedHostNetworkingApi
category: feature
authors: mmucha, moti, sandrobonazzola
---

# Detailed Host Networking Api

## Owner

*   Name: Martin Mucha (mmucha)

## Detailed Description

The suggest api implementation should maintain existing api for the sake of backward compatibility, hence until 4.0 all former apis will be maintained.

#### Entity Description

A new entity named NetworkAttachment will be added to the system. The NetworkAttachment will represent a network which is configured on a host.
The NetworkAttachment can be attached to a network interface or not. If not attached to a network interface, the network is considered a nic-less network. A new table **network_attachments** will be added :

<span style="color:Teal">**NETWORK_ATTACHMENTS**</span> Describes a network configured on a host:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |id ||UUID ||not null ||The network attachment ID |- |network_id ||UUID ||not null ||The configured network ID |- |external ||Boolean ||not null ||Indicates if the network is external |- |nic_id ||UUID ||null ||The network interface id on which the network is configured (nic or bond) |- |boot_protocol ||String ||null ||The network boot protocol |- |address ||String ||null ||The desired network ip address |- |netmask ||String ||null ||The desired network netmask |- |gateway ||String ||null ||The desired network gateway |- |custom_properties ||Text ||null ||The desired network properties |- |}

The entity will allow to differentiate between the desired network configuration to what is actually configured on the host.
By that the engine will have a better capability to report more cases of network out-of-sync.

## Detailed Design

#### New commands

*   **AddNetworkAttachmentCommand** - adds a network attachment to a host
*   **UpdateNetworkAttachmentCommand** - updates network attachment on a host
*   **RemoveNetworkAttachmentCommand** - removes a network attachment from the host
*   **GetNetworkAttachmentByIdQuery** - returns network attachment by its id
*   **GetNetworkAttachmentsByNicIdQuery** - returns all network attachments which are configured on top of a given nic
*   **GetNetworkAttachmentsByHostIdQuery** - returns all network attachments which are configured on top of a given host
*   **HostSetupNetworksCommand** - performs multiple network attachments changes on a host at once

#### Updated commands

*   **HostSetupNetworksCommand** - In case of a failure, if 'checkConnnectivity' is set, compensation for network attachments should be triggered. If 'checkConnnectivity' is unset, no compensation is required for the network attachments.

<!-- -->

*   Host network capabilities update (CollectVdsNetworkData) should be updated to consider the network attachment entity management:
    -   Network attachment should be preserved if its nic was reported
    -   Network attachment should be removed if its nic was not reported

The **HostSetupNetworksCommand** will use the **SetupNetworksVDSCommand** (vdsm api) directly to provision networks on the host.
The other commands which uses SetupNetworksCommand will now use **HostSetupNetworksCommand**:

       AddNetworkAttachmentCommand -------|
       UpdateNetworkAttachmentCommand ----|
                                          +------- HostSetupNetworksCommand ------ SetupNetworksVDSCommand
       RemoveNetworkAttachmentCommand ----|
       SetupNicsCommand ------------------|

#### VDS Command

The setupnetworks API exposed by VDSM remains the same:

       for each network:
         create attributes map:
           bonding : name | nic : name
           vlan : id
           [
            bootproto : dhcp 
            or
            ipaddr : ip
            netmask : netmask
            gateway : gateway
           ]
           mtu : int
           bridged : true / false
           STP : yes / no
           qosInbound : { average : int, peak: int, burst: int }
           qosOutbound : { average : int, peak: int, burst: int }
           defaultRoute : True
           custom: {}
           -- OR --
           remove : True
        add { network name : attributes } to map
         
       for each bond:
         create attributes map:
            nics=[nic1 , nic2, ...]
            options="`<bonding-options>`"
            -- OR --
            remove=True
      Addition attributes:
       connectivityCheck
       connectivityTimeout

**HostSetupNetworksParameters** will hold the relevant information to be sent to **HostSetupNetworksVDSCommand**.


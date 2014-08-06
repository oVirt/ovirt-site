---
title: HostNetworkingApi
category: api
authors: moti, sandrobonazzola
wiki_category: Feature
wiki_title: Features/HostNetworkingApi
wiki_revision_count: 68
wiki_last_updated: 2014-12-08
---

# Host Networking API

### Current Status

The current host networking api suffers from various limitations:

*   A mix of the physical and the logical network configuration
    -   Exposing vlan device implementation to the user
    -   Using 'Sync Network' feature requires to find the specific interface which carries the network
*   A Cumbersome request format for 'setup networks':
    -   creating vlan devices
    -   a complex input structure to represent the expected configuration
*   The attach/detach network isn't the RESTFul way to modify the interface
*   Cannot support a host only network (a network without a nic)
    -   Cannot support a dynamic (external) networks

### Proposed Solution

Introducing new sub-collections to reflect the host network configuration:

#### Network connections sub-collection of the nic resource

*   A collection of network connections that are attached to a specific physical interface or a bond:

       /api/hosts/{host:id}/nics/{nic:id}/networkconnections

*   Supported actions:
    \*# **GET** returns a list of networks attached to the nic

    \*# **POST** attaches a network to the nic

##### Network resource

       /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnection:id}

*   Supported actions:
    \*# **GET** returns a specific network which is attached to the nic

    \*# **DELETE** detaches a network from the nic

    \*# **PUT** updates the network on the nic

##### Network statistics sub-collection

       /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnections:id}/statistics

*   Supported actions:
    \*# **GET** returns a specific statistics for a network (if reported) which is attached to the nic

##### Network connections sub-collection

*   A collection of network connections which represent how the network is provisioned on the host

       /api/hosts/{host:id}/networkconnections

*   Supported actions:
    \*# **GET** returns a list of networks configured on the host

    \*# **POST** provision a network on the host

The **<networkconnection>** element describes the how network is configured on the host:

` `<networkconnection>
`   `<network/>
`   `<host_nic/>
`   `<boot_protocol/>
`   `<ip/>
`   `<properties/>
`   `<qos/>
`   `<override_configuration/>
`   `<external/>
` `</networkconnection>

*   network - which logical network is connected to the host
*   host_nic - an optional sub-element which described the underlying interface
    -   When not provided, implies the network is a nic-less network
    -   Can specify an unused nic or a bond (either existing bond or bond to create requires unused nics).
*   external - a flag to indicate whether this network is managed by ovirt/vdsm
*   boot_protocol - the boot protocol
*   ip - ip address, subnet, gateway
*   properties - network custom properties
*   qos - the network qos
*   override_configuration - sync network on host according to its logical network definition

##### Network connecton resource

       /api/hosts/{host:id}/networkconnections/{networkconnection:id}

*   Supported actions:
    \*# **GET** returns a specific network configured on the host

    \*# **PUT** update a network configured on the host

    \*# **DELETE** removes a network from the host

##### Network connecton statistics sub-collection

       /api/hosts/{host:id}/networkconnections/{networkconnection:id}/statistics

*   Supported actions:
    \*# **GET** returns a specific statistics for a network (if reported) which is attached to the host

##### Host Network Label resource

A collection designed to specify network labels on host level which aren't bounded to a specific nic.
Using this resource, nic-less networks could be configured on host.

       /api/hosts/{host:id}/networklabels/

*   **GET** - list host network labels
*   **POST** - add a label to the host

       /api/hosts/{host:id}/networklabels/{networklabel:id}

*   **GET** - returns a specific host network label
*   **DELETE** - removes a specific host network label

**pros**: Using host level network labels we can support nic-less networks auto-provision
**cons**: The management of labels becomes more complex, cannot use same label for nics

### Current Host Networking API (up to ovirt-engine-3.5)

       /api/hosts/{host:id}/nics

*   **GET** - list of network interfaces (GetVdsInterfacesByVdsId)
*   **POST** - creates a bond (AddBond)

       /api/hosts/{host:id}/nics/setupnetworks

*   **POST** - performs setup networks action (SetupNetworks)

       /api/hosts/{host:id}/nics/{nic:id}

*   **GET** - gets a specific network interface (GetVdsInterfacesByVdsId)
*   **DELETE** - removes a bond (RemoveBond)
*   **PUT** - updates a network which is attached to the specific network interface, aka mini-setup networks (UpdateNetworkToVdsInterface)

       /api/hosts/{host:id}/nics/{nic:id}/attach

*   **POST** - adds a network to a nic (AttachNetworkToVdsInterface)

       /api/hosts/{host:id}/nics/{nic:id}/detach

*   **POST** - removes a network from a nic (DetachNetworkFromVdsInterface)

       /api/hosts/{host:id}/nics/{nic:id}/statistics

*   **GET** - list the statistics of the specific network interface

Network labels related actions are listed at [Features/NetworkLabels#REST](Features/NetworkLabels#REST).

### What should be deprecated?

*   The *network* element in host_nic is replaced by *networkconnections* subcollection:

       /api/hosts/{host:id}/nics/{nic:id}:
` `<host_nic>
`   `<network />
` `</host_nic>

       is replaced by:
` `<host_nic>
`   `<link href= "/ovirt-engine/api/hosts/{host:id}/nics/{nic:id}/networkconnections" rel="networkconnections"/>
` `</host_nic>

The vlan devices will be hidden from the list of /api/hosts/{host:id}/nics and will be represented as a *networkconnection* element of the underlying nic.

*   Deprecated: /api/hosts/{host:id}/nics/setupnetworks

` `<host_nics>
`   `<host_nic>
`     `<network id="..."/>
`   `</host_nic>
` `</host_nics>

Is replaced by: /api/hosts/{host:id}/nics/setupnics

` `<host_nics>
`   `<host_nic>
`     `<networkconnections>
            ...
`     `</networkconnections>
`   `</host_nic>
         ...
` `</host_nics>

Request should contain only nics or bonds (no vlans).

*   Deprecated Host nics actions:

       /api/hosts/{host:id}/nics/{nic:id}/attach
       is replaced by POST request to 
       /api/hosts/{host:id}/nics/{nic:id}/networkconnections

and:

       /api/hosts/{host:id}/nics/{nic:id}/detach
       is replaced by DELETE request to:
       /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnection:id}

*   Updating network interface

       `**`PUT`**` on /api/hosts/{host:id}/nics/{nic:id}/
       the action semantics is changed to edit bond only

### Samples

Request samples can be found [here](Features/NetworkingApi).

### Detailed Design

A new entity named NetworkConnection will be added to the system. The NetworkConnection will represent a network which is configured on a host.
The NetworkConnection can be attached to a network interface or not. If not attached to a network interface, the network is considered a nic-less network. A new table **network_connections** will be added :

<span style="color:Teal">**NETWORK_CONNECTIONS**</span> Describes a network configured on a host:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |id ||UUID ||not null ||The network connection ID |- |network_id ||UUID ||not null ||The configured network ID |- |external ||Boolean ||not null ||Indicates if the network is external |- |nic_id ||UUID ||null ||The network interface id on which the network is configured (nic or bond) |- |boot_protocol ||String ||null ||The network boot protocol |- |ip_address ||String ||null ||The desired network ip address |- |netmask ||String ||null ||The desired network netmask |- |gateway ||String ||null ||The desired network gateway |- |properties ||Text ||null ||The desired network properties |- |}

The table will allow to differentiate between the desired network configuration to what is actually configured on the host.
By that the engine will have a better capability to report more cases of network out-of-sync.

#### Backend Changes

##### New commands

**AddNetworkConnectionCommand** - adds a network connection to a host
**UpdateNetworkConnectionCommand** - updates network connection on a host
**RemoveNetworkConnectionCommand** - removes a network connection from the host
**GetNetworkConnectionByIdQuery** - returns network connection by its id
**GetNetworkConnectionsByNicIdQuery** - returns all network connections which are configured on top of a given nic
**GetNetworkConnectionsByHostIdQuery** - returns all network connections which are configured on top of a given host
**SetupNicsCommand** - performs multiple network connections changes on a host at once
==== Updated commands ==== **SetupNetworksCommand** - In case 'checkConnnectivity' is set, compensation for network connections should be triggered in case of a failure. If 'checkConnnectivity' is unset, no compensation is required for network connections.

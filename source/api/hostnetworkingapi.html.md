---
title: HostNetworkingApi
category: api
authors: moti, sandrobonazzola
wiki_category: Feature
wiki_title: Features/HostNetworkingApi
wiki_revision_count: 68
wiki_last_updated: 2014-12-08
feature_name: Host Networking API
feature_modules: Networking
feature_status: Design
---

# Host Networking Api

### Owner

*   Name: [ Moti Asayag](User:masayag)
*   Email: masayag@redhat.com

## Current Status

The current host networking api (up to ovirt-engine-3.6) suffers from various limitations:

*   A mix of the physical and the logical network configuration
    -   Exposing vlan device implementation to the user
    -   Using 'Sync Network' feature requires to find the specific interface which carries the network
*   A Cumbersome request format for 'setup networks':
    -   creating vlan devices
    -   a complex input structure to represent the expected configuration
*   The attach/detach network isn't the RESTFul way to modify the interface
*   Cannot support a host only network (a network without a nic)
    -   Cannot support a dynamic (external) networks

## Proposed Solution

Introduce **<networkconnection>** element which describes how the network is configured on the host:

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

### Network connections sub-collection of the nic resource

*   A collection of network connections that are attached to a specific physical interface or a bond:

       /api/hosts/{host:id}/nics/{nic:id}/networkconnections

*   Supported actions:
    \*# **GET** returns a list of networks attached to the nic

    \*# **POST** attaches a network to the nic

#### Network resource

       /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnection:id}

*   Supported actions:
    \*# **GET** returns a specific network which is attached to the nic

    \*# **DELETE** detaches a network from the nic

    \*# **PUT** updates the network on the nic

#### Network statistics sub-collection (optional)

       /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnections:id}/statistics

*   Supported actions:
    \*# **GET** returns a specific statistics for a network (if reported) which is attached to the nic

<!-- -->

*   We can implement a new API in this context to reflect the total rx/tx instead of a processed measurements.

#### Network connecton statistics sub-collection

       /api/hosts/{host:id}/networkconnections/{networkconnection:id}/statistics

*   Supported actions:
    \*# **GET** returns a specific statistics for a network (if reported) which is attached to the host

## Current Host Networking API (up to ovirt-engine-3.5)

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

## What should be deprecated?

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

## Samples

Request samples can be found [here](Features/NetworkingApi).

<Category:Feature> <Category:Networking>

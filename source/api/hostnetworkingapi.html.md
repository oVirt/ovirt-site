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

Introduce **<network_connection>** element which describes how the network is configured on the host:

` `<network_connection>
`   `<network/>
`   `<host_nic/>
`   `<ip_configuration/>
`   `<properties/>
`   `<qos/>
`   `<override_configuration/>
`   `<reported_configurations in_sync="false">
`     `<reported_configuration name="mtu" value="9000" in_sync="false" />
`     `<reported_configuration name="bridged" value="false" in_sync="false" />
`     `<reported_configuration name="vlan" value="200" in_sync="false" />
`   `</reported_configurations>
` `</network_connection>

*   network - which logical network is connected to the host
*   host_nic - an optional sub-element which described the underlying interface
    -   When not provided, implies the network is a nic-less network
    -   Can specify an unused nic or a bond (either existing bond or bond to create requires unused nics).
*   ip_configuration - the ip configuration (ipv4/ipv6, boot protocol and addresses)
*   properties - network custom properties
*   override_configuration - sync network on host according to its logical network definition
*   reported_configuration - read-only element, returned *only* when the network is out-of-sync with the logical network definition, listing the specific out-of-sync properties.

The **ip_configuration** representation is:

` `<ip_configuration>
`   `<ipv4s>
           `<boot_protocol>`DHCP`</boot_protocol>` 
`     `<ipv4 primary="true">
             

<address />
             `<netmask />` 
`       `<gateway />
`     `</ipv4>
`     `<ipv4>
             

<address />
`       `<netmask />
             `<gateway />` 
`     `<ipv4>
`   `</ipv4s>
`   `<ipv6s>
`     `<boot_protocol>`DHCP`</boot_protocol>
`     `<ipv6>
             

<address />
`       `<gateway />
`     `</ipv6>
`     `<ipv6>
             

<address />
`       `<gateway />
`     `</ipv6>
`   `</ipv6s>
` `</ip_configuration>

#### Network connections sub-collection of the nic resource

*   A collection of network connections that are attached to a specific physical interface or a bond:

       /api/hosts/{host:id}/nics/{nic:id}/networkconnections

*   Supported actions:
    \*# **GET** returns a list of networks attached to the nic

    \*# **POST** attaches a network to the nic

#### Setupnics API of the network interfaces resource

*   A multi-nics configuration action to support complex network settings (i.e. cross nics actions: move network from one nic to another)

       /api/hosts/{host:id}/nics/setupnics

*   Request structure:

` `<host_nics />
` `<check_connectivity />
` `<connectivity_timeout />

*   Supported actions:
    \*# **POST** - expects the destination topology to be configured on the host, via patch method principal.

**setupnics** nics api expects a list of host_nics where the host_nic will describe the desired network connections for it.
If a nic is omitted from the request, it will be left intact, with its network connections.
If a nic is part of the request, and its networkconnections section is not provided, the network connection will be kept intact.
In order to remove any networkconnections from a specific nic, the user should provide an empty element for it, i.e. <networkconnections />.
If the user wishes to to provide any configuration for a given nic, the user should provide the desired <networkconnections> element for it.

#### Network connection resource under nic

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

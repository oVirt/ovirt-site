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

1.  **GET** - list of network interfaces (GetVdsInterfacesByVdsId)
2.  **POST** - creates a bond (AddBond)

       /api/hosts/{host:id}/nics/setupnetworks

1.  **POST** - performs setup networks action (SetupNetworks)

       /api/hosts/{host:id}/nics/{nic:id}

1.  **GET** - gets a specific network interface (GetVdsInterfacesByVdsId)
2.  **DELETE** - removes a bond (RemoveBond)
3.  **PUT** - updates a network which is attached to the specific network interface, aka mini-setup networks (UpdateNetworkToVdsInterface)

       /api/hosts/{host:id}/nics/{nic:id}/attach

1.  **POST** - adds a network to a nic (AttachNetworkToVdsInterface)

       /api/hosts/{host:id}/nics/{nic:id}/detach

1.  **POST** - removes a network from a nic (DetachNetworkFromVdsInterface)

       /api/hosts/{host:id}/nics/{nic:id}/statistics

1.  **GET** - list the statistics of the specific network interface

Network labels related actions are listed [<http://www.ovirt.org/Features/NetworkLabels#REST>](here).

### What should be deprecated?

*   Replace *network* element in host_nic with *networkconnections*:

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

` `<host_nic>
`    `<network id="..."/>
` `</host_nic>

Replaced by: /api/hosts/{host:id}/nics/setupnics

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
       is replaced be POST request to 
       /api/hosts/{host:id}/nics/{nic:id}/networkconnections

       and:
       /api/hosts/{host:id}/nics/{nic:id}/detach
       is replaced be DELETE request on:
       /api/hosts/{host:id}/nics/{nic:id}/networkconnections/{networkconnection:id}

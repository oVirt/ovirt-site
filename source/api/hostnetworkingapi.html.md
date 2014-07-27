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

#### Network sub-collection of the nic resource

*   A collection of networks that are attached to a specific physical interface or a bond:

       /api/hosts/{host:id}/nics/{nic:id}/networks

*   Supported actions:
    \*# **GET** returns a list of networks attached to the nic

    \*# **POST** attaches a network to the nic

##### Network resource

       /api/hosts/{host:id}/nics/{nic:id}/networks/{network:id}

*   Supported actions:
    \*# **GET** returns a specific network which is attached to the nic

    \*# **DELETE** detaches a network from the nic

##### Network statistics sub-collection

       /api/hosts/{host:id}/nics/{nic:id}/networks/{network:id}/statistics

*   Supported actions:
    \*# **GET** returns a specific statistics for a network (if reported) which is attached to the nic

##### Network connections sub-collection

*   A collection of network connections which represent how the network is provisioned on the host

       /api/hosts/{host:id}/networkconnections

*   Supported actions:
    \*# **GET** returns a list of networks configured on the host

    \*# **POST** provision a network on the host

The **<networkconnection>** element describes the how network is configured on the host:

*   network - which logical network is connected to the host
*   nic - an optional sub-element which described the underlying interface
    -   When not provided, implies the network is a nic-less network
*   external - a flag to indicate whether this network is managed by ovirt/vdsm

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

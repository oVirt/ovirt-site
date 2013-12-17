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
*   A Cumbersome request format for 'setup networks':
    -   creating vlan devices
    -   a complex input structure to represent the expected configuration
*   The attach/detach network isn't the RESTFul way to modify the interface
*   Cannot support a host only network (a network without a nic)
    -   Cannot support a dynamic (external) networks

### Proposed Solution

Introducing new sub-collections to reflect the host network configuration

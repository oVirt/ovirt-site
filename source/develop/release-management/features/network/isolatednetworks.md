---
title: IsolatedNetworks
category: feature
authors: moti, sandrobonazzola
---

# Isolated Networks

### Owner

*   Name: Moti Asayag (masayag)
*   Email: masayag@redhat.com

## Summary

The current host networking api (up to ovirt-engine-3.6) requires a network to be configured on top of a network interface.
In order to configure a local network on the host the user had to create a dummy interface to which the network was attached.
The Isolated Networks feature aimed to configure a local host on the network which isn't connected to any network interface and allows vms which are connected to it to communicate with each other.
Isolated Networks will be limited to VM networks only and only MTU should be relevant in that network definition for the created isolated network.

## Benefit to oVirt

Local networks are desired for enabling a secured connectivity among vms, isolated from any other networks.

### Detailed Description

Based on [Host Networking API design](/develop/release-management/features/network/hostnetworkingapi.html), removing the constraint of having a network interface configured for each network attachment will allow the user to create a network attachment which isn't bounded to any network interface.
Isolated networks will be represented on host level to reflect not being tied to any network interface:
\* When network attachment entity on host level is associated with an interface - it will be referred to as network configured on a nic.

*   When network attachment entity on host level is *not* associated with any interface - it will be refereed to as an isolated network.

### REST

#### Network attachment statistics sub-collection

       /api/hosts/{host:id}/networkattachments/{networkattachment:id}/statistics

*   Supported actions:
    \*# **GET** returns a specific statistics for a network (if reported) which is attached to the host

#### Host Network Label resource

A collection designed to specify network labels on host level which aren't bounded to a specific nic.
Using this resource, an isolated networks could be configured on host, if a network is labelled with the same label.

       /api/hosts/{host:id}/networklabels/

*   **GET** - list host network labels
*   **POST** - add a label to the host

       /api/hosts/{host:id}/networklabels/{networklabel:id}

*   **GET** - returns a specific host network label
*   **DELETE** - removes a specific host network label

**pros**: Using host level network labels we can support auto-provision of isolated networks
**cons**: The management of labels becomes more complex, cannot use same label for nics

       /api/hosts/{host:id}/setupnetworks

No changes required. Without specifying the host_nic for the network_attachment element, an isolated will be configured on the host.


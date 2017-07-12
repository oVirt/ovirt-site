---
title: Networks
authors: mkolesni
---

<!-- TODO: Content review -->

# Networks

Networking in oVirt comprises of several layers:

*   The logical network definition (Data center + cluster network)
*   The actual implementation (The host level)
*   The usage of the network (vNIC profiles + vNICs)

This document will try to cover the various networking aspects and some basic usages.

## The Logical Network Definitions

### The Data Center Networks

The first and foremost container of a network is the data center. The data center's networks are modelled under the data center (in the system tree and main tabs). In this scope, each network must have a unique name and a unique VLAN tag (if it's used).

The availabke fields of a network entity represent the L2 properties that can be set on the network:

*   Name
    -   Used to identify the network (propogates to the hosts)
*   VLAN tag
    -   If selected, the specific VLAN tag to use, otherwise traffic is untagged (No 802.1Q field in the frame header)
*   VM network
    -   If selected, the network can be consumed by VMs (via vNIC profiles), otherwise it is not consumable by VMs
    -   Non-VM networks are implemented without a bridge, so:
        -   Their performance is faster
        -   They can be combined with VLAN networks on the same NIC (more on this in the hosts section)
*   MTU
    -   If specified, this MTU will be used, otherwise the OS default (usually 1500) of the host is used

Optionally, it's possible to export the network to an external provider upon creation. This topic is covered by the [Features/Detailed_OSN_Integration](Features/Detailed_OSN_Integration) feature and includes extra configuration to work.

### The Attachment of a Network to a Cluster

In order to be able to actually use the network, you must attach it to the cluster first. Once a network is attached to the cluster, you can use it in VMs and templates, and set it up on the hosts. The attachment also denotes special roles this network has (by default the management network performs all these, but oVirt offers flexibility to separate them).

The cluster attachment allows these usages of a network:

*   Required/Non-Required
    -   Required networks cause the hosts to go to Non-Operational state if they don't have the network, while Not-Required networks are more flexible.
        -   This behaviour happens only if the network state is "Operational" which is reached once all hosts in the cluster have it (so that when deploying new network, all existing hosts will not turn non-operational).
    -   However, if the network is used by a VM and is marked as non required, only those hosts in the cluster that have the network will be able to run it.
*   Display Network
    -   This network will be used to transfer the display (VNC/Spice) data from the VMs.
        -   The network must exist on a host AND have an IP in order to run VMs, otherwise the host won't be able to run VMs.
    -   If no network is selected on a cluster, the management network is used.
*   Migration Network
    -   This network will be used to transfer the migration data when a VM is live-migrating.
        -   If network doesn't exist on source or destination host, the management network will be used.
    -   If no network is selected on a cluster, the management network is used.

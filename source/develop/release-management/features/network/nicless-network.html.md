---
title: Nicless Network
category: feature
authors: danken
wiki_category: Feature
wiki_title: Features/Nicless Network
wiki_revision_count: 8
wiki_last_updated: 2014-05-01
feature_name: Nic-less Network
feature_modules: engine,api
feature_status: Dormant
---

# Nic-less Network

### Summary

Create an in-host-only network, with no external communication

### Owner

*   Name: [Yevgeny Zaspitsky](User:yevgenyz)

<!-- -->

*   Email: <yzaspits@redhat.com>

### Detailed Description

In oVirt, after a VM network is defined in the Data Center level and added to a cluster, it needs to be implemented on each host. All VM networks are (currently) based on a Linux software bridge. The specific implementation controls how traffic from that bridge reaches the outer world. For example, the bridge may be connected externally via `eth3`, or `bond3` over `eth2` and `p1p2`. This feature is about implementing a network with no network interfaces (NICs) at all.

Having a disconnected network may first seem to add complexity to VM placement. Until now, we assumed that if a network (say, *blue*) is defined on two hosts, the two hosts lie in the same broadcast domain. If a couple of VMs are connected to *blue* it does not matter where they a run - they would always hear each other. This is of course no longer true if one of the hosts implements *blue* as nicless. However, this is nothing new. oVirt never validates the single broadcast domain assumption, which can be easily broken by an admin: on one host, an admin can implement *blue* using a nic that has completely unrelated physical connectivity.

### Benefit to oVirt

*   [All-in-One](Feature/AllInOne) use case: we'd like to have a complete oVirt deployment that does not rely on external resources, such as layer-2 connectivity or DNS.
*   Collaborative computing: an oVirt user may wish to have a group of VMs with heavy in-group secret communication, where only one of the VMs exposes an external web service. The in-group secret communication could be limited to a nic-less network, no need to let it spill outside.
*   Nic-less networks can be tunneled to remote network segments over IP, a layer 2 NIC may not be part of its definition.

### Dependencies / Related Features

### Vdsm

Vdsm already supports defining a network with no nics attached.

### Engine

Implementing this in Engine is quite a pain, as network external interfaces are currently used as keys of the NetworkAttachment entity.

**More elaboration is requited here.**

#### DB changes

*   Network table
    -   new field: *is_isolated* boolean (not nullable with default value 'false'). True value indicates an isolated (nicless) network whereas is for a regular network.
*   Network_attachements table
    -   new field: *host_id* UUID (not nullable). The new field references pk_vds_static key.
    -   modified field: *nic_id* - becomes nullable and isn't a part of the unique key.
    -   *network_attachments_network_id_nic_id_key* - the unique constraint will be changed to include host_id instead of nic_id.

#### Java Domain Objects

*   Network class
    -   New property: *isolated* - correspondent to network.is_isolated DB field.
*   NetworkAttachment
    -   New propertty: *hostId* - correspondent to network_attachments.host_id DB field.

<!-- -->

*   which high-level logic assume that the filed is not-null
*   CAVEATS: where this change is expected to break current functionality

#### Usage

*   How would a user define an isolated network? We need to choose between two options:
    -   Let the DC-level network entity have a new flag is_isolated. After assigning an isolated network to a cluster, a bridge is auto-created on each of the hosts (this can happen right before a VM is tarted, or more traditionally --- ahead of time)
    -   In SetupNetworks dialog (and in the relevant APIs) Let the user select that a VM network has no interface on a specific host
*   Which validation (if any) are required

#### UI

*   mock-up (or a simple-but-clear) description of required UI changes

#### REST

### Documentation / External references

*   [All-in-One](Feature/AllInOne) - an oVirt deployment that needs to fire up VMs with no external network connectivity.

<!-- -->

*   NAT-based host-only network requested by DHC <http://lists.ovirt.org/pipermail/users/2012-April/001751.html>

### Comments and Discussion

*   Refer to [Talk:Nicless Network](Talk:Nicless Network)

<Category:Feature> <Category:Networking>

---
title: Nicless Network
category: feature
authors: danken
wiki_category: Feature
wiki_title: Features/Nicless Network
wiki_revision_count: 8
wiki_last_updated: 2014-05-01
---

# Nic-less Network

### Summary

Create an in-host-only network, with no external communication

### Owner

*   Name: [ Dan Kenigsberg](User:Danken)

<!-- -->

*   Email: <danken@redhat.com>

### Current status

*   Not yet scheduled to a specific release
*   Last updated: ,

### Detailed Description

In oVirt, after a VM network is defined in the Data Center level and added to a cluster, it needs to be implemented on each host. All VM networks are (currently) based on a Linux software bridge. The specific implementation controls how traffic from that bridge reaches the outer world. For example, the bridge may be connected externally via `eth3`, or `bond3` over `eth2` and `p1p2`. This feature is about implementing a network with no network interfaces (NICs) at all.

Having a disconnected network may first seem to add complexity to VM placement. Until now, we assumed that if a network (say, *blue*) is defined on two hosts, the two hosts lie in the same broadcast domain. If a couple of VMs are connected to *blue* it does not matter where they a run - they would always hear each other. This is of course no longer true if one of the hosts implements *blue* as nicless. However, this is nothing new. oVirt never validates the single broadcast domain assumption, which can be easily broken by an admin: on one host, an admin can implement *blue* using a nic that has completely unrelated physical connectivity.

### Benefit to oVirt

*   [Feature/AllInOne All-in-One](Feature/AllInOne All-in-One) use case: we'd like to have an oVirt complete deployment that does not rely on external resources, such as layer-2 connectivity or DNS.
*   Collaborative computing: an oVirt user may wish to have a group of VMs with heavy in-group secret communication, where only one of the VMs exposes an external web service. The in-group secret communication could be limited to a nic-less network, no need to let it spill outside.

### Dependencies / Related Features

#### Vdsm

Vdsm already supports defining a network with no nics attached.

#### Engine

I am told that implementing this in Engine is quite a pain, as network external interfaces are currently used as keys. A network without nics is currently unsearchable.

**More elaboration is requited here.**

### Documentation / External references

*   [Feature/AllInOne All-in-One](Feature/AllInOne All-in-One) - an oVirt deployment that needs to fire up VMs with no external network connectivity.

### Comments and Discussion

*   Refer to [Talk:Nicless Network](Talk:Nicless Network)

<Category:Feature>

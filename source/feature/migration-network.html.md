---
title: Migration Network
category: feature
authors: alkaplan, danken, ilvovsky, mpavlik
wiki_category: Feature
wiki_title: Features/Migration Network
wiki_revision_count: 28
wiki_last_updated: 2013-05-28
---

# Migration Network

### Summary

Define a migration network role, and use such networks to carry migration data

### Owner

*   Name: [ Dan Kenigsberg](User:Danken)

<!-- -->

*   Email: <danken@redhat.com>

### Current status

*   oVirt-3.3
*   Last updated: ,

### Detailed Description

When Engine requests to migrate a VM from one node to another, the VM state (Bios, IO devices, RAM) is transferred over a TCP/IP connection that is opened from the source `qemu` process to the destination `qemu`. Currently, destination qemu listens for the incoming connection on the management IP address of the destination host. This has serious downsides: a "migration storm" may choke the destination's management interface; migration is plaintext and ovirtmgmt includes Engine which sits may sit the node cluster.

With this feature, a cluster administrator may grant the "migration" role to one of the cluster networks. Engine would use that network's IP address on the destination host when it requests a migration of a VM. With proper network setup, migration data would be separated to that network.

### Benefit to oVirt

*   Users would be able to define and dedicate a separate network for migration. Users that need quick migration would use nics with high bandwidth. Users who want to cap the bandwidth consumed by migration could define a migration network over nics with bandwidth limitation.
*   Migration data can be limited to a separate network, that has no layer-2 access from Engine

### Dependencies / Related Features

#### Vdsm

The `migrate` verb should be extended with an additional parameter, specifying the address that the remote `qemu` process should listen on. A new argument is to be added to the currently-defined migration arguments:

*   vmId: UUID
*   dst: management address of destination host
*   dstparams: hibernation volumes definition
*   mode: migration/hibernation
*   method: rotten legacy
*   dstqemu': dedicated migration address of destination host. Would be used to build libivrt's `miguri` [argument](http://libvirt.org/html/libvirt-libvirt.html#virDomainMigrateToURI2) such as `tcp://<ip of migration network on remote node>`.

#### Engine

1.  Network definition.
    -   A new network role - not unlike "display network" should be added.Only one migration network should be defined on a cluster.
    -   If none is defined, the legacy "use ovirtmgmt for migration" behavior would apply.
    -   A migration network is more likely to be a *required* network, but a user may opt for non-required. He may face unpleasant surprises if he wants to migrate his machine, but no candidate host has the network available.
    -   The "migration" role can be granted or taken on-the-fly, when hosts are active, as long as there are no currently-migrating VMs.

2.  Scheduler:
    -   When deciding which host should be used for automatic migration, take into account the existence and availability of the migration network on the destination host.
    -   For manual migration, let user migrate a VM to a host with no migration network - if the admin wants to keep jamming the management network with migration traffic, let her.
    -   Just like choosing the destination host, the user may choose a specific migration network. If host is not selected then allow to choose from cluster's networks. The default should be the cluster's migration network.

3.  migration verb.
    -   For a modern cluster level, with migration network defined on the destination host, an additional *dstqemu* parameter should be added to the `migrate` command

### Development Phases

#### First phase

*   Add a new network role of migration network.
*   Each cluster has one, and it is the default migration network for VMs on the cluster.
*   Factory default is that ovirtmgmt is the cluster migration network.

*Target:* oVirt -3.3

#### Second phase

*   Add a per-VM propery of migrationNetwork. If Null, the cluster migrationNetwork would be used.
*   Let the user override the VM migration network in the migrate API and in the GUI.

*Target:* TBD

### Documentation / External references

*   Yuval M asking to choose a network form migration data: <http://lists.ovirt.org/pipermail/users/2013-January/011301.html>

### Comments and Discussion

*   Refer to [Talk:Migration Network](Talk:Migration Network)

<Category:Feature> <Category:Networking>

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

*   Name: [ Alona Kaplan](User:alkaplan)

<!-- -->

*   Email: <alkaplan@redhat.com>

### Current status

*   oVirt-3.3
*   Last updated: ,

### Detailed Description

When Engine requests to migrate a VM from one node to another, the VM state (Bios, IO devices, RAM) is transferred over a TCP/IP connection that is opened from the source `qemu` process to the destination `qemu`. Currently, destination qemu listens for the incoming connection on the management IP address of the destination host. This has serious downsides: a "migration storm" may choke the destination's management interface; migration is plaintext and ovirtmgmt includes Engine which sits may sit the node cluster.

With this feature, a cluster administrator may grant the "migration" role to one of the cluster networks. Engine would use that network's IP address on the destination host when it requests a migration of a VM. With proper network setup, migration data would be separated to that network.

### Benefit to oVirt

*   Users would be able to define and dedicate a separate network for migration. Users that need quick migration would use nics with high bandwidth. Users who want to cap the bandwidth consumed by migration could define a migration network over nics with bandwidth limitation.
*   Migration data can be limited to a separate network, that has no layer-2 access from Engine
*   Having a migration-specific network is one step towards capping/promising migration bandwidth. With this feature applied, this could be done with the help of external switches. In the future, we plan to let the end admin set QoS properties on each oVirt-defined network.

### Dependencies / Related Features

#### Vdsm

The `migrate` verb should be extended with an additional parameter, specifying the address that the remote `qemu` process should listen on. A new argument is to be added to the currently-defined migration arguments:

*   vmId: UUID
*   dst: management address of destination host
*   dstparams: hibernation volumes definition
*   mode: migration/hibernation
*   method: rotten legacy
*   **dstqemu**: dedicated migration address of destination host. Would be used to build libivrt's `miguri` [argument](http://libvirt.org/html/libvirt-libvirt.html#virDomainMigrateToURI2) such as `tcp://<ip of migration network on remote node>`.

Note that the migration protocol requires Vdms-Vdsm and libvirt-libvirt communication. Both are routed over the management network even when the new dstqemu argument is used.

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

#### Screen shots

![](EditMigration.png "fig:EditMigration.png") ![](MigrationSubTab.png "fig:MigrationSubTab.png") ![](MigrationSetupNetwork.png "fig:MigrationSetupNetwork.png")

### Development Phases

#### First phase

*   Add a new network role of migration network.
*   Each cluster has one, and it is the default migration network for VMs on the cluster.
*   Factory default is that ovirtmgmt is the cluster migration network.

*Target:* oVirt -3.3

#### Second phase

*   Add a per-VM property of migrationNetwork. If Null, the cluster migrationNetwork would be used.
*   Let the user override the VM migration network in the migrate API and in the GUI.

*Target:* TBD

### Testing

*   Set up a cluster of at least two hosts, and have them inter-connected via two different networks. Simplest form is to have two NICs on each host.
*   One NIC should be used by the management network, and the other - by the management network. Use the new GUI to configure your hosts appropriately.
*   Start a VM on one machine, and migrate it to the other. Verify that migration succeeds.
*   Sniff the traffic on the source and destination hosts while migration is going on. Verify that qemu-to-qemu migration traffic is limited to the migration network.

| Test                        | Steps                                                         | Expected Result                                                         | Status | Version | Note                                                                          |
|-----------------------------|---------------------------------------------------------------|-------------------------------------------------------------------------|--------|---------|-------------------------------------------------------------------------------|

| dedicated migration network | 1) Assign migration role to the network                       
                               2) Attach the network to the host (do not forget to setup IP)  
                               3) Migrate VMs between nodes                                   | 1) role assigned                                                        
                                                                                               2) network attached                                                      
                                                                                               3) successfull migration which happens over dedicated migration network  |        |         | Test for: regular network, bridgeless network, bridgeless network, VLAN, bond |

### Known Limitations

*   The address of the migration network must live on the same subnet for both hosts. If it is not, qemu cannot guess the correct source address to use, so traffic would flow via the default gateway. **TODO**: open qemu and libvirt RFEs to allow specifying the source IP address of migration traffic.

### Documentation / External references

*   Yuval M asking to choose a network for migration data: <http://lists.ovirt.org/pipermail/users/2013-January/011301.html>

### Comments and Discussion

*   Refer to [Talk:Migration Network](Talk:Migration Network)
*   Currently, there is a bug when the boot protocol of the migration network is dhcp. Sometimes the engine doesn't get in time the ip of the network from the dhcp server. In this case, when the migration command will be invoked the engine won't have the ip address of the migration network. It will cause the migration to be done on the fallback (management) network. Bug Url- <https://bugzilla.redhat.com/642551>

<Category:Feature> <Category:Networking>

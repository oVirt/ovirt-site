---
title: Nicless Network
category: feature
authors: danken
feature_name: Nic-less Network
feature_modules: engine,api
feature_status: Dormant
---

# Nic-less Network

## Summary

Create an in-host-only network, with no external communication

## Owner

*   Name: Yevgeny Zaspitsky (yevgenyz)


## Detailed Description

In oVirt, after a VM network is defined in the Data Center level and added to a cluster, it needs to be implemented on each host. All VM networks are (currently) based on a Linux software bridge. The specific implementation controls how traffic from that bridge reaches the outer world. For example, the bridge may be connected externally via `eth3`, or `bond3` over `eth2` and `p1p2`. This feature is about implementing a network with no network interfaces (NICs) at all.

Having a disconnected network may first seem to add complexity to VM placement. Until now, we assumed that if a network (say, *blue*) is defined on two hosts, the two hosts lie in the same broadcast domain. If a couple of VMs are connected to *blue* it does not matter where they a run - they would always hear each other. This is of course no longer true if one of the hosts implements *blue* as nicless. However, this is nothing new. oVirt never validates the single broadcast domain assumption, which can be easily broken by an admin: on one host, an admin can implement *blue* using a nic that has completely unrelated physical connectivity.

## Benefit to oVirt

*   [All-in-One](/develop/release-management/features/integration/allinone.html) use case: we'd like to have a complete oVirt deployment that does not rely on external resources, such as layer-2 connectivity or DNS.
*   Collaborative computing: an oVirt user may wish to have a group of VMs with heavy in-group secret communication, where only one of the VMs exposes an external web service. The in-group secret communication could be limited to a nic-less network, no need to let it spill outside.
*   Nic-less networks can be tunneled to remote network segments over IP, a layer 2 NIC may not be part of its definition.

## Dependencies / Related Features

## Vdsm

Vdsm already supports defining a network with no nics attached.

## Engine

Implementing this in Engine is quite a pain, as network external interfaces are currently used as keys of the NetworkAttachment entity. Currently 20 different places in the engine code refer to NetworkAttachement.getNicId method. All those should be amended in order to support that it might return null and/or alternatively use *getHostId* instead. Also we might think of declaring NetworkAttachmentKey class that will be used as the attachment identifier. Initially the class will hold networkId and nicId and then change that to hold hostId instead of the nicId.

### DB changes

*   Network table
    -   new field: *is_isolated* boolean (not nullable with default value 'false'). True value indicates an isolated (nicless) network whereas is for a regular network.
*   Network_attachements table
    -   new field: *host_id* UUID (not nullable). The new field references vds_static.vds_id field.
    -   modified field: *nic_id* - becomes nullable and isn't a part of the unique key.
    -   *network_attachments_network_id_nic_id_key* - the unique constraint will be changed to include host_id instead of nic_id.

### Java Domain Objects

*   Network class
    -   New property: *isolated* - correspondent to network.is_isolated DB field.
*   NetworkAttachment
    -   New propertty: *hostId* - correspondent to network_attachments.host_id DB field.

      The main high-level logic that would be impacted by the change is `*`HostSetupNetworksCommand`*` but other flows should be evaluated too.

### Usage

*   Defining an isolated (nic-less) network will be possible by checking *isolated* checkbox during creating the network on the DC level.
*   An isolated network that is attached to a cluster will be set as a required network permanently (DK: please explain why this makes sense).
*   An isolated network is inherently a VM network. It could not bear any other role.

Any oVirt-managed host is able to support an isolated network unconditionally and does not require any additional info to that was supplied at the network creating. Thus defining such network on the hosts could be automated. That removes from a user the need of defining an isolated network manually on each host prior to be able running a VM that uses the network.

*   Upon attaching an isolated network to a cluster, the engine will deploy the network on all active hosts in the cluster.
*   The existence of the network would be re-validated upon a host becoming active and the network would be created if that is missing on the host.

#### Alternative approaches

*   Similar to the described above, but creating the network on a host would be done just before running a VM that uses the network.
*   [Features/IsolatedNetworks](/develop/release-management/features/network/isolatednetworks.html) - this approach is about to treat an isolated network like any other network and let it be attached to a host rather than a NIC. The network would not be defined as isolated in advance and being such or not would be determined by the usage. This approach leads another sub-feature "host label" in order to automate an isolated network creating.

### UI

*   mock-up (or a simple-but-clear) description of required UI changes - TBD
*   **TBD** should we present isolated networks on the the Setup Networks dialog?

### REST

No changes will be done to the REST API, but the implementation will allow specifying a network attachment to a host without specifying which NIC the network [is|to be] connected to.

## Testing

**TBD**

## Documentation / External references

*   [All-in-One](/develop/release-management/features/integration/allinone.html) - an oVirt deployment that needs to fire up VMs with no external network connectivity.

<!-- -->

*   NAT-based host-only network requested by DHC <https://lists.ovirt.org/pipermail/users/2012-April/001751.html>




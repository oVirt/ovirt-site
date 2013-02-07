---
title: NetworkReloaded
category: feature
authors: amuller, apuimedo, danken
wiki_category: Feature
wiki_title: Feature/NetworkReloaded
wiki_revision_count: 58
wiki_last_updated: 2014-03-02
---

# Network Reloaded

## Summary

Network reloaded is a feature that encompasses several change proposals on the VDSM component of oVirt, all of them related to networking.

The main points are:

*   Multiple network backend design, i.e., ways in which to interact with the kernel, directly or indirectly for setting the networking state in the way we are requested by the engine. Motivation:
    -   Cross-distribution compatibility, and thus, very closely aligned to the future goals of vdsm.
    -   Add support for new technologies by using several backends at the same time: for example iproute2 + openvSwitch.
*   Object oriented representation of Networking primitives (Bridge, Bond, nic, etc). Motivation:
    -   Currently the network logic is spread among netinfo and configNetworks in a way that makes it a bit difficult to grasp which are the actors in the networks and what are the rules.
    -   An object oriented approach could help group the current methods into smaller and easier to grasp semantical groups.
*   Live network information. Motivation:
    -   Avoid continuous fetching of all the information.
    -   Improve scalability.
    -   Allow for the possibility to have event response actions to handle network changes (e.g. hotplug a host nic, nic going offline).
*   SetupNetworks method definition does not change.

## Owner

*   Name: [ Antoni Segura Puimedon](User:APuimedo)
*   Email: apuimedo aT redhat.com

## Current status

*   Planning, designing and prototyping.

| Step                                   | Description                                                                                                                   | Completion |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|------------|
| Define object oriented representations | Find the best class representations for the network primitives for our usage                                                  | 20%        |
| Define internal API                    | Define the API that will establish the relationship between the new network representation and the multiple network backends. | 10%        |
| Live Netinfo instance                  | Define a way to keep a netinfo.Netinfo instance updated based on the representations of the first point.                      | 10%        |
| ifcfg backend                          | refactor our current ifcfg-based implementation as backend, following the internal API.                                       | 0%         |
| IProute2 backend                       | Create a network backend from iproute2 tools, following the internal API.                                                     | 10%        |
| Objectified rollback                   | Modify the rollback mechanism into just feeding the pre-crash network object representation to the selected network backend   | 0%         |

## Components

In the following sections we will develop the action points expressed in the above table in detail (growing from community feedback) to give a proper idea of how the feature will look like when completed.

### Object oriented representations

The primitives to represent are:

*   Bridge,
*   Bond,
*   Nic,
*   VLAN,
*   Device alias (is it really required?),
*   IpConfig.

The relationship is as follows:

1.  Bridge, Bonds, VLANs and Nics may have IpConfig, mtu and link_state information.
2.  Bridges have ports that can be Bond, Nic and Vlan instances (or none, for nicless bridges).
3.  Bonds have slaves that are Nic instances.
4.  IpConfig objects contain information about the configured IPv4 and IPv6 addresses (they can have multiple of each), routes.
5.  Vlans can be set upon Nics and bonds.
6.  Each class contains the logic for validating the parameters received from the engine, based on its current state and relations to other objects (e.g a change to a bridge may be disallowed due to its currently-connected nic). This way, the responsibilities for wrong configuration detection are semantically localized.
7.  Each object should be able to contribute its part in generating the information for getVdsCaps.
8.  The following combinations of network elements are allowed:
    -   Single non-VLANed bridged network
    -   Multiple VLANed networks (bridged or bridgeless) with only a single non-VLANed bridgeless network.

A netinfo object would have a list of the top hierarchy objects and generate the info from that.

#### Bridge

*   ports: Could be nics, bonds or vlans. vNics of VMs are connected to temporary ports (tap devices).
*   name,
*   forward_delay,
*   stp,
*   priority,
*   IpConfig,
*   link_active: True/False,
*   mtu: Max. Transfer Unit,
*   configurator: Reference to the configurator implementation that can apply/delete changes.

#### Bond

*   name,
*   slaves: nics or vlans,
*   opts: Dictionary with stuff like mode and miimon.
*   IpConfig,
*   link_active: True/False,
*   mtu: Max. Transfer Unit,
*   configurator: Reference to the configurator implementation that can apply/delete changes.

#### Nic

*   name.
*   IpConfig,
*   LinkActive: True/False,
*   mtu: Max. Transfer Unit,
*   configurator: Reference to the configurator implementation that can apply/delete changes.

#### VLAN

*   tag: The tag number of the VLAN.
*   Interface: A nic, bond or bridge that has the vlan on top.
*   IPConfing,
*   link_active: True/False,
*   mtu: Max. Transfer Unit,
*   configurator: Reference to the configurator implementation that can apply/delete changes.

#### Alias

*   Users have shown interest in the likes of `eth0:4`. We should find out if this is really required of oVirt.

#### IpConfig

*   inet: List of IPv4 address information (addr + netmask + gateway/route),
*   inet6: List of IPv6 address information (addr + netmask + gateway/route).
*   MTU: ,
*   conf_impl: Reference to the configurator implementation that can apply/delete changes.

#### Network

*   an abstract object representing a layer-2 network, that may be implemented by a bridge, a set of nics, etc.

### Define internal API

The internal API should allow for an objectified network definition (via setupNetworks command from Engine or from rollback) to be applied consistently regardless of which configurator implementation provides it. That includes:

*   Creation,
*   Modification,
*   Deletion.

Thus, a configurator implementation should have methods for doing these three actions for the above primitives or a subset of them (as we allow for multiple different configurator implementations to coexist).

### Network configurators

#### ifcfg configurator (persistent)

This configurator relies on ifcfg files placed in /etc/sysconfig/network-scripts/ and the ifup/ifdown bash scripts for controlling:

*   Vlans,
*   Bridges,
*   Bonds,
*   Nics.

It is important to note that this is the currently implemented interface of vdsm networking, and thus, the most likely to be the the first supported configurator via a refactoring of the current code.

#### IProute2 configurator (Non-persistent)

A configurator implementation could be made that supported:

*   Vlans: via the "ip link" cmdline tool (also used for mtu setting and upping/downing ifaces).
*   Bridges: via the "brctl" cmdline tool.
*   Bonds: via writes to /sys/class/net/bonding_masters (creation/removal of bonds) and /sys/class/net/bond_name/bonding/slaves (addition/removal of bond slaves).
*   Nics,
*   IpConfig: via the "ip addr" and "ip route" cmdline tools.

#### Open vSwitch configurator (persistent by default)

This configurator would preferably use the Python bindings to the Open vSwitch database (or alternatively the "ovs-vsctl" cmdline tool) to establish configuration of:

*   Vlans,
*   Bridges,
*   Special bond kernel module defined by Open vSwitch could be supported as well,
*   Additionally, other capabilities like QoS and portMirroring could be leveraged.

#### NetworkManager configurator (persistent and non-persistent, via temp. connections)

NetworkManager provides a D-Bus endpoint that could be used from Python to set up (once support for all of them stabilizes):

*   Vlans,
*   Bridges,
*   Bonds,
*   IpConfig.

#### Team configurator (persistent and non-persistent via ip)

Team is the newfangled kernel module + userspace daemon for replacing bonding. Thus, it would support:

*   "Bonds". A conf file can be passed to the teamd daemon, or an interface can be created/modified via the "ip link" and "ip addr" cmdline tool.

### Live Netinfo instance

The goal of this action point is to have a thread that on the beginning polls the network state of the host and then registers to the network events to update the internal objects. To avoid race conditions, setupNetworks and other network modifying operations should get a copy of the object before starting work.

The thread could work in the following way:

1.  Use the libnl library via ctypes to register to kernel multicast events.
2.  Use RTNLGRP_LINK to listen to link creation, deletion, upping and downing of links.
3.  Use RTNLGRP_IFADDR to list for address creation and deletion events.
4.  Parse the nl_msg to get the information of what changed.
5.  For each event, create a copy of the current Netinfo instance, do the modifications that the event entails and update the netinfo module reference to the live Netinfo objec to the new object.

### Objectified rollback

The configuration objects are serialized in /var/lib/vdsm/netconfback/ before each modification (typically setupNetworks). setSafeConfig deletes the rollback objects and, if the configuration is to be persistent, it is saved as the parameters to a setupNetworks command that is applied on service bootup.

## Open questions

*   Persistence: If and how do we handle interaction between multiple configurators that have different models of persistance, i.e., ifcfg and iproute2?

      The guess is that all the configurators should be made to work in a non persistent way, managing ourselves the persistence.

*   In case multiple configurators were to be supported and available to interact, how do the engine - host decide which configurator to use?
*   Do we need to support aliases or is the multiple ip address per interface support enough?
*   Do we keep persistence for the management network only or for all the configured networks.

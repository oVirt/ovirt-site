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

*   Implementing.

| Step                                   | Description                                                                                                                   | Completion |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|------------|
| Define object oriented representations | Find the best class representations for the network primitives for our usage                                                  | 95%        |
| Define internal API                    | Define the API that will establish the relationship between the new network representation and the multiple network backends. | 90%        |
| Live Netinfo instance                  | Define a way to keep a netinfo.Netinfo instance updated based on the representations of the first point.                      | Postponed  |
| ifcfg backend                          | refactor our current ifcfg-based implementation as backend, following the internal API.                                       | 85%        |
| IProute2 backend                       | Create a network backend from iproute2 tools, following the internal API.                                                     | 30%        |
| Objectified rollback                   | Modify the rollback mechanism into just feeding the pre-crash network object representation to the selected network backend   | 10%        |

## Components

In the following sections we will develop the action points expressed in the above table in detail (growing from community feedback) to give a proper idea of how the feature will look like when completed.

### Object oriented representations

The primitives to represent are:

*   Bridge,
*   Bond,
*   Nic,
*   VLAN,
*   IpConfig.

The first four count as NetDevices. The relationship is as follows:

1.  NetDevices may have IpConfig and mtu information.
2.  Bridges have ports that can be Bond, Nic and Vlan instances (or none, for nicless bridges).
3.  Bonds have slaves that are Nic instances.
4.  IpConfig objects contain information about the configured IPv4 addresses and a default gateway.
5.  Vlans can be set upon Nics and bonds.
6.  Each class contains the logic for validating the parameters received from the engine, based on its current state and relations to other objects (e.g a change to a bridge may be disallowed due to its currently-connected nic). This way, the responsibilities for wrong configuration detection are semantically localized.
7.  Each object should be able to contribute its part in generating the information for getVdsCaps. (Postponed due to leaving netinfo out of the initial refactoring).
8.  The following combinations of network elements are allowed:
    -   Single non-VLANed bridged network
    -   Multiple VLANed networks (bridged or bridgeless) with only a single non-VLANed bridgeless network.

#### NetDevice

*   name,
*   IPConfig
*   mtu
*   configurator: Reference to the configurator implementation that can apply/delete changes.

#### Bridge is a NetDevice

*   port: Could be a nic, a bond or a vlans.
*   forward_delay,
*   stp,

#### Bond is a NetDevice

*   slaves: nics or vlans,
*   options: Dictionary with stuff like mode and miimon.

#### VLAN

*   tag: The tag number of the VLAN.
*   device: A nic, bond or bridge that has the vlan on top.

#### Nic is a NetDevice

Nothing on top of NetDevice

#### Alias

*   Users have shown interest in the likes of `eth0:4`. We should find out if this is really required of oVirt.

#### IpConfig

*   inet: IPv4 address information (addr + netmask + gateway/route),
*   bootproto: whether it should use dhcp (dynamic) or static ip configuration.
*   async: whether the dynamic ip configuration should be asynchronous or not.

#### Network

It is an implicit entity, i.e., not represented by any class, but rather by the top object of a hierarchy, e.g. , for a bridgeless network set on a nic, the network would be the nic with its IPConfig.

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
*   Bridges:
    -   RHEL6.x via the "brctl" cmdline tool.
    -   Newer distros:
        -   Creation: ip link add bridge_name type bridge,
        -   Add master to bridge: ip link set ethX master bridge_name.
*   Bonds:
    -   RHEL6.x: via writes to /sys/class/net/bonding_masters (creation/removal of bonds) and /sys/class/net/bond_name/bonding/slaves (addition/removal of bond slaves).
    -   Newer distros:
        -   Creation: ip link add bondX type bond,
        -   Addition of ethernet: ip link set ethX master bondX.
*   Nics,
*   IpConfig: via the "ip addr" and "ip route" cmdline tools.

#### Open vSwitch configurator (persistent. Non persistence would require a service cleaning ovs-db at boot-time)

This configurator would preferably use the Python bindings to the Open vSwitch database (or alternatively the "ovs-vsctl" cmdline tool) to establish configuration of:

*   Vlans,
*   Bridges,
*   Special bond kernel module defined by Open vSwitch could be supported as well,
*   Additionally, other capabilities like QoS and portMirroring could be leveraged.

The assistance of iproute2 configurator would be needed to set ip addresses on ovs-configured interfaces.

#### NetworkManager configurator (persistent and non-persistent, via temp. connections)

NetworkManager provides a D-Bus endpoint that could be used from Python to set up (once support for all of them stabilizes):

*   Vlans,
*   Bridges,
*   Bonds,
*   IpConfig.

#### Team configurator (persistent and non-persistent via ip)

Team is the newfangled kernel module + userspace daemon for replacing bonding. Thus, it would support:

*   "Bonds". A conf file can be passed to the teamd daemon, or an interface can be created/modified via the "ip link" and "ip addr" cmdline tool.

### Live Netinfo instance (Postponed)

The goal of this action point is to have a thread that on the beginning polls the network state of the host and then registers to the network events to update the internal objects. To avoid race conditions, setupNetworks and other network modifying operations should get a copy of the object before starting work.

The thread could work in the following way:

1.  Use the libnl library via ctypes to register to kernel multicast events.
2.  Use RTNLGRP_LINK to listen to link creation, deletion, upping and downing of links.
3.  Use RTNLGRP_IFADDR to list for address creation and deletion events.
4.  Parse the nl_msg to get the information of what changed.
5.  For each event, create a copy of the current Netinfo instance, do the modifications that the event entails and update the netinfo module reference to the live Netinfo objec to the new object.

### Unified persistence

The old-style ifcfg persistence currently defined on the ConfigWriter class will be kept and will be selectable by setting:

*   /etc/vdsm/vdsm.conf

         persistence = ifcfg

If that is not specified, the unified persistence will be used. The way in which it works is the following:

1.  After each successful addNetwork/delNetwork writes a network and bond

         dictionary serialization (using json) to:
         /run/vdsm/nets/
         /run/vdsm/bonds/

1.  After setSafeConfig atomically copies:

         /run/vdsm/nets/* -> /var/lib/vdsm/nets/
         /run/vdsm/bonds/* -> /var/lib/vdsm/bonds/

1.  Split vdsm-restore-net service in:

         - vdsm-remove-net-persistance (before network.service): Deletes all the persistance done by the configurator and also removes libvirt's  persistent vdsm networks. For ifcfg that would be:
           a) Remove all the ifcfg-* files that have the newly defined vdsm header: "# This file was created by vdsm. Do not edit it, as it is not persisted across reboots."
           b) Remove libvirt networks starting with vdsm-*
         - vdsm-restore-persistent-nets (after vdsmd.service): Constructs a setupNetwork command by putting together the networks and bonds in /var/lib/vdsm/nets and /var/lib/vdsm/bonds and calls vdsCli setupNetworks

We should make sure that \`rpm -V vdsm\` is happily quiet even after setSafeConfig, unlike now

      # rpm -V vdsm
      missing     /var/lib/vdsm/netconfback

## Open questions

*   In case multiple configurators were to be supported and available to interact, how do the engine - host decide which configurator to use?

/etc/vdsm/vdsm.conf has a setting

         configurator = ifcfg

*   Do we keep persistence for the management network only or for all the configured networks?

Until the engine vdsm syncing is improved, we persist all the configured networks.

<Category:Feature> <Category:Networking>

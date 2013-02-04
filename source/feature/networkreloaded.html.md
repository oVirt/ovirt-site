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

### Summary

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
    -   Allow for the possibility to have event response actions to fix network problems.

### Owner

*   Name: [ Antoni Segura Puimedon](User:APuimedo)
*   Email: apuimedo aT redhat.com

### Current status

*   Planning, designing and prototyping.

| Step                                   | Description                                                                                                                   | Completion |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|------------|
| Define object oriented representations | Find the best class representations for the network primitives for our usage                                                  | 20%        |
| Define internal API                    | Define the API that will establish the relationship between the new network representation and the multiple network backends. | 0%         |
| Live Netinfo instance                  | Define a way to keep a netinfo.Netinfo instance updated based on the representations of the first point.                      | 10%        |
| IProute2 backend                       | Create a network backend from iproute2 tools, following the internal API.                                                     | 10%        |
| Objectified rollback                   | Modify the rollback mechanism into just feeding the pre-crash network object representation to the selected network backend   | 0%         |

### Components

In the following sections we will develop the action points expressed in the above table in detail (growing from community feedback) to give a proper idea of how the feature will look like when completed.

#### Object oriented representations

The primitives to represent are:

*   Bridge,
*   Bond,
*   Nic,
*   VLAN,
*   IpConfig.

The relationship is as follows:

1.  Bridge, Bonds and Nics have both IpConfig information.
2.  Bridges have ports that can be Bond, Nic and Vlan instances.
3.  Bonds have slaves that are Nic or Vlan instances.
4.  IpConfig objects contain information about the configured IPv4 and IPv6 addresses(they can have multiple of each), routes mtu and link state.
5.  Vlans can be set upon Nics, and bonds.
6.  Each class contains the logic for validating the parameters received from the engine, this way, the responsibilities for wrong configuration detection are semantically localized.
7.  Each object should be able to contribute its part in generating the information for getVdsCaps.

A netinfo object would have a list of the top hierarchy objects and generate the info from that.

##### Bridge

*   ports: Could be nics, bonds or vlans,
*   name,
*   forward_delay,
*   stp,
*   priority,
*   IpConfig,
*   backend: Reference to the configurator that can apply/delete the configuration.

##### Bond

*   name,
*   slaves: nics or vlans,
*   opts: Dictionary with stuff like mode and miimon.
*   IpConfig,
*   backend: Reference to the configurator that can apply/delete the configuration.

##### Nic

*   name.
*   IpConfig,
*   backend: Reference to the configurator that can apply/delete the configuration.

##### IpConfig

*   inet: List of IPv4 address information (addr + netmask + gateway/route),
*   inet6: List of IPv6 address information (addr + netmask + gateway/route).
*   MTU: Max. Transfer Unit,
*   LinkActive: True/False,
*   backend: Reference to the configurator that can apply/delete the configuration.

##### VLAN

*   Tag: The tag number of the VLAN.
*   Interface: A nic, bond or bridge that has the vlan on top.
*   IPConfing,
*   backend: Reference to the configurator that can apply/delete the configuration.

#### Define internal API

The internal API should allow for an objectified network definition (from setupNetworks and/or rollback) to be applied consistently regardless of which backend provides it. That includes:

*   Creation,
*   Edition,
*   Deletion.

Thus, a backend should have methods for doing these three actions for the above primitives or a subset of them (as we allow for multiple different backends to coexist.

#### Live Netinfo instance

The goal of this action point is to have a thread that on the beginning polls the network state of the host and then registers to the network events to update the internal objects. To avoid race conditions, setupNetworks and other network modifying operations should get a copy of the object before starting work.

The thread could work in the following way:

1.  Use the libnl library via ctypes to register to kernel multicast events.
2.  Use RTNLGRP_LINK to listen to link creation, deletion, upping and downing of links.
3.  Use RTNLGRP_IFADDR to list for address creation and deletion events.
4.  Parse the nl_msg to get the information of what changed.
5.  For each event, create a copy of the current Netinfo instance, do the modifications that the event entails and update the netinfo module reference to the live Netinfo objec to the new object.

#### IProute2 network backend

A backend could be made that used the following tools to apply network configuration:

1.  ip link: To create vlans, set mtus, upping and downing interfaces.
2.  ip addr: To add/remove IPv4 and IPv6 addresses (with their netmasks).
3.  ip route: To add/remove routes and set gateways.
4.  brctl: To create, delete bridges and add/remove its ports.
5.  Writing to /sys/class/net/bonding_masters: Create/remove bonds.
6.  Writing to /sys/class/net/bond_name/bonding/slaves: Add remove slaves of bonds.

#### Objectified rollback

Using setsafeconfig will serialize to /var/lib/vdsm/netconfback/ the live Netinfo object. In case of crash, this Netinfo instance will be recovered and reapplied.

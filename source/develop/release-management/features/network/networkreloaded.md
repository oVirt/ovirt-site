---
title: NetworkReloaded
category: feature
authors:
  - amuller
  - apuimedo
  - danken
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

*   Name: Antoni Segura Puimedon (APuimedo)
*   Email: apuimedo aT redhat.com

## Current status

*   Tuning and tweaking.

| Step                                   | Description                                                                                                                   | Completion |
|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|------------|
| Define object oriented representations | Find the best class representations for the network primitives for our usage                                                  | 100%       |
| Define internal API                    | Define the API that will establish the relationship between the new network representation and the multiple network backends. | 100%       |
| Live Netinfo instance                  | Define a way to keep a netinfo.Netinfo instance updated based on the representations of the first point.                      | Postponed  |
| ifcfg backend                          | refactor our current ifcfg-based implementation as backend, following the internal API.                                       | 100%       |
| IProute2 backend                       | Create a network backend from iproute2 tools, following the internal API.                                                     | 90%        |
| Objectified rollback                   | Modify the rollback mechanism into just feeding the pre-crash network object representation to the selected network backend   | 100%       |

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

#### Bridge

It is a NetDevice.

*   port: Could be a nic, a bond or a vlans.
*   forward_delay,
*   stp,

#### Bond

It is a NetDevice.

*   slaves: nics or vlans,
*   options: Dictionary with stuff like mode and miimon.

#### VLAN

It is a NetDevice.

*   tag: The tag number of the VLAN.
*   device: A nic, bond or bridge that has the vlan on top.

#### Nic

It is a NetDevice.

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

#### Motivation

VDSM is on a path to deprecate the usage of initscripts. We currently use initscripts to supply both networking persistence and configuration. The iproute2 configurator will replace the usage of initscripts for configuration, and unified network persistence will supply the new persistence model. The new network model will have three uses (All currently supplied by the ifcfg persistence model, saved at /etc/sysconfig/network-scripts)

1.  Persist networking configuration through host reboots
2.  Provide rollback mechanisms for the iproute2 configurator (In case an add/delNetwork fails midway due to an exception or connectivity loss we rollback any changes made)
3.  Provide an easily accessible representation of the current networking configuration

#### ifcfg Persistence Overview (History)

*   Persistence:

To ensure that any networking configuration changes are persisted we use initscripts. These are network device configuration files saved at /etc/sysconfig/network-scripts (In Red Hat based distributions). Upon host reboot the 'network' service is started, which looks for those configuration files and configures the network devices accordingly. We supply an additional feature where the network admin can mark a networking configuration as 'safe' from the engine. Marking the current configuration as safe is done via the 'setSafeConfig' verb. Upon host bootup, the current implementation looks for the existence of ifcfg in a specific VDSM folder. If these files exist then they are copied over to /etc/sysconfig/network-scripts, and when the 'network' service is started it will use these newly copied files. The 'setSafeConfig' then simply deletes the backups from the backups folder, marking the ifcfg files in /etc/sysconfig/network-scripts 'final'.

*   Rollbacks:

The 'set current networking configuration as safe' feature is only done on host bootup, and is separate from the rollback feature. We rollback any failed add/delNetwork if an exception was thrown, or if the operation succeeded but it caused networking connectivity loss to the host. These rollbacks are done by backing up any changes made to ifcfg files before actually writing the files during an add/delNetwork verb. If an exception is thrown or a networking connectivity loss is detected we bring back the backups and perform the needed ifdown/ifups.

*   Networking configuration lookup:

The ifcfg files provide a convenient way to lookup the current networking configuration, such as the boot protocol on a device, or the bonding options on a bond.

#### Implementation Overview

We've defined two new terms:

*   Running configuration - A mirror of the setupNetworks verbs received from the engine. We keep a list of networks and a list of bonds that are maintained during add/delNetwork. So if a setupNetworks was received that adds two networks and edits a third, followed by another setupNetworks that deletes the the first new network, the running configuration will contain only the second network, and the newly edited third network. Any bonding changes are maintained as well in the bonds list.
*   Persistent configuration - During the 'setSafeConfig' verb we copy the running configuration from one folder to another. Any changes made between 'setSafeConfig' received from the engine are only reflected in the running configuration.

1.  The persistent configuration is used for networking persistence on host reboot.
2.  The running configuration is used for rollbacks - We know the state of the running configuration before the start of an add or delNetwork, and we know what was added or deleted, and so we can use the diff to revert any changes using setupNetworks itself. (Note: As of 23/09/2013 this part is still unimplemented and is under debate).
3.  We also use the running configuration to perform lookups of the current networking configuration.

#### Implementation Details

The persistence model may be selected by editing

*   /etc/vdsm/vdsm.conf

And setting:

         net_persistence = [ifcfg | unified]

1.  When VDSM gets a new setupNetworks, it breaks it into a series of addNetwork and delNetwork (Currently editNetwork is done via a del followed by an add). After each successful add or del network we then persist the new network and bond changes, represented by dictionary and written to disk via json serialization to:
    -   /var/run/vdsm/netconf/nets/
    -   /var/run/vdsm/netconf/bonds/

2.  After setSafeConfig we atomically copy:
    -   var/run/vdsm/netconf/nets/\* -> /var/lib/vdsm/persistence/netconf/nets
    -   var/run/vdsm/netconf/bonds/\* ->/var/lib/vdsm/persistence/netconf/bonds

3.  Split vdsm-restore-net service to:
    -   vdsm-remove-net-persistence (before network.service): Deletes all the persistence done by the configurator and also removes libvirt's persistent vdsm networks. For ifcfg that would be:
        -   Remove all the ifcfg-\* files that have the newly defined vdsm header: "# This file was created by vdsm. Do not edit it, as it is not persisted across reboots."
        -   Remove libvirt networks starting with vdsm-\*
    -   vdsm-restore-persistent-nets (after vdsmd.service): Constructs a setupNetwork command by putting together the networks and bonds in /var/lib/vdsm/nets and /var/lib/vdsm/bonds and calls vdsCli setupNetworks

We should make sure that \`rpm -V vdsm\` is happily quiet even after setSafeConfig.

## Open questions

*   In case multiple configurators were to be supported and available to interact, how do the engine - host decide which configurator to use?

/etc/vdsm/vdsm.conf has a setting

         net_configurator = ifcfg

*   Do we keep persistence for the management network only or for all the configured networks?

Until the engine vdsm syncing is improved, we persist all the configured networks.

## Special previous behavior to maintain

If a bond had previous non-vdsm IP configuration (ipaddr + netmask), adding a bridgeless Network using this bond will not flush the ip config from the bond and the new ip config will be set as secondary IPv4 address. Removing the network will break the bond and remove any previous configuration

For nics, the previous scenario deletes the previous IP configuration and sets the new one.

## Upgrading to the unified persistence and iproute2 as configurators

### Flow 1 (No computer reboot)

1.  Edit /etc/vdsm/vdsm.conf so that the vars section has at least:
        [vars]
        net_persistence = unified
        net_configurator = iproute2

2.  restart vdsm
        service vdsmd stop
        service supervdsmd stop
        service vdsmd start

     This will have loaded the unified persistence's RunningConfig and PersistentConfig.

3.  restore vdsm networks
        vdsm-tool restore-nets

     This will use RunningConfig (from step 2) to take down the networks set up by the old configurator, flush all the configurators config files and finally use the PersistentConfig (from step 2) to recover the networking.

4.  You're done ;-)

### Flow 2 (Computer reboot)

1.  Edit /etc/vdsm/vdsm.conf so that the vars section has at least:
        [vars]
        net_persistence = unified
        net_configurator = iproute2

2.  Reboot your computer.
    What will happen is:
    1.  on reboot, the old configurator files will still be there. They will be picked up by that configurator (its init service should still be enabled for this flow to succeed),
    2.  The upgrade script will run generating RunningConfig and PersistentConfig
    3.  /usr/share/vdsm/vdsm-restore-net-config will run and will do the equivalent of step 3 of the flow above.
        </li>

3.  You're done ;-)


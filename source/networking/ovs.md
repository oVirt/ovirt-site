---
title: ovs
category: networking
authors: phoracek
---

# ovs

## Summary

This hook enables us to create selected networks and bonds as Open vSwitch devices.

## Contact

*   Name: Petr Horacek (Phoracek)
*   Email: phoracek aT redhat.com

## Installation

### Host

This hook is dependent on openvswitch package. If you use RHEL/CentOS you might install an extra repository or the package itself.

`yum install `[`https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm`](https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm)

The hook can be installed from oVirt 3.6 Nightly repo or newer.

      yum install vdsm-hook-ovs
      systemctl start openvswitch
      systemctl enable openvswitch

### Engine

Add custom vNic device property.

      engine-config -s CustomDeviceProperties="{type=interface;prop={ovs=.*}}"

Add custom property for network setup, so we can mark a network as OVS network.

      engine-config -s 'UserDefinedNetworkCustomProperties=ovs=.*;ovs_aa_sid=.*'

Don't forget to include the names of other custom network properties you may want to use, such as 'ethtool_opts'.

Restart engine to apply changes.

      systemctl restart ovirt-engine

## Usage

### Create OVS network

In the oVirt UI open 'Networks' tab and create a new network. Then select the network, open its 'vNIC Profiles' tab and click 'Edit'. Now select custom 'ovs' parameter in the bottom of opened dialog and set it value to 'true'.

### Setup network

In the oVirt UI open the 'Setup Host Networks' dialog. Proceed to editing a desired logical network's properties. Among them you will find 'ovs', set it to 'true' or '1' to mark is as a OVS Network.

### Setup bonding

In the oVirt UI open the 'Setup Host Networks' dialog. Merge two networks. In opened 'Create New Bond' dialog select 'Bonding Mode' 'Custom' and set it to 'ovs=True'.

### Dummy interfaces

If you want to use Open vSwitch to connect several VMs without internet connectivity (and physical nic), you could use a dummy interface.

On the host, create a dummy interface:

      ip link add dummy_1 type dummy

Then select the host in oVirt UI and click on 'Refresh Capabilities' button. Created nic should appear in Host's 'Network Interfaces' tab and you should be able to attach a OVS network to it.

## Limitations

*   OVS to non-OVS and non-OVS to OVS network changes are not possible in one editation. It is necessary to first remove old network and then add a new one. Because of this, we are not able to change management network to OVS.
*   Only one untagged network
*   STP only on untagged network
*   All networks are bridged
*   Tested only with ifcfg configurator. OVS rollback probably won't be working with iproute2 or pyroute2 configurators

## TODO

### Test vlans

Test if we do proper trunking.

### Configure SELinux

SELinux in Enforcing mode on Fedora 22 causes OVS problems. That can be temporally ignored with Permissive mode.

      setenforce 0

### Faster rollback

Now in case of a rollback, we remove all OVS networks and bonds and then recreate them. This could be improved with changing just what have to be changed as we do in iproute2 rollback.

### Implement QoS

Linux HFSC QoS is supported by OVS and could be set up via ovs-vsctl as described [here](http://openvswitch.org/ovs-vswitchd.conf.db.5.pdf)

### Implement 'multicast_router' and 'multicast_snooping'

This feature is not supported by openvswitch until 2.4.0 We need to be able to set and get those values. It should be possible via 'mcast_snooping_enable' records, described [here](http://openvswitch.org/ovs-vswitchd.conf.db.5.pdf)

### Define multiple OVS Bridge instances

Now custom network property 'ovs' is passing only True, we could change it to pass an integer and then create OVS network under 'ovsbr$INT' OVS Bridge instance.

### Fix networkTestsOVS.py dependencies

It is possible that this test fail would cause problems when vdsm-hook-ovs package is installed without vdsm-tests.

### Better OVS command logging

Now we log created OVS command as one long string. It would be nice to split commands with new lines and add 'comment' about what was done with certain sub-command.

### Allow non-OVS to OVS and OVS to non-OVS changes

Now we do not handle the situation when OVS network is changed into non-OVS and vice versa. non-OVS=>OVS editation should be easy, we could handle it within a before_network_setup hook. OVS=>non-OVS editation is harder, while we have to first remove non-OVS network and then create OVS network after_network_setup.

### Network persistence

An easy way would be to remove all OVS networks on startup (as we do in rollback) and then let persistence restoration to recreate it all.

### Call \`sysctl enable openvswitch\` on initial configuration

### Report bridge options (like netinfo._bridge_options)

We need to report at least some of bridge options. It is not possible to read them the same way as with native Linux bridges.

### Better dhclient handling

When we configure dhclient over a network and then setup fails, dhclient is not rolled back. We also should handle dhclient return code.


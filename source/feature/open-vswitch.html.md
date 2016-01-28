---
title: Open vSwitch
category: feature
authors: phoracek
wiki_category: Feature
wiki_title: Features/Open vSwitch
wiki_revision_count: 8
wiki_last_updated: 2016-01-28
feature_name: Open vSwitch
feature_modules: Networking
feature_status: Under construction
---

# Open vSwitch

## Summary

This feature enables us to create selected networks and bonds as Open vSwitch devices.

### Owner

*   Name: [ Petr Horacek](User:Phoracek)
*   Email: phoracek aT redhat.com

## Installation

### Host

This feature is dependent on openvswitch package. If you use RHEL/CentOS you might install an extra repository or the package itself.

`yum install `[`https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm`](https://repos.fedorapeople.org/repos/openstack/openstack-kilo/rdo-release-kilo-1.noarch.rpm)

If you want to enable this feature, set net_ovs_mode property in /etc/vdsm/vdsm.conf to 'enabled' and restart vdsmd service.

### Engine

Add custom property for network setup, so we can mark a network as OVS network.

      engine-config -s 'UserDefinedNetworkCustomProperties=ovs=.*;ovs_aa_sid=.*'

Don't forget to include the names of other custom network properties you may want to use, such as 'ethtool_opts'.

Restart engine to apply changes.

      systemctl restart ovirt-engine

## Usage

### Setup network

In the oVirt UI open the 'Setup Host Networks' dialog. Proceed to editing a desired logical network's properties. Among them you will find 'ovs', set it to 'true' or '1' to mark is as a OVS Network.

### Setup bonding

In the oVirt UI open the 'Setup Host Networks' dialog. Merge two networks. In opened 'Create New Bond' dialog select 'Bonding Mode' 'Custom' and set it to 'ovs=True'.

### Dummy interfaces

If you want to use Open vSwitch to connect several VMs without internet connectivity (and physical nic), you could use a dummy interface.

On the host, create a dummy interface:

      ip link add dummy_1 type dummy

Then select the host in oVirt UI and click on 'Refresh Capabilities' button. Created nic should appear in Host's 'Network Interfaces' tab and you should be able to attach a OVS network to it.

## TODO

### Handle broken networks like network/api.py

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

### Better OVS command logging

Now we log created OVS command as one long string. It would be nice to split commands with new lines and add 'comment' about what was done with certain sub-command.

### Network persistence

An easy way would be to remove all OVS networks on startup (as we do in rollback) and then let persistence restoration to recreate it all.

### Call \`systemctl enable openvswitch\` on initial configuration

### Report bridge options (like netinfo._bridge_options)

We need to report at least some of bridge options. It is not possible to read them the same way as with native Linux bridges.

### Create OVS unit tests

### Add OVS testing to networkTests.py

### If OVS is enabled, start openvswitch service on vdsmd startup

### Overwrite unchanged networks

If running config does not differ from to-be-setup network, we do nothing. Maybe it would be better to remove and recreate such network (maybe it's broken in system and somone is trying to fix it).

### Test if openvswitch service is running

### New config parameter 'enabled_default'

With this parameter, all networks sent from engine will be handled as OVS=1 unless OVS=0 is explicitly declared.

### Enable ovs options in Engine by default

### Raise exception on dhclient fail

<Category:Feature> <Category:Networking>

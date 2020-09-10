---
title: Multiple Gateways
category: feature
authors: amuller, danken, lpeer
---

# Multiple Gateways

## Summary

Currently it is assumed that the host-wide default gateway is the gateway defined on the ovirtmgmt logical network. This feature will enable the user to define a gateway per logical network.

The feature is only relevant for deployments with hosts with more than one network device. Without the feature, any traffic going in the device that needs to be returned to a network not directly on the host will be routed out through the default gateway regardless of the device which the traffic came in. With the feature, any traffic going in that needs to be returned to a network outside of the host's own subnets will be routed back via the device that the traffic came in through.

The motivation is to ensure that if outside traffic was routed through a firewall to the host, then it will be returned the way it came in through the same firewall. Additionally, if a special administrative network (Mainly display network) was placed on a device then this feature ensures that return traffic will remain on the same display network and not router back from the host's default gateway, which may be a different network.

Previously users solved the issue with source routing manually, this feature simply automates the process.

## Owner

*   Name: Assaf Muller (amuller)
*   Email: <amuller@redhat.com>

## Current Status

*   oVirt-3.3
*   Merged, bug fix stage


## Why do we need multiple gateways?

The need for a gateway per network has emerged from the need to support other host networks (not VM networks) beside the management one.

As an example, migration and storage networks can be defined, each passing dedicated traffic (one for storage communication and another for VM migration traffic), they may need to pass through different gateways.  So the management network can be accessed using gateway A, storage using B and migration using C. A will usually be set on a host level as the host default gateway, and the others will be set for the individual networks.  Otherwise, there would be no way for your storage to use a different router (than the management one) in the network.


oVirt assumes that the host's default gateway is the gateway defined on the ovirtmgmt network. With that in mind: Multiple oVirt users use this network topology:

![](/images/wiki/Multiple_Gateways_Topology.png)

The administrator created a new network and set it as the display network. The oVirt host is connected to two networks: ovirtmgmt (10.0.0.0) via eth0, and the display network (20.0.0.0) via eth1. A user on a different subnet than the host then connected to the engine, selected a VM on the host and then opened a new Spice console. Network data can reach the host, but all return traffic will route to the host's default gateway, which is the gateway defined on ovirtmgmt, reached via eth0. The return traffic will reach R1, but R1 doesn't have a route to the user's laptop and thus the packets will be dropped at R1. In other words, Spice won't work.

More simply put, pings won't work from the user's laptop to the oVirt host, assuming they are not located on the same network. The traffic will reach the host successfully, but all return traffic will be routed through the host's default gateway via eth0. The packets will reach R1 and will then be dropped as R1 cannot route to the user's laptop.

Currently, clients manually edit the host's init scripts and set a different gateway for the display network. This can become problematic to maintain with a large amount of hosts. The multiple gateways feature will automate this process.

## User Experience

The only change needed in the GUI is in the setup networks dialog. When editing an IP configuration, we need to enable the gateway field for all networks, not only ovirtmgmt. If the user chose static IP, then the gateway field should be added and be editable. If DHCP was chosen then the gateway field should be visible and display the gateway configured via DHCP.

## Proposed Solution

### The Manual Solution

The manual solution, or how Linux system admins setup multiple gateways on a host is to create a routing table for each IP subnet configured on the host, and source routing rules to use each table as appropriate. Meaning, if a packet is destined towards the IP configured on the host's eth0 (For example: 10.0.0.1), then when creating a return packet, the source IP will be 10.0.0.1. The host will then go over his configured rules and see that when routing **from** 10.0.0.1, he must use a specific routing table, which holds the gateway for the 10.0.0.0 network. In other words, all traffic to 10.0.0.1 will return via 10.0.0.1's NIC, and all traffic to another IP of the host, will return via that IP's NIC instead. That way, traffic goes out the same way it came in.

More information about iproute2 source routing may be found at: <http://www.policyrouting.org/iproute2-toc.html>

### Manual Configuration Example

The zeus02 host is connected via eth0 to one router, and via eth1 (bridged over ovirtmgmt) to another router. We configured the display network on the eth0 NIC.

**The ip address on eth0:**

![](/images/wiki/Eth0_ip.png)

**The ip address on ovirtmgmt:**

![](/images/wiki/Ovirtmgmt_ip.png)

**A list of the host's routing tables:**

![](/images/wiki/Rt_tables.png)

**The routing table setup for eth0:**

![](/images/wiki/Eth0_table.png)

**The routing table setup for ovirtmgmt:**

![](/images/wiki/Ovirtmgmt_table.png)

**The rules which tell the host when to use each routing table:**

![](/images/wiki/Ip_rule.png)

And finally, here's the host's main routing table. Any traffic coming **in** to the host will use the ip rules and an interface's routing table. The main routing table is only used for traffic originating **from** the host.

![](/images/wiki/Ip_route.png)

### Automatic Solution

The proposed solution is to create a python script that expects an interface's new IP address, subnet mask, network name and gateway. The script will then use the appropriate commands to generate a new routing table, populate it with two rows: One to link the network ip range with the NIC, and another that defines the gateway. Finally, the script will add two new rules that define when to use the new routing table. Of course, the rules define to use the new routing table whenever traffic is destined to or from the new ip network range. For an example, see the previous section. Another script will be created that reverses the aforementioned effects.

**DHCP:** During VDSM installation, an additional script will be created under /etc/dhcp/dhclient.d/, called sourceRouting.sh. We will use DHCP hooks to call our new scripts whenever a DHCP interface is brought up or down.

**Static IP:** We'll call the aforementioned script for statically configured interfaces during addNetwork and delNetwork. Two files will be created during addNetwork. delNetwork will delete the same files. The files are route-<interface> and rule-<interface>, placed in /etc/sysconfig/network-scripts. New routing rules will be placed in the route file, and new rules in the rule file. Both of these files are called during the ifup init script.

**Summary:** Multiple gateways code will be called whenever a DHCP interface goes up or down (Via our DHCP hook), and will create and delete the needed rules every time it is called. For statically configured interfaces, it will be called once during addNetwork, and once during delNetwork. These runs will place init scripts, that in turn will be called during ifup and ifdown.

### Upgrading

When a host upgrades to a VDSM that supports multiple gateways all of its interfaces will have no source routing configured. Any new setup networks will configure source routing on the affected networks / interfaces. Since the current implementation keeps the management network as the host's default gateway, connectivity should never be lost and no actual upgrade script is offered.

### API

#### Vdsm

A significant advantage of the currently proposed implementation is that no API change between the Engine and VDSM is needed. VDSM is capable of distilling the gateways from the current setupNetworks verb.

#### REST and Engine

Currently, only when setting the management network, a gateway may be specified. With this feature, each network with static address may have a gateway, that would control source routing for that address.

## Testing

*   Set up networking as described [above](#why-do-we-need-multiple-gateways). Most importantly, place your spice client outside of the hosts' own subnet.
*   Verify that spice traffic travels through the designated host.
*   Test the above both with static addresses and with DHCP.

## External References


*   On the arch@ovirt.org mailing list.


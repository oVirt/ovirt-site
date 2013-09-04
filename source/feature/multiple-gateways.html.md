---
title: Multiple Gateways
category: feature
authors: amuller, danken, lpeer
wiki_category: Feature
wiki_title: Features/Multiple Gateways
wiki_revision_count: 27
wiki_last_updated: 2013-11-06
---

# Multiple Gateways

### Summary

Currently it is assumed that the host-wide default gateway is the gateway defined on the ovirtmgmt logical network. This feature will enable the user to define a gateway per logical network.

### Owner

*   Name: [ Assaf Muller](User:amuller)
*   Email: <amuller@redhat.com>
*   IRC: amuller at #ovirt (irc.oftc.net)

### Current Status

*   oVirt-3.3
*   Merged, bug fix stage
*   Last updated: ,

### Why do we need multiple gateways?

Now, oVirt assumes that the host's default gateway is the gateway defined on the ovirtmgmt network. With that in mind: Multiple oVirt users use this network topology:

![](Multiple_Gateways_Topology.png "Multiple_Gateways_Topology.png")

The administrator created a new network and set it as the display network. The oVirt host is connected to two networks: ovirtmgmt (10.0.0.0) via eth0, and the display network (20.0.0.0) via eth1. A user on a different subnet than the host then connected to the engine, selected a VM on the host and then opened a new Spice console. Network data can reach the host, but all return traffic will route to the host's default gateway, which is the gateway defined on ovirtmgmt, reached via eth0. The return traffic will reach R1, but R1 doesn't have a route to the user's laptop and thus the packets will be dropped at R1. In other words, Spice won't work.

More simply put, pings won't work from the user's laptop to the oVirt host, assuming they are not located on the same network. The traffic will reach the host successfully, but all return traffic will be routed through the host's default gateway via eth0. The packets will reach R1 and will then be dropped as R1 cannot route to the user's laptop.

Currently, clients manually edit the host's init scripts and set a different gateway for the display network. This can become problematic to maintain with a large amount of hosts. The multiple gateways feature will automate this process.

### User Experience

The only change needed in the GUI is in the setup networks dialog. When editing an IP configuration, we need to enable the gateway field for all networks, not only ovirtmgmt. If the user chose static IP, then the gateway field should be added and be editable. If DHCP was chosen then the gateway field should be visible and display the gateway configured via DHCP.

### Proposed Solution

#### The Manual Solution

The manual solution, or how Linux system admins setup multiple gateways on a host is to create a routing table for each IP subnet configured on the host, and source routing rules to use each table as appropriate. Meaning, if a packet is destined towards the IP configured on the host's eth0 (For example: 10.0.0.1), then when creating a return packet, the source IP will be 10.0.0.1. The host will then go over his configured rules and see that when routing **from** 10.0.0.1, he must use a specific routing table, which holds the gateway for the 10.0.0.0 network. In other words, all traffic to 10.0.0.1 will return via 10.0.0.1's NIC, and all traffic to another IP of the host, will return via that IP's NIC instead. That way, traffic goes out the same way it came in.

More information about iproute2 source routing may be found at: <http://www.policyrouting.org/iproute2-toc.html>

#### Manual Configuration Example

The zeus02 host is connected via eth0 to one router, and via eth1 (bridged over ovirtmgmt) to another router. We configured the display network on the eth0 NIC.

**The ip address on eth0:**

![](Eth0 ip.png "Eth0 ip.png")

**The ip address on ovirtmgmt:**

![](Ovirtmgmt ip.png "Ovirtmgmt ip.png")

**A list of the host's routing tables:**

![](Rt_tables.png "Rt_tables.png")

**The routing table setup for eth0:**

![](Eth0 table.png "Eth0 table.png")

**The routing table setup for ovirtmgmt:**

![](Ovirtmgmt table.png "Ovirtmgmt table.png")

**The rules which tell the host when to use each routing table:**

![](Ip rule.png "Ip rule.png")

And finally, here's the host's main routing table. Any traffic coming **in** to the host will use the ip rules and an interface's routing table. The main routing table is only used for traffic originating **from** the host.

![](Ip route.png "Ip route.png")

#### Automatic Solution

The proposed solution is to create a python script that expects an interface's new IP address, subnet mask, network name and gateway. The script will then use the appropriate commands to generate a new routing table, populate it with two rows: One to link the network ip range with the NIC, and another that defines the gateway. Finally, the script will add two new rules that define when to use the new routing table. Of course, the rules define to use the new routing table whenever traffic is destined to or from the new ip network range. For an example, see the previous section. Another script will be created that reverses the aforementioned effects.

**DHCP:** During VDSM installation, an additional script will be created under /etc/dhcp/dhclient.d/, called sourceRouting.sh. We will use DHCP hooks to call our new scripts whenever a DHCP interface is brought up or down.

**Static IP:** We'll call the aforementioned script for statically configured interfaces during addNetwork and delNetwork. Two files will be created during addNetwork. delNetwork will delete the same files. The files are route-<interface> and rule-<interface>, placed in /etc/sysconfig/network-scripts. New routing rules will be placed in the route file, and new rules in the rule file. Both of these files are called during the ifup init script.

**Summary:** Multiple gateways code will be called whenever a DHCP interface goes up or down (Via our DHCP hook), and will create and delete the needed rules every time it is called. For statically configured interfaces, it will be called once during addNetwork, and once during delNetwork. These runs will place init scripts, that in turn will be called during ifup and ifdown.

#### Upgrading

When upgrading a host to the VDSM version that will support multiple gateways, multiple scenarios are possible. The bottom line is that the current proposal is to offer no upgrade script, and let the users know what steps they must take if they upgrade VDSM and want to utilize the multiple gateways feature.

**Scenario 1:** The user already setup multiple gateways using source routing and multiple routing tables. Any network added will work as expected. Networks deleted won't delete the rules and table created previously by the user. If the same network is added again the new rules and routing table we insert might conflict with the previous rules / routing table that was not deleted, and so their insertion might fail.

**Scenario 2:** The user only used one NIC and one network (ovirtmgmt). When adding a 2nd network, its rules and routing table will be created, **and the default gateway in the main routing table will be changed to be that of the new network.** This is because the proposed solution, apart from creating new rules and a routing table, also writes a network's gateway in the NIC's cfg file. Meaning that whenever the NIC is activated, its gateway is inserted into the main routing table. Only one gateway may reside in a routing table at a time, so whenever a NIC is activated its gateway replaces the one currently residing in the main routing table. Back to scenario 2: The host's gateway in the main routing table will be changed to that of the new network, and ovirtmgmt doesn't have its own rules or routing table, and so any traffic originating from ovirtmgmt will use the new network's gateway. To summarize: The user must be advised to sync the ovirtmgmt network in order to create its rules and routing table during or after the addition of the new network.

**Scenario 3:** The user had multiple networks, but only configured ovirtmgmt's gateway via the engine, and did not use manual source routing. This scenario is similar in effect to the previous one, and the user must again be advised to sync the ovirtmgmt network in order to generate the required routing table and rules after upgrading the host.

#### API

##### Vdsm

A significant advantage of the currently proposed implementation is that no API change between the Engine and VDSM is needed. VDSM is capable of distilling the gateways from the current setupNetworks verb.

##### REST and Engine

Currently, only when setting the management network, a gateway may be specified. With this feature, each network with static address may have a gateway, that would control source routing for that address.

### Testing

*   Set up networking as described [ above](#Why_do_we_need_multiple_gateways.3F). Most importantly, place your spice client outside of the hosts' own subnet.
*   Verify that spice traffic travels through the designated host.
*   Test the above both with static addresses and with DHCP.

### External References

### Comments and Discussion

*   On the arch@ovirt.org mailing list.

<Category:Feature> <Category:Networking>

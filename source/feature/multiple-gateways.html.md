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
*   No patches currently submitted to VDSM or the Engine. Solution currently being researched at the VDSM side, work not assigned yet at the Engine side.
*   Last updated: ,

### Why do we need multiple gateways?

Now, oVirt assumes that the host's default gateway is the gateway defined on the ovirtmgmt network. With that in mind: Multiple oVirt users use this network topology:

![](Multiple_Gateways_Topology.png "Multiple_Gateways_Topology.png")

The administrator created a new network and set it as the display network. The oVirt host is connected to two networks: ovirtmgmt (10.0.0.0) via eth0, and the display network (20.0.0.0) via eth1. A user then connected to the engine, selected a VM on the host and then opened a new Spice console. Network data can reach the host, but all return traffic will route to the host's default gateway, which is the gateway defined on ovirtmgmt, reached via eth0. The return traffic will reach R1, but R1 doesn't have a route to the user's laptop and thus the packets will be dropped at R1. In other words, Spice won't work.

More simply put, pings won't work from the user's laptop to the oVirt host. The traffic will reach the host successfully, but all return traffic will be routed through the host's default gateway via eth0. The packets will reach R1 and will then be dropped as R1 cannot route to the user's laptop.

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

And finally, here's the host's main routing table. Note that in this configuration the main routing table is **never used**, however it still has some significance during an upgrade process. This will be explained later in the upgrade section of this document.

![](Ip route.png "Ip route.png")

#### Automatic solution

*   One bash script that installs rules, table
*   VDSM installation places a hook in /etc/dhcp that links to our script
*   ifup/down on an interface calls our script if the interface is dhcp
*   What if the interface is statically configured?

#### Upgrading

*   Don't do anything. Tell the users to re-add/sync ovirtmgmt so that its rules, table are created

#### API

No change.

### External References

### Comments and Discussion

*   On the arch@ovirt.org mailing list.

<Category:Feature> <Category:Networking>

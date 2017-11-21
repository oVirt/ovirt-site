---
title: LLDP Information Now Available via the Administration Portal 
author: amusil
tags: webadmin, networking
date: 2017-10-27 09:00:00 CET
---

In oVirt 4.2 we have introduced support for the Link Layer Discovery Protocol (LLDP). 
It is used by network devices for advertising the identity and capabilities to 
neighbors on a LAN. The information gathered by the protocol can be used for better 
network configuration.[Learn more about LLDP](https://learningnetwork.cisco.com/docs/DOC-26851).

READMORE

## Why do you need LLDP?

When adding a host into oVirt cluster, the network administrator usually needs to attach
various networks to it. However, a modern host can have multiple interfaces, each 
with its non-descriptive name. 

## Examples

In the screenshot below, taken from the Administration Portal, a network administrator has to know
to which interface to attach the network named `m2` with VLAN_ID 162. Should it be interface 
`enp4s0`, `ens2f0` or even `ens2f1`? With oVirt 4.2, the administrator can hover over `enp4s0` 
and see that this interface is connected to peer switch `rack01-sw03-lab4`, and learn that this 
peer switch does not support VLAN 162 on this interface. By looking at every interface, the 
administrator can choose which interface is the right option for network`m2`.
 
![screen](../images/blog/2017-10-27/regular.png)


A similar situation arises with the configuration of mode 4 bonding (LACP). Configurating LACP 
usually starts with network administrator defining a port group on their switch. These ports are 
are physically connected to interfaces in a hypervisor. But to which of the many interfaces that 
this hypervisor may have? 

For example, when creating`bond0` (See screenshot below), it is important to pick interfaces that 
are connected to the same switch, and that these ports belong to the same `port group`. Often, an 
oVirt administrator might choose the wrong interfaces, and end up with badly configured bonds. 

With LLDP information, this can easily be avoided. The administrator can tell which is the peer of 
each interface, and to which port group it is connected. For example, `enp4s0` is 
connected to port `GigabitEthernet0/9` and `enp6s0` is connected to port
`GigabitEthernet0/10` on the same peer switch named `rack03-sw02-lab4`. 

![screen](../images/blog/2017-10-27/bond0_0.png)

![screen](../images/blog/2017-10-27/bond0_1.png)


The final screenshot (below) shows the information available to the administrator via
the Administration Portal. This includes System name, Port description, Aggregation information, MTU, VLAN IDs and names.

![screen](../images/blog/2017-10-27/every_info.png)


## Where to find the LLDP information?

Log in the **Administration Portal**. From the vertical menu select **Compute** > 
**Hosts** and choose a host by clicking on its Name link. 
Select **Network Interfaces** > **Setup Host Networks**. Hover over each interface to reveal a tooltip
with the relevant information.

### Non-UI approach

The LLDP information is also exposed via REST API. 
More information is available in [REST API documentation](http://ovirt.github.io/ovirt-engine-api-model/4.2/#services/link_layer_discovery_protocol).






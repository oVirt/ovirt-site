---
title: Quantum and oVirt
authors: garyk
wiki_title: Quantum and oVirt
wiki_revision_count: 17
wiki_last_updated: 2012-06-06
---

# Quantum and oVirt

The [Quantum](http://wiki.openstack.org/Quantum) project provides "network connectivity as a service". Quantum is a standalone Network Virtualization service that is currently part of the [OpenStack](http://wiki.openstack.org/) project. It uses a “plug-in” architecture, so that multiple technologies can implement the logical abstractions, which provides a “building block” for sophisticated cloud network topologies.

Quantum currently supports several publicly available plugins:

*   [Open vSwitch](http://openvswitch.org/)
*   Cisco UCS/Nexus
*   Linux Bridge
*   [Nicira Network Virtualization Platform (NVP)](http://nicira.com/)
*   [Ryu OpenFlow Controller](http://www.osrg.net/ryu/using_with_openstack.html)

Integrating Quantum into oVirt enables oVirt to make use of emerging networking technologies, for example, [OpenFlow](http://www.openflow.org/), via one or more of the above mentioned plugins.

This page will address the following:

*   Integration Ideas
*   Flows
*   Open Issues

### Integration Ideas

This section will discuss a number of integration ideas. Ideally we would like to maintain the existing interfaces with minimal changes. The following will be addressed:

*   User Interface
*   Back End
*   VDSM

For each of the above the following will be addressed:

*   Logical Network Management - this will be managed by Quantum
*   Host Management - this is not addressed by the scope of Quantum. The Quantum agents run on the Hosts, hence the hooking and management to the agents is important.

#### User Interface

##### Logical Network Management

The functionality here should not be changed. The interface with the Quantum service will be shielded from the user. The user will only be aware of Quantum when it comes to the Host Management.

##### Host Management

The [interface](:Image:q_ovirt_host.png) ![](q_ovirt_host.png "fig:q_ovirt_host.png") currently has the following format:

| Name | Address | MAC | Speed (Mbps) | Rx (Mbps) | Tx (Mbps) | Drops (Mbps) | Bond | VLAN | Network Name |
|------|---------|-----|--------------|-----------|-----------|--------------|------|------|--------------|
|      |         |     |              |           |           |              |      |      |              |

In order to support Quantum the table can be modified as follows:

| Name | Address | MAC | Speed (Mbps) | Rx (Mbps) | Tx (Mbps) | Drops (Mbps) | Bond | Fabric | Network Name |
|------|---------|-----|--------------|-----------|-----------|--------------|------|--------|--------------|
|      |         |     |              |           |           |              |      |        |              |

The ***Fabric*** will be the networking fabric, that is, the networking implementation. This can be one of the following:

*   VDSM - the traditional networking
*   Quantum - a Quantum network. If this is Quantum then it should indicate the supported plugin. This can be an open source plugin or a commercial plugin.

If the user wishes to see the *characteristics* of the network then they can click on the network name. In the case of traditional VDSM networks this will show the VLAN tag. It may show additional information for a Quantum network, for example GRE tunnel information.

#### Back End

##### Logical Network Management

*   Network Creation
*   Network Deletion
*   VM Creation
*   VM Deletion

##### Host Management

#### VDSM

*   Logical Network Management
*   Host Management

#### Flows

*   Logical Network Management
*   Host Management

### Flows

### Open Issues

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

The Quantum Service is a process that runs the Quantum API web server (port 9696) and is responsible for loading a plugin and passing each API call to the plugin for processing. The Quantum service should run on the oVirt Engine. The API utilizes the following logical abstractions:

*   **Network**: An isolated L2 segment, analogous to a single physical L2 switching device with an arbitrary number of ports.
*   **Port**: Provide a connection point to a Quantum network. Port states are either *DOWN* or *ACTIVE*.
*   **Attachment**: Identifier of an interface device to be *plugged in* to a Quantum port, such as a vNIC.

Each of the above is represented by a UUID. oVirt should save all of the UUID's with the relevant artifacts that make use of the information, namely the logical network and the virtual machines. The usage of these will be discussed below.

##### Logical Network Management

*   Network Creation - If the network is in a cluster that contains a host that uses a Quantum fabric then the Quantum service will need to allocate a UUID for the network. This is done by sending a *network create* message to the service with the name of the logical network.
*   Network Deletion - If a logical network is deleted and the logical network has a UUID (assigned above) then the Quantum service needs to be notified. This is done by sending a *network delete* message with the UUID.
*   VM Creation - If the host that is to run the VM uses a Quantum fabric then a Quantum port needs to be assigned to the VM for each vNIC on a Quantum network. This is done by sending a *port create* message to the service with the UUID of the network. The Quantum service will return the UUID of the port. A port attachment UUID should be generated.
*   VM Start - The port attachment UUID is passed with the port to the Quantum service. This is done by sending a *interface plug* message to the service with the UUID of the network and the UUID of the port. The following information should be passed to VDSM (VDSM functionality will be dealt with in more detail below):
    -   Quantum plugin type (q_plugin)
    -   Quantum Network UUID (q_network_id)
    -   Quantum Port UUID (q_port_id)
    -   Quantum Attachment UUID (q_attachment_id)
*   VM Stop - If the host that is to run the VM uses a Quantum fabric then after an event that the VM has been stopped, oVirt engine will need to unplug the attach interface. This is done by sending a *interface unplug* message to the service with the UUID of the network and the UUID of the port.
*   VM Deletion - If a Quantum port is assigned to the VM then this should be deleted. This is done by sending a *port delete* message to the service with the UUID of the network. The Quantum service will return the UUID of the port.
*   VM Migration - If the VM is moved from Host A to Host B then the follows needs to be done:
    -   If Host B supports Quantum then send the following information to VDSM on Host B (VDSM will create the necessary artifacts):
        -   Quantum plugin type (q_plugin)
        -   Quantum Network UUID (q_network_id)
        -   Quantum Port UUID (q_port_id)
        -   Quantum Attachment UUID (q_attachment_id)
    -   Move the VM from Host A to Host B
    -   If Host A supports Quantum then send the following information to VDSM on Host A (VDSM can remove the artifacts):
    -   Quantum plugin type (q_plugin)
    -   Quantum Network UUID (q_network_id)
    -   Quantum Port UUID (q_port_id)
    -   Quantum Attachment UUID (q_attachment_id)

In order to implement the above a REST client needs to be implemented in the oVirt engine.

##### Host Management

#### VDSM

*   Logical Network Management
*   Host Management

#### Flows

*   Logical Network Management
*   Host Management

### Flows

### Open Issues

---
title: Quantum and oVirt
authors: garyk
---

<!-- TODO: Content review -->

# Quantum and oVirt

The [Quantum](http://wiki.openstack.org/Quantum) project provides "network connectivity as a service". Quantum is a standalone Network Virtualization service that is currently part of the [OpenStack](http://wiki.openstack.org/) project. It uses a “plug-in” architecture, so that multiple technologies can implement the logical abstractions, which provides a “building block” for sophisticated cloud network topologies.

Quantum currently supports several publicly available plugins:

*   [Open vSwitch](http://openvswitch.org/)
*   Cisco UCS/Nexus
*   Linux Bridge
*   [Nicira Network Virtualization Platform (NVP)](http://nicira.com/)
*   [Ryu OpenFlow Controller](http://www.osrg.net/ryu/using_with_openstack.html)

Integrating Quantum into oVirt enables oVirt to make use of emerging networking technologies, for example, [OpenFlow](http://www.openflow.org/), via one or more of the above mentioned plugins.

## Integration Ideas

This section will discuss a number of integration ideas. Ideally we would like to maintain the existing interfaces with minimal changes. The following will be addressed:

*   User Interface
*   Back End
*   VDSM

For each of the above the following will be addressed:

*   Logical Network Management - this will be managed by Quantum
*   Host Management - this is not addressed by the scope of Quantum. The Quantum agents run on the Hosts, hence the hooking and management to the agents is important.

### User Interface

#### Logical Network Management

The functionality here should not be changed. The interface with the Quantum service will be shielded from the user. The user will only be aware of Quantum when it comes to the Host Management.

#### Host Management

The [interface](:Image:q_ovirt_host.png) ![](q_ovirt_host.png "fig:q_ovirt_host.png") currently has the following format:

| Name | Address | MAC | Speed (Mbps) | Rx (Mbps) | Tx (Mbps) | Drops (Mbps) | Bond | VLAN | Network Name |
|------|---------|-----|--------------|-----------|-----------|--------------|------|------|--------------|
|      |         |     |              |           |           |              |      |      |              |

In order to support Quantum the table can be modified as follows:

| Name | Address | MAC | Speed (Mbps) | Rx (Mbps) | Tx (Mbps) | Drops (Mbps) | Bond | Fabric | Network Name |
|------|---------|-----|--------------|-----------|-----------|--------------|------|--------|--------------|
|      |         |     |              |           |           |              |      |        |              |

The ***Fabric*** will be the networking fabric, that is, the networking implementation. The user should be able to receive a list of the supported fabric types. This can be one of the following:

*   VDSM - the traditional networking
*   Quantum - a Quantum network. If this is Quantum then it should indicate the supported plugin. This can be an open source plugin or a commercial plugin.

**NOTE:** a pull down with the fabric types is based on the capabilities supported by VDSM (discussed in the VDSM section).

If the user wishes to see the *characteristics* of the network then they can click on the network name. In the case of traditional VDSM networks this will show the VLAN tag. It may show additional information for a Quantum network, for example GRE tunnel information.

### Back End

The Quantum Service is a process that runs the Quantum API web server (port 9696) and is responsible for loading a plugin and passing each API call to the plugin for processing. The Quantum service should run on the oVirt Engine. The API utilizes the following logical abstractions:

*   **Network**: An isolated L2 segment, analogous to a single physical L2 switching device with an arbitrary number of ports.
*   **Port**: Provide a connection point to a Quantum network. Port states are either *DOWN* or *ACTIVE*.
*   **Attachment**: Identifier of an interface device to be *plugged in* to a Quantum port, such as a vNIC.

Each of the above is represented by a UUID. oVirt should save all of the UUID's with the relevant artifacts that make use of the information, namely the logical network and the virtual machines. The usage of these will be discussed below.

#### Logical Network Management

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

#### Host Management

The oVirt engine should send the configured fabric information to VDSM. The following may be sent to VDSM:

*   Plugin installation packages (if necessary)
*   Plugin configuration details
*   Plugin connectivity details

VDSM will use the above to interface with the Quantum plugin if necessary.

**NOTE:** The Host Operational status will need to be addressed differently with a Quantum network.

### VDSM

If the host that is running VDSM requires a Quantum agents then VDSM should run the agent. The agent package can and may be received from the oVirt Engine or can be downloaded via RPM's. In addition to the treatment below VDSM should also maintain a health check to the Quantum agent, that is, if for some reason the agent crashes, for example an exception, then VDSM should restart the agent.

#### Logical Network Management

If the message received from the oVirt engine contains Quantum plugin information then VDSM should treat accordingly. The device name is created from the q_attachment_id. That is:

      ''deviceName = tap + q_attachment_id[0:11]

**NOTE:** The tap device created uses an "ethernet" network device. This means that the creation of the libvirt XML file is a bit different. For example [libvirtvm.py](https://github.com/gkotton/vdsm_quantum) lines 962 - 982.

Each agents has its own spefic code [https://github.com/gkotton/vdsm_quantum quantum.py](https://github.com/gkotton/vdsm_quantum quantum.py). For example Open vSwitch:

*   VM Start
    -   Open vSwitch commands:

      ''/sbin/ip tuntap add $deviceName mode tap
      ''/sbin/ip link set $deviceName up
      ''/usr/bin/ovs-vsctl -- --may-exist add-port br-int $deviceName 
      ''  -- set Interface $deviceName external-ids:iface-id=q_attachment_id  
      ''  -- set Interface $deviceName external-ids:iface-status=active 
      ''  -- set Interface $deviceName external-ids:attached-mac=$macAddr 
      ''-- set Interface $deviceName external-ids:vm-uuid=vmUuid

*   VM Stop
    -   Open vSwitch:

      ''/usr/bin/ovs-vsctl del-port br-int $deviceName
      ''/sbin/ip link delete $deviceName

**NOTE:** When a communication channel is established between VDSM and the oVirt engine. The VDSM host should notify the oVirt Engine of the Quntum fabric that is supported.

#### Host Management

The oVirt engine will notify VDSM of the physical interfaces to attach to the Quantum network. The treatment is agent specific. In the case of Open vSwitch the following should happen:

*   Update the integration port details add:

       ''ovs-vsctl -- add-port br-int $interfaceName

*   Update the integration port details delete:

       ''ovs-vsctl -- del-port br-int $interfaceName

In the case of the Linux Bridge the agent may have to be stopped and then restarted.

## Open Issues

The current Quantum model has a number of gaps and limitations with respect to integration with oVirt. These are:

*   Networking support
    -   MTU support
    -   Port mirroring
    -   Permissions and ownership
    -   SLA's
*   Product specific issues
    -   Versioning, backward compatibility
    -   Ability to support a heterogeneous data center:
        -   Non-uniform connectivity (i.e. not all computing resources can access the same physical networks)
        -   Non-uniform technology (i.e. different plugins)
    -   Database support
    -   Error handling

## Documentation / External references

<https://fedoraproject.org/wiki/Quantum_and_oVirt>



---
title: Quantum IPAM Integration
authors: danken, lpeer, mkolesni
wiki_title: Quantum IPAM Integration
wiki_revision_count: 36
wiki_last_updated: 2012-11-29
---

# Quantum IPAM integration

### Overview

Quantum offers layer 3 Network services which are not yet available in oVirt.

This page is a proposal for oVirt-Quantum integration focused on leveraging the IP Address Management service offered by Quantum.

### How it works in Quantum

![Quantum IPAM general overview](QuantumDHCPOverview.png "Quantum IPAM general overview")

**Modules**

*   Quantum service - The management module for the networking configuration.

<!-- -->

*   DHCP Agent - The module responsible to configure dnsmask per network.

<!-- -->

*   Layer 3 driver - The module responsible to create the network locally.

<!-- -->

*   Queues - There are two of them, one is used for the DHCP Agent to get notifications and the other is used to sync the DHCP Agent and the Quantum service configuration upon startup/error.

#### Port creation dynamics

V2 API: <http://wiki.openstack.org/Quantum/APIv2-specification#Create_Port>

When a port (e.g. virtual NIC of a VM) is created it is assigned to a network.

The MAC address of the port can either be specified or generated automatically by Quantum Service.

If the network has subnets then the port will be assigned an IP on the subnet:

*   Automatically on some subnet if no subnet id is specified
*   Directly on a specific subnet if the subnet id is specified
*   Directly on a subnet & with a given IP if both subnet id & IP are specified

The port is then part of the quantum DB.

Summary:

*   The port MAC & IP are determined/known by the user, before the VM is up.

#### DHCP Agent dynamics

![Quantum DHCP Agent notification handling](QuantumDHCPNotifications.png "fig:Quantum DHCP Agent notification handling") Quantum's DHCP Agent syncs with the network/subnet/port state on it's start from the Quantum service.

For each Network with DHCP enabled and defined subnet(s), the DHCP Agent:

*   Submits a network creation request to the layer 3 driver plugin.
*   Write port definitions (MAP + IP) to a conf file
*   Spawn a dnsmasq instance with the defined ranges (CIDRs) and the conf file

After the initial sync, the DHCP Agent is getting notifications from the quantum service on each network/subnet and port change. In case of an error the DHCP initiates new sync process.

This process occurs for **ALL** networks defined in the quantum service.

Notes:

*   The dnsmasq is a lightweight DHCP server, which can lease DHCP addresses.
*   According to the DHCP protocol, there can be several DHCP servers active in a network without interfering with each other.

Summary:

*   One or more Quantum DHCP Agents can run simultaneously for each network, serving the addresses defined in Quantum Service.

### Integrating with oVirt

##### Difference in architecture

Whereas Quantum is designed for the homogeneous hardware use-case, to manage one physical network on which multiple virtual networks are created by tenants, oVirt is designed to support also the heterogeneous hardware use-case which means:

*   Not all the virtual networks share the same physical layer
*   Not all networks are available on all hosts
*   Not all virtual networks are implemented using the same technology.

##### Other points to consider

The asynchronous nature of Quantum Service & Quantum DHCP Agent communication can result in a race between the VM start and the DHCP server ability to serve the VM it's IP address.

When port is created, the quantum service allocates ip for that port sends a notification for the DHCP Agent and returns. The DHCP receives the port-create notification asynchronously, updates the dnsmasq configuration file and reloads the configuration.

If the VM was able to start before the dnsmasq is updated then the vNIC might fail to acquire an IP from the DHCP.

This means that in order to gain IPAM capabilities, [One does not simply integrate Quantum into oVirt](http://memegenerator.net/instance/30762058)

#### Integration Path

##### One host to rule them all

The first option we considered and seemed to be the simple one is to have the Quantum Service and the DHCP agent sit in oVirt with a "fake plugin" that will not change anything in the physical network.

The downsides to this approach:

*   All the networks that require the IPAM capability will have to be connected to this host.
*   We cannot have multiple DHCP servers running for HA, so if for some reason the DHCP fails then we can't allocate IP addresses.

The downsides above seems to be too critical for us to overlook, so we were looking for another integration option.

##### DHCP Agent running on the host

A general outline of the approach:

![](QuantumIPAMIntegration.png "QuantumIPAMIntegration.png")

oVirt engine and Quantum Service with the "oVirt plugin" are running on a single host. The Quantum DHCP agent is running on the host with access to the network they want to allocate IP addresses on. We can have multiple DHCP Agents deployed on the various hosts in the data center.

The Quantum DHCP agent uses a layer 3 driver. The driver is responsible for creating the network interface which the DHCP server is connected to. We'll create oVirt driver which will make the call if a DHCP Agent for a given network is required on the specific host. The driver will use a file written by VDSM to determine if the network should have DHCP on this host or not and act accordingly.

A new VDSM verb will allow to set for which networks the DHCP server should be active.

setDHCP(List<networkName, networkQuantumId>)

The method will work as follows:

*   If list is not empty:
    -   Save list items (id + net name) to a file.
    -   (Re)Start the Quantum DHCP Agent.
*   If list is empty:
    -   Stop Quantum DHCP Agent.

In the oVirt engine there would be a DHCPManager which is responsible for the management of the DHCP servers.

*   If a DHCP server is needed (Host went offline for some reason) then start one on another host with this network.
*   If a DHCP server is no longer needed then stop it from a host.

For each network it would be possible to configure at least one DHCP servers.

The downsides to this approach:

*   The DHCP Agent requires a knowledge of the Quantum Service URI in order to communicate with it.
*   In case Run VM is performed right after Setup Networks on the same host, The DHCP Agent might not be started in time, which might cause a VM's vNIC not acquire an IP lease.

![Flow of oVirt operations mapped to Quantum actions](OVirtQuantumFlow.png "Flow of oVirt operations mapped to Quantum actions")

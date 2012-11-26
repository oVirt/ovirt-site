---
title: Quantum IPAM Integration
authors: danken, lpeer, mkolesni
wiki_title: Quantum IPAM Integration
wiki_revision_count: 36
wiki_last_updated: 2012-11-29
---

# Quantum IPAM integration

### Overview

![Quantum IPAM general overview](QuantumDHCPOverview.png "Quantum IPAM general overview")

Quantum offers layer 3 Network services which are not yet available in oVirt.

This page is a proposal for oVirt-Quantum integration focused on leveraging the IP Address Management service offered by Quantum.

### Port creation dynamics

V2 API: <http://wiki.openstack.org/Quantum/APIv2-specification#Create_Port>

When a port is created it is assigned to a network.

The MAC address of the port can either be specified or generated automatically by Quantum Service.

If the network has subnets then the port will be assigned an IP on the subnet:

*   Automatically on some subnet if no subnet id is specified
*   Directly on a specific subnet if the subnet id is specified
*   Directly on a subnet & with a given IP if both subnet id & IP are specified

The port is then part of the quantum DB, and if needed is created by the plugin.

**Bottom line:** The port MAC & IP are determined/known by the user, even before the VM is up.

### DHCP Agent dynamics

![Quantum DHCP Agent notification handling](QuantumDHCPNotifications.png "Quantum DHCP Agent notification handling")

Quantum's DHCP Agent syncs with the network/subnet/port state on it's start from the Quantum service.

The basic way of operation is this:

*   If there is a network with DHCP enabled then
    -   If the network has subnets with DHCP enabled then
        -   Write port definitions (MAP + IP) to a conf file
        -   Spawn a dnsmasq instance with the defined ranges (CIDRs) and the conf file

The dnsmasq is a lightweight DHCP server, which can lease DHCP addresses.

According to the DHCP protocol, there can be several DHCP servers active in a network without interfering with each other - the client will choose whichever lease he prefers and will use that IP.

It then listens on notifications coming from the service a-synchronously, and acts upon them.

If a notification requires action then it acts on it accordingly.

It is noteworthy that the DHCP Agent doesn't discriminate networks/subnets/ports - it will serve all of them which are defined in the Quantum Service that it is communicating with.

**Bottom line:** One or more Quantum DHCP Agents can run simultaneously for each network, serving the addresses defined in Quantum Service.

### Integrating with oVirt

#### Difference in architecture

Whereas Quantum is designed for the cloud use-case, to manage one physical network on which multiple virtual networks are created by tenants, oVirt is designed for the virtualization use-case where multiple physical networks can exist on different data-centers or even in the same data-center.

Furthermore, Quantum relies on a L2 plugin to provision certain aspects of the physical network, whereas oVirt is using linux bridge through VDSM.

Additionally, the asynchronous nature of Quantum Service & Quantum DHCP Agent communication mean that when port is created, the DHCP will not be updates instantly and there could occur a race between the DHCP update and the VM start in which case the vNIC might fail to acquire an IP from the DHCP.

This means that in order to gain IPAM capabilities,

![](OneDoesNotSimplyIntegrateQuantumIntoOvirt.jpg "OneDoesNotSimplyIntegrateQuantumIntoOvirt.jpg")

#### One host to rule them all

The simplest solution is to have the Quantum Service sit in oVirt with a "fake plugin" that will not change anything in the physical network.

This way oVirt can talk to Quantum Service locally and we have a single copy of the data of Quantum (perhaps Quantum can query the network/subnet/port data from oVirt?).

Also if we run the Quantum DHCP Agent on the same machine then we can easily deploy all together, and integration is easier (only 2 additional services to manage overall).

The downsides to this approach:

*   Major: All the networks that require the IPAM capability will have to be connected to this host.
    -   This is not plausible in the virtualization use-case.
*   Minor: We cannot have multiple DHCP servers running for HA, so if for some reason the DHCP fails then we can't allocate IP addresses.

#### DHCP Agent per network

![Flow of oVirt operations mapped to Quantum actions](OVirtQuantumFlow.png "Flow of oVirt operations mapped to Quantum actions")

A general outline of the approach:

![](QuantumIPAMIntegration.png "QuantumIPAMIntegration.png")

As in the previous solution, the oVirt host will also run Quantum Service & the "fake plugin",

For each network there will be possible to configure at least one DHCP server should be available.

A new VDSM verb will allow to set for which networks the DHCP server should be active:

*   If list is empty, turn off Quantum DHCP Agent.
*   If list is not empty:
    -   Save list items (id + net name) to a file.
        -   ID would probably need to be Quantum ID.
    -   Turn on the Quantum DHCP Agent.

The Quantum DHCP agent has a driver which is responsible for creating the network interface the DHCP server is connected to.

The driver will be a "fake" driver which will read the file written by VDSM to determine if the network should have DHCP on this host or not.

There would be a DHCPManager class which is responsible for the management of the DHCP servers.

*   If a DHCP server is needed (Host went offline for some reason) then start one on another host with this network.
*   If a DHCP server is no longer needed then stop it from a host.

The downsides to this approach:

*   Moderate: Quantum needs to be installed on each host (at least DHCP agent requirements).

<!-- -->

*   Moderate/Minor: The host now needs to know at least the Quantum Service URI in order to communicate with it.

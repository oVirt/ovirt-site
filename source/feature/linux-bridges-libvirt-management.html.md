---
title: linux bridges libvirt management
authors: alkaplan, danken, ibarkan
wiki_title: Feature/linux bridges libvirt management
wiki_revision_count: 11
wiki_last_updated: 2015-11-08
feature_name: Manage oVirt bridges with libvirt
feature_modules: engine,vdsm, api
feature_status: Design
---

# linux bridges libvirt management

## Manage oVirt bridges with libvirt

### Summary

This feature adds SR-IOV support to oVirt management system (which is currently available via a vdsm-hook [1](http://www.ovirt.org/VDSM-Hooks/sriov) only).

### Owner

*   Name: [ Ido Barkan](User:ibarkan)
*   Email: <ibarkan@redhat.com>

### Introduction

Since version 1.2.11, libvirt is able to manage the its network bridges FDB (forwarding database, used to determine the correct egress port for packets based on destination MAC address) instead of the kernel. The kernel does it, typically, by using learning, flooding, and promiscuous mode on the bridge's ports in order to determine the proper egress port for packets. Since libvirt is aware of every virtual network device that is attached to the bridge, it can update the bridge's FDB accordingly at runtime.
This has several advantages:

*   Since libvirt disables learning and flooding on the bridge, the bridge should consume less CPU and perform better. Also, for each ingressframe with unknown destination MAC addresses, the frame will be immediately dropped by the bridge thereby reducing traffic on the LAN.
*   Libvirt also configures the bridge ports to stop forwarding packets with MAC addresses unknown to the bridge. As a side effect of this, the kernel can automatically disable promiscuous mode for this port, further reducing CPU consumption.

The use of this feature blocks several other networking setups in the host.

1.  Since libvirt enables vlan_filtering on the bridge, VMs will not be able to tag their own traffic.
2.  Since the bridge only handles MAC addresses that were explicitly configured by libvirt, VMs will not be able to spoof their MAC addresses or nest other virtual machines with unique LAN identity (with their own distinvt MAC address).

### High Level Feature Description

Since this feature might be wanted in some scenarios (for a possible better performance) but should be avoided in others (for blocking several other network setups), there is some business logic involved here that should be done by the engine.

#### VDSM

1.  A new boolean parameter is added to setupNetworks, for each bridged network (defaults False): *manage_macs_with_libvirt*. This tells VDSM to ask libvirt to manage the network's bridge. For non-bridged network, this parameter has no effect. Like all other parameters, this is seriallized and persisted in the disk upon a call to setSafeNetworkConfig and will be restored during boot.
2.  When reporting networks in getCapabilities, under the networks section "manage_macs_with_libvirt'' will be reported for each bridged network.

*   Currently, VDSM asks libvirt to turn on a mac spoofing filter, that prevent VMs to spoof MAC addresses using ebtales. This is already part of the virtual network interface API and might vhnage some day. If it will, it will not work for managed bridges and be managed by the engine.

#### Engine

Currently, the engine

1.  Users should be able to turn on this feature on networks, but the engine should warn/prevent connecting virtual NICs to those networks if they are defined as being able to spoof MAC addresses, or tag their own traffic (see remarks above).

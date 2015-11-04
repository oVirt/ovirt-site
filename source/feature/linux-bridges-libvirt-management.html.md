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

*   Since libvirt enables vlan_filtering on the bridge, VMs will not be able to tag their own traffic.
*   Since the bridge only handles MAC addresses that were explicitly configured by libvirt, VMs will not be able to spoof their MAC addresses or nest other virtual machines with unique LAN identity (with their own distinvt MAC address).

#### High Level Feature Description

SInce this feature might be wanted in some scenarios (for a possible better performance) but should be avoided in others (for blocking several other network setups), there is some buisness logic involved here that should be done by the engine.

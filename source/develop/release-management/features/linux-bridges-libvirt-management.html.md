---
title: linux bridges libvirt management
authors: alkaplan, danken, ibarkan
feature_name: Manage oVirt bridges with libvirt
feature_modules: engine,vdsm, api
feature_status: Design
---

# linux bridges libvirt management

## Manage oVirt bridges with libvirt

### Owner

*   Name: Ido Barkan (ibarkan)
*   Email: <ibarkan@redhat.com>

### Introduction

Since version 1.2.11, libvirt is able to manage the network bridges FDB (forwarding database, used to determine the correct egress port for packets based on destination MAC address) instead of the kernel. The kernel does it, typically, by using learning, flooding, and promiscuous mode on the bridge's ports in order to determine the proper egress port for packets. Since libvirt is aware of every virtual network device that is attached to the bridge, it can update the bridge's FDB accordingly at runtime.
This has several advantages:

*   Since libvirt disables learning and flooding on the bridge, the bridge should consume less CPU and perform better. Also, for each ingress frame with unknown destination MAC addresses, the frame will be immediately dropped by the bridge thereby reducing traffic on the LAN.
*   Libvirt also configures the bridge ports to stop forwarding packets with MAC addresses unknown to the bridge. As a side effect of this, the kernel can automatically disable promiscuous mode for this port, further reducing CPU consumption.

The use of this feature blocks several other networking setups in the host.

1.  Since libvirt enables vlan_filtering on the bridge, VMs will not be able to tag their own traffic.
2.  Since the bridge only handles MAC addresses that were explicitly configured by libvirt, VMs will not be able to spoof their MAC addresses or nest other virtual machines with unique LAN identity (with their own distinct MAC address).

Both of these point are blocked anyway by our default vdsm-no-mac-spoofing filter, but we allow their use when installing vdsm-hook-macspoof, and would like to make allow their usage more prevalent with [this feature request](https://bugzilla.redhat.com/show_bug.cgi?id=1193224).

### High Level Feature Description

Since this feature might be wanted in some scenarios (for a possible better performance) but should be avoided in others (for blocking several other network setups), there is some business logic involved here that should be done by the engine.

#### VDSM

1.  A new boolean parameter is added to setupNetworks, for each bridged network (defaults False): *manage_macs_with_libvirt*. This tells VDSM to ask libvirt to manage the network's bridge. For non-bridged network, this parameter has no effect. Like all other parameters, this is seriallized and persisted in the disk upon a call to setSafeNetworkConfig and will be restored during boot.
2.  When reporting networks in getCapabilities, under the networks section "manage_macs_with_libvirt'' will be reported for each bridged network.

*   Currently, Engine asks VDSM to ask libvirt to turn on the no-mac-spoofing filter, that prevent VMs to spoof MAC addresses using ebtales. This is already part of the virtual network interface API and might chnage some day. If it will, it will not work for managed bridges and be managed by the engine.

#### Engine

1.  Users should be able to turn on this feature on networks, but the engine should warn/prevent connecting virtual NICs to those networks if they are defined as being able to spoof MAC addresses, or tag their own traffic (see remarks above).
2.  The ability to remove the mac spoofing filter from should be available in the engine in a vNIC profile.
3.  The engine should verify that allowing spoofing and automatically controlling a bridge are mutually exclusive.

#### Caveats

*   If VDSM will change its underlying netoworks implementation from Linux Bridges to OVS, then this feature might not be worth the investment since this Libvit API currently does not support OVS.

### Documentation / External references

[1](https://libvirt.org/formatnetwork.html#elementsConnect): libvirt documentation [2](https://gerrit.ovirt.org/#/c/47935/): VDSM gerrit patch.

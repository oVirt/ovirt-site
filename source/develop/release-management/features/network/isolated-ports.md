---
title: Isolated ports
category: feature
authors: dholler
---

# Isolated ports

## Summary

This feature enables you to prevent specific VMs on the same logical network
from communicating with and seeing each other.

The state of the feature is tracked in [[RFE] Private VLAN / port isolation
][1]. Related patches can be found on [gerrit topic:isolated_port][2].

## Owner

*   Name: [Aleš Musil](https://github.com/almusil)

*   Email: <amusil@redhat.com>


## Detailed Description

There are scenarios in which multiple VMs that share an uplink should not be
able to communicate with each other. For example when VMs are owned by multiple
customers. The shared uplink might be a connection to the gateway to the
outside network or the DHCP server.

In such scenarios, it is required to isolate the network connections of the VMs
per port, because filtering on MAC addresses does not address all cases,
e.g. [Bug 1651499][3] and [Bug 1651467][4].

Such scenarios can be addressed by creating a VLAN tagged logical network with a
dedicated IP subnet per VM, but this is a waste of the limited VLANs and subnets
as described by [Cisco][5].

For this reason switches commonly provide isolation per port.
There are two [popular implementation levels][6] of private VLAN:

* The simple level prevents ports from communicating with each other by not
  forwarding any traffic to any other isolated port.
  This is called [port isolation][7] in Linux, [private interfaces][8] in
  FreeBSD, or [PVLAN Edge (Protected Port)][14] in Cisco context, but probably
  every smart or managed switch provides a similar option.

* Advanced implementations, e.g. from [Cisco][5], [Juniper][8], [VMWare][9], or
  [Microsoft][10], support ideas based on [RFC 5517][11].

Very advanced implementations from  [Cisco][5], [Juniper][8], and [Microsoft][10]
even enable combining private VLANS with VLAN tagging.


The proposed new oVirt feature extends the [PVLAN Edge (Protected Port)][14]
feature of the switch to the connected Linux bridge on the oVirt host.

![Diagram of isolated port idea](/images/features/network/isolated_port.png)


## Prerequisites

The implementation requires a [Linux kernel][7] and [libvirt][13] with port
isolation support.

The switch connected to the oVirt hosts has to support [PVLAN Edge (Protected Port)][6].

## Limitations

Out of Scope:
* Updating the new attribute of the logical network.
* Configuring port isolation per vNIC or vNIC profile.
* The permitted uplink, which will be able to communicate with all VMs, is
  immutably the physical network.
* The attribute can only be true for Linux bridge based networks.
* There are many switch models, which are not able to combine the
  [PVLAN Edge (Protected Port)][14] with VLAN tagging. For this reason most
  users will not be able to add additional logical networks to the Ethernet
  port, which uses this feature.


## Benefit to oVirt

This feature will help to reduce the number of required VLAN tagged logical
networks.

## Implementation

### Entity Description

Logical networks will get a new boolean attribute. This attribute cannot be
updated after the network is created.
It is not possible to have this attribute on a VLAN profile, because this would
result in inconsistent behavior with the switch connected to the oVirt host.

### User Experience

On creating the network, the user can enable this feature for the new, not
external, VM networks via REST API or web UI.

### Libvirt XML

If the feature is activated for a logical network connected to a virtual NIC,
the libvirt XML definition of the virtual NIC contains the
[`<port isolated="yes"/>` element][15], as follows:

```
    <interface type="bridge">
      <model type="virtio"/>
      <link state="up"/>
      <source bridge="isolated_0"/>
      <port isolated="yes"/>
      <alias name="ua-6e2e236c-84e2-4601-83e4-2b1c66da46c9"/>
      <mac address="56:6f:74:24:00:02"/>
      <mtu size="1500"/>
      <filterref filter="vdsm-no-mac-spoofing"/>
      <bandwidth/>
    </interface>
```

### Ensuring the Prerequisites

The feature depends on libvirt from RHEL AV 8.3, because this version of
libvirt introduced support support for [isolated ports][13].

Engine has to ensure that VMs using this feature are scheduled only to
oVirt hosts which provides an appropriate version of libvirt.

For this reason, a cluster version dependent configuration value,
e.g. "IsPortIsolationSupported", is introduced and set to false for cluster
levels up to 4.4 . If a user is sure that she wants to use this feature already,
because all the oVirt hosts use AV 8.3, she could enable it for cluster level
4.4. The engine would allow only to connect adding relevant networks to VMs,
if IsPortIsolationSupported is true for the cluster level of the VM.

## Installation/Upgrade

The feature will not affect new or existing installations.

## User work-flows

1. The user ensures that there is an unused Ethernet port on all hosts in the
   relevant cluster.
2. Ensure that the switch prevents communication between the switch ports
   connected to the free Ethernet ports.
3. Create a new logical network and enables the attributes "VM Network" and
   "isolated".
4. Attach the new logical network to the unused Ethernet port on all relevant
   hosts in the cluster.
5. Attache the new logical network to a vNIC and run the VM.
6. Verify that two VMs on the same host cannot communicate with each other.
7. Verify that two VMs on separate hosts cannot communicate with each other.
8. Verify that these VMs can communicate with the external (northbound, uplink)
   network.

## Testing

to test the feature in oVirt, it is sufficient to ensure that two VMs on the
same host are able to communicate with the gateway, but not with each other.
For the single host scenario, it is not necessary to configure the switch.

## Documentation & External references

[Bug 1725166 - [RFE] Private VLAN / port isolation][1]

[1]: https://bugzilla.redhat.com/1725166

[gerrit topic:isolated_port][2]

[2]: https://gerrit.ovirt.org/#/q/topic:isolated_port


[Bug 1651499 - [clean-traffic-gateway filter] VM DHCP IP does not recover when
network operation is done from Guest ][3]

[3]: https://bugzilla.redhat.com/1651499

[Bug 1651467 - [clean-traffic-gateway filter] ARP packet is leaking between
blocked VMs][4]

[4]: https://bugzilla.redhat.com/1651467

[Cisco - Catalyst 4500 Series Switch Software Configuration Guide][5]

[5]: https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst4500/XE3-9-0E/15-25E/configuration/guide/xe-390-configuration/pvlans.html#77328

[Cisco - Private VLAN Catalyst Switch Support Matrix][6]

[6]: https://www.cisco.com/c/en/us/support/docs/switches/catalyst-6500-series-switches/10584-63.html

[Linux - net: bridge: add support for port isolation][7]

[7]: https://github.com/torvalds/linux/commit/7d850abd5f4edb1b1ca4b4141a4453305736f564

[FreeBSD Handbook - Chapter 31. Advanced Networking][8]

[8]: https://www.freebsd.org/doc/handbook/network-bridging.html

[Juniper - Private VLANs][9]

[9]: https://www.juniper.net/documentation/en_US/junos/topics/topic-map/private-vlans.html

[VMWare - Private VLANs][10]

[10]: https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.vsphere.networking.doc/GUID-A9287D46-FDE0-4D64-9348-3905FEAC7FAE.html

[Microsoft - Private Virtual Local Area Network (PVLAN) and Trunk Mode][11]

[11]: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj679878(v%3Dws.11)#private-virtual-local-area-network-pvlan-and-trunk-mode

[RFC 5517][12]

[12]: https://tools.ietf.org/html/rfc5517

[Bug 1727263 - [RFE] Add support for port isolation on linux bridge][13]

[13]: https://bugzilla.redhat.com/1727263

[Cisco - Private Vlan Edge (protected ports)][14]

[14]: https://www.cisco.com/en/US/tech/tk389/tk814/tk841/tsd_technology_support_sub-protocol_home.html

[libvirt - Isolating guests's network traffic from each other][15]

[15]: https://libvirt.org/formatdomain.html#elementPort

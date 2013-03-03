---
title: Device Custom Properties
category: feature
authors: alkaplan, amuller, danken, mperina
wiki_category: Feature
wiki_title: Features/Device Custom Properties
wiki_revision_count: 43
wiki_last_updated: 2013-11-24
---

# Device Custom Properties

### Summary

Define special parameters per VM virtual device, and pass them down to vdsm hooks when a VM is started or a device is plugged into the VM.

### Owner

*   Name: [ Dan Kenigsberg](User:Danken)

<!-- -->

*   Email: <danken@redhat.com>

### Current status

*   oVirt-3.3
*   Last updated: ,

### Detailed Description

Just like we can define VM-wide custom properties, we would like to set per-device ones. This would allow users to pass special parameters to connect a specific vNIC to a funky host network.

### Benefit to oVirt

oVirt currently supports only one type of network connectivity: a vNIC is connected by a Linux bridge to a pre-existing host NIC, that is connected to the outer world. Users want to allow funkier types of connection, for example:

*   Create a host nic (via Mellanox UFM) just in time, and connect it directly to the vNIC.
*   Request OpenStack's Quantum to connect a vNIC to one of its defined networks.
*   Pass non-standard QoS setting for a vNIC.

Similarly, users may want to connect a virtual disk to an "exotic" storage server, that requires special actions just before the VM is started.

These extensions, and many others, can be made available by allowing per-device custom properties. Device custom properties are just like VM-wide ones, only that they are attached to a specific device, and can take effect when the device is hot-plugged.

### Dependencies / Related Features

#### Vdsm

Vdsm should pass device custom properties to its hook scripts.

**TBD** vdsm/hook API.

#### Engine

**TBD**

#### GUI

![](NetworkCustomProperties.png "NetworkCustomProperties.png")

### Documentation / External references

*   Benoit ML asking for per-vNIC custom properties: <http://lists.ovirt.org/pipermail/users/2012-November/010857.html>
*   **TBD** Quantum PoC

### Comments and Discussion

*   Refer to [Talk:Device Custom Properties](Talk:Device Custom Properties)

<Category:Feature>

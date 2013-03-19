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

This feature affects the following Vdsm verbs:

*   vmCreate
*   vmHotplugNic
*   vmHotunplugNic
*   vmHotplugDisk
*   vmHotunplugDisk
*   vmUpdateDevice (In the future)

Each of these verbs accepts a dictionary (of type VmInterfaceDevice) that describes the relevant device (note that vmCreate accepts a **list** of devices). A new optional key "custom" would be added to VmInterfaceDevice. Its value is a dictionary of custom properties and their string value.

Vdsm would pass device custom properties to its hook scripts.

In hooks scripts of per-device verbs, the properties would be passed as environment variables of the hook scripts being executed. For vmCreate, a hook script would be executed per each device that has "custom" in its VmInterfaceDevice device definition.

The reasoning behind the vmCreate behavior is that we should pass different properties for each device. At the stage that before_vm_create hook is executed, the alias of devices is not necessarily known, and the ordering of devices may be changed by other hooks. Thus we have no means to designate which property belong to which device - save for executing a different script for each device, passing that device's xml definition.

#### Engine

With this feature, Engine would keep track of per-device custom properties. This would be done by adding a field **TBD:<fieldname>** to the Vm device table. Currently we envisage custom properties per vNIC and vDisk only, but in the future it may make sense to extend the feature to other devices.

===== Configure valid prps in vdc_options ==== Not all custom properties are valid for every setups - they depend on the hooks installed on hosts. Therefore, just like with per-VM properties, a user would have to define the valid properties and their valid values in vdc_options. Note that properties are most likely to be valid for an interface, but invalid for a disk. Thus we would need to have two different entries **TBD:<entrynames>**, or a more complex syntax such as {type=disk,property=regex,values=regex} to make it easier to add future device types.

#### GUI

![](NetworkCustomProperties.png "NetworkCustomProperties.png")

### Documentation / External references

*   Benoit ML asking for per-vNIC custom properties: <http://lists.ovirt.org/pipermail/users/2012-November/010857.html>
*   **TBD** Quantum PoC
*   Almost any interesting hook for [hotplug disk](https://bugzilla.redhat.com/show_bug.cgi?id=908656) is going to require per-disk triggering proprty

##### REST

**TBD** should be modelled after per-vm properties.

### Comments and Discussion

*   Refer to [Talk:Device Custom Properties](Talk:Device Custom Properties)

<Category:Feature>

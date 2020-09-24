---
title: Device Custom Properties
category: feature
authors: alkaplan, amuller, danken, mperina
---

# Device Custom Properties

## Summary

Define special parameters per VM virtual device, and pass them down to vdsm hooks when a VM is started or migrated, and when a device is plugged or unplugged from the VM.

## Owner

*   Name: Assaf Muller (amuller)
*   Email: <amuller@redhat.com>
*   IRC: amuller at #ovirt (irc.oftc.net)

## Current Status

*   oVirt-3.3

## Detailed Description

Just like we can define VM-wide custom properties, we would like to set per-device ones. This would allow users to pass special parameters to connect a specific vNIC to a funky host network.

## Benefit to oVirt

oVirt currently supports only one type of network connectivity: a vNIC is connected by a Linux bridge to a pre-existing host NIC, that is connected to the outer world. Users want to allow funkier types of connection, for example:

*   Create a host nic (via Mellanox UFM) just in time, and connect it directly to the vNIC.
*   Request OpenStack's Quantum to connect a vNIC to one of its defined networks.
*   Pass non-standard QoS setting for a vNIC.

Similarly, users may want to connect a virtual disk to an "exotic" storage server, that requires special actions just before the VM is started.

These extensions, and many others, can be made available by allowing per-device custom properties. Device custom properties are just like VM-wide ones, only that they are attached to a specific device, and can take effect when the device is hot-plugged.

## User Experience

Under the Networks main tab -> Profiles subtab:

![](/images/wiki/NetworkCustomProperties.png)

## Implementation

#### Vdsm

This feature affects the following Vdsm verbs:

*   vmCreate
*   vmDestroy
*   vmHotplugNic
*   vmHotunplugNic
*   vmHotplugDisk
*   vmHotunplugDisk
*   vmMigrate
*   vmUpdateDevice

Each of these verbs accepts a dictionary (of type VmInterfaceDevice) that describes the relevant device (note that vmCreate accepts a **list** of devices). A new optional key "custom" would be added to VmInterfaceDevice. Its value is a dictionary of custom properties and their string value.

Vdsm would pass device custom properties to its hook scripts.

In hooks scripts of per-device verbs (nic hotplug, for example) the properties would be passed as environment variables of the hook scripts being executed. For vmCreate, two new hook events were created. Hook scripts called before_device_create and after_device_create would be executed per each device that has "custom" in its VmInterfaceDevice device definition.

The reasoning behind the vmCreate behavior is that we should pass different properties for each device. At the stage that before_vm_create hook is executed, the alias of devices is not necessarily known, and the ordering of devices may be changed by other hooks. Thus we have no means to designate which property belong to which device - save for executing a different script for each device, passing that device's xml definition.

#### Dependencies / Related Features

With this feature, Engine would keep track of per-device custom properties.

We will insert the custom properties column into the vm_device table. Custom properties will be saved at the device level to keep the implementation generic and future proof.

#### Configuration

Not all custom properties are valid for every setups - they depend on the hooks installed on hosts. Therefore, just like with per-VM properties, a user would have to define the valid properties and their valid values in vdc_options. Note that properties likely to be valid for an interface, but invalid for a disk. The option_name value will be DeviceCustomProperties, and its corresponding option_value will look like:

`[{type=disk; prop={value1=regex1; ...; valueN=regexN}};{type=interface; prop={value1=regex1; ...; valueN=regexN}};...]`

Following device types are supported:

*   disk
*   interface
*   video
*   sound
*   controller
*   balloon
*   channel
*   console
*   smartcard
*   watchdog

The configuration values should be exposed to the engine-config tool.

#### CRUD

Add a custom_properties column to vm_device of type TEXT.

Every stored procedure and view that depend on vm_device need to be updated. The is_plugged property of a device can serve as an example, as the is_plugged column resides in the vm_device table. vm_interface_view is a view that joins on vm_device and vm_interface that displays the information about a NIC, including whether it is plugged in or not. Similarly, custom_properties needs to be added to vm_interface_view and similar disk views which are affected.

#### Business Entities

Add a string field called customProperties to VmNetworkInterface and to the corresponding disk business entity.

#### DAOs

Update the relevant row mappers at VmDeviceDao, VmNetworkInterfaceDao and vmDiskDao to map from the JDBC result set to the new business entity fields. Similarly, update the save and update methods to include the new field when building the getCustomMapSqlParameterSource object.

#### Business Logic

Each bll command that adds or updates a NIC or a disk should include custom properties validation during its canDoAction stage.

#### VdsBroker

Update all relevant VdsBroker commands that involve verbs related to adding, removing and altering disks and NICs.

#### REST

Add a custom_properties field to api.xsd for NICs and disks:
```xml
<custom_properties>
  <custom_property value="123" name="sndbuf"/>
  <custom_property value="true" name="sap_agent"/>
</custom_properties>
```

And subsequently fix the NicMapper to map properly from VmInterface to NIC and vice versa.

#### Backwards Compatibility

As this is a 3.3 feature, all 3.2 (and down) cluster related entities should not be allowed (at the GUI level ) to customize device properties. In the engine special care needs to be taken at canDoAction to disallow custom device properties for 3.2 and down.

## Testing

*   Use the engine-config tool to insert the property 'label': 'red' to vNics, and 'capped': 'True' to disks. Specify the regex on the 'capped' property to 'True|False'
*   For example: `engine-config -s CustomDeviceProperties="{type=interface;prop={speed=^([0-9]{1,5})$;duplex=^(full|half)$}}"` will set two custom properties for vNics: speed and duplex.
*   Verify that the properties were inserted into the DB
*   From the Engine, edit a vNic and place the label property, and the capped property on a disk (Make sure the cluster level is 3.3+)
*   Verify that you may only place the label property on vNics and not disks, and the capped property on disks and not vNics.
*   Verify that the 'True|False' regex works properly on 'capped'
*   Examine the vdsm.log to verify that the custom properties were sent during the updateDevice verb
*   [Create a new VDSM hook](/develop/developer-guide/vdsm/hooks.html) that occurs during before updateDevice that prints the value for the 'label' and 'capped' environment variables, and the domxml of the device the hook received
*   Verify that when the device received is a nic, 'red' is printed, and when the device received is a disk, 'True' is printed
*   Finally, use the same hook for all relevant hook points: vmCreate, vmHotplugNic, vmHotunplugNic, vmHotplugDisk, vmHotunplugDisk, vmMigrate

## Documentation / External references

*   Benoit ML asking for per-vNIC custom properties: <https://lists.ovirt.org/pipermail/users/2012-November/010857.html>
*   [Features/Quantum_Integration](/develop/release-management/features/network/osn-integration.html)
*   Almost any interesting hook for [hotplug disk](https://bugzilla.redhat.com/show_bug.cgi?id=908656) is going to require per-disk triggering proprty

## Comments and Discussion

*   On the arch@ovirt.org mailing list.


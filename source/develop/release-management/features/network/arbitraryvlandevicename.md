---
title: ArbitraryVlanDeviceName
category: feature
authors: alkaplan
---

# Arbitrary VLAN Device Name

## Owner

*   Name: Alona Kaplan (alkaplan)
*   Email: <alkaplan@redhat.com>

## Current status

*   Last update date: 28/04/2014

## Introduction

Supporting VLAN devices with names not in standard "dev.VLANID" (e.g. eth0.10-fcoe, em1.myvlan10, vlan20, ...).

### VDSM API

'vlanid' entry will be added to VLANs map on getVdsCaps command

```json
vlans =  {'myvlan20':
                   {'addr': '',
                    'cfg': {},
                    'iface': 'eth1',
                    'ipv6addrs': [],
                    'mtu': '1500',
                    'netmask': '',
                    'vlanid': 20}} 
```

**notice:** The map already contained 'iface' key which represents the base interface name.

### Engine changes

#### Old behaviour

The engine assumed the format of the VLAN device name is 'baseIfaceName.vlanId'.
On getVdsCaps (VdsBrokerObjectsBuilder.addHostVlanDevices) the engine extracted the vlanId from the VLAN device name and set it on vdsNetworkInterface.vlanId field.
If the engine needed the base interface name it extracted it over and over again from the VLAN device name.

#### New behaviour

On getVdsCaps (VdsBrokerObjectsBuilder.addHostVlanDevices) the engine checks if the new key 'vlanid' exists in the VLAN map. If exists- sets the vdsNetworkInterface.vlanId according to its value. Otherwise- Preserves the old behaviour- extracts the vlanId from the VLAN device name and set in on vdsNetworkInterface.vlanId field. In both of the cases the vdsNetworkInterface.baseInterface is set according to the 'iface' key in the VLAN map (The 'iface' isn't a new field reported by the vdsm, but previously was unused by the engine).

### DB changes

Adding new column to `vds_interface`: name - `base_interface`, type - varchar(50)

### Affected Flows

There are some engine flows that have to be fixed:

1. NetworkUtils has a lot of methods regarding VLANs. Most of the methods were refactored and the signature of some of them was changed.
There are some flows that used those NetworkUtils methods. Since the signature was changed those flows needed some adjustments.
2. Using iface.getBaseInterface() and iface.getVlanId() instead of determining this values from the VLAN device name.

The effected flows are:

* MigrateVmCommand
* RemoveNetworksByLabelParametersBuilder (DetachNetworksFromClusterCommand, UnlabelNicCommand)
* DetachNetworkFromVdsInterfaceCommand
* GetAllChildVlanInterfacesQuery
* GetAllSiblingVlanInterfacesQuery
* LabelNicCommand
* RemoveBondCommand
* SetupNetworks
* UpdateNetworkToVdsInterfaceCommand
* VdsUpdateRunTimeInfo
* GetVlanParentQuery
* NetworkMonitoringHelper

### REST Api

'base_interface' property will be received on GET VdsNetworkInterface.
Changes in "setupnetworks" ACTION:

1. If the base_interface is specified, it will be used instead of determining it from the device name. (The device name will be ignored).
2. If not, the base_interface name will be determined from the device name as before. (This should be done to keep backward compatibility).

### User Experience

The "VLAN id" will be added to the VLAN column in the Network Interfaces sub tab under Host in the following format- "device name (VLAN id)". The are no visual changes in setup networks dialog since the VLAN devices are not shown there.

### Restrictions

If the user adds manually a VLAN device with non-standard name, he can't assign via the webadmin networks with the same VLAN id as the VLAN device to the base interface of the device.
For example:

1. The user adds manually VLAN device 'myVlanDevice10' on the host- ip link add dev eth1.1- link eth1 name myVlanDevice10 type VLAN id 10
2. The user add 'net10' with VLAN id 10 to the host's cluster.
3. The user tries to attach 'net10' to 'eth1' via setup networks dialog.
Result-
The user will get an error- "Error while executing action Setup Networks: Failed to bring interface up"
The reason for this is that when attaching network with VLAN id 10 to 'eth1' the vdsm tries to create a new standard device 'eth1.10', since a VLAN device with the same VLAN id already exists it fails.

## Documentation / External references

Bugzilla - <https://bugzilla.redhat.com/show_bug.cgi?id=1091863>



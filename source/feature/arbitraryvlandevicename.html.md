---
title: ArbitraryVlanDeviceName
category: feature
authors: alkaplan
wiki_category: Feature
wiki_title: Feature/ArbitraryVlanDeviceName
wiki_revision_count: 22
wiki_last_updated: 2014-05-01
---

# Arbitrary Vlan Device Name

### Summary

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   Last update date: 28/04/2014

### Introduction

Supporting vlan devices with names not in standard "dev.VLANID" (e.g. eth0.10-fcoe, em1.myvlan10, vlan20, ...).

#### VDSM API

'vlanid' entry will be added to vlans map on getVdsCaps command

      vlans =  {'myvlan20': {
                                   'addr': '',
                                   'cfg': {},
`                      `<b>`'iface': 'eth1',`</b>
                                   'ipv6addrs': [],
                                   'mtu': '1500',
                                   'netmask': '',
`                      `<b>`'vlanid': 20}} `</b>

<b>notice:</b> The map already contained 'iface' key which represents the base interface name.

#### Engine changes

##### Old behaviour

The engine assumed the format of the vlan device name is baseIfaceName.vlanId. On getVdsCaps (VdsBrokerObjectsBuilder.addHostVlanDevices) the engine extracted the vlanId from the vlan device name and set it on vdsNetworkInterface.vlanId field. If the engine needed the base interface name it extracted it over and over again from the device name.

##### New behaviour

On getVdsCaps (VdsBrokerObjectsBuilder.addHostVlanDevices) the engine checks if the new key 'vlanid' exists. If exists- sets the vdsNetworkInterface.vlanId according to its value. Otherwise- Preserves the old behavior- extracts the vlanId from the vlan device name and set in on vdsNetworkInterface.vlanId field. In both of the cases the vdsNetworkInterface.baseInterface is set according to the 'iface' key in the vlan map (The 'iface' isn't a new field, but previously was unused by the engine).

#### DB changes

Adding new column to vds_interface- name - 'base_interface', type - varchar(50)

#### Affected Flows

#### User Experience

There are no ux visible changes. As before the user can see the vlanDevice on Host->Network Interface sub tab. And cannot see the devices on the Setup Networks dialog.

#### Restrictions

If the user adds manually a vlan device with non-standard name, he can't assign via the webadmin networks with the same vlan id as the vlan device to the base interface of the device. For example- 1. The user adds manually vlan device 'myVlanDevice10' on the host- ip link add dev eth1.1- link eth1 name myVlanDevice10 type vlan id 10 2. The user add 'net10' with vlan id 10 to the host's cluster. 3. The user tries to attach 'net10' to 'eth1' via setup networks dialog.

Result- The user will get an error- "Error while executing action Setup Networks: Failed to bring interface up" The reason for this is that when attaching network with vlan id 10 to 'eth1' the vdsm tries to create a new standard device 'eth1.10', since a vlan device with the same vlan id already exists it fails.

### Documentation / External references

Bugzilla - <https://bugzilla.redhat.com/840692>

### Comments and Discussion

<Category:Feature> <Category:Networking>

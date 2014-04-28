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

'vlanid' entry will be added to vlans map on getVdsCaps command vlans = {'myvlan20': {'addr': '',

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

### Documentation / External references

Bugzilla - <https://bugzilla.redhat.com/840692>

### Comments and Discussion

<Category:Feature> <Category:Networking>

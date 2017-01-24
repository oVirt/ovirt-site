---
title: Network Filter Parameters
category: feature
authors: dholler
wiki_category: Feature
wiki_title: Network/NetworkFilterParameters
wiki_revision_count: 0
wiki_last_updated: 2016-11-08
feature_name: Network Filter Parameters
feature_modules: engine,vdsm
feature_status: In Development
---

# Network Filter Parameters

## Summary

The attachment of a predefined [network filters by vNIC profiles to VMs is already available][2],
but the user is not yet able to set [parameters][3] of the network filters.
There are scenarios, e.g. [Bug 1366905][4], in which there is a need to set some of the parameters of the network filters.
This feature enables the user to set the values of the parameters explicitly. 

## Owner

*   Name: [Dominik Holler](User:dominikholler)

*   Email: <dholler@redhat.com>

## Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

## Benefit to oVirt

This feature enables the usages of oVirt in scenarios, in which the user has to set parameters, without forcing the user to edit configuration files on the hosts manually.

### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

What access rights are required to prevent abuse?

### User work-flows

Describe the high-level work-flows relevant to this feature.

## Entity Description

The top-level network filter is [associated to the vNIC profile][2]. For this reason it appears likely
that the parameters for this filters, e.g. allowed networking protocols in a network, are associated to the vNIC profile, too.
But the use case described in the [bug report][4] gives the VM's IP addresses as an example for parameters.
These parameters are associated of a concrete network interface of the VM's instance.
So there is a need for parameters on two places.

In a first step, the parameters are implemented for VM's network interfaces, because it addresses the given use case in the [bug report][4].
Furthermore there is the possibility to set parameters on VM's network interfaces, temporary solves the vNIC profile scenarios, too.
The drawback of this approach is that in this scenarios more configuration needed, than it would be of the vNIC profiles could manage the filter parameters.

The new entity ia called `VmNicFilterParameter`. It is associated to an network interface of an VM's network interface, and has the two attributes `name` and `value`.
A `VmNicFilterParameter` is identified by it's `id`. All `VmNicFilterParameter` are persisted in the dedicated table `vm_interface_filter_parameters` in the database.

### Adding a new network filter parameter

To add a new network filter parameter, a reference to the VM's network interfaces, a valid name and a valid value are required.
The name and the value has to satisfy at least the regular expressions of [libvirts XML schema][8], to ensure that VDSM will create valid XML for libvirt.
There are [Reserved variables of libvirt's network filters][9] with known data types, which could be validated, but it is not planned to implement this.
It is explicitly allowed to create multiple network filter parameters with the same name.

On adding a new network filter parameter, a new row is created in the dedicated table in the database.

### Updating a new network filter parameter

The validation of the changed attributes are the same like for adding a new network filter parameter.

Trough oVirt"s REST API it is possible to change the name and the value of the parameter.
The entity allows to change the reference to the VM's network interface, but this is very unlikely to happen.
The `id` of the entity must not be changed.

On updating a network filter parameter, the row representing the network filter parameter is addressed by the attribute `id` and the other attributes in the row are updated.

### Removing a new network filter parameter

If the network filter parameter is removed, the corresponding row in the table in the database is removed.
If the VM's network interface referenced by the network filter parameter is removed, the network filter is removed, too. This is done by the database, hidden from ovirt-engine.

### Installation/Upgrade

The engine-setup prepares the database for the usage of this feature.

The information about the network filter parameters is sent to VDSM via json, but not XML-RPC.
VDSM versions compatible to cluster level 4.1 and higher interprets the network filter parameters, older VDSM versions ignores them.
The next section explains this detailed.

### Communication of VDSM and engine

A naive mapping of a parameterized mapping of the reference to a top-level filter in a network interface in libvirt XML to VDSM json would look like this:

| libvirt XML fragment                         | VDSM json fragment             |
|----------------------------------------------|--------------------------------|
| `<filterref filter='clean-traffic'>`         | `'filterref': {              ` |
|                                              | `  'filter': 'clean-traffic',` |
|                                              | `  'parameter': [            ` |
|`  <parameter name='IP' value='10.0.0.1'/>`    | `    {                       ` |
|                                              | `      'name': 'IP',         ` |
|                                              | `      'value': '10.0.0.1'   ` |
|                                              | `    },                      ` |
|`  <parameter name='IP' value='10.0.0.2'/>`    | `    {                       ` |
|                                              | `      'name': 'IP',         ` |
|                                              | `      'value': '10.0.0.2'   ` |
|                                              | `    },                      ` |
|`  <parameter name='IP' value='10.0.0.3'/>`    | `    {                       ` |
|                                              | `      'name': 'IP',         ` |
|                                              | `      'value': '10.0.0.3'   ` |
|                                              | `    },                      ` |
|                                              | `  ]                         ` |
|`</filterref>`                                | `},                          ` |

The following table shows an example of the previously implemented mapping of the reference to a top-level filter of a network interface in libvirt XML to VDSM json:

| libvirt XML fragment | VDSM json fragment|
|-------------|-----------|
|`<filterref filter='clean-traffic'/>`| `'filter': 'clean-traffic',`|

Implemented is a combination of the naive mapping and the previously implemented mapping, which gives a backward compatible extension of the VDSM API:

| libvirt XML fragment                         | VDSM json fragment             |
|----------------------------------------------|--------------------------------|
| `<filterref filter='clean-traffic'>`         | `  'filter': 'clean-traffic',` |
|                                              | `  'filterParameters': [     ` |
|`  <parameter name='IP' value='10.0.0.1'/>`   | `    {                       ` |
|                                              | `      'name': 'IP',         ` |
|                                              | `      'value': '10.0.0.1'   ` |
|                                              | `    },                      ` |
|`  <parameter name='IP' value='10.0.0.2'/>`   | `    {                       ` |
|                                              | `      'name': 'IP',         ` |
|                                              | `      'value': '10.0.0.2'   ` |
|                                              | `    },                      ` |
|`  <parameter name='IP' value='10.0.0.3'/>`   | `    {                       ` |
|                                              | `      'name': 'IP',         ` |
|                                              | `      'value': '10.0.0.3'   ` |
|                                              | `    },                      ` |
|                                              | `  ],                        ` |
|`</filterref>`                                | `                            ` |


The new key `filterParameters` is only be considered by VDSM, if a value for `filter` is set. An older VDSM, which does not know about `filterParameters`, just ignores it.

### Event Reporting

#### Errors

* Try to set invalid parameters:
  * Invalid name, e.g. the name contains invalid characters
  * Forbidden name, e.g. the user wants to set the parameter `MAC`, which should be set only by libvirt, but not by the user
* Try to set invalid values:
  * Unexpected data type

## Dependencies / Related Features

The feature depends on [Network Filter for vNIC profiles][2], which is already available.

## Documentation / External references

[Networking Filtering in order to prevent mac spoofing (/develop/release-management/features/network/networkfiltering)][1]

[1]: /develop/release-management/features/network/networkfiltering/

[Network Filter for vNIC profiles (/feature/networkfilter)][2]

[2]: /feature/networkfilter

[Usage of variables in filters in libvirt][3]

[3]: https://libvirt.org/formatnwfilter.html#nwfconceptsvars

[Bug 1366905 - [RFE] Allow multiple IP's / text fields for network filters, specifically clean-traffic][4]

[4]: https://bugzilla.redhat.com/show_bug.cgi?id=1366905

[Network Filters Concepts in libvirt][5]

[5]: https://libvirt.org/formatnwfilter.html#nwfconcepts

[Example hook][6]

[6]: https://bugzilla.redhat.com/show_bug.cgi?id=1366905#c8

[Bug 1009608 - [RFE] support for PVLANs in RHEV][7]

[7]: https://bugzilla.redhat.com/show_bug.cgi?id=1009608

[nwfilter.rng][8]

[8]: https://github.com/libvirt/libvirt/blob/master/docs/schemas/nwfilter.rng

[Reserved variables of libvirt's network filters][9]

[9]: https://libvirt.org/formatnwfilter.html#nwfelemsReservedVars

## Testing

### Use cases

#### Setting IP of VM
The IP addresses which are allowed to be used by an virtual machine are set explicitly.

Precondition:
The 'clean-traffic' filter is referenced by a vNIC profile.
This vNIC profile is mapped to a network interface of a  virtual machine.
This virtual machine is down and this network interface is configured to use multiple static IP addresses.

##### Case 0: Only one IP address allowed
Basic flow:

1. The value of parameter 'IP' is set to the first static IP address of the interface.

2. The virtual machine is started and up.

Postcondition:

 * The first, but not the second, static IP address can be pinged from outside the virtual machine.

##### Case 1: Multiple IP addresses allowed
Basic flow:

1. The value of parameter 'IP' is set two times at once.
   The first time the value is the first static IP address and
   the second time value is the second static IP address of the interface.

2. The virtual machine is started and up.

Postcondition:

 * The first and the second static IP address can be pinged from outside the virtual machine.

### Implementation
Tests has to be implemented by the REST API.

## Contingency Plan

Until the feature is available a VDSM hook parameterized by CustomDeviceProperties could be used, example is [available][6]

## Release Notes

      == Network Filter Parameters ==
      Network filters of virtual machines can configured by parameters.


## Open Issues

There are use cases, e.g. [Bug 1009608 - [RFE] support for PVLANs in RHEV][7], for using the same parameters for multiple VMs.
Instead of manage the filter parameters for each single VM's network interfaces, it would be more adequate to manage them per vNIC profile.




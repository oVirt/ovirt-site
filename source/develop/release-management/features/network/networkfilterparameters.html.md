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

### Entity Description

New entities and changes in existing entities.

The top-level network filter is [associated to the vNIC profile][2]. For this reason it appears likely
that the parameters for this filters, e.g. allowed networking protocols in a network, are associated to the vNIC profile, too.
But the use case described in the [bug report][4] gives the VM's IP addresses as an example for parameters.
These parameters are associated of a concrete network interface of the VM's instance.
So there is a need for parameters on two places.

In a first step, the parameters are implemented for VM's network interfaces, because it addresses the given use case in the [bug report][4].
Furthermore the possibility to set parameters on VM's network interfaces, addresses the vNIC profile scenarios, too. The drawback of this approach is that in this scenarios more configuration needed, than it would be of the vNIC profiles could manage the filter parameters.

### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

What access rights are required to prevent abuse?

### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

### User work-flows

Describe the high-level work-flows relevant to this feature.

### Network Filter Parameters in libvirt XML and VDSM API

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

The following table shows an example of the currently implemented mapping of the reference to a top-level filter of a network interface in libvirt XML to VDSM json:

| libvirt XML fragment | VDSM json fragment|
|-------------|-----------|
|`<filterref filter='clean-traffic'/>`| `'filter': 'clean-traffic',`|

A combination of the naive mapping and the currently implemented mapping would give a backward compatible extension of the VDSM API:

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


The new key `filterParameters` is only be considered by VDSM, if a value for `filter` is set. An older VDSM, which does not know about `filterParameters`, just ignors it.

### Event Reporting

### VDSM

#### Errors

* Try to set invalid parameters:
  * Invalid name, e.g. the name contains invalid characters
  * Forbidden name, e.g. the user wants to set the parameter `MAC`, which should be set only by libvirt, but not by the user
* Try to set invalid values:
  * Unexpected data type

## Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

## Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

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

## Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

## Contingency Plan

Explain what will be done in case the feature won't be ready on time

## Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes




## Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.




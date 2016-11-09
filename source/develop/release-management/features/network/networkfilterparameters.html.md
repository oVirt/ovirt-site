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
There are scenarios, e.g. [Bug 1366905][4], in which there is a need to set the parameters of the network filters.
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

### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

### User work-flows

Describe the high-level work-flows relevant to this feature.

### Event Reporting

What events should be reported when using this feature.

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

## Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

## Contingency Plan

Explain what will be done in case the feature won't be ready on time

## Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes




## Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.




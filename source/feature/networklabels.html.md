---
title: NetworkLabels
category: feature
authors: alkaplan, danken, lvernia, moti, mpavlik
wiki_category: Feature
wiki_title: Features/NetworkLabels
wiki_revision_count: 66
wiki_last_updated: 2014-09-15
---

# Network Labels

### Summary

Network labels allow to tag networks with a label and to use that label on the host's interface, so the label abstracts the networks from the physical interface:
The host network configuration can be done by manipulating the network label:

*   Tagging a network with label will attach that network to all hosts nics which are tagged with that label.
*   Removing a tag from a network will trigger its removal from all hosts nics which are tagged with that label.
*   Modifying a network will update all hosts nics which are tagged with that label.

### Owner

*   Name: Moti Asayag
*   Email: <masayag@redhat.com>

### Current status

*   On Design
*   Planned for ovirt-engine-3.4
*   Last updated: ,

### Detailed Description

Expand on the summary, if appropriate. A couple sentences suffices to explain the goal, but the more details you can provide the better.

### Benefit to oVirt

The main advantages of the feature is to ease and simplify the maintenance of a data-center with multiple hosts.
The amount of request actions by the administrator are significantly reduced and in a relative simple manner the host network configuration is kept in-sync with the logical network definition.

### Dependencies / Related Features

The feature will use the [Edit Provisioned Network](Features/EditProvisionedNetwork) feature to achieve its goals.

### Documentation / External references

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

<Category:Feature>

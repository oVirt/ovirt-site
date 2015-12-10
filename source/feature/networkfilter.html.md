---
title: NetworkFilter
category: feature
authors: elevi
wiki_category: Feature
wiki_title: Features/NetworkFilter
wiki_revision_count: 121
wiki_last_updated: 2016-02-02
feature_name: Network filter
feature_modules: engine,network
feature_status: new
---

# Network Filter

### Summary

Network filter will enhance the admin ability to manged the network packets traffic from\\to the participated virtual machines (or "vm" in short).

### Owner

Eliraz Levi

*   Name: [ Eliraz Levi](User:MyUser)

<!-- -->

*   Email: <elevi@redhat.com>

### Detailed Description

One of oVirt benefit is the ability to create a Local area network (LAN) among different vms running on different hosts. The Network representing the described LAN is being defined in cluster level. Network filtering is the ability to choose what kind of packets a certain vm, is being able to send\\received to\\from the LAN. The filtering can be set by using libvirt API which enable to assign a filter policy to each of the vm's virtual network interface (or "vnic" in short)

two motivations impact with exist vdsm feature upgrade script feature design

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>

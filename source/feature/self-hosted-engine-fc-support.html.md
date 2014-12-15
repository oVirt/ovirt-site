---
title: Self Hosted Engine FC Support
category: feature
authors: sandrobonazzola, stirabos
wiki_category: Feature|Self Hosted Engine FC Support
wiki_title: Features/Self Hosted Engine FC Support
wiki_revision_count: 22
wiki_last_updated: 2015-05-06
feature_name: Self Hosted Engine FC Support
feature_modules: ovirt-hosted-engine-setup
feature_status: design
---

# Self Hosted Engine FC Support

### Summary

This feature enable the user to use FC storage for Hosted Engine data domain.

### Owner

*   Name: [ Simone Tiraboschi](User:Stirabos)
*   Email: <stirabos@redhat.com>

### Detailed Description

##### UX changes

Using an existing FC storage:

tbd

##### Config files changes

tbd

##### VDSM commands involved

tbd

The rest is quite similar to NFS storage.

### Benefit to oVirt

Users will be able to use FC storage as data domain for Hosted Engine.

### Dependencies / Related Features

*   A tracker bug has been created for tracking issues:

### Documentation / External references

#### Development environment

The feature can be developed and tested in a simplified environment without the need of a real SAN using FCoE in VN2VN mode (FCoE Direct End-Node to End-Node) on a nested environment.

##### Prerequisites

Two virtual machine with two VirtIO network adapter for each node. The first one (eth0) will be used for generic network traffic, the second one (eth1) will be dedicated to FCoE.

### Testing

Test plan still to be created

### Contingency Plan

Currently all the changes required for this feature are in a single patch. If it won't be ready it won't be merged.

### Release Notes

      ==Self Hosted Engine FC Support==
`Hosted Engine has now added support for `[`FC` `storage`](Features/Self_Hosted_Engine_FC_Support)

### Comments and Discussion

*   Refer to [Talk:Self Hosted Engine FC Support](Talk:Self Hosted Engine FC Support)

[Self Hosted Engine FC Support](Category:Feature) [Self Hosted Engine FC Support](Category:oVirt 3.6 Proposed Feature)

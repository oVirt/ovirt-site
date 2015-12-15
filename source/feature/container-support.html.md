---
title: Container support
category: feature
authors: fromani
wiki_category: Feature
wiki_title: Container support
wiki_revision_count: 6
wiki_last_updated: 2015-12-15
feature_name: Container support
feature_modules: vdsm, engine?
feature_status: Planning
---

# Container support

### Summary

Add containers support to oVirt, to run containers on virtualization hosts, alongside VMs. Support to run containers-inside-VMs, all managed by oVirt is out of scope of this feature.

### Owner

*   Name: [ Francesco Romani](User:fromani)

<!-- -->

*   Email: <fromani@redhat.com>

### Detailed Description

The purpose of this feature is to let oVirt run containers alongside VMs. Future development includes the ability of running containers inside VMs, all managed by oVirt.

### Benefit to oVirt

The ability of running containers will give oVirt greater flexibility, making it possible to leverage transparently the best solution for any given circumstance. Sometimes VMs are the best tool for a job, sometimes containers are, sometimes one can need both at the same time. oVirt could be the most comprehensive solution in this regard.

### Dependencies / Related Features

TODO

### Documentation / External references

TODO

### Testing

TODO

### Contingency Plan

We add a new feature, so there is no negative fallback and no contingency plan, oVirt will just keep working as usual.

### Release Notes

### Comments and Discussion

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature>

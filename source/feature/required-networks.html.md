---
title: Required Networks
category: feature
authors: danken, roy
wiki_category: Feature
wiki_title: Features/Design/Network/Required Networks
wiki_revision_count: 6
wiki_last_updated: 2013-03-07
---

# Required Networks

### Summary

Required networks are a part of monitoring process the engine does, to make sure all the
host in clusters are eligible for migration (cluster is sometimes referred to as the **migration-domain**)
A cluster network which is required but missing from a host will cause the host to be in
non-operational state, thus it can not be activated till it has the network attached.
* Till now, all networks were required by default, now its optional.

### Owner

*   Name: [ Roy](User:Roy)

<!-- -->

*   Email: <rgolan at redhat.com>

### Current status

*   Last updated date: 10/04/12
*   implementation: done

### Detailed Description

Refer to [Required_Networks_detailed](Required_Networks_detailed)

### Benefit to oVirt

1.  coming gluster-cluster support which is a cluster that doesn't have migration prospects.
2.  pinned to host VMs that uses networks we don't want other hosts to implement needlessly.
3.  3rd parties doing network management outside of ovirt.

### Comments and Discussion

*   Refer to [ <http://www.ovirt.org/w/index.php?title=Talk:Features/Design/Network/Required_Networks&action=edit&redlink=1> ](Talk:Required_Networks)

<Category:Feature> <Category:Template>

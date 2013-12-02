---
title: VM-Affinity
category: feature
authors: adahms, gchaplik
wiki_category: Feature
wiki_title: Features/VM-Affinity
wiki_revision_count: 19
wiki_last_updated: 2014-07-31
---

# VM Affinity

### Summary

The oVirt scheduler capabilities introduced in version 3.3 have opened opportunities to enhance how VM Workloads are scheduled to run within a cluster. By using the filtering and weighing mechanisms introduced in the Scheduler, it is now possible to apply Affinity and Anti-Affinity rules to VMs to manually dictate scenarios in which VMs should run together on the same, or separately on different hypervisor hosts.

#### Owner

*   Name: [ Gilad Chaplik](User:gchaplik)
*   Email: <gchaplik@redhat.com>

#### Current status

*   status: design phase
*   Last updated date: 1 Dec 2013

### Detailed Description

<Category:SLA>

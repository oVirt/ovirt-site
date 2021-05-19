---
title: SLA-mom-ballooning-tp
category: feature
authors: aglitke
---

# SLA-mom-ballooning-tp

## MOM Ballooning (Tech Preview)

### Summary

Introduce automatic memory ballooning as a selectable host or cluster-level policy in order to achieve higher VM density by overcommiting host memory.

### Owner

*   Name: Adam Litke (Aglitke)
*   Email: Adam Litke <alitke@redhat.com>

### Current status

*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page

<!-- -->

*   Last updated date: 23 October 2012

### Detailed Description

This feature covers changes to ovirt-engine, vdsm, and mom to enable a memory ballooning MOM policy at the host or cluster level. For users desiring a high level of VM density even with a risk of degraded performance, an aggressive management policy including memory ballooning is needed. Implementation of this feature can be broken down into the following sub-tasks

*   MOM: Multiple policies support
*   MOM: Per-VM attributes
*   MOM: auto-balloon policy
*   vdsm: API for setting/getting/clearing MOM policies
*   engine: host policy management
*   engine: Policy selection UI

### Benefit to oVirt

oVirt will gain the ability to achieve higher VM densities and more efficient use of host memory resources. This feature also serves as the foundation for a more sophisticated SLA framework that will be developed over time.

### Dependencies / Related Features

*   TBD

### Documentation / External references

*   TBD




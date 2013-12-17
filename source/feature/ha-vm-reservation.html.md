---
title: HA VM reservation
category: feature
authors: doron, kianku, sherold
wiki_category: Feature
wiki_title: Features/HA VM reservation
wiki_revision_count: 34
wiki_last_updated: 2014-01-12
---

# HA VM reservation

**HA VM reservation for host failover**

## Summary

The HA VM reservation feature ensure the safety of HA VMs in case of host failover, without negatively impacting performance.

## Owner

*   Name: [Kobi Ianko](User:kianku)
*   Email: kobi@redhat.com

<!-- -->

*   Name: [Scott Herold](User:sherold)
*   Email: sherold@redhat.com

## Current status

*   Target Release: 3.4
*   Status: design
*   Last updated: ,

## Detailed Description

oVirt Manager has the capability to flag individual VMs for High Availability, meaning that in the event of a host failure, these VMs will be rebooted on an alternate hypervisor host. Today, it is possible that the resultant utilization of a cluster during a host failure may either not allow or could cause a notable performance degradation when HA VMs are rebooted. HA VM Reservations will serve as a mechanism to ensure appropriate capacity exists within a cluster for HA VMs in the event the host they currently resides on fails unexpectedly.

## Detailed Design

Detailed design can be found here [HA_VM_reservation_detailedDesign](Features/HA_VM_reservation_detailedDesign)

## Benefit to oVirt

Provide assurance to the end user that critical VMs will have access to the required resources in the event of a host failure without negatively impacting the collective performance of existing workloads

## Comments and Discussion

<Category:Feature> <Category:SLA>

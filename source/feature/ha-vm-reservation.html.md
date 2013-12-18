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

*   Name: [Kobi Ianko](User:kianku), Email: kobi@redhat.com

<!-- -->

*   Name: [Scott Herold](User:sherold), Email: sherold@redhat.com

## Current status

*   Target Release: 3.4
*   Status: design
*   Last updated: ,

## Detailed Description

oVirt Manager has the capability to flag individual VMs for High Availability, meaning that in the event of a host failure, these VMs will be rebooted on an alternate hypervisor host. Today, it is possible that the resultant utilization of a cluster during a host failure may either not allow or could cause a notable performance degradation when HA VMs are rebooted. HA VM Reservations will serve as a mechanism to ensure appropriate capacity exists within a cluster for HA VMs in the event the host they currently resides on fails unexpectedly.

**Terminology**
n+1 failover - A scenario in which VMs recover from a single-host failure within a cluster n+x failover - A scenario in which VMs recover from a multi-host failure within a cluster

For the first iteration of HA VM Reservations, oVirt shall consider a single host failure (n+1). Scenarios involving multiple host failures (n+x) shall be deferred to a future release due to the complexity incurred from the individual VM HA setting approach (vs. Cluster Level HA Policy).

**Concept**
The HA VM reservation mechanism will be implemented in two phases: for the first phase the oVirt manager will be enhanced with monitoring capabilities. oVirt will continuously monitor the clusters in the system, for each Cluster the system will analyze its hosts, determining if the HA VMs on that host can survive the failover of that host by migrating to another host. in case a HA VM cannot migrate upon a failover, an Alert will be presented to the end user.

The monitoring procedure can be logically be divided into two. The first logical unit will search for a single host that can contain all of VMs from the failover host.

*   A pseudo code for that:

1. for each host x in the cluster do:
2. calculate the host x HA resources -> resourceHA(x)
3. for each host y in the cluster, y<>x do:
4. calculate the host y free resources -> resourceFree(y);
5. if resourceHA(x) < resourceFree(x) return ClusterHAStateOK;
6. ClusterHAStateFailed, raise Alert
 In case we did not find a match, the second logical unit will split the host into VMs and will try to find several host that will replace the failover host.

*   A pseudo code for that:

1. for each host x in the cluster do:
2. calculate HA VMs resources -> resourceHA(x,vm(i))
3. for each host y in the cluster, y<>x do:
4. calculate the host y free resources -> resourceFree(y);
5. for each HA VM v for host x do:
6. while resourceFree(y) >= resourceHA(x,vm(v))
7. resourceFree(y) = resourceFree(y) - resourceHA(x,vm(v));
8. mark v as migrated;
9 if all HA VMs are marked as migrated -> ClusterHAStateOK else ClusterHAStateFailed(raise Alert)
**Important - because of the complexity of this scheduling problem, we have decided to use a naive approach**
 Second phase of the implementation is to extend the monitoring capabilities to the "Run VM" and "Migration" actions. the oVirt manager will be able to predict the change of status in cases of run/migrate of VMs, it will need to take into account the resources the new or migrated VM takes. In case of a new HA VM it is needed to take into account not only the resources that the VM consumes from the host but also be aware that the HA VMs resources are lager now, and in case of failover the replacement host must have the appropriate amount of available resources.

## GUI

Enabling or disabling the HA VM Reservation will be possible via the Configure popup.
A sketch of the Configure window:
![](configurewin.png "fig:configurewin.png")

## Detailed Design

Detailed design can be found here [HA_VM_reservation_detailedDesign](Features/HA_VM_reservation_detailedDesign)

## Benefit to oVirt

Provide assurance to the end user that critical VMs will have access to the required resources in the event of a host failure without negatively impacting the collective performance of existing workloads

## Comments and Discussion

<Category:Feature> <Category:SLA>

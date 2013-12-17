---
title: HA VM reservation
category: feature
authors: doron, kianku, sherold
wiki_category: Feature
wiki_title: Features/HA VM reservation
wiki_revision_count: 34
wiki_last_updated: 2014-01-12
---

# HA VM reservation for host failover - phase 1

### Summary

The HA VM reservation feature ensure the safety of HA VMs in case of host failover, without negatively impacting performance.

### Owner

*   Name: [Kobi Ianko](User:kianku)
*   Email: kobi@redhat.com

### Current status

*   Target Release: 3.4
*   Status: work in progress
*   Last updated: ,

### Detailed Description

oVirt Manager has the capability to flag individual VMs for High Availability, meaning that in the event of a host failure, these VMs will be rebooted on an alternate hypervisor host. Today, it is possible that the resultant utilization of a cluster during a host failure may either not allow or could cause a notable performance degradation when HA VMs are rebooted. HA VM Reservations will serve as a mechanism to ensure appropriate capacity exists within a cluster for HA VMs in the event the host they currently resides on fails unexpectedly.

#### UI

Overall the UI will be changed at two places:
One UI change will be a configuration change, enable the user to switch this feature On and Off. under the Configure popup, a radio button will be added to TBD.
A second UI change will be at the Alert window, in case the system will recognize the scenario in which a HA VM cannot be migrated after a Host failover, a new alert will show specifying the problematic cluster and list of problematic Hosts in that cluster.

#### ENGINE

This feature mainly implemented by the engine, the engine will need to monitor the hosts in each cluster, for each host the engine will check if:
1. In case of a failover, is there another host in the cluster to take its place.
2. If (1) is false, then check for available hosts that together will take all the HA VMs from the problematic host(the VMs will be scattered over the cluster).
 To establish a list of potential candidates, we will keep track on two main criterias: RAM and CPU.
For (1), the engine will need to check that there is at least one Host who meet the criteria:
RAM: making sure a potential Host has a satisfactory amount of RAM(larger than the current RAM usage in the Host). CPU: TBD

For (2), the engine will need to walk through each HA VM in the host and for each VM:
RAM: making sure a potential host has a satisfactory amount of RAM(larger than the current RAM usage of the VM).
CPU:TBD

In case a potential host/hosts were not found for (1) and (2) and the feature is switched on, an Alert will be triggered.

#### QUARTZ

The engine logic should run once every X(TBD) minutes, checking if the status of each cluster was changed. Thing will be done using the Quartz mechanism in the system.

#### DB

Since there is no use of persistencing the data, cause it is relevant for a short period of time, no DB changes are needed.

#### BACKWARD CAPABILITY

For this feature there are no changes in APIs to the host and all the logic will be done by the engine, there isn't any backward capabilities problems, the feature will be supported by all host versions.

### Benefit to oVirt

Provide assurance to the end user that critical VMs will have access to the required resources in the event of a host failure without negatively impacting the collective performance of existing workloads

### Comments and Discussion

<Category:Feature> <Category:SLA>

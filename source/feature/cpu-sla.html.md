---
title: CPU SLA
category: feature
authors: adahms, kianku, roy
wiki_category: Feature
wiki_title: Features/CPU SLA
wiki_revision_count: 35
wiki_last_updated: 2015-04-14
---

# CPU SLA

**CPU SLA**

## Summary

The CPU SLA feature enable the user to limit the CPU usage of a VM.

## Owner

*   Name: [Kobi Ianko](User:kianku), Email: kobi@redhat.com

## Current status

*   Target Release: 3.5
*   Status: design
*   Last updated: ,

## Detailed Description

CPU is one of the important component which each guest has.

Currently RHEV doesn't support SLA features which limits guest's and qemu's cpu resource consumption. Therefore all guests working on the same host may be affected by other guests' cpu workload.

On the other hand, customers expect that virtualized systems work as stably as the systems on bare servers.

To provide same stability in virtualized environment, we need to limit cpu bandwidth of each guest and isolate each guest from others.

To accomplish this target a CPU Profile element will be introduced.
The CPU Profile will be selected by the end user from a predefined list in the Add VM popup window, and will be created in the Cluster level of the system.

Each cluster will contain its own list of CPU Profile that are available for the use of the VMs running in that Cluster.

Each CPU Profile will contain a Qos element.
The Qos element will be defined in the DataCenter level of the system, and will be constructed out of a single field that represent the percentage of CPU power that is permitted for this VM out of the total CPU Processing capacity.

## GUI

The user will configure the CPU limitation at the VM popup, at the advance Resource Allocation section:
![](cpuLimit.png "fig:cpuLimit.png")

The administrator will allocate CPU profiles to be used in the Cluster at the Cluster main tab, using the CPU Profile sub tab.
![](CpuLimitClusterSubTab.png "fig:CpuLimitClusterSubTab.png")

## VDSM

In the VDSM we will be using the libvirt API of CPU tuning (http://libvirt.org/formatdomain.html#elementsCPUTuning), The Qos entered by the user will be converted into the libvirt period and quota parameters, ensuring that the CPU limits are enforced.

## DB

The VM_STATIC will introduce a new field of CPU_PROFILE, this field will be a FK to the new table of CPU_PROFILES. CPU_PROFILES table will contain the following fields:
id (PK)
name
qos_id (FK)
cluster_id (FK)

## Benefit to oVirt

When running a VM, the VM should run as an independent unit and should be affected by other VMs as little as possible.
This feature enable the user to limit the CPU resources of a specific VM, this will ensure that in cases were several VMs are running on the same host, one VM will not cause performance decline in another VMs.
Another good use for this feature is in cases a growth in the number of VMs is expected, the user can limit the CPU resource to a VM leaving enough CPU resources for the future VMs, this way users of the guest will not have an impact on performance once other VMs will join the host.

## Comments and Discussion

<Category:Feature> <Category:SLA>

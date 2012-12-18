---
title: CPU thread handling
category: feature
authors: dneary, doron, gpadgett
wiki_category: Feature
wiki_title: Features/CPU thread handling
wiki_revision_count: 25
wiki_last_updated: 2012-12-21
---

# CPU Thread Handling

### Summary

CPU Thread Handling allows hosts to run VMs with a total number of processor cores greater than number of cores in the host. This can be useful for non-CPU-intensive workloads, where allowing a greater number of VMs to start can reduce hardware requirements (along with the associated benefits of easier management, energy savings, lower hardware costs, etc). It also allows VMs to run with CPU topologies that wouldn't be allowed without this option, specifically if the number of guest cores is between the number of host cores and number of host threads.

This project would allow the engine to optionally treat host CPU threads as cores for the purposes of running VMs, on a user-configurable cluster-by-cluster basis. When both SMT (AMD Clustered MultiThreading or Intel Hyper-Threading technology) and this feature are enabled, this would increase the capacity of hosts and may help performance for certain workloads.

There is a possibility that enabling this feature will cause performance degradation and unacceptable QoS on the guests. Currently, there is no QoS monitoring or alerting for this feature. This is planned for the future--this project is just a first step to full CPU Overcommitment support.

### Owner

*   Name: [ Greg Padgett](User:Gpadgett)
*   Email: <gpadgett@redhatdotcom>

### Current status

*   Implementation
*   Last updated date: 18 Dec 2012

### Detailed Description

This project would allow, on a configurable per-cluster basis, hosts to effectively treat host threads as cores which guests can utilize. The exposed threads would look like cores to the guest VMs. For example, a 24-core system with 2 cores per thread (48 threads total) could run any combination of VMs up to 48 virtual CPU cores total.

In oVirt 3.1, a host can only start VMs up to the point where a 1:1 virtual-to-physical CPU mapping is achieved. The described functionality can be achieved in 3.1 by changing a vdsm setting that exposes threads as cores, but it is on a host-by-host basis.

The proposal is to give the engine the knowledge of the host cores and threads, as well as the ability to choose how it wants to treat them with respect to VM capacity. When enabled, this feature would allow guest virtual CPU cores to run on host CPU threads based on host membership to a cluster. The running guests would not have knowledge of the threads (they would appear as cores) or the host-to-guest CPU mapping.

#### Changes

*   UI:
    -   add CPU threading info to Host status, General tab
    -   redesign Optimization tab of Add/Edit Cluster dialog, to include CPU Threading option
        -   new option not visible if cluster compatibility version < 3.2

![](cpuovercommit.png "cpuovercommit.png")

*   backend:
    -   add db column, boolean vds_groups.count_threads_as_cores (db scripts, DAO)
    -   add db column, boolean vds_dynamic.cpu_ht_enabled (db scripts, DAO)
    -   add db column, boolean vds_dynamic.vdsm_count_threads_as_cores
        -   -or- add boolean vds_dynamic.cpu_real_cores (see VDSM section for more detail)
        -   db scripts, DAO
    -   vdsbroker changes to store new vds_dynamic values
    -   logic changes for when VMs can run or migrate (VdsSelector)
*   REST API:
    -   add new cluster and vds attributes
*   VDSM:
    -   expose threading info (see VDSM section)

#### VDSM

VDSM currently exposes host count of cpuCores and cpuSockets, both in vdsGetCapabilities. There is a configuration setting, report_host_threads_as_cores, which if true, may cause the reported cpuCores value to not reflect the physical cpu topology of the host. To enable engine control of CPU threads, we need both an accurate core count, and a way to determine the number of cpu threads on the host. Moving forward, having an accurate cpu topology of the host will help enable performance optimization with NUMA considerations, CPU pinning (e.g. share L1 cache by pinning guest CPUs to the same physical cores), etc.

The proposal is to add two new attributes returned by the vdsGetCapabilities verb (or if vdsGetCapabilities is broken up, then from whichever verb returns the other CPU-related information):

*   cpuHtEnabled: boolean, true if host threads are enabled on the host's cpu. If true, the engine will treat each reported physical core as having 2 threads
*   reportHostThreadsAsCores: boolean, same value as vdsm.conf setting. The engine would store this in vds_dynamic.vdsm_count_threads_as_cores, and if true, would halve the cpu core count when reporting statistics for hosts in 3.2 clusters.

In the future, removal of the report_host_threads_as_cores setting would be ideal as engine will gain the ability to configure this same functionality cluster-wide via the webadmin interface. Cleanliness of the API should be considered moving forward, accounting for the engine's ability to detect when vdsm is lying about the number of cores, as well as engine-side considerations of how to best display the information we have available. The possibility of setting a minimum required vdsm version for the 3.2 engine, or calculating engine-side values based on vdsm version, may help keep the vdsm API clean.

Proposed getVdsCapabilities cpu attribute migration plan

| version | attributes                                                   | notes                                                                                     |
|---------|--------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| 3.1     | cpuSockets, cpuCores                                         | row 1, cell 3                                                                             |
| 3.2     | cpuSockets, cpuCores, cpuHtEnabled, reportHostThreadsAsCores | engine controls 3.2 clusters (knows if vdsm is adjusting cpuCores); vdsm controls <3.2   |
| 3.3     | cpuSockets, cpuCores, cpuHtEnabled                           | remove report_host_threads_as_cores, min cluster version 3.2; engine has full control |

#### Compatibility

This feature will be enabled for clusters with Compatibility Version >= 3.2. For those with lower versions, the default will be disabled: only host physical cores will be available for guest cores to run on. (Adjustable via VDSM, as today.) In this case, the section to set the Treat Threads as Cores attribute in the Add/Edit Cluster dialog will not be visible.

### Benefit to oVirt

Increase capacity of hosts for certain workloads.

### Dependencies / Related Features

*   TBD

### Documentation / External references

*   TBD

### Comments and Discussion

<Category:Feature> <Category:SLA>

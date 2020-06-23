---
title: CPU thread handling
category: feature
authors: dneary, doron, gpadgett
---

# CPU Thread Handling

## Summary

CPU Thread Handling allows hosts to run VMs with a total number of processor cores greater than number of cores in the host. This can be useful for non-CPU-intensive workloads, where allowing a greater number of VMs to start can reduce hardware requirements (along with the associated benefits of easier management, energy savings, lower hardware costs, etc). It also allows VMs to run with CPU topologies that wouldn't be allowed without this option, specifically if the number of guest cores is between the number of host cores and number of host threads.

This project would allow the engine to optionally treat host CPU threads as cores for the purposes of running VMs, on a user-configurable cluster-by-cluster basis. When both SMT (AMD Clustered MultiThreading or Intel Hyper-Threading technology) and this feature are enabled, this would increase the capacity of hosts and may help performance for certain workloads.

There is a possibility that enabling this feature will cause performance degradation and unacceptable QoS on the guests. Currently, there is no QoS monitoring or alerting for this feature. This is planned for the future--this project is just a first step to full CPU Overcommitment support.

## Owner

*   Name: Greg Padgett (Gpadgett)
*   Email: <gpadgett@redhatdotcom>

## Current status

*   4/5 patches merged, 1 in code review
*   Last updated date: 21 Dec 2012

## Detailed Description

This project would allow, on a configurable per-cluster basis, hosts to effectively treat host threads as cores which guests can utilize. The exposed threads would look like cores to the guest VMs. For example, a 24-core system with 2 threads per core (48 threads total) could run VMs with up to 48 cores each, and the algorithms to calculate host CPU load would compare load against twice as many potential utilized cores.

In contrast, oVirt 3.1 has very limited facilities to run VMs past the point where a 1:1 virtual-to-physical CPU mapping is achieved. The described functionality can be achieved in 3.1 by changing a vdsm setting that exposes threads as cores, but it is on a host-by-host basis configured on the host itself (in vdsm.conf; report_host_threads_as_cores=true).

The proposal is to give the engine the knowledge of the host cores and threads, as well as the ability to choose how it wants to treat them with respect to VM capacity. When enabled, this feature would allow guest virtual CPU cores to run on host CPU threads based on host membership to a cluster, further utilizing host CPU SMT capabilities. The running guests would not have knowledge of the threads (they would appear as cores) or the host-to-guest CPU mapping.

### Changes

*   UI:
    -   add CPU threading info to Host status, General tab
        -   this shows up only if a host is not a member of a 3.1 cluster
    -   redesign Optimization tab of Add/Edit Cluster dialog, to include CPU Threading option
        -   new option not visible if cluster compatibility version < 3.2

![](/images/wiki/Cpuovercommit.png)

![](/images/wiki/Cputhreads-hostsgeneral.png)

*   backend:
    -   add db column, boolean vds_groups.count_threads_as_cores
    -   add db column, integer vds_dynamic.cpu_threads
        -   db scripts, DAO for above changes
    -   vdsbroker changes to store new cpu_threads value
    -   logic changes for when VMs can run or migrate (VdsSelector)
        -   compute an effective core count based on cpu threading capability and cluster configuration
*   REST API:
    -   add new cluster and vds attributes
*   VDSM:
    -   expose threading info (see VDSM section)

<!-- -->

*   -   -or- add boolean vds_dynamic.cpu_real_cores (see VDSM section for more detail)

### VDSM

VDSM currently exposes host count of cpuCores and cpuSockets, both in getVdsCapabilities. There is a configuration setting, report_host_threads_as_cores, which if true may cause the reported cpuCores value to not reflect the physical cpu topology of the host. To enable engine control of CPU threads, we need both an accurate core count, and a way to determine the number of cpu threads on the host. Moving forward, having an accurate cpu topology of the host will help enable performance optimization with NUMA considerations, CPU pinning (e.g. share L1 cache by pinning guest CPUs to the same physical cores), etc.

One new option will be returned from getVdsCapabilities: an integer cpuThreads. This will always report the actual number of threads on the host. It is possible for the cpuCores value returned from vdsm to not be true, based on the vdsm.conf report_threads_as_cores setting on the host. \*\* It is recommended to turn this setting off for hosts in 3.2 clusters and let the engine manage cpu thread utilization. \*\* This configuration option may be removed in the future, now that the engine can accomplish the same task.

(For historical context, note that an option to return an extra value to allow engine to determine the true number of cores was discussed. This would have been either a boolean reflecting the vdsm.conf option above, or an integer e.g. cpuCores2 which would always report the true number of cores. However, the additional complexity and cruft in the API wasn't justified by the [estimated] rare use of this option.)

CPU topology returned by getVdsCapabilities

| version   | attributes                       | notes                                                                                                                                                |
|-----------|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| 3.1       | cpuSockets, cpuCores             | cpuCores may actually be cpuThreads                                                                                                                  |
| 3.2       | cpuSockets, cpuCores, cpuThreads | engine should controls 3.2 cluster threading; vdsm controls <3.2; users should turn off vdsm.conf report_host_threads_as_cores for 3.2 clusters |
| after 3.2 | cpuSockets, cpuCores, cpuThreads | if min cluster version is 3.2, vdsm.conf report_host_threads_as_cores may be removed                                                             |

### Compatibility

This feature will be enabled for clusters with Compatibility Version >= 3.2. For those with lower versions, the default will be disabled: only host physical cores will be available for guest cores to run on. (Adjustable via VDSM, as today.) In this case, the section to set the Treat Threads as Cores attribute in the Add/Edit Cluster dialog will not be visible.

## Benefit to oVirt

Increase capacity of hosts for certain workloads.

## Dependencies / Related Features

*   TBD

## Documentation / External references

*   TBD



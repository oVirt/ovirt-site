---
title: CPU thread handling
category: feature
authors: dneary, doron, gpadgett
wiki_category: Feature
wiki_title: Features/CPU thread handling
wiki_revision_count: 25
wiki_last_updated: 2012-12-21
---

# CPU thread handling

## CPU Overcommit

### Summary

CPU Overcommit allows hosts to run VMs with a total number of processor cores greater than number of cores in the host. This can be useful for non-CPU-intensive workloads, where allowing a greater number of VMs to start can reduce hardware requirements (along with the associated benefits of easier management, energy savings, lower hardware costs, etc).

This project would allow the engine to optionally treat host CPU threads as cores for the purposes of running VMs, on a user-configurable cluster-by-cluster basis. When both hyperthreading and this feature are enabled, this would increase the capacity of hosts and may help performance for certain workloads.

There is a possibility that enabling this feature will cause performance degredataion and unacceptable QoS on the guests. Currently, there is no QoS monitoring or alerting for CPU overcommitment. This is planned for the future--this project is just a first step to full CPU Overcommitment support.

### Owner

*   Name: [ Greg Padgett](User:Gpadgett)
*   Email: <gpadgett@redhatdotcom>

### Current status

*   Planning
*   Last updated date: 6 Dec 2012

### Detailed Description

This project would allow, on a configurable per-cluster basis, hosts to effectively treat hyperthreads as cores which guests can utilize. The exposed threads would look like cores to the guest VMs. For example, a 24-core system with 2 cores per thread (48 threads total) could run any combination of VMs up to 48 virtual CPU cores total.

In oVirt 3.1, a host can only start VMs up to the point where a 1:1 virtual-to-physical CPU mapping is achieved. The described overcommitment functionality can be achieved in 3.1 by changing a vdsm setting that exposes threads as cores, but it is on a host-by-host basis.

The proposal is to give the engine the knowledge of the host cores and threads, as well as the ability to choose how it wants to treat them with respect to VM capacity. When enabled, this feature would allow guest virtual CPU cores to run on host CPU threads based on host membership to a cluster. The running guests would not have knowledge of the threads (they would appear as cores) or the host-to-guest CPU mapping.

#### Changes

*   UI:
    -   add CPU hyperthreading info to Host status, General tab
    -   add UI element to set option in Add/Edit Cluster dialog
        -   not visible if cluster compatibility version < 3.2

![](cpuovercommit.png "cpuovercommit.png")

*   backend:
    -   add vds_groups.treat_threads_as_cores boolean attribute
        -   add column to database table
        -   DAO changes
    -   logic changes for when VMs can run or migrate (VdsSelector)
*   REST API:
    -   add new cluster attribute
*   VDSM:
    -   expose hyperthreading info (specifics TBD)

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

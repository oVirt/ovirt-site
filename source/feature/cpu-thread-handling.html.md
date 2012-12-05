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

There is the possibility of setting the value too high, which can cause performance degredataion and unacceptable QoS on the guests. Currently, there is no QoS monitoring or alerting for CPU overcommitment. This is planned for the future--this project is just a first step to full CPU Overcommitment support.

### Owner

*   Name: [ Greg Padgett](User:Gpadgett)
*   Email: <gpadgett@redhatdotcom>

### Current status

*   Planning
*   Last updated date: 5 Dec 2012

### Detailed Description

In oVirt 3.1, a host can only start VMs up to the point where a 1:1 vCPU-to-pCPU mapping is achieved. This project is a first step in allowing virtual CPU cores to share physical CPU cores.

The capability will be defined on a per-cluster level, similarly to memory overcommitment. Once adjusted, all hosts in the cluster will allow overcommitment to the same vCPU-to-pCPU ratio.

#### Changes

*   engine modifications:
    -   add validation for limits during save
    -   add vds_groups.max_cpu_overcommit value
        -   add column to database table
        -   DAO changes
    -   logic changes for when VMs can/should start on hosts
    -   logic changes for when VMs can be migrated between hosts
    -   add UI element to set overcommitment threshold in Add/Edit Cluster dialog
        -   warning if custom utilization < 100%
        -   not visible if cluster compatibility version < 3.2

![](cpuovercommit.png "cpuovercommit.png")

*   REST API:
    -   add new element

#### Compatibility

This feature will be enabled for clusters with Compatibility Version >= 3.2. For those with lower versions, the value of 100%--the current effective value--will continue to be used. In this case, the section to set the CPU Overcommit threshold in the Add/Edit Cluster dialog will not be visible.

### Benefit to oVirt

Increase capacity of hosts for certain workloads.

### Dependencies / Related Features

*   TBD

### Documentation / External references

*   TBD

### Comments and Discussion

<Category:Feature> <Category:SLA>

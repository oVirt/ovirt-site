---
title: External Scheduler Samples
category: sla
authors: doron, nslomian
---

# External Scheduler Samples

## Introduction

When running or migrating VMs the external scheduler proxy is used to introduce user written logic in to the selection process of hosts . The user can effect the selection process In two ways

*   filtering hosts
*   scoring hosts

He can also replace the entire load balancing logic with an entity suitably called

*   load balance

## Filtering

Filtering is referring to the act of disqualifying hosts from being a candidates for running a VM. For instance, a VM count filter may rule out hosts already running a certain number of VMs.

The external scheduler ships with this sample filter doing just that: [Filter By VM Count](/develop/sla/filter-by-vm-count.html)

## Scoring

Scoring is referring to the act of giving hosts scores representing how well are they suited to run a specific VM. For instance, ksm scoring may give hosts running similar VMs a higher rank. making them more likely to be selected.

Luckily we have just that sample already shipping with the external proxy, this proxy scores based on the similarity of the VMs operating system: [Score KSM OS](/develop/sla/score-ksm-os.html)

## Load Balancing

Load balancing is an optional settings telling the engine to periodically check if some hosts are overloaded. If one or more are found the engine will try and migrate VMs from those hosts (one at a time). There are a few default load balancers shipping with Ovirt, but the user can replace them with a custom load balancer of his own. For instance a memory load balancer may move a VMs from hosts that are under memory pressure (for instance due to overcommitting)

An example of this can be found here: [Host Memory balance](/develop/sla/host-memory-balance.html)

**This includes a complete explanation of every part of the code, I would recommend taking a look at it if you wish to write your own external scheduling component**


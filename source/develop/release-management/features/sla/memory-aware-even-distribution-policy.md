---
title: Memory-aware Even-distribution Policy
category: feature
authors: ofri
---

# Memory-aware Even-distribution Policy

This document describes the design for a new algorithm which seeks even distribution of Virtual Machines over Hosts by using host memory usage state as well as its CPU usage state.

## Motivation

In current implementation the user can select between two policies for optimizing the distribution on Virtual-Machines over the Hosts in the Cluster.

*   Even-Distribution - Even Distribution
*   Power Saving

Both policies are based on a single algorithm which takes into consideration only the state of the host's CPU and the VMs CPU usage. This solution can potentially lead to a situation where heavy memory using VMs would be crowded into into the same host. Which would lead to heavy memory use on the host and degradation in the host and the VMs performance.

By adding the state of the host memory and the memory usage of each VM to the algorithm considerations we could avoid situations as described above.

## GUI

Current UI is a 3 radio button selection for selecting only the policy:

*   None
*   Even Distribution
*   Power Saving

Since only one algorithm is available there is no UI for algorithm selection.

The new UI would include a selection box for selecting the algorithm (in addition to the policy section radio buttons). The percentage bar currently used to set the top and bottom thresholds for the current algorithm would remain the same. In case the new Memory aware algorithm will be selected, the percentage will be used as memory threshold and cpu threshold.

## REST API

## Backend

Solution was designed to simple although not optimal. Future changes may include more complex logic.

### Logic Design

In each iteration of the balancing process:

1. Handle CPU balancing (ie- consider cpu violators first), as we did so far

2. If (1) has nothing to do, handle memory balancing

        a. Get a list of memory violator hosts, based on physical memory only
        b. For each host
            b.1. Sort VMs by memory usage
            b.2  Validate if Smallest memory-using VM matches any of under-utilized hosts (based on mem and cpu, so end result will not cause the destination to violate balance thresholds).
            b.3  If vm+dest host match, Migrate the VM.

Advanced options:

*   we can allow the user to choose migration of the biggest memory violator, and he'll need to see if it work better for him. Either way the default will be smallest.
*   we can allow the user to choose handling memory violations prior to CPU. The default will be CPU first.

## Tests

Unit-tests for testing the new policy will be added.

### Special considerations

No special considerations.


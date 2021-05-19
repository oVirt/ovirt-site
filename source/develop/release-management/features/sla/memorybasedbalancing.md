---
title: MemoryBasedBalancing
category: feature
authors: msivak
---

# Memory Based Balancing

## CPU and Memory based cluster auto balancing

### Summary

The auto balancing cluster policies we have today use only CPU load to compute whether the cluster is reasonably balanced. This is not ideal in situations where the prevalent load is memory based and CPU load is low. The goal of this feature is to add support for memory based balancing rules.

### Owner

*   Name: Martin Sivak (Msivak)
*   Email: <msivak@redhat.com>

### Detailed Description

The issue we are trying to solve can be demonstrated on a lightly loaded cluster:

When you start 100 VM (for example) that only boot and wait in PXE or bootloader menu the total load on the host is going to be close to 0. The current balancing policy can (and will) keep adding VMs to a single host (considering other constraints are not a factor), because it only uses the current CPU load in the scoring function.

It also won't notice any gross unbalance in the number of VMs running on different hosts if the CPU load is under the "High Load" threshold. And that is by default 80% that is much higher than the accumulated 0% or 1%.

#### The proposed changes

*   When CPU balancing is needed, everything will work as usual with one exception. Memory over-committed hosts won't be used as destination.
*   When no CPU balancing is needed, free memory will control the balancing using the same rules CPU uses: Over-committed hosts will be considered to be willing to donor a VM to an Under-committed host (Evenly balanced policy) or both Over- and Under-committed hosts will be sourcing the VMs for the "middle" loaded hosts (Power saving policy). Memory balancing will get its own set of High and Low limits in terms of free MB of RAM.
*   No migration will happen to hosts that are (or will become) either CPU or memory over-committed.
*   The memory based balancing can be disabled by using 0 MB as both high and low thresholds.
*   Setting only one of the thresholds in memory based balancing (high or low) might lead to unexpected results.
*   Unit-tests will be introduced to make sure the old CPU load based behaviour is still the same.
*   New weight policy unit for memory load will appear. Each 100 MB of free memory on a host will be worth one negative (better) weight point.

The balancing operations are illustrated using the two following pictures:

![](/images/wiki/Equally-balanced.png) ![](/images/wiki/Power-saving.png)

### Benefit to oVirt

*   Cluster auto-balancing will be usable for memory loaded clusters as well.
*   Refactoring and unit test support will greatly improve the reliability of the Scheduler

### Dependencies / Related Features

This feature has no external dependencies and does not modify any code outside of the engine's scheduling mechanisms.

### Documentation / External references

TBD

### Testing

*   Unit tests are provided for the basic cases
*   There is a simple way (CSV tables) of providing new test scenarios to become part of the test suite
*   Manual testing with multiple hosts and VMs is required to see the live behaviour

### Contingency Plan

No memory based scheduling will be available. There is no danger to the existing functionality if this is not accepted.

### Release Notes

TBD




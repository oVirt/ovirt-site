---
title: PendingResourceManager
category: feature
authors: msivak
feature_name: Pending Resource Manager
feature_modules: engine
feature_status: Draft
---

# Pending Resource Manager

## Summary

This feature will introduce a new way of tracking resources that are assigned to a VM which has not been started yet (WaitForLaunch). It will allow us to retrieve the aggregate value for pending resources that are reserved on a certain host prior to the VM real start.

This is meant to replace the old VDS.pendingVmem and VDS.pendingVCpuCount counters.

## Owner

*   Name: Martin Sivak (Msivak)
*   Email: <msivak@redhat.com>

## Detailed Description

The current way of tracking the pending resources has a lot to desire. It can only track memory and cpu cores and is prone to double decrement issues (compromising the counters' accuracy).

A new internal scheduling component is proposed here - Pending Resource Manager.

This new manager will track each allocated resource separately in context of both a VM and a Host. The aggregate value will be computed when needed to avoid double decrement bugs. Freeing the resource twice will just try twice to remove a resource record from the internal memory structure, but won't compromise other records. That way the reported counts and aggregates will still be correct.

Each resource will be represented by its own class type, host and VM assignment + the necessary values (memory size, cpu count..).

The PRM will be able to return a list (or aggregate) of pending resources of a specified type per Host or per VM as needed. This information will be then used in the policy units instead of the current usage of pendingVmem and pendingVcpu numerical counters.

## Benefit to oVirt

The scheduling mechanism will be able to track planned VM executions including their resources better. This will help fix bugs related to Affinity rules during VM mass-start or maintenance mode migration.

It will be easy to add support for new resources.

## Dependencies / Related Features

This feature depends on the unit test part of [Features/Sla/MemoryBasedBalancing](/develop/release-management/features/memorybasedbalancing/) and is related to the ongoing effort for [Host device passthrough](/develop/release-management/features/engine/hostdev-passthrough/) and [Virtual device (SR-IOV)](/develop/release-management/features/engine/sr-iov/) support.

## Documentation / External references

TBD

## Testing

*   Unit tests are provided for the basic cases
*   Manual testing with multiple hosts and VMs is required to see the live behaviour

## Contingency Plan

Old pending resource tracking will be used. There is no danger to the existing functionality if this is not accepted, but affinity related rules (for example) might be violated during mass-starts or mass migrations.

## Release Notes

TBD




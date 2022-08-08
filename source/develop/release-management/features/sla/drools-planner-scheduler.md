---
title: drools planner scheduler
category: feature
authors: lhornyak
---

> IMPORTANT:
> This feature did not make into oVirt and very likely never will, a scheduling similar to OpenStack Nova was implemented in oVirt 3.3 There is no further plan for implementing it.

# Drools Planner scheduler

## Summary

To improve the quality of VM scheduling, built on the [pluggable scheduling architecture](/develop/release-management/features/sla/ovirtschedulerapi.html), this project will integrate **drools** and **planner** into the ovirt engine

The main objectives of the drools scheduler:

*   allow better resource utilization
*   avoid frequent VM migrations
*   possibly more power saving
*   to be a smarter default scheduler for ovirt

## Owner

*   Name: Laszlo Hornyak (Lhornyak)

## Current status

*   Under development - initial patches <http://gerrit.ovirt.org/8893>
*   Last updated date: 14 NOV 2012

## Detailed Description

### Overview

![](/images/wiki/Drools_score_calculation_plan.png)

The rule calculation will be broken down to three major categories:

*   [costs of the migration](#costs-of-the-migration)
*   [benefits of the migration](#benefits-of-the-migration)
*   [costs of the situatuion](#costs-of-the-situation)

Also, there will be some hard constraints enforced, e.g. required optional networks must be available on vds.

Soft constraints will be applied to tune for better performance, hard constraints will be applied to avoid broken configurations.

### Migration and new VM start

The scheduler will be prepared for load ballancing, this will be represented as a VM running on **null** and need to find a VDS to migrate to (however, this is not really a migration). In case of new VM start, the migration rules should be calculated as zero.

### Costs of the migration

Migration costs will be calculated in order to prevent migrating VM's for minor/momentary benefits.

As part of the migration, these costs should be calculated:

*   The size of the allocated memory of the VM, this data must be sent over the network, so the more data, the slower
*   The actual CPU load, since at migration the throughput drops to zero for a short time, but users do not tolerate such delays.
*   Is console attached. If VM is in use by user, it may be better to migrate another Vm from the host.

### Costs of the situation

The costs of the situation are calculated in order to counterweight the costs of the migration. Some example for situation costs:

*   Overallocation of CPU/memory/network bandwidth/IO
*   High utilisation of physical CPU/memory/network bandwidth/IO
*   Unused resources CPU/memory/network bandwidth/IO - since they only consume power. e.g. a server with 16 CPU's with only 2 vcpus allocated.

The overallocation should be a smaller cost, while the high utilisation should generate a bigger one, but only when it happens.

### Benefits of the migration

The benefits of the migration:

*   may help to counterweight the costs of the migration
*   help to select the optimal available host

Note that the benefits may be negative, in case the host is already overallocated or overused.

All rules in [situation costs](#costs-of-the-situation) should have a migration benefits counterpart, but this one should calculate the difference from an optimal state after the migration.

### Implementation details

*   Time constraint - should be configurable
*   The benefits/compensations should be calculated as negative cost

### Hard constraints

*   Memory constraints
    -   free memory on target node < vm minimal memory - not enough free memory
    -   *free memory on target node < vm maximal memory requirement should be a **soft** constraint*
*   Network constraints
    -   all VM networks must be available on VDS
*   CPU constraints
    -   VM cpus > VDS.cpus - not enough CPUs
    -   *note that cpu over and under-allocation are soft constraints*
*   future hard constraints
    -   [Trusted_compute_pools](/develop/release-management/features/sla/trusted-compute-pools.html) VM's with trusted flag can only run on trusted hosts

## Benefit to oVirt

The new scheduler improves oVirt's default scheduler (~VdsSelector) and gives a better user experience by minimizing the number of migrations and optimizing resource utilization.

## Dependencies / Related Features

*   This feature will be built built on [Features/SLA_PluggableArchitecture](/develop/release-management/features/sla/ovirtschedulerapi.html).
*   drools and drools planner <http://www.jboss.org/drools/>
*   [870322](https://bugzilla.redhat.com/show_bug.cgi?id=870322) - Keep history data for VDS and VM load

## Documentation / External references

## Comments and Discussion

Comments are welcome on the irc channel, engine-devel mailing list and in person.


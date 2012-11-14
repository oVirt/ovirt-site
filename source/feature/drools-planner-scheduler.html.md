---
title: drools planner scheduler
category: feature
authors: lhornyak
wiki_category: Feature
wiki_title: Features/drools planner scheduler
wiki_revision_count: 27
wiki_last_updated: 2013-09-03
---

# drools planner scheduler

## Drools scheduler

### Summary

To improve the quality of VM scheduling, built on the [pluggable scheduling architecture](Features/SLA_PluggableArchitecture), this project will integrate drools and planner into the ovirt engine

The main objectives of the drools scheduler:

*   allow better resource utilization
*   avoid frequent VM migrations
*   possibly more power saving
*   to be a smarter default scheduler for ovirt

### Owner

*   Name: [ Laszlo Hornyak](User:Lhornyak)
*   Email: <lhornyak@redhatdotcom>

### Current status

*   Under development
*   Last updated date: 14 NOV 2012

### Detailed Description

#### Overview

![](Drools_score_calculation_plan.png "Drools_score_calculation_plan.png")

The rule calculation will be broken down to three major categories:

*   costs of the migration
*   benefits of the migration
*   costs of the situatuion

Also, there will be some hard constraints enforced, e.g. required optional networks must be available on vds.

#### Costs of the migration

Migration costs will be calculated in order to prevent migrating VM's for minor/momentary benefits.

As part of the migration, these costs should be calculated:

*   The size of the allocated memory of the VM, this data must be sent over the network, so the more data, the slower
*   The actual CPU load, since at migration the throughput drops to zero for a short time, but users do not tolerate such delays.
*   Is console attached. If VM is in use by user, it may be better to migrate another Vm from the host.

#### costs of the situation

The costs of the situation are calculated in order to counterweight the costs of the migration. Some example for situation costs:

*   Overallocation of CPU/memory/network bandwidth/IO
*   High utilisation of physical CPU/memory/network bandwidth/IO
*   Unused resources CPU/memory/network bandwidth/IO - since they only consume power. e.g. a server with 16 CPU's with only 2 vcpus allocated.

The overallocation should be a smaller cost, while the high utilisation should generate a bigger one, but only when it happens.

#### Benefits of the migration

The benefits of the migration:

*   may help to counterweight the costs of the migration
*   help to select the optimal available host

Also the benefits may be negative, in case the host is already overallocated or overused.

### Benefit to oVirt

The new scheduler improves oVirt's default scheduler (~VdsSelector) and gives a better user experience by minimizing the number of migrations and optimizing resource utilization.

### Dependencies / Related Features

### Documentation / External references

### Comments and Discussion

<Category:Feature>

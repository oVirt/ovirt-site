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

*   [costs of the migration](#Costs_of_the_migration)
*   [benefits of the migration](#Benefits_of_the_migration)
*   [costs of the situatuion](#Costs_of_the_situation)

Also, there will be some hard constraints enforced, e.g. required optional networks must be available on vds.

Soft constraints will be applied to tune for better performance, hard constraints will be applied to avoid broken configurations.

#### Migration and new VM start

The scheduler will be prepared for load ballancing, this will be represented as a VM running on **null** and need to find a VDS to migrate to (however, this is not really a migration). In case of new VM start, the migration rules should be calculated as zero.

#### Costs of the migration

Migration costs will be calculated in order to prevent migrating VM's for minor/momentary benefits.

As part of the migration, these costs should be calculated:

*   The size of the allocated memory of the VM, this data must be sent over the network, so the more data, the slower
*   The actual CPU load, since at migration the throughput drops to zero for a short time, but users do not tolerate such delays.
*   Is console attached. If VM is in use by user, it may be better to migrate another Vm from the host.

#### Costs of the situation

The costs of the situation are calculated in order to counterweight the costs of the migration. Some example for situation costs:

*   Overallocation of CPU/memory/network bandwidth/IO
*   High utilisation of physical CPU/memory/network bandwidth/IO
*   Unused resources CPU/memory/network bandwidth/IO - since they only consume power. e.g. a server with 16 CPU's with only 2 vcpus allocated.

The overallocation should be a smaller cost, while the high utilisation should generate a bigger one, but only when it happens.

#### Benefits of the migration

The benefits of the migration:

*   may help to counterweight the costs of the migration
*   help to select the optimal available host

Note that the benefits may be negative, in case the host is already overallocated or overused.

All rules in [situation costs](#costs_of_the_situation) should have a migration benefits counterpart, but this one should calculate the difference from an optimal state after the migration.

#### Implementation details

*   Time constraint - should be configurable
*   The benefits/compensations should be calculated as negative cost

### Benefit to oVirt

The new scheduler improves oVirt's default scheduler (~VdsSelector) and gives a better user experience by minimizing the number of migrations and optimizing resource utilization.

### Dependencies / Related Features

*   This feature will be built built on [Features/SLA_PluggableArchitecture](Features/SLA_PluggableArchitecture).
*   drools and drools planner <http://www.jboss.org/drools/>

### Documentation / External references

### Comments and Discussion

Comments are welcome on the irc channel, engine-devel mailing list and in person.

<Category:Feature>

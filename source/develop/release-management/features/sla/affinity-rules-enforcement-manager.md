---
title: Affinity Rules Enforcement Manager
category: feature
authors: doron, maroshi, rmohr, tsaban
---

# Affinity Rules Enforcement Manager

## Summary

A new manager that will enforce affinity rules for running VMs. The manager will periodically check each cluster for affinity rule conflicts and will try to resolve those conflicts by migrating problematic VMs. Each interval only one VM will be migrated by the manager for each cluster(As long as there are conflicts).

The following picture, explains AR (Affinity Rules), before enforcement and after enforcement
(The green boxes represent VMs belonging to positive affinity groups and the red ones are VMs belonging to negative affinity groups.
See VM-Affinity page for more details [Features/VM-Affinity](/develop/release-management/features/sla/vm-affinity.html)). ![](/images/wiki/Affinity_Rule_Enforcement.png)

## Owner

*   Name: Tsaban (Tsaban)
*   Email: <tsaban@redhat.com>

## Procedure

![](/images/wiki/ARES_Life_Cycle.png)
[1][2]
[The following method identify broken affinity rule, designate vm that breaks the rule and migrates the vm.]
**\1**

1.  Find migration free clusters
2.  for each migration free cluster:
    1.  **choose next VM to migrate** and add to VM candidates.

3.  for each vm candidate for migrations:
    1.  migrate VM.

## Related methods

**\1**

1.  Get all hard affinity groups.
2.  Get unified affinity groups().

The following picture explains UAG (Unified Affinity Group) algorithm

![](/images/wiki/UAG_Algorithm.png)

1.  Loop over all unified affinity groups(order by size and than by lowest VM id[4]):
    1.  if affinity group positive:
        1.  find VM violating positive affinity group

    2.  Else:
        1.  find VM violating negative affinity group

    3.  if found candidate VM check if can migrate VM:
        1.  If can migrate VM then return VM.

 **\1**

1.  UAG = {% raw %}{{vm} for each vm}{% endraw %}
2.  For each (+) affinity group(Sorted by group id):
    1.  unify VMs from the group in UAG(Sorted by vm id).
    2.  For each (-) affinity group(Sorted by group id):
        1.  For each group in UAG(Sorted by first vm uuid):
            1.  if size of the intersection of group from UAG and the negative group is > 1:
                1.  throw exception “Affinity group contradiction detected” (With associated groups).

## Footnotes

[1]Methods are written in the section “related methods”.
[2] If no class is written(As for most methods/fields) assume it’s in the manager itself.
[3] The migration command will be done automatically to let the scheduler decide where to migrate the VM based on other policies as well.
[4] It’s important to keep getting the same groups in the same order each time. The order is kept because affinity group are assumed not to change very often during enforcement.

## Testing

1.  Manager creation when cluster is created:
    1.  Manager creation on startup.
        1.  Start engine
        2.  Check log to see that ARES has created PerCluster object for the default cluster.

    2.  Manager creation on new cluster.
        1.  Create new cluster
        2.  Check log to see that ARES has created PerCluster object for the new cluster.

    3.  Manager deletion of deleted cluster(pre-condition = test 1b):
        1.  Delete cluster
        2.  Check log to see that ARES has deleted PerCluster object for the deleted cluster.

2.  Manager interval check:
    1.  Check regular interval:
        1.  Create new cluster.
        2.  Check log to see that ARES has created PerCluster object for cluster. (Make sure cluster has affinity rules).
        3.  Add 2 VMs on the same host
        4.  Add negative affinity rule for the 2 VMs.
        5.  wait for “regular interval”
        6.  check that ARES interval reached.

    2.  Check long interval: (Preconditions = one datacenter is up, affinity rules enforced).
        1.  Create new cluster.
        2.  Check log to see that ARES has created PerCluster object for cluster. (Make sure cluster has no affinity rules).
        3.  Wait for long interval
        4.  Check logs to see that long interval reached.

3.  Manager Affinity Rules enforcement:
    1.  Enforcement for positive affinity rule: (Precondition load balancer if off, All vms can run together on the same hypervisor)
        1.  Start engine
        2.  Add 2 hosts.
        3.  For host A add 3 Vms
        4.  For host B add 1 Vm
        5.  Add positive affinity rule for all VMs.
        6.  Wait for regular interval.
        7.  See that the Vm from Host B migrated to host A.

    2.  Enforcement for negative affinity rule: (Preconditions: load balancer if off, All vms can run together on the each hypervisor)
        1.  Start engine
        2.  Add 2 hosts.
        3.  For host A add 2 Vms
        4.  For host B no Vms should be running on it.
        5.  Add negative affinity rule for the two VMs.
        6.  Wait for regular interval.
        7.  See that one Vm migrated from host A to host B.

    3.  Enforcement for balanced hypervisors:(Precondition: All Vms should be able to run on the same hypervisor at once)
        1.  Start engine
        2.  Add 2 hosts
        3.  For host A add 3 Vms
        4.  For host B add 3 Vms
        5.  Add positive affinity rule for all Vms.
        6.  Wait for 6 regular intervals(6 \* regular interval)
        7.  See that all Vms migrated from one of the hosts to the other one.

4.  Affinity Rule contradictions check:
    1.  Check two opposite conditions:
        1.  Start engine
        2.  Add 2 hosts
        3.  Add 2 Vms
        4.  Add positive affinity rule for both VMs.
        5.  Add negative affinity rule for both VMs.
        6.  Wait for regular interval.
        7.  Check logs to see a new exception was thrown saying: “Affinity group contradiction detected” (With associated groups).

5.  Balancer competing managers:
    1.  Check power saving and colliding affinity:
        1.  Start engine
        2.  Add 2 hosts
        3.  Add 6 Vms(Each host should have 3 VMs).
        4.  Add positive affinity rule for 3 VMs
        5.  Put balancer on power saving.
        6.  Wait for a 4 regular intervals(4 \* regular interval).
        7.  Check in the logs that the manager has been shutdown because of contradicting migrations.

## Benefit to oVirt

Affinity groups will be enforced also for VMs which are already running.

## Dependencies / Related Features

1.  SchedulerUtilQuartzImpl - scheduleAFixedDelayJob, scheduleAOneTimeJob.
2.  VmAffinityFilterPolicyUnit - getAcceptableHosts, filter.
3.  MigrateVmCommand.
4.  AddAffinityGroupCommand.

## Intervals and values used in the system

1.  Regular interval - 1 minute.

## Release Notes

This feature is a manager that checks if hard affinity rules are broken and migrates VMs in order to enforce them.
This manager includes:

1.  Manager only starts migrations when no other migrations are active in the cluster.
2.  Manager uses scheduler's automatic migration command to comply with filter and weight policies.
3.  Manager has a new and improved algorithm for finding affinity rule contradictions called "Unified Affinity Group Algorithm".
4.  Manager will enforce affinity rules one by one, starting with the violated affinity rule which consists of most VMs.
5.  Manager's strategy to enforce affinity rules in case of positive groups is to migrate VMs from the hypervisor that has the minimum number of VMs from the same affinity group to the one that has the most VMs(Taking into account the Scheduler policies. Sometimes VMs might be migrated to a different host if the scheduler thinks it's better).
6.  Affinity rules only work for clusters with version >= 3.5.

## Phase 2 (not included in 3.6.0)

1.  Using UAG algorithm to tell the user where there are conflicting affinity rules and also if the affinity rules can be optimized by uniting positive intersecting groups.
2.  Taking into consideration the host's RAM, CPU type, Network interfaces etc in order choose only hosts that can run the entire affinity group(In case of enforcing positive affinity group).


For more information see the following BugZilla link:
<https://bugzilla.redhat.com/show_bug.cgi?id=1112332>



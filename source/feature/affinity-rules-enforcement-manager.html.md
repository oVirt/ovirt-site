---
title: Affinity Rules Enforcement Manager
category: feature
authors: doron, maroshi, tsaban
wiki_category: Feature|Affinity Group Enforcement Manager
wiki_title: Affinity Rules Enforcement Manager
wiki_revision_count: 33
wiki_last_updated: 2015-05-19
feature_name: Affinity Rules Enforcement Manager
feature_modules: engine
feature_status: In Development
---

# Affinity Rules Enforcement Manager

### Summary

A new manager that will enforce affinity rules for running VMs. The manager will periodically check each cluster for affinity rule conflicts and will try to resolve those conflicts by migrating problematic VMs. Each interval only one VM will be migrated by the manager for each cluster(As long as there are conflicts).

The following picture, explains AR (Affinity Rules), before enforcement and after enforcement
(The green boxes represent VMs belonging to positive affinity groups and the red ones are VMs belonging to negative affinity groups.
See VM-Affinity page for more details <http://www.ovirt.org/Features/VM-Affinity>). ![](Affinity_Rule_Enforcement.png "fig:Affinity_Rule_Enforcement.png")

### Owner

<http://www.ovirt.org/User:Tsaban>

*   Name: [ Tomer Saban](User:Tsaban)
*   Email: <tsaban@redhat.com>

### Procedure

![](ARES_Life_Cycle.png "fig:ARES_Life_Cycle.png")
[1][2]
[The following method identify broken affinity rule, designate vm that breaks the rule and migrates the vm.]
**\1**

1.  Find migration free clusters
2.  for each migration free cluster:
    1.  **choose next VM to migrate** and add to VM candidates.

3.  for each vm candidate for migrations:
    1.  migrate VM.

### Related methods

**\1**

1.  Get all hard affinity groups.
2.  Get unified affinity groups().

The following picture explains UAG (Unified Affinity Group) algorithm

![](UAG_Algorithm.png "fig:UAG_Algorithm.png")

1.  Loop over all unified affinity groups(order by size and than by lowest VM id[4]):
    1.  if affinity group positive:
        1.  find VM violating positive affinity group

    2.  Else:
        1.  find VM violating negative affinity group

    3.  if found candidate VM check if can migrate VM:
        1.  If can migrate VM then return VM.

 **\1**

1.  UAG = {{vm} for each vm}
2.  For each (+) affinity group(Sorted by group id):
    1.  unify VMs from the group in UAG(Sorted by vm id).
    2.  For each (-) affinity group(Sorted by group id):
        1.  [5]For each group in UAG(Sorted by first vm uuid):
            1.  if size of the intersection of group from UAG and the negative group is > 1:
                1.  throw exception “Affinity group contradiction detected” (With associated groups).

### Footnotes

[1]Methods are written in the section “related methods”.
[2] If no class is written(As for most methods/fields) assume it’s in the manager itself.
[3] The migration command will be done automatically to let the scheduler decide where to migrate the VM based on other policies as well.
[4] It’s important to keep getting the same groups in the same order each time. The order is kept because affinity group are assumed not to change very often during enforcement.
[5] VMs in error state can’t migrate.

### Related Data Structures

**\1**

1.  UUID vm.
2.  UUID sourceHost.
3.  vdcReturnValue migrationReturnValue.
4.  VDS targetHost

**\1**

1.  List<MigrationEntryDS> lastMigrations.
2.  Integer migrationTries.

**\1**

1.  SHORT_INTERVAL = 1.
2.  LONG_INTERVAL = 15.
3.  MAXIMUM_MIGRATION_TRIES = 5.
4.  List<AffinityRulesEnforcemenetPerCluster> perClusterList.
5.  Iterator<AffinityRulesEnforcemenetPerCluster> AreClusterIterator;

== Testing ==

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

### Benefit to oVirt

Affinity group will be better enforced when a manager will be checking them periodically.

### Dependencies / Related Features

1.  SchedulerUtilQuartzImpl - scheduleAFixedDelayJob, scheduleAOneTimeJob.
2.  VmAffinityFilterPolicyUnit - getAcceptableHosts, filter.
3.  MigrateVmCommand.
4.  AddAffinityGroupCommand.
5.  SchedulerUtilQuartzImpl.

### Intervals and values used in the system

1.  Regular interval - 1 minute.
2.  Long interval - 15 minutes.
3.  Maximum migration tries - 5.

### Release Notes

This feature is a manager that checks if any affinity rules are broken and migrates VMs in order to enforce them.
This manager includes:

1.  Triggers for creation of the manager on Cluster Creation/Deletion.
2.  Managers wakes up on Affinity group Creation/Deletion/Update and engine startup.
3.  Manager Sleeps long interval when too many migration tries fail.
4.  Manager shutsdown when migration loop is detected or if the same migration happens more than once on the last 5 migrations.
5.  Manager avoid multiple migrations on the same cluster by sleeping when migration in progress(Using pending resource manager).
6.  Manager uses scheduler's automatic migration command to comply with filter and weight policies.
7.  Manager will sleep for 15 minutes instead of 5 if all affinity rules are enforced when interval is reached.
8.  Manager will automatically sort and create "Unified Affinity Rules" based on the defined affinity rules and will detect contradictions between rules.
9.  Manager will enforce affinity rules one by one in order to reduce the number of broken affinity rules as soon as possible.
10. Manager will try to resolve a specific affinity rule break by migrating VMs from hosts with less VMs from a than affinity group to the one with the maximum VMs.

### Phase 2

1.  Using UAG algorithm to tell the user where there are conflicting affinity rules and also if the affinity rules can be optimized by uniting positive intersecting groups.
2.  Taking into consideration host's RAM, CPU type, Network interfaces etc in order choose the best host to migrate the affinity group to.
3.  Taking into consideration where a vm might be migrated(This is supported in the system already but not in this feature). That way the enforcement process can be optimized better.

### Comments and Discussion

For more information see the following BugZilla link:
<https://bugzilla.redhat.com/show_bug.cgi?id=1112332>

*   Refer to <Talk:Affinity_Group_Enforcement_Manager>

[Affinity Group Enforcement Manager](Category:Feature) [Affinity Group Enforcement Manager](Category:oVirt 3.6 Proposed Feature) <Category:SLA>

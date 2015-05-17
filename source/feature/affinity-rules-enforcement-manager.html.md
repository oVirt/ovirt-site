---
title: Affinity Rules Enforcement Manager
category: feature
authors: doron, maroshi, tsaban
wiki_category: Feature|Affinity Group Enforcement Manager
wiki_title: Affinity Rules Enforcement Manager
wiki_revision_count: 33
wiki_last_updated: 2015-05-19
feature_name: Affinity Rules Enforcement Service
feature_modules: engine
feature_status: In Development
---

# Affinity Rules Enforcement Service

### Summary

A new engine internal service that will enforce affinity rules. The service will periodically query a list of VMs that break affinity rules, and will try to resolve the conflicts by migrating problematic VMs. Each cluster will have a separate service.

### Owner

<http://www.ovirt.org/User:Tsaban>

*   Name: [ Tomer Saban](User:Tsaban)

<!-- -->

*   Email: <tsaban@redhat.com>

### Procedure

[1][2][3]

#### Trigger each time a cluster is created(Or for the default cluster at startup)

*   Create new AffinityRulesEnforcementServicePerCluster:
    -   Set service interval to “regular interval”.

=== Trigger each time a cluster is deleted ===

*   In AffintiyRulesEnforcementService, find the service associated with the cluster and delete it.

=== Trigger before service shutdown ===

*   Write AuditLog message: “Affinity Rules Enforcement Service finished. all Affinity rules are enforced.”

#### Trigger each time a Create/Update/Delete action occur on affinity group and on engine startup

*   lastMigrations = new List<MigrationEntryDS>{}.
*   migrationTries = 0.
*   Wakeup ARES for associated cluster.

#### Service wakes up

*   migrationTries = 0.
*   lastMigrations = new List<MigrationEntryDS>{}.
*   Change interval to “regular interval” minute. Call the “Enforce affinity rule using migration”.
*   Write AuditLog message: “Affinity Rules Enforcement Service started”

 [The method finds broken affinity rule and chooses vm that break that rule and migrates it.]

#### Service interval reached: Enforce affinity rules using migration

*   if lastMigrations tail is currently migrating(Using PendingResourceManager):
    -   currentInterval = regular interval
    -   return.
*   Else:
    -   if lastMigrations tail exists(not null):
        -   if lastMigrations tail.getMigrationStatus() is failure:
            -   migrationTries++
            -   lastMigrations tail. setMigrationReturnValue to null.
*   if migrationTries == MAXIMUM_MIGRATION_TRIES:
    -   currentInterval = long interval
    -   migrationTries = 0.
    -   return.
*   Else if currentInterval == Long interval:
    -   currentInterval = regular interval.
    -   migrationTries = 0.
*   vm = Choose next vm to migrate(cluster).
*   [4]if vm is not null:
    -   lastMigrations tail.setMigrationReturnValue = [5]Call scheduler to migrate vm.
    -   currentInterval = regular interval
*   currentInterval = long interval (All affinity rules enforced).
*   return.

### Related methods

#### Choose next vm to migrate(cluster)

*   Get all affinity groups
*   Get unified affinity groups().
*   [6]Sort all groups first by size and then by first VM UUID.
*   Loop over all unified affinity groups:
    -   [7]candidate_host = choose_candidate_host_for_migration(Unified Affinity Group).
    -   loop all VMs in group:
        -   if current vm’s host is not candidate_host and [8]vm not in error state:
            -   current_migration = MigrationEntryDS(current_vm, current_vm.runOnVds()).
            -   If lastMigrations.contains(current_migration.opposite_migration()) or lastMigrations.contains(current_migration)
                -   print “Migrations loop occurred. Shutting down service.”
                -   Shutdown service.
            -   Else:
                -   lastMigrations.add(current_migration).
                -   return current_migration.

#### choose_candidate_host_for_migration(Unified Affinity Group - UAG)

*   hosts = create_map_of_hosts_and_vms()
*   Return hosts with max number of Vms on it(More Vms from the same UAG means less migrations needed to enforce the UAG).

=== create_map_of_hosts_and_vms() ===

*   map = {}
*   for AG in UAG:
    -   for VM in AG:
        -   host = null
        -   if vm in the middle of migration:
            -   [9]get host that vm is migrating to.
        -   Else if Vm’s host is available:
            -   get the host.
        -   if not host == null:
            -   if host is key in map:
                -   map[host]++
            -   else:
                -   map[host] = 1
*   return map.

#### Get unified affinity groups()

*   UAG = {{vm} for each vm}
*   For each (+) affinity group(Sorted by group id):
    -   unify VMs from the group in UAG(Sorted by vm id).
    -   For each (-) affinity group(Sorted by group id):
        -   [10]For each group in UAG(Sorted by first vm uuid):
            -   if size of the intersection of group from UAG and the negative group is > 1:
                -   throw exception “Affinity group contradiction detected” (With associated groups).

#### MigrationEntryDS.opposite_migration(entry)

*   [11]migration_entry_ds = MigrationEntryDS(entry.getCurrentVm, entry.getMigrationStatus().getVds())
*   migration_entry_ds.setTargetHost(entry.getSourceHost())

#### MigrationEntryDS constructor(vm, sourceHost)

*   this.vm = current_vm
*   this.sourceHost = sourceHost

#### MigrationEntryDS setMigrationReturnValue(returnValue)

*   this.migrationReturnValue = returnValue.

#### MigrationEntryDS getMigrationStatus()

*   if this.targetHost not null:
    -   return this.targetHost
*   else if this.migrationReturnValue not null:
    -   return this.migrationReturnValue.status
*   else:
    -   return null

### Footnotes

[1]Methods are written in the section “related methods”. [2] If no class is written(As for most methods/fields) assume it’s in the service itself. [3] Procedure here happens for every cluster separately. [4] if no vm is found for migration, In this situation we decide to make the service sleep for long interval because, affinity groups are enforced at that point. [5] The migration command will be done automatically to take into account other policies that might be in use. [6] It’s important to keep getting the same groups in the same order each time. That’s why we will use SortedSet. The order is kept because affinity group are not supposed to change during migrations and if an affinity group will change then it can be fixed by emptying the last migrations list(thus temporarily allowing opposite migration and preventing the service from shutting down unnecessarily). [7] candidate host is the host we think is going to be the host that the next vm should migrate to. But, we are using the scheduler’s automatic migration thus the scheduler may decide to migrate the vm somewhere else. [8] Vms in error state can’t migrate. [9] The migration might fail. But, because we don’t want to cause migration loop we prefer to assume that the migration will succeed when we decide which host should be the one that the vms will migrate to. [10] VMs that don’t belong to any positive affinity group(In the UAG - Unified Affinity group). Still has group of their own. So, in the next step that group still need to be on a separate host(It is still possible to put two positive affinity groups on the same host but we let the scheduler decide that for us). [11] This if statement checks that a migration in the opposite direction doesn’t occur(Replacing target host with source host in the last migration).

### Related Data Structures

#### MigrationEntryDS

*   UUID vm.
*   UUID sourceHost.
*   vdcReturnValue migrationReturnValue.
*   VDS targetHost

#### AffinityRulesEnforcementPerClusterService

*   List<MigrationEntryDS> lastMigrations.
*   Integer currentInterval, migrationTries.

#### AffinityRulesEnforcementService

*   SHORT_INTERVAL = 1.
*   LONG_INTERVAL = 15.
*   MAXIMUM_MIGRATION_TRIES = 5.
*   List<AffinityRulesEnforcemenetPerClusterService> perClusterService.

== Testing ==

*   Service creation when cluster is created:
    -   Service creation on startup.
        -   Start engine
        -   Check log to see that ARES was created for the default cluster.
    -   Service creation on new cluster.
        -   Create new cluster
        -   Check log to see that ARES was created for the new cluster.
    -   Service deletion of deleted cluster(pre-condition = test 1b):
        -   Delete cluster
        -   Check log to see that ARES was deleted for the deleted cluster.
*   Service interval check:
    -   Check regular interval:
        -   Create new cluster.
        -   Check log to see that ARES was created for cluster. (Make sure cluster has affinity rules).
        -   Add 2 VMs on the same host
        -   Add negative affinity rule for the 2 VMs.
        -   wait for “regular interval”
        -   check that ARES interval reached.
    -   Check long interval: (Preconditions = one datacenter is up, affinity rules enforced).
        -   Create new cluster.
        -   Check log to see that ARES was created for cluster. (Make sure cluster has no affinity rules).
        -   Wait for long interval
        -   Check logs to see that long interval reached.
*   Service Affinity Rules enforcement:
    -   Enforcement for positive affinity rule: (Precondition load balancer if off, All vms can run together on the same hypervisor)
        -   Start engine
        -   Add 2 hosts.
        -   For host A add 3 Vms
        -   For host B add 1 Vm
        -   Add positive affinity rule for all VMs.
        -   Wait for regular interval.
        -   See that the Vm from Host B migrated to host A.
    -   Enforcement for negative affinity rule: (Preconditions: load balancer if off, All vms can run together on the each hypervisor)
        -   Start engine
        -   Add 2 hosts.
        -   For host A add 2 Vms
        -   For host B no Vms should be running on it.
        -   Add negative affinity rule for the two VMs.
        -   Wait for regular interval.
        -   See that one Vm migrated from host A to host B.
    -   Enforcement for balanced hypervisors:(Precondition: All Vms should be able to run on the same hypervisor at once)
        -   Start engine
        -   Add 2 hosts
        -   For host A add 3 Vms
        -   For host B add 3 Vms
        -   Add positive affinity rule for all Vms.
        -   Wait for 6 regular intervals(6 \* regular interval)
        -   See that all Vms migrated from one of the hosts to the other one.
*   Affinity Rule contradictions check:
    -   Check two opposite conditions:
        -   Start engine
        -   Add 2 hosts
        -   Add 2 Vms
        -   Add positive affinity rule for both VMs.
        -   Add negative affinity rule for both VMs.
        -   Wait for regular interval.
        -   Check logs to see a new exception was thrown saying: “Affinity group contradiction detected” (With associated groups).
*   Balancer competing services:
    -   Check power saving and colliding affinity:
        -   Start engine
        -   Add 2 hosts
        -   Add 6 Vms(Each host should have 3 VMs).
        -   Add positive affinity rule for 3 VMs
        -   Put balancer on power saving.
        -   Wait for a 4 regular intervals(4 \* regular interval).
        -   Check in the logs that the service has been shutdown because of contradicting migrations.

### Benefit to oVirt

Affinity group will be better enforced when a service will be checking them periodically.

### Dependencies / Related Features

*   SchedulerUtilQuartzImpl - scheduleAFixedDelayJob, scheduleAOneTimeJob.
*   VmAffinityFilterPolicyUnit - getAcceptableHosts, filter.
*   MigrateVmCommand.
*   AddAffinityGroupCommand.
*   SchedulerUtilQuartzImpl.

### Intervals and values used in the system

*   Regular interval - 1 minute.
*   Long interval - 15 minutes.
*   Maximum migration tries - 5.

### Release Notes

This feature is a service that checks if any affinity rules are broken and migrates VMs in order to enforce them.
This service includes:

*   Triggers for creation of the service on Cluster Creation/Deletion.
*   Services wakes up on Affinity group Creation/Deletion/Update and engine startup.
*   Service Sleeps long interval when too many migration tries fail.
*   Service shutsdown when migration loop is detected or if the same migration happens more than once on the last 5 migrations.
*   Service avoid multiple migrations on the same cluster by sleeping when migration in progress(Using pending resource manager).
*   Service uses scheduler's automatic migration command to comply with filter and weight policies.
*   Service will sleep for 15 minutes instead of 5 if all affinity rules are enforced when interval is reached.
*   Service will automatically sort and create "Unified Affinity Rules" based on the defined affinity rules and will detect contradictions between rules.
*   Service will enforce affinity rules one by one in order to reduce the number of broken affinity rules as soon as possible.
*   Service will try to resolve a specific affinity rule break by migrating VMs from hosts with less VMs from a than affinity group to the one with the maximum VMs.

### Graphical representations

![](ARES_Life_Cycle.png "fig:ARES_Life_Cycle.png") ![](Affinity_Rule_Enforcement.png "fig:Affinity_Rule_Enforcement.png") ![](Migration_Loop_Detection.png "fig:Migration_Loop_Detection.png") ![](UAG_Algorithm.png "fig:UAG_Algorithm.png")

### Comments and Discussion

For more information see the following BugZilla link: <https://bugzilla.redhat.com/show_bug.cgi?id=1112332>

*   Refer to <Talk:Affinity_Group_Enforcement_Service>

[Affinity Group Enforcement Service](Category:Feature) [Affinity Group Enforcement Service](Category:oVirt 3.6 Proposed Feature) <Category:SLA>

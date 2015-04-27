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

A new service that will automatically enforce affinity rules. The service will query a list of VMs that break affinity rules, and will try to resolve the conflicts by migrating VMs. Each cluster will have a separate task in the service.

### Owner

<http://www.ovirt.org/User:Tsaban>

*   Name: [ Tomer Saban](User:Tsaban)

<!-- -->

*   Email: <tsaban@redhat.com>

### Detailed Description

#### Basic procedure

1. A new affinity group is created. 2. Affinity Group creation triggers a new job that gets all the conflicts(And associated VMs) which break affinity rules and add them to a list of conflicts. 3. The Affinity Rules Enforcement service will take the list of conflicts created in step 2 and try to resolve them by migrating the VMs associated with those conflicts.

#### Detailed procedures

##### Conflict identification process

Current migration process relies on the condition that only one migration occurs each time. It will not take into consideration the currently migrating Vms and that’s why we are using the following procedure.

Each time a new Affinity group is created it will add the Vms that break affinity rules to a list in groups. A service will be query the list of ConflictGroups in fixed intervals. Each time the service is called it will check the list for Vm groups. It will choose a group randomly and choose a vm out of it randomly(To avoid NP-Complete problem when choosing VM to migrate). Then, it will try to migrate the vm. After the vm has been migrated the affinity rule that belongs to the group has to be checked again to determine if it was resolved. (The VM is added to the ConflictGroup migratedVms Set(See below detailed structure of ConflictGroup). If the affinity rule break was solved or that all ConflictGroup vms list is empty(all of the vms were moved to ConflictGroup.migratedVms list), The ConflictGroup associated with that rule will be removed.

Affinity Group conflicts are an NP-Complete problem which is not possible to solve(In a reasonable time), That's why we will let the migration process decide where to migrate the VMs so it will take into considerations other factors like the weight and filter policies.

##### Conflict resolution process

The service will run each period of time(5 minute or so) and will work as follows: If ConflictGroup list is empty:

*   Exit

Else:

*   Choose a random ConflictGroup from the list and choose a random vm from the conflict group.
*   Add VM to the ConflictGroup.migratedVms Set.
*   If the affinity group is positive try to migrate the vm to one of the hypervisors that has at least 1 vm from the same affinity group. Else, if the affinity group is negative try to migrate the vm to one of the hypervisors the has no vms from the same affinity group. (Migration using the VmMigrateCommand).
*   If VMs set in the ConflictGroup is empty or that conflict was resolved, remove the ConflictGroup from the list.

<!-- -->

*   The automatic MigrateVmCommand is used because we want to take into consideration that other filters and weight policies exist and we don’t want to break them. Another thing is to reuse the scheduling policies logic.

### Benefit to oVirt

Affinity group will be better enforced when a service will be checking them periodically.

### Dependencies / Related Features

*   SchedulerUtilQuartzImpl - scheduleAFixedDelayJob, scheduleAOneTimeJob.
*   VmAffinityFilterPolicyUnit - getAcceptableHosts, filter.
*   MigrateVmCommand.
*   AddAffinityGroupCommand.
*   SchedulerUtilQuartzImpl.

### Testing

#### Sanity Test

BeforeTest: Create two hosts and two identical VMs. Make sure that the VMs can run on both hosts and no scheduling policy prevents it.

1. Run the Two VMs on one host. 2. Create a new anti-affinity policy and apply it to these VMs 3. Wait for 15 minutes.

Expected results: Engine should detect that a new policy has been applied and migrate one of the VMs off.

### Comments and Discussion

For more information see the following BugZilla link: <https://bugzilla.redhat.com/show_bug.cgi?id=1112332>

*   Refer to <Talk:Affinity_Group_Enforcement_Service>

[Affinity Group Enforcement Service](Category:Feature) [Affinity Group Enforcement Service](Category:oVirt 3.6 Proposed Feature)

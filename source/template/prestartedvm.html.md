---
title: PrestartedVm
category: template
authors: msalem, ovedo, tdosek
wiki_category: Template
wiki_title: Features/PrestartedVm
wiki_revision_count: 20
wiki_last_updated: 2012-04-17
wiki_warnings: list-item?
---

# Prestarted Vm

------------------------------------------------------------------------

### Summary

The Prestarted Vm feature allows holding a predefined number of unassigned ready to use Vms running in a pool.

### Owner

*   Feature owner: [ Muli Salem](User:msalem)

    * Backend Component owner: [ Muli Salem](User:msalem)

    * GUI Component owner: [ ?](User:?)

    * REST Component owner: [ Michael Pasternak](User:mpasternak)

    * QA Owner: [ ?](User:?)

*   Email: msalem@redhat.com

### Current status

*   Design stage
*   Last updated date: Tue Dec 20 2011:

### Detailed Description

1.  Today there are 2 types of Vm pools:
    1.  Manual - the Vm is supposed to be manually returned to the pool. In practice, this is not really entirely supported.
    2.  Automatic - once the user shuts down the Vm - it returns to the pool (stateless).

**The prestarted Vm feature will deal with Automatic Vm pools.**

In ovirt, a VmPool is created based on a specific template. A Vm in the pool can either be assigned to a specific user or be in shutdown state. This creates the situation that when an admin assigns a Vm to a user, he needs to run the Vm before the user can begin using it.

In addition, when dealing with Windows machines, after pool creation the admin is required to manually go through every machine and run once, in order for sysprep to be configured (takes approximately 15 minutes). After that he needs to shut down all the machines, so they will be available for use.

The prestarted Vm will allow a situation where at all times there are at least a minimal number of Vms that are running and not assigned to a specific user (unassigned). In case of Windows machines, we assume that the admin will make sure that the Vms will be after sysprep configuration when we begin running prestarted Vms.

### Benefit to ovirt

The prestarted Vms will allow instant assignment of a Vm from the pool to a user without the user needing to wait for the Vm to start.

### PRD

The requirements are the following:

1.  Enable a Vm in a pool to be both running and unassigned to a specific user.
2.  Maintain a minimal amount of prestarted Vms, that are running and waiting to be assigned.
    1.  The minimum number of prestarted Vms is configurable. This number can be changed after Vm pool was already created. In case it is changed, the system is not required to shutdown prestarted Vms, but rather this will be done manually by the admin if necessary.
    2.  The maximum number of prestarted Vms is the size of the VmPool.

3.  When a Vm is shut down its base snapshot is restored and it is returned to the pool (no change in behaviour here).
4.  Each VmPool is configured in the dialog box with a minimal amount of prestarted Vms (Default is 0).
5.  The prestarted Vms creation does not have to begin immediately upon pool creation, but rather can be happen periodically.

**Optional Further Stage**: Template deprecation - in case that the Vm pool is assigned a new template, rhevm will identify when there are no more Vms in the pool that are dependent on this template, and at that moment deprecate the old template.

### Design

Current flow:

1.  When running Vm from administrator - the RunVm command is called. The changes he makes actually stay on the Vm even after shutdown.
2.  When running Vm from user portal - AttachUserToVmFromPoolAndRunCommand executes, which runs the addPermission + CreateAllSnapshotsFromVm. On endSuccessfully the RunVm command runs. When Vm is shut down - VmPoolHandler.ProcessVmPoolOnStopVm(vmId) -> removePermission + RestoreAllSnapshots.

New Design:

1.  Adding a min_prestarted_vms field to each VmPool.
    1.  This field is configurable upon Vmpool creation by the admin.
    2.  It can be edited after the pool has been created. In case an admin lowers the minimum number, the "extra" Vms will not be shutdown. He will be supplied with the following message:

*The number of prestarted Vms will not be reduced automatically.*

<span style="color:Teal">**min_prestarted_vms**</span>:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Description |- |min_prestarted_vms ||Boolean ||not null / default true ||The minimum number of prestarted vms |- |}

1.  There are 2 possible approaches to maintaining the minimal amount of prestarted Vms:
    1.  1.  Periodic - creating a job that runs every x minutes. x is defined in vdc_options in a new row called VmPoolRefreshRate. A new property needs to be added to the engine-config.properties file. The default will be 2 minutes. The job will go over each pool, check whether there are enough prestarted Vms running. If not, it will start the needed amount.
        2.  This option can be optimized by triggering the job upon certain events. Events that should trigger: addVmPool, AttachUserToVmFromPoolCommand...?

<!-- -->

1.  1.  The second approach, is the event driven approach. The same logic can run upon events that triggers it. Events that should trigger: addVmPool, AttachUserToVmFromPoolCommand...?

**Algorithm for selecting a Vm for user**

------------------------------------------------------------------------

1.  A vm will be assigned to a user in the following priority:
    1.  1.  The Vm is up
        2.  is not running by the admin (Can be deduced from the images status?)
        3.  is not given to another user

    2.  Current assignment:
        1.  The Vm is down
        2.  is not given to a user

**Algorithm for maintaining number of prestarted Vms**

------------------------------------------------------------------------

1.  The Prestarted Vm Job counts the number of Vms that:
    1.  1.  Are running (\*) not by the admin
        2.  are not assigned to a user

    2.  If there are not enough of them, he looks for Vms that are:
        1.  down
        2.  not assigned to a user

Overall, we need three optional flows:

1.  A flow that leads to only "addpermission" (to give to a user that wants to be assigned a vm) - a change inside the flow of AttachUserToVmFromPoolCommand.execute
2.  A command that does CreateAllSnapshots + runVm (for the scheduler that is preparing prestarted vms) - a new flow.
3.  A command that does all three (in case we didn't find a prestarted vm to give to a user) --> (already exists)

### Open Issues

1.  -   We need to define what the scheduler counts to be as a prestarted vm (only up, maybe VM.isStatusQualifyToMigrate() which includes Up, PoweringUp, Paused, RebootInProgress)

2.  We need to decide whether we take the periodic approach (with or without optimization), or the event driven one.

### Dependencies / Related Features

Affected rhevm projects:

*   API
*   CLI
*   backend
*   Webadmin
*   User Portal

### Documentation / External references

### Comments and Discussion

------------------------------------------------------------------------

<Category:Template> <Category:Feature>

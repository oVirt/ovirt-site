---
title: PrestartedVm
category: feature
authors:
  - msalem
  - ovedo
  - tdosek
---

# Prestarted Vm

------------------------------------------------------------------------

## Summary

The Prestarted Vm feature allows holding a predefined number of unassigned ready to use Vms running in a pool.

## Owner

*   Feature owner: Muli Salem (msalem)

    * Backend Component owner: Muli Salem (msalem)

    * GUI Component owner: [ ?](User:?)

    * REST Component owner: Michael Pasternak (mpasternak)

    * QA Owner: Tomas Dosek (Tdosek)

*   Email: msalem@redhat.com

## Current status

*   Status: Engine-done, API-done, GUI-design, QA-test plans ready and reviewed
*   Last updated date: Tue Dec 27 2011:

## Detailed Description

1.  Today there are 2 types of Vm pools:
    1.  Manual - the Vm is supposed to be manually returned to the pool. In practice, this is not really entirely supported.
    2.  Automatic - once the user shuts down the Vm - it returns to the pool (stateless).

**The prestarted Vm feature will deal with Automatic Vm pools.**

In ovirt, a VmPool is created based on a specific template. A Vm in the pool can either be assigned to a specific user or be in shutdown state. Therefore, when an admin assigns a Vm to a user, the Vm needs to boot before the user can begin using it.

The prestarted Vm will maintain a number of Vms that are running and not assigned to a specific user (unassigned). This will be at a "best effort" basis, meaning there may be cases in which the number of prestarted Vms will be smaller than the amount defined by the admin.

## Benefit to ovirt

The prestarted Vms will allow instant assignment of a Vm from the pool to a user without the user needing to wait for the Vm to start.

## PRD

The requirements are the following:

1.  Enable a Vm in a pool to be both running and unassigned to a specific user.
2.  Maintain a minimal amount of prestarted Vms, that are running and waiting to be assigned.
    1.  The number of prestarted Vms is a new VMpool property. This number can be changed after Vm pool was already created. In case it is changed, the system is not required to shutdown prestarted Vms, but rather this will be done manually by the admin if necessary.
    2.  The maximum number of prestarted Vms is the size of the VmPool.

3.  When a Vm is shut down its base snapshot is restored and it is returned to the pool (no change in behaviour here).
4.  The prestarted Vms creation does not have to begin immediately upon pool creation, but rather can be happen periodically.

## Design

Current flow:

1.  When running Vm from administrator - the RunVm command is called. The changes he makes actually stay on the Vm even after shutdown.
2.  When running Vm from user portal - AttachUserToVmFromPoolAndRunCommand executes, which runs the addPermission + CreateAllSnapshotsFromVm. On endSuccessfully the RunVm command runs. When Vm is shut down - VmPoolHandler.ProcessVmPoolOnStopVm(vmId) -> removePermission + RestoreAllSnapshots.

New Design:

1.  Adding a prestarted_vms field to each VmPool.
    1.  This field is configurable upon Vmpool creation by the admin, and has a default value of 0;
    2.  It can be edited after the pool has been created. In case an admin lowers the minimum number, the "extra" Vms will not be shutdown. He will be supplied with the following message:

*The prestarted Vms will not be shut down automatically.*

<span style="color:Teal">**prestarted_vms**</span>:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Description |- |prestarted_vms || smallint ||not null / default 0 ||The minimum number of prestarted vms |- |}

*   We also need to add this column to vm_pools_view and vm_pools_full_view.

**VmPoolMonitor**
Maintaining the number of prestarted will be done periodically. The periodic approach was chosen since it avoids relying on the different stages in the VmPool's life cycle. There will be a job that runs every x minutes. x is defined in vdc_options in a new row called VmPoolRefreshRate. A new property needs to be added to the engine-config.properties file. The default will be 2 minutes. The job will go over each pool, check whether there are enough prestarted Vms running. If not, it will start the needed amount.

We will the following config values for this job: <span style="color:Teal">**prestarted_vms**</span>:
{|class="wikitable sortable" !border="1"| config key || config type ||Null? / Default ||Description |- |VmPoolMonitorBatchSize || smallint ||5||The maximum amount of vms that will be prestarted in a single run of the VmPoolMonitor |- |VmPoolMonitorIntervalInMinutes || smallint ||5||The size of interval between VmPoolMonitor runs |- |VmPoolMonitorMaxAttempts || smallint ||3||The number of attempts that are made to prestart a Vm |}

*   This option can be optimized by triggering the job upon certain events. Events that should trigger: addVmPool, AttachUserToVmFromPoolCommand...?

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

The implementation will be as follows:

1.  The AttachUserToVmFromPoolAndRunCommand and AttachUserToVmFromPoolCommand will be combined to one command named AllocateVmFromPoolCommand.
2.  A new command called PrepareVmForUse will be added. The command will run the CreateAllSnapshotsFromVmCommand, and upon ending successfully will run RunVm. The command will be used both by the command in the previous clause, and by the scheduler that prepares prestarted vms.
3.  We will add a flow that checks if there are available prestarted Vms. If so, do only "AddPermission". If no prestarted Vms were found, run AddPermission + PrepareVmForUse.

### REST API

A new integer property, "prestarted_vms", was added to the VmPool resource

## Affected Commands

1.  AttachUserToVmFromPoolCommandAndRun + AttachUserToVmFromPoolCommandAndRun - As explained above.
2.  AddVmPoolCommand - no change since the parameter held is of type vm_pools.
3.  UpdateVmPoolCommand - no change since the parameter held is of type vm_pools.
4.  RemoveVmPoolCommand - no change since the parameter held is of type vm_pools.

## Open Issues

1.  -   We need to define what the scheduler counts to be as a prestarted vm (only up, maybe VM.isStatusQualifyToMigrate() which includes Up, PoweringUp, Paused, RebootInProgress)

2.  We need to decide whether we take the periodic approach (with or without optimization), or the event driven one.

## Dependencies / Related Features

Affected rhevm projects:

*   API
*   CLI
*   backend
*   Webadmin
*   User Portal

## Documentation / External references


------------------------------------------------------------------------


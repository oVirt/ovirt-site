---
title: ReloadableConfiguration
category: template
authors: lpeer, msalem
wiki_category: Template
wiki_title: Features/ReloadableConfiguration
wiki_revision_count: 37
wiki_last_updated: 2012-06-28
wiki_warnings: list-item?
---

# Reloadable Configuration

------------------------------------------------------------------------

### Summary

The Reloadable Configuration feature will allow the admin to change core configurations through the engine-config tool without restarting the machine.

### Owner

*   Feature owner: [ Muli Salem](User:msalem)

    * Backend Component owner: [ Muli Salem](User:msalem)

    * QA Owner: [ ?](User:?)

*   Email: msalem@redhat.com

### Current status

*   Status: Design

### Detailed Description

Caching of the config values of the vdc_options table, is currently done once, in the initialization of the Backend class. Therefore, if a config value is changed, the machine needs to be restarted for the change to take place.

The Reloadable Configuration feature will allow updating **some** of the values, without restarting the machine.

### PRD

The requirements are the following:

1.  Enable the updating of configurations in vdc_options, while the machine is up.
2.  This should be enabled for keys that can be changed in runtime without harming the system, and keys that can actua
3.  The update does not have to take place immediately upon configuration change, but rather can happen periodically.

### Design

Today the config values from vdc_options are cached in a map of type DBConfigUtils, that is held in the Config class. Caching of the config values of the table, are done only in the initialization of the Backend class.

New Design:

1.  Creating a periodic job that refreshes the cached map, once a minute.
2.  Adding a reloadable column in vdc_options. This field will distinguish between keys that can be reloaded in runtime, and keys that should only change when the machine is restarted.

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

### Affected Commands

1.  AttachUserToVmFromPoolCommandAndRun + AttachUserToVmFromPoolCommandAndRun - As explained above.
2.  AddVmPoolCommand - no change since the parameter held is of type vm_pools.
3.  UpdateVmPoolCommand - no change since the parameter held is of type vm_pools.
4.  RemoveVmPoolCommand - no change since the parameter held is of type vm_pools.

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

---
title: oVirtSchedulerAPI
category: api
authors: doron, gchaplik, lhornyak, nslomian
wiki_category: Feature
wiki_title: Features/oVirtSchedulerAPI
wiki_revision_count: 57
wiki_last_updated: 2014-06-30
---

# o Virt Scheduler API

## [WIP] SLA Pluggable Architecture

### Summary

This feature will model all the scheduling into a single API, that oVirt admins can alter and enhance default scheduling behavior.

### Owner

*   Feature owners: [ Gilad Chaplik](User:gchaplik), [ Doron Fediuck](User:dfediuck), [ Laszlo Hornyak](User:lhornyak)

### Current status

*   Target Release: 3.2
*   Status: Design Phase
*   Last updated date: Mon Oct 22 2012

### Detailed Description

Currently scheduling mechanism is handled by oVirt engine internals. To allow users to enhance scheduling mechanism, we need to provide a way for a user to replace or add a self-written scheduler - or 'SLA Pluggable Architecture'. This feature is meant to model current scheduling methods into a single API (place), which will become the 'Default oVirt Scheduling Mechanism'. The Pluggable Architecture has to be flexible enough to foresee future API changes or at least keep them minimal, in order for API to be backward compatible and stable.

#### Existing Scheduling Mechanisms

Currently, we can divide oVirt scheduling into two flows, direct and indirect. These flows depend on the VM, host and cluster (oVirt scheduling parameters: HA, selection algo, failure policy, etc.). The direct flows are 'Run Vm' and 'Migrate Vm' commands (select host to run on) & Load Balancing task, the indirect flows are Maintanance VDS, SetNonOperationalVdsCommand, etc., which may cause migration (with host selection obviously). Additionally oVirt scheduling parameters (which will be explained next) are specific for existing scheduler. oVirt

##### VM migration policy - migration support (VM HA)

*   migratable, implicitly non migratable (autoStartup)
    -   References:
        -   RunVmCommandBase.canRunVm(Check if iso and floppy path exists ??),
        -   VmRunHandler.performImageChecksForRunningVm(Check isValid, storageDomain and diskSpace only if VM is not HA VM)
    -   commands:
        -   FenceVdsManualyCommand,
        -   ClearNonResponsiveVdsVmsCommand,
        -   MaintananceVdsCommand,
        -   RunVmCommandBase (starts spice)

<!-- -->

*   pin to host (dedicated_vm_for_vds)
    -   References:
        -   selection
        -   load balancing
    -   commands:
        -   ChangeVMClusterCommand (clear pinned host),
        -   RunVmCommand (selection)

<!-- -->

*   priority (priority, VmsComparer)
    -   References:
        -   VmsComparer
    -   Commands:
        -   MaintananceVds (+ numberOf),
        -   MigrateVM (order commands),
        -   LoadBalance (isMigratable),
        -   VdsSelector (pinned to host)

##### Cluster's Host selection policy (selection algorithm)

*   None
*   EvenlyDistribute
*   PowerSave

<!-- -->

*   References:
    -   LoadBalancer
    -   VdsGroupOperationCommandBase.validateMetrics (validating high/low utilization, adding/updating vdsGroup)
    -   VdsSelector

##### Cluster migration policy - resilience policy

MigrateOnErrorOptions: yes, no, HA only References: SetNonOperationalVdsCommand

##### Load Balancer

VdsLoadBalancer (Scheduled task)

#### Scheduler API

In order to really replace (enhance) the scheduler, we need to move all the code and parameters into the API; I know that this is a utopia (to do it all at once), so we'll do it in steps; first replace the 'direct' scheduler (see above), and then we are inspiring to box out also the indirect scheduler, scheduler validations and oVirt scheduler parameters for cluster, host and VM.

The new API is a single interface which extends 5 other interfaces:

*   HostSelector

chooses a host to run on according to selection algorithm. getSelectedHosts(): returns a list containing the last selected hosts. hasAnyHosts(): is called in the validation while running a VM, and returns whether there are hosts to choose from. selectHost(): is called in the execution while running a VM, and returns a host that the implemented algorithm chooses (note: should have shared code with hasAnyHosts).

*   LoadBalancer

Invoked for each cluster every interval and perform load balancing according to a load balancing algorithm. loadBalance() invoked every configValue.VdsLoadBalancingeIntervalInMinutes minutes.

*   TimerInvokedScheduler

Very much similar to the loadBalancer, but has a general purpose and can have a different timer span. onTimerInvoked(): invoked every configValue.SchedulerTimerIntervalInMinutes minutes.

*   VmStatusChanged

implements behavior for VM status transitions for SLA context.

*   HostStatusChanged

implements behavior for Host status transitions for SLA context.

##### Class Diagram

![](schedulerApi.png "schedulerApi.png")

scheduler API implements 5 other interfaces.

Methods' Parameters:

*   Scheduler defaultScheduler (each method in the api can address the default api)
*   HostObject (host entity in relevant methods, currently only in host state changed)
*   VmObject
*   HostStatus (old, new)
*   VmStatus (old, new)
*   Rest API entry point (see next paragraph)
*   Inputs (including separate input for policy?)
*   scheduling log

##### Implementing API with default oVirt scheduler

We should first move the current scheduling logic into a new class implementing the new API, the question here is what to export and what to leave behind (still in beckend internals), e.g., scheduling parameters should be boxed out? migration in maintenance? And so on; my beliefs are that everything should be boxed out, but this can be done in several phases:

phases:

1.  Alter cluster scheduling parameters to be customized (without touching current parameters).
2.  Move select host logic into new API (including canDoAction of selectHost).
3.  Create scheduled tasks (tasks invoked by timer)- LoadBalacer & timer invoked method.
4.  Build a state machine for VM and Host statuses.
5.  Move migration logic according to VM and Host status changes.
6.  Allow having configurable and customized parameters for Vms, Hosts & clusters, and moving the current fields (HA, selection algo, etc) into a dynamic field that is controlled by the scheduler.

##### Backend Entry Point (REST-API)

WIP, currently we are talking about having an entry point given by in the method signature, this object is auto-generated REST-API jar that represents the various entities, commands and queries that can be done via the REST-API.

##### Authentication

Currently the programmer is responsible for authentication; we will try to give some examples on ways to fetch authentication data (like having a text file next to the plugin class contains the user and password).

##### Scheduler Details

We should add scheduler metadata that identify the scheduler better, and this parameters are optional. for instance:

        * id
        * version / md5sum (we calculate)
        * name
        * available policies.
        * default input (& validations)
        * hide

the default input and validations is quite interesting: probably the ui-plugin will be implemented later-on and we would like to get some user input from the user in a dynamic way, so we will use something like custom properties sheet, for custom parameters (and we need there reg-ex for identifying the structure).

#### Default API Implementation

Example: 'MaintananceVds' flow related to scheduling

old implementation -> new implementation

*   MaintananceVds.canDoAction : can migrate running hosts -> scheduler.canChangeStatus(\*, prepareToMaintanance)
*   MaintananceVds.execute : migrateAllVms() -> scheduler.hostStatusChanged(\*, prepareToMaintanance)

#### Association to Cluster, Host & VM

#### Class Loading

##### Standard

Pluin jar files need to have a section in their Manifest file:

      Name: OVirt
      Plugin-Class: com.example.ovirt.plugin.MyCoolScheduler
      Plugin-Version: 3.2

Plugin-Version: the OVirt version for which this plugin was written. Versions newer than the one currently running may be ignored (warning) Plugin-Class: the name of the plugin class to deploy

##### OSGI

We can build on an existing OSGI container to enable plugins, this would allow us to use all of the features of OSGI (dynamic loading, service discovery, dependencies, etc)

Solutions:

*   use the JBoss' OSGI runtime - simple, supported, but may bring future portablity problems
*   use an embeddable OSGI runtime (like what jira, eclipse and many other products do)

##### Sandbox

The plugin framework needs to isolate plugins from the ovirt system so that they can invoke methods only through the plugin API. A typical misuse would be directly using singletons like *DbFacade*.

Isolation:

*   must be loaded from the plugin directory (plugin classloader)
*   Plugin classloader should only lookup classes and resources of the plugin API from the parent classloader.
*   Should be invoked i a separate thread?

Q:

*   Dependencies of the plugin (e.g. drools, httpclient, funkyframework) should be
    -   packaged into the jar as an uberjar/onejar? (would hurt both linux packaging policies and java traditions)
    -   placed into the plugin directory with the plugin jar? (would be a problem with linux packaging policies)
    -   used from the jar files of the system (a jar hell)

#### Authentication

##### UI

##### User Input & Validation

similar to custom properties sheet.

##### Pluggable UI

currently not ready.

### Tests

acceptance test for scheduler.

<Category:Feature> <Category:SLA>

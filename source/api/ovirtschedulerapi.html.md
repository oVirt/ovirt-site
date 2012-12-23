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

<Category:Feature> <Category:SLA>

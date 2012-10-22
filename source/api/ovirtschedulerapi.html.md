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

This feature will model all the scheduling into a single api, that ovirt admins can alter and enhance default scheduling behavior.

### Owner

*   Feature owners: [ Gilad Chaplik](User:gchaplik), [ Doron Fediuck](User:dfediuck), [ Laszlo Hornyak](User:lhornyak)

### Current status

*   Target Release: 3.2
*   Status: Design Phase
*   Last updated date: Mon Oct 22 2012

### Detailed Description

#### Existing Scheduling Mechanisms

*   VM migration policy - migration support

         migratable, implicitly non migratable, pinned to host; priority

References:

         - MaintananceVds (+ numberOf)
         - MigrateVM
         - loadBalance (isMigratable)
         - VdsSelector (pinned to host)

*   Cluster's Host selection policy (selection algorithm)

         None, EvenlyDistribute, PowerSave.

References:

         - loadBalancer
         - VdsGroupOperationCommandBase.validateMetrics ????
         - selection algo in VDS - ?????? (no need)

*   Cluster migration policy - resilience policy

         yes, no, only HA

References:

*   Load Balancer

References:

*   HA (auto-start)

References:

#### Scheduler API

##### Class Diagram

##### Backend Entry Point (REST-API)

##### Scheduler Details

        * id
        * version / md5sum (we calculate)
        * name
        * available policies.
        * input (& validations)

#### Default Implementation

#### Association to Cluster

##### UI

===== User Input & Validation ====

##### Pluggable UI

#### Class Loading

##### Standard

##### OSGI

##### Sandbox

#### Authentication

### Tests

<Category:Feature> <Category:SLA>

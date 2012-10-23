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

### Tests

##### UI

===== User Input & Validation ====

##### Pluggable UI

<Category:Feature> <Category:SLA>

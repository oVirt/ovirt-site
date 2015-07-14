---
title: VmPinningToMultipleHosts
category: feature
authors: maroshi
wiki_category: Feature
wiki_title: Feature/VmPinningToMultipleHosts
wiki_revision_count: 2
wiki_last_updated: 2015-06-08
feature_name: VM pinning to multiple hosts
feature_modules: engine,database,rest
feature_status: Development
---

# Vm Pinning To Multiple Hosts

## VM pinning to multiple hosts

### Summary

In oVirt 3.5 it is possible to pin a vm to a specific host. The pinning functionality provides the following benefits:

1.  Controlled physical hardware configuration for vm (e.g NUMA, CPU, NICs…).
2.  Prevent vm migration, satisfying administrative constraints. Such as: licensing, physical proximity, optimize CPU utilization, network optimization...

oVirt users, favor host pinning feature. And wish to extend the single host pinning, to multiple hosts pinning. See this [RFE](https://bugzilla.redhat.com/1107512).

### Owner

*   Name: Dudi Maroshi

<!-- -->

*   Email: <maroshi-at-redhat.com>

### General Description

#### Functional requirements

We name hosts group within a cluster, hosts bundle, or just bundle. The hosts bundle introduction, provides a fine grained migration domain internal to a specific cluster. Limiting specified vm migration (one or more vms) to the hosts bundle.

<big>Following the rational in the general description above:</big>

1.  User may define many bounding bundles, and assign multiple hosts (in same cluster) to bounding bundle.
2.  Hosts can be member in more than one bounding bundle.
3.  User defining a preferred starting host need to chose from the following:
    1.  All hosts in cluster
        1.  Preferred hosts (one or more) in the cluster (all hosts in cluster selection list)

    2.  A bounding bundle in the cluster
        1.  Preferred hosts (one or more) in the bounding bundle (shorter selection list)

<!-- -->

1.  The migration policy will bound the VM to the selected bounding bundle.
2.  For backward compatibility, user may pin a single host in the bounding bundle.
3.  Running VM should display its bounding hosts list. The bounding group name if exist or list of bounding host for ad-hoc group.

<big>Planned Functionality levels:</big>

1.  Provide vm pinning to multiple host functionality with REST-api
2.  Provide vm pinning to multiple host functionality with GUI
3.  Provide management of bounding bundles, and vm bounding to bundle with REST-api
4.  Provide management of bounding bundles, and vm bounding to bundle with GUI

### Detailed Description

Functionality level 1. Requires extensive refactoring to in data access layer and business logic. Due to large dependency tree.

#### Architecture flows

<big>Functionality level 1</big>

Refactor the current prefered host, from single host to list of hosts. This will requires change at database level. Change to scheduling, change to all VM types and their management commands. Refactor REST-api structure and mapping to handle preferring multiple hosts.

#### Detailed design

<big>Functionality level 1</big>

1.  Refactor database schema (tables, constraints, view)
2.  Refactor stored procedures to manage hosts removal consistency with VMs
3.  Refactor all VM entities to accepts list of prefered hosts
4.  Refactor data access layer to transform hosts bundle presentation from CSV text to list
5.  Refactor all references of prefered single host, to use list. Requires some logic redesign for managing: NUMA, OVF, host devices.
6.  Refactor REST-api schema and mapper. With consistency verifications.

### Benefit to oVirt

The business argument for multiple hosts pinning is the following:

1.  oVirt admin wants to provide high availability for vms running on hosts group. When hosts group share similar physical hardware configuration.
2.  oVirt admin wants to provide high availability for host with pinned vm.
3.  Prevent vm migration outside of the hosts group (see benefit 2 in previous paragraph).

### Dependencies / Related Features

Depends on the following oVirt-engine subsystems: Database, entities, bll, GUI, REST-api

1.  vm_static table and related views. Data access stored procedures.
2.  All business logic commands referencing preferred host. (16 commands)
3.  Scheduling manager and validators.
4.  Business entities dependant on preferred host. (vm, template, numa, host_device)

Currently the implementation of NUMA pinning and Host Devices requires **single** host pinning. The command verification method (canDoAction) in each respective command is refactored, and a descriptive error message is provided to prevent multiple host pinning on NUMA or host device.

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

### Comments and Discussion

<Category:Feature> <Category:Template>

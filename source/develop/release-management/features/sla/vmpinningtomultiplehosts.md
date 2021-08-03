---
title: VmPinningToMultipleHosts
category: feature
authors: maroshi
---

# VM Pinning To Multiple Hosts

### Summary

In oVirt 3.5 it is possible to pin a VM to a specific host. The pinning functionality provides the following benefits:

1.  Controlled physical hardware configuration for VM (e.g NUMA, CPU, NICs…).
2.  Prevent VM migration, satisfying administrative constraints. Such as: licensing, physical proximity, optimize CPU utilization, network optimization...

oVirt users favor host pinning feature and wish to extend the single host pinning to multiple hosts pinning.
See this [RFE](https://bugzilla.redhat.com/show_bug.cgi?id=1107512).

### Owner

*   Name: Dudi Maroshi


*   Email: maroshi@redhat.com

### General Description

#### Functional requirements

We name hosts group within a cluster, hosts bundle, or just bundle. The hosts bundle introduction, provides a fine grained migration domain internal to a specific cluster. Limiting specified VM migration (one or more VMs) to the hosts bundle.

**Following the rational in the general description above:**

1.  User may define many bounding bundles, and assign multiple hosts (in same cluster) to bounding bundle.
2.  Hosts can be member in more than one bounding bundle.
3.  User defining a preferred starting host need to chose from the following:
    1.  All hosts in cluster
        1.  Preferred hosts (one or more) in the cluster (all hosts in cluster selection list)

    2.  A bounding bundle in the cluster
        1.  Preferred hosts (one or more) in the bounding bundle (shorter selection list)



1.  The migration policy will bound the VM to the selected bounding bundle.
2.  For backward compatibility, user may pin a single host in the bounding bundle.
3.  Running VM should display its bounding hosts list. The bounding group name if exist or list of bounding host for ad-hoc group.

**Planned Functionality levels:**

1.  Provide VM pinning to multiple host functionality with REST-api
2.  Provide VM pinning to multiple host functionality with GUI
3.  Provide management of bounding bundles, and VM bounding to bundle with REST-api
4.  Provide management of bounding bundles, and VM bounding to bundle with GUI

### Detailed Description

**Functionality level 1**

Requires extensive refactoring in the data access layer and business logic due to large dependency tree.

#### Architecture flows

**Functionality level 1**

Refactor the current preferred host, from single host to list of hosts. This will require change at database level, change to scheduling, change to all VM types and their management commands. Refactor REST-api structure and mapping to handle preferring multiple hosts.

#### Detailed design

**Functionality level 1**

1.  Refactor database schema (tables, constraints, view)
2.  Refactor stored procedures to manage hosts removal consistency with VMs
3.  Refactor all VM entities to accepts list of preferred hosts
4.  Refactor data access layer to transform hosts bundle presentation from CSV text to list
5.  Refactor all references of preferred single host, to use list. Requires some logic redesign for managing: NUMA, OVF, host devices.
6.  Refactor REST-api schema and mapper. With consistency verifications.


**Accepted XML elements for REST-api in VM element.**

**Single host pinning by id**

```xml
<placement_policy>
    <host id="bbf42054-2e5b-4f3c-8c19-e3428f5fd5c9"/>
    <affinity>pinned</affinity>
</placement_policy>
```

**Single host pinning by name**

```xml
<placement_policy>
    <host><name>"host-1"</name></host>
    <affinity>pinned</affinity>
</placement_policy>
```

**Multiple host pinning by id**

```xml
<placement_policy>
    <hosts>
        <host id="bbf42054-2e5b-4f3c-8c19-e3428f5fd5c9"/>
        <host id="bbf42054-2e5b-4f3c-8c19-e3428f5fd5ca"/>
    </hosts>
<affinity>pinned</affinity>
</placement_policy>
```

**Multiple host pinning by name**

```xml
<placement_policy>
    <hosts>
        <host><name>"host-1"</name></host>
        <host><name>"host-2"</name></host>
    </hosts>
    <affinity>pinned</affinity>
</placement_policy>
```

### Benefit to oVirt

The business argument for multiple hosts pinning is the following:

1.  oVirt admin wants to provide high availability for VMs running on hosts group. When hosts group share similar physical hardware configuration.
2.  oVirt admin wants to provide high availability for host with pinned VM.
3.  Prevent VM migration outside of the hosts group (see benefit 2 in previous paragraph).

### Dependencies / Related Features

Depends on the following oVirt-engine subsystems: Database, entities, bll, GUI, REST-api

1.  vm_static table and related views. Data access stored procedures.
2.  All business logic commands referencing preferred host. (16 commands)
3.  Scheduling manager and validators.
4.  Business entities dependant on preferred host. (VM, template, numa, host_device)

Currently the implementation of NUMA pinning and Host Devices requires **single** host pinning. The command verification method (canDoAction) in each respective command is refactored, and a descriptive error message is provided to prevent multiple host pinning on NUMA or host device.



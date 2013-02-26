---
title: Self Hosted Engine
category: feature
authors: didi, dneary, doron, dyasny, fabiand, gpadgett, jmoskovc, lveyde, mgoldboi,
  mlipchuk, msivak, sandrobonazzola, scohen
wiki_category: Feature|Self Hosted Engine
wiki_title: Features/Self Hosted Engine
wiki_revision_count: 48
wiki_last_updated: 2015-01-16
---

# Self Hosted Engine

### Summary

The ability to run the Engine as a VM in a Datacentre that is managed by this Engine.

### Owner

*   Dan Yasny: [ Dyasny](User:Dyasny)

<!-- -->

*   Email: <dyasny@redhat.com>

### Current status

*   Still being discussed
*   Last updated: ,

### Detailed Description

This feature will deal with two main issues:

*   The deployment of an Engine as a VM into a fresh setup.
*   HA for the Engine VM needs to be managed by the hosts and not the Engine.

### Benefit to oVirt

*   This will allow us to deploy less hardware (with the Engine not requiring a separate machine)
*   We will be capable of providing HA for the Engine out of the box, instead of using a separate cluster in order to make the Engine HA.
*   The Engine services will be managed as a regular VM in terms of load balancing, placing the Engine VM where resources are best suited to run it.
*   This operational mode will attract users already familiar with it from other virt platforms.

# **Requirements**

*   New installation should be simple and guided.
*   A user will start with a single hypervisor host (full host OS or ovirt-node), that can access shared storage, and after the setup, will be able to access the Engine webadmin UI in order to add mode hosts, clusters, SDs etc.
*   The engine should be able to start on any of the hosts it manages, provided the host can access the Engine's virtual disk's location.
*   The engine should be highly available, and be able to tolerate host, network and storage failures.
*   An ability to define priorities for hosting the engine is required.
*   The host currently running the engine should report additional resources used, just like we reserve an extra CPU for the SPM, and compensate for that.

### Deployment

*   Initial setup will involve creating the Engine VM (libvirt based), then, the Engine VM should be started, configured and updated.
*   When the process is finished, the user should be able to login to the Engine, and start defining DCs and adding hosts, including the host the engine is already running on.

### Operational Routine

During normal ops:

*   Monitor the state of the Engine VM and restart the VM on other hosts in case of failure
*   Monitor the Engine status in the VM and restart the VM (or just the engine service) if it fails
*   Monitor the status of the host that is currently running the Engine VM, live migrate the engine in case of host health degradation

Issues to address specifically:

*   Engine VM Host losing only the management network
*   All the management network is down for all hosts
*   Hypervisor crash
*   Engine VM crashing
*   Engine service unavailable
*   Engine VM storage down
*   A situation when the host where the Egnine is running is in a problematic state, while the Engine VM is still up should also trigger a failover, or live migration.

#### Additional functionality required at host level

*   Heartbeat the Engine VM
*   Heartbeat the Engine service health
*   Heartbeat the current Engine VM host
*   Host self monitoring (HB to the Engine, designated network entities, Storage)
*   Inter-host selection for the next host to pick up the Engine VM
*   Host failure counter, that will have effect on the host selection heuristics
*   Host capabilities (minimal CPU/RAM available) will have effect on the host selection heuristics
*   Host priority in Engine election

#### Additional functionality required at the Engine level

*   If Engine fails, all the vm/host/cluster/storage statuses should be locked, when the Engine is up again, the states should be reassessed by querying the hosts, Engine will take these as given, and continue managing the entities with the initial status taken from the hosts.
*   If a conflicting situation is reported (same VM running on two hosts, or there are two hosts reporting they are SPM) Engine should be able to resolve.

#### General

*   Ability to tolerate an SD loss: have a mirrored copy of the Engine VM disk on another SD
*   Ability to tolerate a cluster loss: if all the hosts in the cluster are not available, a host from another cluster should be able to start the Engine VM

# Comments and Discussion

*   Refer to [Talk:Self Hosted Engine](Talk:Self Hosted Engine)

<Category:Feature>

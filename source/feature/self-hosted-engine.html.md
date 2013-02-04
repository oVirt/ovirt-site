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

*   The deployment of an Engine as a VM into a fresh setup. This presents an issue, since the traditional flow means we first deploy an Engine, then attach a host, and only then attach a Storage Domain, so we can start creating VMs. In this case, we want to create the SD and register a host without an Engine in place, and then have the Engine pick up the details of the existing SD and first host
*   HA for the Engine VM needs to be managed by the hosts and not the Engine, like HA is managed for the other VMs.

### Benefit to oVirt

This will allow us to deploy less hardware (with the Engine not requiring a separate machine) while providing HA for the Engine out of the box, instead of using a separate cluster in order to make the Engine HA.

### Dependencies / Related Features

*   TBD

# Requirements

### Pre created Engine Image

1. An OS image with installed but not set up Engine (ready for the engine-setup stage)

2. The engine-setup stage should pick up the data passed at first install into the database, so when the engine service is up, it is already working with the existing SD and should recognize itself as a VM in this setup.

### First deployment

Initial setup means defining a host, cluster and SD, deploying the Engine into this host, registering the host and adding the SD to the Engine. Then, the Engine VM should be started, configured and updated. When the process is finished, the user should be able to login to the Engine, and be able to see a defined DC+SD and Cluster with one host and one VM (the Engine itself). The first and only host will also be the current SPM.

1. Create a Storage Domain from a Fedora (RHEL)/ovirt-node (RHEV-H) host

2. Define the first cluster according to the capabilities of the first hypervisor, and place the Engien VM in this cluster

3. Deploy a prepared Engine VM image into the new SD and start it

4. Pass the details of the new host, cluster and new SD to the Engine VM, so that is can pick this data up at the engine-setup stage

### Operational Routine

1. Monitor the state of the Engine VM and restart the VM on other hosts in case of failure

2. Monitor the Engine status in the VM and restart the VM (or just the engine service) if it fails

3. Monitor the status of the host that is currently running the Engine VM

#### What to Monitor

*   Engine VM Host losing only the management network
*   All the management network is down for all hosts
*   Hypervisor crash
*   Engine VM crashing
*   Engine service unavailable
*   SD where the Engine VM is hosted is down
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

*   If Engine fails, all the vm/host/cluster/storage statuses should be locked, when the Engine is up again, the states should be reported, Engine will take these as given, and continue managing the entities with the initial status taken from the hosts.
*   If a conflicting situation is reported (same VM running on two hosts, or there are two hosts reporting they are SPM) Engine should be able to resolve.

#### General

*   Ability to tolerate an SD loss: have a mirrored copy of the Engine VM disk on another SD
*   Ability to tolerate a cluster loss: if all the hosts in the cluster are not available, a host from another cluster should be able to start the Engine VM

# Comments and Discussion

*   Refer to [Talk:Self Hosted Engine](Talk:Self Hosted Engine)

<Category:Feature>

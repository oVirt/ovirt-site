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

The ability to run the Engine as a VM on the hosts that are managed by this Engine, in an HA configuration, when the Engine VM can start on any of the hosts.

### Owner

*   Dan Yasny: [ Dyasny](User:Dyasny)

<!-- -->

*   Email: <dyasny@redhat.com>

### Current status

*   Initial POC devel
*   Last updated: ,

### Detailed Description

This feature will deal with two main issues:

*   The deployment of an Engine as a VM into a fresh setup.
*   HA for the Engine VM needs to be managed by the hosts and not the Engine.

### Benefit to oVirt

*   This will allow us to deploy less hardware (with the Engine not requiring a separate machine)
*   We will be capable of providing HA for the Engine out of the box, instead of using a separate cluster in order to make the Engine HA.
*   This operational mode will attract users already familiar with it from other virt platforms.

# **Requirements**

*   New installation should be simple and guided.
*   A user will start with a single hypervisor host (full host OS or ovirt-node), that can access shared storage, and after the setup, will be able to access the Engine webadmin UI in order to add mode hosts, clusters, SDs etc.
*   The engine should be able to start on any of the hosts it manages, provided the hosts have the hosted engine addons installed.
*   The engine should be highly available, and be able to tolerate host, network and storage failures.
*   An ability to define priorities for hosting the engine is a "nice to have".
*   The host currently running the engine should report additional resources used, just like we reserve an extra CPU for the SPM, and compensate for that.
*   Some resources (especially RAM) should be reserved on one or two nodes in the cluster, in case the engine VM has to migrate over
*   ovirt-node should have a TUI for the initial deployment and configuration of the Engine VM

### Deployment

*   Initial setup will involve creating the Engine VM (libvirt based), then, the Engine VM should be started, configured and updated.
*   After the setup the user will be able to access the Engine webadmin UI in order to add more hosts, clusters, SDs etc in the regular flow.

**Assumptions and requirements:**

*   NFS or GlusterFS share is provided by the administrator for the engine vm hosting
*   There is only one host (full OS or ovirt-node) at this stage. The first host is installed by the administrator.

**Engine vm setup:** The admin will run a setup script which will collect the following information:

*   NFS mount details
*   ip addresses for network health checks
*   engine vm setup details (install source, ip etc)

After collecting and verifying the information the script will run the engine vm setup. Admin will go through with the os installation of the engine vm, network settings, registration, updates and engine setup. After the engine is operational, the admin will shut the engine vm down. Once the engine vm is down, the setup script will edit the new domxml with sanlock definitions and move the xml to the nfs share and start the engine vm.

At this point we should be able to open the webadmin, add the first host and start defining hosts, clusters, storage etc.

### Operational Routine

**Phase 2: engine vm high availability daemon**

*   Daemon setup: The HA daemon is deployed as an rpm package (preinstalled on ovirt-node).
*   The daemon maintains two conf files: one is local and contains the NFS mount details, the other is on the NFS mount and it contains the network health check IPs and the engine vm ip (additional configs go here).
*   The daemon starts on all the configured hosts, and there it will start maintaining the engine VM. The Detailed Feature page will have a flow chart of how exactly the daemon operates

HA daemon requirements during normal ops:

*   Monitor the state of the Engine VM and restart the VM on other hosts in case of failure
*   Monitor the Engine status in the VM and restart the VM (or just the engine service - probably in the future versions) if it fails
*   Monitor the status of the host that is currently running the Engine VM, live migrate the engine in case of host health degradation (network/storage loss)

Issues to address specifically:

*   Engine VM Host losing only the management network - move the engine to another host
*   All the management network is down for all hosts - do nothing, no point taking the engine down if it can't operate anywhere
*   Hypervisor crash - restart the engine on another host
*   Engine VM crashing - restart locally, if fails - on another host
*   Engine service unavailable - restart VM after a timeout, if that fails - alert
*   Engine VM storage down - restart the engine on another host
*   A situation when the host where the Egnine is running is in a problematic state, while the Engine VM is still up should also trigger a failover, or live migration.
*   Avoid race conditions in case of a multiple host start - e.g. many hosts not detecting the engine VM and trying to start it
*   SBA for the engine VM should be provided (is sanlock enough?)

#### Additional functionality required at host level

*   Heartbeat the Engine VM status
*   Heartbeat the Engine service health
*   Heartbeat the current Engine VM host
*   Host self monitoring (HB to the Engine, designated network entities)
*   Inter-host selection for the next host to pick up the Engine VM, with host priorities in place
*   Host failure counter, that will have effect on the host selection heuristics
*   (optional) Host capabilities (minimal CPU/RAM available) will have effect on the host selection heuristics

#### Nice to have

*   Ability to tolerate a file share loss: have a mirrored copy of the Engine VM disk on another share

# Comments and Discussion

*   Refer to [Talk:Self Hosted Engine](Talk:Self Hosted Engine)

<Category:Feature>

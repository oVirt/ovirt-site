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

*   Featue Owner: Sean Cohen: [ scohen](User:scohen)

<!-- -->

*   Email: <scohen@redhat.com>

<!-- -->

*   Engine Component owner: Moran Goldboim

<!-- -->

*   Email: <mgoldboi@redhat.com>

<!-- -->

*   VSDM Component owner:

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

# Detailed Description

#### RPM level

*   package should require vdsm enabling the host to be an hypervisor
*   package should require cli/sdk to comunicate with engine

#### UI - first host deployment

*   yum install ovirt-hosted-engine (rpm level installation)
*   hosted-engine --deploy

          please specify the shared storage location to use
          please indicate nic to set mgmt-bridge on [eth0]
          please specify engine FQDN
          please specify installation media you would like to use (pxe,iso,ova)   

*   output: spice/terminal console to the new vm
*   once liveliness page is up install current host using sdk/cli call (no reboot)
*   deploy ended successfully

#### UI - additional host deployment

*   install host through rhevm
*   yum install ovirt-hosted-engine
*   configuration file should be add to this host with modifications

#### UI - operations

       hosted-engine --deploy (deploys first host)
       hosted-engine --vm-status (shows the vm status based on sanlock)
       hosted-engine --vm-stop (stops the vm if running on the host)
       hosted-engine --vm-start (try starts the vm)
       hosted-engein --check-liveliness (checks liveliness page of engine)

#### Configuration files

*   /etc/ovirt-engine/hosted-engine.conf

         FQDN of the engine machine
         shared storage
         service_start_timeout
         vm_disk_id (sanlock host id) = (host_fqdn by default)

*   /etc/ovirt-engine/vm.xml(or vm.conf)

       mem
       cpu
       image (optional)
       connect iso (optional)
       direct lun (optional)
       

#### Logic

*   based on vdsClient (bash)/ import vdsm (python) create SP infra

       connectStorageServer
       createStorageDomain
       createStoragePool
       create vm image (vdsm cli/api)
       connectStoragePool (should be removed later on)
       spmStart
       getSpmStatus
       createVolume
       getAllTasksStatuses
       clearTask

*   run vm with installation media
*   provide spice/terminal console

<!-- -->

*   polling on liveliness till engine is up
*   install host --no-reboot (first host)

#### Enhancements

*   sanlock vm/host id broker
*   shared cluster config
*   shared vm config
*   engine to reflect the host running the engine VM
*   engine to reserve resources for the engine VM

#### Open issues

*   pool connection is needed to run vm (should be solved on vdsm level) - we can't connect two pools to vdsm
*   sanlock on vm image (should be solved on vdsm level) - we can workaround for now
*   vdsm sanity for running a VM from another pool
*   vdsm providing monitoring service for tasks
*   change bridge details
*   host level oprations on engine hypervisor

#### Limitations

*   NFS/Gluster FS only (Block to be supported at a later stage)
*   RHEV-H not supported

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

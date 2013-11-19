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

*   Engine Component owner: Sandro Bonazzola

<!-- -->

*   Email: <sbonazzo@redhat.com>

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
*   Should support importing an existing installed engine ovf as installation media

# Detailed Description

### RPM level

*   package should require vdsm enabling the host to be an hypervisor
*   package should require cli/sdk to comunicate with engine

### UI - first host deployment

*   yum install ovirt-hosted-engine (rpm level installation)
*   hosted-engine --deploy

          please specify the shared storage location to use
          please indicate nic to set mgmt-bridge on [eth0]
          please specify engine FQDN
          please specify installation media you would like to use (pxe,iso,ovf)   

*   output: spice/terminal console to the new vm
*   once liveliness page is up install current host using sdk/cli call (no reboot)
*   deploy ended successfully

### UI - additional host deployment

*   install host through rhevm
*   yum install ovirt-hosted-engine
*   configuration file should be add to this host with modifications

### UI - operations

       hosted-engine --deploy (deploys first host)
       hosted-engine --vm-status (shows the vm status based on sanlock)
       hosted-engine --vm-stop (stops the vm if running on the host)
       hosted-engine --vm-start (try starts the vm)
       hosted-engein --check-liveliness (checks liveliness page of engine)

### Configuration files

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

*   /etc/ovirt-hosted-engine-ha/broker.conf

      [email]
      smtp-server=

<address of the smtp server to send notification emails with>
      smtp-port=25
`destination-emails=`<single email address that will be used as the sender's address>
`source-email=`<comma separated list of email addresses to send the notification emails to>

      [notify] <- keys configure the list of event types we are interested in
      state_transition=maintenance|start|stop|migrate|on
      ^- key is event type, value is regular expression,
         when it matches part of the internal detail field, the mail will be sent

*   /etc/ovirt-hosted-engine-ha/notifications/<event type>.txt - Files in this directory are used as templates for the notification emails. The template has to contain proper email message compliant to rfc822. That means both header and body parts. Some strings are replaced by the notification engine:
    -   {source-email} - source email address
    -   {destination-emails} - list of destination email addresses
    -   {detail} - the detail field of the event
    -   {hostname} - the hostname of machine that sent the event
    -   {time} - numeric timestamp of the message (0 = 1st of Jan 1970)
    -   {type} - type of the message, matches the filename

      state_transition.txt
      --------------------
      From: {source-email}
      To: {destination-emails}
      Subject: ovirt-hosted-engine state transition {detail} at {hostname}
      The state machine changed state.

### Logic

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

### Enhancements

*   sanlock vm/host id broker
*   shared cluster config
*   shared vm config
*   engine to reflect the host running the engine VM
*   engine to reserve resources for the engine VM

### Open issues

*   pool connection is needed to run vm (should be solved on vdsm level) - we can't connect two pools to vdsm
*   sanlock on vm image (should be solved on vdsm level) - we can workaround for now
*   vdsm sanity for running a VM from another pool
*   vdsm providing monitoring service for tasks
*   change bridge details
*   host level oprations on engine hypervisor

### Limitations

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

#### Required modifications

*   VDSM currently only support volume locking on the global level only - thus it can be currently either globally on or off, with no option to enable it for specific VM only.
*   In VDSM handling of operations like live snapshot (hoplug the new volume lease), live storage migration (hotplug all the new volume leases on the new storage and hotunplug all the old ones), disk hotplug/hotunplug (hotplug/hotunplug the volume lease), etc. must be handled properly (currently these cases are not handled).
*   VDSM is currently limited to only one Storage Pool, thus it's currently impossible to store the Engine VM not in the same Storage Pool as other VMs that will be managed.

#### Agent State Diagram

FSM diagram for hosted engine agent states (generated from README.AGENT-FSM.gv in agent source tree): ![](hosted-engine-agent-fsm.png "fig:hosted-engine-agent-fsm.png")

#### Maintenance Flows

The HA Agent will support 2 types of maintenance:

*   Global maintenance: all HA agents in the cluster will ignore the engine VM state while this mode is enabled, allowing an administrator to start/stop/modify the engine VM without any worry of interference from the HA agents. To accomplish this, a flag will be written to the HA metadata residing on shared storage, and all HA agents will heed this flag and enter a mode where the only actions they take will be to a) remain initialized, b) update their scores, and c) watch for the flag to become unset. Once the flag is unset, the agents will discover the status of the VM as they do upon starting up, and then will resume normal operation.
*   Local maintenance: an individual HA agent will stop the VM and not attempt to restart it while this mode is enabled, in an effort to allow the local host to enter maintenance mode (in vdsm/engine). Another host in the cluster should attempt to start the engine VM, at which time maintenance operations on the first host can proceed. A shortcut to initiate this process is to shut down the engine VM manually, as any unexpected shutdown of the VM on a given host will cause the HA agent on that host to temporarily drop its score to 0. In this event, the administrator should still log into the host and enter maintenance mode to ensure the score does not recover, possibly causing the host to reacquire the engine VM. Once local maintenance mode is disabled, the score on this host will recover and the agent will resume normal operation.

# Comments and Discussion

*   Refer to [Talk:Self Hosted Engine](Talk:Self Hosted Engine)

<Category:Feature>

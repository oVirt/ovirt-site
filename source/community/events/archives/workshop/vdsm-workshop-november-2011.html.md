---
title: VDSM - oVirt workshop November 2011
category: event/workshop
authors: danken, dannfrazier, quaid
---

# VDSM - oVirt workshop November 2011

Slides from talk:

*   [ODP](http://resources.ovirt.org/old-site-files/wiki/OVirt_VDSM_20111102.odp)
*   [Storage ODP](http://resources.ovirt.org/old-site-files/wiki/OVirt_VDSM_20111102.pdf)
*   [PDF](http://resources.ovirt.org/old-site-files/wiki/OVirt_VDSM_Storage_20111102.odp)
*   [Storage PDF](http://resources.ovirt.org/old-site-files/wiki/OVirt_VDSM_Storage_20111102.pdf)

### VDSM

*   Host bootstrap and registration
*   VM life cycle (via libvirt)
*   Guest Agent: Single Sign On, stop guest from within itself
*   Scheduler: Moved from CFQ to deadline
*   Thin provisioning for storage, if you don't have high end storage to do it
*   Tune page cache
*   fence proxy, upon request

## Why VDSM?

*   uses qemu/libvirt - but needs to scale to thousands of VMs

## Architecture and Implementation

*   VM info is store in the database, nowhere on the host
*   VDSM API (xmlrpc)
*   Communcate with guest agent via virtio serial
*   talks to sysfs, lvm, iscsi, etc
*   written in python - multithreaded/multi-process
*   uses clustering level above LVM to scale to 100s of nodes
    -   Implements a distributed image repository over local dir, FCP, FCoe, iSCSI, NFS, SAS
    -   Multihost system - one concurrent metadata writer (SPM, discuss it later)

### Robustness as a Design Goal

*   Heavily tested - add latency/block networking/drop lun paths/node crashes/livelocked qemu

### Packages

*   vdsm - daemon itself
*   vdsm_cli - communicate w/ vdsm on host itself
*   vdsm_bootstrap - what needs to be setup when added to oVirt setup
*   vdsm_reg - registration; relevant for oVirt node
*   vdsm_hooks - will cover later

### Infrastructure

Multi-processed to deal w/ D-state hangs (e.g. NFS hangs). Anything that might hang is in a separate process.

*   Supervdsm - used to use sudo for privileged ops, now use a separate daemon. only it does things that require root access.
*   Out of process -
*   Async Tasks - Can run some operations in an async way; want to move everything to this (engine gets job id, can monitor progress)

### Infrastructure continued

*   When you want to perform a storage refresh (refresh SCSI LUNs, e.g.). SamplingMethod queues up multiple requests, serializes them and gives them the same result (sounds a lot like the watershed command)
*   ResourceManageR: refcounted lock w/ the ability to create something and destroy it when refcount goes to 0
*   Securable: when host is VSPM must be executed as secured (actually, commands that do not need to be secured say they shouldn't be secured)

Q: what is vdsm? a library? No - it is a daemon

### Hooks

*   VM Livecycle hooks - for anything that is not (yet) part of the oVirt project
    -   before/after vm start, continue, pause, hibernate, dehibernate, migrate source, migrate dest & after destroy
*   VDSM lifecycle hooks - before/after vdsm_start
*   Hooks get passed arguments from engine

<!-- -->

*   Q: Is there any mapping between these hooks and libvirt hooks?
*   A: No.
*   Q: Is there any guarantee that a hook will continue to work w/ future oVirt changes?
*   A: No - we only guarantee that we'll continue to run your hooks
*   Q: Is it possible to have different hooks on different hosts?
*   A: Yes - but not recommended; might make sense if you have VMs that are non-migrateable, or if nodes have heterogenous storage domain access mechanisms
*   Q: can before/after hooks communicate?
*   A: must devise their own communication schemes (run a daemon, persist files)
*   Q: is there any plan to formalize the hooks?
*   A: no plans. hooks are not intended to be sustainable; send patches to get those features included in oVirt

You are invited to take a look at an assortment of completely unsupported set of [Vdsm hooks](http://danken.fedorapeople.org/hooks-2011-11-02.tar.gz)

### VM Livecycle API

*   create/destroy/pause/continue
*   setVmTicket - for setting up a SPICE connection
*   changeCD/changeFloppy
*   migrate/hibernate - hibernate writes VM to disk externaly, integrate w/ S4 inside the guest (migrate to file)
    -   mainly done for timing; guest knows this is happening.
    -   Q: would you consider falling back to externally hibernating a VM? Would prefer not to. Lots of problems w/ KVM around timekeeping.
*   shutdown - shutdown gracefully
*   desktopLogin/Logoff/Lock

### VM Monitoring API

*   list - list running Vms
*   getAllVmStats, getVmStats

## Network Config API

*   Add/Del/Edit Network
*   SetupNetworks - transactional; avoid situation where you don't lose connectivity to the node. makes sure it can still reach manager - if it cannot, roll back.

### Host Monitoring API

*   getVdsCapabilities (cpu capabilities, etc)
*   getVdsStats - oVirt engine doesn't use it, introduced for testing purposes (or was that ping?)
*   fenceNode

## StorageAPI

extensive.... too extensive

### Async Tasks API

### Roadmap

*   Networking
    -   Vepa, VN-Link, SR-IOV
    -   storage network (requires bridgeless network). all virtual networks are bridged today; would need to get rid of teh bridge for better performance (also redundant)
    -   migration network (requires bridgeless network)
    -   traffic shaping (tc, cgroups)
    -   intrusion detection
*   Cgroups (CPU, Memory, I/o, Network) for SLA; restrict number of IOPS a node can used out of the overall pool, allow HA VMs to get prioritization.
*   Monitoring
    -   Add counters
        -   Q: What counters? Storage - how much allocated, monitor usage, IOPS, there's a list somewhere
    -   Move to collectd?
*   Support for self-contained single host - not necessarily inside VDSM, but acts as a manager inside the host & stores config locallky
*   API needs generalization and stability - current API is not very clean
    -   want a looks & feel similar to engine API, Adam Litke working on RESTful
*   Events, etc

Q: how do we see the libvirt relationship continuing? features have to go through KVM->QEMU->libvirt->VDSM A: haven't experienced the time between libvirt->oVirt features to be a long amount of time. libvirt used to wait for stability in KVM, but recently libvirt is working in parallel (even leading - libvirt has feature before KVM implements it). libvirt/RH maintainer is here, is committed to working closely w/ KVM community. Speaker would like libvirt to be an actual library instead of daemon. Q: What's the scope between libvirt and VDSM? (e.g. cgroups - VDSM has it on the roadmap, libvirt has it) A: perhaps a BoF later Q: VDSM does iSCSI directly - will that migrate to libvirt? A: No. Basically using libvirt for hypervisor management/VM lifecycle, not storage management, etc. RH considers libvirt a great API for kvm; lots of apps use libvirt (e.g. for monitoring). Q: Managmeent tools that use libvirt vs. VDSM APIs - where should they plug in? sounds like they'd need to migrate. relies on RPM for package mgmt; requires specific versions of packages like qemu-kvm - don't want baggage of maintaining compatability like libvirt does

### How to contribute

[Category: Workshop November 2011](Category: Workshop November 2011)

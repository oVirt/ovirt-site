---
title: VDSM VM startup
category: vdsm
authors: fromani
---

# VDSM VM startup

## Summary

This page gather the design of the VM startup revamp. The code which handles the VM startup in current (<= 4.14.x) has become tangled and hard to follow. A rewrite will be beneficial. Performance improvements about the VDSM startup are covered in a [separate page](/develop/developer-guide/vdsm/libvirt-performance-scalability.html)

This page aims to document the internals and the execution flow of a VM startup/migration; migration is covered here (because it is is tightly correlated with VM creation. If you look for a gentler introduction to VDSM architecture, you'd probably better served by other wiki page. The remainder of this page will provide minimal context and minimal documentation about some other important parts of VDSM like the client interface, the API abstraction, the libvirt interaction and so on.

#### WARNING!

This document is work in progress and requently updated, for content and for style/consistency/readability. Proof-reading is also in prgress.

### Owner

*   Name: Francesco Romani (Fromani)
*   Email: <fromani@redhat.com>
*   PM Requirements : N/A
*   Email: N/A

### Current status

*   Target Release: oVirt 3.5 and following
*   Status: Draft/Discussion
*   Last updated: 2014-03-05

## Summary of the status quo

A (more) succint presentation about the topics described on this page is available here: [ODP](http://resources.ovirt.org/old-site-files/wiki/Fromani-VDSM-gathering-creation-migration-flows.odp).

### Introduction

Inside VDSM, a VM object encapsulate all the data and methods needed to fullfill the oVirt engine requests and commands, to keep track of the VM status (e.g. resource accounting) and to interact with the hypervisor, theough libvirt.

The creation of a VM object may be the result of different actions, all of which has the purpose to bring up and let the engine manage a virtual machine. Different actions demands for different code flows. The code flow that will lead to the creation of a VM are

*   creation: the most simple flow. A new VM is booted up and brought to existence in a given hosts, while it was previously down on the data center.
*   recovering: VDSM resyncs its internal state with libvirt, and retake ownership of the VMs found running in a given host.
*   dehibernation: VDSM restores a VM which was hibernated, or from a checkpoint being saved in the past.
*   migration destination: used internally, not directly exposed to users. VDSM create a VM to host the result of a migration of a VM from its source node.

### Implementation

All the code which implements the vm creation flow is found in *vdsm/vm.py*. Code is referenced *like this* in the remainder of this page.

VM objects are created each in its independent thread, to make the caller not-blocking. Each VM objects has its own *_creationThread* member (set in te constructor) which runs the *_startUnderlyingVm* method which actually implements the VM creation. Note that all the creation flow are intermixed here, and the code is branchy and scatthered through various helper methods. When *_startUnderlyingVm* ends its job, it sets the VM *_lastStatus* either to "Up" or "Down".

Note that VM objects are registered inside *vmContainer* before the creation process starts, so they are exposed to while the actual creation is still in progress. For the migration flow, which uses more threads and background operation through libvirt/qemu, synchronization is achieved using *threading.Event*s, which are triggered after certain phases of the creation have been reached.

The synchronization with the engine is regulated by te VM status parameter, which is in turn the result of the aggregation of various fields (see: *_getStatsInternal*, *status*, *_get_lastStatus*, *_set_lastStatus*)

*   the internal VM status field *_lastStatus*
*   a boolean flag reporting if the guest CPU is running or paused *_guestCpuRunning*
*   the status of the guest agent *_guestEvent* (note this is **NOT** a *threading.Event*)
*   the reported responsiveness of the hypervisor *_monitorResponse*

A VM objects may receive method invocations while the creation process is still ongoing (including, but not limited to *getStats* calls)

pseudo-code-summary of the *_startUnderlyingVm* workhorse

         def _startUnderlyingVm(self):
             try:
                 with throttle(libvirt)  # BoundedSempahore initialized to 4
                     try:
                         self._run()
                     except Exception:
                         handleExceptions()
                 if ('migrationDest' in self.conf or 'restoreState' in self.conf) \
                         and self.lastStatus != 'Down':
                     self._waitForIncomingMigrationFinish()
                 self.lastStatus = 'Up'
                 self.saveState()
             except Exception as e:
                  handleExceptions()
         

Please note this snippet is **just pseudo-code stripped from important parts to unclutter the example and highlight the point below**'. Important parts omitted are: status handling, exception handling, pause code handling).

What we aim to highlight here is the creation flow is scattered through methods at various nesting levels: *_startUnderlyingVm* itself, *_run*, *_waitForIncomingMigrationFinish*, and the logic to distinguish among creation flow is scattered as well.

The *_startUnderlyingVm* method does some generic preparation for the startup

*   sets the commited memory (stripped in the example)
*   sets VM internal status (stripped in the example)
*   handles the exception/failures triggered by helper methods and takes corrective action
*   handles the VM pause reason (stripped in the example)
*   saves the VM state for future recovery

The *_run* method implements most of the remaining setup common to all the migration flows, and the the **creation** and **recovering** flows. Most of the **dehibernation** flow (aka *restoreState*) is handled here, while the remainder is done in *_waitForIncomingMigrationToFinish*, where the **migration destination** flow is also implemented.

The *_run* method is surrounded by a BoundingSemaphore to throttle the access to libvirt. In the current implementation no more than 4 (four) parallel accesses to libvirt are permitted. This affects the entire *creation* and *recovery* flow and partially the *dehibernation* flow, which is implemented partially in *_waitForIncomingMigrationFInish*.

### The VM Creation flow

This execution flow boot up a VM previously reported as Down in the data center. It is named *creation* by borrowing the libvirt jargon (the libvirt call being used is domain.CreateXML). This is the only execution flow which do not assume a VM is already up and being handled by libvirt. VDSM recreates the VM definition in the XML format used by libvirt from the data provided by engine, and feed it into libvirt. libvirt will do the heavy lifting with qemu/kvm.

The most important steps are:

*   translation of the device data sent to engine in the internal data structure (*buildConfDevices*)
*   normalization of devices and enforcing the device limits (*preparePaths*, *_prepareTransientDisks* et al. See point below)
*   setup of the drive paths/images: oVirt uses shared storage and this has to be set before a VM can run; this is done by using the services provided by the VDSM storage subsystem
*   translate the internal data representation into the libvirt XML format (*_buildCmdLine*)
*   create the Domain (libvirt jargon) by using this XML, effectively starting up the VM
*   perform post-creation domain checks (*_domDependentInit*, shared with the other flows):
    -   resync data representation with the libvirt one (*_getUnderlyingVmInfo*)
    -   update and resync the device information from libvirt (*_getUnderlyingVmDevicesInfo* and sub-methods)
    -   start the statistics gathering thread, one per VM
    -   (try to) connect to Guest Agent
    -   handle paused VM, the most important task is handling VM paused for disk space exausted and handle this case appropriately
    -   set up niceness and guest scheduler parameters
*   if the VM was paused, recover the pause code; extend the VM drives if needed.

This flows is composed to many steps but is may be the most striaghtforward because there is no state to be synchronized between parties. The engine has the reference state, VDSM is acting as middlemen for libvirt and mostly translating data from the engine representation to the libvirt representation. Moreover, most of actions involved, and most of the helpers which implements them, are shared with the other execution flows.

### The VM Recovery flow

This execution flow recovers a VM after a VDSM restart, crash or genera unavailability. VM running in an host should not be affected by VDSM restarts, and they should continue to run. When VDSM returns up, it resyncs with the running VMs to regain the control and to be able again to manage them.

Please note that we document here just the part of the recovery which affects a VM startup. Recovery is a broader process and other parts of VDSM (clientIF) are affected. The recovery flow is implemented in the *_run* method. VDSM uses the data saved by the *saveState* call to restore most of its internal state, and merges those informations with the data provided by libvirt. This flow shares some similiarities with the 'Creation' flow. Being the VM already running, some steps can be omitted, and other are needed.

The recovery flow skips some startup errors to avoid to get stuck on the recovery of a single unresponsive VM. The objective is to recover as much VM as is possible.

The most important steps are:

*   translation of the device data sent to engine in the internal data structure (*buildConfDevices*)
*   collection of the device using the saved data (*_run*)
*   re-attach to the existing libvirt domain/VM
*   check drive merge in progress, if any, and resync state with libvirt (*domain.blockJobInfo*)
*   perform post-creation domain checks (*_domDependentInit*), as seen in the 'Creation' flow above
*   if the VM was paused, recover the pause code; extend the VM drives if needed, as seen in the 'Creation' flow above

WRITEME further notes about recovery

### The VM Dehibernation flow

This execution flow let a VM restart from a saved checkpoint, either from snapshot or from hibernation. Under the hood this is implemented as special migration case, **migration to file**.

The most important steps are:

*   translation of the device data sent to engine in the internal data structure (*buildConfDevices*)
*   normalization of devices and enforcing the device limits (*preparePaths*, *_prepareTransientDisks* et al. See point below)
*   setup of the drive paths/images: oVirt uses shared storage and this has to be set before a VM can run; this is done by using the services provided by the VDSM storage subsystem
*   translate the internal data representation into the libvirt XML format (*_buildCmdLine*)
*   update the XML representation using the XML data recevied ([?] by engine? **TODO: verify**). Optionally, adjust the device/image paths
*   prepare the volume paths (*prepareVolumePath*)
*   reattach to the libvirt's Domain (libvirt jargon)
*   perform post-creation domain checks (*_domDependentInit*, as seen above).
*   if the VM was paused, recover the pause code; extend the VM drives if needed.
*   let the domain continue the execution, sending the *resume* message to it (*_waitForIncomingMigrationFinish*)

### Migrations and the VM Migration destination flow

In order to properly describe the 'Migration destination' flow is beneficial to step back and describe the whole migration flow on its entirety. On this page, the focus is still on the VM creation phase, so more detailed description of Migration is demanded to other wiki pages.

In a nutshell, migration si performed through libvirt using the [peer to peer flow](http://libvirt.org/migration.html#flowpeer2peer). This means:

*   the actual migration is done by libvirt which in turn uses the facilities of the underlying QEMU
*   the source host is in charge of control of the operation, thus
*   the destination hosts acts as receiver, and it is controlled by the source hosts (see below for a detailed description of the 'Migration Destination' startup)
*   the control and the ownership of the VM is passed from source to destination after a succesfull migration
*   if migration fails, the source keeps running and the destination is trasparently (= without explicit user intervention) destroyed

A migration is triggered using the 'migrate' verb and is implemented using the *VM.migrate* method. A migration is carried by a service thread, *MigrationSourceThread*, which uses a couple more threads to monitor the operation:

*   *MigrationMonitorThread* polls libvirt periodically and report the migration progress
*   *MigrationDowntimeThread* controls the maximum allowed downtime and updates libvirt during the migration. The purpose is to avoid the guest OS go paused during the migration, or to minimize the pause duration.

*MigrationSourceThread* performs the following steps to do the migration (in the *run* method)

*   establish a connection to the destination host, optionally secured unsing SSL, using the XML-RPC bindings and make sure a VM with the same ID is not running on that host. (*_setupVdsConnection*)
*   prepares the destination machine parameters from the migration source: the destination VM must be a clone of the source VM, so the guest OS should see no difference. (*_setupRemoteMachineParams*)
*   save the source state for checkpointing
*   create the destination VM, empty. Here on the destination hosts starts the 'Migration Destination' startup flow. See below for more details. (*_startUnderlyingMigration*)
*   run the Downtime control and the Migration Monitor threads. (*_startUnderlyingMigration*)
*   starts the actual migration using libvirt's *migrateToURI2* call (*_startUnderlyingMigration*)
*   if migration ends well, save the Source VM state and put the source VM Down with success code (*_finishSuccesfully*)

Is worth to note that a lot of details are been skipped here and this summary just cover the basic succesfull case. See the migration page for a deeper explanation about migration, error scenarios and more detailed documentation.

On the destination host, the 'Migration Destination' flow is the implemented as follows.

*   translation of the device data sent to engine in the internal data structure (*_run* :: *buildConfDevices*)
*   normalization of devices and enforcing the device limits ('_run'' ::*preparePaths*, *_run* ::'_prepareTransientDisks'' et al. See point below)
*   setup of the drive paths/images: oVirt uses shared storage and this has to be set before a VM can run; this is done by using the services provided by the VDSM storage subsystem
*   compute the migration timeout and wait for expiration (*_waitForIncomingMigrationFinish*)
*   wait for VM to come up, either by libvirt notification (successfull migration or error) or by timeout expiration. When this event triggers, the actual migration is likely still in progress, because the data has yet to be transferred; however, here the destination VM is created and running, and it is ready to receive (or already been receiving) such data. (*_waitForIncomingMigrationFinish*)
*   perform post-creation domain checks (*_domDependentInit*), as seen in the 'Creation' flow above (*_startUnderlyingVm*)
*   if the VM was paused, recover the pause code; extend the VM drives if needed, as seen in the 'Creation' flow above (*_startUnderlyingVm*)

**NOTE** just AFTER the destination VM has been sucesfully created we have to wait for the actual data transfer to take place. We need a running VM instance on the destination host for this. See the *waitForMigrationDestinationPrepare* method which

*   estimates the duration of the migration and wait accordingly
*   updates the destination VM data with the XML data received from the migration source

## Rewrite objectives

*   add more tests! **both** unit-tests and functional (probably need to revamp vm functional tests as well)

<!-- -->

*   make the code cleaner/more extensible

<!-- -->

*   make the code more robust

<!-- -->

*   avoid racy behaviour (see [bz912390](https://bugzilla.redhat.com/show_bug.cgi?id=912390))

## Rewrite proposals

### Draft 1

Meta-proposal: try to preserve orthogonality between the folling concepts; e.g. allow to drop the 'staging area' concept while preserving the 'separate control flow' concept. Avoid inter-dependent enhancements wherever feasible.

1 clearly separate the control flows for each major startup mode (creation, recovery, restoring state); avoid multiplex-like functions like _run

2 OK to create the VMs in a separate thread, throttle parallelism until we can fully depend on libvirt not being a bottleneck ([details here](/develop/developer-guide/vdsm/libvirt-performance-scalability.html#startup-of-many-vms))

3 introduce 'staging area' for VMs being created, e.g. while the creation thread is running. In a nutshell, a separate private vmContainer-like structure to hold half-baked VMs; move VMs to public vmContainer -as it is now- only when they are fully created. Rationale: improve transactional behaviour as seen from the outside (engine), and make code more robust.

### Draft 2

Abandon staging area concept. Rationale: we can achieve the same result by enforcing states (e.g. a given method can run only in a given state) which will likely lead to simpler and more self-documenting code.

1 clearly separate the control flows for each major startup mode (creation, recovery, restoring state); avoid multiplex-like functions like _run

2 OK to create the VMs in a separate thread, throttle parallelism until we can fully depend on libvirt not being a bottleneck ([details here](/develop/developer-guide/vdsm/libvirt-performance-scalability.html#startup-of-many-vms))

3 builder-like classmethod for every creation flow except the creation.

         vm = Vm(params)  # creation
         vm = Vm.from_recovery(params)
         vm = Vm.from_snapshot(params)  # dehibernation/restoreState
         vm = Vm.from_migration(params)  # migration destination

4 better handling of exceptions when creating VMs **but behave properly on abort!** no changes in existing behaviour just deal better with cases like

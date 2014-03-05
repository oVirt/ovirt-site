---
title: VDSM VM startup
category: vdsm
authors: fromani
wiki_title: VDSM VM startup
wiki_revision_count: 43
wiki_last_updated: 2014-03-19
---

# VDSM VM startup

## Summary

This page gather the design of the VM startup revamp. The code which handles the VM startup in current (<= 4.14.x) has become tangled and hard to follow. A rewrite will be beneficial. Performance improvements about the VDSM startup are covered in a [separate page](VDSM_libvirt_performance_scalability)

This page aims to document the internals and the execution flow of a VM startup/migration (because the migration flow is tightly correlated with VM creation). If you look for a gentler introduction to VDSM architecture, you'd probably better served by other wiki page. The remainder of this page will provide minimal context and minimal documentation about some other important parts of VDSM like the client interface, the API abstraction, the libvirt interaction and so on.

#### WARNING!

This document is work in progress and requently updated, both for content and for style/consistency/readability

### Owner

*   Name: [Francesco Romani](User:Fromani)
*   Email: <fromani@redhat.com>
*   PM Requirements : N/A
*   Email: N/A

### Current status

*   Target Release: oVirt 3.5 and following
*   Status: Draft/Discussion
*   Last updated: 2014-03-05

## Summary of the status quo

### Introduction

Inside VDSM, a VM object encapsulate all the data and methods needed to fullfill the oVirt engine requests and commands, to keep track of the VM status (e.g. resource accounting) and to interact with the hypervisor, theough libvirt.

The creation of a VM object may be the result of different actions, all of which has the purpose to bring up and let the engine manage a virtual machine. Different actions demands for different code flows. The code flow that will lead to the creation of a VM are

*   creation: the most simple flow. A new VM is booted up and brought to existence in a given hosts, while it was previously down on the data center.
*   recovering: VDSM resyncs its internal state with libvirt, and retake ownership of the VMs found running in a given host.
*   dehibernation: VDSM restores a VM which was hibernated, or from a checkpoint being saved in the past.
*   migration destination: used internally, not directly exposed to users. VDSM create a VM to host the result of a migration of a VM from its source node.

### Implementation

All the code which implements the vm creation flow is found in *vdsm/vm.py*. Code is referenced "like this" in the remainder of this page.

VM objects are created each in its independent thread, to make the caller not-blocking. Each VM objects has its own *_creationThread* member (set in te constructor) which runs the *_startUnderlyingVm* method which actually implements the VM creation. Note that all the creation flow are intermixed here, and the code is branchy and scatthered through various helper methods. When *_startUnderlyingVm* ends its job, it sets the VM *_lastStatus* either to "Up" or "Down".

Note that VM objects are registered inside *vmContainer* before the creation process starts, so they are exposed to while the actual creation is still in progress. For the migration flow, which uses more threads and background operation through libvirt/qemu, synchronization is achieved using *threading.Event*s, which are triggered after certain phases of the creation have been reached.

The synchronization with the engine is regulated by te VM status parameter, which is in turn the result of the aggregation of various fields (see: *_getStatsInternal*, *status*, *_get_lastStatus*, *_set_lastStatus*)

*   the internal VM status field *_lastStatus*
*   a boolean flag reporting if the guest CPU is running or paused *_guestCpuRunning*
*   the status of the guest agent *_guestEvent* (note this is **NOT** a *threading.Event*)
*   the reported responsiveness of the hypervisor *_monitorResponse*

A VM objects may receive method invocations while the creation process is still ongoing (including, but not limited to *getStats* calls)

pseudo-code-summary of the *_startUnderlyingVm* workhorse

         def _startUnderlyingVm(self):
             try:
                 with throttle(libvirt)
                     try:
                         self._run()
                     except Exception:
                         handleExceptions()
                 if ('migrationDest' in self.conf or 'restoreState' in self.conf) \
                         and self.lastStatus != 'Down':
                     self._waitForIncomingMigrationFinish()
                 self.lastStatus = 'Up'
                 self.saveState()
             except Exception as e:
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

*   clearly separate the control flows for each major startup mode (creation, recovery, restoring state); avoid multiplex-like functions like _run

<!-- -->

*   OK to create the VMs in a separate thread, throttle parallelism until we can fully depend on libvirt not being a bottleneck ([details here](VDSM_libvirt_performance_scalability#Startup_of_many_VMs))

<!-- -->

*   introduce 'staging area' for VMs being created, e.g. while the creation thread is running. In a nutshell, a separate private vmContainer-like structure to hold half-baked VMs; move VMs to public vmContainer -as it is now- only when they are fully created. Rationale: improve transactional behaviour as seen from the outside (engine), and make code more robust.

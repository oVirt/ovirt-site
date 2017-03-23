---
title: Hot Unplug Memory
category: feature
authors: mzamazal
wiki_category: Feature
wiki_title: Features/Hot Unplug Memory
wiki_revision_count: 2
wiki_last_updated: 2017-03-21
---

# Hot unplug memory

## Summary

This feature allows removing memory from a VM while the VM is running.

## Owner

*   Name: Milan Zamazal
*   Email: mzamazal@redhat.com
*   BZ: https://bugzilla.redhat.com/1228543

## Description

Until now, it was possible to only add memory to a running VM.  In order to
remove memory from a VM, the VM had to be shut down.

It is now possible to hot unplug memory from a running VM.  However there are
some limitations:

- You can't remove arbitrary amount of memory.  Only previously hot plugged
  memory devices can be removed.

- The guest OS must support memory hot unplug.  Up-to-date RHEL/CentOS 7
  systems support it.

- All blocks of the previously hot plugged memory must be onlined as movable.

- It is not recommended to combine memory hot unplug with memory ballooning.

If any of those conditions is not satisfied, the memory hot unplug action may
fail or cause problems.

## Making hot plugged memory movable

To fulfill the requirement of making hot plugged memory movable on an
up-to-date RHEL/CentOS 7 guest system, ovirt-guest-agent of version
1.0.13-2.el7 or higher must be installed in the guest.  Please note that proper
ovirt-guest-agent version must be installed in the guest prior to hot plugging
any memory in order to guarantee that hot plugged memory is movable.

## How to hot unplug memory from a VM

**Not yet implemented.**

The previously hot plugged memory appears in the form of memory devices in
*Vm Devices* tab of the given VM.  You can remove any of the devices (assuming
they have been hot plugged considering the constraints described above) and
thus remove that amount of memory from the VM.  Once the memory device is
successfully hot unplugged the device disappears from the device list.

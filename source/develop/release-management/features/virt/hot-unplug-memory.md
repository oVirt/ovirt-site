---
title: Hot Unplug Memory
category: feature
authors: mzamazal,jniederm
feature_name: Hot Unplug Memory
feature_modules: engine,vdsm
feature_status: Merged
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

There is no ovirt-guest-agent on RHEL/CentOS 8.  For such guests,
there are two options to make the hot plugged memory movable:

- Add `movable_node` option to the guest kernel command line and
  reboot the VM.

- Override the memory hot plug udev rule from
  `/lib/udev/rules.d/40-redhat.rules` by copying
  `# Memory hotadd request` section from it to a new rule file
  `/etc/udev/rules.d/39-redhat.rules` and changing
  `ENV{.state}="online"` line to `ENV{.state}="online_movable"` there.
  Then reload udev rules.  Note that the original rule may change
  on system updates, you should check it for contingent changes after
  system upgrades.

You can apply either of the two options.

## How to hot unplug memory from a VM

### WebAdmin

The previously hot plugged memory appears in the form of memory devices in
*Vm Devices* tab of the given VM.  You can remove any of the devices (assuming
they have been hot plugged considering the constraints described above) and
thus remove that amount of memory from the VM.  Once the memory device is
successfully hot unplugged the device disappears from the device list.

*Physical Memory Guaranteed* is decremented if necessary.

If next run configuration exists and its memory values is the same as the memory
size of the running VM before hot unplug, next run configuration is updated.

![](/images/wiki/memory-hot-unplug-webadmin.png "Memory hot unplug button in 'VM Devices' tab in Administration Portal")

### REST API

Memory hot unplug can be performed by updating a VM with decremented value
of `/vm/memory` tag. It may be required to decrement value of *Physical
Memory Guaranteed* (`vm/memory_policy/guaranteed`) as well to keep it lesser than
value of memory. Both properties are set in bytes that are later floored to MiB.

Memory devices to hot unplug are picked so that sum of sizes of hot unplugged
devices will be smaller or equal to requested memory size decrement.

Values for next run configuration are not rounded.

#### Example

Let's suppose there is a running VM started with 1GiB memory that was given three 
256MiB hot-plugs. This resulted in additional memory devices of following sizes:
256MiB, 256MiB, 128MiB, 128MiB and the VM having 1792MiB memory available in total.

Firing request requiring 1400MiB memory and 900MiB physical memory guaranteed will
result in updating next run configuration with memory of 1400MiB and physical memory
guaranteed of 900MiB. Currently running VM will be asked to release memory devices
of sizes 256MiB and 128MiB. Thus the VM will end up with 1792MiB - (256MiB + 128MiB)
= 1408MiB >= requested 1400MiB. Physical memory guaranteed will be hot set to value
900MiB.

```xml
PUT api/vms/{vmId}

<vm>
    <memory>1468006400</memory> <!-- 1400 * 1024^2 -->
    
    <!-- and optionally -->
    <memory_policy>
        <guaranteed>943718400</guaranteed> <!-- 900 * 1024^2 -->
    </memory_policy>
</vm>
```

---
title: Hot Plug Memory
category: feature
authors: ofrenkel
---

# Hot plug memory

## Summary

Allow adding memory to VM while it is running

## Owners

*   Name: Vitor de Lima (Vitordelima)
*   Name: Omer Frenkel (ofrenkel)
*   Email: <ofrenkel@redhat.com>

## Description

Until now, adding memory to a VM required it to be down, in order the change will take effect.
with hot plug memory, user can add memory to a running VM and select to apply the change immediately,
so the guest will see the new memory.
Hot plugging memory is done using Update-VM for a running VM.
just updating the amount of the VM memory to the new (higher) value will trigger hot plug,
unless user request to apply the changes later.

    When memory is updated, the new value is saved for next run,<br>
    so next time the vm is started, the new memory value is used.
    user flow example:
     * VM started with 4gb memory.
     * User update memory to 6gb, memory is hot-plugged to the vm (2gb memory device created).
     * User stop the VM, and start it again.
     * VM now starts with 6gb, as its base memory (no memory devices are created).

## Implementation Details

*   The new memory is added to the VM as a DIMM device:

<!-- -->

    <memory model='acpi-dimm'>
          <source>
            <node>0</node> <-- source memory slot, if not provided, sane default  shall be used
            <pagesize unit='KiB'>4096</pagesize> <--- size of the memory page to be used as source (to be able to specify hugepages), sane default shall be used if ommitted
          </source> <- both source node and pagesize are optional, <source> can be ommited, defaults from the domain config will be used
          <target>
            <node>0</node> <--- guest memory node (mandatory)
            <size unit='KiB'>12345</size> <- new module size (mandatory)
          </target>
        </memory>

*   Every memory device must be a multiplication of 256mb.
    -   It doesn't matter what the base memory is, for example if vm started with 1003mb, it can be updated only to 1259mb,1515mb,...
    -   note that this amount of memory is configurable but its not recommended to change, VM may fail to start, configuration value is 'HotPlugMemoryMultiplicationSizeMb'.
*   There is a limit on the number of memory devices, which means limit the number of times user can do hotplug during run of vm.
    -   The configuration value for this limit is 'MaxMemorySlots' and the default is 16.
*   Number of max memory devices (slots) and maximum memory are sent to libvirt.xml:
    -   <maxMemory slots="16">4294967296</maxMemory>
    -   the maximum memory is configurable for 32 and 64 bit OS: VM32BitMaxMemorySizeInMB, VM64BitMaxMemorySizeInMB.
*   The memory devices are attached to a guest numa node, so on 3.6 cluster, with 'HotPlugMemorySupported' configuration enabled (true by default), every VM has a default guest numa node.
*   VDSM hotplugMemory verb expect memory device with size in mb and guest numa node id to plug the memory to.

### More Info

*   libvirt docs:
    -   <http://libvirt.org/formatdomain.html#elementsMemory>
*   Discussion about the libvirt API for memory hotplug:
    -   <https://www.redhat.com/archives/libvir-list/2014-July/msg01265.html>

## VDSM Hooks

its possible to manipulate the libvirt xml in the following vdsm hooks

*   before_memory_hotplug
*   after_memory_hotplug

### Compatibility issues

Not yet supported on PPC


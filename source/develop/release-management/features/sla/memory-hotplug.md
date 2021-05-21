---
title: Memory Hotplug
authors:
  - ofrenkel
  - vitordelima
---

# Memory Hotplug

### Summary

This feature will add the possibility of hot plugging virtual memory modules into a running VM from the GWT frontend and the REST API.

### Owner

*   Name: Vitor de Lima (Vitordelima)
*   Email: vdelima@redhat.com

### Current status

Implementation: <https://gerrit.ovirt.org/#/q/status:open+branch:master+topic:hotPlugMem>

### Detailed Description

Dynamically resizing the amount of memory dedicated to a guest is an important feature, it allows server upgrades without restarting the VM.

### Benefit to oVirt

Allows the admin of an oVirt based datacenter to dynamically resize the amount of RAM of each guest.

### Detailed Design

The amount of memory destined to a VM will be available as an editable field in the "Edit VM" dialog while the VM is running, clicking OK will trigger a "Hot Set" action in the backend to adjust the VM memory without the need to tell from which physical NUMA cell it comes from or to which cell it goes.

The memory increase must be implemented as a memory module device to be hot plugged into the VM, the XML definition of such device is:

```xml
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
```

Hot unplugging memory will be implemented by forcing the user to reduce the size of the memory in amounts that can be represented by a sum of previously hotplugged virtual memory modules. The engine will solve the subset sum problem to find which virtual memory modules must be unplugged and call VDSM to unplug them.

### Documentation

Discussion about the libvirt API for memory hotplug: <https://www.redhat.com/archives/libvir-list/2014-July/msg01265.html>

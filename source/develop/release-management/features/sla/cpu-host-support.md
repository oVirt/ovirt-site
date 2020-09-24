---
title: Cpu-host Support
category: feature
authors: acathrow, lhornyak
---

# CPU-Host Support

## Summary

CPU-Host support allows the virtual machines to see and utilize the host's CPU flags, this enables better performance in VM's, at the price of worse portablity.

## Owner

*   Name: Laszlo Hornyak

## Current status

*   Merged
*   Last updated date: 19 Dec 2012

## Detailed Description

Since with host-passthrough gives the host cpu-capabilities to the VM's CPU, migration can not happen to different CPU-models. This could still be acceptable if all the hosts are all uniform in the cluster.

*   engine modifications:
    -   modify VmStatic, add useHostCpuFlags boolean property
        -   database schema modification in tables, views and stored procedures
        -   DAO modifications
    -   modify the Add/Edit VM dialog, add 'use host cpu flags' checkbox - it should be enabled only when Vm is pinned to host

![](/images/wiki/Hostcpumockup.png)

*   vdsm modifications:
    -   add hostPassthrough and hostModel as special cpu types <http://gerrit.ovirt.org/9507> - **merged**
*   rest-api:
    -   Add new element cpu_mode with values *custom*, *host_model* and *host_passthrough* to CPU
    -   example

```xml
<cpu>
  <topology cores="1" sockets="1"/>
  <cpu_mode>HOST_PASSTHROUGH</cpu_mode>
</cpu>
```

Label should be "Pass through host CPU". When this is set the VM should be marked as non-migratable

## Benefit to oVirt

Allows the users to get better performance from their VM's through using all CPU capabilities - including the ones not handled by qemu/kvm

## Dependencies / Related Features

*   libvirt's [CPU-model and topology](http://libvirt.org/formatdomain.html#elementsCPU)

## Documentation / External references

*   [BZ838469 - Support cpu -host for virtual machines](https://bugzilla.redhat.com/show_bug.cgi?id=838469)



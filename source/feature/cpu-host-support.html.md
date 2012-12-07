---
title: Cpu-host Support
category: feature
authors: acathrow, lhornyak
wiki_category: Feature
wiki_title: Features/Cpu-host Support
wiki_revision_count: 27
wiki_last_updated: 2013-01-07
---

# CPU-Host Support

### Summary

CPU-Host support allows the virtual machines to see and utilize the host's CPU flags, this enables better performance in VM's, at the price of worse portablity.

### Owner

*   Name: [ Laszlo Hornyak](User:Lhornyak)
*   Email: <lhornyak@redhatdotcom>

### Current status

*   Implementation
*   Last updated date: 5 Dec 2012

### Detailed Description

Since with host-passthrough gives the host cpu-capabilities to the VM's CPU, migration can not happen to different CPU-models. This could still be acceptable if all the hosts are all uniform in the cluster.

*   engine modifications:
    -   modify VmStatic, add useHostCpuFlags boolean property
        -   database schema modification in tables, views and stored procedures
        -   DAO modifications
    -   modify the Add/Edit VM dialog, add 'use host cpu flags' checkbox - it should be enabled only when Vm is pinned to host

![](Hostcpumockup.png "Hostcpumockup.png")

*   vdsm modifications:
    -   **either** add support to domain creation for host-passthrough - api parameter name could be 'useHostCpuFlags' <http://gerrit.ovirt.org/9367>
    -   **OR** add hostPassthrough and hostModel as special cpu types <http://gerrit.ovirt.org/9507>
    -   vdsm guys please decide
*   rest-api:
    -   Add new attribute 'host_passthrough' to CPU

Label should be "Pass through host CPU". When this is set the VM should be marked as non-migratable

### Benefit to oVirt

Allows the users to get better performance from their VM's through using all CPU capabilities - including the ones not handled by qemu/kvm

### Dependencies / Related Features

*   libvirt's [CPU-model and topology](http://libvirt.org/formatdomain.html#elementsCPU)

### Documentation / External references

*   [BZ838469 - Support cpu -host for virtual machines](https://bugzilla.redhat.com/show_bug.cgi?id=838469)

### Comments and Discussion

<Category:Feature> <Category:SLA>

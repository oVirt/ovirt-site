---
title: NUMA and Virtual NUMA
category: feature
authors: adahms, danken, jasonliao
wiki_category: Feature
wiki_title: Features/NUMA and Virtual NUMA
wiki_revision_count: 20
wiki_last_updated: 2014-08-14
---

# NUMA and Virtual NUMA

### Summary

The hypervisor’s default policy is to schedule and run the guest on any available resources on the host. As a result, the resources backing a given guest could end up getting spread out across multiple NUMA nodes and over a period of time may get moved around, leading to poor and unpredictable performance inside the guest.

### Owner

*   Name: [ Jason Liao](User:JasonLiao)
*   Email: <chuan.liao@hp.com>

### Current status

*   Initialization
*   Last updated date: 13 Dec 2013

### Detailed Description

*   engine modifications:
    -   Add three properties on VM define NUMA and Virtual NUMA
    -   Add one protperty on Host define NUMA node
    -   Change GUI interface Add/Edit VM dialog with Host tab

![](OVirt_large_guest_feature(Dialog).png "OVirt_large_guest_feature(Dialog).png")

*   -   Change Frontend VM Module and related operation
    -   Change Backend VM Module and related operation
*   vsdm modifications:
    -   Change vdsm create process and capabilities with host numa info

[HDesign document](http://www.ovirt.org/images/2/29/OVirt_large_guest_feature.pdf)

When this is set the VM should be marked as non-migratable

### Benefit to oVirt

Allows the users to get better performance from their VM's through using all CPU related memory - including the ones not handled by qemu/kvm. Allows the users to get better performance from their VM's through split virtual NUMA node.

### Dependencies / Related Features

*   libvirt's [NUMA Node Tuning](http://libvirt.org/formatdomain.html#elementsNUMATuning)
*   libvirt's [Guest NUMA topology](http://libvirt.org/formatdomain.html#elementsCPU)

### Documentation / External references

*   [BZ1010059 - NUMA aware and balanced allocation of backing host resources for large guests](https://bugzilla.redhat.com/show_bug.cgi?id=1010059)
*   [BZ1010079 - Virtual NUMA nodes inside larger guests](https://bugzilla.redhat.com/show_bug.cgi?id=1010079)

### Comments and Discussion

<Category:Feature> <Category:SLA>

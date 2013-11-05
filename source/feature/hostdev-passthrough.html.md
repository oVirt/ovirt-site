---
title: hostdev passthrough
category: feature
authors: mbetak, mpolednik
wiki_category: Feature
wiki_title: Features/hostdev passthrough
wiki_revision_count: 65
wiki_last_updated: 2015-05-07
---

# VM device PCI passthrough

### Summary

This feature will allow VDSM to assign pci device to guest using passthrough

### Owner

*   Name: [ Martin Polednik](User:Martin Polednik)
*   Email: <mpoledni@redhat.com>

### Current status

*   Last updated date: Mon Nov 05 2013

* waiting for refactored device handling in VDSM

### VDSM side

Unlike virtual devices, PCI passthrough uses real host hardware, making the number of such assigned devices limited. VDSM has to internally keep list (dict) of PCI devices and their assignments and report this data to engine. As these devices are persisted in libvirt XML, we don't need to persist the list itself but reconstruct it using getUnderlying\* function. VMs that are assigned devices that do not exist anymore will refuse to boot, reporting libvirterror message to engine.

#### Migration

Migration is complicated by the fact that migrating VM with assigned PCI device will cause such device to be hot-unplugged and hot-plugged after the migration is done, causing possible downtime in service. Therefore, migration will not be allowed for devices with specific hardware assigned to them (such as GPU).

*   **Devices with possible migration:**
    -   VMs with physical NIC can be migrated without downtime of service using bonding [1](http://net.pku.edu.cn/vc/read/VM_OLS08.pdf).

<!-- -->

*   **Devices where migration is not easily possible:**
    -   GPU, TPM (passthrough), ... (probably more)

### Engine side

TODO

<Category:Feature>

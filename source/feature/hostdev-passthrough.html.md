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

*   Last updated date: Fri Dec 20 2013

### VDSM side

Unlike virtual devices, PCI passthrough uses real host hardware, making the number of such assigned devices limited. VDSM will report available devices in vdsCapabilities using keyword hostDevices. The list itself does not (and by philosophy cannot) report the assignments itself. These are reported in VM devices section, identified by type 'hostdev'.

Structures

    vdsCapabilities 'hostDevices': [{'name': '...', 'vendor': '...', 'product': '...'}]
    VM: 'devices': [... {'type': 'hostdev', 'name': '...', 'vendor': '...', 'product': '...'} ...]

Hot(un)plug is accomplished by hotplugHostdev and hotunplugHostdev calls, which only take vmId and name field of the device to be added/removed.

#### Migration

Migration should be disabled for any VM with hostdev device.

### Engine side

Engine needs to internally keep track of device assignments for individual hosts. Device assignment should preferably look similar to virt-manager, displaying list of (name product vendor) available for assignment. User also needs to have a way of hot(un)plugging these devices.

<Category:Feature>

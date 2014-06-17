---
title: hostdev passthrough
category: feature
authors: mbetak, mpolednik
wiki_category: Feature
wiki_title: Features/hostdev passthrough
wiki_revision_count: 65
wiki_last_updated: 2015-05-07
---

# VM device hostdev passthrough

### Summary

This feature will allow passthrough of host devices to guest

### Owner

*   Name: [ Martin Polednik](User:Martin Polednik)
*   Email: <mpoledni@redhat.com>

### Current status

*   Last updated date: Fri Jun 17 2014

### VDSM side

Unlike virtual devices, PCI passthrough uses real host hardware, making the number of such assigned devices limited. VDSM will report available devices in vdsCapabilities using keyword hostDevices. The list itself does not (and by philosophy of host capabilities cannot) report the assignments itself. These are reported in VM devices section, identified by type 'hostdev'.

Structures

    vdsCapabilities 'hostDevices': [{'name': '...', 'capability': '...', 'vendor': '...', 'product': '...'}]
    VM: 'devices': [... {'type': 'hostdev', 'name': '...', 'capability': '...'} ...]

Engine wil receive name, capability, vendor and product of the device

*   name: unique string containing physical address of the device, guaranteed to be host-unique
*   capability: type of the device (pci, usb, scsi and possibly more in the future - scsi targets, hosts etc.)
*   vendor, product: human-readable identifiers of the device, possibly not unique

### Migration

Migration should be disabled for any VM with hostdev device.

### Engine side

Engine needs to internally keep track of device assignments for individual hosts. Device assignment should preferably look similar to virt-manager, displaying list of (name product vendor) available for assignment.

<Category:Feature>

---
title: DetailedStableDeviceAddresses
category: feature
authors: doron, ekohl, emesika
wiki_category: Feature
wiki_title: Features/Design/DetailedStableDeviceAddresses
wiki_revision_count: 52
wiki_last_updated: 2012-03-14
wiki_warnings: list-item?
---

# Detailed Stable Device Addresses

## Stable Device Addresses

### Summary

Allow devices in guest virtual machines to retain the same device address allocations as other devices are added or removed from the guest configuration. This is particularly important for Windows guests in order to prevent warnings or reactivation when device addresses change.
In the term Device we include PCI, VirtIO Serial, SCSI, IDE, CCID and actually anything libvirt supports.

### Owner

*   Feature owner: [ Eli Mesika](User:emesika)

    * GUI Component owner: Not Relevant

    * REST Component owner: Not Relevant

    * Engine Component owner: [ Eli Mesika](User:emesika)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.1
*   Status: Design Stage
*   Last updated date: Wed December 28 2011

### Detailed Description

#### Entity Description

##### Generic Device

#### CRUD

#### User Experience

#### Installation/Upgrade

#### User work-flows

#### Enforcement

### Dependencies / Related Features and Projects

<http://www.ovirt.org/wiki/Features/Design/StableDeviceAddresses>

### Open Issues

[Category: Feature](Category: Feature)

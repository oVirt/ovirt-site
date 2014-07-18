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

*   Last updated date: Fri Jul 18 2014

### VDSM side

Unlike virtual devices, host passthrough uses real host hardware, making the number of such assigned devices limited. The passthrough capability itself requires hardware that supports intel VT-d or AMD-vi. This capability can be reported through the parsing of kernel cmdline, where intel_iommu or iommu option appears. Please note that this cannot guarantee that the feature is in fully working condition, but should be sufficient on correctly configured passthrough hosts.

In order to report state of these devices, two new verbs are introduced: hostDeviceLookupByDomain and hostDeviceLookupByCapability. Both of these verbs return devices in the format stated below, the only difference are the devices returned.

    vdsCapabilities: 'hostPassthrough': 'true'
    devices: ['deviceName': [{capability': '...', 'product': '', 'vendor': ''}, vmId]]

In order to add these devices to VM, it needs to be appended to vmCreate's devices section, where device = 'hostdev' and type = 'hostdev'. Host's vdsm takes care of detaching the device and making it available to use by calling libvirt's virNodeDevice.dettach().

Reattaching of these devices is also handled by VDSM and by service verb hostDeviceReattach().

### Migration

Migration should be disabled for any VM with hostdev device.

<Category:Feature>

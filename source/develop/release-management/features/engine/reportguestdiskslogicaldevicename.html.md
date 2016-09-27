---
title: ReportGuestDisksLogicalDeviceName
category: feature
authors: laravot
wiki_category: Feature
wiki_title: Features/ReportGuestDisksLogicalDeviceName
wiki_revision_count: 9
wiki_last_updated: 2014-08-31
feature_name: Report Guest Disks Logical Device Name
feature_modules: engine,vdsm,guest-agent
feature_status: Design
---

# Report Guest Disks Logical Device Name

## Summary

When a disk is plugged to a running VM, the user can't tell what's the device logical name assigned to that disk within the guest OS (for example: /dev/sda) without performing further operations. Reporting and displaying the logical device name within oVirt will ease users life and will eliminate the need to "discover" the device name manually.

Currently the first 20 chrachters of the disk guid are being passed to libvirt as the disk serial, on each OS the way of getting the device name using the passed serial is different, this feature aims to save those operations from the user and provide that info without need to perform in-guest operations.

## Owners

oVirt Guest Agent:

*   Name: [ Vinzenz Feenstra](User:vfeenstr)
*   Email: <vfeenstr@redhat.com>

oVirt Engine and VDSM:

*   Name: [ Liron Aravot](User:laravot)
*   Email: <laravot@redhat.com>

## Current status

This feature is in coding phase.

*   Last updated on -- by

## Detailed Description

The disks logical names are assigned by the guest OS and are OS dependent, therefore we need to report them back from the guest. oVirt currently uses the oVirt guest agent (http://www.ovirt.org/Category:Ovirt_guest_agent) to report such information back from the guest - so as part of this feature the disks logical names reporting has been added to the guest agent.

The engine (VdsUpdateRuntimeInfo) executes GetAllVmStats every few seconds, among the returned information a hash code is being returned to determine if a 'device related' update has been done in the guest configuration (see further info here -[Stable device addresses](Features/Design/StableDeviceAddresses)). If such update has been done, the engine issues a list(Full=True) call to vdsm to get the "full" vm information and persists the received data in the engine database. The guest disks logical names is something that changes rarely, so same as with the vm devices, the idea is to not return that information back to the engine every few seconds, but only when it was changed (which should be on disk hotplug/unplug). If we'll take a closer look on the hotplug operation, the update of the configuration of the vm and the assignment of the logical device name within the guest are two separate operations, using the hash current calculation (based on the vm configuration) isn't good enough as we may always encounter a race condition in which the vm configuration has been updated but logical name hasn't been assigned yet within the guest. Threfore as part of this change the disk logical device names returned by the oVirt guest agent are included in the hash calculation as well, eliminating that possible race condition.

## Detailed Design

### Engine

*   VdsUpdateRuntimeInfo - if the cluster version supports reported device logical name, the logical device name for disk

will be persisted to the engine db.

### Guest Agent

*   Extend the disks-usage message with the 'mapping' field.

The value of the mapping field is an object {'$serial': {'name': '$devname'}}

<http://gerrit.ovirt.org/#/c/31465/>

### VDSM

*   Handling report of disk mapping from the guest agent:

<http://gerrit.ovirt.org/#/c/31497/>

*   Return the disk mapping on status call:

<http://gerrit.ovirt.org/#/c/31700/>

*   Include the disk mapping on the hash calculation:

<http://gerrit.ovirt.org/#/c/31701/>

### DB Changes

vm_device table:

       add column -logical_name VARCHAR(255)




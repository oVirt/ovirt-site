---
title: Disk Hooks
category: feature
authors: vered
wiki_category: Feature
wiki_title: Features/Disk Hooks
wiki_revision_count: 4
wiki_last_updated: 2014-07-03
---

# Disk Hooks

### Summary

Adding VDSM hooking points before and after disk's hot plug and hot unplug.
 These hooks enable the running of guest-level operations on the disks when they're plugged/unplugged.

### Owner

*   Name: [Vered Volansky](User:vvolansk)
*   Email: vered@redhat.com

### Current status

*   Target Release: 3.3
*   Status: done
*   Last updated: ,

### Detailed Description

This feature adds four hooking points to vdsm, for before and after a disk's hot plug and unplug from a VM.
These hooking points are named:
1. before_disk_hotplug
2. after_disk_hotplug
3. before_disk_hotunplug
4. after_disk_hotunplug
 The above hooking points are defined in vdsm/hooks.py, and used in vdsm/libvirtvm.py.

### Benefit to oVirt

The feature allows customers to add their own functionality before hot-plugging and hot-unplugging disks.
 This can be done by adding scripts performing custom behaviour.
More details regarding the actual usage can be found [here](VDSM-Hooks) and [here](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Administration_Guide/VDSM_Hooks.html/).

<Category:Feature>

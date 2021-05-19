---
title: Disk Hooks
category: feature
authors: vered
---

# Disk Hooks

## Summary

Adding VDSM hooking points before and after disk's hot plug and hot unplug.
 These hooks enable the running of guest-level operations on the disks when they're plugged/unplugged.

## Owner

*   Name: Vered Volansky (vvolansk)
*   Email: vered@redhat.com

## Current status

*   Target Release: 3.3
*   Status: done
*   Last updated: ,

## Detailed Description

This feature adds four hooking points to vdsm, for before and after a disk's hot plug and unplug from a VM.
These hooking points are named:
1. before_disk_hotplug
2. after_disk_hotplug
3. before_disk_hotunplug
4. after_disk_hotunplug
 The above hooking points are defined in vdsm/hooks.py, and used in vdsm/libvirtvm.py.

## Benefit to oVirt

The feature allows customers to add their own functionality before hot-plugging and hot-unplugging disks.
 This can be done by adding scripts performing custom behaviour.
More details regarding the actual usage can be found [here](/develop/developer-guide/vdsm/hooks.html) and [here](/documentation/administration_guide/#appe-VDSM_and_Hooks).


---
title: Expose VM Devices
authors: ofrenkel
---

# Expose VM Devices

## Summary

We would like to allow the user to see more information regarding the devices that attached to a vm.
VM devices are mostly virtual hardware devices used in the vm,
like controllers, PCI cards and more.

## Owner

*   Name: Omer Frenkel
*   Email: ofrenkel@redhat.com

## Current Status

*   Status: Design
*   Target release: 3.6

## Detailed Description

currently (oVirt 3.5), only some of the device are visible to the user,
and also for these devices not all information is exposed.

some examples:
on add/edit vm, user can select to use sound, display device, smart-card and more.
Still the user cannot see the controllers used for these devices,
and more information on every device like address, type in the system and other information that stored in the system.
**\1**
VM devices are widely used in the ovirt engine, but merely exposed in UI and API,
The idea of this feature is to allow users to see more information of devices,
and prepare the ground for future work, like allowing setting device address and more.
for every device we will show:

      * icon per type
      * Type: like USB, Controller, Disk...
      * address
      * boot order
      * plugged
      * readonly
      * engine managed
      * spec params

### UI

Add new sub tab for VMs and Templates: Devices
This sub tab will contain a list of all VM devices
need to consider what actions (if any) we would like to have in the new sub tab.

### REST API

Add new sub collection for VMs and Templates: Devices
This will be a collection of all VM devices

## UI Mock-Ups

*   sub tab view with icons for devices

![](/images/wiki/Vm_devices_tab.png)

## Open Issues

*   Expose "grouping" of devices?

today in the engine db we have "general" type that can be used,
for example: Disk, Floppy and CD are all of general-type "Disk"
and sound,ac97,ich6 are sound
but some has no group, like smartcard,watchdog, etc..
another option for grouping is analyzing the address,
and group with "pci","ide" and so.
the downside of this approach is that it is very general,
and probably most devices will just be PCI and it will be useless
another issue is that address is available only after the vm was run.



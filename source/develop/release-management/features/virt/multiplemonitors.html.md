---
title: MultipleMonitors
authors: shaharh
---

# Multiple Monitor Via Single PCI

## Summary

Ability to channel Spice display protocol up to 4 different PCI channels in a single VM

## Owner

Shahar Havivi,

*   Name: shaharh (shaharh)
*   Email: <shaharh@redhat.com>

## Detailed Description

Traditionally support for multiple monitor was handled via a single PCI channel, I.e. user could select up to 4 monitors and the VM handle that via a single PCI analog to one physical display adapter that is attach to a mother board via a single PCI express slot. This feature let the user decide if he want one PCI slot for each monitor or using the legacy multiple monitor support.

## Usage

VM (VMStatic object) have a new Boolean property called singleQxlPci User will have the ability to check/uncheck this feature via the admin portal under the console version. User can also use that via oVirt API as well as the REST API under VM or VMStatic objects.

## Behaviour

The Single Qxl Pci will be enable by default for Linux based VMs.

## Limitation

oVirt will support only cluster 3.3 and higher and only for Qxl (Spice) display type, VNC display type is not supported for this feature. Only Linux based OS will support this feature.

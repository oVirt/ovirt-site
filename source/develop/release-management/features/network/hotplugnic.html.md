---
title: HotplugNic
category: feature
authors: danken, ekohl, ilvovsky, moti
feature_name: Hotplug/Hotunplug of Network Interface Cards
feature_modules: vdsm,engine,api
feature_status: Released
---

# Hotplug Nic

## Hotplug/Hotunplug of Network Interface Cards

### Summary

Allow to hot plug and unplug a NIC to/from running guest.

### Owner

*   Name: Igor Lvovsky (MyUser)

<!-- -->

*   Email: ilvovsky@redhat.com

### Current status

*   [Features/Design/DetailedHotPlugNic](/develop/release-management/features/ux/detailedhotplugnic/)
*   Last Update: Feb 1 20012

### Detailed Description

Today it is not allowed to plug or unplug NIC to/from running guest. In order to improve a user experience a new APIs will be introduced which will allow to hot plug/unplug NIC in running VM.

### Benefit to oVirt

The following feature will improve user experience and will add flexibility for using VMs.

### Dependencies / Related Features

This feature is depends from [Features/Design/StableDeviceAddresses](/develop/release-management/features/ux/design/stabledeviceaddresses/) feature that introduce a new device's parameter layout

Affected oVirt projects:

*   VDSM
*   REST
*   Engine-core
*   Webadmin
*   User Portal

### Documentation / External references




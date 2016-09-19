---
title: HotplugNic
category: feature
authors: danken, ekohl, ilvovsky, moti
wiki_category: Feature
wiki_title: Features/HotplugNic
wiki_revision_count: 4
wiki_last_updated: 2014-05-01
feature_name: Hotplug/Hotunplug of Network Interface Cards
feature_modules: vdsm,engine,api
feature_status: Released
---

# Hotplug Nic

## Hotplug/Hotunplug of Network Interface Cards

### Summary

Allow to hot plug and unplug a NIC to/from running guest.

### Owner

*   Name: [ Igor Lvovsky](User:MyUser)

<!-- -->

*   Email: ilvovsky@redhat.com

### Current status

*   <http://www.ovirt.org/wiki/Features/Design/DetailedHotPlugNic>
*   Last Update: Feb 1 20012

### Detailed Description

Today it is not allowed to plug or unplug NIC to/from running guest. In order to improve a user experience a new APIs will be introduced which will allow to hot plug/unplug NIC in running VM.

### Benefit to oVirt

The following feature will improve user experience and will add flexibility for using VMs.

### Dependencies / Related Features

This feature is depends from <http://www.ovirt.org/wiki/Features/Design/StableDeviceAddresses> feature that introduce a new device's parameter layout

Affected oVirt projects:

*   VDSM
*   REST
*   Engine-core
*   Webadmin
*   User Portal

### Documentation / External references

### Comments and Discussion



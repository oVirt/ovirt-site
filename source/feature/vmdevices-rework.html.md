---
title: VmDevices rework
authors: danken, mpolednik
wiki_title: Feature/VmDevices rework
wiki_revision_count: 22
wiki_last_updated: 2015-05-04
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# VmDevices rework

### Summary

This feature will track the refactoring and reworking of VmDevices inside VDSM.

### Owner

*   Name: [Martin Polednik](user:Martin%20Polednik)
*   Email: <mpolednik@redhat.com>

### Current status

*   Last updated date: Thu Apr 23 2015

### Current state of devices

Currently, there are multiple representations of a device in it's lifetime inside VDSM. In order to work with them, it makes sense to formalize the naming of representations:

*   `{'device': '...', 'type': '...', 'deviceId', ...}` is the format in which the device is specified in configuration sent from engine. We will call this a *device specification* `dev_spec`.
*   `[device_spec]` denotes a list of device specifications. Generally, we want to avoid extra long names and will therefore call it **specification list** `spec_list`.
*   `{device_type: [device_spec]}` is an internal format of VM's conf['devices'], that we will call *device mapping* `dev_map`.
*   Legacy VM conf section will be called *legacy conf*.
*   And current VM conf section *conf*
*   `` is python object representing the device, *device object* `dev_object` and plural *device objects* `dev_objects`

### Phase 1

Using the names defined above, the first phase of devices rework will consist of removing device-specific code in vm.py and moving it to vmdevices/${device}.py, using consistent naming conventions. One of the first thing is isolating device object creation from _run method of VM class. This will allow us to work with multiple device objects in unit tests, possibly leading to better tests.

#### Phase 1.1

VM class's _run method contains a code that, given a device mapping, generates device objects and stores them in VM._devices attribute. The first step is simply moving this code to a new method and naming it correctly: `devObjectsFromDevMap` (lowerCamelCase for the sake of consistency). This is also opportunity to rename `buildConfDevices` to something a bit more descriptive and accurate: `devMapFromConf`. The flow inside VDSM will therefore be

def _run():

        ...
        dev_map = devMapFromConf()
        ...
        self._devices = devObjectsFromDevMap(dev_map)

---
title: VmDevices rework
authors: danken, mpolednik
wiki_title: Feature/VmDevices rework
wiki_revision_count: 22
wiki_last_updated: 2015-05-04
---

# VmDevices rework

### Summary

This feature will track the refactoring and reworking of VmDevices inside VDSM.

### Owner

*   Name: [ Martin Polednik](User:Martin Polednik)
*   Email: <mpolednik@redhat.com>

### Current status

*   Last updated date: Thu Apr 23 2015

### What is wrong with current state

*   Information duplication - the data is kept in device objects AND self.conf['devices'] dictionary
*   Most of the functionality is in the VM class itself (while device modules would be more suitable)
*   Above goes for legacy device configuration and getUnderlying\* family of methods
*   The code is not well tested
*   Libvirt XML parsing and processing is dumb - missing orchestration object to delegate XML chunks to devices themself

### Formal naming system

Currently, there are multiple representations of a device in it's lifetime inside VDSM. In order to work with them, it makes sense to formalize the naming of representations:

*   `{'device': '...', 'type': '...', 'deviceId', ...}` is the format in which the device is specified in configuration sent from engine. We will call this a <i>device specification</i> `dev_spec`.
*   `[device_spec]` denotes a list of device specifications. Let's call it <i>device specification list<i> `dev_spec_list`.
*   Legacy VM conf section will be called <i>legacy conf</i>.
*   And current VM conf section <i>conf</i>.
*   `<Sound object at...>` is python object representing the device, <i>device object</i> `dev_object` and plural <i>device objects</i> `dev_objects`.
*   `{device_type: [device_object]}` is an internal format of VM's _devices, that we will call <i>device mapping</i> `dev_map`.
*   `{device_type: [device_spec]}` is a format used for transition from device specification list to device mapping - <i>device specification map</i> `dev_spec_map`.
*   When initializing an empty structure, prefix with `empty`.

<!-- -->

*   Type of the device is `dev_type`.
*   Class of the device is `dev_class`.

The `dev_` prefix can be omitted if for each occurrence of function/method call there exists a \*device\* word in one of the namespaces accessed.

### Phase 1

Using the names defined above, the first phase of devices rework will consist of removing device-specific code in vm.py and moving it to vmdevices/${device}.py, using consistent naming conventions. One of the first thing is isolating device object creation from _run method of VM class. This will allow us to work with multiple device objects in unit tests, possibly leading to better tests.

#### Phase 1.1

VM class's _run method contains a code that, given a device mapping, generates device objects and stores them in VM._devices attribute. The first step is simply moving this code to a new method and naming it correctly: `devObjectsFromDevMap` (lowerCamelCase for the sake of consistency). This is also opportunity to rename `buildConfDevices` to something a bit more descriptive and accurate: `devSpecMapFromConf`. The flow inside VDSM will therefore be

    def _run():
        ...
        dev_spec = devSpecMapFromConf()
        ...
        self._devices = devMapFromDevSpecMap(dev_spec)

#### Phase 1.2

Legacy configuration had lower number of devices than current conf has. There exists a code that, given legacy conf, returns correct specification list. These devices are Drive, NetworkInterfaceController, Sound, Video, Graphics and Controller. The legacy methods called getConf${device} are currently in VM class. One possible destination for these methods are the device modules (not the classes). Moving them and respecting pep8 yields module functions `spec_list_from_legacy_conf`. This also requires purification of the methods, which isn't exactly complex because each one of them contains reference to VM's conf and possibly arch. Therefore, to make them easily iterable, the final signature should be `spec_list_from_legacy_conf(conf, arch)`.

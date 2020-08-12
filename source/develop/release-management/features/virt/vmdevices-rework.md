---
title: VmDevices rework
authors: danken, mpolednik
---

# VmDevices rework

## Summary

This feature will track the refactoring and reworking of VmDevices inside VDSM.

## Owner

*   Name: Martin Polednik (Martin Polednik)

## Current status

*   Last updated date: Thu Apr 28 2015
*   [gerrit topic branch](https://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:device_isolation)

## What is wrong with current state

*   Information duplication - the data is kept in device objects AND self.conf['devices'] dictionary
*   Most of the functionality is in the VM class itself (while device modules would be more suitable)
*   Above goes for legacy device configuration and getUnderlying\* family of methods
*   The code is not well tested
*   libvirt XML parsing and processing is ineffective - it loops all device elements in libvirt XML for every device, leading to quadratic asymptotic time complexity

## Formal naming system

Currently, there are multiple representations of a device in its lifetime inside VDSM. In order to work with them, it makes sense to formalize the naming of representations:

*   `{'device': '...', 'type': '...', 'deviceId', ...}` is the format in which the device is specified in configuration sent from engine. We will call this a <i>device specification</i> `dev_spec`.
*   `[device_spec]` denotes a list of device specifications. Let's call it <i>device specification list<i> `dev_spec_list`.
*   Legacy VM conf section will be called <i>legacy conf</i>.
*   And current VM conf section <i>conf</i>.
*   `<Sound object at...>` is python object representing the device, <i>device object</i> `dev_object` and plural <i>device objects</i> `dev_objects`.
*   `{device_type: [device_object]}` is an internal format of VM's _devices, that we will call <i>device mapping</i> `dev_map`.
*   `{device_type: [device_spec]}` is a format used for transition from device specification list to device mapping - <i>device specification map</i> `dev_spec_map`.
*   When initializing an empty structure, prefix with `empty`.

<!-- -->

*   Type of the device is `dev_type`. Examples: sound device, disk devices, host devices, ...
*   Class of the device is `dev_class`. Examples: `Drive`, `NetworkInterfaceDevice`, `GraphicsDevice`, ...

The `dev_` prefix can be omitted if for each occurrence of function/method call there exists a \*device\* word in one of the namespaces accessed.

      PEP8: we're trying to make the code as consistent as possible while slowly converting everything to be pep8 compliant. Therefore, following rules can be used:

*   use pep8 conventions in new modules,
*   use pep8 conventions in old module if the code is about to move,
*   stay consistent within the file.

## Phase 1 - vm.py diet

Using the names defined above, the first phase of devices rework will consist of removing device-specific code in vm.py and moving it to vmdevices/${device}.py, using consistent naming conventions. One of the first thing is isolating device object creation from _run method of VM class. This will allow us to work with multiple device objects in unit tests, possibly leading to better tests.

### Phase 1.1

VM class's _run method contains a code that, given a device mapping, generates device objects and stores them in VM._devices attribute. The first step is simply moving this code to a new method and naming it correctly: `devObjectsFromDevMap` (lowerCamelCase for the sake of consistency). This is also opportunity to rename `buildConfDevices` to something a bit more descriptive and accurate: `devSpecMapFromConf`. The flow inside VDSM will therefore be

    def _run():
        ...
        dev_spec = devSpecMapFromConf()
        ...
        self._devices = devMapFromDevSpecMap(dev_spec)

### Phase 1.2

Legacy configuration had lower number of devices than current conf has. There exists a code that, given legacy conf, returns correct specification list. These devices are Drive, NetworkInterfaceController, Sound, Video, Graphics and Controller. The legacy methods called getConf${device} are currently in VM class. One possible destination for these methods are the device modules (not the classes). Moving them and respecting pep8 yields module functions `spec_list_from_legacy_conf`. This also requires purification of the methods, which isn't exactly complex because each one of them contains reference to VM's conf and possibly arch. Therefore, to make them easily iterable, the final signature should be `spec_list_from_legacy_conf(conf, arch)`.

### Phase 1.3

Support for engine <3.3 was removed in <https://gerrit.ovirt.org/#/c/40104/> and therefore, legacy code for device creation shouldn't really exist. Complication is that there may be tests using this legacy configuration, therefore simple removal may not be the best solution. The methods used for legacy devices should therefore be marked as deprecated in the documentation (if they are documented at all) and should at least log some deprecation warning.

## Phase 2 - Reading libvirt XML

Some (most?) of the device types have a code to parse the libvirt XML, find the device in device mapping and update it according to the real specification in libvirt's XML. The code is currently encapsulated in methods called `getUnderlying${device_class}DeviceInfo` in class VM (vm.py). There are multiple issues with the code and it's placement, therefore we will need few phases to get it somewhat correct.

### Phase 2.1

First, the code accesses internal VM attributes such as `_devices` and `conf['devices']`(possibly more) and cannot be moved as they are. To move them, we need to make them pure and then the move is possible - because it doesn't really change functionality or anything, this can be done in a single step. Two methods must be kept at this point: getUnderlyingDeviceInfo and getUnderlyingUnknownDeviceInfo. The former is entry point for the moved function while the later one, as the name suggests, parses the devices that aren't known to VDSM.

### Phase 2.2

## Final Goal

The device classes and modules would hold all methods, data and classes necessary to fully maintain the device. vm.py file, with a bit of luck, can be reduced by up to ~700 lines. conf['devices'] and _devices would be merged into a single entity that provides interface for legacy access but internally keeps all the information in device objects.

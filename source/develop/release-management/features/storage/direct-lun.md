---
title: Direct Lun
category: feature
authors: derez, eduardo, ekohl, ilvovsky, lpeer, mkublin, sandrobonazzola
---

# Direct LUN

# Introduction

Any block device can be used as local disk in the VM specifying it's GUID.

# OVIRT flows

These flows should be supported from the GUI.

*   Add disk

1.  Discovery targets
2.  Connect to the target
3.  Get device list
    -   Return GUID and connection parameters

4.  Choose a block device:
    -   default: Unattached devices
    -   option: From a VM (+ plug)

*   Attach to VM (+ plug)

1.  Select VM
2.  Select or import disk
3.  Plug it
    -   If the VM is not running, the disk target connection should be added to the required connections for the VM.
    -   If the VM is running:
        1.  Engine should assert that the backing storage target is reachable or connect it to the host running the VM.
        2.  Do hot plug.

*   Run VM

1.  Async manage disk target connection on [all](#notes) hosts for all the required disks/domains.
2.  Wait on connection on the preferred host.
    -   If succeded, RunVM
    -   If not immediately try next hosts until success.

*   Hot plug

1.  Engine should assert that the backing storage target is reachable or connect it to the host running the VM.
2.  Do hot plug.

*   Hot unplug

1.  Do unplug.
2.  Unmanage the target disk connection.

*   Migration

1.  Engine should assert that the backing storage target is reachable or connect it to the VM [**destination host**](#notes).
2.  Do migration.

*   Stop VM

1.  Stop the VM.
2.  Unmanage the target disk connection.

*   HA

1.  Engine should assert that the backing storage target is reachable or connect it to the VM [**destination host**](#notes).
2.  Restart the VM

The following UI mockups contain guidelines for the different screens and wizards:

**Add description to the object in the UI.**

**Change the import term in the UI (mockup).**

**\1**

![](/images/wiki/Import_direct_lun.png)

**Attach and detach should be part of the VM interface.**

**\1**

**\1**

*' No filter on the LUNs, used disks may be grayed out.*'

![](/images/wiki/Attach_direct_lun.png)

# Rest API

= Will be added an option to pass a direct lun object via API, all other APIs will be the same

# Engine - VDSM API

A new API is added for this feature.

The API specifies a block device by GUID or UUID, instead of the PDIV quartet of a regular VDSM volume.

Other disk device parameters are the same as in VDSM volumes.

    'devices': [
           {'type': 'disk',
            'device': 'disk',
            'iface': 'virtio|ide',
            'index': <int>,                            <--- disk index unique per 'iface' virtio|ide
            'GUID': 'shared disk GUID',                <--- Should be passed instead the PDIV
            'address': 'PCI|IDE address dictionary',   <--- PCI = {'type':'pci', 'domain':'0x0000', 'bus':'0x00', 'slot':'0x0c', 'function':'0x0'} ,  
                                                            IDE = {'type':'drive', 'controller':'0', 'bus':'0', 'unit':'0'}
                                                            Only if known.
            'format': 'raw',                           <--- Only raw disks are supported.
            'bootOrder': <int>,                        <--- global boot order across all bootable devices
            'propagateErrors': 'off',
            'shared': 'True|False',                    <--- whether disk is shared
            'optional': 'True|False',                  <--- whether disk is optional (VM can be run without optional disk if inaccessible)
                                                            THIS FEATURE IS UNSUPPORTED YET!
            'readonly': 'True|False'}

The *GUID* is returned in the getDeviceList response.

Will be a query relating the "name" of the disk and all of the connection details providing the WWID.

VM disks specified this way should support all the modes and features, i.e Sharable, Hot-Plug, etc.

See [Stable Device Addresses](/develop/release-management/features/virt/stabledeviceaddresses.html) for the complete device interface.

# Engine considerations

## The vDisk entity

*   Engine should have an abstraction that contains:
    -   Backing storage (returned by getDeviceList or equivalent).
    -   Connection to the backing storage.
    -   The image stack (history).
    -   Other Engine required info.

This object will be called a **vDisk**.

A vDisk represents the time evolution of a VM or floating disk and extra Engine data.

It's started from a *single* block device returned by getDeviceList (or equivalent function).

Creating a new entity from the same block device should result in the [same](#notes) vDisk entity.

Successive snapshots creates new (time stamp, image UID) entries.

The image UID can be transferred to runVM, hot-plug, migrate, etc.

Before starting of any operations Engine should assert that the [**destination host**](#notes) is connected to the target.

The LunID is the GUID (WWID) and should be used for identify the disk.

May be the name (= alias) be the filled automatically as the WWID. The description will be used if not.

In case RHEV-M not provides the GUID should used for the description when creating the external disk

LUNs from a SD can be used as direct LUN.

Multiple uses of a LUN for different SD is prevented.

## The Engine design

*   Adding of new lun to vm:
    -   Choose some host
    -   Connect a lun in asynchronous way to every host in pool
    -   Wait for success connection with first host, at case it failed check a result for a next host in list
    -   When connection with host successes, engine will consider that all other hosts successes to connect with lun, engine will not wait for results for all

<!-- -->

*   Changes at scenarious
    -   During RunVm and MigrationVm engine will check if appropriate host is connected to lun of vm, if yes the vm will be run or migrate, if host is not connected a choosen host will not be calculated as missed try

# Notes

1.  If two vDisks can be based on the same backing storage is still on discussion.
2.  A short set in the future.
3.  <dt>
    Destination host

<dd>
the host running or that will run the VM.

[Direct_Lun](/develop/release-management/features/) [Direct_Lun](/develop/release-management/releases/3.1/featurelist.html)

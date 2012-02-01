---
title: Direct Lun
category: feature
authors: derez, eduardo, ekohl, ilvovsky, lpeer, mkublin, sandrobonazzola
wiki_category: Feature|Direct_Lun
wiki_title: Features/Direct Lun
wiki_revision_count: 50
wiki_last_updated: 2015-01-16
---

# Direct Lun

## Introduction

Any block device can be used as local disk in the VM specifying it's GUID.

## OVIRT flows

These flows should be supported from the GUI.

*   Import disk

1.  Discovery targets
2.  Connect to the target
3.  Get device list
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

*   Hot plug

1.  Engine should assert that the backing storage target is reachable or connect it to the host running the VM.
2.  Do hot plug.

*   Migration

1.  Engine should assert that the backing storage target is reachable or connect it to the VM [**destination host**](#Notes).
2.  Do migration.

*   HA

1.  Engine should assert that the backing storage target is reachable or connect it to the VM [**destination host**](#Notes).
2.  Restart the VM

## Engine - VDSM API

A new API is added for this feature.

The API specifies a block device by GUID or UUID, instead of the PDIV quartet of a regular [VDSM volume](Live_Snapshots#Introduction).

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

VM disks specified this way should support all the modes and features, i.e Shared Hot-Plug, etc.

See [Stable Device Addresses](Features/Design/StableDeviceAddresses) for the complete device interface.

## Engine considerations

### The vDisk entity

*   Engine should have an abstraction that contains:
    -   Backing storage (returned by getDeviceList or equivalent).
    -   Connection to the backing storage.
    -   The image stack (history).
    -   Other Engine required info.

This object will be called a **vDisk**.

A vDisk represents the time evolution of a VM disk and extra Engine data.

It's started from a *single* block device returned by getDeviceList (or equivalent function).

Creating a new entity from the same block device should result in the [same](#Notes) vDisk entity.

Successive snapshots creates new (time stamp, image UID) entries.

The image UID can be transferred to runVM, hot-plug, migrate, etc.

Before starting of any operations Engine should assert that the [**destination host**](#Notes) is connected to the target

## Notes

1.  If two vDisks can be based on the same backing storage is still on discussion.
2.  <dt>
    Destination host

<dd>
the host running or that will run the VM.

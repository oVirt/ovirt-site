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

Any block device can be used as local disk in the VM specifying it's GUID or UUID.

## Engine - VDSM API

A new API is added for this feature.

The API specifies a block device by GUID or UUID, instead of the PDIV quartet of a regular [VDSM volume](Live_Snapshots#Introduction).

Other disk device parameters are the same as in VDSM volumes.

    'devices': [   
           {'type': 'disk',
            'device': 'disk',
            'iface': 'virtio|ide',
            'index': <int>,                            <--- disk index unique per 'iface' virtio|ide
            'UUID': 'shared disk UUID',                <--- Should be passed on of 2 options
            'GUID': 'shared disk GUID'}
        <--- Optional:
            'address': 'PCI|IDE address dictionary',   <--- PCI = {'type':'pci', 'domain':'0x0000', 'bus':'0x00', 'slot':'0x0c', 'function':'0x0'} ,  
                                                            IDE = {'type':'drive', 'controller':'0', 'bus':'0', 'unit':'0'}
                                                            Only after the VM was running, if you want stable addresses.
            'format': 'raw',                           <--- Only raw disks are supported.
            'bootOrder': <int>,                        <--- global boot order across all bootable devices
            'propagateErrors': 'off',
            'shared': 'True|False',                    <--- whether disk is shared
            'optional': 'True|False',                  <--- whether disk is optional (VM can be run without optional disk if inaccessible)
                                                            THIS FEATURE IS UNSUPPORTED YET!
            'readonly': 'True|False',

See [Features/Design/StableDeviceAddresses](Features/Design/StableDeviceAddresses) for the complete device interface.

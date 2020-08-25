---
title: CD-ROM support for block storage
category: feature
authors: vjuranek, nsoffer
feature_name: CD-ROM support for block storage
feature_modules: engine,vdsm
feature_status: Design
---

# CD-ROM support for block storage


## Summary

This feature adds new implementation for CD-ROM management no block storage domains,
namely for loading, ejecting and changing CD-ROM.

## Owner

- Vojtech Juranek (<vjuranek@redhat.com>)

## Overview

### What was available before this feature?

Before this feature, oVirt engine provided functions for changing and ejecting CD-ROM.
However, non of these functions worked properly with block based storage.
Changing CD failed on block storage as the appropriate volume wasn't activated.
Ejecting CD failed to deactivate the volume.
For more details, see following bugs.

#### CD-ROM related XML

Currently each VM contains CD-ROM (without CD), e.g.

```xml
    <disk type='file' device='cdrom'>
      <driver name='qemu' error_policy='report'/>
      <source startupPolicy='optional'/>
      <target dev='sdc' bus='sata'/>
      <readonly/>
      <alias name='ua-79287c04-4eea-4db7-a376-99a9f85ad0ed'/>
      <address type='drive' controller='0' bus='0' target='0' unit='2'/>
    </disk>
```

When VM is booted with CD, it chages e.g. to

```xml
    <disk type='block' device='cdrom'>
      <driver name='qemu' type='raw' error_policy='report'/>
      <source dev='/rhev/data-center/mnt/blockSD/88252cf6-381e-48f0-8795-a294a32c7149/images/89f05c7d-b961-4935-993f-514499024515/626a493f-5214-4337-b580-96a1ce702c2a' index='2'>
        <seclabel model='dac' relabel='no'/>
      </source>
      <backingStore/>
      <target dev='sdc' bus='sata'/>
      <readonly/>
      <alias name='ua-79287c04-4eea-4db7-a376-99a9f85ad0ed'/>
      <address type='drive' controller='0' bus='0' target='0' unit='2'/>
    </disk>
```

so that it contains path to the ISO.

Besides this libvirt XML, oVirt adds its own XML for each disk to be able to identify
the volume by PDIV (pool, domain, image volume) coordinates and includes other useful info like lease path. e.g.

```xml
    <ovirt-vm:device devtype="disk" name="sdc">
        <ovirt-vm:domainID>88252cf6-381e-48f0-8795-a294a32c7149</ovirt-vm:domainID>
        <ovirt-vm:imageID>89f05c7d-b961-4935-993f-514499024515</ovirt-vm:imageID>
        <ovirt-vm:poolID>13345997-b94f-42dd-b8ef-a1392f65cebf</ovirt-vm:poolID>
        <ovirt-vm:volumeID>626a493f-5214-4337-b580-96a1ce702c2a</ovirt-vm:volumeID>
        <ovirt-vm:volumeChain>
            <ovirt-vm:volumeChainNode>
                <ovirt-vm:domainID>88252cf6-381e-48f0-8795-a294a32c7149</ovirt-vm:domainID>
                <ovirt-vm:imageID>89f05c7d-b961-4935-993f-514499024515</ovirt-vm:imageID>
                <ovirt-vm:leaseOffset type="int">105906176</ovirt-vm:leaseOffset>
                <ovirt-vm:leasePath>/dev/88252cf6-381e-48f0-8795-a294a32c7149/leases</ovirt-vm:leasePath>
                <ovirt-vm:path>/rhev/data-center/mnt/blockSD/88252cf6-381e-48f0-8795-a294a32c7149/images/89f05c7d-b961-4935-993f-514499024515/626a493f-5214-4337-b580-96a1ce702c2a</ovirt-vm:path>
                <ovirt-vm:volumeID>626a493f-5214-4337-b580-96a1ce702c2a</ovirt-vm:volumeID>
            </ovirt-vm:volumeChainNode>
        </ovirt-vm:volumeChain>
    </ovirt-vm:device>
```

When CD is not loaded, this element is still present (as CD-ROM is always present), but is empty, e.g.:

```xml
    <ovirt-vm:device devtype="disk" name="sdc"/>
```

### Bugs

- [Bug 1589763: Error changing CD for a running VM when ISO image is on a block domain](https://bugzilla.redhat.com/1589763)
- [Bug 1868643: Volume not deactivated after ejecting CDROM](https://bugzilla.redhat.com/1868643)


### Functionality added with this feature

This feature reworks existing vdsm API for loading, ejecting and
changing CD to be able to work on block storage domains.
From implementation point of view it is only one function,`ChangeCD`.
This function will handle all aforementioned cases - loading CD, ejecting CD and changing CD.
It  will also ensure, that the CD will be changed atomically.
This means that the change either happens or previous state will be preserved,
e.g. if user wants to change CD by another and activation of new CD fails, CDROM will still hold
old CD once the operation finishes.


#### Vdsm

- Rework `VM.changeCD` API implementation.
- Updated recovery flow to check `status` flag for CDs.
- If ISO is not specified by PDIV but by path, fall back to old behaviour.


### Flows

#### VM with empty tray, insert CD

1. engine sends `changeCD` command, specifying ISO by PDIV format.
1. add new drive spec to VM metadata with new attribute `state="loading"`
```xml
    <ovirt-vm:device devtype="disk" name="sdc" state="loading">
```
1. prepare new drive spec
  - if failed:
      1. remove drive spec (log errors)
      1. fail the flow with original error
1. loads CD into VM
  - if failed:
      1. tear down the volume (log error)
      1. remove the drive spec (log error)
      1. fail the flow with the original error
1. remove `state` attribute from VM metadata
  - if failed: log the error and succeed


#### VM with loaded CD, eject CD

1. engine sends `changeCD` command with empty PDIV format.
1. vdsm updates VM metadata with new attribute `state="ejecting"`:
```xml
    <ovirt-vm:device devtype="disk" name="sdc" state="ejecting">
```
1. vdsm eject CD from VM (calling libvirt `updateDeviceFlags()`)
  - if failed (e.g. timeout?):
      1. remove the `state` attribute (log error)
      1. fail with original error
1. tear down drive spec
  - if tearing down volume fails: log error if volume used by another VM and succeed
  - if error is anything else except device in use error, remove `state` attribute from metadata, re-throw the exception and fail
1. remove drive spec from VM metadata
  - if failed: log error and succeed


#### VM with loaded CD, changeCD

1. engine sends `changeCD`, specifying new ISO path by PDIV format and also path.
1. update exiting drive spec for loaded CD with `state="ejecting"`:
```xml
    <ovirt-vm:device devtype="disk" name="sdc" state="ejecting">
```
1. add another drive spec to VM metadata for CD being loaded with attribute `state="loading"`
```xml
    <ovirt-vm:device devtype="disk" name="sdc" state="loading">
```
1. prepare new drive spec
  - if failed:
      1. remove `state="ejecting"` from loaded CD metadata
      1. remove newly added drive spec (log errors)
      1. fail the flow with original error
1. loads new CD into VM (by calling libvirt `updateDeviceFlags()`)
  - if failed:
    1. tear down new CD volume (log error)
    1. remove the new CD drive spec (log error)
    1. remove `state="ejecting"` from old drive spec metadata
    1. fail the flow with the original error
1. remove the `state="loading"` attribute from new drive spec metadata
  - if failed: log the error and continue
1. tear down old drive spec
  - if failed (e.g. timeout?):
      1. log the error and continue (tearing down new CD would probably fail
      as well and we would end up with unused activated volume anyway, so
      there's no reason to fail it now)
1. remove old CD drive spec
  - if failed: log the error and succeed


#### VM recovery flow

Try to cleanup storage leftovers from loading and ejecting operations without changing VM state.


##### VM with empty tray, insert CD

1. metadata `state="loading"`, there are no other matadata for CDROM, volume is prepared, CD is loaded
  - remove `state="loading"` from metadata from XML
1. metadata `state="loading"`, there are no other matadata for CDROM, volume is prepared, CD isn't loaded
  - tear down the volume and remove drive spec from XML
1. metadata `state="loading"`, there are no other matadata for CDROM, volume is torn down, CD isn't loaded
  - remove drive spec metadata


##### VM with loaded CD, eject CD

1. metadata `state="ejecting"`, there are no other matadata for CDROM, volume is prepared, CD is loaded
  - remove `state="ejecting"` from metadata from XML
1. metadata `state="ejecting"`, there are no other matadata for CDROM, volume is prepared, CD not loaded
  - tear down the volume and remove `state="ejecting"` from metadata from XML
1. metadata `state="ejecting"`, there are no other matadata for CDROM, volume is torn down, CD not loaded
  - remove `state="ejecting"` from metadata from XML


##### VM with loaded CD, changeCD

1. metadata `state="ejecting"`, there are no other matadata for CDROM
  - see previous paragraph
1. there are two metadata for CDROM, one with `state="ejecting"`, second with `state="loading"`, volume for loading is torn down
  - remove metadata for loading from VM XML
  - remove `state="ejecting"` from ejecting metadata
1. there are two metadata for CDROM, one with `state="ejecting"`, second with `state="loading"`, volume for loading is prepared, CDROM still contains ejecting CD
  - tear down loading CD volume
  - remove metadata for loading CD
  - remove `state="ejecting"` from metadata
1. there are two metadata for CDROM, one with `state="ejecting"`, second with `state="loading"`, volume for loading is prepared, CDROM still contains loading CD
  - tear down ejecting CD volume
  - remove metadata for ejecting CD
  - remove `state="loading"` from metadata
1. there are two metadata for CDROM, one with `state="ejecting"`, second without `state` attribute, volume for ejected CD is prepared
  - tear down ejecting CD volume
  - remove metadata for ejecting CD
1. there are two metadata for CDROM, one with `state="ejecting"`, second without `state` attribute, volume for ejected CD is torn down
  - remove metadata for ejecting CD


`state` attribute is an optimization for easy cleanup.
E.g. in case of hot disk plug, this is not used and if vdsm fails between activation of the volume
and pluging disk into VM, unused active disk is left in the storage.


### Changes in Engine

Engine will only use PDIV in ChangeCD command and there will be no changes visible to the user.

- Update ChangeCD to use PDIV for CD specification on 4.5 cluster version


### Changes in SDK

`VmCdromResource` used SDK uses `ChangeDisk` command.
Once internal engine implementation will switch to using PDIV, this will be available also in SDK.
Therefore, similarly to engine, there will be no changes in public SDK API visible to user.


## Installation/Upgrade

Changed implementation of `ChangeCD` we delivered with new vdsm packages containing these changes.
Changes in engine will require appropriate vdsm version to use new vdsm APIs.
Once user upgrades to this engine version, changes will be available to the user.

New `ChangeCD` implementation will be used for ISOs on DATA domains.
Old  `ChangeCD` implementation will be used for ISOs on old ISO domains.


## Testing

### Test setup

- create block storage domain
- upload an ISO into block storage domain
- create VM with CD

### Preposed testing scenarios

- eject CD from CD-ROM
  - verify CD was removed in engine UI
  - verify that metadata related to this CD-ROM was removed from VM XML
  - verify ISO volume was deactivated on the host

- load CD into CD-ROM
  - verify CD was loaded in engine UI
  - verify that metadata related to this CD-ROM was added into VM XML
  - verify ISO volume was activated on the host
  - verify ISO is not visible to VM (e.g by running `virsh domblklist`)

- eject CD from CD-ROM
  - verify CD was removed in engine UI
  - verify that metadata related to this CD-ROM was removed from VM XML
  - verify ISO volume was deactivated on the host
  - verify ISO is visible to VM (e.g by running `virsh domblklist`)

- change CD in CD-ROM
  - verify new CD was loaded in engine UI
  - verify that metadata related to old CD-ROM was removed from VM XML
  - verify that metadata related to new CD-ROM was added into VM XML
  - verify old ISO volume was deactivated on the host
  - verify new ISO volume was activated on the host
  - verify old ISO is not visible to VM (e.g by running `virsh domblklist`)
  - verify ISO is visible to VM (e.g by running `virsh domblklist`)


### Related links

- [Discussion in ovirt devel mailing list.](https://www.mail-archive.com/devel@ovirt.org/msg16082.html)
- [Bug 1725915: Vdsm tries to tear down in-use volume of ISO in block storage domain](https://bugzilla.redhat.com/1725915)



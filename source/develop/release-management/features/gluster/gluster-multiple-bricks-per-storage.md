---
title: Support for multiple GlusterFS bricks on a block device(s)
category: feature
authors: dchaplyg
---

# Support for multiple GlusterFS bricks on a block device(s)

# Summary

This feature introduces ability to create multiple GlusterFS bricks on the same block device(s).

Having one (or more) physical block device, user should be able to create a LVM volume group on top of it and use LVM logical volumes as a brick backend device. That approach will allow better management of the local storage alongside with support for thin provisioning for the GlusterFS and SSD caching.

## Owner

*   Name: [Denis Chaplygin](https://github.com/akashihi)

## Current status

*   Target Release: 4.3
*   Status: Planning
*   Last updated: January 08, 2018

# Detailed description

Current oVirt's GlusterFS brick/volume management implementation implies that bricks should occupy the whole block device, thus limiting possible number of bricks to the number of physically available block devices. That approach could be quite limiting, especially in case of small deployments or hyperconverged environments, when you have just one or two relatively big drives for you VM payloads.

This change will introduce multiple bricks sharing same block device into oVirt, thus allowing users to manage their local storage using oVirt UI and use LVM logical volumes as a block devices for GlusterFS bricks. It will also bring LVM specific features, such as thin provisioning and SSD caching.

# Implementation details

## Engine

* Engine should support creation of physical volumes, volume groups and logical volumes. This can be implemented using engine Ansible integration, to not to pollute vdsm with that code. Engine should be able to retrieve current LVM configuration.
* Engine should support LVM thin pools and allow creation of thin logical volumes. Thin pool implementation details should be hidden from the user.
* Alongside with thin pools, engine must support SSD caching configuration. Implementation details should be hidden from the user.
* Thin pool support adds a 'second' size to the logical volumes (and, therefore, to gluster bricks, gluster volumes and storage domains running on top of them) - with thin pool every logical volume will have a 'reported' size and 'physical' size. First one, 'reported' is a size of a logical volume, as reported by df command or similar. 'Physical' size is a size of thin pool itself. Obviously, they could differ and actual usage of both filesystem and thin pool may differ, so both sizes must be reported by vdsm to the engine, stored at the database and presented to the user.
* It would be nice if engine will actually know type of each block device (solid/spinning) and will only allow solid drives to be used as SSD cache. We need that information to be reported by VDSM and stored at the database.

## VDSM

* VDSM LVM filtering needs to work correctly with new engine LVM management.
* VDSM should report underlying thin pool size/usage, probably using additional field at VolumeGroupInfo
* VDSM should report block device type (solid/spinning), probaly using additional field at BlockDeviceInfo
* VDSM blivet support should be dropped and replaced with ansible brick/volume management at the engine side.

## REST API

* Support for additional fields, introduced above, must be added.

## oVirt UI

* 'Physical' size needs to be added alongside with existing 'reported' size field
* Gluster brick management dialog needs to be extended and support for multiple bricks on the same device should be added.
* Gluster brick management dialog should allow thin pool creation
* Gluster brick management dialog should allow SSD cache configration, only in case of presence of unused SSD block devices and, at the same time, with thin pool enabled

## Benefit to oVirt

* Simplification of hyperconverged deploys
* Fine grained local storage management

## Open issues

* [BUG-1515299: (https://bugzilla.redhat.com/show_bug.cgi?id=1515299)[RFE] - Support multiple bricks per storage device and configuring lvmcache]


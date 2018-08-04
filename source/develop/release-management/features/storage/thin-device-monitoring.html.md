# Thin device space monitoring

# Summary

oVirt, especially when used in hyperconverged environments, can report incorrect storage domain usage data, when SD is on the thinly provided device. This feature adds additional 'confirmed free space' reporting for the storage domains.

## Owner

*   Name: [Denis Chaplygin](https://github.com/akashihi)
*   Email: <dchaplyg@redhat.com>

## Current status

*   Target Release: 4.2.x
*   Status: Work in progress
*   Last updated: July 31, 2018


# Detailed description

Storage domain can be deployes on top of thin provisioned storage, like LVM thin pool or VDO deduplicated/compressed device. In that case oVirt will report 'virtual' size of a storage domain, not taking into account it's underlying limitations.

For example, storage domain of 50G size can be built on top of thin pool with size of 50G, shared with two other logical volumes. Thin pool may have only 20G of actual free space and, because of that, oVirt user will get a 'out of space' error after writing 20G to a empty 50G partition. 

As a solution of that problem, i propose to add a third monitoring parameter to the storage domain, a 'minimum guaranteed free size' or 'physical size' monitor and report that parameter.

# Implementation details

While reporting physical size seem to be simple and obvious, implementing that feature could be challenging. To make it less challenging we will limit the problem to hyperconverged deployment - storage domain on gluster volumes, made from a local storage. In that case oVirt will have a direct access to all the storage details using local VDSM.

But ieven in that case local storage data will not be enough. Gluster volume size/usage are reported per volume and are same on every gluster or vdsm host. On the other hand thin storage statistic is  reported per block device for each brick and may differ for each gluster host. Therefore we need a way to match block device to brick and brick to volume. Even worse - we may have a stack of thin devices (thin lvm on top of deduplicated device) and have to correctly resolve those dependencies.
Physical size calculation need to consider volume configuration - for distributed volumes disk space reported by block device needs to be summarized, for replica 2 volumes we need to choose smallest one and so on

## VDSM

* A special verb that will return lvm configuration (pvs/vgs/lvs) and their usage data
* A special verb, that will read /proc/vdo/<volume name> files and return vdo usage data.
Those verbs should be added to the Gluster namespace.


## Engine

* Additional field for storage domain stats that will keep a ‘physical size’
* Tree-friendly structure for keeping physical devices stats, provided by the vdsm
* Polling VDSM for the physical devices status
* Additional algorigthm that will detect correct physical size for the gluster bricks
* Physical size calculation algorithm for gluster volumes.

## REST API

* Support for additional size field

## oVirt UI

* 'Physical' size needs to be added alongside with existing 'reported' size field

# Benefit to oVirt

* Accurate reporting of thin device based storage domains stats
* Opens a way for better support of thin devices

---
title: OVirt 3.4.4 Release Notes
category: documentation
authors: sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.4.4 Release Notes
wiki_revision_count: 18
wiki_last_updated: 2014-09-25
---

# OVirt 3.4.4 Release Notes

## Install / Upgrade from previous versions

## What's New in 3.4.4?

## Known issues

## Bugs fixed

### oVirt Engine

* wrong boot order when trying to boot from CDROM while using cloud-init
 - Run vm with odd number of cores drop libvirt error
 - [Neutron integration] Custom device properties are not passed to vdsm
 - [rhevm] unable to create template from Windows 2012 guest with SPICE videocard in RHEV 3.4
 - Disks imported from Export Domain to Data Domain are converted to Preallocated after upgrade from oVirt 3.4.1 to 3.4.2
 - Fail to update VM with any field, on missing domain name.
 - Cannot add AD group to a new VM from the user portal
 - engine serves only English docs when other locales are installed
 - ovirt-engine should not store long term files in "/var/tmp/ovirt-engine/"
 - Violating hard constraint positive Affinity rule can prevent fixing the violated rule forever
 - [rhevm-cli]: update vm has no --memory_policy-guaranteed option
 - ovirt-engine currently sets the disk device to "lun" for all virtio-scsi direct LUN connections and disables read-only for these devices
 - [engine-backend] [iSCSI multipath] It's possible to remove a network from the setup even though it participates in an iSCSI multipath bond
 - [engine-backend] [iSCSI multipath] No indication that updating an iSCSI multipath bond doesn't trigger any operation from vdsm side
 - Odd vCPU topology dropped by libvirt
 - [engine-backend] [iscsi multipath] After networks replacement in an iSCSI multipath bond had failed, the bond's networks aren't being updated back
 - No link to VMs sub-collections under affinitygroups
 - engine-backup fails if bzip2 is not installed
 - Could not import a VM from export domain with raw sparse disks to a block storage domain
 - update supported PPC cpu to power8
 - Can't change a vm disk's storage domain from a file domain to a block domain when creating a template from a vm
 - Failed to remove host xxxxxxxx
 - Cannot export VM. Disk configuration (COW Preallocated) is incompatible with the storage domain type.
 - [Windows sysprep] Run Once: Special characters are not encoded in XML sysprep files for Windows 7, 8, 2008, 2012
 - Adding networks to an Iscsi Bond will remove all the other existing networks in this IscsiBond and replace them with the new added network
 - Fix operations of add,remove and list for StorageConnections in iSCSI Bond
 - RHEVM Backend : VM can be removed while in other state than down, like migrating and powering off

### oVirt Log Collector

* [log-collector] no engine.log in the final archive
 - /etc/rhevm is not collected

### oVirt Image Uploader

* rhevm-image-uploader ignores insecure option

### oVirt Hosted Engine HA

* If two hosts have engine status 'vm not running on this host' ha agent not start vm automatically

<Category:Documentation> <Category:Releases>

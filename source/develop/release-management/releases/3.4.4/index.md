---
title: oVirt 3.4.4 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 3.4.4 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.4.4 release.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4.3 Release Notes](/develop/release-management/releases/3.4.3/), [oVirt 3.4 Release Notes](/develop/release-management/releases/3.4/), [oVirt 3.3.5 release notes](/develop/release-management/releases/3.3.5/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/). For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide/) and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm)

If you're upgrading from a previous version you should have ovirt-release package already installed on your system.

You can then install ovirt-release34.rpm as in a clean install side-by-side.

If you're upgrading from oVirt 3.4.0 you can now remove ovirt-release package:

      # yum remove ovirt-release

and then just execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from 3.3.2 or later, keep ovirt-release rpm in place until the upgrade is completed. See [oVirt 3.4.0 release notes](/develop/release-management/releases/3.4/) for upgrading from previous versions.

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.4.iso`](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.4.iso)

## What's New in 3.4.4?

## Known issues

## CVE Fixed

[CVE-2014-3573](https://access.redhat.com/security/cve/CVE-2014-3573) oVirt Engine: XML eXternal Entity (XXE) flaw in backend module

## Bugs fixed

### oVirt Engine

* wrong boot order when trying to boot from CDROM while using cloud-init
 - Run vm with odd number of cores drop libvirt error
 - Duplicated CD device when creating VMs from the blank template
 - Executing multiple "template.delete" commands in parallel to "vm.delete" commands, creates a race condition which cause the Blank template to be removed from Data Center
 - [Neutron integration] Custom device properties are not passed to vdsm
 - [rhevm] unable to create template from Windows 2012 guest with SPICE videocard in RHEV 3.4
 - Disks imported from Export Domain to Data Domain are converted to Preallocated after upgrade from oVirt 3.4.1 to 3.4.2
 - Fail to update VM with any field, on missing domain name.
 - Cannot add AD group to a new VM from the user portal
 - Tracker: oVirt 3.4.4 release
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
 - Default storage type is not Shared/local in rhevm-setup
 - CVE-2014-3573 ovirt-engine-backend: oVirt Engine: XML eXternal Entity (XXE) flaw in backend module
 - Automatic provisioning ignores db password supplied in answer file
 - [Network label] RHEV does not allow adding label for a network being used by VMs
 - SNMP trap notification has missing sysUptime field

### oVirt Log Collector

* [log-collector] no engine.log in the final archive
 - /etc/rhevm is not collected

### oVirt Image Uploader

* rhevm-image-uploader ignores insecure option

### oVirt Iso Uploader

* --insecure options still requires a valid CA cert

### oVirt Hosted Engine HA

* If two hosts have engine status 'vm not running on this host' ha agent not start vm automatically

### VDSM

* Pthreading is imported too late
 - [RFE] Host Self-Health Log: network connectivity information
 - RHEV-H 20140603.2 - new FC LUNs not visible
 - multipathd reload fails when installing running vdsm in the first time on a fresh install where multipath.conf is missing
 - Incorrect usage of logrotate leads to using two different settings
 - recovery of VMs after VDSM restart doesn't work on PPC
 - Vdsm sampling threads unexpectingly stops with IOError ENODEV
 - vdsm tests do not check for sudo availability


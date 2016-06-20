---
title: oVirt 3.4.3 Release Notes
category: documentation
authors: sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.4.3 Release Notes
wiki_revision_count: 17
wiki_last_updated: 2014-08-09
---

# OVirt 3.4.3 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.4.3 release.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4.2 Release Notes](oVirt 3.4.2 Release Notes), [oVirt 3.4 Release Notes](oVirt 3.4 Release Notes), [oVirt 3.3.5 release notes](oVirt 3.3.5 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm)

You should read then our [Quick Start Guide](Quick Start Guide)

If you're upgrading from a previous version you should have ovirt-release package already installed on your system.

You can then install ovirt-release34.rpm as in a clean install side-by-side.

If you're upgrading from oVirt 3.4.0 you can now remove ovirt-release package:

      # yum remove ovirt-release
      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from 3.3.2 or later, keep ovirt-release rpm in place until the upgrade is completed. See [oVirt 3.4.0 release notes](oVirt 3.4.0 release notes) for upgrading from previous versions.

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.3-1.iso`](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.3-1.iso)

## What's New in 3.4.3?

## Known issues

## Bugs fixed

### oVirt Engine

* [Neutron Integration] Default Gateway and DNS are missing when creating Network on External Provider
 - [python-sdk] Preview snapshot action does not support passing correlation_id parameter
 - smartcard entries are duplicated every time a template is saved, resulting in unbootable VMs
 - [Python/Java SDK]HostNICLabel.add and NetworkLabel.add methods lacks expect and correlation_id parameters
 - [engine-backend] [iSCSI multipath] Internal engine error when vdsm fails to connect to storage server with IscsiNodeError
 - [engine-backend] When committing a snapshot that contains disk and conf. of the 'Active VM', engine doesn't report about the result of the operation
 - Need warning message for moving sparse disk from file to block as it will become preallocated
 - [engine-backend] [external-provider] engine failure while createVolume task is running in vdsm (as part of importing an image from glance), leaves image in LOCKED state
 - Performing Live Storage Migration when target domain equal to source domain will cause infinite loop of 'LiveMigrateDiskCommand'
 - [RFE] Wipe after Delete flag modification while VM is Up
 - RHEV needs to support 4,000 GB of Memory
 - Can't configure vNIC QoS to "unlimited" once it had been set
 - Alignment issue in VMs --> New/Edit VM --> System Tab
 - Templates not being listed under Create Pool dialog pop-up
 - [engine-backend] [iSCSI multipath] Required cluster network shouldn't be allowed to be added to an iSCSI multipath bond
 - Reduce blocking operations as part of hosts & VMs monitoring cycles
 - Run once vm via REST with <pause>true</pause> parameter, save this parameter true also in next runs
 - console icon not activated after VM start
 - User fails to get attached to a prestarted pool in case messages parameter of canRunVm is null - NPE is throwed
 - Throw IO exception for JAXB validation errors
 - notifier daemon is not keeping startup settings after upgrade to 3.3
 - [upgrade/async-tasks] 'Plugin' object has no attribute 'queryBoolean'
 - Inconsistent VirtIO direct lun disk attachment behaviour.
 - When RHEV reports a problem with a storage domain, it should report \*\*which\*\* storage domain
 - System is not power on after a fencing operation (ILO3).
 - CPU hot plug "tool tip", in VM edit dialogue, is not clear.
 - API: Interface name is not set via cloud-init api
 Bugs fixed between RC and GA:

* [RFE] remove log collector as mandatory dependency
 - Tracker: oVirt 3.4.3 release
 - Cannot run VMs on host while VM is migrating to it

### oVirt ISO Uploader

* option nossl does not work

### oVirt Log Collector

* Backport of <http://gerrit.ovirt.org/#/c/28053/> to improve performance of api after max is removed
 Bugs fixed between RC and GA

* Add log gathering for a new ovirt module (External scheduler)
 - missing sosreport.html from postgresql-report-admin

### oVirt Hosted Engine Setup

* [RFE] [ovirt-hosted-engine-setup] add support for bonded interfaces
 - [RFE] Hosted Engine deploy should support VLAN-tagged interfaces
 Bugs fixed between RC and GA

* hosted-engine --deploy does not check for NX flag

### oVirt Hosted Engine HA

Bugs fixed between RC and GA

* Migration of hosted-engine vm put target host score to zero
 - ovirt-ha-agent dead but subsys locked
 - After host restart, storage domain not mounted automatically
 - If two hosts have engine status 'vm not running on this host' ha agent not start vm automatically
 - Migration of hosted-engine vm put target host score to zero

### VDSM

* vdsm returns a value of "None" for systemFamily
 - [scale] VDSNetworkException and TimeoutException raised every 4-5 min - Host is state Connecting
 - Incorrect migration progress reporting may lead to unwanted migration cancellation
 - Can't login the hypervisor with correct password after upgrading the RHEV-H from "rhevh-6.5-20140603.2.el6ev.iso" to "rhevh-6.5-20140618.0.el6ev.iso"
 - avoid XML-RPC integer overflows in balloon stats
 - Thin provisioning disks broken on block storage when using pthreading 1.3

<Category:Documentation> <Category:Releases>

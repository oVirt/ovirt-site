---
title: oVirt 3.4.2 Release Notes
category: documentation
toc: true
authors: dougsland, sandrobonazzola
---

# oVirt 3.4.2 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.4.2 release.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4.1 release notes](/develop/release-management/releases/3.4.1/), [oVirt 3.4 Release Notes](/develop/release-management/releases/3.4/), [oVirt 3.3.5 release notes](/develop/release-management/releases/3.3.5/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/). For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide/) and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm)


If you're upgrading from a previous version you should have ovirt-release package already installed on your system.

You can then install ovirt-release34.rpm as in a clean install side-by-side.

If you're upgrading from oVirt 3.4.0 you can now remove ovirt-release package:

      # yum remove ovirt-release
      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from 3.3.2 or later, keep ovirt-release rpm in place until the upgrade is completed. See [oVirt 3.4.0 release notes](/develop/release-management/releases/3.4/) for upgrading from previous versions.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.2.iso`](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.2.iso)

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide.

## What's New in 3.4.2?

## Known issues

## Bugs fixed

### oVirt Engine

* 'list jobs' shows 'UNKNOWN' for target hosts when VMs are migrating
 - [RHSC] Host does not move to non operational even after glusterd is made down .
 - display the actual CPU allocation of a VM to manage inconsistencies
 - User and System CPU Usage have values higher than 100%
 - [branding] engine-setup says "login into oVirt Engine"
 - [REST-API] Can't set display network if display=false and usages.usage is display
 - [engine] [RO-disk] Direct-LUN connected by Virt-IO-SCSI which is configured to be RO to a VM is writeable
 - Run once vm with attached cd, not attach payload
 - Hot plug causes the breach in quota enforcement
 - Break bond by detaching the network label cannot be done in one step
 - template of thin provision NFS,can't be copied to block data domains
 - [Network Label] Cannot break bond with Network label attached by break bond action
 - Engine should not send defaultRoute in clusterLevel <= 3.3
 - [User Portal] Windows VNC-based VM are opened via RDP by default in User Portal
 - Cannot sysprep Windows VM with different time zone than the one set in VM dialog / System side-tab
 - SuperUser of DataCenter X cannot approve a host under this Data Center
 - [Network labels] Network label rename should be blocked while label is configured on hosts
 - Extending Preallocated Read Only Disk should fail
 - Extending Thin provision Read Only Disk should block with canDoAction
 - NullPointerException raised while perform REST API request api/vms/\*\*\*/applications for VM w/o installed applications
 - New Power Savings Policy Parameters are not in Beta 3 Build
 - Failed to commit custom preview of snapshot
 - Unable to upgrade rhevh - Please select an ISO with major version 6.x
 - Neutron: Failed to install Host neseted_host_1. Failed to execute stage 'Misc configuration': list index out of range.
 - Block IDE disks and VirtIO-SCSI disks when attaching/updating
 - admin@internal can not log in to the Web admin portal if another admin user exists in an external directory
 - rhevm failed to create "rhevm" bridge after add new host
 - ovirt-engine failed to create management network during new host installation
 - [Neutron integration] It's impossible to create network on Neutron from ovirt-engine
 - [RHEVM-RHS] Host status is shown up in RHEVM UI, even when glusterd is stopped
 - [engine] [RO-disk] Disbale read-only VirtIO-SCIS LUN disks in the GUI
 - [engine-webadmin] Cannot create an export domain under local DC
 - A movement operation of raw sparse disk from file to block domain results in Raw preallocated disk, but reports its type wrongly in the webadmin
 - Batch updates might create a database deadlock
 Bugs fixed between RC and GA:

* Run once vm via REST with <pause>true</pause> parameter, save this parameter true also in next runs
 - Tracker: oVirt 3.4.2 release

### oVirt Log Collector

* [engine-log-collector] problem with sos3 on rhel7 as general.all_logs no longer exist

### oVirt Hosted Engine HA

* Could not start ha-agent with exception AttributeError: 'dict' object has no attribute 'engine_status'
 - Hosted engine upgrade from 3.3 to 3.4, ovirt-ha-agent die after three errors

### oVirt Hosted Engine Setup

* hosted-engine setup logs the temporary VM password

### VDSM

### ovirt-node-plugin-vdsm

* engine_page: catch exception from vdscli.connect()
 - engine_page: replace netinfo to xmlrpc
 - engine_page: set password when no address is used
 - spec: remove uneeded sed's
 - engine_page: Display correctly proto for Manage by
 - engine_page: Remove Retrieve Certificate button
 - engine_page: network is required to register tab
 - engine_page: add exception for ENETUNREACH
 - hooks: Adding hooks for ovirt-node-upgrade
 - engine_page: remove dep. from ovirt_config_setup.engine

### oVirt ISO Uploader

* option insecure doesn't work

### oVirt Image Uploader

* option insecure doesn't work


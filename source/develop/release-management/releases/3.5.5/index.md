---
title: oVirt 3.5.5 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 3.5.5 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.5.5 release as of October 26th, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.1, CentOS Linux 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/). 

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install oVirt 3.5.5 Release on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

If you are upgrading from a previous version, you may have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](/develop/release-management/releases/3.4.1/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.5/ovirt-live-el6-3.5.5.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.5/ovirt-live-el6-3.5.5.iso)

### oVirt Node

## What's New in 3.5.5?

*   Windows 10 Guest OS detection support and a default icon have been added to the web UI.

## Known issues

### Upgrade issues

### Distribution specific issues

## CVE Fixed

## Bugs fixed

### oVirt Engine

* [search] Support tokens with special characters within name
 - On datacenter with compatibility version less than 3.5 attaching and detaching from one dc to another in the same setup can cause vm states loss (depending on timing of the detach)
 - [sysprep] Sysprep floppy payload attached to normal VM regardless of its settings enabling
 - If Quotas are enabled, even in Audit mode, active VMs' disks cannot be edited
 - [userportal][AAA] in case there is no password (nego) disable automatic login feature
 - [RHEV-M webadmin] improve German translation.
 - Incorrect message when trying to remove a scheduling policy while attached to a cluster
 - support forcing the use of custom JRE
 - [RFE] Windows 10 Guest OS Support - UI
 - Upgrade from 3.5.2 to 3.5.3 experiencing database execution error
 - [sysprep] Sysprep floppy payload attached to normal VM regardless of its settings enabling
 - Engine: Live merge fails after a disk containing a snapshot has been extended
 - [PKI] enforce utf-8 subject for openssl
 - Korean translation update
 - [events] ...was started by null@N/A
 - Can't update storage domain via REST API in case that the storage domain's 'containsUnregisteredEntities' property is true
 - Dropdown boxes on RHEVM not rendered properly in Chromium
 - Stateless VM snapshot gets deleted when user shuts down VM in a Manual Pool type
 - [scale] - org.jboss.resteasy.spi.ResteasyProviderFactory potential leak
 - [host-deploy] when updating multiple packages only the latest is considered in cache timestamp
 - Node unusable after upgrade from F20 to F21 (supported machine types list too long for database field)
 - several async tasks are not cleared altough they are over and finished in vdsm
 - VM --> Provisoning Operations --> Create permit required for live migrations in 3.5
 - Windows 2012 guest reports incorrect time randomly and after a cold restart.
 - [extmgr] load extension properties as unicode
 - [AAA] Incorrect AuthRecord.VALID_TO parsing
 - fencing_policies is not available in REST API output
 - Encrypted database fields should allow spaces
 - Automatic fencing doesn't work when network is killed on host

### oVirt Hosted Engine HA

* hosted-engine --vm-status results into python exception
 - [hosted-engine-setup] Deployment over iSCSI fails due to broken symlink under /rhev/data-center/

### oVirt Hosted Engine Setup

* On additional hosts, appending an answerfile, the setup will not download the HE one from the first host
 - [hosted-engine-setup] Deployment over iSCSI using RHEVM-appliance fails with endless 'WARNING otopi.plugins.ovirt_hosted_engine_setup.vm.image image._disk_customization:124 Not enough free space' messages
 - hosted-engine-setup fails updating vlan property on the management network if more than one datacenter is there
 - [HE] Failed to deploy additional host using NFS

### VDSM

* [vdsm] Flooding logs and high cpu during communication issues over jsonrpc
 - systemd kills dhclient when supervdsm is stopped
 - vdsm log is flooded with JsonRpcServer and stompReactor messages
 - /var/log/messages is spammed with hosted engine errors on RHEV-H 3.5.4
 - VDSM: Live merge fails after a disk containing a snapshot has been extended
 - [libvirt] incorrect XML restore on dehibernation path

### oVirt DWH

* Deadlock in user sync causes failures in collections and aggregation- unblock 3.5 users.

### oVirt Reports

* Network usage not displayed in br2a\\br10a and disk not displayed in br10a
 - engine-setup deletes adhoc reports on upgrade

### Other packages updated

*   ovirt-engine-sdk-python
*   ovirt-engine-sdk-java
*   ovirt-engine-cli
*   qemu-kvm-rhev
*   qemu-kvm-ev


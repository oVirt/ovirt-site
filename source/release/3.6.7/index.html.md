---
title: OVirt 3.6.7 Release Notes
category: documentation
authors: didi, sandrobonazzola, rafaelmartins, fabiand
---

# oVirt 3.6.7 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.7 first release candidate as of May 24th, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](http://www.ovirt.org/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

## CANDIDATE RELEASE

In order to install oVirt 3.6.7 Release Candidate you've to enable oVirt 3.6 release candidate repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.6.repo**

**For CentOS / RHEL:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
      baseurl=http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
      gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6

**For Fedora:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
      baseurl=http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever`
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
      gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.7 on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](oVirt 3.5.6 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/)

### oVirt Node

A new oVirt Node installation iso is available at: <http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-node-ng-installer/>

Download and install instructions are avaialble on the [Node Project](/node) page.

If you have already got oVirt Node Next installed, you can run

    yum update

to update Node.


## What's New in 3.6.7?

### Enhancement

#### oVirt Engine

##### Team: UX

 - [BZ 1325478](https://bugzilla.redhat.com/1325478) <b>Please re-import translations for 3.6.7</b><br>

##### Team: Infra

 - [BZ 1327041](https://bugzilla.redhat.com/1327041) <b>[RFE] [z-stream clone - 3.6.7] AAA - Make Kerberos work with Java Authentication Framework</b><br>Provide a way how to configure gssapi using ticket cache for authz pool.<br>

#### oVirt Hosted Engine Setup

##### Team: Gluster

 - [BZ 1298693](https://bugzilla.redhat.com/1298693) <b>[RFE] - Single point of failure on entry point server deploying hosted-engine over gluster FS</b><br>

#### oVirt Hosted Engine HA

##### Team: Gluster

 - [BZ 1298693](https://bugzilla.redhat.com/1298693) <b>[RFE] - Single point of failure on entry point server deploying hosted-engine over gluster FS</b><br>

### If docs needed, set a value

#### VDSM

##### Team: Storage

 - [BZ 1337314](https://bugzilla.redhat.com/1337314) <b>Excessive cpu usage while deleting disks on block storage when "wipe after delete" selected</b><br>
 - [BZ 1338543](https://bugzilla.redhat.com/1338543) <b>VDSM to consume fix for "Bug 1322279 - Messages file are flooded with byte_count = 126 != scsi_bufflen = 0 [rhel-7.2.z]"</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1337050](https://bugzilla.redhat.com/1337050) <b>ovirt-hosted-engine-setup always refuses to deploy if NetworkManager is active, make it configurable</b><br>

## Bug fixes

### oVirt Engine

#### Team: Virt

 - [BZ 1331333](https://bugzilla.redhat.com/1331333) <b>VNC Console Keyboard layout/mapping not used</b><br>
 - [BZ 1332101](https://bugzilla.redhat.com/1332101) <b>Hovering above an exclamation mark next to windows guest shows "New guest tools are available" even after upgrading guest tools to latest version.</b><br>

#### Team: Storage

 - [BZ 1334105](https://bugzilla.redhat.com/1334105) <b>VMs from auto-start pool randomly stop getting started</b><br>

#### Team: SLA

 - [BZ 1209505](https://bugzilla.redhat.com/1209505) <b>assign DiskProfileUser role to Everyone group to newly added storagedomain's profile</b><br>

#### Team: Infra

 - [BZ 1335488](https://bugzilla.redhat.com/1335488) <b>Groups resolution shouldn't be done on authn stage</b><br>
 - [BZ 1331068](https://bugzilla.redhat.com/1331068) <b>[OVIRT-PYTHON-SDK] Template's sub-collection nics and cdroms have no 'delete' attribute</b><br>
 - [BZ 1314826](https://bugzilla.redhat.com/1314826) <b>No debug log entry for user executing an action or query</b><br>

### VDSM

#### Team: Virt

 - [BZ 1303160](https://bugzilla.redhat.com/1303160) <b>Connecting vfio-pci device failed, no device found with kernel > 3.10.0-229.20.1.el7.x86_64 (RHEL 7.2)</b><br>

#### Team: Storage

 - [BZ 1336464](https://bugzilla.redhat.com/1336464) <b>Data Center upgrade fails due to pending running upgrade</b><br>

#### Team: Infra

 - [BZ 1325664](https://bugzilla.redhat.com/1325664) <b>No failure message appears when setting a power management test fails</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1251968](https://bugzilla.redhat.com/1251968) <b>[Tracker] - Hosted engine setup fails with localhost.localdomain could not be used as a valid FQDN</b><br>

---
title: oVirt 3.6.7 Release Notes
category: documentation
toc: true
authors: didi, sandrobonazzola, rafaelmartins, fabiand
page_classes: releases
---

# oVirt 3.6.7 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.7 release as of Jun 30th, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).
This release supports Hypervisor Hosts running Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.7 on a clean host, you should read our [Quick Start Guide](/documentation/quickstart/quickstart-guide/).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](/develop/release-management/releases/3.5.6/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide.

### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

### oVirt Node

A new oVirt Node installation iso is available at: <http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-node-ng-installer/>

Download and install instructions are avaialble on the [Node Project](/develop/projects/node/node/) page.

If you have already got oVirt Node Next installed, you can run

    yum update

to update Node.

## What's New in 3.6.7?

### Enhancement

#### oVirt Engine

##### Team: UX

 - [BZ 1325478](https://bugzilla.redhat.com/1325478) <b>Please re-import translations for 3.6.7</b><br>

##### Team: Infra

 - [BZ 1327041](https://bugzilla.redhat.com/1327041) <b>[RFE] [z-stream clone - 3.6.7] AAA - Make Kerberos work with Java Authentication Framework</b><br>To provide a way to configure gssapi using ticket cache for authz pool, a new security domain called 'oVirtKerbAAA' was added to JBoss configuration.

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1337050](https://bugzilla.redhat.com/1337050) <b>ovirt-hosted-engine-setup always refuses to deploy if NetworkManager is active, make it configurable</b><br>ovirt-hosted-engine-setup always refuses to deploy if NetworkManager is active, making it configurable via answer file

##### Team: Gluster

 - [BZ 1298693](https://bugzilla.redhat.com/1298693) <b>[RFE] - Single point of failure on entry point server deploying hosted-engine over gluster FS</b><br>hosted-engine-setup let the user entry just a single gluster fs entry point that becomes a single point of failure. Accepting custom mount options via answer file let the user pass backup-volfile-servers options.

#### oVirt Hosted Engine HA

##### Team: Gluster

 - [BZ 1298693](https://bugzilla.redhat.com/1298693) <b>[RFE] - Single point of failure on entry point server deploying hosted-engine over gluster FS</b><br>hosted-engine-setup let the user entry just a single gluster fs entry point that becomes a single point of failure. Accepting custom mount options via answer file let the user pass backup-volfile-servers options.

### Unclassified

#### oVirt Engine

##### Team: Virt

 - [BZ 1336828](https://bugzilla.redhat.com/1336828) <b>v2v: Import VMs dialog - Load button and error message issues</b><br>Load button in Import VMs dialog is disabled when <br><br>* The is no data center up<br>* or, there is no export domain and "Source" in Import VM dialog is set to "Export domain"

##### Team: Storage

 - [BZ 1344314](https://bugzilla.redhat.com/1344314) <b>"VDSM HOST2 command failed: Cannot find master domain" after adding storage</b><br>
 - [BZ 1337257](https://bugzilla.redhat.com/1337257) <b>[scale][ovirt-3.6.z] - GetStorageConnectionsByStorageTypeAndStatus generate slow query for multiple SD's</b><br>
 - [BZ 1341661](https://bugzilla.redhat.com/1341661) <b>[ovirt-3.6.z][scale] - storage_domains view generate inefficient query</b><br>

#### VDSM

##### Team: Storage

 - [BZ 1337314](https://bugzilla.redhat.com/1337314) <b>Excessive cpu usage while deleting disks on block storage when "wipe after delete" selected</b><br>
 - [BZ 1339245](https://bugzilla.redhat.com/1339245) <b>Creation of 300 storage domains, failed during creation of 54th storage domain.</b><br>
 - [BZ 1338543](https://bugzilla.redhat.com/1338543) <b>VDSM to consume fix for "Bug 1322279 - Messages file are flooded with byte_count = 126 != scsi_bufflen = 0 [rhel-7.2.z]"</b><br>

## Bug fixes

### oVirt Engine

#### Team: Virt

 - [BZ 1341078](https://bugzilla.redhat.com/1341078) <b>Can't add a new cluster from the UI</b><br>
 - [BZ 1342388](https://bugzilla.redhat.com/1342388) <b>VM split brain during networking issues</b><br>
 - [BZ 1338943](https://bugzilla.redhat.com/1338943) <b>VM Snapshot can't be cloned to new VM</b><br>
 - [BZ 1294451](https://bugzilla.redhat.com/1294451) <b>v2v: webadmin uncaught exception occurs when trying to import VM without selecting cluster.</b><br>
 - [BZ 1338816](https://bugzilla.redhat.com/1338816) <b>Template tab doesn't show all templates</b><br>
 - [BZ 1331333](https://bugzilla.redhat.com/1331333) <b>VNC Console Keyboard layout/mapping not used</b><br>
 - [BZ 1332101](https://bugzilla.redhat.com/1332101) <b>Hovering above an exclamation mark next to windows guest shows "New guest tools are available" even after upgrading guest tools to latest version.</b><br>
 - [BZ 1341299](https://bugzilla.redhat.com/1341299) <b>Host devicelist in VM Tab is empty after upgrade from 3.6.4</b><br>

#### Team: Infra

 - [BZ 1331186](https://bugzilla.redhat.com/1331186) <b>[events] Host memory usage exceeded defined threshold email message not generated.</b><br>
 - [BZ 1335488](https://bugzilla.redhat.com/1335488) <b>Groups resolution shouldn't be done on authn stage</b><br>
 - [BZ 1331068](https://bugzilla.redhat.com/1331068) <b>[OVIRT-PYTHON-SDK] Template's sub-collection nics and cdroms have no 'delete' attribute</b><br>
 - [BZ 1314826](https://bugzilla.redhat.com/1314826) <b>No debug log entry for user executing an action or query</b><br>

#### Team: Gluster

 - [BZ 1343946](https://bugzilla.redhat.com/1343946) <b>[gluster]: geo-rep creation fails and status goes to UNKNOWN</b><br>

#### Team: SLA

 - [BZ 1328921](https://bugzilla.redhat.com/1328921) <b>Importing HE with VNC device attached creates corrupted VM in the database</b><br>
 - [BZ 1317699](https://bugzilla.redhat.com/1317699) <b>Hosted engine on Gluster prevents additional non-ha hosts being added</b><br>
 - [BZ 1209505](https://bugzilla.redhat.com/1209505) <b>assign DiskProfileUser role to Everyone group to newly added storagedomain's profile</b><br>
 - [BZ 1291063](https://bugzilla.redhat.com/1291063) <b>[ppc64le] Start vm with "Pass-Through Host CPU" enabled failed</b><br>

### VDSM

#### Team: Virt

 - [BZ 1343070](https://bugzilla.redhat.com/1343070) <b>Broken Dependencies for vdsm on ppc64le</b><br>
 - [BZ 1335840](https://bugzilla.redhat.com/1335840) <b>VMs reported as paused after libvirtd restart</b><br>
 - [BZ 1303160](https://bugzilla.redhat.com/1303160) <b>Connecting vfio-pci device failed, no device found with kernel > 3.10.0-229.20.1.el7.x86_64 (RHEL 7.2)</b><br>
 - [BZ 1331333](https://bugzilla.redhat.com/1331333) <b>VNC Console Keyboard layout/mapping not used</b><br>

#### Team: Storage

 - [BZ 1336464](https://bugzilla.redhat.com/1336464) <b>Data Center upgrade fails due to pending running upgrade</b><br>
 - [BZ 1317850](https://bugzilla.redhat.com/1317850) <b>make QCOW2_COMPAT configurable</b><br>
 - [BZ 1336367](https://bugzilla.redhat.com/1336367) <b>[z-stream clone - 3.6.7] Growing backing file length in qcow2 header causes 'Backing file name too long' error.</b><br>

#### Team: Gluster

 - [BZ 1343946](https://bugzilla.redhat.com/1343946) <b>[gluster]: geo-rep creation fails and status goes to UNKNOWN</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1339593](https://bugzilla.redhat.com/1339593) <b>Failed to deploy additional RHEL7 3.6 host under HE 3.5 environment</b><br>
 - [BZ 1251968](https://bugzilla.redhat.com/1251968) <b>[Tracker] - Hosted engine setup fails with localhost.localdomain could not be used as a valid FQDN</b><br>

#### Team: SLA

 - [BZ 1339306](https://bugzilla.redhat.com/1339306) <b>Video device is not explicitly requested from VDSM</b><br>

### oVirt Hosted Engine HA

#### Team: SLA

 - [BZ 1339305](https://bugzilla.redhat.com/1339305) <b>Video device is not imported from OVF store</b><br>

### oVirt Engine SDK

#### Team: Infra

 - [BZ 1326729](https://bugzilla.redhat.com/1326729) <b>The VersionCaps broker object is broken</b><br>
 - [BZ 1333889](https://bugzilla.redhat.com/1333889) <b>missing import in ovirtsdk.xml.params</b><br>

### MOM

#### Team: SLA

 - [BZ 1337228](https://bugzilla.redhat.com/1337228) <b>empty ioTune policy is being set periodically even when no QoS is configured at all</b><br>
 - [BZ 1337834](https://bugzilla.redhat.com/1337834) <b>MoM completely ignores VMs when they have no ballooning devices</b><br>

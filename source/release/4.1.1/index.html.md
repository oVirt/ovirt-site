---
title: oVirt 4.1.1 Release Notes
category: documentation
authors: sandrobonazzola
---

# oVirt 4.1.1 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.1
First Test Compose as
of February 09, 2017.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3, CentOS Linux 7.3
(or similar).


This is pre-release software.
Please take a look at our [community page](/community/) to know how to
ask questions and interact with developers and users.
All issues or bugs should be reported via the [Red Hat Bugzilla](https://bugzilla.redhat.com/).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature complete.


To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

An updated documentation has been provided by our downstream
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization?version=4.0/)


## Install / Upgrade from previous versions


### Fedora / CentOS / RHEL


## TEST COMPOSE

In order to install this Test Compose you will need to enable pre-release repository.


In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


To test this pre release, you may read our
[Quick Start Guide](Quick Start Guide)

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding Red Hat Virtualization
[Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding Red Hat Virtualization
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/)

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the epel repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS OpsTools SIG repos, for other packages.

EPEL currently includes collectd 5.7.1, and the collectd package there includes
the write_http plugin.

OpsTools currently includes collectd 5.7.0, and the write_http plugin is
packaged separately.

ovirt-release does not use collectd from epel, so if you only use it, you
should be ok.

If you want to use other packages from EPEL, you should make sure to not
include collectd. Either use `includepkgs` and add those you need, or use
`excludepkgs=collectd*`.
## What's New in 4.1.0 Async release?
On February 3rd 2017 the ovirt team issued an async release of ovirt-engine package including a fix for:
- [BZ 1417597](https://bugzilla.redhat.com/1417597) <b>Failed to update template</b><br>

## What's New in 4.1.1?

### Enhancements

#### oVirt Engine

##### Team: Infra

 - [BZ 1412547](https://bugzilla.redhat.com/1412547) <b>Allow negotiation of highest available TLS version for engine <-> VDSM communication</b><br>Feature: <br><br>Currently when engine tries to connect to VDSM, it tries to negotiate highest available version of TLS, but due to issues in the past we have a limitation to try TLSv1.0 as highest version and not try any higher version.<br><br>This fix removes the limit, so we can negotiate also TLSv1.1 and TLSv1.2 when they will be available on VDSM side. Removing this limit will allow us to drop TLSv1.0 in future VDSM versions and provide only newer TLS versions<br><br><br>Reason: <br><br>Result:

### No Doc Update

#### oVirt Engine

##### Team: Network

 - [BZ 1418537](https://bugzilla.redhat.com/1418537) <b>[Admin Portal] Exception while adding new host network QoS from cluster->logical networks->add network</b><br>undefined

#### VDSM

##### Team: Storage

 - [BZ 1215039](https://bugzilla.redhat.com/1215039) <b>[HC] - API schema for StorageDomainType is missing glusterfs type</b><br>undefined

### Unclassified

#### oVirt Engine

##### Team: Infra

 - [BZ 1414787](https://bugzilla.redhat.com/1414787) <b>Hide tracebacks in engine.log by upgrading non responsive host</b><br>
 - [BZ 1416845](https://bugzilla.redhat.com/1416845) <b>Can not add power management to the host, when the host has state 'UP'</b><br>
 - [BZ 1414083](https://bugzilla.redhat.com/1414083) <b>User Name required for login on behalf</b><br>
 - [BZ 1400500](https://bugzilla.redhat.com/1400500) <b>If AvailableUpdatesFinder finds already running process it should not be ERROR level</b><br>
 - [BZ 1416147](https://bugzilla.redhat.com/1416147) <b>Version 3 of the API doesn't implement the 'testconnectivity' action of external providers</b><br>

##### Team: Metrics

 - [BZ 1415639](https://bugzilla.redhat.com/1415639) <b>Some of the values are not considered as numbers by elasticsearch</b><br>

##### Team: Network

 - [BZ 1415471](https://bugzilla.redhat.com/1415471) <b>Adding host to engine failed at first time but host was auto recovered after several mins</b><br>
 - [BZ 1390575](https://bugzilla.redhat.com/1390575) <b>Import VM from data domain failed when trying to import a VM without re-assign MACs, but there is no MACs left in the destination pool</b><br>

##### Team: SLA

 - [BZ 1364132](https://bugzilla.redhat.com/1364132) <b>Once the engine imports the hosted-engine VM we loose the console device</b><br>

##### Team: Storage

 - [BZ 1414126](https://bugzilla.redhat.com/1414126) <b>UI error on 'wipe' and 'discard' being mutually exclusive is unclear and appears too late</b><br>
 - [BZ 1379130](https://bugzilla.redhat.com/1379130) <b>Unexpected client exception when glance server is not reachable</b><br>
 - [BZ 1419364](https://bugzilla.redhat.com/1419364) <b>Fail to register an unregistered Template through REST due to an NPE when calling updateMaxMemorySize</b><br>
 - [BZ 1416340](https://bugzilla.redhat.com/1416340) <b>Change name of check box in Edit Virtual Disks window from Pass Discard to Enable Discard</b><br>
 - [BZ 1399603](https://bugzilla.redhat.com/1399603) <b>Import template from glance and export it to export domain will cause that it is impossible to import it</b><br>
 - [BZ 1416809](https://bugzilla.redhat.com/1416809) <b>New HSM infrastructure - No QCow version displayed for images created with 4.0</b><br>
 - [BZ 1414084](https://bugzilla.redhat.com/1414084) <b>uploaded images using the GUI have actual_size=0</b><br>

##### Team: Virt

 - [BZ 1414455](https://bugzilla.redhat.com/1414455) <b>removing disk in VM edit dialog causes UI error</b><br>
 - [BZ 1410606](https://bugzilla.redhat.com/1410606) <b>Imported VMs has max memory 0</b><br>
 - [BZ 1364137](https://bugzilla.redhat.com/1364137) <b>make VM template should be blocked while importing this VM.</b><br>
 - [BZ 1406572](https://bugzilla.redhat.com/1406572) <b>Uncaught exception is received when trying to create a vm from User portal without power user role assigned</b><br>
 - [BZ 1374589](https://bugzilla.redhat.com/1374589) <b>remove virtio-win drivers drop down for KVM imports</b><br>
 - [BZ 1414086](https://bugzilla.redhat.com/1414086) <b>Remove redundant video cards when no graphics available for a VM and also add video cards if one graphics device exists</b><br>
 - [BZ 1347356](https://bugzilla.redhat.com/1347356) <b>Pending Virtual Machine Changes -> minAllocatedMem issues</b><br>
 - [BZ 1416837](https://bugzilla.redhat.com/1416837) <b>Order VMs by Uptime doesn't work</b><br>

#### VDSM

##### Team: Network

 - [BZ 1414323](https://bugzilla.redhat.com/1414323) <b>Failed to add host to engine via bond+vlan configured by NM during anaconda</b><br>
 - [BZ 1412563](https://bugzilla.redhat.com/1412563) <b>parse arp_ip_target with multiple ip properly</b><br>
 - [BZ 1410076](https://bugzilla.redhat.com/1410076) <b>[SR-IOV] - in-guest bond with virtio+passthrough slave lose connectivity after hotunplug/hotplug of passthrough slave</b><br>

##### Team: Storage

 - [BZ 1417460](https://bugzilla.redhat.com/1417460) <b>Failed to Amend Qcow volume on block SD due failure on Qemu-image</b><br>
 - [BZ 1417737](https://bugzilla.redhat.com/1417737) <b>Cold Merge: Deprecate mergeSnapshots verb</b><br>
 - [BZ 1415803](https://bugzilla.redhat.com/1415803) <b>Improve logging during live merge</b><br>

##### Team: Virt

 - [BZ 1419557](https://bugzilla.redhat.com/1419557) <b>Switching to post-copy should catch exceptions</b><br>

#### oVirt Engine Extension AAA JDBC

 - [BZ 1415704](https://bugzilla.redhat.com/1415704) <b>Casting exception during group show by ovirt-aaa-jdbc tool</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1411640](https://bugzilla.redhat.com/1411640) <b>[HC] - Include gdeploy package in oVirt Node</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1394687](https://bugzilla.redhat.com/1394687) <b>DC gets non-responding when detaching inactive ISO domain</b><br>
 - [BZ 1323663](https://bugzilla.redhat.com/1323663) <b>the path of storage domain is not trimmed/missing warning about invalid path</b><br>
 - [BZ 1417458](https://bugzilla.redhat.com/1417458) <b>Cold Merge: Use volume generation</b><br>
 - [BZ 1276670](https://bugzilla.redhat.com/1276670) <b>[engine-clean] engine-cleanup doesn't stop ovirt-vmconsole-proxy-sshd</b><br>
 - [BZ 1273825](https://bugzilla.redhat.com/1273825) <b>Template sorting by version is broken</b><br>

### VDSM

 - [BZ 1302358](https://bugzilla.redhat.com/1302358) <b>File Storage domain export path does not support [IPv6]:/path input</b><br>

### oVirt Hosted Engine Setup

 - [BZ 1288979](https://bugzilla.redhat.com/1288979) <b>[HC] glusterd port was not opened, when automatically configuring firewall in hosted-engine setup</b><br>

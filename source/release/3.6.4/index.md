---
title: oVirt 3.6.4 Release Notes
category: documentation
toc: true
authors: didi, sandrobonazzola, rafaelmartins
page_classes: releases
---

# oVirt 3.6.4 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.4 release as of March 29th, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6 stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.6. Please see [oVirt 3.5.6 Release Notes](/develop/release-management/releases/3.5.6/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup


### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

## Bugs fixed

### oVirt Engine

 - [BZ 1310390](https://bugzilla.redhat.com/1310390) - Restore snapshot with only subset of vm's disks will stuck the vm in image locked state
 - [BZ 1311616](https://bugzilla.redhat.com/1311616) - The API crashes when parsing unexpected version numbers
 - [BZ 1313369](https://bugzilla.redhat.com/1313369) - VM parameters set in Edit running VM, are not updated after

### VDSM

 - [BZ 1303410](https://bugzilla.redhat.com/1303410) - [ipv6] vdsm-network reconvigures network due to unsolicited ipvp6 address
 - [BZ 1308839](https://bugzilla.redhat.com/1308839) - [vmfex-hook] - Failed to run VM with vdsm-hook-vmfex-dev-4.17.20
 - [BZ 1321444](https://bugzilla.redhat.com/1321444) - [z-stream clone] Storage activities are failing with error "Image is not a legal chain"

### oVirt Hosted Engine Setup

 - [BZ 1306825](https://bugzilla.redhat.com/1306825) - hosted-engine upgrade fails after upgrade hosts from el6 to el7
 - [BZ 1311317](https://bugzilla.redhat.com/1311317) - Unattended Ovirt host deploy fails on second host when the engine...

### oVirt Hosted Engine HA

 - [BZ 1316143](https://bugzilla.redhat.com/1316143) - 3.6 hosted-engine hosts can't be added properly to 3.6 host cluster that was started with 3.4.
 - [BZ 1319721](https://bugzilla.redhat.com/1319721) - Call to getImagesList on NFS on host without connected storage...


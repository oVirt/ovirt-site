---
title: OVirt 3.6.3 Release Notes
category: documentation
authors: didi, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.6.3 Release Notes
wiki_revision_count: 19
wiki_last_updated: 2016-02-17
---

# OVirt 3.6.3 Release Notes

<big><big>DRAFT</big></big>
The oVirt Project is pleased to announce the availability of oVirt 3.6.3 first release candidate as of <date>.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](http://www.ovirt.org/Category:Releases). For a general overview of oVirt, read [ the Quick Start Guide](Quick_Start_Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

### CANDIDATE RELEASE

In order to install oVirt 3.6.3 Release Candidate you've to enable oVirt 3.6 release candidate repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.6.repo**

**For CentOS / RHEL:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever`](http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6)

**For Fedora:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever`](http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.3 on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](oVirt 3.5.6 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

## Bugs fixed

### VDSM

* Error during successful migration: [Errno 9] Bad file descriptor
 - disable ksmtuned.service during host installation
 - vmchannel thread consumes 100% of CPU
 - Ghost VMs created with prefix "external-" by "null@N/A"
 - VDSM memory leak
 - [vdsm] nofiles impact hardly host - OSError: [Errno 24] Too many open files
 - VM memory usage is not reported correctly
 - Vm.status() causes crash of MoM GuestManager
 - [SR-IOV] - vdsm should persist and restore the number of enabled VFs on a PF during reboots

### oVirt Log Collector

* RHEV engine-log-collector with --local-tmp=PATH option deletes PATH once command is executed

<Category:Documentation> <Category:Releases>

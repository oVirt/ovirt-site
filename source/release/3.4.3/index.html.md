---
title: OVirt 3.4.3 Release Notes
category: documentation
authors: sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.4.3 Release Notes
wiki_revision_count: 17
wiki_last_updated: 2014-08-09
---

# OVirt 3.4.3 Release Notes

The oVirt Project is preparing oVirt 3.4.3 candidate release for testing. This page is still a work in progress.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4.2 Release Notes](oVirt 3.4.2 Release Notes), [oVirt 3.4 Release Notes](oVirt 3.4 Release Notes), [oVirt 3.3.5 release notes](oVirt 3.3.5 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### CANDIDATE RELEASE

oVirt 3.4.3 candidate release is available since 2014-07-10. In order to install it you've to enable oVirt 3.4 rc repository.

**PLEASE WAIT FOR OFFICIAL ANNOUNCE BEFORE TRYING TO INSTALL IT**

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.4.repo**

**For CentOS / RHEL:**

      [ovirt-3.4-rc]
      name=Latest oVirt 3.4 RC
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.4-rc/rpm/el6`](http://resources.ovirt.org/pub/ovirt-3.4-rc/rpm/el6)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

**For Fedora:**

      [ovirt-3.4-rc]
      name=Latest oVirt 3.4 RC
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.4-rc/rpm/fc$releasever`](http://resources.ovirt.org/pub/ovirt-3.4-rc/rpm/fc$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

If you're installing oVirt 3.4.3-rc on a clean host you should read our [Quick Start Guide](Quick Start Guide)

If you're upgrading from a previous version you should have ovirt-release package already installed on your system. You can then install ovirt-release34.rpm as in a clean install side-by-side. If you're upgrading from oVirt 3.4.0 you can now remove ovirt-release package:

      # yum remove ovirt-release

and then just execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from 3.3.2 or later, keep ovirt-release rpm in place until the upgrade is completed. See [oVirt 3.4.0 release notes](oVirt 3.4.0 release notes) for upgrading from previous versions.

If you're going to test oVirt 3.4.3 development version, please add yourself to [Testing/oVirt 3.4.3 Testing](Testing/oVirt 3.4.3 Testing).

## What's New in 3.4.3?

## Known issues

## Bugs fixed

### oVirt Engine

### VDSM

### ovirt-node-plugin-vdsm

<Category:Documentation> <Category:Releases>

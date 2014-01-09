---
title: OVirt 3.4.0 release notes
category: documentation
authors: alonbl, bproffitt, danken, derez, didi, dneary, dougsland, fabiand, fkobzik,
  fromani, lbianc, ndarshan, ofrenkel, sandrobonazzola, shaharh, ttorcz
wiki_category: Documentation
wiki_title: OVirt 3.4.0 release notes
wiki_revision_count: 77
wiki_last_updated: 2014-03-28
---

# OVirt 3.4.0 release notes

The oVirt Project is preparing oVirt 3.4.0 alpha release for testing. This page is still a work in progress.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3.2 release notes](oVirt 3.3.2 release notes), [oVirt 3.3.1 release notes](oVirt 3.3.1 release notes), [oVirt 3.3 release notes](oVirt 3.3 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### ALPHA RELEASE

oVirt 3.4.0 is still in alpha. In order to install it you've to enable oVirt alpha repository and disable nightly repository if you're using it. You'll need to add the following lines in your /etc/yum.repos.d/ovirt.repo:

for CentOS / RHEL:

      [ovirt-3.4.0-alpha]
      name=Alpha builds of the oVirt 3.4 project
`baseurl=`[`http://resources.ovirt.org/releases/3.4.0-alpha/rpm/EL/$releasever/`](http://resources.ovirt.org/releases/3.4.0-alpha/rpm/EL/$releasever/)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

for Fedora:

      [ovirt-3.4.0-alpha]
      name=Alpha builds of the oVirt 3.4 project
`baseurl=`[`http://resources.ovirt.org/releases/3.4.0-alpha/rpm/Fedora/$releasever/`](http://resources.ovirt.org/releases/3.4.0-alpha/rpm/Fedora/$releasever/)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

### Fedora / CentOS / RHEL

If you're installing oVirt 3.4.0 alpha on a clean host you should read our [Quick Start Guide](Quick Start Guide)

If you're upgrading from oVirt 3.3 you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2 you should read [oVirt 3.2 to 3.3 upgrade](oVirt 3.2 to 3.3 upgrade)

If you're upgrading from oVirt 3.1 you should upgrade to 3.2 before upgrading to 3.3.1. Please read [oVirt 3.1 to 3.2 upgrade](oVirt 3.1 to 3.2 upgrade) before starting the upgrade.
On CentOS and RHEL: For upgrading to 3.2 you'll need 3.2 stable repository.
So, first step is disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

      [ovirt-32]
      name=Stable builds of the oVirt 3.2 project
`baseurl=`[`http://ovirt.org/releases/3.2/rpm/EL/$releasever/`](http://ovirt.org/releases/3.2/rpm/EL/$releasever/)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

Then

      # yum update ovirt-engine-setup

should install ovirt-engine-setup-3.2.3-1.el6.noarch.rpm
if you have already updated to 3.3.x please use distro-sync or downgrade instead of update.
Then:

      # engine-upgrade

this will upgrade your system to latest 3.2.
Once you've all working on 3.2, enable 3.3/stable repository, then just

      # yum update ovirt-engine-setup
      # engine-setup

will upgrade to latest 3.3.

## What's New in 3.4.0?

## Known issues

## Bugs fixed

### oVirt Engine

### VDSM

### ovirt-node-plugin-vdsm

<Category:Documentation> <Category:Releases>

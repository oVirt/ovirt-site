---
title: OVirt 3.3.5 release notes
category: documentation
authors: sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.3.5 release notes
wiki_revision_count: 11
wiki_last_updated: 2014-05-02
---

# OVirt 3.3.5 release notes

## Install / Upgrade from previous versions

### NIGHTLY RELEASE

oVirt 3.3.5 is still in development. In order to install it you've to enable oVirt 3.3 snapshot repository

      # yum-config-manager --enable ovirt-3.3-snapshot
      # yum-config-manager --enable ovirt-3.3-snapshot-static

If you're going to test oVirt 3.3.5 development version, please add yourself to [Testing/Ovirt 3.3.5 testing](Testing/Ovirt 3.3.5 testing).

### Fedora / CentOS / RHEL

If you're installing oVirt 3.3.5 on a clean host you should read our [Quick Start Guide](Quick Start Guide)

If you're upgrading from oVirt 3.3 you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2 you should read [oVirt 3.2 to 3.3 upgrade](oVirt 3.2 to 3.3 upgrade)

If you're upgrading from oVirt 3.1 you should upgrade to 3.2 before upgrading to 3.3.4. Please read [oVirt 3.1 to 3.2 upgrade](oVirt 3.1 to 3.2 upgrade) before starting the upgrade.
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

## What's New in 3.3.5?

## Known issues

## Bugs fixed

### oVirt Engine

### VDSM

### ovirt-node-plugin-vdsm

<Category:Documentation> <Category:Releases>

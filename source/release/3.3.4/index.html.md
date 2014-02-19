---
title: OVirt 3.3.4 release notes
category: documentation
authors: dougsland, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.3.4 release notes
wiki_revision_count: 11
wiki_last_updated: 2014-03-04
---

# OVirt 3.3.4 release notes

The oVirt Project is preparing oVirt 3.3.4 beta release for testing. This page is still a work in progress.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3.3 release notes](oVirt 3.3.3 release notes), [oVirt 3.3.2 release notes](oVirt 3.3.2 release notes) , [oVirt 3.3.1 release notes](oVirt 3.3.1 release notes), [oVirt 3.3 release notes](oVirt 3.3 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### BETA RELEASE

oVirt 3.3.4 is still in beta. In order to install it you've to enable oVirt beta repository **please wait for official announcement before trying to install it**.

If you're going to test oVirt 3.3.4 beta, please add yourself to [Testing/Ovirt 3.3.4 testing](Testing/Ovirt 3.3.4 testing).

### Fedora / CentOS / RHEL

If you're installing oVirt 3.3.4 on a clean host you should read our [Quick Start Guide](Quick Start Guide)

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

## What's New in 3.3.4?

## Known issues

## Bugs fixed

### oVirt Engine

### VDSM

* vdsm: pre-defined range for spice/vnc ports
 - Avoid going into 'Paused' status during long lasting migrations
 - vdsmd not starting on first run since vdsm logs are not included in rpm
 - vdsm: fix RTC offset
 - netinfo.speed: avoid log spam
 - vm: discover volume path from xml definition
 - Removing vdsm-python-cpopen rpm creation from vdsm
 - vm iface statistics: never report negative rates
sos: plugin should ignore /var/run/vdsm/storage

### ovirt-node-plugin-vdsm

* UI: AttributeError("'module' object has no attribute 'configure_logging'",)
 - engine_page: use vdsm to detect mgmt interface
 - engine_page: display url/port only on available

<Category:Documentation> <Category:Releases>

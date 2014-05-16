---
title: OVirt 3.5 Release Notes
category: documentation
authors: adahms, aglitke, apuimedo, danken, didi, dougsland, eedri, fromani, lveyde,
  moti, mpavlik, pkliczewski, sandrobonazzola, sradco, stirabos, yair zaslavsky, ybronhei
wiki_category: Documentation
wiki_title: OVirt 3.5 Release Notes
wiki_revision_count: 127
wiki_last_updated: 2015-01-06
---

DRAFT DRAFT DRAFT

The oVirt Project is working on oVirt 3.5.0 Alpha release. oVirt is an open source alternative to VMware vSphere, and provides an excellent KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes), [oVirt 3.3.5 release notes](oVirt 3.3.5 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

# oVirt 3.5.0 ALPHA Release Notes

### ALPHA RELEASE

### Feature #1

<description>

### Other Enhancements

#### Virt

#### Infra

#### Networking

#### Storage

#### SLA & Scheduling

#### UX Enhancements

# Install / Upgrade from previous versions

### ALPHA RELEASE

oVirt 3.5.0 Alpha release is available since 2014-05-16. In order to install it you've to enable oVirt 3.5 pre release repository.

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

You should read then our [Quick Start Guide](Quick Start Guide)

Please note that this is still a development release, installation on a production system is not recommended.

If you're upgrading from a previous version you should have ovirt-release package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

If you're upgrading from oVirt 3.4.0 you can now remove ovirt-release package:

      # yum remove ovirt-release
      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from oVirt < 3.4.0 you must first upgrade to oVirt 3.4.1. Please see [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes) for upgrading instructions.

# <span class="mw-customtoggle-0" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Known Issues

<div  id="mw-customcollapsible-0" class="mw-collapsible mw-collapsed">
*   VDSM packages released with the first 3.5.0 alpha have version lower than the ones we had in 3.4.1 so they won't be updated.

</div>
# <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
### oVirt Engine

### VDSM

### ovirt-node-plugin-vdsm

### oVirt DWH

### oVirt Reports

### oVirt Log Collector

* [engine-log-collector] problem with sos3 on rhel7 as general.all_logs no longer exist

### oVirt ISO Uploader

### oVirt Image Uploader

</div>
<Category:Documentation> <Category:Releases>

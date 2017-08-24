---
title: oVirt 4.1.6 Release Notes
category: documentation
layout: toc
---

# oVirt 4.1.6 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.6
First Release Candidate as
of August 24, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).
Packages for Fedora 24 are also available as a Tech Preview.


This is pre-release software.
Please take a look at our [community page](/community/) to know how to
ask questions and interact with developers and users.
All issues or bugs should be reported via the
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.1.6, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.


In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


and then follow our
[Installation guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)



### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding section within the
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
`exclude=collectd*`.


## What's New in 4.1.6?

### Enhancements

#### oVirt Hosted Engine Setup

 - [BZ 1481095](https://bugzilla.redhat.com/1481095) <b>[downstream clone - 4.1.6] [bug] hosted-engine yum repo required, but rpm-based install optional</b><br>Feature: <br>Provide path to Appliance OVF<br><br>Reason: <br>This feature is supported according to RedHat customer portal, but dropped in the past for some reason<br><br>Result: <br>User can provide path to appliance OVA instead of installing appliance RPM

### Unclassified

#### oVirt Engine

 - [BZ 1445235](https://bugzilla.redhat.com/1445235) <b>Storage subtab is unsorted and keeps sorting its items</b><br>
 - [BZ 1482569](https://bugzilla.redhat.com/1482569) <b>Force remove of a storage domain should release MAC addresses only for VMs which are removed from the setup</b><br>

#### VDSM

 - [BZ 1479677](https://bugzilla.redhat.com/1479677) <b>[RFE] - LLDP protocol REST API support</b><br>
 - [BZ 1432386](https://bugzilla.redhat.com/1432386) <b>static ip remain on the interface when removing non-vm network from it in case it has another vlan network attached</b><br>
 - [BZ 1482014](https://bugzilla.redhat.com/1482014) <b>vdsmd fails to start if system time moves backwards during boot</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1481115](https://bugzilla.redhat.com/1481115) <b>Downloading an image with backing files from the sdk is triggering disk deletion</b><br>

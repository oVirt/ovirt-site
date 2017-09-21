---
title: oVirt 4.1.7 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.1.7 Release Notes

The oVirt Project is pleased to announce the availability of the 4.1.7
 first release candidate
 as of September 21, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).


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

To learn about features introduced before 4.1.7, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.






In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)



### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the epel repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.1.7?

### Enhancements

#### oVirt Hosted Engine Setup

 - [BZ 1471658](https://bugzilla.redhat.com/1471658) <b>[HC] Hosted engine deployment should enable gfapi access for cluster</b><br>Feature: Enabling gfapi during HE installation<br><br>Reason: For the HC deployment, we want the gfapi access to be enabled for the "Default" cluster during HE deployment. <br><br>Result: You could use additional config file with:<br><br>OVEHOSTED_ENGINE/enableLibgfapi=bool:True<br><br>to enable libgfapi during HE setup

## Bug fixes

### oVirt Hosted Engine Setup

 - [BZ 1490202](https://bugzilla.redhat.com/1490202) <b>[downstream clone - 4.1.7] [iSCSI] ovirt-hosted-engine-setup fails if none of the discovered target is associated to the accessed portal</b><br>

### Unclassified

#### VDSM

 - [BZ 1483328](https://bugzilla.redhat.com/1483328) <b>[downstream clone - 4.1.7] [sos plugin] lvm commands need syntax change</b><br>
 - [BZ 1488878](https://bugzilla.redhat.com/1488878) <b>vdsm-client help should show all available commands</b><br>

#### oVirt Engine Metrics

 - [BZ 1468895](https://bugzilla.redhat.com/1468895) <b>Add a playbook that changes collectd and fluentd services state and enable/disable on the engine and hosts</b><br>

#### oVirt Engine

 - [BZ 1477700](https://bugzilla.redhat.com/1477700) <b>Host enters to power management restart loop</b><br>
 - [BZ 1464765](https://bugzilla.redhat.com/1464765) <b>Set iothreads via REST does not update virtio-scsi devices</b><br>
 - [BZ 1484825](https://bugzilla.redhat.com/1484825) <b>Auto generated snapshot remains LOCKED after concurrent LSM</b><br>
 - [BZ 1478296](https://bugzilla.redhat.com/1478296) <b>Health check on Host <UNKNOWN> indicates that future attempts to Stop this host using Power-Management are expected to fail.</b><br>
 - [BZ 1489795](https://bugzilla.redhat.com/1489795) <b>Importing a VM from 3.6 fails due to NPE @ org.ovirt.engine.core.bll.network.VmInterfaceManager.removeAll</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1492791](https://bugzilla.redhat.com/1492791) <b>Engine VM has no external connectivity due to unconfigured default gateway if deployed with static IP</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1493384](https://bugzilla.redhat.com/1493384) <b>[downstream clone - 4.1.7] Additional HE host deploy fails due to 'received downloaded data size is wrong'</b><br>


### No Doc Update

#### oVirt Engine

 - [BZ 1471815](https://bugzilla.redhat.com/1471815) <b>SQL Exception while sorting columns of events subtab of Hosts main tab</b><br>


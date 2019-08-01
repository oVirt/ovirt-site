---
title: oVirt 4.3.6 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.3.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.6 First Release Candidate as of August 01, 2019.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.6,
CentOS Linux 7.6 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.3.6, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/).

### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.


## What's New in 4.3.6?

### Release Note

#### oVirt Engine WildFly

 - [BZ 1732499](https://bugzilla.redhat.com/1732499) <b>Require WildFly 17.0.1 for oVirt Engine 4.3</b><br>oVirt engine 4.3.6 now depends on WildFly 17.0.1.FINAL

#### oVirt Engine

 - [BZ 1732499](https://bugzilla.redhat.com/1732499) <b>Require WildFly 17.0.1 for oVirt Engine 4.3</b><br>oVirt engine 4.3.6 now depends on WildFly 17.0.1.FINAL

### Enhancements

#### oVirt Engine

 - [BZ 1680498](https://bugzilla.redhat.com/1680498) <b>[RFE] Implement priorities for soft affinity groups</b><br>Feature: <br>Added priorities to nonenforcing affinity groups. If not all affinity groups can be satisfied, the groups with lower priority are broken first.<br><br>Reason: <br>Some affinities can be more important than others. Previously, it was not possible to specify it.<br><br>Result: <br>When a VM is started or migrated, a host is chosen, such that the broken affinity groups have the lowest priority.<br><br>A new text field has been added to the affinity group dialog, to set to priority. It can contain any real number, not just integers. Priority can also be set using a new parameter in the REST API.

### Bug Fixes

#### oVirt image transfer daemon and proxy

 - [BZ 1637809](https://bugzilla.redhat.com/1637809) <b>ovirt-imageio-proxy should use apache's pki</b><br>

#### oVirt Engine

 - [BZ 1733438](https://bugzilla.redhat.com/1733438) <b>[downstream clone - 4.3.6] engine-setup fails to upgrade to 4.3 with Unicode characters in CA subject</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1691933](https://bugzilla.redhat.com/1691933) <b>/etc/sudoers.d/50_vdsm_hook_ovirt_provider_ovn_hook is missing the commands of ovirt_provider_ovn_vhostuser_hook</b><br>
 - [BZ 1725013](https://bugzilla.redhat.com/1725013) <b>vdsm-tool fails deploying fedora 29 host from el7 engine</b><br>
 - [BZ 1723800](https://bugzilla.redhat.com/1723800) <b>[OVN] Updating a router's 'admin_state_up' returns OK but does not change the property</b><br>

#### VDSM

 - [BZ 1726834](https://bugzilla.redhat.com/1726834) <b>ioprocess readfile(direct=True) does not use direct I/O</b><br>
 - [BZ 1691760](https://bugzilla.redhat.com/1691760) <b>[SR-IOV] not able to enable VF on broadcom network card</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1713304](https://bugzilla.redhat.com/1713304) <b>Fail to deploy hosted-engine with --6 on a dual-stack host</b><br>

#### oVirt Engine

 - [BZ 1686717](https://bugzilla.redhat.com/1686717) <b>UI Dialog for moving disks between Storagedomains is less useful</b><br>
 - [BZ 1720908](https://bugzilla.redhat.com/1720908) <b>Remove host fails when host is in maintenance as it's lock due to DisconnectHostFromStoragePoolServersCommand - host in maintenance should not be locked</b><br>
 - [BZ 1679867](https://bugzilla.redhat.com/1679867) <b>UI exception seen in RHV-M (models.vms.UnitVmModel.$validate)</b><br>
 - [BZ 1715435](https://bugzilla.redhat.com/1715435) <b>Failed to run check-update of host</b><br>
 - [BZ 1533160](https://bugzilla.redhat.com/1533160) <b>Webadmin-manage domain window - it's possible to insert a number bigger than storage domain size</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1715478](https://bugzilla.redhat.com/1715478) <b>Trying to move disk using REST-API during LSM, at RemoveSnapshot phase, leaves the disk in a status where it can't be moved again</b><br>
 - [BZ 1690155](https://bugzilla.redhat.com/1690155) <b>Disk migration progress bar not clearly visible and unusable.</b><br>

#### Contributors

24 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Andrej Cernek
	Andrej Krejcir
	Benny Zlotnik
	Dafna Ron
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Eitan Raviv
	Eyal Shenitzky
	Fedor Gavrilov
	Greg Sheremeta
	Ido Rosenzwig
	Martin Perina
	Miguel Duarte Barroso
	Nir Soffer
	Ondra Machacek
	Sandro Bonazzola
	Simone Tiraboschi
	Tomasz Baranski
	Vojtech Juranek
	Yedidyah Bar David
	mmirecki

---
title: oVirt 4.3.6 Release Notes
category: documentation
layout: toc
authors: sandrobonazzola
---

# oVirt 4.3.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.6 Second Release Candidate as of August 08, 2019.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.7,
CentOS Linux 7.7 (or similar).


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

 - [BZ 1734671](https://bugzilla.redhat.com/1734671) <b>[scale] updatevmdynamic broken if too many users logged in - psql ERROR: value too long for type character varying(255)</b><br>
 - [BZ 1733438](https://bugzilla.redhat.com/1733438) <b>[downstream clone - 4.3.6] engine-setup fails to upgrade to 4.3 with Unicode characters in CA subject</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1691933](https://bugzilla.redhat.com/1691933) <b>/etc/sudoers.d/50_vdsm_hook_ovirt_provider_ovn_hook is missing the commands of ovirt_provider_ovn_vhostuser_hook</b><br>
 - [BZ 1725013](https://bugzilla.redhat.com/1725013) <b>vdsm-tool fails deploying fedora 29 host from el7 engine</b><br>
 - [BZ 1723800](https://bugzilla.redhat.com/1723800) <b>[OVN] Updating a router's 'admin_state_up' returns OK but does not change the property</b><br>

#### VDSM

 - [BZ 1592916](https://bugzilla.redhat.com/1592916) <b>[blocked on platform bug 1690511] Support device block size of 4096 bytes for file based storage domains</b><br>
 - [BZ 1726834](https://bugzilla.redhat.com/1726834) <b>ioprocess readfile(direct=True) does not use direct I/O</b><br>
 - [BZ 1691760](https://bugzilla.redhat.com/1691760) <b>[SR-IOV] not able to enable VF on broadcom network card</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1713304](https://bugzilla.redhat.com/1713304) <b>Fail to deploy hosted-engine with --6 on a dual-stack host</b><br>

#### oVirt Engine

 - [BZ 1639577](https://bugzilla.redhat.com/1639577) <b>[UI] - Tasks - Synchronizing networks on cluster <UNKNOWN></b><br>
 - [BZ 1720994](https://bugzilla.redhat.com/1720994) <b>sync all cluster networks - all sync host events are numbered '1/1' in events tab\engine.log</b><br>
 - [BZ 1619011](https://bugzilla.redhat.com/1619011) <b>"sync all cluster networks" - do not attempt to sync hosts which are already in sync</b><br>
 - [BZ 1734429](https://bugzilla.redhat.com/1734429) <b>Support device block size of 4096 bytes for file based storage domains</b><br>
 - [BZ 1720487](https://bugzilla.redhat.com/1720487) <b>[REST] Unable to set 'Unlimited' QOS for vNIC profile using RESTAPI</b><br>
 - [BZ 1730436](https://bugzilla.redhat.com/1730436) <b>Snapshot creation was successful, but snapshot remains locked</b><br>
 - [BZ 1686717](https://bugzilla.redhat.com/1686717) <b>UI Dialog for moving disks between Storagedomains is less useful</b><br>
 - [BZ 1720908](https://bugzilla.redhat.com/1720908) <b>Remove host fails when host is in maintenance as it's lock due to DisconnectHostFromStoragePoolServersCommand - host in maintenance should not be locked</b><br>
 - [BZ 1679867](https://bugzilla.redhat.com/1679867) <b>UI exception seen in RHV-M (models.vms.UnitVmModel.$validate)</b><br>
 - [BZ 1715435](https://bugzilla.redhat.com/1715435) <b>Failed to run check-update of host</b><br>
 - [BZ 1533160](https://bugzilla.redhat.com/1533160) <b>Webadmin-manage domain window - it's possible to insert a number bigger than storage domain size</b><br>

#### oVirt Engine Appliance

 - [BZ 1737555](https://bugzilla.redhat.com/1737555) <b>pam_pkcs11 error trying to login to the graphical console of the hosted-engine VM</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1613702](https://bugzilla.redhat.com/1613702) <b>[RFE][UI] - Add out-of-sync icon indication for the cluster entity</b><br>
 - [BZ 1734360](https://bugzilla.redhat.com/1734360) <b>When vdsm spice CA file checking may fail if spice ca directory don't exists</b><br>
 - [BZ 1712437](https://bugzilla.redhat.com/1712437) <b>[downstream clone - 4.3.6] [scale] RHV-M runs out of memory due to to much data reported by the guest agent</b><br>
 - [BZ 1715478](https://bugzilla.redhat.com/1715478) <b>Trying to move disk using REST-API during LSM, at RemoveSnapshot phase, leaves the disk in a status where it can't be moved again</b><br>
 - [BZ 1690155](https://bugzilla.redhat.com/1690155) <b>Disk migration progress bar not clearly visible and unusable.</b><br>

#### Contributors

25 people contributed to this release:

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
	Martin Perina
	Miguel Duarte Barroso
	Nir Soffer
	Ondra Machacek
	Sandro Bonazzola
	Simone Tiraboschi
	Steven Rosenberg
	Tomasz Baranski
	Vojtech Juranek
	Yedidyah Bar David
	Yuval Turgeman
	mmirecki

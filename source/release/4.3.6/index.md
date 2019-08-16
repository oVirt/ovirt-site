---
title: oVirt 4.3.6 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

<style>
h1, h2, h3, h4, h5, h6, li, a, p {
    font-family: 'Open Sans', sans-serif !important;
}
</style>

# oVirt 4.3.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.6 Third Release Candidate as of August 22, 2019.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.7 and
CentOS Linux 7.7 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.3.6, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm)

## Known issues

Since CentOS 7.7 is not available yet, you can get missing sanlock dependency with this repo file:

	cat /etc/yum.repos.d/ov4.3-fix.repo
	[ovirt-4.3-fix]
	name=oVirt 4.3 Pre-Release Fix CentOS 7.7
	baseurl=https://buildlogs.centos.org/centos/7/virt/x86_64/ovirt-4.3/
	enabled=1
	gpgcheck=0
	exclude=python2-sanlock

Thanks to Maton Brett for sharing it on users mailing list

## What's New in 4.3.6?

### Release Note

#### oVirt Engine WildFly

 - [BZ 1732499](https://bugzilla.redhat.com/1732499) <b>Require WildFly 17.0.1 for oVirt Engine 4.3</b><br>oVirt engine 4.3.6 now depends on WildFly 17.0.1.FINAL

#### oVirt Engine

 - [BZ 1732499](https://bugzilla.redhat.com/1732499) <b>Require WildFly 17.0.1 for oVirt Engine 4.3</b><br>oVirt engine 4.3.6 now depends on WildFly 17.0.1.FINAL

### Enhancements

#### oVirt Engine

 - [BZ 1741152](https://bugzilla.redhat.com/1741152) <b>[downstream clone - 4.3.6] [RFE] - Creating an NFS storage domain the engine should let the user specify exact NFS version v4.0 and not just v4</b><br>
 - [BZ 1680498](https://bugzilla.redhat.com/1680498) <b>[RFE] Implement priorities for soft affinity groups</b><br>Feature: <br>Added priorities to nonenforcing affinity groups. If not all affinity groups can be satisfied, the groups with lower priority are broken first.<br><br>Reason: <br>Some affinities can be more important than others. Previously, it was not possible to specify it.<br><br>Result: <br>When a VM is started or migrated, a host is chosen, such that the broken affinity groups have the lowest priority.<br><br>A new text field has been added to the affinity group dialog, to set to priority. It can contain any real number, not just integers. Priority can also be set using a new parameter in the REST API.

### Bug Fixes

#### VDSM

 - [BZ 1660451](https://bugzilla.redhat.com/1660451) <b>Executor queue can get full if vm.destroy takes some time to complete</b><br>
 - [BZ 1740498](https://bugzilla.redhat.com/1740498) <b>[downstream clone - 4.3.6] Remove nwfilter configuration from the vdsmd service start</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1637809](https://bugzilla.redhat.com/1637809) <b>ovirt-imageio-proxy should use apache's pki</b><br>

#### oVirt Engine

 - [BZ 1709201](https://bugzilla.redhat.com/1709201) <b>Change md5 checksum used in GlusterHooks calls</b><br>
 - [BZ 1734671](https://bugzilla.redhat.com/1734671) <b>[scale] updatevmdynamic broken if too many users logged in - psql ERROR: value too long for type character varying(255)</b><br>
 - [BZ 1733438](https://bugzilla.redhat.com/1733438) <b>[downstream clone - 4.3.6] engine-setup fails to upgrade to 4.3 with Unicode characters in CA subject</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1691933](https://bugzilla.redhat.com/1691933) <b>/etc/sudoers.d/50_vdsm_hook_ovirt_provider_ovn_hook is missing the commands of ovirt_provider_ovn_vhostuser_hook</b><br>
 - [BZ 1725013](https://bugzilla.redhat.com/1725013) <b>vdsm-tool fails deploying fedora 29 host from el7 engine</b><br>
 - [BZ 1723800](https://bugzilla.redhat.com/1723800) <b>[OVN] Updating a router's 'admin_state_up' returns OK but does not change the property</b><br>

#### VDSM

 - [BZ 1740774](https://bugzilla.redhat.com/1740774) <b>Pad memory volumes to 4096 bytes to support 4K storage</b><br>
 - [BZ 1719789](https://bugzilla.redhat.com/1719789) <b>dynamic_ownership enabled breaks file ownership after virtual machine migration and shutdown for disk images on Gluster SD when libgfapi is enabled</b><br>
 - [BZ 1673277](https://bugzilla.redhat.com/1673277) <b>"Volume Option cluster.granular-entry-heal=enable could not be set" when using "Optimize for Virt store"</b><br>
 - [BZ 1688052](https://bugzilla.redhat.com/1688052) <b>Typo and exception due to non-iterable object on gluster fencing testing</b><br>
 - [BZ 1592916](https://bugzilla.redhat.com/1592916) <b>[blocked on platform bug 1690511] Support device block size of 4096 bytes for file based storage domains</b><br>
 - [BZ 1726834](https://bugzilla.redhat.com/1726834) <b>ioprocess readfile(direct=True) does not use direct I/O</b><br>
 - [BZ 1691760](https://bugzilla.redhat.com/1691760) <b>[SR-IOV] not able to enable VF on broadcom network card</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1739147](https://bugzilla.redhat.com/1739147) <b>[RFE] Support 4k storage - ovirt-hosted-engine-ha</b><br>
 - [BZ 1704500](https://bugzilla.redhat.com/1704500) <b>auditd logs full of sudo events from vdsm</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1713304](https://bugzilla.redhat.com/1713304) <b>Fail to deploy hosted-engine with --6 on a dual-stack host</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1737353](https://bugzilla.redhat.com/1737353) <b>he-invalid-engine-fqdn-err "Unable to resolve address" is missing in cockpit UI</b><br>

#### oVirt Engine

 - [BZ 1743246](https://bugzilla.redhat.com/1743246) <b>[downstream clone - 4.3.6] Move/Copy disk are blocked if there is less space in source SD than the size of the disk</b><br>
 - [BZ 1731245](https://bugzilla.redhat.com/1731245) <b>Wrong disk size of managed block device disk shown when virtual machine: Bytes instead of gigabytes</b><br>
 - [BZ 1741155](https://bugzilla.redhat.com/1741155) <b>[downstream clone - 4.3.6] a new size of the direct LUN not updated in Admin Portal</b><br>
 - [BZ 1739134](https://bugzilla.redhat.com/1739134) <b>Error creating local storage domain: Internal Engine Error.</b><br>
 - [BZ 1730264](https://bugzilla.redhat.com/1730264) <b>VMs will fail to start if the vnic profile attached is having port mirroring enabled and have name greater than 15 characters</b><br>
 - [BZ 1639577](https://bugzilla.redhat.com/1639577) <b>[UI] - Tasks - Synchronizing networks on cluster <UNKNOWN></b><br>
 - [BZ 1720994](https://bugzilla.redhat.com/1720994) <b>sync all cluster networks - all sync host events are numbered '1/1' in events tab\engine.log</b><br>
 - [BZ 1619011](https://bugzilla.redhat.com/1619011) <b>"sync all cluster networks" - do not attempt to sync hosts which are already in sync</b><br>
 - [BZ 1734429](https://bugzilla.redhat.com/1734429) <b>Support device block size of 4096 bytes for file based storage domains</b><br>
 - [BZ 1720487](https://bugzilla.redhat.com/1720487) <b>[REST] Unable to set 'Unlimited' QOS for vNIC profile using RESTAPI</b><br>
 - [BZ 1686717](https://bugzilla.redhat.com/1686717) <b>UI Dialog for moving disks between Storagedomains is less useful</b><br>
 - [BZ 1720908](https://bugzilla.redhat.com/1720908) <b>Remove host fails when host is in maintenance as it's lock due to DisconnectHostFromStoragePoolServersCommand - host in maintenance should not be locked</b><br>
 - [BZ 1679867](https://bugzilla.redhat.com/1679867) <b>UI exception seen in RHV-M (models.vms.UnitVmModel.$validate)</b><br>
 - [BZ 1533160](https://bugzilla.redhat.com/1533160) <b>Webadmin-manage domain window - it's possible to insert a number bigger than storage domain size</b><br>

#### oVirt Engine Appliance

 - [BZ 1737555](https://bugzilla.redhat.com/1737555) <b>pam_pkcs11 error trying to login to the graphical console of the hosted-engine VM</b><br>

#### ovirt-engine-extension-aaa-misc

 - [BZ 1713195](https://bugzilla.redhat.com/1713195) <b>ovirt-engine-extension-aaa-misc doesn't build on Fedora 29</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1715959](https://bugzilla.redhat.com/1715959) <b>Single node RHHI-V deployment, results in the host added twice to the cluster, one with backend and other with frontend FQDN</b><br>
 - [BZ 1712714](https://bugzilla.redhat.com/1712714) <b>Provide option for user to attach LVM Cache to specific thinpool</b><br>
 - [BZ 1693149](https://bugzilla.redhat.com/1693149) <b>[Day 2] With expand cluster, newly added nodes are not added in to the existing gluster cluster</b><br>
 - [BZ 1690741](https://bugzilla.redhat.com/1690741) <b>Cockpit Day 2 - RFE - Support for expanding volume/creating bricks</b><br>
 - [BZ 1692793](https://bugzilla.redhat.com/1692793) <b>[Day 2] While creating new volume or expanding the volume using day2, option to add brick should be removed</b><br>
 - [BZ 1690801](https://bugzilla.redhat.com/1690801) <b>Disk count and stripe size are missing in the deployment wizard, when changing disktype from JBOD to RAID</b><br>
 - [BZ 1715461](https://bugzilla.redhat.com/1715461) <b>Changing the name from FQDN to additional hosts in cockpit</b><br>
 - [BZ 1738019](https://bugzilla.redhat.com/1738019) <b>Update LV cache related variables in generated vars file</b><br>
 - [BZ 1738502](https://bugzilla.redhat.com/1738502) <b>LVM cache feature not possible with ansible-2.8</b><br>
 - [BZ 1721371](https://bugzilla.redhat.com/1721371) <b>Provide a way to cleanup gluster deployment from cockpit</b><br>
 - [BZ 1693657](https://bugzilla.redhat.com/1693657) <b>Enable LV thinpool on VDO devices</b><br>
 - [BZ 1724035](https://bugzilla.redhat.com/1724035) <b>Move the preflight check in to ansible pre-task for automated CLI deployment</b><br>
 - [BZ 1713935](https://bugzilla.redhat.com/1713935) <b>[RFE] Add Log verbosity flag to Cockpit installer</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1726758](https://bugzilla.redhat.com/1726758) <b>[Cinderlib] - Error connecting to ceph cluster when starting VM with Ceph MBD disk</b><br>
 - [BZ 1613702](https://bugzilla.redhat.com/1613702) <b>[RFE][UI] - Add out-of-sync icon indication for the cluster entity</b><br>
 - [BZ 1730436](https://bugzilla.redhat.com/1730436) <b>Snapshot creation was successful, but snapshot remains locked</b><br>
 - [BZ 1734360](https://bugzilla.redhat.com/1734360) <b>When vdsm spice CA file checking may fail if spice ca directory don't exists</b><br>
 - [BZ 1712437](https://bugzilla.redhat.com/1712437) <b>[downstream clone - 4.3.6] [scale] RHV-M runs out of memory due to to much data reported by the guest agent</b><br>
 - [BZ 1715478](https://bugzilla.redhat.com/1715478) <b>Trying to move disk using REST-API during LSM, at RemoveSnapshot phase, leaves the disk in a status where it can't be moved again</b><br>
 - [BZ 1690155](https://bugzilla.redhat.com/1690155) <b>Disk migration progress bar not clearly visible and unusable.</b><br>

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1733111](https://bugzilla.redhat.com/1733111) <b>[ovirt-engine-extension-aaa-ldap-setup] dig command usage does not allow for tcp fallback</b><br>

#### Contributors

43 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Andrej Cernek
	Andrej Krejcir
	Bell Levin
	Benny Zlotnik
	Dafna Ron
	Daniel Erez
	Denis Chaplygin
	Dominik Holler
	Eitan Raviv
	Eyal Shenitzky
	Fedor Gavrilov
	Gal Zaidman
	Gobinda Das
	Greg Sheremeta
	Ido Rosenzwig
	Joey
	Kaustav Majumder
	Lev Veyde
	Martin Perina
	Michal Skrivanek
	Miguel Duarte Barroso
	Milan Zamazal
	Nir Soffer
	Ondra Machacek
	Pavel Bar
	Sahina Bose
	Sandro Bonazzola
	Shani Leviim
	Shirly Radco
	Simone Tiraboschi
	Steven Rosenberg
	Tomasz Baranski
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
	Yuval Turgeman
	godas
	imjoey
	jenkins CI
	mmirecki
	parthdhanjal

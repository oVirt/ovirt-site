---
title: oVirt 4.3.6 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---


# oVirt 4.3.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.6 release as of September 26, 2019.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.7 and
CentOS Linux 7.7 (or similar).



If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.3.6, see the
[release notes for previous versions](/documentation/#previous-release-notes).



## What's New in 4.3.6?

Release has been updated on [October 8th providing additional fixes](https://lists.ovirt.org/archives/list/announce@ovirt.org/thread/L7HQ3OU3PUEOJZKKZPLDOCUNMZD6UW5C/).

### Release Note

#### oVirt Engine WildFly

 - [BZ 1732499](https://bugzilla.redhat.com/show_bug.cgi?id=1732499) <b>Require WildFly 17.0.1 for oVirt Engine 4.3</b><br>oVirt engine 4.3.6 now depends on WildFly 17.0.1.FINAL

#### oVirt Engine

 - [BZ 1732499](https://bugzilla.redhat.com/show_bug.cgi?id=1732499) <b>Require WildFly 17.0.1 for oVirt Engine 4.3</b><br>oVirt engine 4.3.6 now depends on WildFly 17.0.1.FINAL

### Enhancements

#### VDSM

 - [BZ 1753116](https://bugzilla.redhat.com/show_bug.cgi?id=1753116) <b>require updated kernel for CVE-2019-14835</b><br>vdsm now requires a host kernel with fix for CVE-2019-14835

#### oVirt Engine

 - [BZ 1741152](https://bugzilla.redhat.com/show_bug.cgi?id=1741152) <b>[downstream clone - 4.3.6] [RFE] - Creating an NFS storage domain the engine should let the user specify exact NFS version v4.0 and not just v4</b><br>
 - [BZ 1680498](https://bugzilla.redhat.com/show_bug.cgi?id=1680498) <b>[RFE] Implement priorities for soft affinity groups</b><br>A new text field has been added to the affinity group dialog to set priority. It can contain any real number, not just integers. Priority can also be set using a new parameter in the REST API.<br>When a Virtual Machine is started or migrated, a host is selected, with the broken affinity groups having the lowest priority.<br>If not all affinity groups can be satisfied, the groups with lower priority are broken first.

#### imgbased

 - [BZ 1744027](https://bugzilla.redhat.com/show_bug.cgi?id=1744027) <b>[downstream clone - 4.3.6] [RFE] Warn if SELinux is disabled when upgrading RHV-H</b><br>

#### IOProcess

 - [BZ 1753901](https://bugzilla.redhat.com/show_bug.cgi?id=1753901) <b>ioprocess - Implement block size detection compatible with Gluster storage</b><br>The current release provides an API to probe the block size of the underlying filesystem. The vdsm package needs this  API to support 4k storage on gluster.

### Bug Fixes

#### VDSM

 - [BZ 1748395](https://bugzilla.redhat.com/show_bug.cgi?id=1748395) <b>[downstream clone - 4.3.6] Can't import guest from export domain to data domain on rhv4.3 due to error "Invalid parameter: 'DiskType=1'"</b><br>
 - [BZ 1744572](https://bugzilla.redhat.com/show_bug.cgi?id=1744572) <b>[downstream clone - 4.3.6] VDSM command Get Host Statistics failed: Internal JSON-RPC error: {'reason': '[Errno 19] vnet<x> is not present in the system'}</b><br>
 - [BZ 1746718](https://bugzilla.redhat.com/show_bug.cgi?id=1746718) <b>[downstream clone - 4.3.6] Typo and exception due to non-iterable object on gluster fencing testing</b><br>
 - [BZ 1660451](https://bugzilla.redhat.com/show_bug.cgi?id=1660451) <b>Executor queue can get full if vm.destroy takes some time to complete</b><br>
 - [BZ 1740498](https://bugzilla.redhat.com/show_bug.cgi?id=1740498) <b>[downstream clone - 4.3.6] Remove nwfilter configuration from the vdsmd service start</b><br>
 - [BZ 1691760](https://bugzilla.redhat.com/show_bug.cgi?id=1691760) <b>[SR-IOV] cannot enable VF on broadcom network card</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1637809](https://bugzilla.redhat.com/show_bug.cgi?id=1637809) <b>ovirt-imageio-proxy should use apache's pki</b><br>

#### oVirt Engine

 - [BZ 1753168](https://bugzilla.redhat.com/show_bug.cgi?id=1753168) <b>[downstream clone - 4.3.6] teardownImage attempts to deactivate in-use LV's rendering the VM disk image/volumes in locked state.</b><br>
 - [BZ 1751142](https://bugzilla.redhat.com/show_bug.cgi?id=1751142) <b>[downstream clone - 4.3.6] host activation causes RHHI nodes to lose the quorum</b><br>
 - [BZ 1709201](https://bugzilla.redhat.com/show_bug.cgi?id=1709201) <b>Change md5 checksum used in GlusterHooks calls</b><br>
 - [BZ 1734671](https://bugzilla.redhat.com/show_bug.cgi?id=1734671) <b>[scale] updatevmdynamic broken if too many users logged in - psql ERROR: value too long for type character varying(255)</b><br>
 - [BZ 1733438](https://bugzilla.redhat.com/show_bug.cgi?id=1733438) <b>[downstream clone - 4.3.6] engine-setup fails to upgrade to 4.3 with Unicode characters in CA subject</b><br>

#### oVirt Engine Metrics

 - [BZ 1723453](https://bugzilla.redhat.com/show_bug.cgi?id=1723453) <b>Install failed on timeout during "Wait for resize"</b><br>

### Other

#### VDSM

 - [BZ 1740774](https://bugzilla.redhat.com/show_bug.cgi?id=1740774) <b>Pad memory volumes to 4096 bytes to support 4K storage</b><br>
 - [BZ 1726834](https://bugzilla.redhat.com/show_bug.cgi?id=1726834) <b>ioprocess readfile(direct=True) does not use direct I/O</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1704500](https://bugzilla.redhat.com/show_bug.cgi?id=1704500) <b>auditd logs full of sudo events from vdsm</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1713304](https://bugzilla.redhat.com/show_bug.cgi?id=1713304) <b>Fail to deploy hosted-engine with --6 on a dual-stack host</b><br>

#### oVirt Ansible hosted-engine setup role

 - [BZ 1737353](https://bugzilla.redhat.com/show_bug.cgi?id=1737353) <b>he-invalid-engine-fqdn-err "Unable to resolve address" is missing in cockpit UI</b><br>
 - [BZ 1711672](https://bugzilla.redhat.com/show_bug.cgi?id=1711672) <b>hosted-engine-setup fails if LANGUAGE set to some local language</b><br>

#### oVirt Engine

 - [BZ 1758052](https://bugzilla.redhat.com/show_bug.cgi?id=1758052) <b>Create VM rollback fails with NPE leaving VM locked - Exception in invoking callback of command AddVmFromTemplate- Exception: javax.ejb.EJBTransactionRolledbackException</b><br>
 - [BZ 1757782](https://bugzilla.redhat.com/show_bug.cgi?id=1757782) <b>Deleting a Single snapshot disk live merge 'REDUCE_IMAGE' step fails with NPE and snapshot disk remains in illegal state</b><br>
 - [BZ 1755869](https://bugzilla.redhat.com/show_bug.cgi?id=1755869) <b>[downstream clone - 4.3.6] RHV 4.3 throws an exception when trying to access VMs which have snapshots from unsupported compatibility levels</b><br>
 - [BZ 1680499](https://bugzilla.redhat.com/show_bug.cgi?id=1680499) <b>[RFE] Allowing use of labels in affinity groups</b><br>
 - [BZ 1748387](https://bugzilla.redhat.com/show_bug.cgi?id=1748387) <b>[downstream clone - 4.3.7] NPE in DestroyImage endAction during live merge leaving a task in DB for hours causing operations depending on host clean tasks to fail as Deactivate host/StopSPM/deactivate SD</b><br>
 - [BZ 1745491](https://bugzilla.redhat.com/show_bug.cgi?id=1745491) <b>[downstream clone - 4.3.6] Unable to start guests in our Power9 cluster without running in headless mode.</b><br>
 - [BZ 1715435](https://bugzilla.redhat.com/show_bug.cgi?id=1715435) <b>Failed to run check-update of host</b><br>
 - [BZ 1741893](https://bugzilla.redhat.com/show_bug.cgi?id=1741893) <b>uploading raw image to cow disk fails on verify volume</b><br>
 - [BZ 1731245](https://bugzilla.redhat.com/show_bug.cgi?id=1731245) <b>Wrong disk size of managed block device disk shown when virtual machine: Bytes instead of gigabytes</b><br>
 - [BZ 1741155](https://bugzilla.redhat.com/show_bug.cgi?id=1741155) <b>[downstream clone - 4.3.6] a new size of the direct LUN not updated in Admin Portal</b><br>
 - [BZ 1739134](https://bugzilla.redhat.com/show_bug.cgi?id=1739134) <b>Error creating local storage domain: Internal Engine Error.</b><br>
 - [BZ 1744571](https://bugzilla.redhat.com/show_bug.cgi?id=1744571) <b>[downstream clone - 4.3.6] VMs will fail to start if the vnic profile attached is having port mirroring enabled and have name greater than 15 characters</b><br>
 - [BZ 1639577](https://bugzilla.redhat.com/show_bug.cgi?id=1639577) <b>[UI] - Tasks - Synchronizing networks on cluster <UNKNOWN></b><br>
 - [BZ 1720994](https://bugzilla.redhat.com/show_bug.cgi?id=1720994) <b>sync all cluster networks - all sync host events are numbered '1/1' in events tab\engine.log</b><br>
 - [BZ 1619011](https://bugzilla.redhat.com/show_bug.cgi?id=1619011) <b>"sync all cluster networks" - do not attempt to sync hosts which are already in sync</b><br>
 - [BZ 1734429](https://bugzilla.redhat.com/show_bug.cgi?id=1734429) <b>Support device block size of 4096 bytes for file based storage domains</b><br>
 - [BZ 1720487](https://bugzilla.redhat.com/show_bug.cgi?id=1720487) <b>[REST] Unable to set 'Unlimited' QOS for vNIC profile using RESTAPI</b><br>
 - [BZ 1686717](https://bugzilla.redhat.com/show_bug.cgi?id=1686717) <b>UI Dialog for moving disks between Storagedomains is less useful</b><br>
 - [BZ 1720908](https://bugzilla.redhat.com/show_bug.cgi?id=1720908) <b>Remove host fails when host is in maintenance as it's lock due to DisconnectHostFromStoragePoolServersCommand - host in maintenance should not be locked</b><br>
 - [BZ 1679867](https://bugzilla.redhat.com/show_bug.cgi?id=1679867) <b>UI exception seen in RHV-M (models.vms.UnitVmModel.$validate)</b><br>
 - [BZ 1533160](https://bugzilla.redhat.com/show_bug.cgi?id=1533160) <b>Webadmin-manage domain window - it's possible to insert a number bigger than storage domain size</b><br>
 - [BZ 1744510](https://bugzilla.redhat.com/show_bug.cgi?id=1744510) <b>[downstream clone - 4.3.6] Disk migration progress bar not clearly visible and unusable.</b><br>
 - [BZ 1749202](https://bugzilla.redhat.com/show_bug.cgi?id=1749202) <b> - [downstream clone - 4.3.7] "Field 'foo' can not be updated when status is 'Up'" in engine.log when listing 'NEXT_RUN' configuration snapshot VMs</b><br>

#### oVirt Engine Appliance

 - [BZ 1737555](https://bugzilla.redhat.com/show_bug.cgi?id=1737555) <b>pam_pkcs11 error trying to login to the graphical console of the hosted-engine VM</b><br>When trying to log in to a Self-Hosted Engine virtual machine using a VNC or SPICE console, an error regarding smart card authorization is displayed.<br>With this release, the log in process completes without errors.

#### oVirt Engine Data Warehouse

 - [BZ 1727550](https://bugzilla.redhat.com/show_bug.cgi?id=1727550) <b>Install DWH  on separate machine failed - problem with execute stage 'Misc configuration'</b><br>

#### ovirt-engine-extension-aaa-misc

 - [BZ 1713195](https://bugzilla.redhat.com/show_bug.cgi?id=1713195) <b>ovirt-engine-extension-aaa-misc doesn't build on Fedora 29</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1746728](https://bugzilla.redhat.com/show_bug.cgi?id=1746728) <b>Day 2 [Expand Volume]: Logical size is incorrect while providing the LV size</b><br>
 - [BZ 1746452](https://bugzilla.redhat.com/show_bug.cgi?id=1746452) <b>lvcache should be the same as input from user</b><br>
 - [BZ 1745565](https://bugzilla.redhat.com/show_bug.cgi?id=1745565) <b>Remove the default arbiter check for vmstore volume</b><br>
 - [BZ 1745503](https://bugzilla.redhat.com/show_bug.cgi?id=1745503) <b>VDO with LVM thinpool needs correct entry in inventory file in cockpit based deployment.</b><br>
 - [BZ 1745501](https://bugzilla.redhat.com/show_bug.cgi?id=1745501) <b>Deployment wizard has overlapped buttons, for the scenario of reusing existing configuration</b><br>
 - [BZ 1739881](https://bugzilla.redhat.com/show_bug.cgi?id=1739881) <b>Rename lifecycle methods to support React 17.x</b><br>
 - [BZ 1715959](https://bugzilla.redhat.com/show_bug.cgi?id=1715959) <b>Single node RHHI-V deployment, results in the host added twice to the cluster, one with backend and other with frontend FQDN</b><br>
 - [BZ 1712714](https://bugzilla.redhat.com/show_bug.cgi?id=1712714) <b>Provide option for user to attach LVM Cache to specific thinpool</b><br>
 - [BZ 1693149](https://bugzilla.redhat.com/show_bug.cgi?id=1693149) <b>[Day 2] With expand cluster, newly added nodes are not added in to the existing gluster cluster</b><br>
 - [BZ 1690741](https://bugzilla.redhat.com/show_bug.cgi?id=1690741) <b>Cockpit Day 2 - RFE - Support for expanding volume/creating bricks</b><br>
 - [BZ 1692793](https://bugzilla.redhat.com/show_bug.cgi?id=1692793) <b>[Day 2] While creating new volume or expanding the volume using day2, option to add brick should be removed</b><br>
 - [BZ 1690801](https://bugzilla.redhat.com/show_bug.cgi?id=1690801) <b>Disk count and stripe size are missing in the deployment wizard, when changing disktype from JBOD to RAID</b><br>
 - [BZ 1715461](https://bugzilla.redhat.com/show_bug.cgi?id=1715461) <b>Changing the name from FQDN to additional hosts in cockpit</b><br>
 - [BZ 1738019](https://bugzilla.redhat.com/show_bug.cgi?id=1738019) <b>Update LV cache related variables in generated vars file</b><br>
 - [BZ 1738502](https://bugzilla.redhat.com/show_bug.cgi?id=1738502) <b>LVM cache feature not possible with ansible-2.8</b><br>
 - [BZ 1721371](https://bugzilla.redhat.com/show_bug.cgi?id=1721371) <b>Provide a way to cleanup gluster deployment from cockpit</b><br>
 - [BZ 1693657](https://bugzilla.redhat.com/show_bug.cgi?id=1693657) <b>Enable LV thinpool on VDO devices</b><br>
 - [BZ 1724035](https://bugzilla.redhat.com/show_bug.cgi?id=1724035) <b>Move the preflight check in to ansible pre-task for automated CLI deployment</b><br>
 - [BZ 1713935](https://bugzilla.redhat.com/show_bug.cgi?id=1713935) <b>[RFE] Add Log verbosity flag to Cockpit installer</b><br>

#### oVirt Engine UI Extensions

 - [BZ 1751144](https://bugzilla.redhat.com/show_bug.cgi?id=1751144) <b>[UI] cluster upgrade dialog big margin</b><br>

#### oVirt Host Deploy

 - [BZ 1747787](https://bugzilla.redhat.com/show_bug.cgi?id=1747787) <b>Failed to deploy hosted engine with Failed to execute stage 'Misc configuration': expected string or buffer</b><br>
 - [BZ 1737926](https://bugzilla.redhat.com/show_bug.cgi?id=1737926) <b>[downstream clone - 4.3.6] Setting FIPS parameter from the engine will make the host unable to reboot if /boot resides on a separate partition (as in RHV-H case)</b><br>

### No Doc Update

#### VDSM

 - [BZ 1755271](https://bugzilla.redhat.com/show_bug.cgi?id=1755271) <b>[downstream clone - 4.3.6] Make block size detection compatible with Gluster storage</b><br>
 - [BZ 1719789](https://bugzilla.redhat.com/show_bug.cgi?id=1719789) <b>dynamic_ownership enabled breaks file ownership after virtual machine migration and shutdown for disk images on Gluster SD when libgfapi is enabled</b><br>

#### oVirt Engine

 - [BZ 1718694](https://bugzilla.redhat.com/show_bug.cgi?id=1718694) <b>Fix message about removing iptables support in 4.3</b><br>
 - [BZ 1746730](https://bugzilla.redhat.com/show_bug.cgi?id=1746730) <b>[downstream clone - 4.3.6] Engine deletes the leaf volume when SnapshotVDSCommand timed out without checking if the  volume is still used by the VM</b><br>
 - [BZ 1737612](https://bugzilla.redhat.com/show_bug.cgi?id=1737612) <b>[CodeChange][i18n] oVirt 4.3 webadmin - translation update</b><br>
 - [BZ 1733089](https://bugzilla.redhat.com/show_bug.cgi?id=1733089) <b>engine-setup role fails if ovn password is not supplied in vault</b><br>
 - [BZ 1743246](https://bugzilla.redhat.com/show_bug.cgi?id=1743246) <b>[downstream clone - 4.3.6] Move/Copy disk are blocked if there is less space in source SD than the size of the disk</b><br>
 - [BZ 1726758](https://bugzilla.redhat.com/show_bug.cgi?id=1726758) <b>[Cinderlib] - Error connecting to ceph cluster when starting VM with Ceph MBD disk</b><br>
 - [BZ 1613702](https://bugzilla.redhat.com/show_bug.cgi?id=1613702) <b>[RFE][UI] - Add out-of-sync icon indication for the cluster entity</b><br>
 - [BZ 1744507](https://bugzilla.redhat.com/show_bug.cgi?id=1744507) <b>[downstream clone - 4.3.6] Snapshot creation was successful, but snapshot remains locked</b><br>
 - [BZ 1734360](https://bugzilla.redhat.com/show_bug.cgi?id=1734360) <b>When vdsm spice CA file checking may fail if spice ca directory don't exists</b><br>
 - [BZ 1715478](https://bugzilla.redhat.com/show_bug.cgi?id=1715478) <b>Trying to move disk using REST-API during LSM, at RemoveSnapshot phase, leaves the disk in a status where it can't be moved again</b><br>

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1733111](https://bugzilla.redhat.com/show_bug.cgi?id=1733111) <b>[ovirt-engine-extension-aaa-ldap-setup] dig command usage does not allow for tcp fallback</b><br>

#### oVirt Engine UI Extensions

 - [BZ 1750669](https://bugzilla.redhat.com/show_bug.cgi?id=1750669) <b>Cluster upgrade dialogue closes unexpectedly with Minified React error #130</b><br>

#### Contributors

58 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Andrej Krejcir
	Bell Levin
	Benny Zlotnik
	Bohdan Iakymets
	Charles Thao
	Daniel Erez
	Denis Chaplygin
	Divan Santana
	Dominik Holler
	Eitan Raviv
	Eyal Edri
	Eyal Shenitzky
	Fedor Gavrilov
	Gal Zaidman
	Gobinda Das
	Greg Sheremeta
	Ido Rosenzwig
	Jan Zmeskal
	Joey
	Kaustav Majumder
	Lev Veyde
	Liran Rotenberg
	Lucia Jelinkova
	Marcin Sobczyk
	Martin Necas
	Martin Nečas
	Martin Perina
	Michal Skrivanek
	Milan Zamazal
	Nir Soffer
	Ondra Machacek
	Ori_Liel
	Pavel Bar
	Sahina Bose
	Sandro Bonazzola
	Scott Dickerson
	Scott J Dickerson
	Shani Leviim
	Sharon Gratch
	Shirly Radco
	Simone Tiraboschi
	Steven Rosenberg
	Tomasz Baranski
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David
	Yotam Fromm
	Yuval Turgeman
	bond95
	godas
	imjoey
	jenkins CI
	jirimacku
	michalskrivanek
	parthdhanjal
	thaorell

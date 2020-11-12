---
title: oVirt 4.4.4 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
page_classes: releases
---

# oVirt 4.4.4 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.4 First Release Candidate as of November 12, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.2 and
CentOS Linux 8.2 (or similar).

To find out how to interact with oVirt developers and users and ask questions,
visit our [community page](/community/).
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

To learn about features introduced before 4.4.4, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)



## What's New in 4.4.4?

### Bug Fixes

#### oVirt Engine

 - [BZ 1891293](https://bugzilla.redhat.com/1891293) **auto_pinning calculation is broken for hosts with 4 NUMA nodes. request fails**

 - [BZ 1871792](https://bugzilla.redhat.com/1871792) **Importing VM using virt-v2v fails if service ovirt-engine restarted during AddDisk operation.**

 - [BZ 1694711](https://bugzilla.redhat.com/1694711) **Incorrect NUMA pinning due to improper correlation between CPU sockets and NUMA nodes**


### Other

#### oVirt Engine Data Warehouse

 - [BZ 1892247](https://bugzilla.redhat.com/1892247) **Fix duplicates in time-based queries (that use the hourly + daily tables)**

   


#### oVirt Engine

 - [BZ 1893101](https://bugzilla.redhat.com/1893101) **nl-be keymap should be removed**

   

 - [BZ 1894758](https://bugzilla.redhat.com/1894758) **[DR] Remote data sync to the secondary site never completes**

   

 - [BZ 1880251](https://bugzilla.redhat.com/1880251) **VM stuck in "reboot in progress" ("virtual machine XXX should be running in a host but it isn't.").**

   

 - [BZ 1885132](https://bugzilla.redhat.com/1885132) **[OVN] Run OVN tasks on host re-install flow**

   

 - [BZ 1888278](https://bugzilla.redhat.com/1888278) **Refresh LUNs pop UI massage if the vm is powered off**

   

 - [BZ 1847090](https://bugzilla.redhat.com/1847090) **[RFE] Support transferring snapshots using raw format (NBD backend)**

   

 - [BZ 1890430](https://bugzilla.redhat.com/1890430) **Kubevirt / OpenShift Virtualization provider - the cluster/host cpu mismatch message**

   

 - [BZ 1881026](https://bugzilla.redhat.com/1881026) **UI Prints 'Actual timezone in the guest differs from the configuration' due to daylight saving time**

   

 - [BZ 1891303](https://bugzilla.redhat.com/1891303) **Cloning modal doesn't close automatically when cloning is finished/failed**

   

 - [BZ 1889394](https://bugzilla.redhat.com/1889394) **VM hosted by non-operational host fails in migration with NullPointerException**

   

 - [BZ 1890071](https://bugzilla.redhat.com/1890071) **Bond mode 4 is detected as custom bond options**

   


### No Doc Update

#### VDSM

 - [BZ 1839444](https://bugzilla.redhat.com/1839444) **[RFE] Use more efficient dumpStorageDomain() in dump-volume-chains**

   

 - [BZ 1833780](https://bugzilla.redhat.com/1833780) **Live storage migration failed -  Failed to change disk image**

   


#### oVirt Engine Data Warehouse

 - [BZ 1894420](https://bugzilla.redhat.com/1894420) **Stopping a remote dwh is broken**

   


#### oVirt Engine

 - [BZ 1833780](https://bugzilla.redhat.com/1833780) **Live storage migration failed -  Failed to change disk image**

   

 - [BZ 1846338](https://bugzilla.redhat.com/1846338) **Host monitoring does not report bond mode 1 active slave after engine is alive some time**

   

 - [BZ 1689362](https://bugzilla.redhat.com/1689362) **ovirt does not respect domcapabilities**

   


#### Contributors

25 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: vdsm)
	Amit Bawer (Contributed to: vdsm)
	Andrej Cernek (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Aviv Litman (Contributed to: ovirt-dwh)
	Bell Levin (Contributed to: vdsm)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dominik Holler (Contributed to: ovirt-engine)
	Jean-Louis Dupond (Contributed to: ovirt-engine)
	Kaustav Majumder (Contributed to: ovirt-engine)
	Lev Veyde (Contributed to: ovirt-engine)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Perina (Contributed to: ovirt-engine)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: vdsm)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-release)
	Shani Leviim (Contributed to: ovirt-engine)
	Shirly Radco (Contributed to: ovirt-dwh)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine)

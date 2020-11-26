---
title: oVirt 4.4.4 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
page_classes: releases
---

# oVirt 4.4.4 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.4 Third Release Candidate as of November 26, 2020.

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

### Enhancements

#### VDSM

 - [BZ 1859092](https://bugzilla.redhat.com/1859092) **Logical Name is missing when attaching RO direct LUN to a VM**

   Previously, the logical name of LUN disks within the guest weren't pull to the user visibility. Now, the LUN logical name is pulled and shown in the disk device.


#### oVirt Engine

 - [BZ 1859092](https://bugzilla.redhat.com/1859092) **Logical Name is missing when attaching RO direct LUN to a VM**

   Previously, the logical name of LUN disks within the guest weren't pull to the user visibility. Now, the LUN logical name is pulled and shown in the disk device.

 - [BZ 1872210](https://bugzilla.redhat.com/1872210) **[RFE] Don't require ovirt-guest-agent on Ubuntu 18.04.1 LTS (Bionic Beaver) and newer**

   Feature: Added support for Ubuntu 18.04, Debian 9 and later versions. Also turned off ovirt guest agent for Ubuntu 18.04 and later as well as Debian 9 versions and later.



Reason: To support the latest Ubuntu Operating Systems and to turn off ovirt guest agent support for the latest Ubuntu and Debian versions.



Result: The latest Ubuntu and Debian Operating Systems are now supported without ovirt guest agent support.


### Bug Fixes

#### oVirt Engine

 - [BZ 1875386](https://bugzilla.redhat.com/1875386) **openssl conf files point at qemu-ca-certificate**

 - [BZ 1855782](https://bugzilla.redhat.com/1855782) **Export VM task blocks other tasks**

 - [BZ 1797553](https://bugzilla.redhat.com/1797553) **[REST-API] exportToPathOnHost call works only synchronously**

 - [BZ 1889987](https://bugzilla.redhat.com/1889987) **Export VM task block other tasks**

 - [BZ 1886750](https://bugzilla.redhat.com/1886750) **VM host device is not removed while removing the host**

 - [BZ 1875363](https://bugzilla.redhat.com/1875363) **engine-setup failing on FIPS enable rhel8 machine**

 - [BZ 1758216](https://bugzilla.redhat.com/1758216) **[scale] Engine fails to create multiple pools of vms**

 - [BZ 1880251](https://bugzilla.redhat.com/1880251) **VM stuck in "reboot in progress" ("virtual machine XXX should be running in a host but it isn't.").**

 - [BZ 1891293](https://bugzilla.redhat.com/1891293) **auto_pinning calculation is broken for hosts with 4 NUMA nodes. request fails**

 - [BZ 1871792](https://bugzilla.redhat.com/1871792) **Importing VM using virt-v2v fails if service ovirt-engine restarted during AddDisk operation.**

 - [BZ 1694711](https://bugzilla.redhat.com/1694711) **Incorrect NUMA pinning due to improper correlation between CPU sockets and NUMA nodes**


### Other

#### VDSM

 - [BZ 1893773](https://bugzilla.redhat.com/1893773) **NVDIMM: memory usage in WebAdmin is always ~100% regardless to actual usage inside the VM.**

   


#### oVirt Engine Data Warehouse

 - [BZ 1851725](https://bugzilla.redhat.com/1851725) **[RFE] Add tags to grafana dashboards**

   

 - [BZ 1894298](https://bugzilla.redhat.com/1894298) **ModuleNotFoundError: No module named 'ovirt_engine' raised when starting ovirt-engine-dwhd.py in dev env**

   

 - [BZ 1892247](https://bugzilla.redhat.com/1892247) **Fix duplicates in time-based queries (that use the hourly + daily tables)**

   


#### oVirt Engine

 - [BZ 1899768](https://bugzilla.redhat.com/1899768) **Live merge fails on invoking callback end method 'onSucceeded' for a VM with Cluster Chipset/Firmware Type "Cluster default" or "Legacy".**

   

 - [BZ 1895697](https://bugzilla.redhat.com/1895697) **Modifying disk allocation target domain in the clone modal doesn't reflect on the cloned VM**

   

 - [BZ 1892291](https://bugzilla.redhat.com/1892291) **Change the representation of empty disk.usage statistics**

   

 - [BZ 1885997](https://bugzilla.redhat.com/1885997) **[OVS] Trigger sync while switching host from legacy type cluster to OVS type and vise versa**

   

 - [BZ 1893540](https://bugzilla.redhat.com/1893540) **Cannot clone a suspended VM**

   

 - [BZ 1710446](https://bugzilla.redhat.com/1710446) **[RFE] Europe/Helsinki timezone not available in RHV.**

   

 - [BZ 1897422](https://bugzilla.redhat.com/1897422) **Virtual Machine imported from OVA has no small/large_icon_id set in vm_static**

   

 - [BZ 1893101](https://bugzilla.redhat.com/1893101) **nl-be keymap should be removed**

   

 - [BZ 1894758](https://bugzilla.redhat.com/1894758) **[DR] Remote data sync to the secondary site never completes**

   

 - [BZ 1885132](https://bugzilla.redhat.com/1885132) **[OVN] Run OVN tasks on host re-install flow**

   

 - [BZ 1888278](https://bugzilla.redhat.com/1888278) **Refresh LUNs pop UI massage if the vm is powered off**

   

 - [BZ 1847090](https://bugzilla.redhat.com/1847090) **[RFE] Support transferring snapshots using raw format (NBD backend)**

   

 - [BZ 1890430](https://bugzilla.redhat.com/1890430) **Kubevirt / OpenShift Virtualization provider - the cluster/host cpu mismatch message**

   

 - [BZ 1881026](https://bugzilla.redhat.com/1881026) **UI Prints 'Actual timezone in the guest differs from the configuration' due to daylight saving time**

   

 - [BZ 1891303](https://bugzilla.redhat.com/1891303) **Cloning modal doesn't close automatically when cloning is finished/failed**

   

 - [BZ 1889394](https://bugzilla.redhat.com/1889394) **VM hosted by non-operational host fails in migration with NullPointerException**

   

 - [BZ 1890071](https://bugzilla.redhat.com/1890071) **Bond mode 4 is detected as custom bond options**

   

 - [BZ 1726558](https://bugzilla.redhat.com/1726558) **[v2v] VMware VMs with EFI BIOS and secure boot are converted to Q35 with UEFI instead of Q35 with SecureBoot**

   


#### VDSM JSON-RPC Java

 - [BZ 1890430](https://bugzilla.redhat.com/1890430) **Kubevirt / OpenShift Virtualization provider - the cluster/host cpu mismatch message**

   


#### oVirt Hosted Engine Setup

 - [BZ 1897888](https://bugzilla.redhat.com/1897888) **[RFE] Refine "hosted-engine --check-deployed" results.**

   


### No Doc Update

#### VDSM

 - [BZ 1895015](https://bugzilla.redhat.com/1895015) **Bad permissions in /etc/sudoers.d drop-in files**

   

 - [BZ 1839444](https://bugzilla.redhat.com/1839444) **[RFE] Use more efficient dumpStorageDomain() in dump-volume-chains**

   

 - [BZ 1833780](https://bugzilla.redhat.com/1833780) **Live storage migration failed -  Failed to change disk image**

   


#### oVirt Engine Data Warehouse

 - [BZ 1894420](https://bugzilla.redhat.com/1894420) **Stopping a remote dwh is broken**

   


#### oVirt Engine

 - [BZ 1811593](https://bugzilla.redhat.com/1811593) **Some PKI files are not removed by engine-cleanup**

   

 - [BZ 1833780](https://bugzilla.redhat.com/1833780) **Live storage migration failed -  Failed to change disk image**

   

 - [BZ 1856375](https://bugzilla.redhat.com/1856375) **Can't add additional host as hosted-engine ha-host from "Guide me" from UI.**

   

 - [BZ 1846338](https://bugzilla.redhat.com/1846338) **Host monitoring does not report bond mode 1 active slave after engine is alive some time**

   

 - [BZ 1689362](https://bugzilla.redhat.com/1689362) **ovirt does not respect domcapabilities**

   


#### VDSM JSON-RPC Java

 - [BZ 1846338](https://bugzilla.redhat.com/1846338) **Host monitoring does not report bond mode 1 active slave after engine is alive some time**

   


#### Contributors

35 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: vdsm)
	Amit Bawer (Contributed to: vdsm)
	Andrej Cernek (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh)
	Aviv Turgeman (Contributed to: cockpit-ovirt, ovirt-hosted-engine-setup)
	Bell Levin (Contributed to: vdsm)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dan Kenigsberg (Contributed to: vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Dominik Holler (Contributed to: ovirt-engine)
	Ehud Yonasi (Contributed to: vdsm)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine)
	Jean-Louis Dupond (Contributed to: ovirt-engine)
	Kaustav Majumder (Contributed to: ovirt-engine)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Perina (Contributed to: ovirt-engine)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: ovirt-engine, vdsm)
	Parth Dhanjal (Contributed to: cockpit-ovirt)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-release)
	Shani Leviim (Contributed to: ovirt-engine)
	Shirly Radco (Contributed to: ovirt-dwh)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Steven Rosenberg (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine)

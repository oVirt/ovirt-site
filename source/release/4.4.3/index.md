---
title: oVirt 4.4.3 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.4.3 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.3 First Release Candidate as of September 17, 2020.

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

To learn about features introduced before 4.4.3, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)



## What's New in 4.4.3?

### Enhancements

#### oVirt Engine

 - [BZ 1797717](https://bugzilla.redhat.com/1797717) **Search backend cannot find VMs which name starts with a search keyword**

   Feature: 



Enable to use a keyword in a free text search in search engine.



Search engine enables to enter free text pattern in a search expression, this

kind of search looks for the pattern on all the entity fields.



In the case that the free text pattern starts with a keyword (column

name) that is related to the searched entity, search engine fails to

find the expected results and generates an error.



For example, if you have a cluster named "namedCluster" and you are

searching for "Cluster:name*" , you will get an empty result and an

error complaining on illegal search, also if you are doing that from UI ,

you will see that the character '*' is marked with red.



Reason: 



search engine should enable to search for entity column values that are prefixed with a keyword



Result: 



Support for search for entity column values that are prefixed with a keyword was added

 - [BZ 1657294](https://bugzilla.redhat.com/1657294) **[RFE] - enable renaming HostedEngine VM name**

   Feature: 

Let the user specify a custom name for the engine VM

 - [BZ 1828347](https://bugzilla.redhat.com/1828347) **[RFE] support virtio-win flows in 4.4**

   Previously, you used Windows Guest Tools to install the required drivers for virtual machines running Microsoft Windows. Now, RHV version 4.4 uses VirtIO-Win to provide these drivers. For clusters with a compatibility level of 4.4 and later, the engine sign of the guest-agent depends on the available VirtIO-Win. The auto-attaching of a driver ISO is dropped in favor of Microsoft Windows updates. However, the initial installation needs to be done manually.

 - [BZ 1854888](https://bugzilla.redhat.com/1854888) **RHV-M shows successful operation if OVA export/import failed during "qemu-img convert" phase**

   Feature: Added error handling for ova importing and exporting.



Reason: When the qemu-img process failed, the engine was reporting a successful completion of the process when the process actually failed.



Result: Now when the qemu-img process fails to compete, the failure is detected and reported to the engine which fails appropriately.


### Bug Fixes

#### VDSM

 - [BZ 1870500](https://bugzilla.redhat.com/1870500) **Some of the qemu-ga commands do not block anymore**

 - [BZ 1800966](https://bugzilla.redhat.com/1800966) **HA VMs are not restarted in case of host reboot**

 - [BZ 1870108](https://bugzilla.redhat.com/1870108) **VM devices may get temporarily unplugged on VM boot**


#### oVirt Engine database query tool

 - [BZ 1866981](https://bugzilla.redhat.com/1866981) **obj must be encoded before hashing**


#### oVirt Engine

 - [BZ 1869317](https://bugzilla.redhat.com/1869317) **SCSI Hostdev Passthrough: VM snapshot is dropping attached scsi_hostdev.**

 - [BZ 1855249](https://bugzilla.redhat.com/1855249) **noVNC console via websocket with separated host doesn't work in chrome**

 - [BZ 1873322](https://bugzilla.redhat.com/1873322) **Engine fails to properly import ppc64le VMs from storage domain classifying it as x86_64**

 - [BZ 1874519](https://bugzilla.redhat.com/1874519) **Block CPU hotplug on UEFI**

 - [BZ 1872383](https://bugzilla.redhat.com/1872383) **Uploading disks via the upload_disk script fails due to an engine regression.**

 - [BZ 1632068](https://bugzilla.redhat.com/1632068) **Cannot import VM from KVM without ISO Domain active**

 - [BZ 1808320](https://bugzilla.redhat.com/1808320) **[Permissions] DataCenterAdmin role defined on DC level does not allow Cluster creation**


#### oVirt Engine Data Warehouse

 - [BZ 1846365](https://bugzilla.redhat.com/1846365) **Handle grafana in ovirt-engine-rename**

 - [BZ 1861368](https://bugzilla.redhat.com/1861368) **grafana startup may take some time**


### Other

#### VDSM

 - [BZ 1870148](https://bugzilla.redhat.com/1870148) **Cannot bond a NIC with vlan tagged network attachment**

   

 - [BZ 1871348](https://bugzilla.redhat.com/1871348) **Cannot transfer images from admin portal or via using proxy_url in SDK with all-in-one setup**

   

 - [BZ 1871202](https://bugzilla.redhat.com/1871202) **List of users logged into guest OS is not reset on logout**

   


#### oVirt Engine

 - [BZ 1873112](https://bugzilla.redhat.com/1873112) **Cannot update cluster chipset/firmware type if the cluster contains templates**

   

 - [BZ 1855305](https://bugzilla.redhat.com/1855305) **Cannot hotplug disk reports libvirtError: Requested operation is not valid: Domain already contains a disk with that address**

   

 - [BZ 1862785](https://bugzilla.redhat.com/1862785) **Update "USB Policy" and "USB Support" to match each other**

   

 - [BZ 1871348](https://bugzilla.redhat.com/1871348) **Cannot transfer images from admin portal or via using proxy_url in SDK with all-in-one setup**

   

 - [BZ 1869359](https://bugzilla.redhat.com/1869359) **Q35 Fixups**

   

 - [BZ 1873136](https://bugzilla.redhat.com/1873136) **[CNV&RHV]Notification about VM creation contain <UNKNOWN> string**

   

 - [BZ 1854034](https://bugzilla.redhat.com/1854034) **Show bios type in VM/Template/Pool general information**

   

 - [BZ 1726558](https://bugzilla.redhat.com/1726558) **[v2v] VMware VMs with EFI BIOS and secure boot are converted to Q35 with UEFI instead of Q35 with SecureBoot**

   

 - [BZ 1822372](https://bugzilla.redhat.com/1822372) **Adding quota to group doesn't propagate to users**

   

 - [BZ 1872602](https://bugzilla.redhat.com/1872602) **Incorrect storage consumption on Quota list page**

   

 - [BZ 1828333](https://bugzilla.redhat.com/1828333) **Can't resume an upload after it has been paused**

   

 - [BZ 1862722](https://bugzilla.redhat.com/1862722) **Remove unused ImageTransfer.signed_ticket**

   

 - [BZ 1836034](https://bugzilla.redhat.com/1836034) **Cannot switch Master to hosted_storage**

   

 - [BZ 1857148](https://bugzilla.redhat.com/1857148) **OVA import (exported from the same 4.4 cluster) is not using the correct BIOS Type.**

   


#### oVirt Provider OVN

 - [BZ 1835550](https://bugzilla.redhat.com/1835550) **ovirt-provider-ovn takes more than ExternalNetworkProviderTimeout to respond to engine requests**

   


#### oVirt Engine Data Warehouse

 - [BZ 1874880](https://bugzilla.redhat.com/1874880) **Update column settings to contain only relevant columns**

   

 - [BZ 1878496](https://bugzilla.redhat.com/1878496) **Add delete_date columns to uptime dashboard**

   

 - [BZ 1877706](https://bugzilla.redhat.com/1877706) **PostgreSQL 12 in oVirt 4.4 - engine-setup menu ref URL needs updating**

   

 - [BZ 1877280](https://bugzilla.redhat.com/1877280) **Remove time picker in hosts and vms inventory dashboard**

   

 - [BZ 1876802](https://bugzilla.redhat.com/1876802) **Adding a missing alias to a column settings**

   

 - [BZ 1874029](https://bugzilla.redhat.com/1874029) **Missing column in inventory dashboard**

   

 - [BZ 1873087](https://bugzilla.redhat.com/1873087) **Update reports that count to display the exact number**

   

 - [BZ 1866356](https://bugzilla.redhat.com/1866356) **Update the dashboards default time period**

   


### No Doc Update

#### VDSM

 - [BZ 1876230](https://bugzilla.redhat.com/1876230) **LSM fails on CreateLiveSnapshotForVmCommand - Unable to prepare the volume path for disk vdb**

   


#### oVirt Engine

 - [BZ 1871128](https://bugzilla.redhat.com/1871128) **CVE-2020-14333 ovirt-engine: Reflected cross site scripting vulnerability**

   

 - [BZ 1877279](https://bugzilla.redhat.com/1877279) **dwh status is overwritten by engine-setup**

   

 - [BZ 1874631](https://bugzilla.redhat.com/1874631) **Tidy up and improve fix for bug 1755518**

   

 - [BZ 1872441](https://bugzilla.redhat.com/1872441) **inconsistent result set between views without tag information and views with tag information**

   

 - [BZ 1872911](https://bugzilla.redhat.com/1872911) **RHV Administration Portal fails with 404 error even after updating to RHV 4.3.9**

   

 - [BZ 1858638](https://bugzilla.redhat.com/1858638) **[Scale] Poor Performing VM search by cluster_name and partial host name**

   

 - [BZ 1686280](https://bugzilla.redhat.com/1686280) **[cinderLib] - Kaminario backend- CloneVM fails and non managed disk does not roll back and remains in "LOCKED' state**

   

 - [BZ 1828241](https://bugzilla.redhat.com/1828241) **Deleting snapshot do not display a lock for it's disks under "Disk Snapshots" tab.**

   

 - [BZ 1683573](https://bugzilla.redhat.com/1683573) **[CinderLib] - remove managed block disks from VM which have a template create from it fails - USER_REMOVE_VM_FINISHED_WITH_ILLEGAL_DISKS**

   

 - [BZ 1842344](https://bugzilla.redhat.com/1842344) **Status loop due to host initialization not checking network status, monitoring finding the network issue and auto-recovery.**

   


#### Contributors

46 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Alan Rominger (Contributed to: ovirt-ansible-collection)
	Ales Musil (Contributed to: vdsm)
	Amit Bawer (Contributed to: ovirt-engine, vdsm)
	Andrej Cernek (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-ansible-collection, ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: ovirt-ansible-collection)
	Aviv Litman (Contributed to: ovirt-dwh)
	Baptiste Mille-Mathias (Contributed to: ovirt-ansible-collection)
	Bella Khizgiyev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Christopher Brown (Contributed to: ovirt-ansible-collection)
	Dana Elfassy (Contributed to: ovirt-engine)
	Darin (Contributed to: ovirt-ansible-collection)
	Dominik Holler (Contributed to: ovirt-provider-ovn)
	Douglas Schilling Landgraf (Contributed to: engine-db-query)
	Eli Mesika (Contributed to: ovirt-engine, vdsm)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Germano Veit Michel (Contributed to: vdsm)
	Lev Veyde (Contributed to: ovirt-dwh, ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection, ovirt-engine)
	Michal Skrivanek (Contributed to: ovirt-engine)
	Milan Zamazal (Contributed to: vdsm)
	Nijin Ashok (Contributed to: ovirt-ansible-collection)
	Nir Soffer (Contributed to: ovirt-engine, vdsm)
	Pierre Lecomte (Contributed to: ovirt-engine)
	Prajith Kesava Prasad (Contributed to: ovirt-engine)
	Reto Gantenbein (Contributed to: ovirt-ansible-collection)
	Sandro Bonazzola (Contributed to: engine-db-query, ovirt-engine)
	Sean Sackowitz (Contributed to: ovirt-ansible-collection)
	Shani Leviim (Contributed to: ovirt-engine)
	Shirly Radco (Contributed to: ovirt-dwh)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Simone Tiraboschi (Contributed to: ovirt-engine)
	Sloane Hertel (Contributed to: ovirt-ansible-collection)
	Steven Rosenberg (Contributed to: ovirt-engine, vdsm)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-engine, vdsm)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine)
	bverschueren (Contributed to: ovirt-ansible-collection)
	hiyokotaisa (Contributed to: ovirt-ansible-collection)
	jekader (Contributed to: ovirt-ansible-collection)

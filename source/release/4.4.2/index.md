---
title: oVirt 4.4.2 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
page_classes: releases
---

# oVirt 4.4.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.2 Third Release Candidate as of August 13, 2020.

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

To learn about features introduced before 4.4.2, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)



## What's New in 4.4.2?

### Enhancements

#### oVirt Engine

 - [BZ 1749803](https://bugzilla.redhat.com/1749803) **[RFE] Improve workflow for storage migration of VMs with multiple disks**

   Feature: 

Allow setting the same target domain for multiple disks at

once on the move/copy popup.



Reason:

Currently, while moving/copying multiple disks, the user is required to set the target domain for each disk separately, one by one.



Result: 

For multiple selected disks, if a common target domain exists, it can be set as the target domain for all those disks at once by selecting it from the list.



In case a common storage domain doesn't exist, or setting a different target domain for part of the disks,

(so not all disks will be moved/copied to the same storage domain), the common target domain would be set as 'Mixed'.

 - [BZ 1860309](https://bugzilla.redhat.com/1860309) **Upgrade to GWT 2.9.0**

   Feature: 

Upgrade GWT (Google Web Toolkit) version from 2.8.0 to 2.9.0



Reason: 

1. support for building with Java 11

2. accumulated improvements and bug fixes (from versions 2.8.1, 2.8.2, 2.9.0)

 - [BZ 1837873](https://bugzilla.redhat.com/1837873) **[RFE] No warning/blocking when detaching storage domain when there are VMs with disk on the detached domain and second disk on other domain**

   Feature: 

Warn on detaching a storage domain having VMs/templates with disks on another storage domain.



Reason:

When a user wants to detach a storage domain that contains

VMs/templates, their disks should be moved to a storage domain used for migration.

Currently, when that entity also has multiple disks on a different storage domain, its future migration might get complicated and split into two partial entities instead. 



Result:

In order to avoid the entity's split, a new warning was added in that case while confirming the SD detach.

 - [BZ 1667019](https://bugzilla.redhat.com/1667019) **Button for removing cluster can be mistaken for button removing VMs**

   Feature: Moved the Cluster's Remove Button to the drop down menu.



Reason: Enhanced usability.



Result: The remove button resides within the drop down menu to avoid removing the Cluster accidentally.

 - [BZ 1819260](https://bugzilla.redhat.com/1819260) **[RFE] enhance search filter for Storage Domains with free argument**

   This RFE was resolved by 



1) change "size" to "free_size"

2) add "total_size" to the search engine options

3) change "used" to "used_size"

4) adding "(GB)" when displaying 1-3 above  



for example , you can use now the followingf from the storage domains TAB



"free_size > 6 and total_size < 20"


#### oVirt dependencies

 - [BZ 1860309](https://bugzilla.redhat.com/1860309) **Upgrade to GWT 2.9.0**

   Feature: 

Upgrade GWT (Google Web Toolkit) version from 2.8.0 to 2.9.0



Reason: 

1. support for building with Java 11

2. accumulated improvements and bug fixes (from versions 2.8.1, 2.8.2, 2.9.0)


### Bug Fixes

#### VDSM

 - [BZ 1849850](https://bugzilla.redhat.com/1849850) **KVM Importing fails due to missing readinto function on the VMAdapter**

 - [BZ 1854922](https://bugzilla.redhat.com/1854922) **spec_ctrl host feature not detected**

 - [BZ 1793290](https://bugzilla.redhat.com/1793290) **guestDiskMapping can be missing or incorrect when retrieved from qga**


#### oVirt Engine

 - [BZ 1863615](https://bugzilla.redhat.com/1863615) **High Performance, headless VM fails to run when having graphic consoles devices**

 - [BZ 1573218](https://bugzilla.redhat.com/1573218) **Updating CPU pinning setting or NUMA nodes setting for a running VM requires VM restart (should be updated only for VM next run)**

 - [BZ 1856677](https://bugzilla.redhat.com/1856677) **postgresql restarts too much, eventually fails**


### Other

#### VDSM

 - [BZ 1860716](https://bugzilla.redhat.com/1860716) **VDSM Traceback failure at the journal log on DEBUG mode**

   

 - [BZ 1840414](https://bugzilla.redhat.com/1840414) **Live merge failure with libvirt error virDomainBlockCommit() failed**

   

 - [BZ 1850267](https://bugzilla.redhat.com/1850267) **[Performance] VDSM creating or copying preallocated disks cause severe slowdowns on NFS < 4.2 storage domains**

   

 - [BZ 1790747](https://bugzilla.redhat.com/1790747) **engine can't display mode 3 bond speed**

   

 - [BZ 1856065](https://bugzilla.redhat.com/1856065) **[Scale] While create snapshot to VM with 13Disks (Diff SDs) - "dictionary changed size during iteration"**

   

 - [BZ 1779527](https://bugzilla.redhat.com/1779527) **During hosted engine deploy, vdsm log has: "Failed to connect to guest agent channel"**

   


#### oVirt Engine

 - [BZ 1860284](https://bugzilla.redhat.com/1860284) **VM can not be taken from pool when no prestarted VM's are available**

   

 - [BZ 1846350](https://bugzilla.redhat.com/1846350) **Extra white space and over-stretched components in WebAdmin dialogues - Storage dialogs**

   

 - [BZ 1850401](https://bugzilla.redhat.com/1850401) **Remove isDeferringFileVolumePreallocationSupported flag**

   

 - [BZ 1828089](https://bugzilla.redhat.com/1828089) **Import data domain from previous RHV version fails**

   

 - [BZ 1840732](https://bugzilla.redhat.com/1840732) **VM can be started during ofline disk migration when the disk is locked**

   

 - [BZ 1839772](https://bugzilla.redhat.com/1839772) **[UI] Incorrect total of VMs ,shows under single host detail view**

   

 - [BZ 1855377](https://bugzilla.redhat.com/1855377) **[CNV&RHV] Add-Disk operation failed to complete.**

   

 - [BZ 1860769](https://bugzilla.redhat.com/1860769) **Ensure that meaningful messages are logged, when edit cluster properties change and gluster service enabled**

   

 - [BZ 1859460](https://bugzilla.redhat.com/1859460) **Cannot create KubeVirt VM as a normal user**

   

 - [BZ 1839505](https://bugzilla.redhat.com/1839505) **WebAdmin UI - remove unregistered entities from attached storage domain - confirmation dialog box text not aligned**

   

 - [BZ 1854478](https://bugzilla.redhat.com/1854478) **[UI] Inject copy host network failure into the event log UI.**

   

 - [BZ 1801206](https://bugzilla.redhat.com/1801206) **Possible missing block path for a SCSI host device needs to be handled in the UI**

   

 - [BZ 1804253](https://bugzilla.redhat.com/1804253) **Block cluster version update if the cluster contains affinity labels with old behavior enabled**

   

 - [BZ 1838051](https://bugzilla.redhat.com/1838051) **Refresh LUN is using host from different Data Center to scan the LUN**

   

 - [BZ 1692355](https://bugzilla.redhat.com/1692355) **Memory overcommitted VMs are not scheduled on different hosts**

   

 - [BZ 1853909](https://bugzilla.redhat.com/1853909) **Update i440fx machine types of existing 4.4 clusters**

   

 - [BZ 1845591](https://bugzilla.redhat.com/1845591) **Cleanly remove ovirt ga socket requirement.**

   

 - [BZ 1830840](https://bugzilla.redhat.com/1830840) **[4.4] Wrong bios-type for templates imported from glance server**

   

 - [BZ 1854488](https://bugzilla.redhat.com/1854488) **[RHV-CNV] - NPE when creating new VM in cnv cluster**

   

 - [BZ 1842272](https://bugzilla.redhat.com/1842272) **When trying to export VM to a different SD the VM clone creates on the source SD instead.**

   


#### oVirt dependencies

 - [BZ 1851092](https://bugzilla.redhat.com/1851092) **Package ovirt-engine missing java dependencies in a RPM**

   


#### oVirt Engine Data Warehouse

 - [BZ 1852752](https://bugzilla.redhat.com/1852752) **Fix chainsaw graphs**

   


#### oVirt Hosted Engine Setup

 - [BZ 1849517](https://bugzilla.redhat.com/1849517) **[RFE] Allow passing arbitrary vars to ansible**

   

 - [BZ 1826875](https://bugzilla.redhat.com/1826875) **HE deployment gets into an endless loop when the memory is not sufficient and you choose not to continue.**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1866709](https://bugzilla.redhat.com/1866709) **database restore fails if non-default extensions are included in the backup**

   

 - [BZ 1866688](https://bugzilla.redhat.com/1866688) **CVE-2020-10775 ovirt-engine: Redirect to arbitrary URL allows for phishing**

   

 - [BZ 1841195](https://bugzilla.redhat.com/1841195) **Hosted Engine deployment fails with restored backup from 4.3.9 when CA renewal is selected**

   

 - [BZ 1816951](https://bugzilla.redhat.com/1816951) **[CNV&RHV] CNV VM migration failure is not handled correctly by the engine**

   

 - [BZ 1802538](https://bugzilla.redhat.com/1802538) **When trying to attach backup API disk to backup VM, the disk_attachment href contains "null" instead of "disk_attachment"**

   

 - [BZ 1758024](https://bugzilla.redhat.com/1758024) **Long running Ansible tasks timeout and abort for RHV-H hosts with STIG/Security Profiles applied**

   

 - [BZ 1856339](https://bugzilla.redhat.com/1856339) **[CNV&RHV]  Add test for the OpenShift API to Provider Test connection**

   

 - [BZ 1803856](https://bugzilla.redhat.com/1803856) **[Scale] ovirt-vmconsole takes too long or times out in a 500+ VM environment.**

   

 - [BZ 1856375](https://bugzilla.redhat.com/1856375) **Can't add additional host as hosted-engine ha-host from "Guide me" from UI.**

   

 - [BZ 1826255](https://bugzilla.redhat.com/1826255) **[CNV&RHV]Change name of type of provider - CNV -> OpenShift Virtualization**

   

 - [BZ 1855221](https://bugzilla.redhat.com/1855221) **Setup on separate machine with "manual_files" is broken**

   


#### oVirt Engine Data Warehouse

 - [BZ 1846365](https://bugzilla.redhat.com/1846365) **Handle grafana in ovirt-engine-rename**

   


#### Contributors

43 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: vdsm)
	Amit Bawer (Contributed to: vdsm)
	Andrej Cernek (Contributed to: vdsm)
	Anton Marchukov (Contributed to: ovirt-dependencies)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh)
	Bell Levin (Contributed to: vdsm)
	Bella Khizgiyev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine)
	Dana Elfassy (Contributed to: ovirt-engine)
	Daniel Erez (Contributed to: ovirt-engine)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Germano Veit Michel (Contributed to: vdsm)
	Jan Zmeskal (Contributed to: ovirt-ansible-infra)
	Kobi Hakimi (Contributed to: ovirt-ansible-repositories)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Luca (Contributed to: ovirt-ansible-infra)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-infra, ovirt-ansible-repositories, ovirt-engine)
	Martin Perina (Contributed to: ovirt-dependencies, vdsm-jsonrpc-java)
	Milan Zamazal (Contributed to: vdsm)
	Nir Soffer (Contributed to: ovirt-engine, ovirt-imageio, vdsm)
	Orcun Atakan (Contributed to: ovirt-ansible-infra)
	Ori Liel (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Ritesh Chikatwar (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: ovirt-dependencies, ovirt-engine, vdsm-jsonrpc-java, wix-toolset-binaries)
	Shani Leviim (Contributed to: ovirt-engine)
	Sharon Gratch (Contributed to: ovirt-engine)
	Shirly Radco (Contributed to: ovirt-dwh)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Steven Rosenberg (Contributed to: ovirt-engine, vdsm)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-imageio, vdsm)
	Xavi (Contributed to: ovirt-ansible-infra)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine, ovirt-hosted-engine-setup)

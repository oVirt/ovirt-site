---
title: oVirt 4.4.2 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
page_classes: releases
---

# oVirt 4.4.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.2 First Release Candidate as of July 30, 2020.

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

 - [BZ 1837873](https://bugzilla.redhat.com/1837873) **[RFE] No warning/blocking when detaching storage domain when there are VMs with disk on the detached domain and second disk on other domain**

   Feature: 

Warn on detaching a storage domain having VMs/templates with disks on another storage domain.



Reason:

When a user wants to detach a storage domain that contains

VMs/templates, their disks should be moved to a storage domain used for migration.

Currently, when that entity also has multiple disks on a different storage domain, its future migration might get complicated and split into two partial entities instead. 



Result:

In order to avoid the entity's split, a new warning was added in that case while confirming the SD detach.

 - [BZ 1819260](https://bugzilla.redhat.com/1819260) **[RFE] enhance search filter for Storage Domains with free argument**

   This RFE was resolved by 



1) change "size" to "free_size"

2) add "total_size" to the search engine options

3) change "used" to "used_size"

4) adding "(GB)" when displaying 1-3 above  



for example , you can use now the followingf from the storage domains TAB



"free_size > 6 and total_size < 20"


### Bug Fixes

#### VDSM

 - [BZ 1854922](https://bugzilla.redhat.com/1854922) **spec_ctrl host feature not detected**

 - [BZ 1793290](https://bugzilla.redhat.com/1793290) **guestDiskMapping can be missing or incorrect when retrieved from qga**


#### oVirt Engine

 - [BZ 1856677](https://bugzilla.redhat.com/1856677) **postgresql restarts too much, eventually fails**


### Other

#### VDSM

 - [BZ 1860716](https://bugzilla.redhat.com/1860716) **VDSM Traceback failure at the journal log on DEBUG mode**

   

 - [BZ 1850267](https://bugzilla.redhat.com/1850267) **[Performance] VDSM creating or copying preallocated disks cause severe slowdowns on NFS < 4.2 storage domains**

   

 - [BZ 1790747](https://bugzilla.redhat.com/1790747) **engine can't display mode 3 bond speed**

   

 - [BZ 1856065](https://bugzilla.redhat.com/1856065) **[Scale] While create snapshot to VM with 13Disks (Diff SDs) - "dictionary changed size during iteration"**

   

 - [BZ 1779527](https://bugzilla.redhat.com/1779527) **During hosted engine deploy, vdsm log has: "Failed to connect to guest agent channel"**

   


#### oVirt Engine

 - [BZ 1855377](https://bugzilla.redhat.com/1855377) **[CNV&RHV] Add-Disk operation failed to complete.**

   

 - [BZ 1859460](https://bugzilla.redhat.com/1859460) **Cannot create KubeVirt VM as a normal user**

   

 - [BZ 1839505](https://bugzilla.redhat.com/1839505) **WebAdmin UI - remove unregistered entities from attached storage domain - confirmation dialog box text not aligned**

   

 - [BZ 1854478](https://bugzilla.redhat.com/1854478) **[UI] Inject copy host network failure into the event log UI.**

   

 - [BZ 1804253](https://bugzilla.redhat.com/1804253) **Block cluster version update if the cluster contains affinity labels with old behavior enabled**

   

 - [BZ 1838051](https://bugzilla.redhat.com/1838051) **Refresh LUN is using host from different Data Center to scan the LUN**

   

 - [BZ 1692355](https://bugzilla.redhat.com/1692355) **Memory overcommitted VMs are not scheduled on different hosts**

   

 - [BZ 1853909](https://bugzilla.redhat.com/1853909) **Update i440fx machine types of existing 4.4 clusters**

   

 - [BZ 1845591](https://bugzilla.redhat.com/1845591) **Cleanly remove ovirt ga socket requirement.**

   

 - [BZ 1830840](https://bugzilla.redhat.com/1830840) **[4.4] Wrong bios-type for templates imported from glance server**

   

 - [BZ 1854488](https://bugzilla.redhat.com/1854488) **[RHV-CNV] - NPE when creating new VM in cnv cluster**

   

 - [BZ 1771469](https://bugzilla.redhat.com/1771469) **Hot-plug SATA disk from VM fails with error - Validation of action 'HotPlugDiskToVm' failed for  user admin@internal-authz. Reasons: VAR__ACTION__HOT_PLUG,VAR__TYPE__DISK,ACTION_TYPE_DISK_INTERFACE_UNSUPPORTED,$osName Other OS**

   

 - [BZ 1842272](https://bugzilla.redhat.com/1842272) **When trying to export VM to a different SD the VM clone creates on the source SD instead.**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1841195](https://bugzilla.redhat.com/1841195) **Hosted Engine deployment fails with restored backup from 4.3.9 when CA renewal is selected**

   

 - [BZ 1816951](https://bugzilla.redhat.com/1816951) **[CNV&RHV] CNV VM migration failure is not handled correctly by the engine**

   

 - [BZ 1802538](https://bugzilla.redhat.com/1802538) **When trying to attach backup API disk to backup VM, the disk_attachment href contains "null" instead of "disk_attachment"**

   

 - [BZ 1758024](https://bugzilla.redhat.com/1758024) **Long running Ansible tasks timeout and abort for RHV-H hosts with STIG/Security Profiles applied**

   

 - [BZ 1856339](https://bugzilla.redhat.com/1856339) **[CNV&RHV]  Add test for the OpenShift API to Provider Test connection**

   

 - [BZ 1803856](https://bugzilla.redhat.com/1803856) **[Scale] ovirt-vmconsole takes too long or times out in a 500+ VM environment.**

   

 - [BZ 1856375](https://bugzilla.redhat.com/1856375) **Can't add additional host as hosted-engine ha-host from "Guide me" from UI.**

   

 - [BZ 1826255](https://bugzilla.redhat.com/1826255) **[CNV&RHV]Change name of type of provider - CNV -> OpenShift Virtualization**

   

 - [BZ 1855221](https://bugzilla.redhat.com/1855221) **Setup on separate machine with "manual_files" is broken**

   


#### Contributors

31 people contributed to this release:

	Ahmad Khiet
	Ales Musil
	Amit Bawer
	Andrej Cernek
	Arik Hadas
	Artur Socha
	Bell Levin
	Bella Khizgiyev
	Benny Zlotnik
	Dana Elfassy
	Daniel Erez
	Eitan Raviv
	Eli Mesika
	Eyal Shenitzky
	Lev Veyde
	Liran Rotenberg
	Lucia Jelinkova
	Marcin Sobczyk
	Martin Nečas
	Milan Zamazal
	Nir Soffer
	Ori Liel
	Ritesh Chikatwar
	Sandro Bonazzola
	Shani Leviim
	Sharon Gratch
	Shmuel Melamud
	Steven Rosenberg
	Tomáš Golembiovský
	Vojtech Juranek
	Yedidyah Bar David

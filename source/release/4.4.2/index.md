---
title: oVirt 4.4.2 Release Notes
category: documentation
authors:
  - sandrobonazzola
  - lveyde
toc: true
page_classes: releases
---

# oVirt 4.4.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.2 release as of September 17, 2020.

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


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.4.2, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**, 

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.2 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.2 (redeploy in case of already being on 4.4.2).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.2?

### Release Note

#### oVirt dependencies

 - [BZ 1851092](https://bugzilla.redhat.com/show_bug.cgi?id=1851092) **Package ovirt-engine missing java dependencies in a RPM**

   ovirt-dependency package has been added to the oVirt distribution providing binary java dependencies previously bundled within oVirt Engine packages.


### Enhancements

#### oVirt Engine

 - [BZ 1749803](https://bugzilla.redhat.com/show_bug.cgi?id=1749803) **[RFE] Improve workflow for storage migration of VMs with multiple disks**

   This enhancement enables you to set the same target domain for multiple disks. 



Previously, when moving or copying multiple disks, you needed to set the target domain for each disk separately. Now, if a common target domain exists, you can set it as the target domain for all disks.



If there is no common storage domain, such that not all disks are moved or copied to the same storage domain, set the common target domain as 'Mixed'.

 - [BZ 1860309](https://bugzilla.redhat.com/show_bug.cgi?id=1860309) **Upgrade to GWT 2.9.0**

   Feature: 

Upgrade GWT (Google Web Toolkit) version from 2.8.0 to 2.9.0



Reason: 

1. support for building with Java 11

2. accumulated improvements and bug fixes (from versions 2.8.1, 2.8.2, 2.9.0)

 - [BZ 1837873](https://bugzilla.redhat.com/show_bug.cgi?id=1837873) **[RFE] No warning/blocking when detaching storage domain when there are VMs with disk on the detached domain and second disk on other domain**

   Feature: 

Warn on detaching a storage domain having VMs/templates with disks on another storage domain.



Reason:

When a user wants to detach a storage domain that contains

VMs/templates, their disks should be moved to a storage domain used for migration.

Currently, when that entity also has multiple disks on a different storage domain, its future migration might get complicated and split into two partial entities instead. 



Result:

In order to avoid the entity's split, a new warning was added in that case while confirming the SD detach.

 - [BZ 1667019](https://bugzilla.redhat.com/show_bug.cgi?id=1667019) **Button for removing cluster can be mistaken for button removing VMs**

   Feature: Moved the Cluster's Remove Button to the drop down menu.



Reason: Enhanced usability.



Result: The remove button resides within the drop down menu to avoid removing the Cluster accidentally.

 - [BZ 1819260](https://bugzilla.redhat.com/show_bug.cgi?id=1819260) **[RFE] enhance search filter for Storage Domains with free argument**

   The following search filter properties for Storage Domains have been enhanced: 

- 'size' changed to 'free_size'

- 'total_size' added to the search engine options

- 'used' changed to 'used_size'



For example , you can use now the following in the Storage Domains tab:



"free_size > 6 GB and total_size < 20 GB"


#### oVirt dependencies

 - [BZ 1860309](https://bugzilla.redhat.com/show_bug.cgi?id=1860309) **Upgrade to GWT 2.9.0**

   Feature: 

Upgrade GWT (Google Web Toolkit) version from 2.8.0 to 2.9.0



Reason: 

1. support for building with Java 11

2. accumulated improvements and bug fixes (from versions 2.8.1, 2.8.2, 2.9.0)


### Known Issue

#### VDSM

 - [BZ 1837864](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) **Host enter emergency mode after upgrading to latest build**

   When upgrading from Red Hat Virtualization 4.4 GA (RHV 4.4.1) to RHEV 4.4.2, the host enters emergency mode and cannot be restarted. 

Workaround: see the solution in https://access.redhat.com/solutions/5428651


#### oVirt Engine

 - [BZ 1837864](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) **Host enter emergency mode after upgrading to latest build**

   When upgrading from Red Hat Virtualization 4.4 GA (RHV 4.4.1) to RHEV 4.4.2, the host enters emergency mode and cannot be restarted. 

Workaround: see the solution in https://access.redhat.com/solutions/5428651


#### imgbased

 - [BZ 1837864](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) **Host enter emergency mode after upgrading to latest build**

   When upgrading from Red Hat Virtualization 4.4 GA (RHV 4.4.1) to RHEV 4.4.2, the host enters emergency mode and cannot be restarted. 

Workaround: see the solution in https://access.redhat.com/solutions/5428651


#### oVirt Node NG Image

 - [BZ 1850378](https://bugzilla.redhat.com/show_bug.cgi?id=1850378) **Installation of node will not quit when mountpoint has existing domain (VMs)**

   When you upgrade Red Hat Virtualization from 4.3 to 4.4 with a storage domain that is locally mounted on / (root), the upgrade fails. Specifically, on the host it appears that the upgrade is successful, but the host's status on the Administration Portal, is `NonOperational`.



Local storage should always be defined on a file system that is separate from / (root). Use a separate logical volume or disk, to prevent possible loss of data during upgrades.



If you are using / (root) as the locally mounted storage domain, migrate your data to a separate logical volume or disk prior to upgrading.


### Bug Fixes

#### VDSM

 - [BZ 1849850](https://bugzilla.redhat.com/show_bug.cgi?id=1849850) **KVM Importing fails due to missing readinto function on the VMAdapter**

 - [BZ 1854922](https://bugzilla.redhat.com/show_bug.cgi?id=1854922) **spec_ctrl host feature not detected**

 - [BZ 1663135](https://bugzilla.redhat.com/show_bug.cgi?id=1663135) **RFE: importing vm from KVM external provider should work also to block based SD**

 - [BZ 1793290](https://bugzilla.redhat.com/show_bug.cgi?id=1793290) **guestDiskMapping can be missing or incorrect when retrieved from qga**


#### oVirt Engine

 - [BZ 1863615](https://bugzilla.redhat.com/show_bug.cgi?id=1863615) **High Performance, headless VM fails to run when having graphic consoles devices**

 - [BZ 1573218](https://bugzilla.redhat.com/show_bug.cgi?id=1573218) **Updating CPU pinning setting or NUMA nodes setting for a running VM requires VM restart (should be updated only for VM next run)**

 - [BZ 1663135](https://bugzilla.redhat.com/show_bug.cgi?id=1663135) **RFE: importing vm from KVM external provider should work also to block based SD**

 - [BZ 1856677](https://bugzilla.redhat.com/show_bug.cgi?id=1856677) **postgresql restarts too much, eventually fails**


#### oVirt Engine Data Warehouse

 - [BZ 1847966](https://bugzilla.redhat.com/show_bug.cgi?id=1847966) **grafana setup with "weird" characters is broken**


#### oVirt Engine UI Extensions

 - [BZ 1855761](https://bugzilla.redhat.com/show_bug.cgi?id=1855761) **Web Admin interface broken on Firefox**


#### oVirt Ansible hosted-engine setup role

 - [BZ 1866956](https://bugzilla.redhat.com/show_bug.cgi?id=1866956) **Hosted-Engine restore from backup and 4.4 upgrade fail if Blank template is set as HA**

 - [BZ 1868571](https://bugzilla.redhat.com/show_bug.cgi?id=1868571) **Failed to deploy HE over NFS storage  "FileNotFoundError: [Errno 2] No such file or directory"**


#### oVirt Engine Appliance

 - [BZ 1866811](https://bugzilla.redhat.com/show_bug.cgi?id=1866811) **gssapi packages missing on upgrade**

 - [BZ 1866780](https://bugzilla.redhat.com/show_bug.cgi?id=1866780) **hosted-engine upgrade to 4.4 with dwh on remote machine fails due to grafana**


### Other

#### VDSM

 - [BZ 1875805](https://bugzilla.redhat.com/show_bug.cgi?id=1875805) **Disk QoS not applied live (AttributeError: 'Drive' object has no attribute 'get')**

   

 - [BZ 1855078](https://bugzilla.redhat.com/show_bug.cgi?id=1855078) **KeyError with vlanned bridgeless default route networks**

   

 - [BZ 1860716](https://bugzilla.redhat.com/show_bug.cgi?id=1860716) **VDSM Traceback failure at the journal log on DEBUG mode**

   

 - [BZ 1840414](https://bugzilla.redhat.com/show_bug.cgi?id=1840414) **Live merge failure with libvirt error virDomainBlockCommit() failed**

   

 - [BZ 1850267](https://bugzilla.redhat.com/show_bug.cgi?id=1850267) **[Performance] VDSM creating or copying preallocated disks cause severe slowdowns on NFS < 4.2 storage domains**

   

 - [BZ 1790747](https://bugzilla.redhat.com/show_bug.cgi?id=1790747) **engine can't display mode 3 bond speed**

   

 - [BZ 1779527](https://bugzilla.redhat.com/show_bug.cgi?id=1779527) **During hosted engine deploy, vdsm log has: "Failed to connect to guest agent channel"**

   


#### oVirt Engine

 - [BZ 1874543](https://bugzilla.redhat.com/show_bug.cgi?id=1874543) **[RHV 4.4] Can not login to RHV Manager "Warning alert:app_url domain differs from SSO_ENGINE_URL or SSO_ALTERNATE_ENGINE_FQDN domains"**

   

 - [BZ 1866745](https://bugzilla.redhat.com/show_bug.cgi?id=1866745) **Configure imageio backend http CA file**

   

 - [BZ 1860284](https://bugzilla.redhat.com/show_bug.cgi?id=1860284) **VM can not be taken from pool when no prestarted VM's are available**

   

 - [BZ 1850401](https://bugzilla.redhat.com/show_bug.cgi?id=1850401) **Remove isDeferringFileVolumePreallocationSupported flag**

   

 - [BZ 1828089](https://bugzilla.redhat.com/show_bug.cgi?id=1828089) **Import data domain from previous RHV version fails**

   

 - [BZ 1840732](https://bugzilla.redhat.com/show_bug.cgi?id=1840732) **VM can be started during ofline disk migration when the disk is locked**

   

 - [BZ 1839772](https://bugzilla.redhat.com/show_bug.cgi?id=1839772) **[UI] Incorrect total of VMs ,shows under single host detail view**

   

 - [BZ 1855377](https://bugzilla.redhat.com/show_bug.cgi?id=1855377) **[CNV&RHV] Add-Disk operation failed to complete.**

   

 - [BZ 1860769](https://bugzilla.redhat.com/show_bug.cgi?id=1860769) **Ensure that meaningful messages are logged, when edit cluster properties change and gluster service enabled**

   

 - [BZ 1859460](https://bugzilla.redhat.com/show_bug.cgi?id=1859460) **Cannot create KubeVirt VM as a normal user**

   

 - [BZ 1839505](https://bugzilla.redhat.com/show_bug.cgi?id=1839505) **WebAdmin UI - remove unregistered entities from attached storage domain - confirmation dialog box text not aligned**

   

 - [BZ 1854478](https://bugzilla.redhat.com/show_bug.cgi?id=1854478) **[UI] Inject copy host network failure into the event log UI.**

   

 - [BZ 1801206](https://bugzilla.redhat.com/show_bug.cgi?id=1801206) **Possible missing block path for a SCSI host device needs to be handled in the UI**

   

 - [BZ 1804253](https://bugzilla.redhat.com/show_bug.cgi?id=1804253) **Block cluster version update if the cluster contains affinity labels with old behavior enabled**

   

 - [BZ 1838051](https://bugzilla.redhat.com/show_bug.cgi?id=1838051) **Refresh LUN is using host from different Data Center to scan the LUN**

   

 - [BZ 1692355](https://bugzilla.redhat.com/show_bug.cgi?id=1692355) **Memory overcommitted VMs are not scheduled on different hosts**

   

 - [BZ 1853909](https://bugzilla.redhat.com/show_bug.cgi?id=1853909) **Update i440fx machine types of existing 4.4 clusters**

   

 - [BZ 1845591](https://bugzilla.redhat.com/show_bug.cgi?id=1845591) **Cleanly remove ovirt ga socket requirement.**

   

 - [BZ 1830840](https://bugzilla.redhat.com/show_bug.cgi?id=1830840) **[4.4] Wrong bios-type for templates imported from glance server**

   

 - [BZ 1854488](https://bugzilla.redhat.com/show_bug.cgi?id=1854488) **[RHV-CNV] - NPE when creating new VM in cnv cluster**

   

 - [BZ 1771469](https://bugzilla.redhat.com/show_bug.cgi?id=1771469) **Hot-plug SATA disk from VM fails with error - Validation of action 'HotPlugDiskToVm' failed for  user admin@internal-authz. Reasons: VAR__ACTION__HOT_PLUG,VAR__TYPE__DISK,ACTION_TYPE_DISK_INTERFACE_UNSUPPORTED,$osName Other OS**

   

 - [BZ 1842272](https://bugzilla.redhat.com/show_bug.cgi?id=1842272) **When trying to export VM to a different SD the VM clone creates on the source SD instead.**

   


#### ovirt-imageio

 - [BZ 1862107](https://bugzilla.redhat.com/show_bug.cgi?id=1862107) **Image transfer via imageio proxy broken after replacing apache pki**

   


#### oVirt Engine Data Warehouse

 - [BZ 1866349](https://bugzilla.redhat.com/show_bug.cgi?id=1866349) **Update reports descriptions according to documentation notes**

   

 - [BZ 1857778](https://bugzilla.redhat.com/show_bug.cgi?id=1857778) **[RFE] Add Five_most_utilized_hosts_over_time (Br4B) to Trend Dashboard**

   

 - [BZ 1852752](https://bugzilla.redhat.com/show_bug.cgi?id=1852752) **Fix chainsaw graphs**

   


#### oVirt Hosted Engine Setup

 - [BZ 1849517](https://bugzilla.redhat.com/show_bug.cgi?id=1849517) **[RFE] Allow passing arbitrary vars to ansible**

   

 - [BZ 1826875](https://bugzilla.redhat.com/show_bug.cgi?id=1826875) **HE deployment gets into an endless loop when the memory is not sufficient and you choose not to continue.**

   


#### oVirt Engine UI Extensions

 - [BZ 1772038](https://bugzilla.redhat.com/show_bug.cgi?id=1772038) **In case there are no available hosts to migrate the VM to then "migrate VM" dialog is opened with disabled fields instead of showing a notification message**

   

 - [BZ 1857197](https://bugzilla.redhat.com/show_bug.cgi?id=1857197) **Cluster stats not available**

   

 - [BZ 1772030](https://bugzilla.redhat.com/show_bug.cgi?id=1772030) **Tooltips text windows position are dis-alligned for the "Cluster upgrade" dialog**

   


#### oVirt Engine NodeJS Modules

 - [BZ 1862759](https://bugzilla.redhat.com/show_bug.cgi?id=1862759) **Resolve CVE alerts on Github**

   


#### cockpit-ovirt

 - [BZ 1856630](https://bugzilla.redhat.com/show_bug.cgi?id=1856630) **[day2] Warning pops up with expand cluster operation to use device with format /dev/mapper even with blacklist gluster devices enabled**

   

 - [BZ 1866698](https://bugzilla.redhat.com/show_bug.cgi?id=1866698) **HE deployment should save the state when clicking "No" in "Exit Wizard"**

   

 - [BZ 1855758](https://bugzilla.redhat.com/show_bug.cgi?id=1855758) **auto-populate LV cache size for other hosts during deployment**

   

 - [BZ 1862759](https://bugzilla.redhat.com/show_bug.cgi?id=1862759) **Resolve CVE alerts on Github**

   


#### oVirt environment shutdown ansible roles

 - [BZ 1855772](https://bugzilla.redhat.com/show_bug.cgi?id=1855772) **shutdown-env role emit DEPRECATION WARNING**

   


### No Doc Update

#### VDSM

 - [BZ 1874807](https://bugzilla.redhat.com/show_bug.cgi?id=1874807) **TPS result complaining about exiting symbolic link**

   

 - [BZ 1859876](https://bugzilla.redhat.com/show_bug.cgi?id=1859876) **imgbase check failed after register to engine**

   


#### oVirt Engine

 - [BZ 1877790](https://bugzilla.redhat.com/show_bug.cgi?id=1877790) **lsm causes disk to change from RAW to QCOW2, but database is not updated**

   

 - [BZ 1869302](https://bugzilla.redhat.com/show_bug.cgi?id=1869302) **ansible 2.9.12 - host deploy fixes**

   

 - [BZ 1866709](https://bugzilla.redhat.com/show_bug.cgi?id=1866709) **database restore fails if non-default extensions are included in the backup**

   

 - [BZ 1866688](https://bugzilla.redhat.com/show_bug.cgi?id=1866688) **CVE-2020-10775 ovirt-engine: Redirect to arbitrary URL allows for phishing**

   

 - [BZ 1841195](https://bugzilla.redhat.com/show_bug.cgi?id=1841195) **Hosted Engine deployment fails with restored backup from 4.3.9 when CA renewal is selected**

   

 - [BZ 1816951](https://bugzilla.redhat.com/show_bug.cgi?id=1816951) **[CNV&RHV] CNV VM migration failure is not handled correctly by the engine**

   

 - [BZ 1802538](https://bugzilla.redhat.com/show_bug.cgi?id=1802538) **When trying to attach backup API disk to backup VM, the disk_attachment href contains "null" instead of "disk_attachment"**

   

 - [BZ 1758024](https://bugzilla.redhat.com/show_bug.cgi?id=1758024) **Long running Ansible tasks timeout and abort for RHV-H hosts with STIG/Security Profiles applied**

   

 - [BZ 1856339](https://bugzilla.redhat.com/show_bug.cgi?id=1856339) **[CNV&RHV]  Add test for the OpenShift API to Provider Test connection**

   

 - [BZ 1803856](https://bugzilla.redhat.com/show_bug.cgi?id=1803856) **[Scale] ovirt-vmconsole takes too long or times out in a 500+ VM environment.**

   

 - [BZ 1826255](https://bugzilla.redhat.com/show_bug.cgi?id=1826255) **[CNV&RHV]Change name of type of provider - CNV -> OpenShift Virtualization**

   

 - [BZ 1855221](https://bugzilla.redhat.com/show_bug.cgi?id=1855221) **Setup on separate machine with "manual_files" is broken**

   


#### ovirt-engine-extension-aaa-ldap

 - [BZ 1778471](https://bugzilla.redhat.com/show_bug.cgi?id=1778471) **Using more than one asterisk in LDAP search string is not working when searching for  AD users.**

   


#### Contributors

51 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: vdsm)
	Amit Bawer (Contributed to: ovirt-engine, vdsm)
	Andrej Cernek (Contributed to: vdsm)
	Anton Marchukov (Contributed to: ovirt-dependencies)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: ovirt-ansible-hosted-engine-setup, ovirt-ansible-shutdown-env, ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh)
	Aviv Turgeman (Contributed to: cockpit-ovirt, ovirt-engine-nodejs-modules)
	Bell Levin (Contributed to: vdsm)
	Bella Khizgiyev (Contributed to: ovirt-engine)
	Ben Amsalem (Contributed to: ovirt-web-ui)
	Benny Zlotnik (Contributed to: ovirt-engine)
	Dana Elfassy (Contributed to: ovirt-engine)
	Daniel Erez (Contributed to: ovirt-engine)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Germano Veit Michel (Contributed to: vdsm)
	Hilda Stastna (Contributed to: ovirt-web-ui)
	Jan Zmeskal (Contributed to: ovirt-ansible-infra)
	Kedar Kulkarni (Contributed to: ovirt-ansible-hosted-engine-setup)
	Kobi Hakimi (Contributed to: ovirt-ansible-repositories)
	Lev Veyde (Contributed to: ovirt-ansible-shutdown-env, ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Luca (Contributed to: ovirt-ansible-infra)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-infra, ovirt-ansible-repositories, ovirt-engine)
	Martin Perina (Contributed to: ovirt-dependencies, ovirt-engine-extension-aaa-ldap, vdsm-jsonrpc-java)
	Milan Zamazal (Contributed to: vdsm)
	Nir Levy (Contributed to: imgbased)
	Nir Soffer (Contributed to: ovirt-engine, ovirt-imageio, vdsm)
	Orcun Atakan (Contributed to: ovirt-ansible-infra)
	Ori Liel (Contributed to: ovirt-engine)
	Parth Dhanjal (Contributed to: cockpit-ovirt)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions)
	Ritesh Chikatwar (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: imgbased, ovirt-ansible-shutdown-env, ovirt-dependencies, ovirt-engine, vdsm-jsonrpc-java, wix-toolset-binaries)
	Scott J Dickerson (Contributed to: ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shani Leviim (Contributed to: ovirt-engine)
	Sharon Gratch (Contributed to: ovirt-engine, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shirly Radco (Contributed to: ovirt-dwh)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Simone Tiraboschi (Contributed to: ovirt-ansible-shutdown-env)
	Steven Rosenberg (Contributed to: ovirt-engine, vdsm)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-engine, ovirt-imageio, vdsm)
	Xavi (Contributed to: ovirt-ansible-infra)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine, ovirt-hosted-engine-setup)

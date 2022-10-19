---
title: oVirt 4.5.3 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.3 Release Notes

The oVirt Project is pleased to announce the availability of the 4.5.3 release as of October 18, 2022.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for CentOS Stream 8 and Red Hat Enterprise Linux 8.6 (or similar).

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

To learn about features introduced before 4.5.3, see the
[release notes for previous versions](/documentation/#previous-release-notes).

> IMPORTANT
> If you are going to install on RHEL 8.6 or derivatives please follow [Installing on RHEL](/download/install_on_rhel.html) first.



## What's New in 4.5.3?

### Enhancements

#### VDSM

 - [BZ 2089434](https://bugzilla.redhat.com/show_bug.cgi?id=2089434) **[RFE] RFE to allow enabling ZEROCOPY live migration**

   The feature is described on its feature page: https://ovirt.org/develop/release-management/features/virt/zerocopy-migrations.html

   Note that the feature is not intended for common use, only for large VMs (&gt;1 TB RAM) when the user is willing to accept the risk implied by the fact it is a new feature. The scope of support is waiting for clarification.

### Bug Fixes

#### VDSM

 - [BZ 2125290](https://bugzilla.redhat.com/show_bug.cgi?id=2125290) **LVM devices file is not created if the hypervisor is installed without LVM**
 - [BZ 2094576](https://bugzilla.redhat.com/show_bug.cgi?id=2094576) **Sub optimal block storage allocation for small volumes from OCP**

#### oVirt Ansible Collection

 - [BZ 2125658](https://bugzilla.redhat.com/show_bug.cgi?id=2125658) **Hosted Engine deployed with static IPv6 address leaves autoconfiguration enabled**

### Other

#### oVirt Engine UI Extensions

 - [BZ 2100194](https://bugzilla.redhat.com/show_bug.cgi?id=2100194) **Cannot export VM to another data domain. "o.original_template is undefined"**

### No Doc Update

#### oVirt Engine Data Warehouse

 - [BZ 2122174](https://bugzilla.redhat.com/show_bug.cgi?id=2122174) **engine-setup on separate DWH machine fails: Failed to execute stage 'Closing up': 'NoneType' object has no attribute 'open_sftp_client'**

#### Keycloak SSO setup for oVirt Engine

 - [BZ 2120602](https://bugzilla.redhat.com/show_bug.cgi?id=2120602) **engine-setup always sets the engine admin password to be the keycloak admin password**



## Also includes

### Release Note

#### ovirt-engine

 - [BZ 2089299](https://bugzilla.redhat.com/show_bug.cgi?id=2089299) **Remove dependency on apache-commons-configuration**

   ovirt-engine-4.5.3 and newer no longer depends on apache-commons-configuration package

#### oVirt Ansible Collection

 - [BZ 2132386](https://bugzilla.redhat.com/show_bug.cgi?id=2132386) **Fix to RHEL 8.6 EUS channel when installing oVirt 4.5 Manager or hypervisors using repositories role**

   oVirt 4.5 is supported only on RHEL 8.6 EUS, so when performing oVirt Engine or hypervisor installation we need to fix RHEL version to 8.6 and subscribe also RHEL EUS channels if they are available

### Enhancements

#### oVirt Web UI

 - [BZ 1886211](https://bugzilla.redhat.com/show_bug.cgi?id=1886211) **[RFE] Show last events for user VMs**

   Feature: 
   Lock the snapshot during a restore operation and display a  notification after a successful snapshot restore.

   Reason: 
   The restore operation status was not reflected in the vm portal ui -no snapshot locking was supported during the operation and no event for a successful restoring was displayed.


   Result: 
   Now the user can see when the restore snapshot operation is ended and if it was succeeded or failed.

### Bug Fixes

#### ovirt-engine

 - [BZ 1705338](https://bugzilla.redhat.com/show_bug.cgi?id=1705338) **Ghost OVFs are written when using floating SD to migrate VMs between 2 oVirt environments.**
 - [BZ 1968433](https://bugzilla.redhat.com/show_bug.cgi?id=1968433) **[DR] Failover / Failback HA VM Fails to be started due to 'VM XXX is being imported'**
 - [BZ 1974535](https://bugzilla.redhat.com/show_bug.cgi?id=1974535) **Virtual Machine with lease fails to run on DR failover**
 - [BZ 1983567](https://bugzilla.redhat.com/show_bug.cgi?id=1983567) **Disk is missing after importing VM from Storage Domain that was detached from another DC.**
 - [BZ 2123141](https://bugzilla.redhat.com/show_bug.cgi?id=2123141) **Unable to switch oVirt host into maintenance mode as there are image transfer in progress**

#### ovirt-engine-dwh

 - [BZ 2113980](https://bugzilla.redhat.com/show_bug.cgi?id=2113980) **engine-setup on a separate machine fails with: 'Plugin' object has no attribute '_remote_engine'**

### Other

#### ovirt-engine

 - [BZ 1565183](https://bugzilla.redhat.com/show_bug.cgi?id=1565183) **Snapshot creation with memory fails on permission validation**
 - [BZ 1721455](https://bugzilla.redhat.com/show_bug.cgi?id=1721455) **Cannot use ISO from data domain in VM Import**
 - [BZ 1836318](https://bugzilla.redhat.com/show_bug.cgi?id=1836318) **oVirt engine is reporting a delete disk with wipe as completing successfully when it actually fails from a timeout.**

   Previously, when failing to wipe the content of the disk during disk removal, the operation completed successfully with no indication of the wipe operation being timed out.

   Now, when failing to wipe the content of the disk then the disk removal fails, the disk is set with ILLEGAL status and an audit log that describe the failure is created.
 - [BZ 1912067](https://bugzilla.redhat.com/show_bug.cgi?id=1912067) **[RENAME] openssl qemu-ca conf files not handled well**
 - [BZ 1929376](https://bugzilla.redhat.com/show_bug.cgi?id=1929376) **Warn when creating clone or template from snapshot with memory**
 - [BZ 1990231](https://bugzilla.redhat.com/show_bug.cgi?id=1990231) **Setting a host to maintenance shouldn't be blocked when having 'active' image transfer**
 - [BZ 2013697](https://bugzilla.redhat.com/show_bug.cgi?id=2013697) **[REST API] Incorrect disk_snapshot parent href in api/disks/xxx/disksnapshots**
 - [BZ 2035559](https://bugzilla.redhat.com/show_bug.cgi?id=2035559) **oVirt 4.4.9 - error setting Cluster Compatibility Version to 4.6**
 - [BZ 2092816](https://bugzilla.redhat.com/show_bug.cgi?id=2092816) **Unable to enable maintenance mode for host due to "image transfer in progress" which is not the case.**
 - [BZ 2106893](https://bugzilla.redhat.com/show_bug.cgi?id=2106893) **remote-viewer.exe Failed to complete handshake Error in the pull function**
 - [BZ 2107590](https://bugzilla.redhat.com/show_bug.cgi?id=2107590) **StartVmBackupCommand gets removed by running engine-setup**
 - [BZ 2108182](https://bugzilla.redhat.com/show_bug.cgi?id=2108182) **Actual disk size is bigger when converting block disk from raw_Preallocated to cow_sparse**
 - [BZ 2110186](https://bugzilla.redhat.com/show_bug.cgi?id=2110186) **Restart of ovirt-engine while LSM is running causes LSM to get stuck**
 - [BZ 2114020](https://bugzilla.redhat.com/show_bug.cgi?id=2114020) **oVirt vGPU placement policy for separated not working**
 - [BZ 2116309](https://bugzilla.redhat.com/show_bug.cgi?id=2116309) **Fails to LSM a disk although there is enough space on the target SD**
 - [BZ 2120040](https://bugzilla.redhat.com/show_bug.cgi?id=2120040) **Missing execution job message for ReduceImage**
 - [BZ 2120228](https://bugzilla.redhat.com/show_bug.cgi?id=2120228) **ISO broken after upload via Browser.**
 - [BZ 2121083](https://bugzilla.redhat.com/show_bug.cgi?id=2121083) **Error changing cluster with default template**
 - [BZ 2123008](https://bugzilla.redhat.com/show_bug.cgi?id=2123008) **engine qemu-nbd lock virtual disk even with process failed**

### No Doc Update

#### ovirt-engine

 - [BZ 1983401](https://bugzilla.redhat.com/show_bug.cgi?id=1983401) **Windows mark doesn't refresh as expected**
 - [BZ 2005978](https://bugzilla.redhat.com/show_bug.cgi?id=2005978) **ovirt-engine uses %add_maven_depmap macro which has been removed**
 - [BZ 2078189](https://bugzilla.redhat.com/show_bug.cgi?id=2078189) **Change an error returned when running together resize policy VM with the dedicated VM**
 - [BZ 2110351](https://bugzilla.redhat.com/show_bug.cgi?id=2110351) **Can not create VM from template and delete template.**
 - [BZ 2118672](https://bugzilla.redhat.com/show_bug.cgi?id=2118672) **Use rpm instead of auto in package_facts ansible module to prevent mistakes of determining the correct package manager inside package_facts module**
 - [BZ 2120066](https://bugzilla.redhat.com/show_bug.cgi?id=2120066) **Branding package build fail on system with country and language different from US and English.**
 - [BZ 2120381](https://bugzilla.redhat.com/show_bug.cgi?id=2120381) **[ovirt-guest-agent] Virtual Machines inconsistently marked with "The latest guest agent needs to be installed and running on the guest" warning**
 - [BZ 2126483](https://bugzilla.redhat.com/show_bug.cgi?id=2126483) **Setup on a separate machine fails in FIPS mode**

#### VDSM

 - [BZ 2116119](https://bugzilla.redhat.com/show_bug.cgi?id=2116119) **Add support for vdsm to use nmstate for bridge options**

#### ovirt-engine-dwh

 - [BZ 2120566](https://bugzilla.redhat.com/show_bug.cgi?id=2120566) **ok_to_renew_cert missing error when upgrading DWH using engine-setup**

#### OTOPI

 - [BZ 2124205](https://bugzilla.redhat.com/show_bug.cgi?id=2124205) **Upgrade otopi to 1.10.3**
 - [BZ 2131734](https://bugzilla.redhat.com/show_bug.cgi?id=2131734) **Build otopi for oVirt 4.5 for RHEL 8**

### Contributors

22 people contributed to this release:

	Albert Esteve (Contributed to: vdsm)
	ArtiomDivak (Contributed to: ovirt-engine-ui-extensions)
	Asaf Rachmani (Contributed to: ovirt-ansible-collection)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine-metrics)
	Eitan Raviv (Contributed to: ovirt-ansible-collection, vdsm)
	Eli Mesika (Contributed to: ovirt-engine-extension-aaa-jdbc)
	Marcin Sobczyk (Contributed to: ovirt-ansible-collection, ovirt-web-ui, vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-ansible-collection, ovirt-dwh, ovirt-engine-build-dependencies, ovirt-engine-extension-aaa-jdbc, ovirt-engine-keycloak, ovirt-engine-metrics)
	Michal Skrivanek (Contributed to: otopi, ovirt-ansible-collection, ovirt-engine-metrics, vdsm)
	Milan Zamazal (Contributed to: vdsm)
	Niall O Donnell (Contributed to: ovirt-ansible-collection)
	Nir Soffer (Contributed to: vdsm)
	Pavel Bar (Contributed to: ovirt-ansible-collection)
	Radoslaw Szwajkowski (Contributed to: ovirt-web-ui)
	Saif Abu Saleh (Contributed to: ovirt-engine-extension-aaa-jdbc)
	Sandro Bonazzola (Contributed to: otopi, ovirt-engine-extension-aaa-jdbc)
	Sanja Bonic (Contributed to: ovirt-dwh, ovirt-engine-metrics, vdsm)
	Scott J Dickerson (Contributed to: ovirt-web-ui)
	Sharon Gratch (Contributed to: ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Yedidyah Bar David (Contributed to: otopi, ovirt-ansible-collection, ovirt-dwh, ovirt-engine-keycloak)
	dupondje (Contributed to: ovirt-ansible-collection)

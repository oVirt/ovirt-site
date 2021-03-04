---
title: oVirt 4.4.5 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
page_classes: releases
---


# oVirt 4.4.5 release planning

The oVirt 4.4.5 code freeze is planned for February 08, 2021.

If no critical issues are discovered while testing this compose it will be released on March 09, 2021.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.4.5](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.4.5%22%20-target_milestone%3A%22ovirt-4.4.5-%22)


# oVirt 4.4.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.5 Eighth Release Candidate as of March 04, 2021.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.3 and
CentOS Linux 8.3 (or similar).

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

To learn about features introduced before 4.4.5, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)


## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.5 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.5 (redeploy in case of already being on 4.4.5).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.5?

### Release Note

#### oVirt Release Package

 - [BZ 1917462](https://bugzilla.redhat.com/1917462) **Switch to Gluster 8 repositories**

   With oVirt 4.4.5 we now enable Gluster 8 repository from CentOS Storage SIG. Release notes for Gluster 8 are available at https://docs.gluster.org/en/latest/release-notes/#glusterfs-8-release-notes


#### oVirt Engine

 - [BZ 1906320](https://bugzilla.redhat.com/1906320) **Recreate engine HTTPS certificate in engine-setup during upgrade when certificate validity period is longer than 398 days**

   Up until 4.4.5 RHV Manager HTTPS certificates were valid for 5 years. 

Due to recent efforts to reduce certificate lifetime [1] engine certificates validity was reduced to 398 days.

This change doesn't affect existing setup, but when running a new engine-setup engine's certificates will be verified to be valid for 398 days. If they are valid for a longer period, the user will be asked to renew certificates.



[1] https://www.thesslstore.com/blog/ssl-certificate-validity-will-be-limited-to-one-year-by-apples-safari-browser/

 - [BZ 1921104](https://bugzilla.redhat.com/1921104) **Bump required ansible version in RHV Manager 4.4.5**

   RHV Manager 4.4.5 now requires ansible-2.9.17

 - [BZ 1901835](https://bugzilla.redhat.com/1901835) **[RFE][CBT] Redefine VM checkpoint without using the VM domain XML**

   Feature:

Redefine VM backup checkpoint without the domain XML of the VM.



Reason: 

Redefine the VM backup checkpoint complicates the backup flow:

1. When the backup is taken the engine should keep the created checkpoint XML in its database - if the XML is missing recovery flow added to get over this case.

2. Keeping the XML in the engine database is taking a lot of space.

3. when the checkpoint is redefined, the XML should be given to Libvirt so a lot of data is transferred from the Engine to the host.



Without the need of using the checkpoint XML when the checkpoint is redefined, we can reduce the flow complexity and reduce the needed space for the backup operation.





Result:

Checkpoint redefinition is done without the checkpoint XML that was kept in the Engine database when the backup was taken.

There is no column for keeping the XML in the database anymore. 

The checkpoint is now redefined by composing the checkpoint XML in the host and sending it to Libvirt.



Incremental backup is still in a technical preview state both in oVirt/RHV and in Libvirt. Because of that, Libvirt doesn't provide a way to identify if checkpoint redefinition without the domain XML is supported or not.

Due to that fact, the Engine cannot support in both ways to redefine the checkpoints so this change breaks the backward compatibility with the previous backups that were taken. A full backup is needed even if the VM had previous backups that were taken.



Also, to use incremental backup, both Engine and VDSM (v4.40.50.3) should have the latest version.

 - [BZ 1916076](https://bugzilla.redhat.com/1916076) **Rebase on Wildfly 22**

   oVirt Engine now requires WildFly 22

 - [BZ 1848872](https://bugzilla.redhat.com/1848872) **Rebase on Wildfly 21.0.2**

   oVirt Engine is now requiring WildFly 21.0.2


#### VDSM

 - [BZ 1901835](https://bugzilla.redhat.com/1901835) **[RFE][CBT] Redefine VM checkpoint without using the VM domain XML**

   Feature:

Redefine VM backup checkpoint without the domain XML of the VM.



Reason: 

Redefine the VM backup checkpoint complicates the backup flow:

1. When the backup is taken the engine should keep the created checkpoint XML in its database - if the XML is missing recovery flow added to get over this case.

2. Keeping the XML in the engine database is taking a lot of space.

3. when the checkpoint is redefined, the XML should be given to Libvirt so a lot of data is transferred from the Engine to the host.



Without the need of using the checkpoint XML when the checkpoint is redefined, we can reduce the flow complexity and reduce the needed space for the backup operation.





Result:

Checkpoint redefinition is done without the checkpoint XML that was kept in the Engine database when the backup was taken.

There is no column for keeping the XML in the database anymore. 

The checkpoint is now redefined by composing the checkpoint XML in the host and sending it to Libvirt.



Incremental backup is still in a technical preview state both in oVirt/RHV and in Libvirt. Because of that, Libvirt doesn't provide a way to identify if checkpoint redefinition without the domain XML is supported or not.

Due to that fact, the Engine cannot support in both ways to redefine the checkpoints so this change breaks the backward compatibility with the previous backups that were taken. A full backup is needed even if the VM had previous backups that were taken.



Also, to use incremental backup, both Engine and VDSM (v4.40.50.3) should have the latest version.


#### oVirt Engine WildFly

 - [BZ 1916076](https://bugzilla.redhat.com/1916076) **Rebase on Wildfly 22**

   oVirt Engine now requires WildFly 22

 - [BZ 1848872](https://bugzilla.redhat.com/1848872) **Rebase on Wildfly 21.0.2**

   oVirt Engine is now requiring WildFly 21.0.2


#### oVirt Engine Data Warehouse

 - [BZ 1917848](https://bugzilla.redhat.com/1917848) **[RFE] Add hardware panel to Hosts Inventory Dashboard**

   If this bug requires documentation, please select an appropriate Doc Type value.


### Enhancements

#### oVirt Engine

 - [BZ 1910022](https://bugzilla.redhat.com/1910022) **[RFE] add button to switch the master storage domain role**

   Feature: 

Add a button to switch the master storage domain role from UI.



Reason: 

The ability to switch the master domain role is currently available only from SDK.



Result:

The master storage domain role can be switched by pressing the 'Set as master storage domain' button on the Storage Domain sidebar menu.

 - [BZ 1669178](https://bugzilla.redhat.com/1669178) **[RFE] Q35 SecureBoot - Add ability to preserve variable store certificates.**

   Secure Boot process relies on keys that are normally stored in NVRAM of the VM. However, NVRAM was not stored in previous versions of oVirt and was newly initialized on every start of a VM. This prevented the use of any custom drivers (e.g. for Nvidia devices or for PLDP drivers in SUSE) on VMs with Secure Boot enabled. To be able to use SecureBoot VMs effectively oVirt now persists the content of NVRAM for UEFI VMs.

 - [BZ 1926854](https://bugzilla.redhat.com/1926854) **[RFE] Requesting an audit log entry be added in LSM flow to display the host on which the internal volumes are copied**

   

 - [BZ 1787235](https://bugzilla.redhat.com/1787235) **[RFE] Offline disk move should log which host the data is being copied on in the audit log**

   

 - [BZ 1927851](https://bugzilla.redhat.com/1927851) **[RFE] Add timezone AUS Eastern Standard Time**

   The timezone AUS Eastern Standard Time is added to cover daylight saving in Canberra, Melbourne and Sydney.

 - [BZ 1155275](https://bugzilla.redhat.com/1155275) **[RFE] - Online update LUN size to the Guest after LUN resize**

   Feature: 

Online update LUNs on a guest while it's running.



Reason: 

In case of a LUN disk attached to a running VM, and its size has been updated, the host and VM should refresh the disk and get its updated information, without shutting down the VM.



Result: 

A 'Refresh LUN' button is now accessible from the VM Disks sub-tab.

This button syncs the LUN's size on all hosts connected to the LUN disk, and updates its size on the VM it's being attached to while the VM is running.

In case the disk is attached to more than one running VM, all VMs are being updated.

For not running VMs, the disk should be updated once the

VMs are back up.

 - [BZ 1926888](https://bugzilla.redhat.com/1926888) **[RFE][CBT] Allow mixed incremental backup of RAW and COW disks**

   Feature: 

VM backup that contains both full backups for part of the disks and incremental backups for the others is now allowed.



Reason:

A mixed backup will allow the creation of a backup for the VM under a single operation. 



Before that, the user had to do an incremental backup for the disks that already had a backup and supports it and a different full backup for the disks that are not marked as 'Incremental backup enabled'.



Result: 

Full and incremental backup can be taken in the same backup operation under the same checkpoint. the backup_mode of each disk in the backup will indicate the type of backup that was taken for each disk (full/incremental).

 - [BZ 1874483](https://bugzilla.redhat.com/1874483) **[CBT] During the VM backup, the local storage of the hypervisor is used**

   Feature:

The creation of scratch disks for a backup operation will use the same shared storage as the backed-up disks that participate in the backup.



Reason: 

For backup operation, scratch disks created in order to keep the 'old' disk state and persist the data until the backup is over. Those disks created on the host local storage which is limited and not scalable.



Result: 

For each disk that participates in the backup a scratch disk created on the same storage domain that the disk is based on.

This process is now done by the engine and not by the host, before the backup is taken, the scratch disks created and prepared for the backup. When the backup is done the scratch disks teardown and removed.

 - [BZ 1909197](https://bugzilla.redhat.com/1909197) **[CBT] Enable incremental backup by default for new installation**

   Feature:

Incremental backup enabled by default for 4.5 clusters.



Reason:

Allow using the incremental backup feature without any explicit database configuration operations



Result: 

For 4.5 clusters, incremental backup can be used without changing the "IsIncrementalBackupSupported" configuration value in the database.

 - [BZ 1922200](https://bugzilla.redhat.com/1922200) **Checking the Engine database consistency takes too long to complete**

   Up until now records in event_notification_hist table have been erased only during regular cleanup of audit_log table. By default we are periodically removing audit_log table records which are older than 30 days (can be overriden by AuditLogAgingThreshold option in engine-config).

But records in event_notification_hist are much less important than records in audit_log table, so we have decided to keep records in event_notification_hist table only for 7 days. This limit can be overriden by creating custom configuration file /etc/ovirt-engine/notifier/notifier.conf.d/history.conf with content below:



DAYS_TO_KEEP_HISTORY=NNN



where NNN is number of days to keep records in event_notification_host table.

After changing this value ovirt-engine-notifier service needs to be restarted:



 systemctl restart ovirt-engine-notifier

 - [BZ 1688186](https://bugzilla.redhat.com/1688186) **[RFE] CPU and NUMA Pinning shall be handled automatically**

   Previously, the CPU and NUMA pinning were done manually or automatically only by using REST-API when adding a new VM. This feature will add support for doing it automatically by UI and when updating a VM.

 - [BZ 1926942](https://bugzilla.redhat.com/1926942) **[RFE] Support up to 512 VCPUs**

   Increase the limit of virtual CPUs in 4.5 clusters to 512.

 - [BZ 1712481](https://bugzilla.redhat.com/1712481) **Migration fail between non-FIPS &lt;-&gt; FIPS enabled host**

   A new property added to the cluster entity: FIPS Mode.

The FIPS mode is `undefined` by default, to be later changed, or set to a specific mode: `disabled` or `enabled`.

The `undefined` is changed to the host specific capabilities, usually when a host in the cluster goes up.

Any hosts that won't fulfill the cluster's FIPS mode will become non-operational, while those who were non-operational because of that - will try to initialize and if no other problem occur, will become up.

This mode, will make alignment to the cluster specific allowing VMs to have the normal functionality such as migration between hosts.

 - [BZ 1837221](https://bugzilla.redhat.com/1837221) **[RFE] Allow using other than RSA SHA-1/SHA-2 public keys for SSH connections between RHVM and hypervisors**

   Currently RHV Manager was able to connect to hypervisors only using RSA public keys for SSH connection. From RHV 4.4.5 RHV Manager is also able to use EcDSA and EdDSA public keys for SSH.

Also up until now RHV used only fingerprint of SSH public key to verify the host. But with the ability to use non RSA public we need to store the whole public SSH key in RHV database, so using fingerprint is deprecated.



Newly added host to RHV Manager 4.4.5 will always be verified using the strongest public key offered by the host (unless administrator provide specific public key to use).

For existing hosts RHV Manager 4.4.5 will store the whole RSA public key into its database on the next SSH connection (for example if administrator moves the host to maintenance and executes Enroll certificate or Reinstall).

If administrator wants to use different public key for the host, he can provide custom public key using RESTAPI or fetching the strongest public key in webadmin in Edit host dialog.

 - [BZ 1900564](https://bugzilla.redhat.com/1900564) **[CBT][incremental backup] Engine cannot stop backup because VM is hang, cannot destroy VM because backup is running**

   Feature:

It is now allowed to shutdown/power-off/reboot a VM even if the VM is during a backup. It can be done only by using the REST-API.



Reason:

There are cases when the VM backup is hanged so the backup is stuck. We should have a way to shutdown/power-off/reboot the VM in those cases.



Result:

VM can be shutdown/power-off/reboot during a backup by using the following request:



POST /ovirt-engine/api/vms/123/(shutdown/power-off/reboot)



&lt;action&gt;

    &lt;force&gt;true&lt;/force&gt;

&lt;/action&gt;

 - [BZ 1910302](https://bugzilla.redhat.com/1910302) **[RFE] Allow SPM switching if all tasks have finished via UI**

   Feature:

Adding a menu to support finished tasks' clean-up.



Reason:

Currently the SPM fails to switch to another host if the SPM contains uncleared tasks.



Result:

The storage pool manager (SPM) fails to switch to another host if the SPM has uncleared tasks.

Clearing all the finished tasks enables the SPM switching.

This RFE adds a UI menu to cleanup 1 or more active Data Centers and is based on 'Bug 1627997' that implemented this functionality in REST API.

 - [BZ 1753645](https://bugzilla.redhat.com/1753645) **[RFE] Enable bochs-display for UEFI guests**

   

 - [BZ 1891470](https://bugzilla.redhat.com/1891470) **[CBT][RFE] Support cold VM incremental backup**

   Feature: 

Support VM backup when the VM is not running



Reason: 

Backup vendors and users should have the option to backup their VMs even when they are not running.



Result:

Backup of VMs that are not running is now supported, the same API that used for backup running VMs is used so it is transparent for the backup vendor or the user what is the status of the VM.



The process of 'cold' backup is different, when a cold backup is taken there is no need to redefine the previous checkpoints and to create scratch disks for each disk that participate in the backup because the VM is down and there will be no writing to the disks during the backup.



The backup operation is done without Libvirt.

A checkpoint created in the Engine DB in the same way as for 'live' backup but in the host, there is no checkpoint creation. Instead, a new bitmap is added for each disk.

The created bitmap will be exposed using the NBD server when the image will be downloaded using imageio.



When the VM is started with "cold" backup checkpoints, the system will redefine the checkpoints in Libvirt. Once a 'cold' checkpoint is redefined, there is no difference between the 'cold' checkpoint and checkpoint created during live backup.

 - [BZ 1899583](https://bugzilla.redhat.com/1899583) **[RFE] Allow Live update of network filter's parameters**

   Feature: Allow live update of vnic filter parameters



Reason: Better user experience: if live update is not available the user has to unplug and re-plug the vnic after an update.



Result: When adding\deleting\editing filter parameters of a VM's vnic in engine, they are applied immediately on the device on the VM.

 - [BZ 1866749](https://bugzilla.redhat.com/1866749) **[RFE] provide warning for soft errors**

   Feature: Allow to set severity for messages that are displayed via ansible debug module



Reason: When some tasks fail they don't stop the host deploy flow, but a debug message is printed in the host deploy log. However, host deploy log is mostly not looked at when host deploy finishes successfully, so such messages can be missed.



Result: When using the debug module for ansible roles in the host deploy flow, a message that will be written in the format of: "[SEVERITY] message" where SEVERITY is one of {ERROR, WARNING, ALERT} will be parsed and printed in the audit log with its correct severity level.

 - [BZ 1853906](https://bugzilla.redhat.com/1853906) **[RFE] Add the ability to reboot after install/ reinstall**

   Feature: 'Reboot' option was added to the install and reinstall flows and is enabled by default (same as in the upgrade flow)



Reason: Rebooting the host is needed is several cases such as specifying new kernel parameters and when switching from iptables to firewalld



Result: When installing/ reinstalling host, reboot is enabled by default (can be disabled by the administrator)


#### VDSM

 - [BZ 1155275](https://bugzilla.redhat.com/1155275) **[RFE] - Online update LUN size to the Guest after LUN resize**

   Feature: 

Online update LUNs on a guest while it's running.



Reason: 

In case of a LUN disk attached to a running VM, and its size has been updated, the host and VM should refresh the disk and get its updated information, without shutting down the VM.



Result: 

A 'Refresh LUN' button is now accessible from the VM Disks sub-tab.

This button syncs the LUN's size on all hosts connected to the LUN disk, and updates its size on the VM it's being attached to while the VM is running.

In case the disk is attached to more than one running VM, all VMs are being updated.

For not running VMs, the disk should be updated once the

VMs are back up.

 - [BZ 1874483](https://bugzilla.redhat.com/1874483) **[CBT] During the VM backup, the local storage of the hypervisor is used**

   Feature:

The creation of scratch disks for a backup operation will use the same shared storage as the backed-up disks that participate in the backup.



Reason: 

For backup operation, scratch disks created in order to keep the 'old' disk state and persist the data until the backup is over. Those disks created on the host local storage which is limited and not scalable.



Result: 

For each disk that participates in the backup a scratch disk created on the same storage domain that the disk is based on.

This process is now done by the engine and not by the host, before the backup is taken, the scratch disks created and prepared for the backup. When the backup is done the scratch disks teardown and removed.

 - [BZ 1669178](https://bugzilla.redhat.com/1669178) **[RFE] Q35 SecureBoot - Add ability to preserve variable store certificates.**

   Secure Boot process relies on keys that are normally stored in NVRAM of the VM. However, NVRAM was not stored in previous versions of oVirt and was newly initialized on every start of a VM. This prevented the use of any custom drivers (e.g. for Nvidia devices or for PLDP drivers in SUSE) on VMs with Secure Boot enabled. To be able to use SecureBoot VMs effectively oVirt now persists the content of NVRAM for UEFI VMs.

 - [BZ 1891470](https://bugzilla.redhat.com/1891470) **[CBT][RFE] Support cold VM incremental backup**

   Feature: 

Support VM backup when the VM is not running



Reason: 

Backup vendors and users should have the option to backup their VMs even when they are not running.



Result:

Backup of VMs that are not running is now supported, the same API that used for backup running VMs is used so it is transparent for the backup vendor or the user what is the status of the VM.



The process of 'cold' backup is different, when a cold backup is taken there is no need to redefine the previous checkpoints and to create scratch disks for each disk that participate in the backup because the VM is down and there will be no writing to the disks during the backup.



The backup operation is done without Libvirt.

A checkpoint created in the Engine DB in the same way as for 'live' backup but in the host, there is no checkpoint creation. Instead, a new bitmap is added for each disk.

The created bitmap will be exposed using the NBD server when the image will be downloaded using imageio.



When the VM is started with "cold" backup checkpoints, the system will redefine the checkpoints in Libvirt. Once a 'cold' checkpoint is redefined, there is no difference between the 'cold' checkpoint and checkpoint created during live backup.

 - [BZ 1899583](https://bugzilla.redhat.com/1899583) **[RFE] Allow Live update of network filter's parameters**

   Feature: Allow live update of vnic filter parameters



Reason: Better user experience: if live update is not available the user has to unplug and re-plug the vnic after an update.



Result: When adding\deleting\editing filter parameters of a VM's vnic in engine, they are applied immediately on the device on the VM.


#### oVirt Engine Data Warehouse

 - [BZ 1887149](https://bugzilla.redhat.com/1887149) **[RFE] VM Disk stats should contain IOPS stats**

   Feature: 

Collect VM disks IOPS stats to DWH database



Reason: 

Allow users to view VM disks IOPS stats



Result: 

VM disks IOPS stats are now saved to DWH database and aggregated to hourly and daily data.


### Known Issue

#### oVirt Engine

 - [BZ 1912426](https://bugzilla.redhat.com/1912426) **Disable suspending a VM with an NVDIMM device**

   Suspending VMs with NVDIMMs can be very slow and prevent operating the VM for a very long time. For this reason, hibernating VMs with NVDIMMs has been disabled, until the underlying issues are fixed.


### Bug Fixes

#### oVirt Engine SDK 4 Python

 - [BZ 1848586](https://bugzilla.redhat.com/1848586) **Fix upload_ova_as_template.py**


#### OTOPI

 - [BZ 1344270](https://bugzilla.redhat.com/1344270) **dnf: Check package signature**


#### oVirt Engine

 - [BZ 1931932](https://bugzilla.redhat.com/1931932) **Adding VM to an existing affinity group always returns an error although the action was successful**

 - [BZ 1897532](https://bugzilla.redhat.com/1897532) **VmPool created without ballooning when template has ballooning enabled**

 - [BZ 1931474](https://bugzilla.redhat.com/1931474) **SSH connection fails**

 - [BZ 1931786](https://bugzilla.redhat.com/1931786) **Windows driver update does not work on cluster level 4.5**

 - [BZ 1145658](https://bugzilla.redhat.com/1145658) **Storage domain removal does not check if the storage domain contains any memory dumps.**

 - [BZ 1895217](https://bugzilla.redhat.com/1895217) **Hosted-Engine --restore-from-file fails if backup has VM pinned to restore host and has no Icon set.**

 - [BZ 1921119](https://bugzilla.redhat.com/1921119) **RHV reports unsynced cluster when host QoS is in use.**

 - [BZ 1890665](https://bugzilla.redhat.com/1890665) **Update numa node value is not applied after the VM restart**

 - [BZ 1910411](https://bugzilla.redhat.com/1910411) **Always use Single-PCI for Linux guests**

 - [BZ 1914648](https://bugzilla.redhat.com/1914648) **Q35: BIOS type changed to "Default" when creating new VM from template with Q35 chipset.**

 - [BZ 1905108](https://bugzilla.redhat.com/1905108) **Cannot hotplug disk reports libvirtError: Requested operation is not valid: Domain already contains a disk with that address**

 - [BZ 1910338](https://bugzilla.redhat.com/1910338) **OVA export might fail with: nlosetup: /var/tmp/ova_vm.ova.tmp: failed to set up loop device: Resource temporarily unavailable**

 - [BZ 1886520](https://bugzilla.redhat.com/1886520) **Cannot import OVA that was exported from oVirt on PPC**

 - [BZ 1908757](https://bugzilla.redhat.com/1908757) **Create VM by auto_pinning_policy=adjust fails with ArrayIndexOutOfBoundsException**

 - [BZ 1906270](https://bugzilla.redhat.com/1906270) **HW clock and windows clock problem in Turkey Standard Time**


#### VDSM

 - [BZ 1860492](https://bugzilla.redhat.com/1860492) **Create template with option "seal template" from VM snapshot fails to remove VM specific information.**

 - [BZ 1916519](https://bugzilla.redhat.com/1916519) **Host memory statistics discrepancies due to SReclaimable**

 - [BZ 1773922](https://bugzilla.redhat.com/1773922) **remote-viewer prompts for password after migration of a VM with expired ticket**


#### oVirt Engine Data Warehouse

 - [BZ 1903977](https://bugzilla.redhat.com/1903977) **Fix Trend Dashboards to show 5/3 entities**


#### oVirt Hosted Engine HA

 - [BZ 1916032](https://bugzilla.redhat.com/1916032) **Engine allows deploying HE hosts with spm_id &gt; 64 but broker won't read past slot 64**

 - [BZ 1815589](https://bugzilla.redhat.com/1815589) **The HA agent trying to start HE VM in source host after successful HE migration**


### Other

#### cockpit-ovirt

 - [BZ 1755156](https://bugzilla.redhat.com/1755156) **[RFE] Cockpit: RHV deployment missing local appliance installation**

   

 - [BZ 1780881](https://bugzilla.redhat.com/1780881) **[RFE] Allow pausing during deploy**

   

 - [BZ 1908234](https://bugzilla.redhat.com/1908234) **Order of hosts not preserved for day2 operations**

   

 - [BZ 1884223](https://bugzilla.redhat.com/1884223) **[GSS][RHHI 1.7][Error message '&lt;device-path&gt;  is not a valid name for this device' showing up every two hours]**

   


#### oVirt Engine SDK 4 Python

 - [BZ 1805030](https://bugzilla.redhat.com/1805030) **Java SDK connection.timeout is in milliseconds**

   


#### OTOPI

 - [BZ 1908602](https://bugzilla.redhat.com/1908602) **dnf packager is broken on CentOS Stream**

   


#### oVirt Engine

 - [BZ 1892676](https://bugzilla.redhat.com/1892676) **The ImageIO transfer doesn't finalize after timeout is reached**

   

 - [BZ 1923095](https://bugzilla.redhat.com/1923095) **iscsi search UI exception**

   

 - [BZ 1928705](https://bugzilla.redhat.com/1928705) **VM configured with the CPUs equal to the host fails to start on ppc arch**

   

 - [BZ 1930733](https://bugzilla.redhat.com/1930733) **Cluster upgrade fails when using Intel Skylake Client/Server IBRS SSBD MDS Family**

   

 - [BZ 1905158](https://bugzilla.redhat.com/1905158) **After upgrading RHVH 4.4.2 to 4.4.3 moves to non-operational due to missing CPU features : model_Cascadelake-Server**

   

 - [BZ 1923717](https://bugzilla.redhat.com/1923717) **When creating a VM via rest from a template with ballooning=false, the template's ballooning setting is ignored if memory_policy exists**

   

 - [BZ 1715287](https://bugzilla.redhat.com/1715287) **VM starts with UEFI+pc-q35-rhel7.6.0 XML when configuring UEFI bios type+pc-i440fx-rhel7.6.0 in WEB UI**

   

 - [BZ 1868249](https://bugzilla.redhat.com/1868249) **The OVF disk size on file storage reported by engine does not match the actual size of the OVF**

   

 - [BZ 1729359](https://bugzilla.redhat.com/1729359) **Failed image upload leaves disk in locked state, requiring manual intervention to cleanup.**

   

 - [BZ 1905394](https://bugzilla.redhat.com/1905394) **CPU validation fails with VM custom compatibility version**

   

 - [BZ 1854041](https://bugzilla.redhat.com/1854041) **[v2v] Warning message during every v2v import about incompatible parameter "memory"**

   

 - [BZ 1649479](https://bugzilla.redhat.com/1649479) **[RFE] OVF_STORE last update not exposed in the UI**

   

 - [BZ 1912435](https://bugzilla.redhat.com/1912435) **Add event log for starting/finishing SwitchMasterStorageDomain**

   

 - [BZ 1901503](https://bugzilla.redhat.com/1901503) **Misleading error message, displaying Data Center Storage Type instead of its name**

   

 - [BZ 1805819](https://bugzilla.redhat.com/1805819) **[de_DE] Compute - Templates - Template - Storage: table column headings truncated**

   

 - [BZ 1875412](https://bugzilla.redhat.com/1875412) **Request to create a nic on template gets wrong response content**

   

 - [BZ 1897160](https://bugzilla.redhat.com/1897160) **SCSI Pass-Through is enabled by default**

   


#### VDSM

 - [BZ 1928041](https://bugzilla.redhat.com/1928041) **Stale DM links after block SD removal**

   

 - [BZ 1925099](https://bugzilla.redhat.com/1925099) **[CBT] Incremental backup errors when disk was replaced**

   

 - [BZ 1796415](https://bugzilla.redhat.com/1796415) **Live Merge  and Remove Snapshot fails**

   

 - [BZ 1870435](https://bugzilla.redhat.com/1870435) **StorageDomain.dump() can return {"key" : None} if metadata is missing**

   

 - [BZ 1858956](https://bugzilla.redhat.com/1858956) **Bad handling of imageio errors since imageio 1.5**

   


#### oVirt Engine Data Warehouse

 - [BZ 1899529](https://bugzilla.redhat.com/1899529) **[RFE] Add Virtual Machines Dashboard**

   

 - [BZ 1899573](https://bugzilla.redhat.com/1899573) **[RFE] Add IOPS stats to vms dashboard**

   

 - [BZ 1898863](https://bugzilla.redhat.com/1898863) **[RFE] Add Hosts Dashboard**

   

 - [BZ 1914825](https://bugzilla.redhat.com/1914825) **Update queries to use v4_4 views in all dashboards**

   

 - [BZ 1910045](https://bugzilla.redhat.com/1910045) **Update data source in all dashboards**

   

 - [BZ 1912887](https://bugzilla.redhat.com/1912887) **Update variables on dashboards that do not display deleted entities**

   

 - [BZ 1904047](https://bugzilla.redhat.com/1904047) **Add types of storage and storage domain to enum_translator table (enums.sql)**

   


#### oVirt Ansible collection

 - [BZ 1915286](https://bugzilla.redhat.com/1915286) **RHHI-V deployment fails on task "Get server CPU list via REST API"**

   


#### imgbased

 - [BZ 1907746](https://bugzilla.redhat.com/1907746) **RHVH cannot enter the new layer after upgrade testing with STIG profile selected.**

   


### No Doc Update

#### OTOPI

 - [BZ 1908617](https://bugzilla.redhat.com/1908617) **otopi is using a private dnf method _read_conf_file**

   


#### oVirt Engine

 - [BZ 1925025](https://bugzilla.redhat.com/1925025) **Add information tooltip icon to the new reboot host option**

   

 - [BZ 1932188](https://bugzilla.redhat.com/1932188) **The nic href in the response of getting template nics is wrong**

   

 - [BZ 1930198](https://bugzilla.redhat.com/1930198) **[Webadmin] Fetch ssh public key instead of fingerprint when adding new host.**

   

 - [BZ 1914602](https://bugzilla.redhat.com/1914602) **[RHV 4.4] /var/lib/ovirt-engine/external_truststore (Permission denied)**

   

 - [BZ 1914636](https://bugzilla.redhat.com/1914636) **[CBT] Engine fails to complete full backup due to Java exception "RedefineVmCheckpointCommand cannot be cast to class org.ovirt.engine.core.bll.SerialChildExecutingComman"**

   

 - [BZ 1924962](https://bugzilla.redhat.com/1924962) **AnsibleServlet used by cluster upgrade fails to properly start the ovirt-cluster-upgrade.yml playbook**

   

 - [BZ 1926277](https://bugzilla.redhat.com/1926277) **Exception: Failed to create host deploy variables mapper Unexpected IOException (of type org.codehaus.jackson.JsonParseException): Illegal character '_' (code 0x5f) in base64 content**

   

 - [BZ 1917821](https://bugzilla.redhat.com/1917821) **Adding new host with reboot causes the host to end up non operational**

   

 - [BZ 1924823](https://bugzilla.redhat.com/1924823) **Reboot host after host deploy is not exposed in RESTAPI**

   

 - [BZ 1903052](https://bugzilla.redhat.com/1903052) **ansible-runner-service.cil selinux module is often needlessly re-installed, takes a long time**

   

 - [BZ 1917809](https://bugzilla.redhat.com/1917809) **When running reboot after reinstall of a host reboot is reported as failed**

   

 - [BZ 1922094](https://bugzilla.redhat.com/1922094) **Upgrading host with reboot after upgrade option failes**

   

 - [BZ 1923218](https://bugzilla.redhat.com/1923218) **VM fails to start after preview operation - Exit message: XML error: Invalid PCI address 0000:05:00.0. slot must be &gt;= 1.**

   

 - [BZ 1919555](https://bugzilla.redhat.com/1919555) **Rebase apache-sshd to version 2.6.0 for RHV 4.4.5**

   

 - [BZ 1919628](https://bugzilla.redhat.com/1919628) **VM pool size update using the REST API fails**

   

 - [BZ 1915329](https://bugzilla.redhat.com/1915329) **[Stream] Add host fails with: Destination /etc/pki/ovirt-engine/requests not writable**

   

 - [BZ 1918022](https://bugzilla.redhat.com/1918022) **oVirt Manager is not loading after engine-setup**

   

 - [BZ 1581677](https://bugzilla.redhat.com/1581677) **[scale] search (VMs + storage domain) is taking too long**

   

 - [BZ 1846294](https://bugzilla.redhat.com/1846294) **Engine restart needed after ovirt-register-sso-client-tool**

   

 - [BZ 1911303](https://bugzilla.redhat.com/1911303) **host deploy fails when parameters are set with the value null**

   


#### VDSM

 - [BZ 1796124](https://bugzilla.redhat.com/1796124) **Live Merge  and Remove Snapshot fails**

   

 - [BZ 1896245](https://bugzilla.redhat.com/1896245) **[CBT][RFE] Use the new VIR_ERR_CHECKPOINT_INCONSISTENT error from libvirt to identify invalid checkpoints**

   

 - [BZ 1915025](https://bugzilla.redhat.com/1915025) **Unable to backup VM with raw disk after snapshot deletion**

   

 - [BZ 1916947](https://bugzilla.redhat.com/1916947) **The syntax of the entry in '99-vdsm_protect_ifcfg.conf' is incorrect**

   


#### oVirt Engine Data Warehouse

 - [BZ 1926188](https://bugzilla.redhat.com/1926188) **Fix vms disks usage panels to show the average**

   

 - [BZ 1922645](https://bugzilla.redhat.com/1922645) **typo "Saterday" on VM resource usage dashboard panels.**

   

 - [BZ 1898858](https://bugzilla.redhat.com/1898858) **[RFE] Add to the Variables the option to select one or more**

   


#### Contributors

44 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: ovirt-release, vdsm)
	Amit Bawer (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, ovirt-engine-wildfly)
	Asaf Rachmani (Contributed to: imgbased, ovirt-ansible-collection, ovirt-hosted-engine-ha)
	Aviv Litman (Contributed to: ovirt-dwh)
	Aviv Turgeman (Contributed to: cockpit-ovirt, ovirt-engine-nodejs-modules)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Ben Amsalem (Contributed to: ovirt-engine, ovirt-web-ui)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Evgeny Slutsky (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Jean-Louis Dupond (Contributed to: ovirt-engine, vdsm)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection, ovirt-engine)
	Martin Perina (Contributed to: ovirt-engine, ovirt-engine-wildfly)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Levy (Contributed to: imgbased, ovirt-host)
	Nir Soffer (Contributed to: vdsm)
	Ondra Machacek (Contributed to: ovirt-engine-sdk-java)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk, ovirt-engine-sdk-java)
	Parth Dhanjal (Contributed to: cockpit-ovirt)
	Pavel Bar (Contributed to: ovirt-engine)
	Prajith Kesava Prasad (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Roman Bednar (Contributed to: vdsm)
	Sandro Bonazzola (Contributed to: cockpit-ovirt, ovirt-cockpit-sso, ovirt-engine, ovirt-engine-sdk-java, ovirt-host, ovirt-release, vdsm)
	Scott J Dickerson (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-web-ui)
	Shane McDonald (Contributed to: ovirt-ansible-collection)
	Shani Leviim (Contributed to: ovirt-engine, vdsm)
	Sharon Gratch (Contributed to: ovirt-engine-nodejs-modules, ovirt-web-ui)
	Shirly Radco (Contributed to: ovirt-dwh)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Steven Rosenberg (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: otopi, ovirt-ansible-collection, ovirt-cockpit-sso, ovirt-engine, ovirt-host, ovirt-hosted-engine-ha)

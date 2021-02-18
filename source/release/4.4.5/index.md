---
title: oVirt 4.4.5 Release Notes
category: documentation
authors: lveyde sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.5 release planning

The oVirt 4.4.5 code freeze is planned for February 08, 2021.

If no critical issues are discovered while testing this compose it will be released on March 04, 2021.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.4.5](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.4.5%22%20-target_milestone%3A%22ovirt-4.4.5-%22)


# oVirt 4.4.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.5 Sixth Release Candidate as of February 18, 2021.

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

 - [BZ 1753645](https://bugzilla.redhat.com/1753645) **[RFE] Enable bochs-display for UEFI guests**

   

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

 - [BZ 1908234](https://bugzilla.redhat.com/1908234) **Order of hosts not preserved for day2 operations**

   

 - [BZ 1884223](https://bugzilla.redhat.com/1884223) **[GSS][RHHI 1.7][Error message '&lt;device-path&gt;  is not a valid name for this device' showing up every two hours]**

   


#### oVirt Engine SDK 4 Python

 - [BZ 1805030](https://bugzilla.redhat.com/1805030) **Java SDK connection.timeout is in milliseconds**

   


#### OTOPI

 - [BZ 1908602](https://bugzilla.redhat.com/1908602) **dnf packager is broken on CentOS Stream**

   


#### oVirt Engine

 - [BZ 1923717](https://bugzilla.redhat.com/1923717) **[REST API ] When creating a VM via rest from a template with ballooning=false, the temp's ballooning setting is ignored if memory_policy exists**

   

 - [BZ 1715287](https://bugzilla.redhat.com/1715287) **VM starts with UEFI+pc-q35-rhel7.6.0 XML when configuring UEFI bios type+pc-i440fx-rhel7.6.0 in WEB UI**

   

 - [BZ 1905394](https://bugzilla.redhat.com/1905394) **CPU validation fails with VM custom compatibility version**

   

 - [BZ 1854041](https://bugzilla.redhat.com/1854041) **[v2v] Warning message during every v2v import about incompatible parameter "memory"**

   

 - [BZ 1920871](https://bugzilla.redhat.com/1920871) **[RHHI-V] gluster-brick-create task fails when creating brick with LV cache from RHV admin portal**

   

 - [BZ 1910302](https://bugzilla.redhat.com/1910302) **[RFE] Allow SPM switching if all tasks have finished via UI**

   

 - [BZ 1649479](https://bugzilla.redhat.com/1649479) **[RFE] OVF_STORE last update not exposed in the UI**

   

 - [BZ 1875412](https://bugzilla.redhat.com/1875412) **Request to create a nic on template gets wrong response content**

   

 - [BZ 1897160](https://bugzilla.redhat.com/1897160) **SCSI Pass-Through is enabled by default**

   


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

#### cockpit-ovirt

 - [BZ 1893161](https://bugzilla.redhat.com/1893161) **Cockpit hosted engine installer allows a disk size bigger than the LUN**

   


#### OTOPI

 - [BZ 1908617](https://bugzilla.redhat.com/1908617) **otopi is using a private dnf method _read_conf_file**

   


#### oVirt Engine

 - [BZ 1924962](https://bugzilla.redhat.com/1924962) **AnsibleServlet used by cluster upgrade fails to properly start the ovirt-cluster-upgrade.yml playbook**

   

 - [BZ 1926277](https://bugzilla.redhat.com/1926277) **Exception: Failed to create host deploy variables mapper Unexpected IOException (of type org.codehaus.jackson.JsonParseException): Illegal character '_' (code 0x5f) in base64 content**

   

 - [BZ 1925025](https://bugzilla.redhat.com/1925025) **Add information tooltip icon to the new reboot host option**

   

 - [BZ 1917821](https://bugzilla.redhat.com/1917821) **Adding new host with reboot causes the host to end up non operational**

   

 - [BZ 1924823](https://bugzilla.redhat.com/1924823) **Reboot host after host deploy is not exposed in RESTAPI**

   

 - [BZ 1903052](https://bugzilla.redhat.com/1903052) **ansible-runner-service.cil selinux module is often needlessly re-installed, takes a long time**

   

 - [BZ 1923218](https://bugzilla.redhat.com/1923218) **VM fails to start after preview operation - Exit message: XML error: Invalid PCI address 0000:05:00.0. slot must be &gt;= 1.**

   

 - [BZ 1919555](https://bugzilla.redhat.com/1919555) **Rebase apache-sshd to version 2.6.0 for RHV 4.4.5**

   

 - [BZ 1919628](https://bugzilla.redhat.com/1919628) **VM pool size update using the REST API fails**

   

 - [BZ 1915329](https://bugzilla.redhat.com/1915329) **[Stream] Add host fails with: Destination /etc/pki/ovirt-engine/requests not writable**

   

 - [BZ 1918022](https://bugzilla.redhat.com/1918022) **oVirt Manager is not loading after engine-setup**

   

 - [BZ 1581677](https://bugzilla.redhat.com/1581677) **[scale] search (VMs + storage domain) is taking too long**

   

 - [BZ 1846294](https://bugzilla.redhat.com/1846294) **Engine restart needed after ovirt-register-sso-client-tool**

   

 - [BZ 1911303](https://bugzilla.redhat.com/1911303) **host deploy fails when parameters are set with the value null**

   


#### VDSM

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

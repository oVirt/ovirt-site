---
title: oVirt 4.4.7 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.7 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.7 release as of July 06, 2021.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.4 (or similar) and CentOS Stream.

> **NOTE**
>
> Starting from oVirt 4.4.6 both oVirt Node and oVirt Engine Appliance are
> based on CentOS Stream.

{:.alert.alert-warning}
Please note that if you are upgrading oVirt Node from previous version you should remove CentOS Linux related yum configuration.
See Bug [1955617 - CentOS Repositories should be removed from yum.repo.d when upgrading to CentOS Stream](https://bugzilla.redhat.com/show_bug.cgi?id=1955617)
For more details.


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

To learn about features introduced before 4.4.7, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.7 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.7 (redeploy in case of already being on 4.4.7).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.7?

### Release Note

#### oVirt Engine WildFly

 - [BZ 1938101](https://bugzilla.redhat.com/1938101) **Rebase on Wildfly 23**

   oVirt Engine now requires WildFly 23


#### oVirt Engine Data Warehouse

 - [BZ 1966574](https://bugzilla.redhat.com/1966574) **Update the required Grafana to 7.3 in ovirt-dwh**

   Required Grafana version changed from 6.7 to 7.3.


#### oVirt Engine

 - [BZ 1901011](https://bugzilla.redhat.com/1901011) **[RFE] Remove Foreman integration from engine**

   Foreman integration, which allow to provision bare metal hosts from webadmin using Foreman and afterwards being added to engine, hasn't been properly maintained for quite some time due to resource limitation and as there was no significant feedback from users about this feature, it was deprecated in oVirt 4.4.6 and now removed completely in oVirt 4.4.7.



Similar functionality to provision bare metal host can be achieved using Foreman directly and after that just add already provisioned host using webadmin or RESTAPI.

 - [BZ 1804774](https://bugzilla.redhat.com/1804774) **Simplify the process to add a msg on the RHVM Admin Portal Login**

   Adding a message to the welcome page is straight forward using a custom branding only containing a preamble section. An example of a preamble branding is https://bugzilla.redhat.com/attachment.cgi?id=1783329.



On an engine upgrade the custom preamble brand will remain in place and will work without issue.



During an engine backup and subsequent restore, on engine restore it is expected that the custom preamble branding will need to be manually restored/reinstalled and verified.

 - [BZ 1950343](https://bugzilla.redhat.com/1950343) **[RFE] Set compatibility level 4.6 for Default DataCenter/Cluster during new installations of oVirt 4.4.7**

   Default DataCenter/Cluster will be set to compatibility level 4.6 on new installations of oVirt 4.4.7

 - [BZ 1966145](https://bugzilla.redhat.com/1966145) **Remove version lock on specific ansible version and require ansible 2.9.z &gt;= 2.9.21 in ovirt-engine**

   ovirt-engine in RHV 4.4.7 requires ansible 2.9.z higher than 2.9.20. Also in RHV 4.4.7 version for specific ansible version has been removed, because correct ansible version shipped in RHV channels.

 - [BZ 1938101](https://bugzilla.redhat.com/1938101) **Rebase on Wildfly 23**

   oVirt Engine now requires WildFly 23


#### ovirt-engine-extension-aaa-ldap

 - [BZ 1964522](https://bugzilla.redhat.com/1964522) **Allow both automatic detection of IP version available as well as manual configuration**

   To solve issues in mixed Pv4/IPv6 setups following changes has been done:



1. A new option pool.default.socketfactory.resolver.detectIPVersion

   to enable/disable automatic detection of IP protocol has been

   introduced:

    - By default set to true

    - Automatic detection of IP versions has been improved to use

      the default gateway IP addresses (if a default gateway has

      IPv4/IPv6 address, A/AAAA DNS records are used to resolve LDAP

      servers FQDNs)

    - If automatic detection is disabled, then administrators need

      to set properly below options according to their network setup



2. A new option pool.default.socketfactory.resolver.supportIPv4

   to enable/disable usage of IPv4 has been introduced:

    - By default set to false (automatic detection is preferred)

    - If set to true, type "A" DNS records are used to resolve LDAP

      servers FQDNs

   

3. Existing option pool.default.socketfactory.resolver.supportIPv6

   is used to enable/disable usage of IPv6

    - By default set to false (in previous versions it was enabled)

    - If set to true, type "AAAA" DNS records are used to resolve

      LDAP servers FQDNs



So by default automatic detection of IP version using the default gateway addresses is used, which should work for most of the setups. If there is some special mixed IPv4/IPv6 setup, where automatic detection fails, then it's needed to turn off automatic detection and configure IP versions manually as a part of /etc/ovirt-engine/aaa/&lt;PROFILE&gt;.properties configuration for specific LDAP setup.


### Enhancements

#### oVirt Host Dependencies

 - [BZ 1947450](https://bugzilla.redhat.com/1947450) **ovirt-host shouldn't have hard dependency on vdsm hooks**

   ovirt-host package now doesn't pull in any vdsm-hook anymore.

Users now can decide if to install specific vdsm hooks or not.


#### oVirt Engine Data Warehouse

 - [BZ 1948418](https://bugzilla.redhat.com/1948418) **[RFE] Add memory, and CPU sizes to Hosts/Virtual Machines Trend dashboard**

   Feature: 

added to hosts and vms trend dashboards 2 panels. one withe the total memory size, and one with the total cpu cores.

 - [BZ 1849685](https://bugzilla.redhat.com/1849685) **[RFE] Handle PKI renew for grafana**

   engine-setup now allows renewing the certificate also for grafana when it is set up on a separate machine from the engine.

 - [BZ 1952424](https://bugzilla.redhat.com/1952424) **[RFE]  Add Data Source variable to all dashboards**

   Feature: Add the option to select Data Source for all dashboards.



Reason: 

This way we can navigate easily if there are several different engines (with different dwh).


#### VDSM

 - [BZ 1966177](https://bugzilla.redhat.com/1966177) **[CBT][RFE] Unable to delete a vm checkpoint if vm has poweroff state**

   Feature: 

VM checkpoint can be removed while the VM is in a 'DOWN' state.



Reason: 

Until now, the VM checkpoint that was taken during a VM backup process can be removed only when the VM is running. This fix provides the ability to remove the VM checkpoint when the VM isn't running using the same API - 



DELETE /vms/123/checkpoints/456/



Result: 

VM checkpoint can be removed when the VM is 'UP' or 'DOWN' using the same API.

 - [BZ 1947450](https://bugzilla.redhat.com/1947450) **ovirt-host shouldn't have hard dependency on vdsm hooks**

   ovirt-host package now doesn't pull in any vdsm-hook anymore.

Users now can decide if to install specific vdsm hooks or not.


#### oVirt Engine

 - [BZ 1849861](https://bugzilla.redhat.com/1849861) **[RFE][v2v] [upload/download disk/CBT] Failed to attach disk to the VM - disk is OK but image transfer still holds a lock on the disk**

   Feature:

1. Add 2 new backup phases:

- SUCCEEDED

- FAILED

2. Disable 'vm_backups' &amp; 'image_transfers' DB tables cleanup after backup / image transfer operation is over.

3. Add DB cleanup scheduled thread to automatically clean backups and image transfers once in a while.



Reason:

After backup / image transfer operation finishes, all the execution data disappeared.

That means, that the user didn't know the final execution state of the operation that was visible via DB and API while the backup / image transfer execution was still in progress.

In case of backup operation, the situation was even worse - there was no indication for success/failure, the last thing the user might be able to see is the 'FINALIZING' status.

We want the user to be able to see the operation result, but also not over-polute the database with too old data.



Result:

1. Added 2 new backup phases to show possible execution statuses (success/failure) for backup operations.

2. Cancel DB cleanup of the 'vm_backups' &amp; 'image_transfers' DB tables when the backup / image transfer finishes to allow DB &amp; API status retrieval by user.

3. Scheduled execution of the cleanup - 15 minutes for success entries, 30 minutes for the failure. Separate values for backup &amp; for image transfer operations, an additional value for the cleanup thread rate (all 5 values are configurable).

4. Some minor user experience improvements.

 - [BZ 1966177](https://bugzilla.redhat.com/1966177) **[CBT][RFE] Unable to delete a vm checkpoint if vm has poweroff state**

   Feature: 

VM checkpoint can be removed while the VM is in a 'DOWN' state.



Reason: 

Until now, the VM checkpoint that was taken during a VM backup process can be removed only when the VM is running. This fix provides the ability to remove the VM checkpoint when the VM isn't running using the same API - 



DELETE /vms/123/checkpoints/456/



Result: 

VM checkpoint can be removed when the VM is 'UP' or 'DOWN' using the same API.

 - [BZ 1913858](https://bugzilla.redhat.com/1913858) **[RFE] Enable high-availability for VMs that are pinned to host(s)**

   

 - [BZ 1958081](https://bugzilla.redhat.com/1958081) **[RFE] Enable ramfb for mdev with display=on**

   When a vGPU is used and nodisplay is not specified, an additional framebuffer display device is added to the VM now, allowing to display the VM console before the vGPU is initialized. This allows display console access during boot, instead of having just a blank screen there as before this change.



This works only on cluster levels &gt;= 4.5. It is possible to disable the feature by setting VgpuFramebufferSupported Engine config value to false.

 - [BZ 1953468](https://bugzilla.redhat.com/1953468) **[CBT][RFE] Allow removing non-root checkpoints from the VM**

   Feature:

Allow removing any VM checkpoint from the checkpoint chain and not just the root checkpoint



Reason: 

Users should be able to remove any checkpoint from the VM backups checkpoints chain.

 

Result: 

Any checkpoint from the VM checkpoints chain can be removed and not just the root checkpoint in the chain.


#### oVirt Ansible collection

 - [BZ 1959273](https://bugzilla.redhat.com/1959273) **Add the option to pause Hosted-Engine deployment before running engine-setup**

   Feature: Allow to pause Hosted-Engine deployment before running engine-setup



Reason: This allows to make changes in the bootstrap VM 



Result: Changes can be made on the Hosted-Engine VM during the deployment and before engine-setup


### Deprecated Functionality

#### oVirt Engine Data Warehouse

 - [BZ 1896359](https://bugzilla.redhat.com/1896359) **"Count threads as cores" option is not honored by the RHV Dashboard CPU graph**

   In version 4.4.7.2 we will update the column name to number_of_threads.

In DWH we will leave the old name (threads_per_core) as another alias,

so DWH will have 2 columns with the same data: number_of_threads,threads_per_core.

In the next version we will completely delete the old name.


#### VDSM

 - [BZ 1899875](https://bugzilla.redhat.com/1899875) **drop support for VM-FEX**

   


#### oVirt Engine

 - [BZ 1896359](https://bugzilla.redhat.com/1896359) **"Count threads as cores" option is not honored by the RHV Dashboard CPU graph**

   In version 4.4.7.2 we will update the column name to number_of_threads.

In DWH we will leave the old name (threads_per_core) as another alias,

so DWH will have 2 columns with the same data: number_of_threads,threads_per_core.

In the next version we will completely delete the old name.


### Bug Fixes

#### VDSM

 - [BZ 1971182](https://bugzilla.redhat.com/1971182) **[RFE] Use "qemu:allocation-depth" meta context to report holes**

 - [BZ 1952577](https://bugzilla.redhat.com/1952577) **[CBT] Preview to older snapshot breaks vm backup**


#### oVirt Engine

 - [BZ 1952577](https://bugzilla.redhat.com/1952577) **[CBT] Preview to older snapshot breaks vm backup**

 - [BZ 1956106](https://bugzilla.redhat.com/1956106) **VM fails on start with XML error: Invalid PCI address 0000:12:01.0. slot must be &lt;= 0**

 - [BZ 1862035](https://bugzilla.redhat.com/1862035) **[ppc64le] 'sPAPR VSCSI' interface disk attachment is not seen from the guest.**


#### oVirt Release Package

 - [BZ 1958145](https://bugzilla.redhat.com/1958145) **[RHVH 4.4.5] Need to enable rhsmcertd service on the host by default**


#### oVirt Hosted Engine Setup

 - [BZ 1662657](https://bugzilla.redhat.com/1662657) **Restore SHE environment on iscsi fails - KeyError: 'available'**


#### oVirt Ansible collection

 - [BZ 1965456](https://bugzilla.redhat.com/1965456) **cloud-user has NOPASSWD permissions in sudoers file after deployment of Hosted Engine.**


#### ovirt-imageio

 - [BZ 1971182](https://bugzilla.redhat.com/1971182) **[RFE] Use "qemu:allocation-depth" meta context to report holes**


### Other

#### oVirt Engine Data Warehouse

 - [BZ 1976768](https://bugzilla.redhat.com/1976768) **Inquiries regarding missing data in the calendar table created/inserted into the ovirt_engine_history DB.**

   


#### VDSM

 - [BZ 1883399](https://bugzilla.redhat.com/1883399) **During migration, late volume extension request on src is possibly not refreshed on dst, qcow2 corrupt bit set**

   

 - [BZ 1870887](https://bugzilla.redhat.com/1870887) **StorageDomain.dump() missing several keys for volume if one key is missing.**

   

 - [BZ 1973345](https://bugzilla.redhat.com/1973345) **Create template broken with block storage**

   

 - [BZ 1970008](https://bugzilla.redhat.com/1970008) **VDSM service fails if the vdsm log file (/var/log/vdsm/vdsm.log) is not owned by vdsm:kvm**

   

 - [BZ 1949059](https://bugzilla.redhat.com/1949059) **Reducing LUNs from storage domain is failing with error "LVM command executed by lvmpolld failed"**

   

 - [BZ 1946193](https://bugzilla.redhat.com/1946193) **Snapshot creation after blocking connection from host to storage fails**

   

 - [BZ 1961752](https://bugzilla.redhat.com/1961752) **Panic if SPM lease is lost**

   

 - [BZ 1725915](https://bugzilla.redhat.com/1725915) **Vdsm tries to tear down in-use volume of ISO in block storage domain**

   

 - [BZ 1944495](https://bugzilla.redhat.com/1944495) **GET diskattachments for a VM using qemu-guest-agent is missing a logical_name for disks without monted file-system**

   


#### oVirt Engine

 - [BZ 1950593](https://bugzilla.redhat.com/1950593) **Can't properly upload image to Storage Domain without using Test Connection button**

   

 - [BZ 1961945](https://bugzilla.redhat.com/1961945) **RHV should upgrade guest BIOS from i440fx chipset to q35 automatically when the cluster is set with the q35 chipset**

   

 - [BZ 1976742](https://bugzilla.redhat.com/1976742) **Import template from export domain fails with NullPointerException**

   

 - [BZ 1588061](https://bugzilla.redhat.com/1588061) **Suspend VM leaves disks as leftover**

   

 - [BZ 1974181](https://bugzilla.redhat.com/1974181) **Can't create/update instance type via API with display section specified**

   

 - [BZ 1939198](https://bugzilla.redhat.com/1939198) **Refresh LUN operation via Admin Portal fails with "No host was found to perform the operation"**

   

 - [BZ 1970718](https://bugzilla.redhat.com/1970718) **Engine hits NPE when importing template with disks on 2 storage domains**

   

 - [BZ 1969765](https://bugzilla.redhat.com/1969765) **[CBT] Failed to redefine VM checkpoints for full backup that was taken after previous incremental backup**

   

 - [BZ 1947312](https://bugzilla.redhat.com/1947312) **bochs-display: there's no video object in REST API and REST default video type for UEFI server is incorrect.**

   

 - [BZ 1887434](https://bugzilla.redhat.com/1887434) **LVM IDs and Machine ID are same for all new VMs created from sealed template**

   

 - [BZ 1779983](https://bugzilla.redhat.com/1779983) **After memory hot plug, Why the VM is showing icon for "server with the newer configuration for next run"?**

   

 - [BZ 1946876](https://bugzilla.redhat.com/1946876) **automatic Maximum Memory exceeds possible maximum on new VM dialog**

   

 - [BZ 1941581](https://bugzilla.redhat.com/1941581) **[RFE] Add to API external template import**

   

 - [BZ 1961396](https://bugzilla.redhat.com/1961396) **[CodeChange][i18n] oVirt 4.4.7 webadmin - translation update**

   

 - [BZ 1960968](https://bugzilla.redhat.com/1960968) **Disable checking of SSH connection when adding a host into the ansible-runner-service inventory**

   

 - [BZ 1951894](https://bugzilla.redhat.com/1951894) **Add validation when creating storage domain with disperse volume type**

   

 - [BZ 1962177](https://bugzilla.redhat.com/1962177) **Disk search API returns zero result if max parameter is specified**

   

 - [BZ 1930298](https://bugzilla.redhat.com/1930298) **'NUMA Node Count' number is not set if at the same editing the user sets vcpu pinning.**

   

 - [BZ 1954404](https://bugzilla.redhat.com/1954404) **[RFE][cinderlib] Add option to copy Managed block storage disks via the UI**

   

 - [BZ 1954878](https://bugzilla.redhat.com/1954878) **[RFE] Auto Pinning Policy: improve tooltip description and policy names**

   

 - [BZ 1963680](https://bugzilla.redhat.com/1963680) **Block the 'Existing' auto-pinning policy**

   

 - [BZ 1957240](https://bugzilla.redhat.com/1957240) **Adding ISO domain deprecation message is misleading**

   

 - [BZ 1940529](https://bugzilla.redhat.com/1940529) **[RFE] Set guaranteed memory of VM according to its defined memory when not specified**

   

 - [BZ 1588100](https://bugzilla.redhat.com/1588100) **AddVmTemplate ends with failure even though its copyImage task succeeded on vdsm**

   

 - [BZ 1932484](https://bugzilla.redhat.com/1932484) **[RFE] Export/import VMs/templates with TPM**

   

 - [BZ 1940766](https://bugzilla.redhat.com/1940766) **No longer possible to select console type since ovirt-web-ui-1.6.8 upgrade (regression)**

   

 - [BZ 1913793](https://bugzilla.redhat.com/1913793) **NPE on host reinstall UI dialog**

   

 - [BZ 1958047](https://bugzilla.redhat.com/1958047) **NullPointerException during VM export to data domain**

   

 - [BZ 1956967](https://bugzilla.redhat.com/1956967) **'Next run config changes' mark appears when nothing was changed on VM**

   

 - [BZ 1929730](https://bugzilla.redhat.com/1929730) **Fails to update vNUMA nodes from number to 0 for running VM (next configuration run).**

   

 - [BZ 1577121](https://bugzilla.redhat.com/1577121) **[ALL_LANG]  The language list format in the drop-down on the welcome page should be consistent**

   

 - [BZ 1954920](https://bugzilla.redhat.com/1954920) **Auto Pinning Policy results in division by zero on hosts with 1 NUMA node.**

   

 - [BZ 1947337](https://bugzilla.redhat.com/1947337) **Select noVNC by default for Kubevirt VMs**

   

 - [BZ 1954447](https://bugzilla.redhat.com/1954447) **[CBT] Unable to create snapshot on a RAW disk after incremental backup**

   


#### oVirt Engine SDK 4 Python

 - [BZ 1956167](https://bugzilla.redhat.com/1956167) **SDK example script "backup_vm.py" fails to complete "full" cycle**

   


#### imgbased

 - [BZ 1964490](https://bugzilla.redhat.com/1964490) **After upgrading the oVirt node to 4.4.6 it's impossible to login through cockpit**

   

 - [BZ 1955415](https://bugzilla.redhat.com/1955415) **RHVH 4.4: There are AVC denied errors in audit.log after upgrade**

   


#### oVirt Web UI

 - [BZ 1577121](https://bugzilla.redhat.com/1577121) **[ALL_LANG]  The language list format in the drop-down on the welcome page should be consistent**

   


#### oVirt Engine UI Extensions

 - [BZ 1860646](https://bugzilla.redhat.com/1860646) **[RFE] Manage vGPU dialog, add option for assigning more than one vGPU instance to VM**

   

 - [BZ 1961331](https://bugzilla.redhat.com/1961331) **[CodeChange][i18n] oVirt 4.4.7 ui-extensions - translation update**

   


### No Doc Update

#### oVirt Engine Data Warehouse

 - [BZ 1962641](https://bugzilla.redhat.com/1962641) **Add "Count threads as cores" to Grafana dashboards**

   

 - [BZ 1937714](https://bugzilla.redhat.com/1937714) **[RFE] Add rx and tx drop to Grafana**

   

 - [BZ 1961598](https://bugzilla.redhat.com/1961598) **race in Termination.java**

   

 - [BZ 1877478](https://bugzilla.redhat.com/1877478) **[RFE] collect network metrics in DWH ( rx and tx drop )**

   


#### VDSM

 - [BZ 1966143](https://bugzilla.redhat.com/1966143) **Requiring nmstate-plugin-ovsdb causes installation of unwanted openvswitch versions**

   


#### oVirt Engine

 - [BZ 1902179](https://bugzilla.redhat.com/1902179) **Ignore message about not using latest kernel after upgrade when a host hasn't been rebooted**

   

 - [BZ 1913785](https://bugzilla.redhat.com/1913785) **Failed to add host with error Format specifier '%2b'**

   

 - [BZ 1975225](https://bugzilla.redhat.com/1975225) **Occasional failures to export VM to OVA**

   

 - [BZ 1968183](https://bugzilla.redhat.com/1968183) **Running an imported VM with TPM which wasn't running while exporting fails**

   

 - [BZ 1817346](https://bugzilla.redhat.com/1817346) **[UI] SHA1 fingerprint shown to the user for approval**

   

 - [BZ 1934201](https://bugzilla.redhat.com/1934201) **ovirt-engine-notifier emails not sent unless MAIL_FROM is set**

   

 - [BZ 1964541](https://bugzilla.redhat.com/1964541) **[RFE] New network dialogue is missing IDs on all elements**

   

 - [BZ 1877478](https://bugzilla.redhat.com/1877478) **[RFE] collect network metrics in DWH ( rx and tx drop )**

   

 - [BZ 1942023](https://bugzilla.redhat.com/1942023) **[RFE] host-deploy: Allow adding non-CentOS hosts based on RHEL**

   

 - [BZ 1959839](https://bugzilla.redhat.com/1959839) **Support renewing separate machine PKI**

   

 - [BZ 1913789](https://bugzilla.redhat.com/1913789) **[RFE] Add RHEL 9 as a guest operating systems**

   

 - [BZ 1917707](https://bugzilla.redhat.com/1917707) **when upgrading host, tasks appear in the audit log multiple times**

   

 - [BZ 1951579](https://bugzilla.redhat.com/1951579) **RHV api issues when account has only "UserRole" permissions**

   


#### oVirt Engine SDK 4 Python

 - [BZ 1956750](https://bugzilla.redhat.com/1956750) **Python oVirt SDK overwrites /dev/null with cookie file**

   


#### oVirt Release Package

 - [BZ 1947759](https://bugzilla.redhat.com/1947759) **allow optional vdsm-hooks intallation on oVirt Node**

   


#### oVirt Hosted Engine Setup

 - [BZ 1922748](https://bugzilla.redhat.com/1922748) **[RFE] Use Ansible module instead of REST API**

   


#### oVirt Ansible collection

 - [BZ 1973640](https://bugzilla.redhat.com/1973640) **Hosted engine deploy fail in version 1.5.1 - VM is not managed by the engine**

   

 - [BZ 1953029](https://bugzilla.redhat.com/1953029) **HE deployment fails on "Add lines to answerfile"**

   

 - [BZ 1922748](https://bugzilla.redhat.com/1922748) **[RFE] Use Ansible module instead of REST API**

   


#### Contributors

45 people contributed to this release:

	Alan Rominger (Contributed to: ovirt-ansible-collection)
	Ales Musil (Contributed to: ovirt-engine, vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, ovirt-engine-wildfly)
	Asaf Rachmani (Contributed to: ovirt-ansible-collection, ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine)
	Aviv Turgeman (Contributed to: ovirt-ansible-collection)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Ben Amsalem (Contributed to: ovirt-web-ui)
	Benny Zlotnik (Contributed to: ovirt-engine, ovirt-release)
	Dan Kenigsberg (Contributed to: vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Dmitry Voronetskiy (Contributed to: ovirt-dwh)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, ovirt-engine-sdk, vdsm)
	Guilherme De Oliveira Santos (Contributed to: ovirt-ansible-collection)
	Hilda Stastna (Contributed to: ovirt-web-ui)
	Ilan Zuckerman (Contributed to: ovirt-imageio)
	Lev Veyde (Contributed to: imgbased, ovirt-engine, ovirt-node-ng-image, ovirt-release, vdsm)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine, ovirt-engine-ui-extensions)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-engine, ovirt-engine-extension-aaa-ldap, ovirt-engine-sdk)
	Matt Martz (Contributed to: ovirt-ansible-collection)
	Michal Skrivanek (Contributed to: ovirt-engine, vdsm)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: ovirt-engine, ovirt-imageio, vdsm)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Paul Belanger (Contributed to: ovirt-ansible-collection)
	Pavel Bar (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-web-ui)
	Ritesh Chikatwar (Contributed to: ovirt-engine)
	Roman Bednar (Contributed to: vdsm)
	Saif Abusaleh (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: ovirt-appliance, ovirt-engine, ovirt-host, ovirt-node-ng-image, ovirt-release, vdsm)
	Scott J Dickerson (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shani Leviim (Contributed to: ovirt-engine)
	Sharon Gratch (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-imageio, vdsm)
	Yalei Li (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-ansible-collection, ovirt-dwh, ovirt-engine, ovirt-hosted-engine-setup)

---
title: oVirt 4.5.0 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.5.0 release planning

The oVirt 4.5.0 code freeze is planned for March 31, 2022.

If no critical issues are discovered while testing this compose it will be released on April 12, 2022.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.5.0](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.5.0%22%20-target_milestone%3A%22ovirt-4.5.0-%22)


# [DRAFT] oVirt 4.5.0 Release Notes

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for CentOS Stream.

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

The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.5.0, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## ALPHA DEVELOPMENT

In order to install this Alplha develoment you will need to [enable nightly snapshot repository](https://ovirt.org/develop/dev-process/install-nightly-snapshot.html).


## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.5.0 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.5.0 (redeploy in case of already being on 4.5.0).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.5.0?

### Release Note

#### VDSM

 - [BZ 2021545](https://bugzilla.redhat.com/show_bug.cgi?id=2021545) **[RFE] Add cluster-level 4.7**

   In this release we have added DataCenter/Cluster compatibility level 4.7, which is available only on hosts with RHEL 8.6+, latest CentOS Stream 8 and CentOS Stream/RHEL 9 with libvirt &gt;= 8.0.0 installed.

 - [BZ 2015093](https://bugzilla.redhat.com/show_bug.cgi?id=2015093) **[RFE] Implement hypervirors core dump related configuration to work on EL8 and EL9**

   oVirt 4.5 has moved from abrt to systemd-coredump to gather crash dumps on the hypervisors

 - [BZ 2010205](https://bugzilla.redhat.com/show_bug.cgi?id=2010205) **vm_kill_paused_time value should be determined from io_timeout**

   Vdsm configuration option vars.vm_kill_paused_time was removed. The corresponding value is directly dependent on the value of recently introduced sanlock.io_timeout option and needn't be configured separately.

 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in RHV to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.



The upgrade is transparent to user as long as few conditions are met:



1) The engine must be upgraded first.

2) Before any host upgrade the ovirt-provider-ovn security groups must be disabled for all OVN networks that are expected to work between host with OVN/OvS version 2.11.

3) Upgrade hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done via the UI, in order to reconfigure OVN and refresh certificates.





To check if provider and OVN was configured successfully on the host, webadmin includes OVN configured flag in General tab for every host, at the same time this value is available via REST API. 



Fixing the host's OVN not being confiugred can be done by reinstalling it from engine 4.5 or higher.


#### oVirt Engine

 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in RHV to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.



The upgrade is transparent to user as long as few conditions are met:



1) The engine must be upgraded first.

2) Before any host upgrade the ovirt-provider-ovn security groups must be disabled for all OVN networks that are expected to work between host with OVN/OvS version 2.11.

3) Upgrade hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done via the UI, in order to reconfigure OVN and refresh certificates.





To check if provider and OVN was configured successfully on the host, webadmin includes OVN configured flag in General tab for every host, at the same time this value is available via REST API. 



Fixing the host's OVN not being confiugred can be done by reinstalling it from engine 4.5 or higher.

 - [BZ 1782056](https://bugzilla.redhat.com/show_bug.cgi?id=1782056) **[RFE] Integration of built-in ipsec feature in RHV/RHHI-V with OVN**

   The IPSec for OVN feature is available on hosts with configured ovirt-provider-ovn, OVN version 2021 or higher and OvS version 2.15 or higher.


#### oVirt Open vSwitch

 - [BZ 1782056](https://bugzilla.redhat.com/show_bug.cgi?id=1782056) **[RFE] Integration of built-in ipsec feature in RHV/RHHI-V with OVN**

   The IPSec for OVN feature is available on hosts with configured ovirt-provider-ovn, OVN version 2021 or higher and OvS version 2.15 or higher.

 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in RHV to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.



The upgrade is transparent to user as long as few conditions are met:



1) The engine must be upgraded first.

2) Before any host upgrade the ovirt-provider-ovn security groups must be disabled for all OVN networks that are expected to work between host with OVN/OvS version 2.11.

3) Upgrade hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done via the UI, in order to reconfigure OVN and refresh certificates.





To check if provider and OVN was configured successfully on the host, webadmin includes OVN configured flag in General tab for every host, at the same time this value is available via REST API. 



Fixing the host's OVN not being confiugred can be done by reinstalling it from engine 4.5 or higher.


#### oVirt Provider OVN

 - [BZ 1782056](https://bugzilla.redhat.com/show_bug.cgi?id=1782056) **[RFE] Integration of built-in ipsec feature in RHV/RHHI-V with OVN**

   The IPSec for OVN feature is available on hosts with configured ovirt-provider-ovn, OVN version 2021 or higher and OvS version 2.15 or higher.

 - [BZ 1940824](https://bugzilla.redhat.com/show_bug.cgi?id=1940824) **[RFE] Upgrade OVN/OVS 2.11 in RHV to OVN/OVS 2.15**

   Upgrade from OvS/OVN 2.11 to OVN 2021 and OvS 2.15.



The upgrade is transparent to user as long as few conditions are met:



1) The engine must be upgraded first.

2) Before any host upgrade the ovirt-provider-ovn security groups must be disabled for all OVN networks that are expected to work between host with OVN/OvS version 2.11.

3) Upgrade hosts to match the OVN version 2021 or higher and OvS version to 2.15. This step should be done via the UI, in order to reconfigure OVN and refresh certificates.





To check if provider and OVN was configured successfully on the host, webadmin includes OVN configured flag in General tab for every host, at the same time this value is available via REST API. 



Fixing the host's OVN not being confiugred can be done by reinstalling it from engine 4.5 or higher.


### Enhancements

#### VDSM

 - [BZ 2012830](https://bugzilla.redhat.com/show_bug.cgi?id=2012830) **[RFE] Use lvmdevices instead of lvm filter on RHEL 8.6/Centos Steam 9**

   Feature: Use LVM devices instead lvm filter to manage storage devices.



Reason: LVM filter is hard to manage and also in some case hard to set up in a correct way. LVM devices provides more easy way how to manage devices. Morover, starting CentOS Stream 9/RHEL 9, this will be the default used by LVM.



Result:

With this feature, vdsm use LVM devices file for managing storage devices and LVM filter is not needed any more.

 - [BZ 1975720](https://bugzilla.redhat.com/show_bug.cgi?id=1975720) **[RFE] Huge VMs require an additional migration parameter**

   Support for parallel migration connections was added.



See https://www.ovirt.org/develop/release-management/features/virt/parallel-migration-connections.html for all the important information about the feature.

 - [BZ 1944834](https://bugzilla.redhat.com/show_bug.cgi?id=1944834) **[RFE] Timer for Console Disconnect Action - Shutdown VM after N minutes of being disconnected (Webadmin-only)**

   The feature adds a user-specified delay to the 'Shutdown' Console Disconnect Action of a VM. The shutdown won't be immediate anymore, but will occur after the delay, unless the user reconnects to the VM console, when it will be canceled.

This prevents a user's session loss after an accidental disconnect.

 - [BZ 1964208](https://bugzilla.redhat.com/show_bug.cgi?id=1964208) **[RFE] add new feature for VM's screenshot on RestAPI**

   Feature: Introduce capture VM screenshot API call



Add screenshot API that captures the current screen of a VM, and then returns PPM file screenshot



the user can then download the screenshot and view it content

 - [BZ 1616436](https://bugzilla.redhat.com/show_bug.cgi?id=1616436) **[RFE] Sparsify uploads**

   Feature: Detect zero areas in uploaded images and use optimized zero write method to write the zeroes to the underlying storage.



Reason: Not all clients support sparse files when uploading images, resulting in fully allocated images even when the disk is using thin allocation policy.



Result:

Images uploaded to disks with thin allocation policy remain sparse, minimizing the storage allocation. Uploading

images containing large zeroed areas is usually faster now.


#### oVirt Hosted Engine Setup

 - [BZ 2029830](https://bugzilla.redhat.com/show_bug.cgi?id=2029830) **[RFE] Hosted engine should accept OpenSCAP profile name instead of bool**

   Hosted Engine installation now supports selecting either DISA STIG or PCI-DSS security profiles for the Hosted Engine VM


#### oVirt Engine

 - [BZ 2003862](https://bugzilla.redhat.com/show_bug.cgi?id=2003862) **Missing default hv_stimer_direct, hv_ipi, hv_evmcs flags**

   hv_stimer_direct and hv_ipi Hyper-V flags are newly added to VMs when the cluster level is higher than 4.6.

 - [BZ 1944834](https://bugzilla.redhat.com/show_bug.cgi?id=1944834) **[RFE] Timer for Console Disconnect Action - Shutdown VM after N minutes of being disconnected (Webadmin-only)**

   The feature adds a user-specified delay to the 'Shutdown' Console Disconnect Action of a VM. The shutdown won't be immediate anymore, but will occur after the delay, unless the user reconnects to the VM console, when it will be canceled.

This prevents a user's session loss after an accidental disconnect.

 - [BZ 1973251](https://bugzilla.redhat.com/show_bug.cgi?id=1973251) **[RFE] Making the number of virtio-scsi multi-queue configurable**

   Feature: Make the number of virtio-scsi multi-queue configurable



The virtio-scsi multi-queue scsi is currently boolean - either disabled or enabled, and when it's enabled the number of queues is determined automatically.



This RFE enables the user to specify the desired number of multi-queues

 - [BZ 1927985](https://bugzilla.redhat.com/show_bug.cgi?id=1927985) **[RFE] Speed up export-to-OVA on NFS by aligning loopback device offset**

   Padding between files is now added when exporting a VM to OVA. The goal is to align disks in the OVA to the edge of a block of the underlying filesystem. In this case disks are written faster during the export, especially to an NFS partition.

 - [BZ 1616436](https://bugzilla.redhat.com/show_bug.cgi?id=1616436) **[RFE] Sparsify uploads**

   Feature: Detect zero areas in uploaded images and use optimized zero write method to write the zeroes to the underlying storage.



Reason: Not all clients support sparse files when uploading images, resulting in fully allocated images even when the disk is using thin allocation policy.



Result:

Images uploaded to disks with thin allocation policy remain sparse, minimizing the storage allocation. Uploading
images containing large zeroed areas is usually faster now.

 - [BZ 1979797](https://bugzilla.redhat.com/show_bug.cgi?id=1979797) **Ask user for confirmation when the deleted storage domain has leases of VMs that has disk in other SDs**

   Adds a new warning message in the removing storage domain window in case that the selected domain has leases for entities that raised on a different storage domain.

 - [BZ 1838089](https://bugzilla.redhat.com/show_bug.cgi?id=1838089) **[RFE] Please allow placing domain in maintenance mode with suspended VM**

   Storage domain can now be deactivated and set to maintenance even if there are suspended VMs.



Note, a suspended VM will be able to run only when all the storage domains disks (including memory disks) are active.

 - [BZ 655153](https://bugzilla.redhat.com/show_bug.cgi?id=655153) **[RFE] confirmation prompt when suspending a virtual machine - webadmin**

   Previously, no confirmation dialog was shown for the suspend VM operation. A virtual machine was suspending right after clicking the suspend-VM button.



Now, a confirmation dialog is presented by default when pressing the suspend-VM button. The user can choose not to show this confirmation dialog again. That setting can be reverted in the user preferences dialog.


### Removed functionality

#### oVirt Engine

 - [BZ 1950730](https://bugzilla.redhat.com/show_bug.cgi?id=1950730) **Remove old Cinder integration from the REST-API**

   This patch removes the ability to create/use old cinder integration using the REST API.


### Bug Fixes

#### VDSM

 - [BZ 2010478](https://bugzilla.redhat.com/show_bug.cgi?id=2010478) **After storage error HA VMs failed to auto resume.**

 - [BZ 1787192](https://bugzilla.redhat.com/show_bug.cgi?id=1787192) **Host fails to activate in RHV and goes to non-operational status when some of the iSCSI targets are down**

 - [BZ 1926589](https://bugzilla.redhat.com/show_bug.cgi?id=1926589) **"Too many open files" in vdsm.log after 380 migrations**


#### oVirt Hosted Engine Setup

 - [BZ 2026770](https://bugzilla.redhat.com/show_bug.cgi?id=2026770) **host deployment fails on fips-enabled host**

 - [BZ 1768969](https://bugzilla.redhat.com/show_bug.cgi?id=1768969) **Duplicate iSCSI sessions in the hosted-engine deployment host when the tpgt is not 1**


#### oVirt Engine

 - [BZ 1956107](https://bugzilla.redhat.com/show_bug.cgi?id=1956107) **Reject RHEL &lt; 6.9 on PPC**

 - [BZ 1687845](https://bugzilla.redhat.com/show_bug.cgi?id=1687845) **Multiple notification for one time host activation**

 - [BZ 1986726](https://bugzilla.redhat.com/show_bug.cgi?id=1986726) **VM imported from OVA gets thin provisioned disk despite of allocation policy set as 'preallocated'**

 - [BZ 2003996](https://bugzilla.redhat.com/show_bug.cgi?id=2003996) **ovirt_snapshot module fails to delete snapshot when there is a "Next Run configuration snapshot"**

 - [BZ 1959186](https://bugzilla.redhat.com/show_bug.cgi?id=1959186) **Enable assignment of user quota when provisioning from a non-blank template via rest-api**

 - [BZ 1971622](https://bugzilla.redhat.com/show_bug.cgi?id=1971622) **Incorrect warning displayed: "The VM CPU does not match the Cluster CPU Type"**

 - [BZ 1979441](https://bugzilla.redhat.com/show_bug.cgi?id=1979441) **High Performance VMs always have "VM CPU does not match the cluster CPU Type" warning**

 - [BZ 1959141](https://bugzilla.redhat.com/show_bug.cgi?id=1959141) **Export to data domain of a VM that isn't running creates a snapshot that isn't removed**

 - [BZ 1988496](https://bugzilla.redhat.com/show_bug.cgi?id=1988496) **vmconsole-proxy-helper.cer is not renewed when running engine-setup**


#### oVirt Setup Lib

 - [BZ 1971863](https://bugzilla.redhat.com/show_bug.cgi?id=1971863) **Queries of type 'ANY' are deprecated - RFC8482**


### Other

#### VDSM

 - [BZ 2033697](https://bugzilla.redhat.com/show_bug.cgi?id=2033697) **Secret information may be leaked in Vdsm logs**

 - [BZ 1536880](https://bugzilla.redhat.com/show_bug.cgi?id=1536880) **Include text from lvm command stdout and stderr in all lvm related exceptions**

 - [BZ 2026263](https://bugzilla.redhat.com/show_bug.cgi?id=2026263) **getStats should report if the data is real or initial**

 - [BZ 1919857](https://bugzilla.redhat.com/show_bug.cgi?id=1919857) **Consume disk logical names from Libvirt (RHEL 8.5)**

 - [BZ 2025527](https://bugzilla.redhat.com/show_bug.cgi?id=2025527) **Refreshing LVs fail:  "locking_type (4) is deprecated, using --sysinit --readonly.\', \'  Operation prohibited while --readonly is set.\', "  Can\'t get lock for ...."**

 - [BZ 1949475](https://bugzilla.redhat.com/show_bug.cgi?id=1949475) **If pivot failed during live merge, top volume is left illegal, requires manual fix if vm is stopped**

 - [BZ 2018947](https://bugzilla.redhat.com/show_bug.cgi?id=2018947) **vm: do not ignore errors when syncing volume chain**


#### oVirt Hosted Engine Setup

 - [BZ 1616158](https://bugzilla.redhat.com/show_bug.cgi?id=1616158) **Check that DHCP assigned IP of the hosted-engine belongs to the same subnet, that ha-hosts belongs to.**

 - [BZ 2012742](https://bugzilla.redhat.com/show_bug.cgi?id=2012742) **Host name is not valid: FQDNofyourhost resolves to IPV6 IPV4 and not all of them can be mapped to non loopback devices on this host**


#### oVirt Engine

 - [BZ 1979041](https://bugzilla.redhat.com/show_bug.cgi?id=1979041) **[RFE] Apply automatic CPU and NUMA pinning based on the scheduled host**

 - [BZ 1952502](https://bugzilla.redhat.com/show_bug.cgi?id=1952502) **Inconsistent validation of pool creation by Rest API**

 - [BZ 1887174](https://bugzilla.redhat.com/show_bug.cgi?id=1887174) **Host deactivation failure after "Migration not in progress, code = 47" error**

 - [BZ 1952321](https://bugzilla.redhat.com/show_bug.cgi?id=1952321) **There is failed cloning message when cloning VM with shareable direct lun attached**

 - [BZ 2019869](https://bugzilla.redhat.com/show_bug.cgi?id=2019869) **Local disk is not bootable when the VM is imported from OVA**

 - [BZ 1940494](https://bugzilla.redhat.com/show_bug.cgi?id=1940494) **provide better information for windows guest-agent mark**

 - [BZ 1950321](https://bugzilla.redhat.com/show_bug.cgi?id=1950321) **SSH public key Ok button is not enabled automatically**

 - [BZ 1679935](https://bugzilla.redhat.com/show_bug.cgi?id=1679935) **Administration Configure user role does not shows scrollbar**

 - [BZ 1913843](https://bugzilla.redhat.com/show_bug.cgi?id=1913843) **Disable NUMA Tuning for non-pinned vNUMA nodes**

 - [BZ 1683098](https://bugzilla.redhat.com/show_bug.cgi?id=1683098) **ovirt-provider-ovn service is not stopped/disabled by engine-cleanup**

 - [BZ 2001565](https://bugzilla.redhat.com/show_bug.cgi?id=2001565) **VM OVA import fails if loop device doesn't exist in the host during the import**

 - [BZ 1991804](https://bugzilla.redhat.com/show_bug.cgi?id=1991804) **Engine using old 2400 maximum score on HA scheduling weight policy**

 - [BZ 1847514](https://bugzilla.redhat.com/show_bug.cgi?id=1847514) **Can't create a VM with memory higher than the max-allowed (hard validation)**

 - [BZ 1956295](https://bugzilla.redhat.com/show_bug.cgi?id=1956295) **Template import from storage domain fails when quota is enabled.**

 - [BZ 1868249](https://bugzilla.redhat.com/show_bug.cgi?id=1868249) **The OVF disk size on file storage reported by engine does not match the actual size of the OVF**

 - [BZ 1959385](https://bugzilla.redhat.com/show_bug.cgi?id=1959385) **[Cinderlib] Not possible to set MBS domain on maintenance even though all its disks have been deleted.**


#### oVirt Provider OVN

 - [BZ 2012850](https://bugzilla.redhat.com/show_bug.cgi?id=2012850) **Cannot add router port with IPv6**


#### oVirt Setup Lib

 - [BZ 1616158](https://bugzilla.redhat.com/show_bug.cgi?id=1616158) **Check that DHCP assigned IP of the hosted-engine belongs to the same subnet, that ha-hosts belongs to.**

 - [BZ 2012742](https://bugzilla.redhat.com/show_bug.cgi?id=2012742) **Host name is not valid: FQDNofyourhost resolves to IPV6 IPV4 and not all of them can be mapped to non loopback devices on this host**


### No Doc Update

#### VDSM

 - [BZ 2004412](https://bugzilla.redhat.com/show_bug.cgi?id=2004412) **Minimize skipped checks in vdsm flake8 configuration**


 - [BZ 2026370](https://bugzilla.redhat.com/show_bug.cgi?id=2026370) **oVirt node fail to boot if lvm filter uses /dev/disk/by-id/lvm-pv-uuid-***


 - [BZ 2005213](https://bugzilla.redhat.com/show_bug.cgi?id=2005213) **c9s - setupNetworks fails**



#### oVirt Engine SDK 4 Python

 - [BZ 1900597](https://bugzilla.redhat.com/show_bug.cgi?id=1900597) **[RFE] Add 'include_template' flag to disk snapshots listing**


#### oVirt Engine

 - [BZ 1900597](https://bugzilla.redhat.com/show_bug.cgi?id=1900597) **[RFE] Add 'include_template' flag to disk snapshots listing**

 - [BZ 2006602](https://bugzilla.redhat.com/show_bug.cgi?id=2006602) **vm_statistics table has wrong type for guest_mem_* columns.**

 - [BZ 2008798](https://bugzilla.redhat.com/show_bug.cgi?id=2008798) **Older name rhv-openvswitch is not checked in ansible playbook**

 - [BZ 1986731](https://bugzilla.redhat.com/show_bug.cgi?id=1986731) **ovirt-engine uses deprecated API platform.linux_distribution which has been removed in Python 3.7 and later.**

 - [BZ 1907798](https://bugzilla.redhat.com/show_bug.cgi?id=1907798) **migrate org.codehaus.jackson to newer com.fasterxml.jackson**

 - [BZ 1996123](https://bugzilla.redhat.com/show_bug.cgi?id=1996123) **ovf stores capacity/truesize on the storage does not match values in engine database**



#### oVirt Log Collector

 - [BZ 2000121](https://bugzilla.redhat.com/show_bug.cgi?id=2000121) **docs/comments/etc misguide about postgresql credentials defaults**

 - [BZ 1986728](https://bugzilla.redhat.com/show_bug.cgi?id=1986728) **ovirt-log-collector uses deprecated API platform.linux_distribution which has been removed in Python 3.7 and later.**



#### Contributors

39 people contributed to this release:

	Ales Musil (Contributed to: ovirt-engine, ovirt-openvswitch, ovirt-provider-ovn, vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: ovirt-hosted-engine-setup, ovirt-setup-lib)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Dominik Holler (Contributed to: ovirt-openvswitch)
	Dusan Fodor (Contributed to: ovirt-openvswitch)
	Eitan Raviv (Contributed to: ovirt-provider-ovn)
	Eli Mesika (Contributed to: ovirt-engine)
	Evgheni Dereveanchin (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Filip Januska (Contributed to: ovirt-engine, python-ovirt-engine-sdk4, vdsm)
	Harel Braha (Contributed to: vdsm)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-log-collector, vdsm)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Mark Kemel (Contributed to: ovirt-engine, python-ovirt-engine-sdk4)
	Martin Nečas (Contributed to: python-ovirt-engine-sdk4)
	Martin Perina (Contributed to: ovirt-engine, python-ovirt-engine-sdk4, vdsm)
	Michal Skrivanek (Contributed to: ovirt-hosted-engine-setup)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nijin Ashok (Contributed to: ovirt-log-collector)
	Nir Soffer (Contributed to: ovirt-engine, python-ovirt-engine-sdk4, vdsm)
	Ori Liel (Contributed to: ovirt-engine)
	Pavel Bar (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Ravi (Contributed to: vdsm)
	Roman Bednar (Contributed to: vdsm)
	Saif Abu Saleh (Contributed to: ovirt-engine, vdsm)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-hosted-engine-setup, ovirt-log-collector, ovirt-provider-ovn, ovirt-setup-lib, python-ovirt-engine-sdk4, vdsm)
	Scott J Dickerson (Contributed to: ovirt-engine)
	Shani Leviim (Contributed to: ovirt-engine)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtěch Juránek (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-engine, ovirt-hosted-engine-setup, ovirt-setup-lib)

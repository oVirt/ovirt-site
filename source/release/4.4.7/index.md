---
title: oVirt 4.4.7 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.7 release planning

The oVirt 4.4.7 code freeze is planned for June 13, 2021.

If no critical issues are discovered while testing this compose it will be released on June 22, 2021.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.4.7](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.4.7%22%20-target_milestone%3A%22ovirt-4.4.7-%22)


# oVirt 4.4.7 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.7 First Release Candidate as of May 27, 2021.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.3 and
CentOS Linux 8.3 (or similar) and CentOS Stream.

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

To learn about features introduced before 4.4.7, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)


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


#### oVirt Engine

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


#### oVirt Engine

 - [BZ 1958081](https://bugzilla.redhat.com/1958081) **[RFE] Enable ramfb for mdev with display=on**

   When a vGPU is used and nodisplay is not specified, an additional framebuffer display device is added to the VM now, allowing to display the VM console before the vGPU is initialized. This allows display console access during boot, instead of having just a blank screen there as before this change.



This works only on cluster levels &gt;= 4.5. It is possible to disable the feature by setting VgpuFramebufferSupported Engine config value to false.

 - [BZ 1913789](https://bugzilla.redhat.com/1913789) **[RFE] Support RHEL 9 guests**

   


### Bug Fixes

#### oVirt Engine

 - [BZ 1862035](https://bugzilla.redhat.com/1862035) **[ppc64le] 'sPAPR VSCSI' interface disk attachment is not seen from the guest.**

 - [BZ 1932392](https://bugzilla.redhat.com/1932392) **engine-setup fails after 'engine-backup --mode=restore' if the backup was taken on a newer version**


### Other

#### oVirt Engine Data Warehouse

 - [BZ 1896359](https://bugzilla.redhat.com/1896359) **"Count threads as cores" option is not honored by the RHV Dashboard CPU graph**

   


#### VDSM

 - [BZ 1944495](https://bugzilla.redhat.com/1944495) **GET diskattachments for a VM using qemu-guest-agent is missing a logical_name for disks without monted file-system**

   


#### oVirt Engine

 - [BZ 1963680](https://bugzilla.redhat.com/1963680) **Block the 'Existing' auto-pinning policy**

   

 - [BZ 1953468](https://bugzilla.redhat.com/1953468) **[CBT][RFE] Allow removing non-root checkpoints from the VM**

   

 - [BZ 1961396](https://bugzilla.redhat.com/1961396) **[CodeChange][i18n] oVirt 4.4.7 webadmin - translation update**

   

 - [BZ 1877478](https://bugzilla.redhat.com/1877478) **[RFE] collect network metrics in DWH ( rx and tx drop )**

   

 - [BZ 1940529](https://bugzilla.redhat.com/1940529) **[RFE] Set guaranteed memory of VM according to its defined memory when not specified**

   

 - [BZ 1588100](https://bugzilla.redhat.com/1588100) **AddVmTemplate ends with failure even though its copyImage task succeeded on vdsm**

   

 - [BZ 1932484](https://bugzilla.redhat.com/1932484) **[RFE] Export/import VMs/templates with TPM**

   

 - [BZ 1913793](https://bugzilla.redhat.com/1913793) **NPE on host reinstall UI dialog**

   

 - [BZ 1958047](https://bugzilla.redhat.com/1958047) **NullPointerException during VM export to data domain**

   

 - [BZ 1956967](https://bugzilla.redhat.com/1956967) **'Next run config changes' mark appears when nothing was changed on VM**

   

 - [BZ 1929730](https://bugzilla.redhat.com/1929730) **Fails to update vNUMA nodes from number to 0 for running VM (next configuration run).**

   

 - [BZ 1577121](https://bugzilla.redhat.com/1577121) **[ALL_LANG]  The language list format in the drop-down on the welcome page should be consistent**

   

 - [BZ 1942021](https://bugzilla.redhat.com/1942021) **[RFE] Add AlmaLinux to the list of guest operating systems**

   

 - [BZ 1896359](https://bugzilla.redhat.com/1896359) **"Count threads as cores" option is not honored by the RHV Dashboard CPU graph**

   

 - [BZ 1954920](https://bugzilla.redhat.com/1954920) **Auto Pinning Policy results in division by zero on hosts with 1 NUMA node.**

   

 - [BZ 1947337](https://bugzilla.redhat.com/1947337) **Select noVNC by default for Kubevirt VMs**

   

 - [BZ 1954447](https://bugzilla.redhat.com/1954447) **[CBT] Unable to create snapshot on a RAW disk after incremental backup**

   


#### oVirt Release Package

 - [BZ 1947759](https://bugzilla.redhat.com/1947759) **allow optional vdsm-hooks intallation on oVirt Node**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1942023](https://bugzilla.redhat.com/1942023) **[RFE] host-deploy: Allow adding non-CentOS hosts based on RHEL**

   

 - [BZ 1959839](https://bugzilla.redhat.com/1959839) **Support renewing separate machine PKI**

   

 - [BZ 1917707](https://bugzilla.redhat.com/1917707) **when upgrading host, tasks appear in the audit log multiple times**

   

 - [BZ 1951579](https://bugzilla.redhat.com/1951579) **RHV api issues when account has only "UserRole" permissions**

   


#### Contributors

29 people contributed to this release:

	Ales Musil (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, ovirt-engine-wildfly)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, ovirt-release)
	Dan Kenigsberg (Contributed to: vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine)
	Lev Veyde (Contributed to: imgbased, ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Perina (Contributed to: ovirt-engine, ovirt-engine-extension-aaa-ldap)
	Michal Skrivanek (Contributed to: ovirt-engine, vdsm)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: vdsm)
	Ori Liel (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Roman Bednar (Contributed to: vdsm)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-host, ovirt-release, vdsm)
	Scott J Dickerson (Contributed to: ovirt-engine)
	Shani Leviim (Contributed to: ovirt-engine)
	Sharon Gratch (Contributed to: ovirt-engine)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: vdsm)
	Yalei Li (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine)

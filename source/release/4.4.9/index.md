---
title: oVirt 4.4.9 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.9 release planning

The oVirt 4.4.9 code freeze is planned for October 12, 2021.

If no critical issues are discovered while testing this compose it will be released on October 19, 2021.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.4.9](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.4.9%22%20-target_milestone%3A%22ovirt-4.4.9-%22)


# oVirt 4.4.9 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.9 Third Release Candidate as of October 15, 2021.

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

The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.4.9, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)


## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.9 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.9 (redeploy in case of already being on 4.4.9).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.9?

### Release Note

#### oVirt Engine Data Warehouse

 - [BZ 2007550](https://bugzilla.redhat.com/show_bug.cgi?id=2007550) **Change type of disk write/read rate from integer to long**

   Change the type of the virtual machines disk write/read rate from integer to long.

 - [BZ 1992690](https://bugzilla.redhat.com/show_bug.cgi?id=1992690) **[RFE] Customize 'oVirt Inventory Dashboard' to include cluster wide information about 'CPUs Overcommit' and 'Running VMs - CPU Cores vs. Total Hosts-CPU Cores'**

   The Inventory dashboard showed until now overcommits rates for each data center, now overcommits rates for each cluster is available too.


#### VDSM

 - [BZ 2004469](https://bugzilla.redhat.com/show_bug.cgi?id=2004469) **[RHV 4.4.8] Unable to upgrade RHVH if vdsm-hook-ethtool-options is installed**

   When custom VDSM hooks are installed on RHVH, it was not possible to upgrade RHVH to 4.4.8. We have need to remove VDSM hooks dependency on the concrete version of VDSM, so customers now need to maintain that dependency by themselves (meaning if customers upgrade VDSM from X.Y.Z to version A.B.C, they need also upgrade all VDSM hooks to the same version A.B.C


#### oVirt Engine

 - [BZ 2004444](https://bugzilla.redhat.com/show_bug.cgi?id=2004444) **Try to enable cinderlib repos on host during host upgrade**

   During host installation or host upgrade engine is checking if cinderlib and ceph packages are available and if not, it tries to enable required channels specified in the documentation. If there is a problem during channel enablement, then error is raised into audit_log and customers need to enable channel manually and afterwards retry installation/upgrade


#### ovirt-engine-extension-aaa-ldap

 - [BZ 2010658](https://bugzilla.redhat.com/show_bug.cgi?id=2010658) **AAA LDAP extension is querying DNS with ANY request**

   ovirt-engine-extension-aaa-ldap has been using single request to fetch both A and AAAA records from DNS servers in mixed IPv4/IPv6 setups. Underlying JVM transformed this request to ANY DNS call, which has been recently deprecated by RFC 8482 and that why we haven't got valid addresses from some DNS servers.

From version 1.4.5 ovirt-engine-extension-aaa-ldap is going to fetch A and AAAA records in separate DNS requests.


### Enhancements

#### oVirt Engine Data Warehouse

 - [BZ 1999563](https://bugzilla.redhat.com/show_bug.cgi?id=1999563) **[RFE] Add a unique number to each panel in Grafana**

   Feature: 

There are panels that have the same panel number, and panels with no panel number at all. 



Reason: 

The goal is to help the user and us identify and differentiate between panels and dashboards in a much easier way.



Result:

We would like to delete all the existing numbers, and add a unique number to each panel in Grafana.


#### oVirt Host Dependencies

 - [BZ 1984886](https://bugzilla.redhat.com/show_bug.cgi?id=1984886) **Include rsyslog-openssl package on hosts**

   Feature: rsyslog-openssl package is now installed by default on the hosts and included in oVirt Node (community) and RHV-H (product)



Reason: rsyslog-openssl allow to setup remote logging using an encrypted channel.



Result: No need to manually install a package to setup remote encrypted logging.


### Bug Fixes

#### oVirt Engine Metrics

 - [BZ 1978655](https://bugzilla.redhat.com/show_bug.cgi?id=1978655) **ELK integration fails due to missing configuration parameters**


#### VDSM

 - [BZ 1978672](https://bugzilla.redhat.com/show_bug.cgi?id=1978672) **VMs with block based storage do not recover from hibernation (suspend)**

 - [BZ 1985973](https://bugzilla.redhat.com/show_bug.cgi?id=1985973) **Remove the abort snapshot behavior**

 - [BZ 1990268](https://bugzilla.redhat.com/show_bug.cgi?id=1990268) **No ability to change iso with virtio drivers when installing a virtual machine with windows**

 - [BZ 1984852](https://bugzilla.redhat.com/show_bug.cgi?id=1984852) **[CBT] Use --skip-broken-bitmaps in qemu-img convert --bitmaps to avoid failure if a bitmap is inconsistent**

 - [BZ 2000720](https://bugzilla.redhat.com/show_bug.cgi?id=2000720) **Previously detached FC Storage Domain not displayed in Admin Portal 'Import Domain' window the first time**

 - [BZ 1983882](https://bugzilla.redhat.com/show_bug.cgi?id=1983882) **Guest data corruption after migration**


#### oVirt Engine

 - [BZ 2000364](https://bugzilla.redhat.com/show_bug.cgi?id=2000364) **Engine fails to start, unable to read cloud-init network config from stateless snapshot configuration.**

 - [BZ 1985973](https://bugzilla.redhat.com/show_bug.cgi?id=1985973) **Remove the abort snapshot behavior**

 - [BZ 1979730](https://bugzilla.redhat.com/show_bug.cgi?id=1979730) **Windows VM ends up with ghost NIC and missing secondary disks machine type changes from pc-q35-rhel8.3.0 to pc-q35-rhel8.4.0**

 - [BZ 1940991](https://bugzilla.redhat.com/show_bug.cgi?id=1940991) **Hot plugging memory then hot unplugging the same memory on a RHEL 8 VM via API, after repeating the process several times the Defined Memory value in RHV-M and free command on the VM go out of sync, displaying completely different values**

 - [BZ 1977276](https://bugzilla.redhat.com/show_bug.cgi?id=1977276) **Uploading ISO through RHV-M portal intermittently fails with error "Failed to add disk for image transfer command"**


#### OTOPI

 - [BZ 2003441](https://bugzilla.redhat.com/show_bug.cgi?id=2003441) **dnf rollback is broken**

 - [BZ 2001465](https://bugzilla.redhat.com/show_bug.cgi?id=2001465) **Missing obsoletes for java bindings removal**


### Other

#### VDSM

 - [BZ 2008431](https://bugzilla.redhat.com/show_bug.cgi?id=2008431) **smbios hook is incompatible with python3**

   

 - [BZ 1993085](https://bugzilla.redhat.com/show_bug.cgi?id=1993085) **OST: Timeout while starting NBD server**

   


#### oVirt Engine

 - [BZ 1923178](https://bugzilla.redhat.com/show_bug.cgi?id=1923178) **Can not download VM disks due to 'Cannot transfer Virtual Disk: Disk is locked'**

   

 - [BZ 1984308](https://bugzilla.redhat.com/show_bug.cgi?id=1984308) **[CBT] Full backup fails when trying to make another backup right after the previous one is reported as done**

   

 - [BZ 1992686](https://bugzilla.redhat.com/show_bug.cgi?id=1992686) **[Scale] Slow performing vm api follow query impacting engine health**

   

 - [BZ 1900518](https://bugzilla.redhat.com/show_bug.cgi?id=1900518) **[CBT][incremental backup] VM.stop_backup should succeed if VM does not exist**

   

 - [BZ 1999651](https://bugzilla.redhat.com/show_bug.cgi?id=1999651) **Importing Windows VMs with timezone 'US Eastern Standard Time' from OVA that was exported from previous versions fails**

   

 - [BZ 1994506](https://bugzilla.redhat.com/show_bug.cgi?id=1994506) **Enable KSM by default in new-cluster dialog**

   


#### ovirt-imageio

 - [BZ 1990656](https://bugzilla.redhat.com/show_bug.cgi?id=1990656) **Downloading images much slower than uploading**

   


#### oVirt Hosted Engine Setup

 - [BZ 2001579](https://bugzilla.redhat.com/show_bug.cgi?id=2001579) **remove genisoimage leftovers as it's not used anymore and not available on CentOS Stream 9**

   

 - [BZ 1986733](https://bugzilla.redhat.com/show_bug.cgi?id=1986733) **ovirt-hosted-engine-setup uses deprecated API platform.linux_distribution which has been removed in Python 3.7 and later.**

   

 - [BZ 1647249](https://bugzilla.redhat.com/show_bug.cgi?id=1647249) **[RFE] hosted-engine command messages while starting are not user friendly.**

   

 - [BZ 1989092](https://bugzilla.redhat.com/show_bug.cgi?id=1989092) **hosted engine Installer typo:"Engine VM FQDN:  []:" should be "Engine VM FQDN[]:"**

   


### No Doc Update

#### oVirt Hosted Engine HA

 - [BZ 1993957](https://bugzilla.redhat.com/show_bug.cgi?id=1993957) **Engine VM might be shut down after the score wrongly being penalized due to cpu load**

   


#### oVirt Engine

 - [BZ 1928704](https://bugzilla.redhat.com/show_bug.cgi?id=1928704) **Host deploy events does not have proper correlation-id**

   

 - [BZ 2001944](https://bugzilla.redhat.com/show_bug.cgi?id=2001944) **Always log exception message which is raised during inserting into audit_log**

   


#### oVirt Host Dependencies

 - [BZ 2004913](https://bugzilla.redhat.com/show_bug.cgi?id=2004913) **update to cinderlib 16.2**

   


#### Contributors

31 people contributed to this release:

	Ales Musil (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: ovirt-hosted-engine-ha, ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh, ovirt-engine-metrics)
	Benny Zlotnik (Contributed to: ovirt-host)
	Dana Elfassy (Contributed to: ovirt-engine)
	Deric Crago (Contributed to: ovirt-ansible-collection)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Filip Januska (Contributed to: vdsm)
	Hilda Stastna (Contributed to: ovirt-web-ui)
	Lev Veyde (Contributed to: ovirt-appliance, ovirt-engine, ovirt-node-ng-image, ovirt-release, ovirt-site)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-engine, ovirt-engine-extension-aaa-ldap)
	Michal Skrivanek (Contributed to: ovirt-hosted-engine-setup)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: ovirt-engine, ovirt-imageio, vdsm)
	Pavel Bar (Contributed to: ovirt-engine)
	Saif Abu Saleh (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: otopi, ovirt-engine, ovirt-host, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup, ovirt-imageio, ovirt-release, ovirt-site, ovirt-web-ui)
	Scott J Dickerson (Contributed to: ovirt-web-ui)
	Shani Leviim (Contributed to: vdsm)
	Sharon Gratch (Contributed to: ovirt-engine-nodejs-modules, ovirt-web-ui)
	Steve Goodman (Contributed to: ovirt-site)
	Tomáš Golembiovský (Contributed to: ovirt-site)
	Vojtěch Juránek (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: otopi, ovirt-hosted-engine-ha)
	hbraha (Contributed to: vdsm)
	rchikatw (Contributed to: ovirt-ansible-collection)

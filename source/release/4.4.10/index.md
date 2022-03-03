---
title: oVirt 4.4.10 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.10 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.10.2 release as of March 03, 2022.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.5 (or similar) and CentOS Stream.

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

To learn about features introduced before 4.4.10, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.10 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.10 (redeploy in case of already being on 4.4.10).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.10?

### Release Note

#### oVirt Engine

 - [BZ 2044257](https://bugzilla.redhat.com/show_bug.cgi?id=2044257) **Bump snmp4j library version to remove dependency on log4j**

   In this release, oVirt 4.4.10 requires snmp4j version 3.6.4 or later, which no longer depends on the log4j library.

 - [BZ 2007286](https://bugzilla.redhat.com/show_bug.cgi?id=2007286) **Host is never fenced after a soft fence attempt**

   Previously, a non-responding host was first soft-fenced by the Engine, but this did not fix the connectivity issue. The engine did not initiate a hard fence and the host was left in an non-responding state.

In this release, soft fencing has been fixed so that if the soft fencing does not make the host responsive again, then the non-responding host treatment process continues correctly with the additional steps.


### Enhancements

#### oVirt Engine

 - [BZ 1897114](https://bugzilla.redhat.com/show_bug.cgi?id=1897114) **Add additional logging information to be able to understand why host is stuck in Unassigned state**

   In this release, monitoring of host refresh capabilities functionality was improved to help debug very rare production issues that sometimes caused the oVirt Engine to lose connectivity with the oVirt Node hosts.


### Removed functionality

#### oVirt Engine

 - [BZ 2044277](https://bugzilla.redhat.com/show_bug.cgi?id=2044277) **Replace ovirt-engine-extension-logger-log4j with internal ovirt-engine implementation**

   With this release, the ovirt-engine-extension-logger-log4j package has been removed. It is replaced by an internal ovirt-engine implementation. 



When upgrading from earlier oVirt versions to oVirt 4.4.10, the ovirt-engine-extension-logger-log4j package is uninstalled if it is present. If you used the ovirt-engine-extension-logger-log4j in earlier oVirt versions, you must manually remove the ovirt-engine-extension-logger-log4j configuration files and configure the new feature for sending log records to a remote syslog service, as outlined in the Administration Guide.



After a successful upgrade to oVirt 4.4.10, you can uninstall log4j12 without breaking the oVirt setup by running the following command: `$ dnf remove log4j12`.


### Bug Fixes

#### VDSM

 - [BZ 2023344](https://bugzilla.redhat.com/show_bug.cgi?id=2023344) **vdsmd fails to shut down cleanly when it tries to deactivate a used LV**

 - [BZ 2012832](https://bugzilla.redhat.com/show_bug.cgi?id=2012832) **Snapshot recovery reports false result**


#### oVirt Engine

 - [BZ 2013430](https://bugzilla.redhat.com/show_bug.cgi?id=2013430) **oVirt 4.4. FIPS install leaves UUID blank in grub after setting kernel option**

 - [BZ 2032919](https://bugzilla.redhat.com/show_bug.cgi?id=2032919) **Unable to add EL 7 host into oVirt Engine in clusters 4.2/4.3**

 - [BZ 2027424](https://bugzilla.redhat.com/show_bug.cgi?id=2027424) **Consume video device from virt-v2v**

 - [BZ 2022660](https://bugzilla.redhat.com/show_bug.cgi?id=2022660) **Removing a iSCSI storage connection removes all newly added connections**

 - [BZ 2025872](https://bugzilla.redhat.com/show_bug.cgi?id=2025872) **VM with a PCI host device and max vCPUs &gt;= 256 fails to start**


#### oVirt Engine Data Warehouse

 - [BZ 2014882](https://bugzilla.redhat.com/show_bug.cgi?id=2014882) **Memory and CPU overcommit panels are incorrect in 'Ovirt executive dashboard/cluster dashboard' in Grafana**


#### oVirt Hosted Engine HA

 - [BZ 2026625](https://bugzilla.redhat.com/show_bug.cgi?id=2026625) **_getHaInfo from vdsm can still get stuck if broker socket is not repsonding**


### Other

#### VDSM

 - [BZ 2026809](https://bugzilla.redhat.com/show_bug.cgi?id=2026809) **VM remains locked after importing from vmware/external-ova, we see  "'str' object has no attribute 'decode'" in the log**



#### oVirt Engine

 - [BZ 2037216](https://bugzilla.redhat.com/show_bug.cgi?id=2037216) **VM imported from configuration is stuck in WaitForLaunch once removed quickly after power-off**


 - [BZ 1854038](https://bugzilla.redhat.com/show_bug.cgi?id=1854038) **Download or upload disk (SDK) fails due to 'Timed out waiting for transfer XXX to finalize'**


 - [BZ 1985746](https://bugzilla.redhat.com/show_bug.cgi?id=1985746) **[CBT][Veeam] Full backup is stuck on 'FINALIZING' status when an error occurs during the image transfer flow**


 - [BZ 2027260](https://bugzilla.redhat.com/show_bug.cgi?id=2027260) **Cold backup fail in various ways - backup is reported ready before add_bitmap jobs complete**


 - [BZ 2018971](https://bugzilla.redhat.com/show_bug.cgi?id=2018971) **[CBT][Veeam] Scratch disks on block-based storage domain created with the wrong initial size.**


 - [BZ 2018986](https://bugzilla.redhat.com/show_bug.cgi?id=2018986) **[CBT][Veeam] Allow configurable block-based scratch disk initial size**


 - [BZ 2015470](https://bugzilla.redhat.com/show_bug.cgi?id=2015470) **[CBT] It's possible to remove a disk immediately after starting a backup**


 - [BZ 2013932](https://bugzilla.redhat.com/show_bug.cgi?id=2013932) **[CBT] VM backup scratch disks remains if the VM destroyed during the backup**

   


#### oVirt Release Package

 - [BZ 2006682](https://bugzilla.redhat.com/show_bug.cgi?id=2006682) **subscription-manager is missing from ovirt-node image**

   


### No Doc Update

#### VDSM

 - [BZ 2022354](https://bugzilla.redhat.com/show_bug.cgi?id=2022354) **Network gateway stays out-of-sync after upgrade**



#### oVirt Node NG Image

 - [BZ 2055098](https://bugzilla.redhat.com/show_bug.cgi?id=2055098) **CVE-2022-22942 kernel: failing usercopy allows for use-after-free exploitation [ovirt-4.4]**


 - [BZ 2047640](https://bugzilla.redhat.com/show_bug.cgi?id=2047640) **CVE-2021-0920 kernel: Use After Free in unix_gc() which could result in a local privilege escalation [ovirt-4.4]**
   

 - [BZ 2047630](https://bugzilla.redhat.com/show_bug.cgi?id=2047630) **CVE-2021-4154 kernel: local privilege escalation by exploiting the fsconfig syscall parameter leads to container breakout  [ovirt-4.4]**
   

 - [BZ 2046005](https://bugzilla.redhat.com/show_bug.cgi?id=2046005) **CVE-2022-0330 kernel: possible privileges escalation due to missing TLB flush  [ovirt-4.4]**


 - [BZ 2043471](https://bugzilla.redhat.com/show_bug.cgi?id=2043471) **CVE-2021-45417 aide: heap-based buffer overflow on outputs larger than B64_BUF [ovirt-4.4]**
   

 - [BZ 2046038](https://bugzilla.redhat.com/show_bug.cgi?id=2046038) **CVE-2021-4034 polkit: Local privilege escalation in pkexec due to incorrect handling of argument vector [ovirt-4.4]**


#### oVirt Engine Data Warehouse

 - [BZ 2014883](https://bugzilla.redhat.com/show_bug.cgi?id=2014883) **None of the grafana dashboard shows ethernet statistics  for VMs**



#### oVirt Hosted Engine HA

 - [BZ 2025381](https://bugzilla.redhat.com/show_bug.cgi?id=2025381) **VDSM logs are spammed due to multiple connection attempts and drops from ha-agent client**



#### Contributors

38 people contributed to this release:

	@lessfoobar (Contributed to: ovirt-site)
	Ales Musil (Contributed to: ovirt-engine, ovirt-site, vdsm)
	Arik Hadas (Contributed to: ovirt-engine, ovirt-site)
	Artur Socha (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: ovirt-hosted-engine-ha)
	Avital Pinnick (Contributed to: ovirt-site)
	Aviv Litman (Contributed to: ovirt-dwh)
	Benny Zlotnik (Contributed to: ovirt-engine)
	Donna DaCosta (Contributed to: ovirt-site)
	Eli Marcus (Contributed to: ovirt-site)
	Eli Mesika (Contributed to: ovirt-engine)
	Evgheni Dereveanchin (Contributed to: ovirt-site)
	Eyal Shenitzky (Contributed to: ovirt-engine)
	Harel Braha (Contributed to: ovirt-site)
	Jake Reynolds (Contributed to: ovirt-hosted-engine-ha)
	Janos Bonic (Contributed to: ovirt-site)
	Lev Veyde (Contributed to: ovirt-appliance, ovirt-node-ng-image, ovirt-release, ovirt-site)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-engine, ovirt-site)
	Milan Zamazal (Contributed to: ovirt-engine, ovirt-site, vdsm)
	Nijin Ashok (Contributed to: ovirt-ansible-collection)
	Nir Soffer (Contributed to: vdsm)
	Pavel Bar (Contributed to: ovirt-engine)
	Richard Hoch (Contributed to: ovirt-site)
	Saif Abu Saleh (Contributed to: ovirt-engine, ovirt-site)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-hosted-engine-ha, ovirt-node-ng-image, ovirt-release, ovirt-site)
	Sanja Bonic (Contributed to: ovirt-site)
	Scott J Dickerson (Contributed to: ovirt-site)
	Shani Leviim (Contributed to: ovirt-engine)
	Steve Goodman (Contributed to: ovirt-site)
	Tomáš Golembiovský (Contributed to: ovirt-site, vdsm)
	Yedidyah Bar David (Contributed to: ovirt-hosted-engine-ha)
	dercol1 (Contributed to: ovirt-site)
	jekader (Contributed to: ovirt-site)
	michalskrivanek (Contributed to: ovirt-site)
	tinez (Contributed to: ovirt-site)

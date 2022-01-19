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

The oVirt Project is pleased to announce the availability of the 4.4.10 release as of January 18, 2022.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.5 Beta (or similar) and CentOS Stream.

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

 - [BZ 2032919](https://bugzilla.redhat.com/show_bug.cgi?id=2032919) **Unable to add RHEL 7 host into RHV Manager in clusters 4.2/4.3**

   There was an error in the with tracked by BZ2019807, which caused the issue that RHEL 7 hosts could not be added to RHV Manager. This issue is now fixed and RHEL 7 hosts can be added to RHV Manager successfully.

 - [BZ 2007286](https://bugzilla.redhat.com/show_bug.cgi?id=2007286) **Host is never fenced after a soft fence attempt**

   Soft fencing phase has been fixed, so if soft fencing won't make the host responsive again, then the non-responding host treatment flow will proceed correctly with following phases.


### Enhancements

#### oVirt Engine

 - [BZ 1897114](https://bugzilla.redhat.com/show_bug.cgi?id=1897114) **Add additional logging information to be able to understand why host is stuck in Unassigned state**

   Feature: 

Improved monitoring of host refresh capabilities functionality [1] and minor refactoring [2]



Reason [1]: 

The motivation behind this change is a difficulty to investigate and very rare production issues causing Virtualization Manager (RHV-M) to lost connectivity hosts (RHV-H). In a result - these hosts end up in illegal states like  or simply cannot be activated.



Result [2]: 

The service occasionally prints information about hosts that were not 'refreshed' by HostMonitoring for

given period (a warning in /var/log/ovirt-engine/engine.log).



The watchdog service is configured by optional configuration properties:



$ engine-config -g HostMonitoringWatchdogIntervalInSeconds

HostMonitoringWatchdogIntervalInSeconds: 900 version: general



$ engine-config -g HostMonitoringWatchdogInactivityThresholdInSeconds

HostMonitoringWatchdogInactivityThresholdInSeconds: 1200 version: general



In order to disable watchdog service set:

$ engine-config -s HostMonitoringWatchdogIntervalInSeconds=0

and restart ovirt-engine



Reason [2]

Some of the internally used volatile flags where incremented in non-atomic way which could lead to unpredictable race conditions.



Result [2]

Dedicated atomic non-blocking data structures were used so that the race condition while increment was impossible.


### Bug Fixes

#### VDSM

 - [BZ 2023344](https://bugzilla.redhat.com/show_bug.cgi?id=2023344) **vdsmd fails to shut down cleanly when it tries to deactivate a used LV**

 - [BZ 2012832](https://bugzilla.redhat.com/show_bug.cgi?id=2012832) **Snapshot recovery reports false result**


#### oVirt Engine

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

 - [BZ 1985746](https://bugzilla.redhat.com/show_bug.cgi?id=1985746) **[CBT][Veeam] Full backup is stuck on 'FINALIZING' status when an error occurs during the image transfer flow**

   

 - [BZ 2027260](https://bugzilla.redhat.com/show_bug.cgi?id=2027260) **Cold backup fail in various ways - backup is reported ready before add_bitmap jobs complete**

   

 - [BZ 2018971](https://bugzilla.redhat.com/show_bug.cgi?id=2018971) **[CBT][Veeam] Scratch disks on block-based storage domain created with the wrong initial size.**

   

 - [BZ 2018986](https://bugzilla.redhat.com/show_bug.cgi?id=2018986) **[CBT][Veeam] Allow configurable block-based scratch disk initial size**

   

 - [BZ 2015470](https://bugzilla.redhat.com/show_bug.cgi?id=2015470) **[CBT] It's possible to remove a disk immediately after starting a backup**

   

 - [BZ 2013932](https://bugzilla.redhat.com/show_bug.cgi?id=2013932) **[CBT] VM backup scratch disks remains if the VM destroyed during the backup**

   


### No Doc Update

#### VDSM

 - [BZ 2022354](https://bugzilla.redhat.com/show_bug.cgi?id=2022354) **Network gateway stays out-of-sync after upgrade**

   


#### oVirt Engine Data Warehouse

 - [BZ 2014883](https://bugzilla.redhat.com/show_bug.cgi?id=2014883) **None of the grafana dashboard shows ethernet statistics  for VMs**

   


#### oVirt Hosted Engine HA

 - [BZ 2025381](https://bugzilla.redhat.com/show_bug.cgi?id=2025381) **VDSM logs are spammed due to multiple connection attempts and drops from ha-agent client**

   


#### Contributors

33 people contributed to this release:

	Ales Musil (Contributed to: ovirt-engine, ovirt-site, vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: ovirt-hosted-engine-ha)
	Aviv Litman (Contributed to: ovirt-dwh)
	Benny Zlotnik (Contributed to: ovirt-engine)
	Donna DaCosta (Contributed to: ovirt-site)
	Eli Marcus (Contributed to: ovirt-site)
	Eli Mesika (Contributed to: ovirt-engine)
	Evgheni Dereveanchin (Contributed to: ovirt-site)
	Eyal Shenitzky (Contributed to: ovirt-engine)
	Jake Reynolds (Contributed to: ovirt-hosted-engine-ha)
	Janos Bonic (Contributed to: ovirt-site)
	Lev Veyde (Contributed to: ovirt-appliance, ovirt-node-ng-image, ovirt-release, ovirt-site)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-engine)
	Milan Zamazal (Contributed to: ovirt-engine, ovirt-site, vdsm)
	Nijin Ashok (Contributed to: ovirt-ansible-collection)
	Nir Soffer (Contributed to: vdsm)
	Pavel Bar (Contributed to: ovirt-engine)
	RichardHoch (Contributed to: ovirt-site)
	Saif Abu Saleh (Contributed to: ovirt-engine, ovirt-site)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-hosted-engine-ha, ovirt-node-ng-image, ovirt-release, ovirt-site)
	Sanja Bonic (Contributed to: ovirt-site)
	Scott J Dickerson (Contributed to: ovirt-site)
	Shani Leviim (Contributed to: ovirt-engine)
	Steve Goodman (Contributed to: ovirt-site)
	Tomáš Golembiovský (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-hosted-engine-ha)
	jekader (Contributed to: ovirt-site)
	tinez (Contributed to: ovirt-site)

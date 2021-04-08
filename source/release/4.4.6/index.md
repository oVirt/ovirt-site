---
title: oVirt 4.4.6 Release Notes
category: documentation
authors: sandrobonazzola lveyde
toc: true
page_classes: releases
---


# oVirt 4.4.6 release planning

The oVirt 4.4.6 code freeze is planned for April 25, 2021.

If no critical issues are discovered while testing this compose it will be released on May 04, 2021.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.4.6](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.4.6%22%20-target_milestone%3A%22ovirt-4.4.6-%22)


# oVirt 4.4.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.6 Third Release Candidate as of April 08, 2021.

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

To learn about features introduced before 4.4.6, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)


## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.6 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.6 (redeploy in case of already being on 4.4.6).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.6?

### Release Note

#### oVirt Engine

 - [BZ 1933974](https://bugzilla.redhat.com/1933974) **[RFE] Introduce Datacenter and cluster level 4.6**

   DataCenter and Cluster compatibility level 4.6 is introduced in oVirt Engine 4.4.6. Only hosts running on CentOS/RHEL 8.4 with Advanced Virtualization 8.4 (libvirt &gt;= 7.0.0) can join cluster level 4.6.



New features available in compatibility 4.6 are tracked as separate bugs depending on this bug.


#### VDSM

 - [BZ 1933974](https://bugzilla.redhat.com/1933974) **[RFE] Introduce Datacenter and cluster level 4.6**

   DataCenter and Cluster compatibility level 4.6 is introduced in oVirt Engine 4.4.6. Only hosts running on CentOS/RHEL 8.4 with Advanced Virtualization 8.4 (libvirt &gt;= 7.0.0) can join cluster level 4.6.



New features available in compatibility 4.6 are tracked as separate bugs depending on this bug.


### Enhancements

#### oVirt Engine

 - [BZ 1669178](https://bugzilla.redhat.com/1669178) **[RFE] Q35 SecureBoot - Add ability to preserve variable store certificates.**

   Secure Boot process relies on keys that are normally stored in NVRAM of the VM. However, NVRAM was not stored in previous versions of oVirt and was newly initialized on every start of a VM. This prevented the use of any custom drivers (e.g. for Nvidia devices or for PLDP drivers in SUSE) on VMs with Secure Boot enabled. To be able to use SecureBoot VMs effectively oVirt now persists the content of NVRAM for UEFI VMs.

 - [BZ 1936897](https://bugzilla.redhat.com/1936897) **[Engine JDK 11] More verbose and configurable GC logging.**

   Feature: 

More verbose and configurable GC logging. This includes:

1. GC verbose logging disabled by default with INFO verbosity level.



2. Ability to setup desired GC log level via config the property:

ENGINE_VERBOSE_GC_LOG_LEVEL=info

Available options are: off, error, warning, info, debug, trace



3. Ability to setup desired GC log file rotation via:

ENGINE_VERBOSE_GC_LOG_FILE_SIZE=2M  #single log file size

ENGINE_VERBOSE_GC_LOG_FILES_NUMBER=50 #number of files in rotation



Reason: 

oVirt Engine tends to allocate large chunks of memory (depending on overall setup) that might contribute to potential various slow downs caused by Java Garbage Collector operations. 



Result: 

The ability to monitor and discover memory related issues much earlier (before the issue is actually negatively impacting an environment)





In order to customize or disable the above default settings it is recommended to put these properties in one of the engine's etc config ie. /etc/ovirt-engine/engine.conf.d/99-setup-gc-logging.conf


#### oVirt Host Dependencies

 - [BZ 1933245](https://bugzilla.redhat.com/1933245) **[RFE] Include smartmontools in RHVH Node image**

   


### Bug Fixes

#### oVirt Engine

 - [BZ 1946502](https://bugzilla.redhat.com/1946502) **engine-setup on a separate {dwh, websocket-proxy, grafana) machine fails**

 - [BZ 1932284](https://bugzilla.redhat.com/1932284) **Engine handled FS freeze is not fast enough for Windows systems**


### Other

#### oVirt Engine Data Warehouse

 - [BZ 1861685](https://bugzilla.redhat.com/1861685) **[RFE] Add filter to Inventory Dashboards**

   

 - [BZ 1935000](https://bugzilla.redhat.com/1935000) **Add a minimal Grafana version as dependent**

   

 - [BZ 1853254](https://bugzilla.redhat.com/1853254) **[RFE] Create links between reports**

   


#### oVirt Engine

 - [BZ 1879032](https://bugzilla.redhat.com/1879032) **If there is no master storage domain, the engine should elect one**

   

 - [BZ 1944723](https://bugzilla.redhat.com/1944723) **[RFE] Support virtual machines with 16TB memory**

   

 - [BZ 1941518](https://bugzilla.redhat.com/1941518) **[CBT] Scratch disk size should be equal to VM disk size for now**

   

 - [BZ 1942722](https://bugzilla.redhat.com/1942722) **VM backup failed with RPC call Host.add_image_ticket failed (error 482)**

   

 - [BZ 1943267](https://bugzilla.redhat.com/1943267) **Snapshot creation is failing for VM having vGPU.**

   

 - [BZ 1775145](https://bugzilla.redhat.com/1775145) **Incorrect message from hot-plugging memory**

   

 - [BZ 1912691](https://bugzilla.redhat.com/1912691) **[RFE] ticket classes should use SHA-256**

   

 - [BZ 1937310](https://bugzilla.redhat.com/1937310) **[REST] live update of the network filter parameter does not update the libvirt XML on the host**

   

 - [BZ 1834250](https://bugzilla.redhat.com/1834250) **CPU hotplug on UEFI VM causes VM reboot**

   

 - [BZ 1927718](https://bugzilla.redhat.com/1927718) **[RFE] Provide Reset option for VMs**

   

 - [BZ 1937827](https://bugzilla.redhat.com/1937827) **TPM device cannot be marked to be added to VM while it is running**

   

 - [BZ 1930282](https://bugzilla.redhat.com/1930282) **vcpu pinning string for HP VM must be shown in UI(even if it must be disabled for editing)**

   

 - [BZ 1936163](https://bugzilla.redhat.com/1936163) **Enable bochs-display for UEFI guests by default**

   

 - [BZ 1936185](https://bugzilla.redhat.com/1936185) **[CBT] Scratch disk not removed if a VM goes to 'paused' state during the backup process**

   

 - [BZ 1934129](https://bugzilla.redhat.com/1934129) **[Gluster] Unable to import existing gluster configuration into newly created cluster**

   

 - [BZ 1897049](https://bugzilla.redhat.com/1897049) **[CBT][incremental backup] Multiple NullPointerExceptions during VM removal after backing up the VM and removing the backup checkpoints**

   


#### VDSM

 - [BZ 1927718](https://bugzilla.redhat.com/1927718) **[RFE] Provide Reset option for VMs**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1930522](https://bugzilla.redhat.com/1930522) **[RHV-4.4.5.5] Failed to deploy RHEL AV 8.4.0 host to RHV with error "missing groups or modules: virt:8.4"**

   

 - [BZ 1919248](https://bugzilla.redhat.com/1919248) **[CBT] Race condition in deleting checkpoints causes inconsistency and failed backups**

   


#### Contributors

29 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: ovirt-engine, vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Aviv Litman (Contributed to: ovirt-dwh)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Jean-Louis Dupond (Contributed to: ovirt-engine, vdsm)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Martin Perina (Contributed to: ovirt-engine, vdsm)
	Michal Skrivanek (Contributed to: vdsm)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nick Bouwhuis (Contributed to: ovirt-engine)
	Nir Soffer (Contributed to: vdsm)
	Ori Liel (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-host, ovirt-release)
	Scott J Dickerson (Contributed to: ovirt-engine)
	Shani Leviim (Contributed to: ovirt-engine)
	Steven Rosenberg (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-engine)
	Yedidyah Bar David (Contributed to: ovirt-engine)

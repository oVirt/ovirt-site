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

The oVirt Project is pleased to announce the availability of the 4.4.6 First Release Candidate as of March 25, 2021.

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

 - [BZ 1932284](https://bugzilla.redhat.com/1932284) **Engine handled FS freeze is not fast enough for Windows systems**


### Other

#### oVirt Engine Data Warehouse

 - [BZ 1935000](https://bugzilla.redhat.com/1935000) **Add a minimal Grafana version as dependent**

   

 - [BZ 1853254](https://bugzilla.redhat.com/1853254) **[RFE] Create links between reports**

   


#### oVirt Engine

 - [BZ 1930282](https://bugzilla.redhat.com/1930282) **vcpu pinning string for HP VM must be shown in UI(even if it must be disabled for editing)**

   

 - [BZ 1936163](https://bugzilla.redhat.com/1936163) **Enable bochs-display for UEFI guests by default**

   

 - [BZ 1934129](https://bugzilla.redhat.com/1934129) **[Gluster] Unable to import existing gluster configuration into newly created cluster**

   


#### VDSM

 - [BZ 1927718](https://bugzilla.redhat.com/1927718) **[RFE] Provide Reset option for VMs**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1930522](https://bugzilla.redhat.com/1930522) **[RHV-4.4.5.5] Failed to deploy RHEL AV 8.4.0 host to RHV with error "missing groups or modules: virt:8.4"**

   


#### Contributors

24 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: ovirt-engine, vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Aviv Litman (Contributed to: ovirt-dwh)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Jean-Louis Dupond (Contributed to: vdsm)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Martin Perina (Contributed to: ovirt-engine, vdsm)
	Michal Skrivanek (Contributed to: vdsm)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nick Bouwhuis (Contributed to: ovirt-engine)
	Nir Soffer (Contributed to: vdsm)
	Ori Liel (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-host, ovirt-release)
	Scott J Dickerson (Contributed to: ovirt-engine)
	Steven Rosenberg (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-engine)

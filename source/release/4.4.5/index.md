---
title: oVirt 4.4.5 Release Notes
category: documentation
authors: lveyde sandrobonazzola
toc: true
page_classes: releases
---

# oVirt 4.4.5 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.5 Third Release Candidate as of January 28, 2021.

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

 - [BZ 1916076](https://bugzilla.redhat.com/1916076) **Rebase on Wildfly 22**

   oVirt Engine now requires WildFly 22

 - [BZ 1848872](https://bugzilla.redhat.com/1848872) **Rebase on Wildfly 21.0.2**

   oVirt Engine is now requiring WildFly 21.0.2


#### oVirt Engine WildFly

 - [BZ 1916076](https://bugzilla.redhat.com/1916076) **Rebase on Wildfly 22**

   oVirt Engine now requires WildFly 22

 - [BZ 1848872](https://bugzilla.redhat.com/1848872) **Rebase on Wildfly 21.0.2**

   oVirt Engine is now requiring WildFly 21.0.2


### Enhancements

#### oVirt Engine

 - [BZ 1866749](https://bugzilla.redhat.com/1866749) **[RFE] provide warning for soft errors**

   Feature: Allow to set severity for messages that are displayed via ansible debug module



Reason: When some tasks fail they don't stop the host deploy flow, but a debug message is printed in the host deploy log. However, host deploy log is mostly not looked at when host deploy finishes successfully, so such messages can be missed.



Result: When using the debug module for ansible roles in the host deploy flow, a message that will be written in the format of: "[SEVERITY] message" where SEVERITY is one of {ERROR, WARNING, ALERT} will be parsed and printed in the audit log with its correct severity level.

 - [BZ 1853906](https://bugzilla.redhat.com/1853906) **[RFE] Add the ability to reboot after install/ reinstall**

   Feature: 'Reboot' option was added to the install and reinstall flows and is enabled by default (same as in the upgrade flow)



Reason: Rebooting the host is needed is several cases such as specifying new kernel parameters and when switching from iptables to firewalld



Result: When installing/ reinstalling host, reboot is enabled by default (can be disabled by the administrator)


#### oVirt Engine Data Warehouse

 - [BZ 1887149](https://bugzilla.redhat.com/1887149) **[RFE] VM Disk stats should contain IOPS stats**

   


### Bug Fixes

#### oVirt Engine SDK 4 Python

 - [BZ 1848586](https://bugzilla.redhat.com/1848586) **Fix upload_ova_as_template.py**


#### oVirt Engine

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

 - [BZ 1773922](https://bugzilla.redhat.com/1773922) **remote-viewer prompts for password after migration of a VM with expired ticket**


### Other

#### cockpit-ovirt

 - [BZ 1908234](https://bugzilla.redhat.com/1908234) **Order of hosts not preserved for day2 operations**

   

 - [BZ 1884223](https://bugzilla.redhat.com/1884223) **[GSS][RHHI 1.7][Error message '&lt;device-path&gt;  is not a valid name for this device' showing up every two hours]**

   


#### oVirt Engine SDK 4 Python

 - [BZ 1805030](https://bugzilla.redhat.com/1805030) **Java SDK connection.timeout is in milliseconds**

   


#### OTOPI

 - [BZ 1908602](https://bugzilla.redhat.com/1908602) **dnf packager is broken on CentOS Stream**

   


#### oVirt Engine

 - [BZ 1921104](https://bugzilla.redhat.com/1921104) **Bump required ansible version in RHV Manager 4.4.5**

   

 - [BZ 1875412](https://bugzilla.redhat.com/1875412) **Request to create a nic on template gets wrong response content**

   

 - [BZ 1897160](https://bugzilla.redhat.com/1897160) **SCSI Pass-Through is enabled by default**

   


#### oVirt Engine Data Warehouse

 - [BZ 1914825](https://bugzilla.redhat.com/1914825) **Update queries to use v4_4 views in all dashboards**

   

 - [BZ 1910045](https://bugzilla.redhat.com/1910045) **Update data source in all dashboards**

   

 - [BZ 1912887](https://bugzilla.redhat.com/1912887) **Update variables on dashboards that do not display deleted entities**

   

 - [BZ 1904047](https://bugzilla.redhat.com/1904047) **Add types of storage and storage domain to enum_translator table (enums.sql)**

   


#### oVirt Ansible collection

 - [BZ 1915286](https://bugzilla.redhat.com/1915286) **RHHI-V deployment fails on task "Get server CPU list via REST API"**

   


### No Doc Update

#### cockpit-ovirt

 - [BZ 1893161](https://bugzilla.redhat.com/1893161) **Cockpit hosted engine installer allows a disk size bigger than the LUN**

   


#### OTOPI

 - [BZ 1908617](https://bugzilla.redhat.com/1908617) **otopi is using a private dnf method _read_conf_file**

   


#### oVirt Engine

 - [BZ 1919628](https://bugzilla.redhat.com/1919628) **VM pool size update using the REST API fails**

   

 - [BZ 1915329](https://bugzilla.redhat.com/1915329) **[Stream] Add host fails with: Destination /etc/pki/ovirt-engine/requests not writable**

   

 - [BZ 1581677](https://bugzilla.redhat.com/1581677) **[scale] search (VMs + storage domain) is taking too long**

   

 - [BZ 1846294](https://bugzilla.redhat.com/1846294) **Engine restart needed after ovirt-register-sso-client-tool**

   

 - [BZ 1911303](https://bugzilla.redhat.com/1911303) **host deploy fails when parameters are set with the value null**

   


#### VDSM

 - [BZ 1916947](https://bugzilla.redhat.com/1916947) **The syntax of the entry in '99-vdsm_protect_ifcfg.conf' is incorrect**

   


#### Contributors

38 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: ovirt-release, vdsm)
	Amit Bawer (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, ovirt-engine-wildfly)
	Asaf Rachmani (Contributed to: imgbased, ovirt-ansible-collection)
	Aviv Litman (Contributed to: ovirt-dwh)
	Aviv Turgeman (Contributed to: cockpit-ovirt, ovirt-engine-nodejs-modules)
	Benny Zlotnik (Contributed to: ovirt-engine)
	Dana Elfassy (Contributed to: ovirt-engine)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Jean-Louis Dupond (Contributed to: ovirt-engine, vdsm)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-engine, ovirt-engine-wildfly)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Levy (Contributed to: ovirt-host)
	Nir Soffer (Contributed to: vdsm)
	Ondra Machacek (Contributed to: ovirt-engine-sdk-java)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk, ovirt-engine-sdk-java)
	Parth Dhanjal (Contributed to: cockpit-ovirt)
	Pavel Bar (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine)
	Roman Bednar (Contributed to: vdsm)
	Sandro Bonazzola (Contributed to: cockpit-ovirt, ovirt-cockpit-sso, ovirt-engine, ovirt-engine-sdk-java, ovirt-host, ovirt-release, vdsm)
	Scott J Dickerson (Contributed to: ovirt-engine-nodejs-modules)
	Shane McDonald (Contributed to: ovirt-ansible-collection)
	Shani Leviim (Contributed to: ovirt-engine)
	Shirly Radco (Contributed to: ovirt-dwh)
	Steven Rosenberg (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: otopi, ovirt-ansible-collection, ovirt-cockpit-sso, ovirt-engine, ovirt-host)

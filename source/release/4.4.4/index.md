---
title: oVirt 4.4.4 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---

# oVirt 4.4.4 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.4 release as of December 21, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.2/8.3 (8.3 recommended) and
CentOS Linux 8.2 (or similar).

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

To learn about features introduced before 4.4.4, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.4 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.4 (redeploy in case of already being on 4.4.4).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.4?

### Release Note

#### VDSM

 - [BZ 1899865](https://bugzilla.redhat.com/show_bug.cgi?id=1899865) **[RFE] Remove dpdk from host networking**

   Experimental support for DPDK has been removed in oVirt 4.4.4


### Enhancements

#### VDSM

 - [BZ 1859092](https://bugzilla.redhat.com/show_bug.cgi?id=1859092) **Logical Name is missing when attaching RO direct LUN to a VM**

   Previously, the logical name of LUN disks within the guest weren't pull to the user visibility. Now, the LUN logical name is pulled and shown in the disk device.


#### oVirt Engine Data Warehouse

 - [BZ 1866363](https://bugzilla.redhat.com/show_bug.cgi?id=1866363) **[RFE] Add variables to choose specific entity**

   Feature: 

Add '$host_id' and '$vm_id' variables to choose specific entity.



Reason: 

In order to allow selection and search of virtual machines or hosts.



Result:

It will be possible to view the relevant reports according to a selected virtual machine or host. In addition it will be possible to search for the machine or host in the variable's search bar.

 - [BZ 1851725](https://bugzilla.redhat.com/show_bug.cgi?id=1851725) **[RFE] Add tags to grafana dashboards**

   Feature: 

Add tags to grafana dashboards.

The tags are:

1. Cluster

2. DC (Data Center)

3. Host

4. VM

5. SD (Storage Domains)

6. CPU

7. Memory

8. Disk

9. Interface 

10. Downtime

11. Uptime

12. OS (Operating System) 

13. HA (High Availability)



Reason: 

Adding tags will make it easier to sort and know the contents of dashboards.



Result:

Each dashboard will have a number of tags that describe the content displayed within it.


#### oVirt Engine

 - [BZ 1884233](https://bugzilla.redhat.com/show_bug.cgi?id=1884233) **oVirt-engine reports misleading login-domain for external RH-SSO accounts**
   The authz name is now used as the user domain on the oVirt Engine home page. It replaces the profile name.
   Additionally, several log statements related to authorization/authentication flow have been made consistent by presenting both the user authz name and the profile name where applicable.
   In this release, `<username>@<authz name>` is displayed on the home page once the user is successfully logged in to the ovirt-engine.
   In addition, the log statements now contain both the authz name and the profile name as well as the username.

 - [BZ 1729897](https://bugzilla.redhat.com/show_bug.cgi?id=1729897) **[RFE] Per-vNUMA node tuning modes**

   Previously, the NUMA tune mode was set to the VM, setting every virtual NUMA node of the VM with this setting. Now, it is possible to set NUMA tune mode for each virtual NUMA node.

 - [BZ 1576923](https://bugzilla.redhat.com/show_bug.cgi?id=1576923) **RFE: Ability to move master role to another domain without putting the domain to maintenance**

   Feature:

Add the ability to move the master role to another domain without putting the domain to maintenance, using the REST API. 



Reason:

Currently, you can't migrate the master role to a newer domain, without migrating the VMs from the old one and putting it on maintenance.



Another scenario was the inability to put on maintenance a hosted_storage domain. 



Result: 

There's now an option to move the master role using the REST API to a different storage domain, without putting them into maintenance.

For example, for setting a storage domain with ID '456' as a master on a data center with ID '123', send a request like this:



POST /ovirt-engine/api/datacenters/123/setmaster



With a request body like this:


```xml
<action>

  <storage_domain id="456"/>

</action>
```


There's also an option for using the storage domain's name:

```xml
<action>

  <storage_domain>

    <name>my-nfs</name>

  </storage_domain>

</action>
```


The specified storage domain should become the new master storage domain.

 - [BZ 1859092](https://bugzilla.redhat.com/show_bug.cgi?id=1859092) **Logical Name is missing when attaching RO direct LUN to a VM**

   Previously, the logical name of LUN disks within the guest weren't pull to the user visibility. Now, the LUN logical name is pulled and shown in the disk device.

 - [BZ 1872210](https://bugzilla.redhat.com/show_bug.cgi?id=1872210) **[RFE] Don't require ovirt-guest-agent on Ubuntu 18.04.1 LTS (Bionic Beaver) and newer**

   Feature: Added support for Ubuntu 18.04, Debian 9 and later versions. Also turned off ovirt guest agent for Ubuntu 18.04 and later as well as Debian 9 versions and later.



Reason: To support the latest Ubuntu Operating Systems and to turn off ovirt guest agent support for the latest Ubuntu and Debian versions.



Result: The latest Ubuntu and Debian Operating Systems are now supported without ovirt guest agent support.


#### oVirt Ansible collection

 - [BZ 1893385](https://bugzilla.redhat.com/show_bug.cgi?id=1893385) **hosted-engine deploy (restore-from-file) fails if any non-management logical network is marked as required in backup file**

   In previous versions, when using 'hosted-engine --restore-from-file' to restore or upgrade, if the backup included extra required networks in the cluster, and if the user did not reply 'Yes' to the question about pausing the execution, deployment failed.



With this version, regardless of the answer to 'pause?', if the host is found to be in state "Non Operational", deployment will pause, outputting relevant information to the user, and waiting until a lock file is removed. This should allow the user to then connect to the web admin UI and manually handle the situation, activate the host, and then remove the lock file and continue the deployment.



This version also allows supplying a custom hook to fix such and similar issues automatically.



Doc team: Perhaps instead of above, or in addition to it, open a doc bug. See also comment 27 for details.


### Bug Fixes

#### VDSM

 - [BZ 1903358](https://bugzilla.redhat.com/show_bug.cgi?id=1903358) **Speed up activation with large number of storage domain**

 - [BZ 1508098](https://bugzilla.redhat.com/show_bug.cgi?id=1508098) **[RFE] RHV should configure sanlock host name**

 - [BZ 1904774](https://bugzilla.redhat.com/show_bug.cgi?id=1904774) **Direct lun disk is reflected on the guest by lun ID instead of disk ID**

 - [BZ 1892403](https://bugzilla.redhat.com/show_bug.cgi?id=1892403) **Image download via SDK broken with older engines**


#### oVirt Engine

 - [BZ 1905417](https://bugzilla.redhat.com/show_bug.cgi?id=1905417) **vGPU: VM failed to run with mdev_type instance (java NPE in engine.log)**

 - [BZ 1904947](https://bugzilla.redhat.com/show_bug.cgi?id=1904947) **ISO domain images list is empty when virtio-win is not installed on the engine side.**

 - [BZ 1904774](https://bugzilla.redhat.com/show_bug.cgi?id=1904774) **Direct lun disk is reflected on the guest by lun ID instead of disk ID**

 - [BZ 1508098](https://bugzilla.redhat.com/show_bug.cgi?id=1508098) **[RFE] RHV should configure sanlock host name**

 - [BZ 1888142](https://bugzilla.redhat.com/show_bug.cgi?id=1888142) **Confusing warning message in the logs while shutting down a pool VM**

 - [BZ 1875386](https://bugzilla.redhat.com/show_bug.cgi?id=1875386) **openssl conf files point at qemu-ca-certificate**

 - [BZ 1855782](https://bugzilla.redhat.com/show_bug.cgi?id=1855782) **Export VM task blocks other tasks**

 - [BZ 1797553](https://bugzilla.redhat.com/show_bug.cgi?id=1797553) **[REST-API] exportToPathOnHost call works only synchronously**

 - [BZ 1889987](https://bugzilla.redhat.com/show_bug.cgi?id=1889987) **Export VM task block other tasks**

 - [BZ 1886750](https://bugzilla.redhat.com/show_bug.cgi?id=1886750) **VM host device is not removed while removing the host**

 - [BZ 1875363](https://bugzilla.redhat.com/show_bug.cgi?id=1875363) **engine-setup failing on FIPS enable rhel8 machine**

 - [BZ 1758216](https://bugzilla.redhat.com/show_bug.cgi?id=1758216) **[scale] Engine fails to create multiple pools of vms**

 - [BZ 1880251](https://bugzilla.redhat.com/show_bug.cgi?id=1880251) **VM stuck in "reboot in progress" ("virtual machine XXX should be running in a host but it isn't.").**

 - [BZ 1891293](https://bugzilla.redhat.com/show_bug.cgi?id=1891293) **auto_pinning calculation is broken for hosts with 4 NUMA nodes. request fails**

 - [BZ 1871792](https://bugzilla.redhat.com/show_bug.cgi?id=1871792) **Importing VM using virt-v2v fails if service ovirt-engine restarted during AddDisk operation.**

 - [BZ 1694711](https://bugzilla.redhat.com/show_bug.cgi?id=1694711) **Incorrect NUMA pinning due to improper correlation between CPU sockets and NUMA nodes**


#### cockpit-ovirt

 - [BZ 1903567](https://bugzilla.redhat.com/show_bug.cgi?id=1903567) **cockpit cant discover iscsi and fc luns**


### Other

#### VDSM

 - [BZ 1893656](https://bugzilla.redhat.com/show_bug.cgi?id=1893656) **[CBT] VM state switches from 'up' to 'powering up' right after full backup - causing a second immediate backup attempt to fail**

   

 - [BZ 1893773](https://bugzilla.redhat.com/show_bug.cgi?id=1893773) **NVDIMM: memory usage in WebAdmin is always ~100% regardless to actual usage inside the VM.**

   


#### oVirt Engine Data Warehouse

 - [BZ 1894298](https://bugzilla.redhat.com/show_bug.cgi?id=1894298) **ModuleNotFoundError: No module named 'ovirt_engine' raised when starting ovirt-engine-dwhd.py in dev env**

   


#### oVirt Engine

 - [BZ 1627997](https://bugzilla.redhat.com/show_bug.cgi?id=1627997) **[RFE] Allow SPM switching if all tasks have finished via REST-API**

   

 - [BZ 1904202](https://bugzilla.redhat.com/show_bug.cgi?id=1904202) **Create backup failed on vm after hot plugging a disk**

   

 - [BZ 1881115](https://bugzilla.redhat.com/show_bug.cgi?id=1881115) **RHEL VM icons squashed, please adhere to brand rules**

   

 - [BZ 1792905](https://bugzilla.redhat.com/show_bug.cgi?id=1792905) **Sparsification is not reflected on image size of qcow volumes**

   

 - [BZ 1881505](https://bugzilla.redhat.com/show_bug.cgi?id=1881505) **German translation of ME should be checked by a native and technical German speaker please**

   

 - [BZ 1796231](https://bugzilla.redhat.com/show_bug.cgi?id=1796231) **VM disk remains in locked state if image transfer (image download) timesout due to inactivity.**

   

 - [BZ 1895695](https://bugzilla.redhat.com/show_bug.cgi?id=1895695) **Modifying (add/remove/replace) NICs in the clone modal doesn't reflect on the cloned VM**

   

 - [BZ 1895667](https://bugzilla.redhat.com/show_bug.cgi?id=1895667) **Missing UI proper error message for cloning a VM which in a process of cloning**

   

 - [BZ 1900540](https://bugzilla.redhat.com/show_bug.cgi?id=1900540) **Engine try to stop NBD server during online backup**

   

 - [BZ 1899768](https://bugzilla.redhat.com/show_bug.cgi?id=1899768) **Live merge fails on invoking callback end method 'onSucceeded' for a VM with Cluster Chipset/Firmware Type "Cluster default" or "Legacy".**

   

 - [BZ 1895697](https://bugzilla.redhat.com/show_bug.cgi?id=1895697) **Modifying disk allocation target domain in the clone modal doesn't reflect on the cloned VM**

   

 - [BZ 1892291](https://bugzilla.redhat.com/show_bug.cgi?id=1892291) **Change the representation of empty disk.usage statistics**

   

 - [BZ 1885997](https://bugzilla.redhat.com/show_bug.cgi?id=1885997) **[OVS] Trigger sync while switching host from legacy type cluster to OVS type and vise versa**

   

 - [BZ 1893540](https://bugzilla.redhat.com/show_bug.cgi?id=1893540) **Cannot clone a suspended VM**

   

 - [BZ 1710446](https://bugzilla.redhat.com/show_bug.cgi?id=1710446) **[RFE] Europe/Helsinki timezone not available in RHV.**

   

 - [BZ 1897422](https://bugzilla.redhat.com/show_bug.cgi?id=1897422) **Virtual Machine imported from OVA has no small/large_icon_id set in vm_static**

   

 - [BZ 1893101](https://bugzilla.redhat.com/show_bug.cgi?id=1893101) **nl-be keymap should be removed**

   

 - [BZ 1894758](https://bugzilla.redhat.com/show_bug.cgi?id=1894758) **[DR] Remote data sync to the secondary site never completes**

   

 - [BZ 1885132](https://bugzilla.redhat.com/show_bug.cgi?id=1885132) **[OVN] Run OVN tasks on host re-install flow**

   

 - [BZ 1888278](https://bugzilla.redhat.com/show_bug.cgi?id=1888278) **Refresh LUNs pop UI massage if the vm is powered off**

   

 - [BZ 1847090](https://bugzilla.redhat.com/show_bug.cgi?id=1847090) **[RFE] Support transferring snapshots using raw format (NBD backend)**

   

 - [BZ 1890430](https://bugzilla.redhat.com/show_bug.cgi?id=1890430) **Kubevirt / OpenShift Virtualization provider - the cluster/host cpu mismatch message**

   

 - [BZ 1881026](https://bugzilla.redhat.com/show_bug.cgi?id=1881026) **UI Prints 'Actual timezone in the guest differs from the configuration' due to daylight saving time**

   

 - [BZ 1891303](https://bugzilla.redhat.com/show_bug.cgi?id=1891303) **Cloning modal doesn't close automatically when cloning is finished/failed**

   

 - [BZ 1889394](https://bugzilla.redhat.com/show_bug.cgi?id=1889394) **VM hosted by non-operational host fails in migration with NullPointerException**

   

 - [BZ 1890071](https://bugzilla.redhat.com/show_bug.cgi?id=1890071) **Bond mode 4 is detected as custom bond options**

   


#### VDSM JSON-RPC Java

 - [BZ 1890430](https://bugzilla.redhat.com/show_bug.cgi?id=1890430) **Kubevirt / OpenShift Virtualization provider - the cluster/host cpu mismatch message**

   


#### cockpit-ovirt

 - [BZ 1899917](https://bugzilla.redhat.com/show_bug.cgi?id=1899917) **[day2] create volume flow from cockpit allows to select more than 3 hosts**

   


### No Doc Update

#### VDSM

 - [BZ 1895015](https://bugzilla.redhat.com/show_bug.cgi?id=1895015) **Bad permissions in /etc/sudoers.d drop-in files**

   

 - [BZ 1839444](https://bugzilla.redhat.com/show_bug.cgi?id=1839444) **[RFE] Use more efficient dumpStorageDomain() in dump-volume-chains**

   

 - [BZ 1833780](https://bugzilla.redhat.com/show_bug.cgi?id=1833780) **Live storage migration failed -  Failed to change disk image**

   


#### oVirt Engine Data Warehouse

 - [BZ 1894420](https://bugzilla.redhat.com/show_bug.cgi?id=1894420) **Stopping a remote dwh is broken**

   

 - [BZ 1892247](https://bugzilla.redhat.com/show_bug.cgi?id=1892247) **Fix duplicates in time-based queries (that use the hourly + daily tables)**

   


#### oVirt Engine

 - [BZ 1900594](https://bugzilla.redhat.com/show_bug.cgi?id=1900594) **[CBT][incremental backup] Engine fail to stop backup if VM was destroyed during backup**

   

 - [BZ 1900546](https://bugzilla.redhat.com/show_bug.cgi?id=1900546) **[CBT][incremental backup] Engine reports that backup was finalized when stopping backup failed**

   

 - [BZ 1868114](https://bugzilla.redhat.com/show_bug.cgi?id=1868114) **RHV-M UI/Webadmin:  The "Disk Snapshots" tab reflects incorrect "Creation Date" information.**

   

 - [BZ 1903595](https://bugzilla.redhat.com/show_bug.cgi?id=1903595) **[PPC] Can't add PPC host to Engine**

   

 - [BZ 1811593](https://bugzilla.redhat.com/show_bug.cgi?id=1811593) **Some PKI files are not removed by engine-cleanup**

   

 - [BZ 1898066](https://bugzilla.redhat.com/show_bug.cgi?id=1898066) **host deploy fails when tune profile is null**

   

 - [BZ 1833780](https://bugzilla.redhat.com/show_bug.cgi?id=1833780) **Live storage migration failed -  Failed to change disk image**

   

 - [BZ 1856375](https://bugzilla.redhat.com/show_bug.cgi?id=1856375) **Can't add additional host as hosted-engine ha-host from "Guide me" from UI.**

   

 - [BZ 1846338](https://bugzilla.redhat.com/show_bug.cgi?id=1846338) **Host monitoring does not report bond mode 1 active slave after engine is alive some time**

   

 - [BZ 1689362](https://bugzilla.redhat.com/show_bug.cgi?id=1689362) **ovirt does not respect domcapabilities**

   


#### VDSM JSON-RPC Java

 - [BZ 1846338](https://bugzilla.redhat.com/show_bug.cgi?id=1846338) **Host monitoring does not report bond mode 1 active slave after engine is alive some time**

   


#### oVirt Hosted Engine Setup

 - [BZ 1897888](https://bugzilla.redhat.com/show_bug.cgi?id=1897888) **[RFE] Refine "hosted-engine --check-deployed" results.**

   


#### oVirt Provider OVN

 - [BZ 1895015](https://bugzilla.redhat.com/show_bug.cgi?id=1895015) **Bad permissions in /etc/sudoers.d drop-in files**

   


#### oVirt Node NG Image

 - [BZ 1907803](https://bugzilla.redhat.com/show_bug.cgi?id=1907803) **ovirt-node anaconda installclass needs rebase on CentOS 8.3 anaconda-33.16.3.***

   


#### Contributors

47 people contributed to this release:

	Ahmad Khiet (Contributed to: ovirt-engine)
	Ales Musil (Contributed to: ovirt-engine, ovirt-provider-ovn, vdsm)
	Amit Bawer (Contributed to: vdsm)
	Andrej Cernek (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine, vdsm-jsonrpc-java)
	Asaf Rachmani (Contributed to: cockpit-ovirt, imgbased, ovirt-hosted-engine-setup, ovirt-node-ng-image)
	Aviv Litman (Contributed to: ovirt-dwh)
	Aviv Turgeman (Contributed to: cockpit-ovirt, ovirt-hosted-engine-setup)
	Bell Levin (Contributed to: vdsm)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Ben Amsalem (Contributed to: ovirt-engine, ovirt-web-ui)
	Benny Zlotnik (Contributed to: ovirt-engine, vdsm)
	Dan Kenigsberg (Contributed to: vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Dominik Holler (Contributed to: ovirt-engine, ovirt-provider-ovn, ovirt-release)
	Ehud Yonasi (Contributed to: vdsm)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine, vdsm)
	Hilda Stastna (Contributed to: ovirt-web-ui)
	Jean-Louis Dupond (Contributed to: ovirt-engine)
	Kaustav Majumder (Contributed to: ovirt-engine)
	Kobi Hakimi (Contributed to: ovirt-ansible-collection)
	Lev Veyde (Contributed to: ovirt-engine, ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marcin Sobczyk (Contributed to: ovirt-provider-ovn, vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-ansible-collection, ovirt-engine, vdsm-jsonrpc-java)
	Milan Zamazal (Contributed to: ovirt-engine, ovirt-vmconsole, vdsm)
	Nir Levy (Contributed to: imgbased, ovirt-node-ng-image)
	Nir Soffer (Contributed to: ovirt-engine, ovirt-engine-sdk, vdsm)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Parth Dhanjal (Contributed to: cockpit-ovirt)
	Pavel Bar (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-web-ui)
	Sandro Bonazzola (Contributed to: ovirt-appliance, ovirt-engine, ovirt-node-ng-image, ovirt-release)
	Scott J Dickerson (Contributed to: ovirt-engine, ovirt-web-ui)
	Shani Leviim (Contributed to: ovirt-engine)
	Sharon Gratch (Contributed to: ovirt-web-ui)
	Shirly Radco (Contributed to: ovirt-dwh)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Steven Rosenberg (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: ovirt-engine-sdk, vdsm)
	Yedidyah Bar David (Contributed to: ovirt-ansible-collection, ovirt-dwh, ovirt-engine, ovirt-node-ng-image)
	aelrayess (Contributed to: ovirt-engine-sdk)

---
title: oVirt 4.4.8 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.8 release planning

The oVirt 4.4.8 code freeze is planned for August 22, 2021.

If no critical issues are discovered while testing this compose it will be released on September 15, 2021.

It has been planned to include in this release the content from this query:
[Bugzilla tickets targeted to 4.4.8](https://bugzilla.redhat.com/buglist.cgi?quicksearch=ALL%20target_milestone%3A%22ovirt-4.4.8%22%20-target_milestone%3A%22ovirt-4.4.8-%22)


# oVirt 4.4.8 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.8 First Release Candidate as of July 15, 2021.

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

To learn about features introduced before 4.4.8, see the
[release notes for previous versions](/documentation/#latest-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm)


## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.8 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.8 (redeploy in case of already being on 4.4.8).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.8?

### Other

#### oVirt Engine

 - [BZ 1963715](https://bugzilla.redhat.com/1963715) **[RFE] Export/import VMs/templates with NVRAM**

   

 - [BZ 1853501](https://bugzilla.redhat.com/1853501) **[RFE] Add column with storage domain in the "Storage -&gt; Disks" page**

   

 - [BZ 1978253](https://bugzilla.redhat.com/1978253) **OGA memory report isn't shown in the VM general tab**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1975225](https://bugzilla.redhat.com/1975225) **Occasional failures to export VM to OVA**

   

 - [BZ 1974656](https://bugzilla.redhat.com/1974656) **[Rest API] Event search template filter does not work**

   


#### Contributors

19 people contributed to this release:

	Ales Musil (Contributed to: vdsm)
	Arik Hadas (Contributed to: ovirt-engine)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Eli Mesika (Contributed to: ovirt-engine)
	Eyal Shenitzky (Contributed to: ovirt-engine-sdk)
	Filip Januska (Contributed to: ovirt-engine)
	Lev Veyde (Contributed to: ovirt-release)
	Liran Rotenberg (Contributed to: ovirt-engine)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Nir Soffer (Contributed to: vdsm)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Pavel Bar (Contributed to: ovirt-engine-sdk)
	Saif Abu Saleh (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: ovirt-engine, ovirt-release)
	Shmuel Melamud (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: vdsm)
	Vojtech Juranek (Contributed to: vdsm)
	Yedidyah Bar David (Contributed to: ovirt-engine)

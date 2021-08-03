---
title: oVirt 4.3.10 Release Notes
category: documentation
authors:
  - sandrobonazzola
  - lveyde
toc: true
page_classes: releases
---

# oVirt 4.3.10 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.10 release as of June 03, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.8 and
CentOS Linux 7.8 (or similar).



If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.3.10, see the
[release notes for previous versions](/documentation/#previous-release-notes).



## What's New in 4.3.10?

### Enhancements

#### oVirt Engine

 - [BZ 1717336](https://bugzilla.redhat.com/show_bug.cgi?id=1717336) **[downstream clone - 4.3.6] [RFE] OVF_STORE last update not exposed in the UI**

   


### Bug Fixes

#### oVirt Engine

 - [BZ 1837994](https://bugzilla.redhat.com/show_bug.cgi?id=1837994) **VM gets stuck after previewing memory snapshot -  Failed to set time: internal error: unable to execute QEMU agent command 'guest-set-time'**

 - [BZ 1832218](https://bugzilla.redhat.com/show_bug.cgi?id=1832218) **clone(as thin) VM from template or create snapshot fails with 'Requested capacity 1073741824 < parent capacity 3221225472 (volume:1211)' [RHV clone - 4.3.10]**

 - [BZ 1842375](https://bugzilla.redhat.com/show_bug.cgi?id=1842375) **Failed snapshot creation can cause data corruption of other VMs [RHV clone - 4.3.10]**

 - [BZ 1828067](https://bugzilla.redhat.com/show_bug.cgi?id=1828067) **mountOptions is ignored for "import storage domain" from GUI [RHV clone - 4.3.10]**

 - [BZ 1820642](https://bugzilla.redhat.com/show_bug.cgi?id=1820642) **[cinderlib] Cinderlib DB is missing a backup and restore option [RHV clone - 4.3.10]**

 - [BZ 1796136](https://bugzilla.redhat.com/show_bug.cgi?id=1796136) **[cloned ]RHV 4.3 landing page does not show login or allow scrolling.**


### Other

#### VDSM

 - [BZ 1829597](https://bugzilla.redhat.com/show_bug.cgi?id=1829597) **Require lvm2 with supporting locking_type=4 for pvs command on CentOS**

   


#### imgbased

 - [BZ 1812574](https://bugzilla.redhat.com/show_bug.cgi?id=1812574) **imgbase layout --init failed during the kickstart installation**

   Before this update, imgbase layout --init failed during Red Hat Virtualization Host installation with Kickstart.

In this release, the installation with Kickstart succeeds.


#### oVirt Engine

 - [BZ 1832707](https://bugzilla.redhat.com/show_bug.cgi?id=1832707) **Errors from tar are not logged**

   

 - [BZ 1825740](https://bugzilla.redhat.com/show_bug.cgi?id=1825740) **[OVN] ovirt sync to ovirt-provider-ovn breaks on upgrade of ovirt-engine-4.2.8.9-0.1.el7ev.noarch to ovirt-engine-4.3.9.4-11.el7.noarch**

   

 - [BZ 1815411](https://bugzilla.redhat.com/show_bug.cgi?id=1815411) **Disable usage of Ansible 2.10 for RHV**

   


### No Doc Update

#### VDSM

 - [BZ 1829348](https://bugzilla.redhat.com/show_bug.cgi?id=1829348) **lvm2 dependency on ppc64le need to stay on 7.6**

   


#### oVirt Engine

 - [BZ 1827039](https://bugzilla.redhat.com/show_bug.cgi?id=1827039) **Error retrieving OpenID userinfo [RHV clone - 4.3.10]**

   

 - [BZ 1817450](https://bugzilla.redhat.com/show_bug.cgi?id=1817450) **host_service.install() does not work with deploy_hosted_engine as True. [RHV clone - 4.3.10]**

   


#### Contributors

20 people contributed to this release:

	Ahmad Khiet
	Artur Socha
	Benny Zlotnik
	Daniel Erez
	Dominik Holler
	Lev Veyde
	Liran Rotenberg
	Martin Necas
	Martin Perina
	Milan Zamazal
	Nir Levy
	Nir Soffer
	Ondra Machacek
	Ori Liel
	Radoslaw Szwajkowski
	Roberto Ciatti
	Sandro Bonazzola
	Steven Rosenberg
	Yedidyah Bar David
	Yuval Turgeman

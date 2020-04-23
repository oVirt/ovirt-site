---
title: oVirt 4.3.10 Release Notes
category: documentation
authors: sandrobonazzola, lveyde
toc: true
---

<style>
h1, h2, h3, h4, h5, h6, li, a, p {
    font-family: 'Open Sans', sans-serif !important;
}
</style>

# oVirt 4.3.10 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.10 First Release Candidate as of April 23, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.7 and
CentOS Linux 7.7 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
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

To learn about features introduced before 4.3.10, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm)



## What's New in 4.3.10?

### Enhancements

#### oVirt Engine

 - [BZ 1717336](https://bugzilla.redhat.com/1717336) **[downstream clone - 4.3.6] [RFE] OVF_STORE last update not exposed in the UI**

   


### Bug Fixes

#### VDSM

 - [BZ 1819721](https://bugzilla.redhat.com/1819721) **Regression in Migration of VM that starts in pause mode: took 11 hours**


#### oVirt Engine

 - [BZ 1820642](https://bugzilla.redhat.com/1820642) **[cinderlib] Cinderlib DB is missing a backup and restore option [RHV clone - 4.3.10]**

 - [BZ 1796136](https://bugzilla.redhat.com/1796136) **[cloned ]RHV 4.3 landing page does not show login or allow scrolling.**


### Other

#### imgbased

 - [BZ 1812574](https://bugzilla.redhat.com/1812574) **imgbase layout --init failed during the kickstart installation**

   


#### oVirt Engine

 - [BZ 1825740](https://bugzilla.redhat.com/1825740) **[OVN] ovirt sync to ovirt-provider-ovn breaks on upgrade of ovirt-engine-4.2.8.9-0.1.el7ev.noarch to ovirt-engine-4.3.9.4-11.el7.noarch**

   

 - [BZ 1815411](https://bugzilla.redhat.com/1815411) **Disable usage of Ansible 2.10 for RHV**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1817450](https://bugzilla.redhat.com/1817450) **host_service.install() does not work with deploy_hosted_engine as True. [RHV clone - 4.3.10]**

   


#### Contributors

10 people contributed to this release:

	Ahmad Khiet
	Dominik Holler
	Lev Veyde
	Martin Necas
	Milan Zamazal
	Nir Levy
	Ori Liel
	Radoslaw Szwajkowski
	Yedidyah Bar David
	Yuval Turgeman

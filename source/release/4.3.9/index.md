---
title: oVirt 4.3.9 Release Notes
category: documentation
toc: true
authors: sandrobonazzola, lveyde
page_classes: releases
---

# oVirt 4.3.9 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.9 release as of March 19, 2020.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.7 and
CentOS Linux 7.7 (or similar).



If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.3.9, see the
[release notes for previous versions](/documentation/#previous-release-notes).



## What's New in 4.3.9?

### Enhancements

#### oVirt Engine

 - [BZ 1797496](https://bugzilla.redhat.com/1797496) **Add RHCOS os to osinfo - for compatability API between 4.3 to 4.4**

   Feature: 

Support Red Hat CoreOS



Reason: 

Red Hat CoreOS is a new operation system that used mostly for containers solution. This bug only introduce the new operation system as part of back compatibility for 4.3 clusters.



Result: 

It is possible to select Red Hat CoreOS operation system for a VM.


### Bug Fixes

#### oVirt Engine

 - [BZ 1808038](https://bugzilla.redhat.com/1808038) **Unable to change Graphical Console of HE VM. [RHV clone - 4.3.9]**

 - [BZ 1792874](https://bugzilla.redhat.com/1792874) **Hide partial engine-cleanup option [RHV clone - 4.3.9]**


#### VDSM

 - [BZ 1795726](https://bugzilla.redhat.com/1795726) **after_migration is not sent to the guest after migration [RHV clone - 4.3.9]**


### Other

#### oVirt Engine

 - [BZ 1801558](https://bugzilla.redhat.com/1801558) **/etc/ovirt-provider-ovn/logger.conf should be included in the backup**

   

 - [BZ 1797659](https://bugzilla.redhat.com/1797659) **[API]Have a generic way to initialize a VM in run-once**

   

 - [BZ 1809470](https://bugzilla.redhat.com/1809470) **[HE] ovirt-provider-ovn is non-functional on 4.3.9 Hosted-Engine [RHV clone - 4.3.9]**

   


#### oVirt Host Deploy

 - [BZ 1613291](https://bugzilla.redhat.com/1613291) **[text] log says ovirt-ha-agent is starting after HE undeploy but it's actually being disabled and stopped**

   


#### oVirt Hosted Engine Setup

 - [BZ 1798834](https://bugzilla.redhat.com/1798834) **Hosted engine redeploy failed at "Add IPv4 outbound route rules" ansible task.**

   


#### oVirt Engine Metrics

 - [BZ 1797023](https://bugzilla.redhat.com/1797023) **In RHV Metric Store, installer vm does not take the static ip mentioned in the configuration file**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1789737](https://bugzilla.redhat.com/1789737) **Import of OVA created from template fails with java.lang.NullPointerException [RHV clone - 4.3.9]**

   

 - [BZ 1782185](https://bugzilla.redhat.com/1782185) **Accessing Storage > Volumes  does not work**

   


#### Contributors

23 people contributed to this release:

	Amit Bawer
	Andrej Krejcir
	Artur Socha
	Asaf Rachmani
	Dominik Holler
	Eli Mesika
	Evgeny Slutsky
	Gal Zaidman
	Lev Veyde
	Liran Rotenberg
	Marcin Sobczyk
	Martin Perina
	Milan Zamazal
	Nir Soffer
	Ori_Liel
	Ravi Nori
	Sandro Bonazzola
	Shani Leviim
	Sharon Gratch
	Shirly Radco
	Simone Tiraboschi
	Vojtech Juranek
	Yedidyah Bar David
	emesika

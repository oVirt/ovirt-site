---
title: oVirt 4.3.8 Release Notes
category: documentation
toc: true
authors: lveyde,sandrobonazzola
---

<style>
h1, h2, h3, h4, h5, h6, li, a, p {
    font-family: 'Open Sans', sans-serif !important;
}
</style>

# oVirt 4.3.8 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.8 release as of January 27, 2020.

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

To learn about features introduced before 4.3.8, see the
[release notes for previous versions](/documentation/#previous-release-notes).



## What's New in 4.3.8?

### Enhancements

#### oVirt Engine Metrics

 - [BZ 1782412](https://bugzilla.redhat.com/1782412) **[RFE] RHV+Metrics Store - Support a Flat DNS environment without subdomains**

   Feature: 

RHV+Metrics Store - Support a Flat DNS environment without subdomains



Reason:

For some users, security policy mandates that they maintain a "flat" DNS environment \-- no submains.



Result: 

This fix adds an option to add a suffix to master0 VM.



Example:

If user sets 'openshift_ovirt_machine_suffix' to 'prod' and

'public_hosted_zone' is 'example.com',

Then the metrics store vm will be called 'master-prod0.example.com'.

 - [BZ 1727546](https://bugzilla.redhat.com/1727546) **[RFE] Add cleanup option to oVirt metrics playbook**

   Feature: 

Add cleanup option to oVirt metrics playbook



Reason: 

User that desided to remove the metrics store requires disabling Collectd, Fluentd (if in 4.2) and setting Rsyslog to default settings or they will get errors for these services on all hosts and engine, once they delete the Metrics store VM.



Result: 

It is now possible to run playbook for handling the services:

./configure_ovirt_machines_for_metrics.sh --playbook=cleanup-ovirt-metrics.yml -vvv


### Bug Fixes

#### VDSM

 - [BZ 1780290](https://bugzilla.redhat.com/1780290) **Host goes non-operational post upgrading that host from RHHI-V 1.6 to RHHI-V 1.7**


#### oVirt Engine Data Warehouse

 - [BZ 1761494](https://bugzilla.redhat.com/1761494) **dwh-vacuum fails with 'vacuumdb: command not found'**


#### oVirt Engine

 - [BZ 1779664](https://bugzilla.redhat.com/1779664) **MERGE_STATUS fails with 'Invalid UUID string: mapper' when Direct LUN that already exists is hot-plugged [RHV clone - 4.3.8]**

 - [BZ 1773704](https://bugzilla.redhat.com/1773704) **engine-cleanup is removing all files listed in "uninstall.conf" irrespective of the options provided**


#### IOProcess

 - [BZ 1780290](https://bugzilla.redhat.com/1780290) **Host goes non-operational post upgrading that host from RHHI-V 1.6 to RHHI-V 1.7**


### Other

#### VDSM

 - [BZ 1748022](https://bugzilla.redhat.com/1748022) **Enable gluster 4k support**

   


#### imgbased

 - [BZ 1780331](https://bugzilla.redhat.com/1780331) **Firewalld service not enabled/running after RHV-H upgrade**

   

 - [BZ 1765250](https://bugzilla.redhat.com/1765250) **After upgrade RHVH did not boot into latest layer by default on UEFI machine.**

   

 - [BZ 1779661](https://bugzilla.redhat.com/1779661) **grubenv file is broken in the UEFI RHV-H hosts**

   


#### oVirt Provider OVN

 - [BZ 1764946](https://bugzilla.redhat.com/1764946) **ovirt-provider-ovn accepts anonymous TLS cipher suites (security)**

   


#### oVirt Engine Metrics

 - [BZ 1711873](https://bugzilla.redhat.com/1711873) **RFE for offline installation  of RHV Metrics Store**

   

 - [BZ 1780234](https://bugzilla.redhat.com/1780234) **Metric Store reports all hosts in Default cluster regardless of cluster assignment.**

   


#### oVirt Cockpit Plugin

 - [BZ 1723728](https://bugzilla.redhat.com/1723728) **Remove the VDO option to emulate 512**

   


#### oVirt image transfer daemon and proxy

 - [BZ 1786950](https://bugzilla.redhat.com/1786950) **Block size detection is unsafe with multiple connections**

   


### No Doc Update

#### oVirt Engine

 - [BZ 1781380](https://bugzilla.redhat.com/1781380) **Rest API for creating affinity group with labels is resulted with the group created with missing labels [RHV clone - 4.3.8]**

   


#### Contributors

23 people contributed to this release:

	Andrej Krejcir
	Daniel Erez
	Dominik Holler
	Eyal Shenitzky
	Fabien Dupont
	Gal Zaidman
	Gobinda Das
	Lev Veyde
	Martin Kletzander
	Miguel Duarte Barroso
	Milan Zamazal
	Nenad Peric
	Nir Soffer
	Ondra Machacek
	Pino Toscano
	Sandro Bonazzola
	Shani Leviim
	Shirly Radco
	Simone Tiraboschi
	Tal Nisan
	Tomáš Golembiovský
	Yedidyah Bar David
	Yuval Turgeman

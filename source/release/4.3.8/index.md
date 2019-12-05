---
title: oVirt 4.3.8 Release Notes
category: documentation
layout: toc
authors: Lev Veyde
---

<style>
h1, h2, h3, h4, h5, h6, li, a, p {
    font-family: 'Open Sans', sans-serif !important;
}
</style>

# oVirt 4.3.8 Release Notes

The oVirt Project is pleased to announce the availability of the 4.3.8 First Release Candidate as of December 05, 2019.

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

To learn about features introduced before 4.3.8, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release43-pre.rpm)



## What's New in 4.3.8?

### Enhancements

#### oVirt Engine Metrics

 - [BZ 1727546](https://bugzilla.redhat.com/1727546) <b>[RFE] Add cleanup option to oVirt metrics playbook</b><br>Feature: <br>Add cleanup option to oVirt metrics playbook<br><br>Reason: <br>User that desided to remove the metrics store requires disabling Collectd, Fluentd (if in 4.2) and setting Rsyslog to default settings or they will get errors for these services on all hosts and engine, once they delete the Metrics store VM.<br><br>Result: <br>It is now possible to run playbook for handling the services:<br>./configure_ovirt_machines_for_metrics.sh --playbook=cleanup-ovirt-metrics.yml -vvv

### Bug Fixes

#### oVirt Engine Data Warehouse

 - [BZ 1761494](https://bugzilla.redhat.com/1761494) <b>dwh-vacuum fails with 'vacuumdb: command not found'</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1764946](https://bugzilla.redhat.com/1764946) <b>ovirt-provider-ovn accepts anonymous TLS cipher suites (security)</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1723728](https://bugzilla.redhat.com/1723728) <b>Remove the VDO option to emulate 512</b><br>

#### Contributors

12 people contributed to this release:

	Fabien Dupont
	Gal Zaidman
	Gobinda Das
	Martin Kletzander
	Miguel Duarte Barroso
	Milan Zamazal
	Nenad Peric
	Pino Toscano
	Sandro Bonazzola
	Shirly Radco
	Tomáš Golembiovský
	Yedidyah Bar David

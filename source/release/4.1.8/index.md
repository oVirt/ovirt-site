---
title: oVirt 4.1.8 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.1.8 Release Notes

The oVirt Project is pleased to announce the availability of the 4.1.8
release as of December 11, 2017.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).

If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.1.8, see the [release notes for previous versions](/documentation/#previous-release-notes).



### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.1.8?

### Release Note

#### VDSM

 - [BZ 1513886](https://bugzilla.redhat.com/show_bug.cgi?id=1513886) <b>[downstream clone - 4.1.8] [RFE] Enable TLSv12 support by default</b><br>This update ensures that TLSv12 support is enabled by default and no manual configuration is required.

### Enhancements

#### oVirt Engine Dashboard

 - [BZ 1504691](https://bugzilla.redhat.com/show_bug.cgi?id=1504691) <b>[downstream clone - 4.1.8] [RFE] Create a Refresh button on Dashboard in Manager UI</b><br>In this release, a refresh button has been added to the Dashboard tab in the Administration <br>Portal to enable users to view up-to-date system summary information.

#### oVirt Release Package

 - [BZ 1516194](https://bugzilla.redhat.com/show_bug.cgi?id=1516194) <b>[downstream clone - 4.1.8] [RFE] Provide IdM client software in RHVH</b><br>The ipa-client package is now installed on hosts, and is included in the Red Hat Virtualization Host image. This enables Cockpit certificate signing and SSO with Red Hat IdM, and adding the host to an IdM realm.

#### oVirt Engine

 - [BZ 1501793](https://bugzilla.redhat.com/show_bug.cgi?id=1501793) <b>[downstream clone - 4.1.8] [RFE] Indicate host needs to be reinstalled to push new configurations.</b><br>There are several cluster and host settings which require reinstallation of the host if changed. The requirement to reinstall was always mentioned in documentation and a WARNING event was raised. With this release, the Administration Portal now also shows an exclamation mark icon for each host that needs to be reinstalled. When an exclamation mark icon is shown, you can find the details about it in the Action Items section of the host's details view.
 - [BZ 1505576](https://bugzilla.redhat.com/show_bug.cgi?id=1505576) <b>Cannot specify proper CPU topology for 4-socket broadwell (24 cores per socket)</b><br>Feature: <br>Support more than 16 cores per socket<br><br>Reason: <br>Modern CPUs do support more, qemu does not have problem with that, this restriction just artificially constrained the user to create a virtual HW which matches the physical<br><br>Result: <br>254 cores per socket is now supported.

#### oVirt Engine Metrics

 - [BZ 1506458](https://bugzilla.redhat.com/show_bug.cgi?id=1506458) <b>[RFE] Add support for fluent-plugin-elasticsearch and use it as default</b><br>Feature: <br>Update fluentd client role to send data from the fluentd on the hosts directly to elasticsearch, by default instead of the central fluentd(mux).<br><br><br><br>Reason: <br>Sending the metrics data and logs data to the central fluentd(mux) had performance issues.<br><br>Result: <br>This required adding support to configure the fluent-plugin-elasticsearch plugin. It will be the default output plugin.
 - [BZ 1475900](https://bugzilla.redhat.com/show_bug.cgi?id=1475900) <b>[RFE] Collect the logs from vdsm.log to the metrics store</b><br>Feature: <br>Collect the logs from vdsm.log to the metrics store<br><br>Reason: <br>In order to allow the users a common logging where they can explore both vdsm and engine logs.<br><br>Result:<br>vdsm.log is now collected to the metric store from each host.
 - [BZ 1506174](https://bugzilla.redhat.com/show_bug.cgi?id=1506174) <b>Add README to ovirt-engine-metrics ansible roles</b><br>

#### oVirt Engine Extension AAA-LDAP

 - [BZ 1489402](https://bugzilla.redhat.com/show_bug.cgi?id=1489402) <b>Provide an example for kerberos authentication between aaa-ldap and LDAP server</b><br>Feature: <br><br>Following examples has been added:<br><br> * Using GSSAPI to authenticate against IPA<br> * Using GSSAPI with ticket cache to authenticate against IPA<br><br>More details about those examples can be found at README.md [1] which is also included inside the package<br><br>[1] https://github.com/oVirt/ovirt-engine-extension-aaa-ldap/blob/master/examples/README.md<br><br>Reason: <br><br>Result:

#### oVirt Host Dependencies

 - [BZ 1516194](https://bugzilla.redhat.com/show_bug.cgi?id=1516194) <b>[downstream clone - 4.1.8] [RFE] Provide IdM client software in RHVH</b><br>The ipa-client package is now installed on hosts, and is included in the Red Hat Virtualization Host image. This enables Cockpit certificate signing and SSO with Red Hat IdM, and adding the host to an IdM realm.

### Rebase: Enhancementss Only

#### oVirt Log collector

 - [BZ 1512308](https://bugzilla.redhat.com/show_bug.cgi?id=1512308) <b>[downstream clone - 4.1.8] [RFE] option to collect logs from one host per cluster</b><br>This is a rebase of the package to version 4.1.7. A notable enhancement is an option has been added to collect logs from one host per cluster.

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Release Package

 - [BZ 1506262](https://bugzilla.redhat.com/show_bug.cgi?id=1506262) <b>Provide ovirt-host package in 4.1</b><br>

### Bug Fixes

#### VDSM

 - [BZ 1506503](https://bugzilla.redhat.com/show_bug.cgi?id=1506503) <b>[downstream clone - 4.1.8] Cold merge will fail if the base qcow2 image reports leaked cluster</b><br>

#### oVirt Engine

 - [BZ 1513684](https://bugzilla.redhat.com/show_bug.cgi?id=1513684) <b>[downstream clone - 4.1.8] [API] Cannot clear vm initialization via api</b><br>

#### imgbased

 - [BZ 1501047](https://bugzilla.redhat.com/show_bug.cgi?id=1501047) <b>Upgrading node brings back deleted network configuration files</b><br>

### Other

#### VDSM

 - [BZ 1515124](https://bugzilla.redhat.com/show_bug.cgi?id=1515124) <b>qemu coredumps are not generated properly</b><br>
 - [BZ 1520953](https://bugzilla.redhat.com/show_bug.cgi?id=1520953) <b>Require libvirt-daemon-kvm-3.2.0-14.el7_4.5 for CentOS</b><br>
 - [BZ 1506157](https://bugzilla.redhat.com/show_bug.cgi?id=1506157) <b>[BLOCKED][downstream clone - 4.1.8] During a Live Merge, VDSM still saw a block job, even though libvirt's block job had completed.</b><br>
 - [BZ 1509614](https://bugzilla.redhat.com/show_bug.cgi?id=1509614) <b>[downstream clone - 4.1.8] "No such drive" error on live merge of one disk causes merge of other disk to fail on engine.</b><br>

#### oVirt Engine

 - [BZ 1504118](https://bugzilla.redhat.com/show_bug.cgi?id=1504118) <b>[downstream clone - 4.1.8] Engine fails with java.lang.OutOfMemoryError making all hosts non responsive</b><br>
 - [BZ 1488839](https://bugzilla.redhat.com/show_bug.cgi?id=1488839) <b>glusterd service is not stopped during RHEL7 as hypervisor upgrade.</b><br>
 - [BZ 1509270](https://bugzilla.redhat.com/show_bug.cgi?id=1509270) <b>[downstream clone - 4.1.8] host_nic_vfs_config is not populated if parent pci device of nic is shared with another device</b><br>
 - [BZ 1481221](https://bugzilla.redhat.com/show_bug.cgi?id=1481221) <b>[Webadmin] LUNs listings are being multiplied by the number of their paths in direct LUN creation prompt in case they have storage domain on them</b><br>
 - [BZ 1466326](https://bugzilla.redhat.com/show_bug.cgi?id=1466326) <b>cannot import storage storage domain when 'use manage gluster volume'  feature is used.</b><br>
 - [BZ 1514901](https://bugzilla.redhat.com/show_bug.cgi?id=1514901) <b>Avoid preparing and tearing down images during create snapshot while the VM isn't down</b><br>
 - [BZ 1512989](https://bugzilla.redhat.com/show_bug.cgi?id=1512989) <b>Add support to retrieve session by token</b><br>
 - [BZ 1511335](https://bugzilla.redhat.com/show_bug.cgi?id=1511335) <b>[downstream clone - 4.1.8] Bookmarks are not sorted after upgrade</b><br>
 - [BZ 1506191](https://bugzilla.redhat.com/show_bug.cgi?id=1506191) <b>Can not get fence status from REST API</b><br>

#### oVirt Engine Metrics

 - [BZ 1490258](https://bugzilla.redhat.com/show_bug.cgi?id=1490258) <b>fluentd produces warnings for each line processed for engine.log</b><br>

#### oVirt Engine Extension AAA-LDAP

 - [BZ 1383862](https://bugzilla.redhat.com/show_bug.cgi?id=1383862) <b>ovirt-engine-extension-aaa-ldap AD integration with LDAPS fails at the Login test sequence</b><br>
 - [BZ 1465463](https://bugzilla.redhat.com/show_bug.cgi?id=1465463) <b>Active Directory - Unexpected comma or semicolon found at the end of the DN string</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1513620](https://bugzilla.redhat.com/show_bug.cgi?id=1513620) <b>Evm.log contains passwords</b><br>
 - [BZ 1509910](https://bugzilla.redhat.com/show_bug.cgi?id=1509910) <b>Don't send `Expect: 100-Continue` for PUT requests</b><br>
 - [BZ 1508944](https://bugzilla.redhat.com/show_bug.cgi?id=1508944) <b>[RFE] Add support for connect timeout</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1504118](https://bugzilla.redhat.com/show_bug.cgi?id=1504118) <b>[downstream clone - 4.1.8] Engine fails with java.lang.OutOfMemoryError making all hosts non responsive</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1512850](https://bugzilla.redhat.com/show_bug.cgi?id=1512850) <b>Unable to boot VM from CD-ROM</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1516203](https://bugzilla.redhat.com/show_bug.cgi?id=1516203) <b>[downstream clone - 4.1.8] hosted engine agent is not able to refresh hosted engine status when iso domain is not available after network outage</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1501385](https://bugzilla.redhat.com/show_bug.cgi?id=1501385) <b>Remove shard-block-size value from generated gdeploy conf file</b><br>
 - [BZ 1469469](https://bugzilla.redhat.com/show_bug.cgi?id=1469469) <b>Rename the usage of disable-multipath.sh script to blacklist_all_disks.sh</b><br>
 - [BZ 1462082](https://bugzilla.redhat.com/show_bug.cgi?id=1462082) <b>path for the gdeploy script files in the generated gdeploy conf has to be changed.</b><br>

### No Doc Update

#### oVirt Engine Dashboard

 - [BZ 1512574](https://bugzilla.redhat.com/show_bug.cgi?id=1512574) <b>dropdown menu for refresh interval in dashboard is not visible</b><br>

#### oVirt Engine

 - [BZ 1518894](https://bugzilla.redhat.com/show_bug.cgi?id=1518894) <b>Tables: when starting to change the width of a column, the column right edge jumps suddenly to the right from the mouse pointer position</b><br>

#### oVirt provider OVN

 - [BZ 1491546](https://bugzilla.redhat.com/show_bug.cgi?id=1491546) <b>vdsm-tool does not start required services before configuring the host</b><br>


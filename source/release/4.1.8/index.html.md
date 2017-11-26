---
title: oVirt 4.1.8 Release Notes
category: documentation
layout: toc
---

# oVirt 4.1.8 Release Notes

The oVirt Project is pleased to announce the availability of the 4.1.8
Third Release Candidate
 as of November 26, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.1.8, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.1.8?

### Release Note

#### VDSM

 - [BZ 1513886](https://bugzilla.redhat.com/1513886) <b>[downstream clone - 4.1.8] [RFE] Enable TLSv12 support by default</b><br>We have backported TLSv12 support into RHV 4.1.5 (BZ1412552), but it was turned off by default and enabling TLSv12 required manual configuration. With this fix TLSv12 support is enabled by default and no manual configuration is required.

### Enhancements

#### oVirt Engine Dashboard

 - [BZ 1504691](https://bugzilla.redhat.com/1504691) <b>[downstream clone - 4.1.8] [RFE] Create a Refresh button on Dashboard in Manager UI</b><br>Feature: Add a manual refresh button to the dashboard UI to update the display with currently available system summary information.

#### oVirt Release Package

 - [BZ 1516194](https://bugzilla.redhat.com/1516194) <b>[downstream clone - 4.1.8] [RFE] Provide IdM client software in RHVH</b><br>

#### oVirt Engine

 - [BZ 1501793](https://bugzilla.redhat.com/1501793) <b>[downstream clone - 4.1.8] [RFE] Indicate host needs to be reinstalled to push new configurations.</b><br>There are several settings of a cluster or host which require reinstallation of a host if those settings are changed:<br><br> I. Host with changed settings needs to be reinstalled<br>   1. Turning on/off Kdump integration<br>   2. Changing command line parameters<br><br>The requirement to reinstall was always mentioned in documentation and also WARNING event is raised.<br><br>Unfortunately it was not enough, so no we also show an exclamation mark icon for each host that needs to be reinstalled. When exclamation mark icon is shown, you can find the details about it in Host detail view within Action Items section.
 - [BZ 1484404](https://bugzilla.redhat.com/1484404) <b>fence_drac5 requires specifying custom SSH options to work properly</b><br>Feature: allow for key=key=value format (where the value of a fence option key is itself in a key=value format) in fence agent options <br><br>Reason: support some old drac5 devices that should add <br> ssh_options=-oCiphers=+3des-cbc<br>to the Options field to enable no-longer-enabled-insecure ciphers for SSH connection<br><br>Result: <br>You can use a format of key=key=value in the fence agent options field from UI and API

#### oVirt Engine Metrics

 - [BZ 1506458](https://bugzilla.redhat.com/1506458) <b>[RFE] Add support for fluent-plugin-elasticsearch and use it as default</b><br>Feature: <br>Update fluentd client role to send data from the fluentd on the hosts directly to elasticsearch, by default instead of the central fluentd(mux).<br><br><br><br>Reason: <br>Sending the metrics data and logs data to the central fluentd(mux) had performance issues.<br><br>Result: <br>This required adding support to configure the fluent-plugin-elasticsearch plugin. It will be the default output plugin.
 - [BZ 1475900](https://bugzilla.redhat.com/1475900) <b>[RFE] Collect the logs from vdsm.log to the metrics store</b><br>Feature: <br>Collect the logs from vdsm.log to the metrics store<br><br>Reason: <br>In order to allow the users a common logging where they can explore both vdsm and engine logs.<br><br>Result:<br>vdsm.log is now collected to the metric store from each host.
 - [BZ 1506174](https://bugzilla.redhat.com/1506174) <b>Add README to ovirt-engine-metrics ansible roles</b><br>

#### oVirt Engine Extension AAA-LDAP

 - [BZ 1489402](https://bugzilla.redhat.com/1489402) <b>Provide an example for kerberos authentication between aaa-ldap and LDAP server</b><br>Feature: <br><br>Following examples has been added:<br><br> * Using GSSAPI to authenticate against IPA<br> * Using GSSAPI with ticket cache to authenticate against IPA<br><br>More details about those examples can be found at README.md [1] which is also included inside the package<br><br>[1] https://github.com/oVirt/ovirt-engine-extension-aaa-ldap/blob/master/examples/README.md<br>

#### oVirt Host Dependencies

 - [BZ 1516194](https://bugzilla.redhat.com/1516194) <b>[downstream clone - 4.1.8] [RFE] Provide IdM client software in RHVH</b><br>

### Rebase: Enhancementss Only

#### oVirt Log collector

 - [BZ 1512308](https://bugzilla.redhat.com/1512308) <b>[downstream clone - 4.1.8] [RFE] option to collect logs from one host per cluster</b><br>Rebase package(s) to version: 4.1.7<br><br>Highlights and notable enhancements: added option to collect logs from one host per cluster

### Rebase: Bug Fixeses and Enhancementss

#### oVirt Release Package

 - [BZ 1506262](https://bugzilla.redhat.com/1506262) <b>Provide ovirt-host package in 4.1</b><br>

### Bug Fixes

#### VDSM

 - [BZ 1506503](https://bugzilla.redhat.com/1506503) <b>[downstream clone - 4.1.8] Cold merge will fail if the base qcow2 image reports leaked cluster</b><br>

#### oVirt Engine

 - [BZ 1513684](https://bugzilla.redhat.com/1513684) <b>[downstream clone - 4.1.8] [API] Cannot clear vm initialization via api</b><br>

### Other

#### VDSM

 - [BZ 1509614](https://bugzilla.redhat.com/1509614) <b>[downstream clone - 4.1.8] "No such drive" error on live merge of one disk causes merge of other disk to fail on engine.</b><br>

#### oVirt Engine

 - [BZ 1504118](https://bugzilla.redhat.com/1504118) <b>[downstream clone - 4.1.8] Engine fails with java.lang.OutOfMemoryError making all hosts non responsive</b><br>
 - [BZ 1488839](https://bugzilla.redhat.com/1488839) <b>glusterd service is not stopped during RHV-H upgrade.</b><br>
 - [BZ 1509270](https://bugzilla.redhat.com/1509270) <b>[downstream clone - 4.1.8] host_nic_vfs_config is not populated if parent pci device of nic is shared with another device</b><br>
 - [BZ 1481221](https://bugzilla.redhat.com/1481221) <b>[Webadmin] LUNs listings are being multiplied by the number of their paths in direct LUN creation prompt in case they have storage domain on them</b><br>
 - [BZ 1466326](https://bugzilla.redhat.com/1466326) <b>cannot import storage storage domain when 'use manage gluster volume'  feature is used.</b><br>
 - [BZ 1367700](https://bugzilla.redhat.com/1367700) <b>Display a warning if user tries to create multiple bricks on the same server during replace-brick.</b><br>
 - [BZ 1505576](https://bugzilla.redhat.com/1505576) <b>Cannot specify proper CPU topology for 4-socket broadwell (24 cores per socket)</b><br>
 - [BZ 1514901](https://bugzilla.redhat.com/1514901) <b>Avoid preparing and tearing down images during create snapshot while the VM isn't down</b><br>
 - [BZ 1512989](https://bugzilla.redhat.com/1512989) <b>Add support to retrieve session by token</b><br>
 - [BZ 1511335](https://bugzilla.redhat.com/1511335) <b>[downstream clone - 4.1.8] Bookmarks are not sorted after upgrade</b><br>
 - [BZ 1506191](https://bugzilla.redhat.com/1506191) <b>Can not get fence status from REST API</b><br>

#### oVirt Engine Metrics

 - [BZ 1490258](https://bugzilla.redhat.com/1490258) <b>fluentd produces warnings for each line processed for engine.log</b><br>

#### oVirt Engine Extension AAA-LDAP

 - [BZ 1383862](https://bugzilla.redhat.com/1383862) <b>ovirt-engine-extension-aaa-ldap AD integration with LDAPS fails at the Login test sequence</b><br>
 - [BZ 1465463](https://bugzilla.redhat.com/1465463) <b>Active Directory - Unexpected comma or semicolon found at the end of the DN string</b><br>

#### oVirt Engine SDK 4 Ruby

 - [BZ 1513620](https://bugzilla.redhat.com/1513620) <b>Evm.log contains passwords</b><br>
 - [BZ 1509910](https://bugzilla.redhat.com/1509910) <b>Don't send `Expect: 100-Continue` for PUT requests</b><br>
 - [BZ 1508944](https://bugzilla.redhat.com/1508944) <b>[RFE] Add support for connect timeout</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1504118](https://bugzilla.redhat.com/1504118) <b>[downstream clone - 4.1.8] Engine fails with java.lang.OutOfMemoryError making all hosts non responsive</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1512850](https://bugzilla.redhat.com/1512850) <b>Unable to boot VM from CD-ROM</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1516203](https://bugzilla.redhat.com/1516203) <b>[downstream clone - 4.1.8] hosted engine agent is not able to refresh hosted engine status when iso domain is not available after network outage</b><br>

### No Doc Update

#### oVirt Engine Dashboard

 - [BZ 1512574](https://bugzilla.redhat.com/1512574) <b>dropdown menu for refresh interval in dashboard is not visible</b><br>

#### oVirt provider OVN

 - [BZ 1491546](https://bugzilla.redhat.com/1491546) <b>vdsm-tool does not start required services before configuring the host</b><br>

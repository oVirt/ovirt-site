---
title: oVirt 4.1.6 Release Notes
category: documentation
layout: toc
---

# oVirt 4.1.6 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.6
Second Release Candidate as
of August 31, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).


This is pre-release software.
Please take a look at our [community page](/community/) to know how to
ask questions and interact with developers and users.
All issues or bugs should be reported via the
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.1.6, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.


In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


and then follow our
[Installation guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)



### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/)

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the epel repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS OpsTools SIG repos, for other packages.

EPEL currently includes collectd 5.7.1, and the collectd package there includes
the write_http plugin.

OpsTools currently includes collectd 5.7.0, and the write_http plugin is
packaged separately.

ovirt-release does not use collectd from epel, so if you only use it, you
should be ok.

If you want to use other packages from EPEL, you should make sure to not
include collectd. Either use `includepkgs` and add those you need, or use
`exclude=collectd*`.


## What's New in 4.1.6?

### Enhancements

#### oVirt Hosted Engine Setup

 - [BZ 1481095](https://bugzilla.redhat.com/1481095) <b>[downstream clone - 4.1.6] [bug] hosted-engine yum repo required, but rpm-based install optional</b><br>Feature: <br>Provide path to Appliance OVF<br><br>Reason: <br>This feature is supported according to RedHat customer portal, but dropped in the past for some reason<br><br>Result: <br>User can provide path to appliance OVA instead of installing appliance RPM

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1472254](https://bugzilla.redhat.com/1472254) <b>[downstream clone - 4.1.6] [RFE] - AD domain configuration is not supported in ovirt-engine-extension-aaa-ldap-setup, provide examples how to configure AD domain</b><br>When configuring Active Directory (AD) with the ovirt-engine-extension-aaa-ldap-setup tool, whether you are defining a multiple or single domain forest, you can only configure the name of the forest - you cannot define the name of a specific domain or a specific server.<br><br>This release provides examples for common advanced AD configuration which users can copy to their local environment and adapt as required. These examples are bundled within the ovirt-engine-extension-aaa-ldap package and after installing the package, a description of these examples can be found in /usr/share/ovirt-engine-extension-aaa-ldap/examples/README.md<br><br>In addition, the following improvements have been made to the ovirt-engine-extension-aaa-ldap-setup tool:<br><br>1. More detailed error reporting for various AD forest configuration steps.<br>2. A mandatory login test to check the configuration (previously this test was optional).

### Release Note

#### oVirt Web UI

 - [BZ 1485814](https://bugzilla.redhat.com/1485814) <b>Release notes for ovirt-web-ui 1.2.1</b><br>Changes since VM Portal 1.1.0:<br><br>- ability to change virtual machine's CD-ROM ISO<br>- infinite scroller for VMS list added to decrease response time<br>- "Runs on Host" - hyperlink to the host running particular virtual machine<br>- Added "Loading ..." indicator of background activity<br>- "Pending Changes" tag rendered when NEXT_RUN configuration exists<br>- "VM Type" field added<br>- error messages improved<br>- "usb-filter" in .vv file for remote-viewer<br>- setting of VM icon fixed<br>- multiple additional functional & UI fixes<br>- app supports branding<br>- basics for internationalization, but translation not yet provided<br>- built as a "noarch" rpm

### Unclassified

#### oVirt Release Package

 - [BZ 1484610](https://bugzilla.redhat.com/1484610) <b>ovirt-vmconsole-host-sshd service is not started automatically after upgrade</b><br>

#### oVirt Engine

 - [BZ 1478823](https://bugzilla.redhat.com/1478823) <b>openstacknet driver should not run on external network nics (conflicts with OVN)</b><br>
 - [BZ 1479677](https://bugzilla.redhat.com/1479677) <b>[RFE] - LLDP protocol REST API support</b><br>
 - [BZ 1445235](https://bugzilla.redhat.com/1445235) <b>Storage subtab is unsorted and keeps sorting its items</b><br>
 - [BZ 1486293](https://bugzilla.redhat.com/1486293) <b>[downstream clone - 4.1.6] Frequent traceback on MetadataDiskDescriptionHandler</b><br>
 - [BZ 1483889](https://bugzilla.redhat.com/1483889) <b>Custom Id is not persisted to the database</b><br>
 - [BZ 1485804](https://bugzilla.redhat.com/1485804) <b>[downstream clone - 4.1.6] Unable to Import a VM linked with its template to RHV 4.1 from export domain imported of RHEV 3.5</b><br>
 - [BZ 1484762](https://bugzilla.redhat.com/1484762) <b>Allow changing type details in fn_db_change_column_type without changing the actual type</b><br>
 - [BZ 1451501](https://bugzilla.redhat.com/1451501) <b>Role UserVmManager is not set on imported VMs</b><br>
 - [BZ 1479693](https://bugzilla.redhat.com/1479693) <b>AuditLogDirector does not log messages if transactional command fails</b><br>
 - [BZ 1482569](https://bugzilla.redhat.com/1482569) <b>Force remove of a storage domain should release MAC addresses only for VMs which are removed from the setup</b><br>

#### VDSM

 - [BZ 1479677](https://bugzilla.redhat.com/1479677) <b>[RFE] - LLDP protocol REST API support</b><br>
 - [BZ 1432386](https://bugzilla.redhat.com/1432386) <b>static ip remain on the interface when removing non-vm network from it in case it has another vlan network attached</b><br>
 - [BZ 1482014](https://bugzilla.redhat.com/1482014) <b>vdsmd fails to start if system time moves backwards during boot</b><br>

#### ovirt-engine-extension-aaa-ldap

 - [BZ 1482940](https://bugzilla.redhat.com/1482940) <b>[aaa-ldap-setup] Login sequence fails on setup</b><br>
 - [BZ 1476980](https://bugzilla.redhat.com/1476980) <b>AAA LDAP setup does not add baseDN to *-authn.properties</b><br>
 - [BZ 1462815](https://bugzilla.redhat.com/1462815) <b>Assume the user is going to use 'Single Sing-On for Virtual Machines'</b><br>

#### ovirt-engine-dwh

 - [BZ 1482043](https://bugzilla.redhat.com/1482043) <b>DWH error - value too long for type character varying(40)|1</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1486565](https://bugzilla.redhat.com/1486565) <b>[downstream clone - 4.1.6] Unable to drag and drop vNuma to the Numa nodes when using Internet Explorer version 11</b><br>
 - [BZ 1481115](https://bugzilla.redhat.com/1481115) <b>Downloading an image with backing files from the sdk is triggering disk deletion</b><br>

### VDSM

 - [BZ 1485807](https://bugzilla.redhat.com/1485807) <b>virt-v2v: trying to import a VM with unreachable cdrom device caused the import to fail with "disk storage error"</b><br>

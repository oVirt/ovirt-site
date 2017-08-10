---
title: oVirt 4.1.5 Release Notes
category: documentation
layout: toc
authors: lveyde,sandrobonazzola
---

# oVirt 4.1.5 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.5
Third Release Candidate as
of August 10, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).
Packages for Fedora 24 are also available as a Tech Preview.


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

To learn about features introduced before 4.1.5, see the [release notes for previous versions](/documentation/#previous-release-notes).


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


## What's New in 4.1.5?

### Deprecated Functionality

#### oVirt Engine

 - [BZ 1473179](https://bugzilla.redhat.com/1473179) <b>ovirt-engine-setup-plugin-dockerc is now deprecated</b><br>ovirt-engine-setup-plugin-dockerc is deprecated and will be removed in oVirt 4.2

### Enhancements

#### oVirt Release Package

 - [BZ 1364083](https://bugzilla.redhat.com/1364083) <b>[RFE] Provide ppc64le arch packages</b><br>With this update, oVirt Host related packages are now also available for ppc64le architecture.

#### oVirt Engine

 - [BZ 1022961](https://bugzilla.redhat.com/1022961) <b>Gluster: running a VM from a gluster domain should use gluster URI instead of a fuse mount</b><br>Feature: Added libgfapi support to the engine and vdsm<br><br>Reason: libgfapi provides VMs with faster access to the vm images, stored on a gluster volume, comparing with fuse interface.<br><br>Result: With 'LibgfApi' DC feature enabled or 'lubgfapi_supported' cluster level feature enabled, VMs will access their images, stored on gluster volumes, directly via libgfapi.

#### VDSM

 - [BZ 1022961](https://bugzilla.redhat.com/1022961) <b>Gluster: running a VM from a gluster domain should use gluster URI instead of a fuse mount</b><br>Feature: Added libgfapi support to the engine and vdsm<br><br>Reason: libgfapi provides VMs with faster access to the vm images, stored on a gluster volume, comparing with fuse interface.<br><br>Result: With 'LibgfApi' DC feature enabled or 'lubgfapi_supported' cluster level feature enabled, VMs will access their images, stored on gluster volumes, directly via libgfapi.

#### oVirt Engine Metrics

 - [BZ 1462500](https://bugzilla.redhat.com/1462500) <b>Add a check that ovirt_env_name is a valid OpenShift namespace identifier</b><br>Feature: <br>This adds a few checks to the ovirt_env_name, to make sure it is a valid OpenShift namespace identifier.<br><br>Reason: <br>ovirt_env_name must be a valid OpenShift namespace identifier in order for the records to be kept to the elasticsearch that is running in OpenShift.<br><br>Result: <br>Will fail the metrics script if the name is not valid.

#### oVirt Engine Extension AAA LDAP

 - [BZ 1472254](https://bugzilla.redhat.com/1472254) <b>[downstream clone - 4.1.5] [RFE] - AD domain configuration is not supported in ovirt-engine-extension-aaa-ldap-setup, provide examples how to configure AD domain</b><br>When configuring Active Directory (AD) with the ovirt-engine-extension-aaa-ldap-setup tool, whether you are defining a multiple or single domain forest, you can only configure the name of the forest - you cannot define the name of a specific domain or a specific server.<br><br>This release provides examples for common advanced AD configuration which users can copy to their local environment and adapt as required. These examples are bundled within the ovirt-engine-extension-aaa-ldap package and after installing the package, a description of these examples can be found in /usr/share/ovirt-engine-extension-aaa-ldap/examples/README.md<br><br>In addition, the following improvements have been made to the ovirt-engine-extension-aaa-ldap-setup tool:<br><br>1. More detailed error reporting for various AD forest configuration steps.<br>2. A mandatory login test to check the configuration (previously this test was optional).

#### oVirt Hosted Engine Setup

 - [BZ 1457357](https://bugzilla.redhat.com/1457357) <b>Allow editing all the shared storage configuration values</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1457357](https://bugzilla.redhat.com/1457357) <b>Allow editing all the shared storage configuration values</b><br>

### No Doc Update

#### oVirt Hosted Engine Setup

 - [BZ 1460982](https://bugzilla.redhat.com/1460982) <b>[downstream clone - 4.1.4] [TEXT] Error message is confusing when hosted-engine Storage Domain can't be mounted</b><br>

### Unclassified

#### oVirt Engine

 - [BZ 1477700](https://bugzilla.redhat.com/1477700) <b>Host enters to power management restart loop</b><br>
 - [BZ 1445235](https://bugzilla.redhat.com/1445235) <b>Storage subtab is unsorted and keeps sorting its items</b><br>
 - [BZ 1418156](https://bugzilla.redhat.com/1418156) <b>[ALL_LANGS] [Admin Portal]The text/UI alignment needs to adjusted on quota->add screen.</b><br>
 - [BZ 1454811](https://bugzilla.redhat.com/1454811) <b>[downstream clone - 4.1.5] No error pops when logging with a locked ovirt user account</b><br>
 - [BZ 1475272](https://bugzilla.redhat.com/1475272) <b>MAC addresses are not freed when a storage domain is destroyed from a data-center</b><br>
 - [BZ 1336708](https://bugzilla.redhat.com/1336708) <b>disk enumeration order in API don't match disk order in the qemu command line</b><br>
 - [BZ 1477042](https://bugzilla.redhat.com/1477042) <b>engine does not start due to trying to call non-existent callback.</b><br>
 - [BZ 1465859](https://bugzilla.redhat.com/1465859) <b>OVESETUP_ENGINE_CONFIG/fqdn value not getting logged in answerfile when installing remote dwh</b><br>
 - [BZ 1476744](https://bugzilla.redhat.com/1476744) <b>No validation on the storage_domain parameter when creating VM disks attachments</b><br>
 - [BZ 1477375](https://bugzilla.redhat.com/1477375) <b>v2v: In audit log IMPORTEXPORT_STARTING_IMPORT_VM is accompanied by ID of the source VM instead of the destination one</b><br>
 - [BZ 1474482](https://bugzilla.redhat.com/1474482) <b>Flood of log: Unable to cleanup SsoSession</b><br>
 - [BZ 1468301](https://bugzilla.redhat.com/1468301) <b>Creating a new Pool fails if 'Auto select target' check box is enabled and the created Pool is based on a Template with at least one disk</b><br>
 - [BZ 1448650](https://bugzilla.redhat.com/1448650) <b>UX: uncaught exception when trying to access the tab "Virtual Machine > Guest Info" of a offline instance.</b><br>
 - [BZ 1471759](https://bugzilla.redhat.com/1471759) <b>Synchronizing a direct lun that is also a part of a storage domain causes its virtual group ID to be removed from the DB</b><br>
 - [BZ 1465539](https://bugzilla.redhat.com/1465539) <b>Auto Generated snapshots failed to remove when live migrating disks concurrently</b><br>

#### VDSM

 - [BZ 1422508](https://bugzilla.redhat.com/1422508) <b>acquire lease Operations which depends on acquire lease, fails with error 'Sanlock resource not acquired', since the acquire has not been completed before the operation took place.</b><br>
 - [BZ 1408304](https://bugzilla.redhat.com/1408304) <b>Confusing errors when a volume does not exists in Volume.getInfo</b><br>
 - [BZ 1473295](https://bugzilla.redhat.com/1473295) <b>vdsm with python/ssl ssl_implementation cannot connect to engine</b><br>
 - [BZ 1473344](https://bugzilla.redhat.com/1473344) <b>vdsm's ssl_excludes not working, can't connect to engine</b><br>
 - [BZ 1469175](https://bugzilla.redhat.com/1469175) <b>vdsm path checking stops</b><br>
 - [BZ 1449944](https://bugzilla.redhat.com/1449944) <b>remove & format iscsi storage domain fails sometimes -  FormatStorageDomainVDS failed</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1469436](https://bugzilla.redhat.com/1469436) <b>set the shard-block-size to recommended value</b><br>
 - [BZ 1477452](https://bugzilla.redhat.com/1477452) <b>Remove the parameter OVEHOSTED_STORAGE/imgSizeGB from file  /usr/share/cockpit/ovirt-dashboard/gdeploy-templates/he-common.conf</b><br>
 - [BZ 1474267](https://bugzilla.redhat.com/1474267) <b>thinpoolsize should include poolmetatadatasize plus lv size.</b><br>
 - [BZ 1441523](https://bugzilla.redhat.com/1441523) <b>Conditionally show packages tab in cockpit UI for RHEL</b><br>
 - [BZ 1459894](https://bugzilla.redhat.com/1459894) <b>Newly created LV for brick entry should be of type thinlv</b><br>
 - [BZ 1459886](https://bugzilla.redhat.com/1459886) <b>Additional volume creation,shows up the volume entry with default volume type as arbiter</b><br>
 - [BZ 1455010](https://bugzilla.redhat.com/1455010) <b>Trim whitespaces in the user provided text in the cockpit UI</b><br>
 - [BZ 1476292](https://bugzilla.redhat.com/1476292) <b>gdeploy config file doesn't load on the 'Review' Step of hosted-engine setup wizard</b><br>
 - [BZ 1460614](https://bugzilla.redhat.com/1460614) <b>The page "Virtual Machines" has no response on Cockpit</b><br>

#### imgbased

 - [BZ 1477942](https://bugzilla.redhat.com/1477942) <b>Missing new layer boot entry sometimes when upgrade to rhvh-4.1-20170802</b><br>
 - [BZ 1477001](https://bugzilla.redhat.com/1477001) <b>Rpm is not persistent after upgrade to rhvh-4.1-20170728.0</b><br>
 - [BZ 1433189](https://bugzilla.redhat.com/1433189) <b>There are 3 layers when upgrade from build1 to build3 after upgrade from build1 to build2</b><br>
 - [BZ 1472193](https://bugzilla.redhat.com/1472193) <b>The NIST LVs generated by auto partitioning are not consistent with the ones generated by manual partitioning</b><br>
 - [BZ 1476094](https://bugzilla.redhat.com/1476094) <b>Upgrade failed when upgrade to rhvh-4.1-20170727.1</b><br>
 - [BZ 1475111](https://bugzilla.redhat.com/1475111) <b>Missing discard for /</b><br>
 - [BZ 1472189](https://bugzilla.redhat.com/1472189) <b>Missing discard for the NIST partitions when choosing auto partitioning</b><br>

#### oVirt Engine Extension AAA LDAP

 - [BZ 1476980](https://bugzilla.redhat.com/1476980) <b>AAA LDAP setup does not add baseDN to *-authn.properties</b><br>
 - [BZ 1462815](https://bugzilla.redhat.com/1462815) <b>Assume the user is going to use 'Single Sing-On for Virtual Machines'</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1479768](https://bugzilla.redhat.com/1479768) <b>[downstream clone - 4.1.5] Hosted engine issues too many lvm operations</b><br>

## Bug fixes

### oVirt Release Package

 - [BZ 1476650](https://bugzilla.redhat.com/1476650) <b>RHV-H Upgrade Breaks System Clock Sync</b><br>

### oVirt Engine

 - [BZ 1414499](https://bugzilla.redhat.com/1414499) <b>[RFE] ability to download images that are attached to vms</b><br>
 - [BZ 1476979](https://bugzilla.redhat.com/1476979) <b>Cannot set ImageProxyAddress with engine-config</b><br>
 - [BZ 1464819](https://bugzilla.redhat.com/1464819) <b>[API] Setting Custom Compatibility Version for a VM via REST api to a none/empty value  is not working</b><br>

### VDSM

 - [BZ 1461029](https://bugzilla.redhat.com/1461029) <b>Live merge fails when file based domain includes "images" in its path</b><br>

### imgbased

 - [BZ 1476071](https://bugzilla.redhat.com/1476071) <b>ovirt-imageio-daemon fails to run after upgrading from 4.0 NGN (as  directory "/var/log/ovirt-imageio-daemon/" is owned by user root)</b><br>
 - [BZ 1478339](https://bugzilla.redhat.com/1478339) <b>capabilities of /usr/bin/ping got corrupted after upgrade from 4.1.2 async to 4.1.3</b><br>


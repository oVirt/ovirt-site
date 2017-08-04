---
title: oVirt 4.1.5 Release Notes
category: documentation
layout: toc
---

# oVirt 4.1.5 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.5
Second Release Candidate as
of August 03, 2017.

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

### Enhancements

#### VDSM

 - [BZ 1022961](https://bugzilla.redhat.com/1022961) <b>Gluster: running a VM from a gluster domain should use gluster URI instead of a fuse mount</b><br>Feature: Added libgfapi support to the engine and vdsm<br><br>Reason: libgfapi provides VMs with faster access to the vm images, stored on a gluster volume, comparing with fuse interface.<br><br>Result: With 'LibgfApi' DC feature enabled or 'lubgfapi_supported' cluster level feature enabled, VMs will access their images, stored on gluster volumes, directly via libgfapi.

#### oVirt Engine Metrics

 - [BZ 1462500](https://bugzilla.redhat.com/1462500) <b>Add a check that ovirt_env_name is a valid OpenShift namespace identifier</b><br>Feature: <br>This adds a few checks to the ovirt_env_name, to make sure it is a valid OpenShift namespace identifier.<br><br>Reason: <br>ovirt_env_name must be a valid OpenShift namespace identifier in order for the records to be kept to the elasticsearch that is running in OpenShift.<br><br>Result: <br>Will fail the metrics script if the name is not valid.

### Unclassified

#### oVirt Engine

 - [BZ 1454811](https://bugzilla.redhat.com/1454811) <b>[downstream clone - 4.1.5] No error pops when logging with a locked ovirt user account</b><br>
 - [BZ 1476979](https://bugzilla.redhat.com/1476979) <b>Cannot set ImageProxyAddress with engine-config</b><br>
 - [BZ 1474482](https://bugzilla.redhat.com/1474482) <b>Flood of log: Unable to cleanup SsoSession</b><br>
 - [BZ 1468301](https://bugzilla.redhat.com/1468301) <b>Creating a new Pool fails if 'Auto select target' check box is enabled and the created Pool is based on a Template with at least one disk</b><br>
 - [BZ 1448650](https://bugzilla.redhat.com/1448650) <b>UX: uncaught exception when trying to access the tab "Virtual Machine > Guest Info" of a offline instance.</b><br>
 - [BZ 1471759](https://bugzilla.redhat.com/1471759) <b>Synchronizing a direct lun that is also a part of a storage domain causes its virtual group ID to be removed from the DB</b><br>
 - [BZ 1465539](https://bugzilla.redhat.com/1465539) <b>Auto Generated snapshots failed to remove when live migrating disks concurrently</b><br>

#### VDSM

 - [BZ 1469175](https://bugzilla.redhat.com/1469175) <b>vdsm path checking stops</b><br>
 - [BZ 1449944](https://bugzilla.redhat.com/1449944) <b>remove & format iscsi storage domain fails sometimes -  FormatStorageDomainVDS failed</b><br>
 - [BZ 1473344](https://bugzilla.redhat.com/1473344) <b>vdsm's ssl_excludes not working, can't connect to engine</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1441523](https://bugzilla.redhat.com/1441523) <b>Conditionally show packages tab in cockpit UI for RHEL</b><br>
 - [BZ 1459894](https://bugzilla.redhat.com/1459894) <b>Newly created LV for brick entry should be of type thinlv</b><br>
 - [BZ 1459886](https://bugzilla.redhat.com/1459886) <b>Additional volume creation,shows up the volume entry with default volume type as arbiter</b><br>
 - [BZ 1476292](https://bugzilla.redhat.com/1476292) <b>gdeploy config file doesn't load on the 'Review' Step of hosted-engine setup wizard</b><br>
 - [BZ 1460614](https://bugzilla.redhat.com/1460614) <b>The page "Virtual Machines" has no response on Cockpit</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1414499](https://bugzilla.redhat.com/1414499) <b>[RFE] ability to download images that are attached to vms</b><br>
 - [BZ 1464819](https://bugzilla.redhat.com/1464819) <b>[API] Setting Custom Compatibility Version for a VM via REST api to a none/empty value  is not working</b><br>

### VDSM

 - [BZ 1461029](https://bugzilla.redhat.com/1461029) <b>Live merge fails when file based domain includes "images" in its path</b><br>

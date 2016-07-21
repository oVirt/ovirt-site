---
title: oVirt 4.0.2 Release Notes
category: documentation
authors: sandrobonazzola
---

# oVirt 4.0.2 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.2 First Release Candidate as of July 21st, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

This is pre-release software. Please take a look at our [community page](http://www.ovirt.org/community/) to know how to ask questions and interact with developers and users. All issues or bugs should be reported via the [Red Hat Bugzilla](https://bugzilla.redhat.com/). The oVirt Project makes no guarantees as to its suitability or usefulness. This pre-release should not to be used in production, and it is not feature complete.

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](http://www.ovirt.org/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

In order to install it on a clean system, you need to install

`# yum install `[`http://plain.resources.ovirt.org/pub/ovirt-4.0-pre/rpm/el7/noarch/ovirt-release40-pre.rpm`](http://plain.resources.ovirt.org/pub/ovirt-4.0-pre/rpm/el7/noarch/ovirt-release40-pre.rpm)

To test this pre release, you should read our [Quick Start Guide](Quick Start Guide).

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

## Known issues

 - [BZ 1297835](https://bugzilla.redhat.com/1297835) <b>Host install fails on Fedora 23 due to lack of dep on python2-dnf</b><br>On Fedora >= 23 dnf package manager with python 3 is used by default while
ovirt-host-deploy is executed by ovirt-engine using python2. This cause Host install to fail on Fedora >= 23 due to lack of python2-dnf in the default environment. As workaround please install manually python2-dnf on the host before trying to add it to the engine.


## What's New in 4.0.2?

### Enhancement

#### oVirt Engine

##### Team: Virt

 - [BZ 1348907](https://bugzilla.redhat.com/1348907) <b>During cluster level upgrade - warn and mark VMs as pending a configuration change when they are running</b><br>The user is informed about running/suspended VMs in a cluster when changing cluster version.<br>All such VMs are marked with a Next Run Configuration symbol to denote the requirement for rebooting them as soon as possible. <br><br>Prior this patch, the cluster upgrade was blocked if there's a running VM in the cluster.
 - [BZ 1310804](https://bugzilla.redhat.com/1310804) <b>[RFE] Override instance type on VmPools in Python-SDK</b><br>The instance type field was missing in the REST API VM pools resource. This patch adds both the ability to pick one during create VM pool and to report the currently configured one.

##### Team: Infra

 - [BZ 1346782](https://bugzilla.redhat.com/1346782) <b>Display also pretty name along with name, version and release in Host Detail tab in Hosts view</b><br>Feature: AS part of the NGN(New Generation Node) support, this enhancement displays now the OS pretty name for all OS that has a /etc/os-release file with the PRETTY_NAME entry  <br><br>Reason: We should display in addition to general OS information more details about the OS in case of NGN<br><br>Result: When you select a host in UI, you can see an additional field in the "Software" option on the Host sub-tab named "OD Description" that displays the OS pretty name <br><br>* This enhancement is no accessible to the REST API

### Unclassified

#### oVirt Engine

##### Team: UX

 - [BZ 1357070](https://bugzilla.redhat.com/1357070) <b>oVirt 4.0 translation update post intl-QA</b><br>

##### Team: Virt

 - [BZ 1357630](https://bugzilla.redhat.com/1357630) <b>VMs > 'Guest Info' subtab throws FE exception while switching VMs</b><br>
 - [BZ 1357440](https://bugzilla.redhat.com/1357440) <b>Cannot create an instance type via UI - gwt error</b><br>
 - [BZ 1354494](https://bugzilla.redhat.com/1354494) <b>VMs in unknown status and no run_on_vds</b><br>
 - [BZ 1356488](https://bugzilla.redhat.com/1356488) <b>Edit VM Pool show wrong storage domain</b><br>
 - [BZ 1351477](https://bugzilla.redhat.com/1351477) <b>Missing property for Origin KVM</b><br>
 - [BZ 1350501](https://bugzilla.redhat.com/1350501) <b>v2v: '?' tooltip in import dialog is located incorrectly.</b><br>
 - [BZ 1354463](https://bugzilla.redhat.com/1354463) <b>Cannot add a permission for a vmPool to a user via API v4</b><br>

##### Team: Storage

 - [BZ 1356649](https://bugzilla.redhat.com/1356649) <b>Template's & VMs disks link is wrongly calculated in rest API V3</b><br>
 - [BZ 1349498](https://bugzilla.redhat.com/1349498) <b>When a VM is started, attached disks can't be edited anymore</b><br>
 - [BZ 1357431](https://bugzilla.redhat.com/1357431) <b>"Scan Disks" option should be disabled for Export and ISO storage domains</b><br>
 - [BZ 1354547](https://bugzilla.redhat.com/1354547) <b>UI exception thrown when creating new profile and moving to another sub tab</b><br>
 - [BZ 1353229](https://bugzilla.redhat.com/1353229) <b>Upload image: default values for Image Type and  Allocation Policy don't integrate</b><br>
 - [BZ 1352855](https://bugzilla.redhat.com/1352855) <b>Storage domain is not selectable when uploading a disk from "disks" tab</b><br>
 - [BZ 1352857](https://bugzilla.redhat.com/1352857) <b>image upload: proper message is required when disk's entered values are not valid</b><br>
 - [BZ 1352825](https://bugzilla.redhat.com/1352825) <b>CommandEntity record isn't cleared for commands with callback that fails on validate() till the next engine restart.</b><br>
 - [BZ 1353604](https://bugzilla.redhat.com/1353604) <b>endAction() is wrongly executed for commands with callback that fails on validate() on the next engine restart.</b><br>
 - [BZ 1352676](https://bugzilla.redhat.com/1352676) <b>When a disk finished uploading to a storage domain, it's status turns to Illegal</b><br>
 - [BZ 1351636](https://bugzilla.redhat.com/1351636) <b>Wrong warning when hotpluging a disk is not supported</b><br>
 - [BZ 1352657](https://bugzilla.redhat.com/1352657) <b>GET of diskattachment returns a list of objects without the href property</b><br>

##### Team: Integration

 - [BZ 1343155](https://bugzilla.redhat.com/1343155) <b>ovirt-engine fails to start with python-daemon-2.1.0 installed</b><br>

##### Team: Infra

 - [BZ 1356675](https://bugzilla.redhat.com/1356675) <b>[AAA] Can't add IPA directory users to VM permissions</b><br>
 - [BZ 1353460](https://bugzilla.redhat.com/1353460) <b>API: exception on engine while trying add an event via API (due to the use of cluster name. Workaround: use cluster ID)</b><br>
 - [BZ 1354452](https://bugzilla.redhat.com/1354452) <b>[notifier] drop mentioning AES192 and AES256 in notifier.conf</b><br>
 - [BZ 1352953](https://bugzilla.redhat.com/1352953) <b>show descriptive error  message when sending a negative number like: {url}/events;max=-3</b><br>
 - [BZ 1355647](https://bugzilla.redhat.com/1355647) <b>Capabilities entry point missing</b><br>
 - [BZ 1352721](https://bugzilla.redhat.com/1352721) <b>Users with '%' in their password, cannot log in.</b><br>
 - [BZ 1350353](https://bugzilla.redhat.com/1350353) <b>[UI] - New cluster - Authorization provider: <UNKNOWN> was granted permission for Role CpuProfileOperator on Cpu Profile <UNKNOWN>, by admin@internal-authz when creating new cluster</b><br>
 - [BZ 1352575](https://bugzilla.redhat.com/1352575) <b>v3 REST API | job object status description should be in upper case letters and inside a <state> entry</b><br>
 - [BZ 1350399](https://bugzilla.redhat.com/1350399) <b>NPE during compensation on startup</b><br>

##### Team: SLA

 - [BZ 1340626](https://bugzilla.redhat.com/1340626) <b>Support update of the HE OVF ad-hoc</b><br>
 - [BZ 1348640](https://bugzilla.redhat.com/1348640) <b>HE can't get started if a new vNIC was added with an empty profile.</b><br>
 - [BZ 1339660](https://bugzilla.redhat.com/1339660) <b>Hosted Engine's disk is in Unassigned Status in the RHEV UI</b><br>

##### Team: Network

 - [BZ 1351145](https://bugzilla.redhat.com/1351145) <b>Register unregistered templates (import storage domain) failed via REST</b><br>

#### VDSM

##### Team: Virt

 - [BZ 1354344](https://bugzilla.redhat.com/1354344) <b>wait properly for migration to begin</b><br>

##### Team: Storage

 - [BZ 1339780](https://bugzilla.redhat.com/1339780) <b>Require fix for bug 1339777 - ioprocess keep open file on shared storage after touching or truncating a file</b><br>
 - [BZ 1344289](https://bugzilla.redhat.com/1344289) <b>Add compat level verification for uploaded QCOW</b><br>
 - [BZ 1342397](https://bugzilla.redhat.com/1342397) <b>Vdsm cannot parse the output of dd from coreutils 8.25.5</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1356221](https://bugzilla.redhat.com/1356221) <b>hosted-engine --ugprade-appliance fails with glusterfs based SHE</b><br>

#### oVirt Engine SDK 4 Java

##### Team: Infra

 - [BZ 1349857](https://bugzilla.redhat.com/1349857) <b><link> element is not parsed</b><br>

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1357104](https://bugzilla.redhat.com/1357104) <b>oVirt 4.0 translation update post intl-QA</b><br>


## Bug fixes

### oVirt Engine

#### Team: Gluster

 - [BZ 1255590](https://bugzilla.redhat.com/1255590) <b>Gluster: Variables in an error message are not replaced when it is shown on screen</b><br>

#### Team: UX

 - [BZ 1320559](https://bugzilla.redhat.com/1320559) <b>[Webadmin] uncaught exception notification repeats endlessly</b><br>

#### Team: Virt

 - [BZ 1128453](https://bugzilla.redhat.com/1128453) <b>[REST API]: VM next_run do not have all fields updated.</b><br>
 - [BZ 1296127](https://bugzilla.redhat.com/1296127) <b>string showing number of cores of VM in basictab in 3.6 is harder to read than in 3.5</b><br>
 - [BZ 1349526](https://bugzilla.redhat.com/1349526) <b>Incorrect error message while VM migration is running</b><br>
 - [BZ 1346848](https://bugzilla.redhat.com/1346848) <b>VmPoolMonitor does not log reason for VM prestart failure</b><br>

#### Team: Integration

 - [BZ 1331168](https://bugzilla.redhat.com/1331168) <b>engine-setup should check postgresql version compatibility for remote DBs</b><br>

#### Team: Infra

 - [BZ 1226561](https://bugzilla.redhat.com/1226561) <b>Command-coordination: re-acquire engine lock after engine restart</b><br>
 - [BZ 1219147](https://bugzilla.redhat.com/1219147) <b>oVirt's message mechanism should permit space allocation warnings to be thrown</b><br>

#### Team: SLA

 - [BZ 1324830](https://bugzilla.redhat.com/1324830) <b>Update VM NUMA pinning via host menu, when VM run will result to VM failed to start on next run</b><br>
 - [BZ 1260381](https://bugzilla.redhat.com/1260381) <b>Incorrect behavior of power saving weight module</b><br>
 - [BZ 1351556](https://bugzilla.redhat.com/1351556) <b>LowUtiliztion parameter does not exist under power_saving policy</b><br>

#### Team: Network

 - [BZ 1324479](https://bugzilla.redhat.com/1324479) <b>race between SetupNetwork and event-triggered getVdsCaps</b><br>
 - [BZ 1324125](https://bugzilla.redhat.com/1324125) <b>macpool addresses are not forced to lowercase</b><br>
 - [BZ 1333728](https://bugzilla.redhat.com/1333728) <b>Rest API allows creating network providers without required fields.</b><br>


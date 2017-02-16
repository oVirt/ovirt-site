---
title: oVirt 4.1.1 Release Notes
category: documentation
authors: sandrobonazzola
---

# oVirt 4.1.1 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.1
Second Test Compose as
of February 16, 2017.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3, CentOS Linux 7.3
(or similar).


This is pre-release software.
Please take a look at our [community page](/community/) to know how to
ask questions and interact with developers and users.
All issues or bugs should be reported via the [Red Hat Bugzilla](https://bugzilla.redhat.com/).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature complete.


To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

An updated documentation has been provided by our downstream
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization?version=4.0/)


## Install / Upgrade from previous versions


### Fedora / CentOS / RHEL


## TEST COMPOSE

In order to install this Test Compose you will need to enable pre-release repository.


In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)


To test this pre release, you may read our
[Quick Start Guide](Quick Start Guide)

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding Red Hat Virtualization
[Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding Red Hat Virtualization
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
`excludepkgs=collectd*`.
## What's New in 4.1.0 Async release?
On February 3rd 2017 the ovirt team issued an async release of ovirt-engine package including a fix for:
- [BZ 1417597](https://bugzilla.redhat.com/1417597) <b>Failed to update template</b><br>

## What's New in 4.1.1?

### Enhancements

#### oVirt Engine
 - [BZ 1408193](https://bugzilla.redhat.com/1408193) <b>[RFE] Update timestamp format in engine log to timestamp with timezone</b><br>
 - [BZ 1388430](https://bugzilla.redhat.com/1388430) <b>[RFE]  Provide a tool to execute vacuum full on engine database</b><br>- There is a documentation bug for this one - see Bug 1416049<br><br>Feature: <br>Adding a tool and a setup-plugin to run vacuum on the engine db. <br><br>Reason: <br>Adding a maintenance tool, to optimize tables stats and clean up garbage and compact the internals of tables. The result is less disk space usage, more efficient future maintenance work, updated table stats for better query planning.<br><br>Result: <br>A cli tools, secure and easy to work with that runs all sorts of vacuum actions on the engine db or specific tables.<br>A setup-plugin dialog that offers to perform vacuum on the engine while in this maintenance period, optionally automated by the answer file.
 - [BZ 1388433](https://bugzilla.redhat.com/1388433) <b>[RFE] Change auto-vacuum configuration defaults to match oVirt db usage</b><br>* there is a documentation bug opened for this one, see Bug 1411756 <br><br>Feature: <br>Configure the engine's postgres with more aggressive vacuum daemon configuration.<br><br>Reason: <br>To prevent the frequently updates tables from piling up garbage and avoid or minimize the risk of disk flood and tx id wrap around<br><br>Result: The engine tables remain healthy, dead rows are collected in timely manner, disk space usage is correlated with the real amount of data kept.
 - [BZ 1412547](https://bugzilla.redhat.com/1412547) <b>Allow negotiation of highest available TLS version for engine <-> VDSM communication</b><br>Feature: <br><br>Currently when engine tries to connect to VDSM, it tries to negotiate highest available version of TLS, but due to issues in the past we have a limitation to try TLSv1.0 as highest version and not try any higher version.<br><br>This fix removes the limit, so we can negotiate also TLSv1.1 and TLSv1.2 when they will be available on VDSM side. Removing this limit will allow us to drop TLSv1.0 in future VDSM versions and provide only newer TLS versions<br><br><br>Reason: <br><br>Result:
 - [BZ 1406398](https://bugzilla.redhat.com/1406398) <b>[RFE] Add NFS V4.2 support for ovirt-engine</b><br>oVirt now supports NFS version 4.2 connections (where supported by storage)
 - [BZ 1369175](https://bugzilla.redhat.com/1369175) <b>VM Console options: hide "Enable USB Auto-Share" entry when USB is disabled.</b><br>"Enable USB Auto-Share" option in "Console options" dialog is now enabled only if "USB Support" is checked for the VM.

#### oVirt Hosted Engine HA
 - [BZ 1101554](https://bugzilla.redhat.com/1101554) <b>[RFE] HE-ha: use vdsm api instead of vdsClient</b><br>With this update, the code interfacing with VDSM now uses the VDSM API directly instead of using vdsClient and xmlrpc.

### No Doc Update

#### oVirt Engine
 - [BZ 1418537](https://bugzilla.redhat.com/1418537) <b>[Admin Portal] Exception while adding new host network QoS from cluster->logical networks->add network</b><br>undefined

#### VDSM
 - [BZ 1215039](https://bugzilla.redhat.com/1215039) <b>[HC] - API schema for StorageDomainType is missing glusterfs type</b><br>undefined

#### MOM
 - [BZ 1370081](https://bugzilla.redhat.com/1370081) <b>Deprecation warning about BaseException.message in a log</b><br>undefined

### Unclassified

#### oVirt Engine

##### Team: Gluster

 - [BZ 1368487](https://bugzilla.redhat.com/1368487) <b>RHGS/Gluster node is still in non-operational state, even after restarting the glusterd service from UI</b><br>

##### Team: Infra

 - [BZ 1418757](https://bugzilla.redhat.com/1418757) <b>Package list for upgrade checks has to contain only valid packages per version</b><br>
 - [BZ 1361223](https://bugzilla.redhat.com/1361223) <b>[AAA] Missing principal name option for keytab usage on kerberos</b><br>In BZ1322940 we have provided a way how to reuse GSSAPI configuration provided by application server. This fix adds an option how to specify principal name if multiple principal names are present within configured keytab.<br><br>This principal name can be specified using following variable:<br><br>AAA_JAAS_PRINCIPAL_NAME=principal_name<br><br>By default principal name is empty, which works fine for cases where only one principal is defined in specified keytab (most common cases).<br><br>To use that option, the user has to create a new configuration file and specify the correct values for GSSAPI variables (more information in BZ1322940), for example: /etc/ovirt-engine/engine.conf.d/99-jaas.conf.
 - [BZ 1418002](https://bugzilla.redhat.com/1418002) <b>[BUG] RHV cisco_ucs power management restart displays misleading message.</b><br>
 - [BZ 1421962](https://bugzilla.redhat.com/1421962) <b>[RFE] Add JMX support for jconsole</b><br>
 - [BZ 1412687](https://bugzilla.redhat.com/1412687) <b>Awkward attempted login error</b><br>
 - [BZ 1414787](https://bugzilla.redhat.com/1414787) <b>Hide tracebacks in engine.log by upgrading non responsive host</b><br>
 - [BZ 1416845](https://bugzilla.redhat.com/1416845) <b>Can not add power management to the host, when the host has state 'UP'</b><br>
 - [BZ 1414083](https://bugzilla.redhat.com/1414083) <b>User Name required for login on behalf</b><br>
 - [BZ 1400500](https://bugzilla.redhat.com/1400500) <b>If AvailableUpdatesFinder finds already running process it should not be ERROR level</b><br>
 - [BZ 1416147](https://bugzilla.redhat.com/1416147) <b>Version 3 of the API doesn't implement the 'testconnectivity' action of external providers</b><br>

##### Team: Metrics

 - [BZ 1415639](https://bugzilla.redhat.com/1415639) <b>Some of the values are not considered as numbers by elasticsearch</b><br>

##### Team: Network

 - [BZ 1415471](https://bugzilla.redhat.com/1415471) <b>Adding host to engine failed at first time but host was auto recovered after several mins</b><br>
 - [BZ 1419529](https://bugzilla.redhat.com/1419529) <b>radio buttons overflow in Network Interface form</b><br>
 - [BZ 1413377](https://bugzilla.redhat.com/1413377) <b>Break bond and create new bond at the same time fail to get applied correctly</b><br>
 - [BZ 1410405](https://bugzilla.redhat.com/1410405) <b>unexpected TAB order in the external network subnet window</b><br>
 - [BZ 1390575](https://bugzilla.redhat.com/1390575) <b>Import VM from data domain failed when trying to import a VM without re-assign MACs, but there is no MACs left in the destination pool</b><br>

##### Team: Storage

 - [BZ 1408982](https://bugzilla.redhat.com/1408982) <b>Lease related tasks remain on SPM</b><br>
 - [BZ 1399603](https://bugzilla.redhat.com/1399603) <b>Import template from glance and export it to export domain will cause that it is impossible to import it</b><br>
 - [BZ 1417439](https://bugzilla.redhat.com/1417439) <b>When adding lease using REST high availability should be enabled first</b><br>
 - [BZ 1421619](https://bugzilla.redhat.com/1421619) <b>Command proceed to perform the next execution phase although execute() failed</b><br>
 - [BZ 1417903](https://bugzilla.redhat.com/1417903) <b>Trying to download an image when it's storage domain is in maintenance locks the image for good</b><br>
 - [BZ 1420821](https://bugzilla.redhat.com/1420821) <b>style issues in block storage dialog</b><br>
 - [BZ 1420816](https://bugzilla.redhat.com/1420816) <b>missing Interface column on Storage and Disks sub-tabs under Templates main-tab</b><br>
 - [BZ 1420812](https://bugzilla.redhat.com/1420812) <b>DirectLUN dialog - missing label for 'Use Host' select-box</b><br>
 - [BZ 1419853](https://bugzilla.redhat.com/1419853) <b>Image upload fails when one of the ovirt-imageio-daemons was not running</b><br>
 - [BZ 1419886](https://bugzilla.redhat.com/1419886) <b>Upload image operations are available using the GUI when there is an active download of the image using the python sdk (for the image that is downloaded)</b><br>
 - [BZ 1414126](https://bugzilla.redhat.com/1414126) <b>UI error on 'wipe' and 'discard' being mutually exclusive is unclear and appears too late</b><br>
 - [BZ 1379130](https://bugzilla.redhat.com/1379130) <b>Unexpected client exception when glance server is not reachable</b><br>
 - [BZ 1419364](https://bugzilla.redhat.com/1419364) <b>Fail to register an unregistered Template through REST due to an NPE when calling updateMaxMemorySize</b><br>
 - [BZ 1416340](https://bugzilla.redhat.com/1416340) <b>Change name of check box in Edit Virtual Disks window from Pass Discard to Enable Discard</b><br>
 - [BZ 1416809](https://bugzilla.redhat.com/1416809) <b>New HSM infrastructure - No QCow version displayed for images created with 4.0</b><br>
 - [BZ 1414084](https://bugzilla.redhat.com/1414084) <b>uploaded images using the GUI have actual_size=0</b><br>

##### Team: UX

 - [BZ 1416830](https://bugzilla.redhat.com/1416830) <b>Search by tags generates wrong filter string in Users tab</b><br>
 - [BZ 1414418](https://bugzilla.redhat.com/1414418) <b>Patternfly Check Boxes and Radio Buttons text should be clickable</b><br>
 - [BZ 1390271](https://bugzilla.redhat.com/1390271) <b>in few of ui dialogs the fields position is pushed down or cut after replacing to the new list boxes</b><br>
 - [BZ 1421285](https://bugzilla.redhat.com/1421285) <b>oVirt 4.1 update it_IT community translation</b><br>

##### Team: Virt

 - [BZ 1421174](https://bugzilla.redhat.com/1421174) <b>Migration scheduler should work with per-VM cluster compatibility level</b><br>
 - [BZ 1414455](https://bugzilla.redhat.com/1414455) <b>removing disk in VM edit dialog causes UI error</b><br>
 - [BZ 1410606](https://bugzilla.redhat.com/1410606) <b>Imported VMs has max memory 0</b><br>
 - [BZ 1415759](https://bugzilla.redhat.com/1415759) <b>Trying to sparsify a direct lun via the REST API gives a NullPointerException</b><br>
 - [BZ 1364137](https://bugzilla.redhat.com/1364137) <b>make VM template should be blocked while importing this VM.</b><br>
 - [BZ 1406572](https://bugzilla.redhat.com/1406572) <b>Uncaught exception is received when trying to create a vm from User portal without power user role assigned</b><br>
 - [BZ 1374589](https://bugzilla.redhat.com/1374589) <b>remove virtio-win drivers drop down for KVM imports</b><br>
 - [BZ 1414430](https://bugzilla.redhat.com/1414430) <b>Disable sparsify option for pre allocated disk</b><br>
 - [BZ 1422089](https://bugzilla.redhat.com/1422089) <b>Missing exit code for post-copy migration failure</b><br>
 - [BZ 1419337](https://bugzilla.redhat.com/1419337) <b>Random Generator setting did not saved after reboot</b><br>Previously, if the RNG configuration was changed on a running VM, after restart of the VM the configuration was not properly restored.<br><br>Please note that the fix takes effect only on VMs which have been restarted on the fixed version of the engine.
 - [BZ 1414086](https://bugzilla.redhat.com/1414086) <b>Remove redundant video cards when no graphics available for a VM and also add video cards if one graphics device exists</b><br>
 - [BZ 1347356](https://bugzilla.redhat.com/1347356) <b>Pending Virtual Machine Changes -> minAllocatedMem issues</b><br>
 - [BZ 1416837](https://bugzilla.redhat.com/1416837) <b>Order VMs by Uptime doesn't work</b><br>

#### VDSM

##### Team: Infra

 - [BZ 1408190](https://bugzilla.redhat.com/1408190) <b>[RFE] Update timestamp format in vdsm log to timestamp with timezone</b><br>
 - [BZ 1421556](https://bugzilla.redhat.com/1421556) <b>Setting log level as shown in README.logging fails.</b><br>
 - [BZ 1412550](https://bugzilla.redhat.com/1412550) <b>Fix certificate validation for engine <-> VDSM encrypted connection when IPv6 is configured</b><br>

##### Team: Network

 - [BZ 1414323](https://bugzilla.redhat.com/1414323) <b>Failed to add host to engine via bond+vlan configured by NM during anaconda</b><br>
 - [BZ 1419931](https://bugzilla.redhat.com/1419931) <b>Failed to destroy partially-initialized VM with port mirroring</b><br>
 - [BZ 1412563](https://bugzilla.redhat.com/1412563) <b>parse arp_ip_target with multiple ip properly</b><br>
 - [BZ 1410076](https://bugzilla.redhat.com/1410076) <b>[SR-IOV] - in-guest bond with virtio+passthrough slave lose connectivity after hotunplug/hotplug of passthrough slave</b><br>

##### Team: Storage

 - [BZ 1408825](https://bugzilla.redhat.com/1408825) <b>Add the ability to create and remove lease while vm is up</b><br>
 - [BZ 1417460](https://bugzilla.redhat.com/1417460) <b>Failed to Amend Qcow volume on block SD due failure on Qemu-image</b><br>
 - [BZ 1417737](https://bugzilla.redhat.com/1417737) <b>Cold Merge: Deprecate mergeSnapshots verb</b><br>
 - [BZ 1415803](https://bugzilla.redhat.com/1415803) <b>Improve logging during live merge</b><br>

##### Team: Virt

 - [BZ 1422087](https://bugzilla.redhat.com/1422087) <b>wrong VMware OVA import capacity</b><br>
 - [BZ 1414626](https://bugzilla.redhat.com/1414626) <b>Crash VM during migrating with error "Failed in MigrateBrokerVDS"</b><br>
 - [BZ 1419557](https://bugzilla.redhat.com/1419557) <b>Switching to post-copy should catch exceptions</b><br>

#### oVirt Engine Extension AAA JDBC

 - [BZ 1415704](https://bugzilla.redhat.com/1415704) <b>Casting exception during group show by ovirt-aaa-jdbc tool</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1420283](https://bugzilla.redhat.com/1420283) <b>Ensure that upgrading the engine vm from 3.6/el6 to 4.0/el7 is properly working once we release 4.1</b><br>
 - [BZ 1411640](https://bugzilla.redhat.com/1411640) <b>[HC] - Include gdeploy package in oVirt Node</b><br>

#### oVirt Release Package

##### Team: Node

 - [BZ 1418630](https://bugzilla.redhat.com/1418630) <b>gluster firewalld service should be added to the default firewall zone</b><br>
 - [BZ 1419105](https://bugzilla.redhat.com/1419105) <b>oVirt Node NG does not include vdsm-hook-vhostmd</b><br>
 - [BZ 1411640](https://bugzilla.redhat.com/1411640) <b>[HC] - Include gdeploy package in oVirt Node</b><br>

## Bug fixes

### oVirt Engine

#### Team: Network

 - [BZ 1416748](https://bugzilla.redhat.com/1416748) <b>punch iptables holes on OVN hosts and OVN central server during installation</b><br>
 - [BZ 1329893](https://bugzilla.redhat.com/1329893) <b>UI: explain why we cannot change the logical network settings in the "Manage Networks" window</b><br>

#### Team: SLA

 - [BZ 1416893](https://bugzilla.redhat.com/1416893) <b>Unable to undeploy hosted-engine host via UI.</b><br>
 - [BZ 1364132](https://bugzilla.redhat.com/1364132) <b>Once the engine imports the hosted-engine VM we loose the console device</b><br>

#### Team: Storage

 - [BZ 1394687](https://bugzilla.redhat.com/1394687) <b>DC gets non-responding when detaching inactive ISO domain</b><br>
 - [BZ 1323663](https://bugzilla.redhat.com/1323663) <b>the path of storage domain is not trimmed/missing warning about invalid path</b><br>
 - [BZ 1417458](https://bugzilla.redhat.com/1417458) <b>Cold Merge: Use volume generation</b><br>

#### Team: Virt

 - [BZ 1406243](https://bugzilla.redhat.com/1406243) <b>Out of range CPU APIC ID</b><br>
 - [BZ 1388963](https://bugzilla.redhat.com/1388963) <b>Unable to change vm Pool Configuration. Receive "Uncaught exception occurred. Please try reloading the page".</b><br>
 - [BZ 1276670](https://bugzilla.redhat.com/1276670) <b>[engine-clean] engine-cleanup doesn't stop ovirt-vmconsole-proxy-sshd</b><br>
 - [BZ 1411844](https://bugzilla.redhat.com/1411844) <b>Imported VMs have maxMemory too large</b><br>
 - [BZ 1273825](https://bugzilla.redhat.com/1273825) <b>Template sorting by version is broken</b><br>

### VDSM

 - [BZ 1403846](https://bugzilla.redhat.com/1403846) <b>keep 3.6 in the supportedEngines reported by VDSM</b><br>
 - [BZ 1302020](https://bugzilla.redhat.com/1302020) <b>[Host QoS] - Set maximum link share('ls') value for all classes on the default class</b><br>
 - [BZ 1223538](https://bugzilla.redhat.com/1223538) <b>VDSM reports "lvm vgs failed" warning when DC contains ISO domain</b><br>
 - [BZ 1302358](https://bugzilla.redhat.com/1302358) <b>File Storage domain export path does not support [IPv6]:/path input</b><br>
 - [BZ 1341106](https://bugzilla.redhat.com/1341106) <b>HA vms do not start after successful power-management.</b><br>

### oVirt Hosted Engine Setup

 - [BZ 1288979](https://bugzilla.redhat.com/1288979) <b>[HC] glusterd port was not opened, when automatically configuring firewall in hosted-engine setup</b><br>


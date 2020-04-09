---
title: oVirt 4.0.5 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 4.0.5 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.5
Release as of November 15th, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and the [about oVirt](/community/about.html) page.

An updated documentation has been provided by our downstream 
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization?version=4.0/)


## Install / Upgrade from previous versions

Users upgrading from 3.6 should be aware of following 4.0 changes around
authentication and certificates handling:

1. Single Sign-On using OAUTH2 protocol has been implemented in engine to
   allow SSO between webadmin, userportal and RESTAPI. More information can
   be found at https://bugzilla.redhat.com/1092744

2. Due to SSO it's required to access engine only using the same FQDN which
   was specified during engine-setup invocation. If your engine FQDN is not
   accessible from all engine clients, you will not be able to login. Please
   use ovirt-engine-rename tool to fix your FQDN, more information can be
   found at https://www.ovirt.org/documentation/how-to/networking/changing-engine-hostname/ .
   If you try to access engine using IP or DNS alias, an error will be
   thrown. Please consult following bugs targeted to oVirt 4.0.4 which
   should fix this limitation:
     https://bugzilla.redhat.com/1325746
     https://bugzilla.redhat.com/1362196

3. If you have used Kerberos SSO to access engine, please consult
   https://bugzilla.redhat.com/1342192 how to update your Apache
   configuration after upgrade to 4.0

4. If you are using HTTPS certificate signed by custom certificate
   authority, please take a look at https://bugzilla.redhat.com/1336838
   for steps which need to be done after migration to 4.0. Also please
   consult https://bugzilla.redhat.com/1313379 how to setup this custom
   CA for use with virt-viewer clients.



### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm)

and then follow our [Quick Start Guide](/documentation/quickstart/quickstart-guide/) or
a more updated documentation from our downstream
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/)

If you're upgrading from a previous release on Enterprise Linux 7 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
      # yum update "ovirt-engine-setup*"
      # engine-setup

Upgrade on Fedora 22 and Enterprise Linux 6 is not supported and you should follow our [Migration Guide](../../documentation/migration-engine-36-to-40/) in order to migrate to Enterprise Linux 7 or Fedora 23.

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow
[Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide or the
corresponding Red Hat Virtualization [Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide
or the corresponding Red Hat Virtualization [Upgrade Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/upgrade-guide/)

## Known issues

 - [BZ 1297835](https://bugzilla.redhat.com/1297835) <b>Host install fails on Fedora 23 due to lack of dep on python2-dnf</b><br>On Fedora >= 23 dnf package manager with python 3 is used by default while
ovirt-host-deploy is executed by ovirt-engine using python2. This cause Host install to fail on Fedora >= 23 due to lack of python2-dnf in the default environment. As workaround please install manually python2-dnf on the host before trying to add it to the engine.


## What's New in 4.0.5?

### Enhancements

#### oVirt Engine

##### Team: Integration

 - [BZ 1340810](https://bugzilla.redhat.com/1340810) <b>4.0 engine-backup should hide reports backup/restore</b><br>Feature: <br><br>engine-backup --mode=restore does not restore reports db/conf even if found in backup.<br><br>Reason: <br><br>In 4.0 Reports is not packaged/supported anymore. engine-backup of 4.0 supports restoring a 3.6 backup, which might include Reports data.<br><br>Result: <br><br>If Reports db dump is found in a backup, engine-backup notifies the user that it will not be restored, and does not restore Reports db/conf.

##### Team: Virt

 - [BZ 1346847](https://bugzilla.redhat.com/1346847) <b>virt-v2v basic REST API</b><br>With this update, the ability to import virtual machines from VMware, VMware OVA, XEN, and KVM via the Red Hat Virtualization REST API has been added. Previously, this was only possible using the web UI.

#### VDSM

##### Team: SLA

 - [BZ 1373832](https://bugzilla.redhat.com/1373832) <b>Add all APIs needed to support jsonrpc in MOM</b><br>The Memory Overcommit Manager (MoM) can now use JSONRPC insead of XMLRPC for communication with the VDSM.

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1347340](https://bugzilla.redhat.com/1347340) <b>[RFE] hosted engine should check the actual size of the qcow instead of relying on the OVA</b><br>Previously, ovirt-hosted-engine-setup relied on the OVA metadata to determine the size of the image contained in OVAs, and the amount of temporary disk space needed to unpack it. However, sparsified images would report a value much higher than the actual space required on-disk. Now, ovirt-hosted-engine-setup will check the actual size of images contained in OVAs in order to determine the amount of temporary storage required.
 - [BZ 1343451](https://bugzilla.redhat.com/1343451) <b>upgrade-appliance should warn about sshd keys changes</b><br>During the migration of the hosted-engine VM from 3.6/el6 to 4.0/el7, hosted-engine-setup is going to deploy a new appliance and so the ssh keys are going to be regenerated.<br>So the user has to remove previous entries from know_hosts on his clients.

#### oVirt Host Deploy

##### Team: Network

 - [BZ 1373968](https://bugzilla.redhat.com/1373968) <b>Deploying a host with an external Neutron network configured fails</b><br>Previously, with the release of OpenStack Liberty the Open vSwitch agent ini file location changed. This caused host deployment to fail when the latest releases of OpenStack were used. Now, support for Liberty and newer releases of OpenStack has been added and host deployment no longer fails.

#### MOM

##### Team: SLA

 - [BZ 1366556](https://bugzilla.redhat.com/1366556) <b>MOM causes Vdsm to slow down, high number of 'vmGetIoTunePolicy' API calls</b><br>This update ensures that the Memory Overcommit Manager (MoM) uses just one request to retrieve the ioTune configuration and status. This retrieval is more efficient and lowers the load imposed on the VDSM.<br><br>Previously one request per virtual machine was made which caused a high load on the VDSM.

#### oVirt Engine Extension AAA LDAP

##### Team: Infra

 - [BZ 1388083](https://bugzilla.redhat.com/1388083) <b>Use mod_auth_gssapi and mod_session instead of mod_auth_kerb for Kerberos SSO</b><br>Red Hat Enterprise Linux 6 used mod_auth_kerb to setup Kerberos SSO, but this module has been deprecated; mod_auth_gssapi is used instead. This update ensures mod_auth_gssapi and mod_session is used, and that example configurations have been updated.<br><br>For existing customers, mod_auth_kerb will continue to work with previous versions of Red Hat Enterprise Virtualization.

### Rebase: Bug Fixes and Enhancements

#### oVirt Engine

##### Team: Infra

 - [BZ 1368985](https://bugzilla.redhat.com/1368985) <b>[RFE] Rebase on wildfly-10.1.0</b><br>Rebase package(s) to version: 10.1.0<br><br>Highlights, important fixes, or notable enhancements: <br>See Wildfly 10.1.0 release notes: http://wildfly.org/news/2016/08/19/WildFly10-1-Released/

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1383577](https://bugzilla.redhat.com/1383577) <b>[Tracking] ovirt-engine-dashboard 4.0.5</b><br>

### Unclassified

#### oVirt Engine

##### Team: Infra

 - [BZ 1377310](https://bugzilla.redhat.com/1377310) <b>Engine log is flooded by UnknownHostException logs</b><br>
 - [BZ 1373456](https://bugzilla.redhat.com/1373456) <b>Debug message for start and end of DWH heartbeat</b><br>
 - [BZ 1381606](https://bugzilla.redhat.com/1381606) <b>desktopLogin sends empty password, impacts desktop SSO feature</b><br>
 - [BZ 1373581](https://bugzilla.redhat.com/1373581) <b>REST API v4 | Creating a NFS storage domain with invalid options will ignore them and use the defaults with no warning</b><br>
 - [BZ 1373092](https://bugzilla.redhat.com/1373092) <b>If error occurred, there should be printed only error description, not full stack trace on login screen</b><br>
 - [BZ 1383831](https://bugzilla.redhat.com/1383831) <b>"Heartbeat exeeded" error message should be "Heartbeat exceeded"</b><br>
 - [BZ 1380780](https://bugzilla.redhat.com/1380780) <b>Problems with auth based on group membership</b><br>
 - [BZ 1379805](https://bugzilla.redhat.com/1379805) <b>Consolidate SSO session validation requests</b><br>
 - [BZ 1376003](https://bugzilla.redhat.com/1376003) <b>Internal server error once automatically logged out from rhv-m and then trying to re-login back to the session</b><br>
 - [BZ 1377422](https://bugzilla.redhat.com/1377422) <b>Engine should not invoke revoke all on session expiration</b><br>

##### Team: Integration

 - [BZ 1371366](https://bugzilla.redhat.com/1371366) <b>[TEXT] - "Trying to upgrade from unsupported versions" is confusing</b><br>
 - [BZ 1360363](https://bugzilla.redhat.com/1360363) <b>engine-setup instructs to setup a remote dwh even if one already is</b><br>

##### Team: Network

 - [BZ 1377783](https://bugzilla.redhat.com/1377783) <b>[TEXT] - Choosing to deploy Neutron provider on host should warn user</b><br>A warning message appears above the configuration panel for external network providers in the new host window.<br><br>Text:<br>Automatic deployment of the Neutron provider on host may not work.<br>It is highly recommended to manually deploy the OVS agent on the host.

##### Team: SLA

 - [BZ 1379802](https://bugzilla.redhat.com/1379802) <b>VmPool creation won't honor template's quota</b><br>

##### Team: Storage

 - [BZ 1389455](https://bugzilla.redhat.com/1389455) <b>Trying to use extended LUN size results in REFRESH_LUN_ERROR</b><br>
 - [BZ 1381322](https://bugzilla.redhat.com/1381322) <b>VM disks in the VM configuration gui are shown in no particular order.</b><br>
 - [BZ 1378402](https://bugzilla.redhat.com/1378402) <b>Creation of template from VM with Cinder disks fails</b><br>
 - [BZ 1377442](https://bugzilla.redhat.com/1377442) <b>Clone from snapshot on Cinder hangs</b><br>
 - [BZ 1371024](https://bugzilla.redhat.com/1371024) <b>[v4 REST-API only] VM in export domain has disks collection and not  diskattachments collection</b><br>

##### Team: UX

 - [BZ 1371884](https://bugzilla.redhat.com/1371884) <b>Dashboard: top utilized - renaming VM causes that multiple records are shown</b><br>
 - [BZ 1389998](https://bugzilla.redhat.com/1389998) <b>[UI] - ui exception is thrown when closing every dialog window in the webadmin portal with the 'x' sign</b><br>
 - [BZ 1386765](https://bugzilla.redhat.com/1386765) <b>UI exception thrown when selecting numerous sub tabs</b><br>

##### Team: Virt

 - [BZ 1384770](https://bugzilla.redhat.com/1384770) <b>Upgrade from 3.6 to 4.0 fails on 04_00_0140_convert_memory_snapshots_to_disks.sql</b><br>
 - [BZ 1383738](https://bugzilla.redhat.com/1383738) <b>Legacy migration settings don't apply</b><br>
 - [BZ 1378933](https://bugzilla.redhat.com/1378933) <b>Certificate subject missing from the API</b><br>
 - [BZ 1374731](https://bugzilla.redhat.com/1374731) <b>disable migration compression in the default policy</b><br>
 - [BZ 1356568](https://bugzilla.redhat.com/1356568) <b>VM CPU hot plug along with memory hot add, leave VM pending SOUND change.</b><br>

#### oVirt Engine SDK 4 Ruby

##### Team: Infra

 - [BZ 1377682](https://bugzilla.redhat.com/1377682) <b>missing dependency: curb</b><br>
 - [BZ 1378066](https://bugzilla.redhat.com/1378066) <b>undefined method end_element</b><br>

#### VDSM

##### Team: Infra

 - [BZ 1377069](https://bugzilla.redhat.com/1377069) <b>DeprecationWarning: vdscli uses xmlrpc. since ovirt 3.6 xmlrpc is deprecated, please use vdsm.jsonrpcvdscli</b><br>
 - [BZ 1377773](https://bugzilla.redhat.com/1377773) <b>Prefer socket pending over dispatcher</b><br>
 - [BZ 1381899](https://bugzilla.redhat.com/1381899) <b>The python jsonrpc client is parsing the API schema on each connect eating a lot of CPU cycles</b><br>

##### Team: Network

 - [BZ 1367378](https://bugzilla.redhat.com/1367378) <b>vdsm can not handle all ifcfg files created by NM</b><br>
 - [BZ 1364087](https://bugzilla.redhat.com/1364087) <b>[OVS] Restore IP+link configuration before libvirtd.service start</b><br>

##### Team: Virt

 - [BZ 1365051](https://bugzilla.redhat.com/1365051) <b>Importing VMs from KVM fails when using  qemu+tcp libvirt uri</b><br>
 - [BZ 1369822](https://bugzilla.redhat.com/1369822) <b>Remove usage of python warnings module</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1378111](https://bugzilla.redhat.com/1378111) <b>[z-stream clone - 4.0.5] [TEXT][HE] Warn on addition of new HE host via host-deploy</b><br>
 - [BZ 1377778](https://bugzilla.redhat.com/1377778) <b>Change HE cluster name will fail upgrade-appliance</b><br>

#### oVirt Release Package

##### Team: Node

 - [BZ 1346872](https://bugzilla.redhat.com/1346872) <b>Hide boot entry of original root filesystem created by anaconda</b><br>

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1368768](https://bugzilla.redhat.com/1368768) <b>Dashboard: bubble text is shown way outside the dialog in top resources - storage dialog box</b><br>
 - [BZ 1353900](https://bugzilla.redhat.com/1353900) <b>Tooltip is partially hidden when hovering over utilization donut</b><br>

#### VDSM JSON-RPC Java

##### Team: Infra

 - [BZ 1362193](https://bugzilla.redhat.com/1362193) <b>[engine-backend] NPE for a failed GetCapabilitiesVDSCommand</b><br>
 - [BZ 1383831](https://bugzilla.redhat.com/1383831) <b>"Heartbeat exeeded" error message should be "Heartbeat exceeded"</b><br>

#### oVirt Cockpit Plugin

##### Team: Node

 - [BZ 1366164](https://bugzilla.redhat.com/1366164) <b>The number(1 2 3 4) show as a dot during deploy HE because it was identified as password input</b><br>

## Bug fixes

### oVirt Engine

#### Team: Gluster

 - [BZ 1313497](https://bugzilla.redhat.com/1313497) <b>Enabling Gluster Service post-facto on HE does not update brick info</b><br>

#### Team: Infra

 - [BZ 1373847](https://bugzilla.redhat.com/1373847) <b>Host that is set with protocol=xml fails cluster upgrade</b><br>

#### Team: SLA

 - [BZ 1370907](https://bugzilla.redhat.com/1370907) <b>When upgrading hosted engine host from the ui the host remains in maintenance mode</b><br>
 - [BZ 1351576](https://bugzilla.redhat.com/1351576) <b>Update cluster scheduling policy always set default properties</b><br>
 - [BZ 1384563](https://bugzilla.redhat.com/1384563) <b>Miss power management parameters under power_saving policy</b><br>

#### Team: Storage

 - [BZ 1367488](https://bugzilla.redhat.com/1367488) <b>Failed to create VM from registered template</b><br>
 - [BZ 1186817](https://bugzilla.redhat.com/1186817) <b>VM fails to start after changing IDE disk boot order</b><br>

#### Team: UX

 - [BZ 1326452](https://bugzilla.redhat.com/1326452) <b>Paging buttons in the view are not reset when selecting a different cluster</b><br>

### VDSM

#### Team: Storage

 - [BZ 1303550](https://bugzilla.redhat.com/1303550) <b>[vdsm] Require selinux-policy fix for CephFS (platform bug 1365640 - released 2016-Sep-15)</b><br>
 - [BZ 1367281](https://bugzilla.redhat.com/1367281) <b>Live merge fails after a disk containing a snapshot has been extended</b><br>
 - [BZ 1303578](https://bugzilla.redhat.com/1303578) <b>[scale] GetDeviceListVDSCommand takes 6-10s on average for large storage domains</b><br>

#### Team: Virt

 - [BZ 1380822](https://bugzilla.redhat.com/1380822) <b>Some migration options don't apply</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1373484](https://bugzilla.redhat.com/1373484) <b>Initial HE VM config must include maxVCpus parameter in order to support CPU hotplug</b><br>

### oVirt ISO Uploader

#### Team: Integration

 - [BZ 1335170](https://bugzilla.redhat.com/1335170) <b>nfs-utils package is required by iso-uploader but is not a dependency</b><br>

### oVirt Host Deploy

#### Team: SLA

 - [BZ 1353600](https://bugzilla.redhat.com/1353600) <b>hosted-engine-host maintenance mode is not attached engine maintenance status</b><br>

### oVirt Engine DWH

#### Team: Integration

 - [BZ 1365427](https://bugzilla.redhat.com/1365427) <b>engine-setup asks about scale also on upgrade/restore from 3.6</b><br>

### oVirt Optimizer

#### Team: SLA

 - [BZ 1388394](https://bugzilla.redhat.com/1388394) <b>Cancel optimizer/ start here buttons doesn't work properly</b><br>


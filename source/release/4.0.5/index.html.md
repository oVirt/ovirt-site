---
title: oVirt 4.0.5 Release Notes
category: documentation
authors: sandrobonazzola
---

# oVirt 4.0.5 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.5
First Release Candidate as of September 29th, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

This is pre-release software.
Please take a look at our [community page](http://www.ovirt.org/community/) to know how to
ask questions and interact with developers and users.
All issues or bugs should be reported via the [Red Hat Bugzilla](https://bugzilla.redhat.com/).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature complete.

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](http://www.ovirt.org/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

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

## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release40-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release40-pre.rpm)

To test this pre release, you may read our [Quick Start Guide](Quick Start Guide) or
a more updated documentation from our downstream
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/)

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow
[Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide or the
corresponding Red Hat Virtualization [Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide
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

 - [BZ 1346847](https://bugzilla.redhat.com/1346847) <b>virt-v2v basic REST API</b><br>Feature: Ability to import virtual machines from WMware, WMware OVA, XEN and KVM via oVirt REST API.<br><br>Reason: It was possible to do such import only using the web UI.<br><br>Result: Now it is possible to perform the import also using the RESTful API.

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1343451](https://bugzilla.redhat.com/1343451) <b>upgrade-appliance should warn about sshd keys changes</b><br>During the migration of the hosted-engine VM from 3.6/el6 to 4.0/el7, hosted-engine-setup is going to deploy a new appliance and so the ssh keys are going to be regenerated.<br>So the user has to remove previous entries from know_hosts on his clients.

### Rebase: Bug Fixes and Enhancements

#### oVirt Engine

##### Team: Infra

 - [BZ 1368985](https://bugzilla.redhat.com/1368985) <b>[RFE] Rebase on wildfly-10.1.0</b><br>Rebase package(s) to version: 10.1.0<br><br>Highlights, important fixes, or notable enhancements: <br>See Wildfly 10.1.0 release notes: http://wildfly.org/news/2016/08/19/WildFly10-1-Released/

### Unclassified

#### oVirt Engine

##### Team: Infra

 - [BZ 1377310](https://bugzilla.redhat.com/1377310) <b>Engine log is flooded by UnknownHostException logs</b><br>
 - [BZ 1373456](https://bugzilla.redhat.com/1373456) <b>DWH alerts "Can not sample data, oVirt Engine is not updating the statistics"</b><br>
 - [BZ 1373581](https://bugzilla.redhat.com/1373581) <b>REST API v4 | Creating a NFS storage domain with invalid options will ignore them and use the defaults with no warning</b><br>
 - [BZ 1373092](https://bugzilla.redhat.com/1373092) <b>If error occurred, there should be printed only error description, not full stack trace on login screen</b><br>
 - [BZ 1376003](https://bugzilla.redhat.com/1376003) <b>Internal server error once automatically logged out from rhv-m and then trying to re-login back to the session</b><br>
 - [BZ 1377422](https://bugzilla.redhat.com/1377422) <b>Engine should not invoke revoke all on session expiration</b><br>

##### Team: Integration

 - [BZ 1360363](https://bugzilla.redhat.com/1360363) <b>engine-setup instructs to setup a remote dwh even if one already is</b><br>

##### Team: Storage

 - [BZ 1378402](https://bugzilla.redhat.com/1378402) <b>Creation of template from VM with Cinder disks fails</b><br>
 - [BZ 1377442](https://bugzilla.redhat.com/1377442) <b>Clone from snapshot on Cinder hangs</b><br>
 - [BZ 1371024](https://bugzilla.redhat.com/1371024) <b>[v4 REST-API only] VM in export domain has disks collection and not  diskattachments collection</b><br>

##### Team: UX

 - [BZ 1371884](https://bugzilla.redhat.com/1371884) <b>Dashboard: top utilized - renaming VM causes that multiple records are shown</b><br>

##### Team: Virt

 - [BZ 1369521](https://bugzilla.redhat.com/1369521) <b>After cluster upgrade from 3.6 to 4.0 with running HA vm, if vm is killed outside engine it starts as a 3.6 vm</b><br>
 - [BZ 1374731](https://bugzilla.redhat.com/1374731) <b>disable migration compression in the default policy</b><br>
 - [BZ 1356568](https://bugzilla.redhat.com/1356568) <b>VM CPU hot plug along with memory hot add, leave VM pending SOUND change.</b><br>

#### VDSM

##### Team: Infra

 - [BZ 1372093](https://bugzilla.redhat.com/1372093) <b>vdsm sos plugin should collect 'nodectl info' output</b><br>
 - [BZ 1377069](https://bugzilla.redhat.com/1377069) <b>DeprecationWarning: vdscli uses xmlrpc. since ovirt 3.6 xmlrpc is deprecated, please use vdsm.jsonrpcvdscli</b><br>
 - [BZ 1377773](https://bugzilla.redhat.com/1377773) <b>Prefer socket pending over dispatcher</b><br>

##### Team: Network

 - [BZ 1372798](https://bugzilla.redhat.com/1372798) <b>Setupnetworks not removing the "BRIDGE=" entry in ifcfg file  when changing a untagged network to tagged</b><br>
 - [BZ 1379115](https://bugzilla.redhat.com/1379115) <b>[OVS] Use Linux bonds with OVS networks (instead of OVS Bonds)</b><br>
 - [BZ 1364087](https://bugzilla.redhat.com/1364087) <b>[OVS] Restore IP+link configuration before libvirtd.service start</b><br>

##### Team: Virt

 - [BZ 1365051](https://bugzilla.redhat.com/1365051) <b>Importing VMs from KVM fails when using  qemu+tcp libvirt uri</b><br>
 - [BZ 1369822](https://bugzilla.redhat.com/1369822) <b>Remove usage of python warnings module</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1378111](https://bugzilla.redhat.com/1378111) <b>[z-stream clone - 4.0.5] [TEXT][HE] Warn on addition of new HE host via host-deploy</b><br>
 - [BZ 1347340](https://bugzilla.redhat.com/1347340) <b>[RFE] hosted engine should check the actual size of the qcow instead of relying on the OVA</b><br>
 - [BZ 1377778](https://bugzilla.redhat.com/1377778) <b>Change HE cluster name will fail upgrade-appliance</b><br>

#### oVirt Host Deploy

##### Team: Network

 - [BZ 1373968](https://bugzilla.redhat.com/1373968) <b>Deploying a host with an external Neutron network configured fails</b><br>

## Bug fixes

### oVirt Engine

#### Team: Gluster

 - [BZ 1313497](https://bugzilla.redhat.com/1313497) <b>Enabling Gluster Service post-facto on HE does not update brick info</b><br>

#### Team: Infra

 - [BZ 1372320](https://bugzilla.redhat.com/1372320) <b>"Started - Finished" Messages in the audit log without any information</b><br>

#### Team: SLA

 - [BZ 1370907](https://bugzilla.redhat.com/1370907) <b>When upgrading hosted engine host from the ui the host remains in maintenance mode</b><br>
 - [BZ 1351576](https://bugzilla.redhat.com/1351576) <b>Update cluster scheduling policy always set default properties</b><br>

#### Team: Storage

 - [BZ 1367488](https://bugzilla.redhat.com/1367488) <b>Failed to create VM from registered template</b><br>
 - [BZ 1186817](https://bugzilla.redhat.com/1186817) <b>VM fails to start after changing IDE disk boot order</b><br>

#### Team: UX

 - [BZ 1326452](https://bugzilla.redhat.com/1326452) <b>Paging buttons in the view are not reset when selecting a different cluster</b><br>

### VDSM

#### Team: Storage

 - [BZ 1367281](https://bugzilla.redhat.com/1367281) <b>Live merge fails after a disk containing a snapshot has been extended</b><br>
 - [BZ 1303578](https://bugzilla.redhat.com/1303578) <b>[scale] GetDeviceListVDSCommand takes 6-10s on average for large storage domains</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1373484](https://bugzilla.redhat.com/1373484) <b>Initial HE VM config must include maxVCpus parameter in order to support CPU hotplug</b><br>

### oVirt ISO Uploader

#### Team: Integration

 - [BZ 1335170](https://bugzilla.redhat.com/1335170) <b>nfs-utils package is required by iso-uploader but is not a dependency</b><br>

### oVirt Host Deploy

#### Team: SLA

 - [BZ 1353600](https://bugzilla.redhat.com/1353600) <b>hosted-engine-host maintenance mode is not attached engine maintenance status</b><br>


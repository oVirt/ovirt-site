---
title: oVirt 4.0.1 Release Notes
category: documentation
authors: rafaelmartins
---

# oVirt 4.0.1 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.1 Release Candidate 1 as of July 1st, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

This is pre-release software. Please take a look at our [community page](http://www.ovirt.org/community/) to know how to ask questions and interact with developers and users. All issues or bugs should be reported via the [Red Hat Bugzilla](https://bugzilla.redhat.com/). The oVirt Project makes no guarantees as to its suitability or usefulness. This pre-release should not to be used in production, and it is not feature complete.

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](http://www.ovirt.org/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

## RELEASE CANDIDATE

In order to install oVirt 4.0.1 Release Candidate you will need to enable oVirt 4.0.1 pre-release repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://plain.resources.ovirt.org/pub/ovirt-4.0-pre/rpm/el7/noarch/ovirt-release40-pre.rpm`](http://plain.resources.ovirt.org/pub/ovirt-4.0-pre/rpm/el7/noarch/ovirt-release40-pre.rpm)

To test oVirt 4.0.1 rc1 release, you should read our [Quick Start Guide](Quick Start Guide).

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

## What's New in 4.0.1?

### Enhancement

#### oVirt Engine

##### Team: Infra

 - [BZ 1268133](https://bugzilla.redhat.com/1268133) <b>[RFE] RHEV Manager support for SNMPv3 traps</b><br>Support for SNMPv3 traps was added, so RHEVM is able to provide SNMP v2c and v3 traps.<br>
 - [BZ 1347157](https://bugzilla.redhat.com/1347157) <b>[v4] capabilities was removed</b><br>Replace /capabilities with /clusterlevels top level collection.<br>

### Unclassified

#### oVirt Engine

##### Team: Network

 - [BZ 1343332](https://bugzilla.redhat.com/1343332) <b>[Network] When all mac range is allocated after engine restart got 404 - Not Found</b><br>
 - [BZ 1340644](https://bugzilla.redhat.com/1340644) <b>[REST-API] - Creating bond with network attached via rest leaving the setup networks dialog in unrecoverable state</b><br>
 - [BZ 1347931](https://bugzilla.redhat.com/1347931) <b>REST-API V4 | Missing network_filter <name> when creating vnic profile with default filter</b><br>

##### Team: Virt

 - [BZ 1349368](https://bugzilla.redhat.com/1349368) <b>'Disable smartcard' checkbox does not work (no change in console.vv file)</b><br>
 - [BZ 1346270](https://bugzilla.redhat.com/1346270) <b>Pool VM loses its disk during reinitialisation after shutdown.</b><br>
 - [BZ 1345791](https://bugzilla.redhat.com/1345791) <b>Cannot go fullscreen from user portal (wrong value in console.vv)</b><br>The "full screen" option from console options dialog was ignored.<br><br>After this fix the console will respect the "full screen" option from this dialog.
 - [BZ 1348468](https://bugzilla.redhat.com/1348468) <b>VM pool in REST is missing all devices but RNG</b><br>
 - [BZ 1341268](https://bugzilla.redhat.com/1341268) <b>REST API for Kernel cmdline</b><br>

##### Team: Storage

 - [BZ 1350708](https://bugzilla.redhat.com/1350708) <b>Hot unplug disk using REST API returns "Internal Server Error"</b><br>
 - [BZ 1344314](https://bugzilla.redhat.com/1344314) <b>"VDSM HOST2 command failed: Cannot find master domain" after adding storage</b><br>
 - [BZ 1344367](https://bugzilla.redhat.com/1344367) <b>Uncaught UI exception when resuming disk upload</b><br>
 - [BZ 1349594](https://bugzilla.redhat.com/1349594) <b>REST-API v3 | Failed to update VM disk interface to virtio_scsi</b><br>
 - [BZ 1350226](https://bugzilla.redhat.com/1350226) <b>Attach disk as VirtIO-ISCSI / SPAPR-VSCSI to a running VM fails</b><br>
 - [BZ 1350203](https://bugzilla.redhat.com/1350203) <b>NullPointerException UI exception is thrown when importing an unregistered VM</b><br>
 - [BZ 1350200](https://bugzilla.redhat.com/1350200) <b>ClassCastException UI exception when importing an unregistered VM with no applications listed</b><br>
 - [BZ 1350343](https://bugzilla.redhat.com/1350343) <b>RESTAPI : Luns collection in ISCSI SD returns always with only one item</b><br>
 - [BZ 1350207](https://bugzilla.redhat.com/1350207) <b>API for updating disk attachments is missing</b><br>
 - [BZ 1350208](https://bugzilla.redhat.com/1350208) <b>iptables should be configured automatically for ovirt-imageio-daemon</b><br>
 - [BZ 1347974](https://bugzilla.redhat.com/1347974) <b>UI - Wrong LUN check when editing ISCSI/FC domain</b><br>
 - [BZ 1342783](https://bugzilla.redhat.com/1342783) <b>Remove snapshot with its disk attached to other VM should be blocked</b><br>

##### Team: Integration

 - [BZ 1348073](https://bugzilla.redhat.com/1348073) <b>engine-setup does not lock packages on fedora 23</b><br>

##### Team: Infra

 - [BZ 1348805](https://bugzilla.redhat.com/1348805) <b>Import vm from export domain using REST API returns "Internal Server Error"</b><br>
 - [BZ 1346932](https://bugzilla.redhat.com/1346932) <b>My Groups option in the Add Permission to User dialog throws NPE (Query 'GetDirectoryGroupsForUserQuery' failed: null)</b><br>
 - [BZ 1344272](https://bugzilla.redhat.com/1344272) <b>Failed to execute login on behalf - for user admin.</b><br>
 - [BZ 1351217](https://bugzilla.redhat.com/1351217) <b>FQDN checking introduced by SSO should be case-insensitive or engine-setup should lower-case Host FQDN</b><br>
 - [BZ 1349008](https://bugzilla.redhat.com/1349008) <b>Host stuck on installing</b><br>
 - [BZ 1340451](https://bugzilla.redhat.com/1340451) <b>Some Sessions columns are not sortable</b><br>
 - [BZ 1350966](https://bugzilla.redhat.com/1350966) <b>REST-API v3 | Failed to destroy a storage domain</b><br>
 - [BZ 1349517](https://bugzilla.redhat.com/1349517) <b>Listing host storages on 4.0 using APIv3 causes internal error</b><br>
 - [BZ 1349092](https://bugzilla.redhat.com/1349092) <b>Add Users and Groups dialog: cannot close via 'X' button or Esc key</b><br>
 - [BZ 1348916](https://bugzilla.redhat.com/1348916) <b>When using provisioned/discovered hosts some fields are not filled in properly</b><br>
 - [BZ 1346299](https://bugzilla.redhat.com/1346299) <b>choosing satellite provider doesn't fill address field</b><br>
 - [BZ 1347007](https://bugzilla.redhat.com/1347007) <b>[Dashboard] Search mechanism does not know all storage statuses</b><br>
 - [BZ 1344284](https://bugzilla.redhat.com/1344284) <b>REST (V3 and V4)| <mac_pool href= is missing under /api/datacenters/<id></b><br>
 - [BZ 1346263](https://bugzilla.redhat.com/1346263) <b>satellite 6.2 changed katello API, incompatible with RHEV 3.6.7</b><br>
 - [BZ 1348138](https://bugzilla.redhat.com/1348138) <b>snapshot type not reported at all if Version: 3</b><br>
 - [BZ 1347155](https://bugzilla.redhat.com/1347155) <b>Can not get graphic console by id from VM under REST API V3</b><br>
 - [BZ 1347148](https://bugzilla.redhat.com/1347148) <b>Localization strings for SSO module needs to use indexes for string substitutions to be translatable</b><br>

##### Team: SLA

 - [BZ 1350228](https://bugzilla.redhat.com/1350228) <b>Add affinity label to the VM or to the host does not return in response body entity</b><br>
 - [BZ 1348559](https://bugzilla.redhat.com/1348559) <b>Can not create quota limits via REST(V4)</b><br>

##### Team: UX

 - [BZ 1344428](https://bugzilla.redhat.com/1344428) <b>[scale] The Dashboard takes a long time to load on a medium scale system (39 Hosts/3K VMs)</b><br>
 - [BZ 1347017](https://bugzilla.redhat.com/1347017) <b>Cannot switch to UI plugin contributed sub tabs</b><br>
 - [BZ 1348278](https://bugzilla.redhat.com/1348278) <b>oVirt 4.0 translation cycle 2</b><br>

#### VDSM

##### Team: Storage

 - [BZ 1349033](https://bugzilla.redhat.com/1349033) <b>Enable ovirt-imageio in rhev</b><br>
 - [BZ 1348256](https://bugzilla.redhat.com/1348256) <b>storage: fix schema validation warnings</b><br>

##### Team: Network

 - [BZ 1350723](https://bugzilla.redhat.com/1350723) <b>VDSM should not require openvswitch as it is not shipped in the Beta channel</b><br>

##### Team: Infra

 - [BZ 1349461](https://bugzilla.redhat.com/1349461) <b>Migrate Failed with "Bad file descriptor" error in vdsm</b><br>
 - [BZ 1350350](https://bugzilla.redhat.com/1350350) <b>[RFE] Add reports module to vdsm</b><br>

#### VDSM JSON-RPC Java

##### Team: Infra

 - [BZ 1349008](https://bugzilla.redhat.com/1349008) <b>Host stuck on installing</b><br>

#### oVirt Engine Extension AAA LDAP

##### Team: Infra

 - [BZ 1349305](https://bugzilla.redhat.com/1349305) <b>[ovirt-engine-extension-aaa-ldap-setup] No timeout when server is down</b><br>
 - [BZ 1340380](https://bugzilla.redhat.com/1340380) <b>[RFE] Assume 'Active Directory Forest name' is by default equal to profile name</b><br>

## Bug fixes

### oVirt Engine

#### Team: Virt

 - [BZ 1318955](https://bugzilla.redhat.com/1318955) <b>VM in pool reported as stateful</b><br>
 - [BZ 1305600](https://bugzilla.redhat.com/1305600) <b>Setting vm ticket using REST doesn't report error</b><br>

#### Team: Gluster

 - [BZ 1262046](https://bugzilla.redhat.com/1262046) <b>[HC] When glusterd is down - show alert and provide an option to restart glusterd</b><br>

#### Team: Storage

 - [BZ 1325863](https://bugzilla.redhat.com/1325863) <b>Storage connections collection for gluster storage domains is empty from API</b><br>
 - [BZ 1302780](https://bugzilla.redhat.com/1302780) <b>Can't clone vm from template as thin copy to an imported domain with a copy of the template disk</b><br>
 - [BZ 1328887](https://bugzilla.redhat.com/1328887) <b>Image Uploader: when not filling in mandatory fields: Size(GB), Alias - Uncaught exception Cannot read property 'H' of undefined</b><br>
 - [BZ 1324076](https://bugzilla.redhat.com/1324076) <b>SD metadata indicates that its attached to DC while it is not, preventing remove and format storage</b><br>

#### Team: Network

 - [BZ 1329224](https://bugzilla.redhat.com/1329224) <b>[Host QoS] - It's not possible to set an anonymous QoS on a network via the setup networks</b><br>

#### Team: Infra

 - [BZ 1323484](https://bugzilla.redhat.com/1323484) <b>oVirt welcome page locale selector is broken</b><br>
 - [BZ 1336838](https://bugzilla.redhat.com/1336838) <b>engine doesn't trust externally-issued web certificate for internal authentication in spite of issuer being in system (and java) trust store</b><br>

### VDSM

#### Team: Infra

 - [BZ 1279555](https://bugzilla.redhat.com/1279555) <b>Add drop-in dir for vdsm configuration file</b><br>

### MOM

#### Team: SLA

 - [BZ 1234953](https://bugzilla.redhat.com/1234953) <b>the error "The ovirt-guest-agent is not active" should not appear when vm is in powering up state</b><br>

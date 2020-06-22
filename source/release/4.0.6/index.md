---
title: oVirt 4.0.6 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 4.0.6 Release Notes

The oVirt Project is pleased to announce the availability of 4.0.6
Release as
of January 10, 2017.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2
(or similar).



To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

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


and then follow documentation from our downstream
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/)


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup

Upgrade on Fedora 22 and Enterprise Linux 6 is not supported and you should
follow our [Migration Guide](../../documentation/migration-engine-36-to-40/) in
order to migrate to Enterprise Linux 7 or Fedora 23.


### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding Red Hat Virtualization
[Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding Red Hat Virtualization
[Upgrade Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/upgrade-guide/)## What's New in 4.0.6?

### Enhancement

#### VDSM

##### Team: SLA

 - [BZ 1374988](https://bugzilla.redhat.com/1374988) <b>MOM causes Vdsm to slow down, high number of 'vmGetIoTunePolicy' API calls - vdsm</b><br>Feature: <br><br>Use just one request (instead one per VM) to retrieve the ioTune configuration and status.<br><br>Reason: <br><br>The amount of requests needed was causing high load on VDSM.<br><br>Result: <br><br>MOM can now use much more efficient data retrieval method that would lower the load imposed on VDSM.

### No Doc Update

#### VDSM

##### Team: SLA

 - [BZ 1348255](https://bugzilla.redhat.com/1348255) <b>sla: fix schema validation warnings</b><br>undefined

##### Team: Storage

 - [BZ 1401540](https://bugzilla.redhat.com/1401540) <b>[z-stream clone - 4.0.6] HE VM shutdown abruptly when master storage domain is put into maintenance mode</b><br>undefined

### Unclassified

#### VDSM

##### Team: Gluster

 - [BZ 1368474](https://bugzilla.redhat.com/1368474) <b>Creation of gluster bricks should also set the proper selinux labels on them</b><br>
 - [BZ 1402248](https://bugzilla.redhat.com/1402248) <b>Gluster Brick Creation fails while running restorecon on the brick mount point</b><br>

##### Team: Infra

 - [BZ 1391877](https://bugzilla.redhat.com/1391877) <b>[z-stream clone - 4.0.6] After ovirt-engine is restarted, hypervisors stop listening on 54321 until vdsm is restarted.</b><br>

##### Team: Network

 - [BZ 1390474](https://bugzilla.redhat.com/1390474) <b>vdsm should handle ifcfg files that have PHYSDEV= instead DEVICE= for vlan connection created with nmcli</b><br>
 - [BZ 1392989](https://bugzilla.redhat.com/1392989) <b>vdsmd start fails due to dead symlink /etc/resolv.conf</b><br>
 - [BZ 1372798](https://bugzilla.redhat.com/1372798) <b>Setupnetworks not removing the "BRIDGE=" entry in ifcfg file  when changing a untagged network to tagged</b><br>
 - [BZ 1374194](https://bugzilla.redhat.com/1374194) <b>[OVS] - Allow to configure also a prefix for a network static ip</b><br>

##### Team: Storage

 - [BZ 1399688](https://bugzilla.redhat.com/1399688) <b>Snapshot delete on HSM fails</b><br>
 - [BZ 1377849](https://bugzilla.redhat.com/1377849) <b>LV is not deactivated after live merge when the VM is running on HSM</b><br>

##### Team: Virt

 - [BZ 1401583](https://bugzilla.redhat.com/1401583) <b>[z-stream clone - 4.0.6] Numa sampling causes very high load on the hypervisor.</b><br>Numa sampling could previously cause unnecessarily high load on complex host. We therefore reduced the sample interval to 10 minutes as that is enough for rarely-changing NUMA topology.

#### oVirt Engine SDK 4 Python

##### Team: Infra

 - [BZ 1392878](https://bugzilla.redhat.com/1392878) <b>Debug mode raises UnicodeDecodeError: 'utf8' codec can't decode byte 0x8d in position 7: invalid start byte</b><br>
 - [BZ 1382644](https://bugzilla.redhat.com/1382644) <b>Examples are not packaged in the RPM (but are mentioned in the README file)</b><br>

#### oVirt Engine

##### Team: Gluster

 - [BZ 1368474](https://bugzilla.redhat.com/1368474) <b>Creation of gluster bricks should also set the proper selinux labels on them</b><br>

##### Team: Infra

 - [BZ 1374171](https://bugzilla.redhat.com/1374171) <b>Commands are not polled properly</b><br>
 - [BZ 1401585](https://bugzilla.redhat.com/1401585) <b>The pendingOperation task processing will lose tasks in case an exception is thrown</b><br>
 - [BZ 1398550](https://bugzilla.redhat.com/1398550) <b>[z-stream clone - 4.0.6] Postgres DB overloads the CPU when specific bookmarks queries are triggered.</b><br>
 - [BZ 1392487](https://bugzilla.redhat.com/1392487) <b>First Name not displayed for admin under users tab</b><br>
 - [BZ 1394508](https://bugzilla.redhat.com/1394508) <b>[z-stream clone - 4.0.6] RHVH-NG is automatically activated after upgrade.</b><br>
 - [BZ 1394184](https://bugzilla.redhat.com/1394184) <b>No error message is shown on login with missing username</b><br>
 - [BZ 1391643](https://bugzilla.redhat.com/1391643) <b>SSO token expiration should be returned as long</b><br>
 - [BZ 1391646](https://bugzilla.redhat.com/1391646) <b>auth domains used to be sorted alphabetically in the past in login screens</b><br>
 - [BZ 1391146](https://bugzilla.redhat.com/1391146) <b>[User Portal] opening spice console for an AD user without GA running causes 'VmLogon: Internal Engine Error'</b><br>
 - [BZ 1389251](https://bugzilla.redhat.com/1389251) <b>User is not able to edit her profile - Connect Automatically and SSH Public Key options</b><br>
 - [BZ 1391370](https://bugzilla.redhat.com/1391370) <b>[z-stream clone - 4.0.6] Engine commands stuck on hosts with: Unrecognized protocol: 'SUBSCRI'.</b><br>

##### Team: Metrics

 - [BZ 1398944](https://bugzilla.redhat.com/1398944) <b>users_details_history table is being updated too much</b><br>

##### Team: Network

 - [BZ 1382341](https://bugzilla.redhat.com/1382341) <b>Network is resolved in NetworkAttachment</b><br>

##### Team: SLA

 - [BZ 1358383](https://bugzilla.redhat.com/1358383) <b>The engine VM doesn't restart on Conroe hosts regardless of cluster CPU level</b><br>

##### Team: Storage

 - [BZ 1362464](https://bugzilla.redhat.com/1362464) <b>REST-API v4 is ignoring disk attributes requested when thin cloning a vm from a template</b><br>
 - [BZ 1395793](https://bugzilla.redhat.com/1395793) <b>Cloning VM will cause both source VM's and cloned VM's disks to stay in locked state</b><br>
 - [BZ 1396108](https://bugzilla.redhat.com/1396108) <b>[z-stream clone - 4.0.6] Migration of HE Disk ends up in Locked State</b><br>
 - [BZ 1383264](https://bugzilla.redhat.com/1383264) <b>[v4 REST-API only] diskattachments link missing from /api/storagedomains/{export-domain:id}/vms/{vm:id}</b><br>
 - [BZ 1397866](https://bugzilla.redhat.com/1397866) <b>Creating a pool of 5 VM's from template fails</b><br>
 - [BZ 1392380](https://bugzilla.redhat.com/1392380) <b>Importing VMs from storage domain not working if the template does not have a disk</b><br>
 - [BZ 1390305](https://bugzilla.redhat.com/1390305) <b>Remove deprecated message when trying to move a disk from webadmin</b><br>
 - [BZ 1382357](https://bugzilla.redhat.com/1382357) <b>Error when creating a disk from within the VM dialog</b><br>

##### Team: Virt

 - [BZ 1392903](https://bugzilla.redhat.com/1392903) <b>VM is not monitored by engine, NPE @ org.ovirt.engine.core.vdsbroker.monitoring.VmAnalyzer.isVdsNonResponsive</b><br>
 - [BZ 1391466](https://bugzilla.redhat.com/1391466) <b>multi-dialog use in the VM dialog is incorrect and causing cleanup issues</b><br>
 - [BZ 1340722](https://bugzilla.redhat.com/1340722) <b>Redundant saves of vms in stable state</b><br>
 - [BZ 1373573](https://bugzilla.redhat.com/1373573) <b>Enhance error reporting when cluster compatibility update fails</b><br>
 - [BZ 1390254](https://bugzilla.redhat.com/1390254) <b>[z-stream clone - 4.0.5] Upgrade from 3.6 to 4.0 fails on 04_00_0140_convert_memory_snapshots_to_disks.sql</b><br>
 - [BZ 1369521](https://bugzilla.redhat.com/1369521) <b>After cluster upgrade from 3.6 to 4.0 with running HA vm, if vm is killed outside engine it starts as a 3.6 vm</b><br>
 - [BZ 1391933](https://bugzilla.redhat.com/1391933) <b>Do not block the VM monitoring thread when something unexpected shows up</b><br>
 - [BZ 1397279](https://bugzilla.redhat.com/1397279) <b>Memory, CPU and Network  utilization graphs are no longer displaying info for VMs under VMs main tab</b><br>

#### oVirt Engine Extension AAA JDBC

##### Team: Infra

 - [BZ 1391154](https://bugzilla.redhat.com/1391154) <b>Option --password=file does not reset the password</b><br>

#### VDSM JSON-RPC Java

##### Team: Infra

 - [BZ 1401585](https://bugzilla.redhat.com/1401585) <b>The pendingOperation task processing will lose tasks in case an exception is thrown</b><br>
 - [BZ 1391370](https://bugzilla.redhat.com/1391370) <b>[z-stream clone - 4.0.6] Engine commands stuck on hosts with: Unrecognized protocol: 'SUBSCRI'.</b><br>

#### oVirt Hosted Engine Setup

##### Team: Docs

 - [BZ 1387146](https://bugzilla.redhat.com/1387146) <b>Proxy set when running hosted-engine may prevent completion</b><br>Adding from https://gerrit.ovirt.org/#/c/65955/<br>network: <br>Add a warning if a proxy is in use, since a not properly configured proxy could prevent the host to reach the engine VM.

##### Team: Integration

 - [BZ 1397810](https://bugzilla.redhat.com/1397810) <b>The rollback will be uncorrected prevented if the 4.0 appliance disk is smaller than the on of 3.6 custom VM</b><br>
 - [BZ 1396193](https://bugzilla.redhat.com/1396193) <b>Hosted Engine upgrade is failing during engine-setup if the db backup file is not in /root/</b><br>

#### oVirt Hosted Engine HA

##### Team: Integration

 - [BZ 1397572](https://bugzilla.redhat.com/1397572) <b>The upgrade procedure fails if a 4.0 is added to a HE 3.5 cluster just partially upgraded to 3.6</b><br>

##### Team: SLA

 - [BZ 1376559](https://bugzilla.redhat.com/1376559) <b>ovirt hosted agent and broker logs duplicating</b><br>

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1356909](https://bugzilla.redhat.com/1356909) <b>Tooltip of Sparkline shows wrong time (UTC TimeZone)</b><br>
 - [BZ 1371893](https://bugzilla.redhat.com/1371893) <b>sparkline for CPU shows some changes, but tooltip says 0%</b><br>

#### oVirt Engine DWH

##### Team: Integration

 - [BZ 1364062](https://bugzilla.redhat.com/1364062) <b>[TEXT] - After remote DWH install prompt user to restart engine explaining that dashboard will not work until this is done.</b><br>

##### Team: Metrics

 - [BZ 1399162](https://bugzilla.redhat.com/1399162) <b>history_configuration table is being updated too much</b><br>
 - [BZ 1398944](https://bugzilla.redhat.com/1398944) <b>users_details_history table is being updated too much</b><br>

## Bug fixes

### VDSM

#### Team: SLA

 - [BZ 1393012](https://bugzilla.redhat.com/1393012) <b>when restarting vdsm, mom also restarting, and immediately failed.</b><br>
 - [BZ 1346926](https://bugzilla.redhat.com/1346926) <b>[scale] - momd memory leakage</b><br>

#### Team: Storage

 - [BZ 1321018](https://bugzilla.redhat.com/1321018) <b>The snapshot disk links are not removed after deleted.</b><br>

### oVirt Engine

#### Team: SLA

 - [BZ 1372000](https://bugzilla.redhat.com/1372000) <b>[Re opening] Support update of the HE OVF ad-hoc</b><br>

#### Team: Virt

 - [BZ 1402401](https://bugzilla.redhat.com/1402401) <b>Accessing the VMs tab causes an InvocationTargetException</b><br>

### VDSM JSON-RPC Java

#### Team: Infra

 - [BZ 1401976](https://bugzilla.redhat.com/1401976) <b>100% cpu when a even a single host is out</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1386293](https://bugzilla.redhat.com/1386293) <b>Host stuck in installing state during ovirt-hosted-engine-setup run</b><br>

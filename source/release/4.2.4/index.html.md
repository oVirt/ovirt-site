---
title: oVirt 4.2.4 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.4 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.4 First Release Candidate as of May 24, 2018.

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

To learn about features introduced before 4.2.4, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



### No Fedora support

Regretfully, Fedora is not supported anymore, and RPMs for it are not provided.
These are still built for the master branch, so users that want to test them,
can use the [nightly snapshot](/develop/dev-process/install-nightly-snapshot/).
At this point, we only try to fix problems specific to Fedora if they affect
developers. For some of the work to be done to restore support for Fedora, see
also tracker [bug 1460625](https://bugzilla.redhat.com/showdependencytree.cgi?id=1460625&hide_resolved=0).

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

## What's New in 4.2.4?

### Enhancements

#### oVirt Engine

 - [BZ 1568893](https://bugzilla.redhat.com/1568893) <b>Alert when guaranteed capacity reaches a threshold value</b><br>Feature: Notification on running our of physical space.<br><br>Reason: With VDO and Thin pool support, users may see more space, that it is available physically. This is totally fine and with VDO it is an expected behavior. At the same time, we can't predict, how much data user will be able to actually write. Because of that, to keep user informed, we would like to notify him, when he is running out of physical space and, at the same time, show him how much confirmed space he have.<br><br>Result: When confirmed space goes down below some configured threshold, an event is issued.
 - [BZ 1549030](https://bugzilla.redhat.com/1549030) <b>Update neutron binding after VM migration with info from caps</b><br>When a port is created/updated, it's "binding:host_id" attribute should be updated with the id of the provider driver id (for example OVN chassis id) reported during get_caps. <br>The port for which the binding has been reported, requires the binding to be set on every consecutive host it moves to. This could be a problem when migrating from a 4.2.2 level host to an earlier one. <br>Hosts before that do not report the host_id. When no provider driver id is reported, the "binding:host_id" is not set, and the value from the previous host will be kept. To fix this, the older hosts need to be updated with a newer version of the provider driver.
 - [BZ 1539765](https://bugzilla.redhat.com/1539765) <b>Auto-Sync - network rename on provider does not trigger rename in engine</b><br>Feature:  External network rename on provider is reflected in engine<br><br>Reason: The name of an external network in engine should be consistent with the name of the same network on the provider.<br><br>Result: Renaming an external network on the provider is reflected in engine.
 - [BZ 1568755](https://bugzilla.redhat.com/1568755) <b>[RFE] Ability to specify a folder of OVAs in import-VMs dialog</b><br>Feature: <br>Listing OVAs in a specified folder.<br><br>Reason: <br>Ease importing of VMs from OVA.<br><br>Result: <br>The user can provide a folder in import-VM dialog and as a result, will be provided with all the OVAs that reside in that folder.
 - [BZ 1579302](https://bugzilla.redhat.com/1579302) <b>support more granularity in cluster cpu types</b><br>Feature: <br>Support distinguishing cpus also by features they support, not just by model.<br><br>Reason: <br>If a new CPU feature is important, it is important to be able to distinguish if the CPU with some model also supports this feature and than require this feature also for VMs.<br><br>Result: <br>Now, it is possible to distinguish CPUs also by features and require them for the VMs.
 - [BZ 1577901](https://bugzilla.redhat.com/1577901) <b>[RFE] add content type column to disk table</b><br>

#### imgbased

 - [BZ 1574187](https://bugzilla.redhat.com/1574187) <b>[RFE] provide LVM stderr in imgbased if an exception is caught</b><br>Feature: Previously, imgbased squashed stderr from LVM commands to improve parsing reliability<br><br>Reason: In order to provide more verbose debugging<br><br>Result: imgbased now logs stderr from LVM commands

### Bug Fixes

#### oVirt Engine

 - [BZ 1574191](https://bugzilla.redhat.com/1574191) <b>SyncNetworkProviderCommand fails on NPE if Provider is DNP of a Cluster with no DC</b><br>
 - [BZ 1574451](https://bugzilla.redhat.com/1574451) <b>UI exception seen in RHEV-M</b><br>

#### VDSM

 - [BZ 1576675](https://bugzilla.redhat.com/1576675) <b>RHV import fails if VM has an unreachable floppy defined</b><br>

#### oVirt Engine Metrics

 - [BZ 1572508](https://bugzilla.redhat.com/1572508) <b>fluentd unable to connect keeps retrying every 3 minutes</b><br>

#### ovirt-engine-dwh

 - [BZ 1576937](https://bugzilla.redhat.com/1576937) <b>Value too long for type character varying(50) for host_interface_configuration and vm_interface_configuration</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1557775](https://bugzilla.redhat.com/1557775) <b>[RFE] During deployment, verification is missing for wrong NFS path.</b><br>

### Other

#### oVirt Engine

 - [BZ 1481022](https://bugzilla.redhat.com/1481022) <b>When blocking connection between host and NFS storage, a running VM doesn't switch to paused mode</b><br>
 - [BZ 1578763](https://bugzilla.redhat.com/1578763) <b>[downstream clone - 4.2.4] Unreachable ISO/Export SD prevents hosts from activating</b><br>
 - [BZ 1558709](https://bugzilla.redhat.com/1558709) <b>VM remains migrating forever with no Host (actually doesn't exist) after StopVmCommand fails to DestroyVDS</b><br>
 - [BZ 1548205](https://bugzilla.redhat.com/1548205) <b>Very slow UI if Host has many (~64) elements (VFs or dummies or networks)</b><br>
 - [BZ 1573216](https://bugzilla.redhat.com/1573216) <b>non-VM network appears in the new vNIC profile drop down</b><br>
 - [BZ 1573462](https://bugzilla.redhat.com/1573462) <b>wrong SinglePciQxl initialization during import from OVF</b><br>
 - [BZ 1561865](https://bugzilla.redhat.com/1561865) <b>[Code Change] - Validate duplicate MACs on unset 'Allow Duplicates' and  transaction rollback fix</b><br>
 - [BZ 1565673](https://bugzilla.redhat.com/1565673) <b>ovirt-engine loses track of a cancelled disk</b><br>
 - [BZ 1571849](https://bugzilla.redhat.com/1571849) <b>USB controllers not written to snapshots</b><br>
 - [BZ 1574480](https://bugzilla.redhat.com/1574480) <b>vGPU: Webadmin should reject VM snapshot creation when using mdev_type hook.</b><br>
 - [BZ 1578276](https://bugzilla.redhat.com/1578276) <b>[engine-setup] PostgreSQL conf verification text is broken</b><br>
 - [BZ 1558614](https://bugzilla.redhat.com/1558614) <b>OVA import does not set CPU topology correctly.</b><br>
 - [BZ 1568305](https://bugzilla.redhat.com/1568305) <b>empty vNIC profiles tab in edit Network dialog</b><br>
 - [BZ 1530027](https://bugzilla.redhat.com/1530027) <b>[RFE] - On OVS switch type with OVN, when defining a VM host network, auto-define an external localnet network based on it.</b><br>
 - [BZ 1539589](https://bugzilla.redhat.com/1539589) <b>ovn localnet - On OVS cluster don't allow to attach VM networks to VM</b><br>
 - [BZ 1551910](https://bugzilla.redhat.com/1551910) <b>[ja_JP] Text truncation observed on compute -> hosts -> network interfaces -> setup host networks page.</b><br>
 - [BZ 1543062](https://bugzilla.redhat.com/1543062) <b>Auto-sync - additional OVN cluster on DC does not consume OVN network as expected</b><br>
 - [BZ 1570383](https://bugzilla.redhat.com/1570383) <b>[PPC] Webadmin doesn't expose sPAPR VSCSI disk interface in disk creation prompt that is initiated from within VM creation prompt</b><br>
 - [BZ 1565534](https://bugzilla.redhat.com/1565534) <b>[UI] - Reverse the title and the entity on the NIC panel - MAC, Statistics and for the new vNIC design</b><br>
 - [BZ 1552449](https://bugzilla.redhat.com/1552449) <b>[UI] - Adjust VM's vNIC panel to the exact size of the host's NIC panel and align vNIC's icons to the center</b><br>
 - [BZ 1483846](https://bugzilla.redhat.com/1483846) <b>[UI] - Adjust the VM's vNIC panel to be similar to the new host NIC panel information design</b><br>
 - [BZ 1572157](https://bugzilla.redhat.com/1572157) <b>bad checkbox spacing in Logical Networks > New > Cluster</b><br>
 - [BZ 1570919](https://bugzilla.redhat.com/1570919) <b>[CodeChange][i18n] oVirt 4.2.4 translation pull</b><br>
 - [BZ 1541917](https://bugzilla.redhat.com/1541917) <b>[ja_JP] Text alignment correction needed on compute -> hosts -> new -> network provider window</b><br>
 - [BZ 1551994](https://bugzilla.redhat.com/1551994) <b>[All_LANG except zh,ko] Text truncation observed on networks -> networks -> import page.</b><br>
 - [BZ 1514374](https://bugzilla.redhat.com/1514374) <b>oVirt webadmin  StorageQoS input letters still could click confirm.</b><br>
 - [BZ 1560553](https://bugzilla.redhat.com/1560553) <b>OVA export: Not all VM parameters are set on imported VM from OVA.</b><br>
 - [BZ 1579909](https://bugzilla.redhat.com/1579909) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>Vdsm uses the domain metadata section to store extra data which is required to configure a VM but not properly represented on the standard libvirt domain.<br>This always happens when a VM starts.<br>Vdsm tried to store the drive IO tune settings in the metadata, which was redundant because the IO tune has already a proper representation.<br>Furthermore the implementation of the store operation of the IO tune settings had an implementation bug, which made it not possible to succesfully start the VM.<br>This bug appears only if IO tune settings are enabled.
 - [BZ 1563567](https://bugzilla.redhat.com/1563567) <b>Change CD dialog lists isos in non-ordered way, dialog list too small</b><br>
 - [BZ 1578756](https://bugzilla.redhat.com/1578756) <b>Importing an OVA made in ovirt failed on extract disks (ExtractOvaCommand)</b><br>
 - [BZ 1578416](https://bugzilla.redhat.com/1578416) <b>Register a partial Template with allow_partial flag throws an exception</b><br>
 - [BZ 1573091](https://bugzilla.redhat.com/1573091) <b>Do no force DB patch version and settings in setup for remote databases.</b><br>engine-setup now allows using a remote PostgreSQL database with a different Z version - e.g. 9.5.9 client (the engine machine) can use a 9.5.8 remote database server.<br><br>engine-setup also allows forcing it to ignore all PostgreSQL sanity/configuration checks.<br><br>Doc team: See also comment 6 for latter. I'd rather not include the details in the doc text.<br><br>For oVirt I added text to [1].<br><br>For RHV we might want a KB article.<br><br>[1] https://ovirt.org/develop/developer-guide/engine/engine-setup/
 - [BZ 1557770](https://bugzilla.redhat.com/1557770) <b>Webadmin-imageIO - 'Cancel' option should be removed from download disk</b><br>
 - [BZ 1573865](https://bugzilla.redhat.com/1573865) <b>[WebAdmin] Move disk dialog displays orange container for warning message even when it is empty</b><br>
 - [BZ 1576862](https://bugzilla.redhat.com/1576862) <b>Uploaded image: Virtual Size of qcow2 image is not reflected at guest OS level</b><br>
 - [BZ 1573913](https://bugzilla.redhat.com/1573913) <b>upload image dialog - test connection button should be displayed for any DC</b><br>
 - [BZ 1571154](https://bugzilla.redhat.com/1571154) <b>vdsm reports to engine  the local host network address IPv4 and IPv6 during the VM launch</b><br>
 - [BZ 1571323](https://bugzilla.redhat.com/1571323) <b>Create template fail sometimes</b><br>
 - [BZ 1570988](https://bugzilla.redhat.com/1570988) <b>Don't try to remove functions in public schema installed by PostgreSQL extensions</b><br>
 - [BZ 1566393](https://bugzilla.redhat.com/1566393) <b>When registering a VM that has disks on detached SD, error appears in engine.log, showing null as the SD name</b><br>
 - [BZ 1572067](https://bugzilla.redhat.com/1572067) <b>can't search in external providers</b><br>

#### VDSM

 - [BZ 1570349](https://bugzilla.redhat.com/1570349) <b>After upgrade from 4.1 to 4.2.3 vm disk is inactive and vm nic is un-plugged</b><br>
 - [BZ 1568696](https://bugzilla.redhat.com/1568696) <b>Failed to convert app: [[Ljava.lang.Object;] warning appear in engine.log</b><br>
 - [BZ 1579909](https://bugzilla.redhat.com/1579909) <b>Cannot start VM with QoS IOPS after host&engine upgrade from 4.1 to 4.2</b><br>Vdsm uses the domain metadata section to store extra data which is required to configure a VM but not properly represented on the standard libvirt domain.<br>This always happens when a VM starts.<br>Vdsm tried to store the drive IO tune settings in the metadata, which was redundant because the IO tune has already a proper representation.<br>Furthermore the implementation of the store operation of the IO tune settings had an implementation bug, which made it not possible to succesfully start the VM.<br>This bug appears only if IO tune settings are enabled.
 - [BZ 1580478](https://bugzilla.redhat.com/1580478) <b>Vdsm should support hotunplug by Alias</b><br>
 - [BZ 1565002](https://bugzilla.redhat.com/1565002) <b>Check vdsmd status before starting rpm upgrade</b><br>

#### oVirt Engine Metrics

 - [BZ 1573784](https://bugzilla.redhat.com/1573784) <b>Deprecation warning in fluentd forward plugin</b><br>

#### ovirt-engine-dwh

 - [BZ 1573145](https://bugzilla.redhat.com/1573145) <b>Update hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision</b><br>Cause: <br>The precision of the rx_rate, tx_rate of virtual and host network interfaces has been increased on the engine db.<br><br>Consequence: <br>This requires updating the dwh precision for better reporting.<br><br>Fix:<br>Update hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision<br><br>Result: <br>Hosts and vms receive_rate_percent and transmit_rate_percent network statistics precision was increased on DWH.

#### oVirt Hosted Engine Setup

 - [BZ 1574881](https://bugzilla.redhat.com/1574881) <b>During HE deployment auto add 2nd and 3rd Hosts is failing</b><br>
 - [BZ 1578404](https://bugzilla.redhat.com/1578404) <b>Fetch engine logs from the engine VM</b><br>
 - [BZ 1573074](https://bugzilla.redhat.com/1573074) <b>The deployment fails on create_storage_domain stage when using generated answers</b><br>
 - [BZ 1578418](https://bugzilla.redhat.com/1578418) <b>Checks on bond mode are not effective</b><br>
 - [BZ 1576451](https://bugzilla.redhat.com/1576451) <b>ovirt-hosted-engine-cleanup must undefine the HostedEngine VM</b><br>

#### imgbased

 - [BZ 1579141](https://bugzilla.redhat.com/1579141) <b>[RHV4.2] unable to upgrade Host 4.1 (rhvh-4.1-0.20180126.0)  to RHVH 4.2 (rhvh-4.2.3.0-0.20180508.0)</b><br>
 - [BZ 1573334](https://bugzilla.redhat.com/1573334) <b>RHV-H update to latest version fails on RHV 4.1 due to yum transaction failure</b><br>
 - [BZ 1575922](https://bugzilla.redhat.com/1575922) <b>RHVH 4.2 upgrade failed from 4.1 wrapper to wrapper</b><br>

#### cockpit-ovirt

 - [BZ 1578334](https://bugzilla.redhat.com/1578334) <b>The expand cluster(Day 2 operations ) is hung.</b><br>
 - [BZ 1573789](https://bugzilla.redhat.com/1573789) <b>Come up with new FQDN wizard which will allow user to enter fqdn for all hosts during Gluster deployment in Cockpit</b><br>
 - [BZ 1572558](https://bugzilla.redhat.com/1572558) <b>The dropdown for hosts under create volume(gluster deployment) in day two operations contain a single host name.</b><br>
 - [BZ 1576783](https://bugzilla.redhat.com/1576783) <b>Engine VM MAC address is hard-coded</b><br>
 - [BZ 1566450](https://bugzilla.redhat.com/1566450) <b>Enable lvmcache on all the hosts when enabled on one of the host</b><br>
 - [BZ 1576679](https://bugzilla.redhat.com/1576679) <b>Create inventory file for auto add 2nd and 3rd host only if gdeploy >= 2.0.2-25 (rhel) and >= 2.0.7 (for centos)</b><br>
 - [BZ 1578718](https://bugzilla.redhat.com/1578718) <b>The info icon for the volume in manage gluster is not providing complete information.</b><br>
 - [BZ 1577038](https://bugzilla.redhat.com/1577038) <b>Cockpit don't validate the engine vm ip prefix</b><br>
 - [BZ 1573473](https://bugzilla.redhat.com/1573473) <b>The VDO logical size check in box should be enabled automatically in all hosts</b><br>
 - [BZ 1571811](https://bugzilla.redhat.com/1571811) <b>set the VDO writepolicy to auto</b><br>
 - [BZ 1578666](https://bugzilla.redhat.com/1578666) <b>The title of the wizard of create volume in day 2 operations is incorrect.</b><br>
 - [BZ 1573138](https://bugzilla.redhat.com/1573138) <b>Multiple Slabsize value for  VDO volumes failing in gdeploy</b><br>
 - [BZ 1560414](https://bugzilla.redhat.com/1560414) <b>The textbox  'writethrough' in the subtab cache mode  under tab configure lv cache is misleading.</b><br>
 - [BZ 1571550](https://bugzilla.redhat.com/1571550) <b>Update emulate512 in VDO section, to have 'on' for boolean true value</b><br>

#### oVirt Engine SDK 4 Java

 - [BZ 1434834](https://bugzilla.redhat.com/1434834) <b>Implement automatic SSO token renew</b><br>
 - [BZ 1571648](https://bugzilla.redhat.com/1571648) <b>Detailed message in Error SDK</b><br>

#### oVirt Log Collector

 - [BZ 1573143](https://bugzilla.redhat.com/1573143) <b>Collect ovirt-provider-ovn logs.</b><br>

### No Doc Update

#### VDSM JSON-RPC Java

 - [BZ 1552098](https://bugzilla.redhat.com/1552098) <b>Rephrase: "command GetStatsAsyncVDS failed: Heartbeat exceeded" error message</b><br>
 - [BZ 1571768](https://bugzilla.redhat.com/1571768) <b>Connections shouldn't be closed after the connection to the host was recovered</b><br>

#### oVirt Engine

 - [BZ 1422428](https://bugzilla.redhat.com/1422428) <b>[fr-FR] Admin portal->Quota: measurements units are mixed up (GB in English and Go in French all mixed up).</b><br>
 - [BZ 1576752](https://bugzilla.redhat.com/1576752) <b>Number of "Prestarted VMs" is ignored and all VMs of Pool starts after editing existing Pool.</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1571119](https://bugzilla.redhat.com/1571119) <b>[HE] - Engine complaining that the 'VM HostedEngine is down with error. Exit message: resource busy: Failed to acquire lock: Lease is held by another host.'</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1572542](https://bugzilla.redhat.com/1572542) <b>argument vlan_tag is of type <type 'str'> and we were unable to convert to int: invalid literal for int() with base 10: '8000\\\\n1'\"}"</b><br>


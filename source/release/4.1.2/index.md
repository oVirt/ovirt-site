---
title: oVirt 4.1.2 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 4.1.2 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.2
Release as of May 23, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).


For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.1.2, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions


### Fedora / CentOS / RHEL



In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm)


and then follow our
[Installation guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade_guide/)

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

## What's New in 4.1.2?

### Enhancements

#### oVirt Engine

 - [BZ 1426902](https://bugzilla.redhat.com/1426902) <b>[RFE] Make update manager also update rubygem-fluent-plugin-viaq_data_model plugin</b><br>
 - [BZ 1427790](https://bugzilla.redhat.com/1427790) <b>[RFE] Remove VdsmSSLProtocol from engine-config options</b><br>Feature: <br><br>In previous releases users had the ability to limit highest SSL/TLS protocol version negotiated when establishing connection between engine and VDSM. This was needed in the past because there were some issue with really old clients.<br><br>Reason: <br><br>We have verified that for all VDSM 3.6 and newer we can negotiate highest available version without any issues (we negogitate up to TLSv1.2 as described in BZ1412547).<br><br>Result: <br><br>Due to above this option is no longer necessary and we have decided to remove it completely from engine-config options.
 - [BZ 1388433](https://bugzilla.redhat.com/1388433) <b>[RFE] Change auto-vacuum configuration defaults to match oVirt db usage</b><br>* there is a documentation bug opened for this one, see Bug 1411756 <br><br>Feature: <br>Configure the engine's postgres with more aggressive vacuum daemon configuration.<br><br>Reason: <br>To prevent the frequently updates tables from piling up garbage and avoid or minimize the risk of disk flood and tx id wrap around<br><br>Result: The engine tables remain healthy, dead rows are collected in timely manner, disk space usage is correlated with the real amount of data kept.

#### oVirt Engine Metrics

 - [BZ 1435993](https://bugzilla.redhat.com/1435993) <b>[RFE]Add ovirt-engine process to collectd process plugin</b><br>Feature: <br>Added to the collection of Collectd Processes plugin the collection of ovirt-engine process statistics.<br><br>Reason: <br>This adds statistics about the ovirt-engine process and help debug issues.<br><br>Result:

#### oVirt Cockpit Plugin

 - [BZ 1434735](https://bugzilla.redhat.com/1434735) <b>calculate arbiter brick size dynamically</b><br>

#### oVirt Host Deploy

 - [BZ 1443508](https://bugzilla.redhat.com/1443508) <b>[RHVH3.6] Failed to add host to rhv-m 4.1 - Package collectd-disk cannot be found</b><br>ovirt-host-deploy now does not fail, but only emits a warning, if packages collectd/fluentd and their plugins are not available. This allows adding a 3.6 host to a 4.1 engine, even though the 3.6 repos do not have these packages.

### No Doc Update

#### oVirt Engine

 - [BZ 1448698](https://bugzilla.redhat.com/1448698) <b>[TEXT] - Clarify 'Experimental' Switch Type on Cluster Settings</b><br>
 - [BZ 1423468](https://bugzilla.redhat.com/1423468) <b>the quota value of datacenter - verify for sane values</b><br>

#### VDSM

 - [BZ 1448473](https://bugzilla.redhat.com/1448473) <b>getAllVmIoTunePolicies exceptions in VDSM</b><br>

### Rebase: Bug Fixes and Enhancementss

#### oVirt Engine

 - [BZ 1438784](https://bugzilla.redhat.com/1438784) <b>[Rebase] Bump vdsm-jsonrpc-java version</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1438784](https://bugzilla.redhat.com/1438784) <b>[Rebase] Bump vdsm-jsonrpc-java version</b><br>

### Release Note

#### oVirt Engine

 - [BZ 1367107](https://bugzilla.redhat.com/1367107) <b>[RFE] Override firewall rules by default when installing a new host or reinstalling existing host</b><br>Prior to 4.1.2 both API and webadmin behaved differently on firewall configuration for installing new host or reinstalling existing one:<br><br>1) webadmin - by default firewall configuration during host installation or reinstallation was enabled<br><br>2) API - by default firewall configuration during host installation or reinstallation was disabled and users had to specify override_iptables=true parameter in request for host to be successfully installed (or they had to perform manual firewall configuration on host prior adding it to engine)<br><br>This was very inconvenient for users as most of them didn't perform manual firewall configuration, so we have decided to change the default behaviour: from 4.1.2 both webadmin and API by default enable firewall configuration during host installation and reinstallation.<br><br>If users upgrading from previous have some scripts using API for adding hosts and their scripts depends on pre-4.1.2 behaviour to not configure firewall, they will have to update their scripts and add override_iptables=false option into their scripts.
 - [BZ 1433961](https://bugzilla.redhat.com/1433961) <b>Disable overcommit by default when creating new cluster</b><br>Previously, it was possible to configure memory overcommit without setting memory ballooning or KSM control. This configuration affected the scheduling, but the memory was not freed. This has now been fixed by disabling ballooning and KSM by default, and setting memory optimization to “None” (100%).
 - [BZ 1436161](https://bugzilla.redhat.com/1436161) <b>[RFE][scale]Increase LVs per VG alert limit</b><br>The recommendation on number of logical volumes per storage domain was increased from 300 to 1000, given that the alert issued when exceeding this number was changed to reflect that, the limit will only change if it was the original default which is 300, in case the user manually configured it the limit will not be overriden

### Unclassified

#### oVirt Engine

 - [BZ 1434917](https://bugzilla.redhat.com/1434917) <b>Import of a VM with memory snapshot from storage domain fails</b><br>
 - [BZ 1415691](https://bugzilla.redhat.com/1415691) <b>New HSM infra - Disk remains locked when engine fails during engine task</b><br>
 - [BZ 1438418](https://bugzilla.redhat.com/1438418) <b>[REST] When setting network as management, the network becomes Non-operational</b><br>
 - [BZ 1390498](https://bugzilla.redhat.com/1390498) <b>[v4 REST-API] Read only Attribute is missing from /api/disks/{disk id}/ or from /api/vms/{vm id}/diskattachments/{diskattachments id}</b><br>
 - [BZ 1439509](https://bugzilla.redhat.com/1439509) <b>Missing description for host certification is expired</b><br>
 - [BZ 1436325](https://bugzilla.redhat.com/1436325) <b>Wrong emulated machine for a VM with custom compatibility version</b><br>
 - [BZ 1436966](https://bugzilla.redhat.com/1436966) <b>EJB Invocation failed on component MacPoolPerCluster for method public org.ovirt.engine.core.bll.network.macpool.ReadMacPool</b><br>
 - [BZ 1426027](https://bugzilla.redhat.com/1426027) <b>Always use engine FQDN even for internal communication between engine and SSO module</b><br>
 - [BZ 1425725](https://bugzilla.redhat.com/1425725) <b>Not able to update response</b><br>
 - [BZ 1427543](https://bugzilla.redhat.com/1427543) <b>A disk that is about to be deleted should be discarded first if it is attached to at least one vm with Pass Discard enabled</b><br>Up until now, a disk would have been discarded only if its block storage domain's Discard After Delete was enabled.<br><br>From now and on, a disk will be discarded also if it is attached to at least one virtual machine with Pass Discard enabled.<br>The logic behind this is that if the user wanted "live" discarding, he will probably want to discard the whole disk when it is removed even if its storage domain's Discard After Delete property is disabled.<br><br>For more information, please refer to the "Discard After Delete" feature page - http://www.ovirt.org/develop/release-management/features/storage/discard-after-delete/ .
 - [BZ 1436577](https://bugzilla.redhat.com/1436577) <b>Solve DC/Cluster upgrade of VMs with now-unsupported custom compatibility level</b><br>
 - [BZ 1430666](https://bugzilla.redhat.com/1430666) <b>Engine does not update the dwh heartbeat in the specified interval causing dwh error</b><br>
 - [BZ 1421764](https://bugzilla.redhat.com/1421764) <b>engine-vacuum needs proper log messages</b><br>
 - [BZ 1431435](https://bugzilla.redhat.com/1431435) <b>RNG source cannot be changed to /dev/urandom if /dev/hwrng source is enabled.</b><br>
 - [BZ 1417839](https://bugzilla.redhat.com/1417839) <b>[ALL LANG] Administration portal - Empty credentials warning message not localized</b><br>
 - [BZ 1438962](https://bugzilla.redhat.com/1438962) <b>DB query cache auto-eviction could be longer then the query run time in a large environment</b><br>
 - [BZ 1413899](https://bugzilla.redhat.com/1413899) <b>tooltips in Extended view on VM show only one value</b><br>
 - [BZ 1422428](https://bugzilla.redhat.com/1422428) <b>[fr-FR] Admin portal->Quota: measurements units are mixed up (GB in English and Go in French all mixed up).</b><br>
 - [BZ 1430451](https://bugzilla.redhat.com/1430451) <b>Make max memory to follow memory only when VM is not UP</b><br>
 - [BZ 1421434](https://bugzilla.redhat.com/1421434) <b>[REST-API] <mac_pool href= is missing under /api/datacenters/</b><br>
 - [BZ 1425156](https://bugzilla.redhat.com/1425156) <b>unexpected UI behavior in the New External Subnet window</b><br>
 - [BZ 1417101](https://bugzilla.redhat.com/1417101) <b>Arbiter flag is not present in the brick path for arbiter bricks when arbiter volume is created from UI.</b><br>
 - [BZ 1420687](https://bugzilla.redhat.com/1420687) <b>Remove NFS & CIFS checkboxes and enable optimize-for-virt-store in the volume creation dialog</b><br>
 - [BZ 1411666](https://bugzilla.redhat.com/1411666) <b>[SR-IOV] - UI - Reflect 'No Filter' for passthrough vNIC profile that was created via rest api</b><br>
 - [BZ 1433977](https://bugzilla.redhat.com/1433977) <b>Cannot fetch fingerprint when Host SSH runs in different port than 22</b><br>
 - [BZ 1432904](https://bugzilla.redhat.com/1432904) <b>[es_ES] Need to change the language option string for es_ES in the language drop-down on welcome page.</b><br>
 - [BZ 1410440](https://bugzilla.redhat.com/1410440) <b>MAC addresses are in use after moving VM to another cluster and removing the vNIC doesn't clear it</b><br>
 - [BZ 1429810](https://bugzilla.redhat.com/1429810) <b>Fix the spurious leading space in the custom bond mode field</b><br>
 - [BZ 1422447](https://bugzilla.redhat.com/1422447) <b>[TEXT] Moving an existing NIC from an oVirt network to one on an external provider does  not require stopping a VM, unplug is fine too</b><br>
 - [BZ 1447050](https://bugzilla.redhat.com/1447050) <b>Snapshot remains in locked status after async delete using api (only when using async)</b><br>
 - [BZ 1447023](https://bugzilla.redhat.com/1447023) <b>Unable to upload/download images using python sdk</b><br>
 - [BZ 1448793](https://bugzilla.redhat.com/1448793) <b>[cinder] Failed to run VM with cinder disk</b><br>
 - [BZ 1423657](https://bugzilla.redhat.com/1423657) <b>Add value to engine-config to set timeout after successful fence start</b><br>When power management start or restart action is executed, we switch host to REBOOT state and wait for number of seconds which are defined in 'ServerRebootTimeout' engine-config property. After that timeout we switch host to NON_RESPONSIVE state, so the host monitoring can handle the host.
 - [BZ 1441706](https://bugzilla.redhat.com/1441706) <b>[engine-backend] Block storage domain creation fails: CreateVG deviceList is passed with duplicated PV names</b><br>
 - [BZ 1432095](https://bugzilla.redhat.com/1432095) <b>The create_functions.sql is not executed on each engine-setup execution</b><br>
 - [BZ 1441857](https://bugzilla.redhat.com/1441857) <b>DashboardDataException in engine log after dashboard fails to load on environment without dwh</b><br>
 - [BZ 1422841](https://bugzilla.redhat.com/1422841) <b>Error is displayed when trying to fence a host but fencing is (sometimes) executed</b><br>
 - [BZ 1438484](https://bugzilla.redhat.com/1438484) <b>Running the command logon on the VM via the REST failed with the exception</b><br>
 - [BZ 1432493](https://bugzilla.redhat.com/1432493) <b>RESTAPI get diskssnapshots of a VM imported to upgraded DC - qcow_version field does not appear</b><br>
 - [BZ 1420401](https://bugzilla.redhat.com/1420401) <b>Cold merge: update job message to show host name</b><br>
 - [BZ 1440549](https://bugzilla.redhat.com/1440549) <b>When failing to fence volume jobs the number of commands in the db grows till the execution ends.</b><br>
 - [BZ 1439749](https://bugzilla.redhat.com/1439749) <b>API v3 of 4.1 engine doesn't have version 4.1 capabilities</b><br>
 - [BZ 1438691](https://bugzilla.redhat.com/1438691) <b>Wrong calculation of initial size of disk when copying template disk from file Raw/Sparse to block Cow</b><br>
 - [BZ 1438497](https://bugzilla.redhat.com/1438497) <b>[scale] - tasks rejection by thread pool util</b><br>
 - [BZ 1438252](https://bugzilla.redhat.com/1438252) <b>snapshots disks(not disk itself) are still with qcow2_v2 after cold move of Vm's disk+snapshots to V4 storage domain</b><br>
 - [BZ 1437383](https://bugzilla.redhat.com/1437383) <b>base volume format may not be preserved when moving disk between block/file domains</b><br>
 - [BZ 1390271](https://bugzilla.redhat.com/1390271) <b>in few of ui dialogs the fields position is pushed down or cut after replacing to the new list boxes</b><br>
 - [BZ 1409849](https://bugzilla.redhat.com/1409849) <b>UI: Storage domains not showing in search on a DC named with an underscore</b><br>
 - [BZ 1434019](https://bugzilla.redhat.com/1434019) <b>Fencing options link leads to retired page</b><br>
 - [BZ 1436160](https://bugzilla.redhat.com/1436160) <b>UI error about Enable Discard (formally "Discard After Delete") comes too late</b><br>
 - [BZ 1427566](https://bugzilla.redhat.com/1427566) <b>Migration downtime not displayed</b><br>
 - [BZ 1434161](https://bugzilla.redhat.com/1434161) <b>Video devices of templates are not updated correctly</b><br>
 - [BZ 1433052](https://bugzilla.redhat.com/1433052) <b>unexpected qcow_version v2 on 2nd disk after snapshot on a VM created from template</b><br>
 - [BZ 1432089](https://bugzilla.redhat.com/1432089) <b>Download an image while it's storage domain is in maintenance causes NPE in engine's log</b><br>
 - [BZ 1432067](https://bugzilla.redhat.com/1432067) <b>After killing vdsmd during Amend locked forever +  flooding of ERROR: "failed to poll the command entity"</b><br>
 - [BZ 1431578](https://bugzilla.redhat.com/1431578) <b>improve V3 performance of retrieving VM disks</b><br>
 - [BZ 1425122](https://bugzilla.redhat.com/1425122) <b>[Sysprep] authz name is not set as domain in new VM dialog</b><br>
 - [BZ 1366507](https://bugzilla.redhat.com/1366507) <b>[RFE] Enable virtio-scsi dataplane for el7.3</b><br>
 - [BZ 1422450](https://bugzilla.redhat.com/1422450) <b>[virtio-scsi dataplane]  viritio scsi disks are bound to the first controller</b><br>
 - [BZ 1426715](https://bugzilla.redhat.com/1426715) <b>[UI][events] user login event is not displayed on events tab</b><br>
 - [BZ 1430817](https://bugzilla.redhat.com/1430817) <b>ovirt-engine-lib needs python-dateutil but does not Require it</b><br>
 - [BZ 1425493](https://bugzilla.redhat.com/1425493) <b>Vm pool auto storage domain target selection option doesn't exist in REST API</b><br>With this release, when creating virtual machine pools using a template that is present in more than one storage domain, virtual machine disks can be distributed to multiple storage domains add the tag:<br><auto_storage_select>true</auto_storage_select><br>to the pool creation
 - [BZ 1360355](https://bugzilla.redhat.com/1360355) <b>Image upload: Upload image shows disk profile: null</b><br>
 - [BZ 1425124](https://bugzilla.redhat.com/1425124) <b>The 'Monitors' and 'USB support' becomes non-greyed out when setting the VM to be headless</b><br>
 - [BZ 1428346](https://bugzilla.redhat.com/1428346) <b>Use the same correlation id for flows that use callback</b><br>
 - [BZ 1414484](https://bugzilla.redhat.com/1414484) <b>image is stuck with "Finalizing" status after a download of 1gb chunk (= disk size) [works with 1mb chunk]</b><br>
 - [BZ 1424755](https://bugzilla.redhat.com/1424755) <b>Log is filled with error "LastUpdate Date is not initialized in the OVF_STORE disk."</b><br>
 - [BZ 1419967](https://bugzilla.redhat.com/1419967) <b>HA VM is reported as restarted even if restart fails</b><br>
 - [BZ 1414418](https://bugzilla.redhat.com/1414418) <b>Patternfly Check Boxes and Radio Buttons text should be clickable</b><br>
 - [BZ 1425347](https://bugzilla.redhat.com/1425347) <b>Using 'VirtIO' interface, Add Virtual Disk of Direct LUN, cannot set attribute of 'Read-Only'</b><br>
 - [BZ 1426064](https://bugzilla.redhat.com/1426064) <b>ImageProxyAddress ConfigValue is being reset to default on upgrade from 3.6</b><br>
 - [BZ 1425774](https://bugzilla.redhat.com/1425774) <b>add a link to engine's certificate on upload image network error event</b><br>

#### VDSM

 - [BZ 1450634](https://bugzilla.redhat.com/1450634) <b>Storage domain in 4.1 RHV will go offline if LVM metadata was restored manually</b><br>
 - [BZ 1437523](https://bugzilla.redhat.com/1437523) <b>migration failures - libvirtError - listen attribute must match address attribute of first listen element</b><br>
 - [BZ 1428415](https://bugzilla.redhat.com/1428415) <b>Improve logging to find out the cause of RPC pool being exhausted</b><br>
 - [BZ 1429420](https://bugzilla.redhat.com/1429420) <b>hostdev.list_by_caps() fails if 'drm' capability reported by libvirt</b><br>
 - [BZ 1430198](https://bugzilla.redhat.com/1430198) <b>can't enable tunneled migration</b><br>
 - [BZ 1419917](https://bugzilla.redhat.com/1419917) <b>VDSM fails to report capabilities if openvswitch stopped while Vdsm is running</b><br>
 - [BZ 1432876](https://bugzilla.redhat.com/1432876) <b>VM destroy call is not robust enough in cleanup flow</b><br>
 - [BZ 1448606](https://bugzilla.redhat.com/1448606) <b>Creating template from VM with converted disk format fails only on iscsi SD - RAW to QCOW</b><br>
 - [BZ 1437341](https://bugzilla.redhat.com/1437341) <b>When MOM is missing, vdsm complains on MOM missing too frequently</b><br>
 - [BZ 1434927](https://bugzilla.redhat.com/1434927) <b>HSM - Cold Move - failed to move disk after cold merge of snapshot</b><br>
 - [BZ 1419240](https://bugzilla.redhat.com/1419240) <b>Creating a Clone vm from template with Format "QCOW2" and Target "block based storage" has a disk with same actual and virtual size.</b><br>
 - [BZ 1421556](https://bugzilla.redhat.com/1421556) <b>Setting log level as shown in README.logging fails.</b><br>
 - [BZ 1427782](https://bugzilla.redhat.com/1427782) <b>improve vdsm logging to detect storage issues</b><br>
 - [BZ 1430122](https://bugzilla.redhat.com/1430122) <b>SPM start task won't end before host jobs involving the master domain are complete</b><br>
 - [BZ 1428692](https://bugzilla.redhat.com/1428692) <b>hostdevListByCaps will fail if some device disappears during its runtime</b><br>
 - [BZ 1435967](https://bugzilla.redhat.com/1435967) <b>creating template from VM with converted disk format fails only on iscsi SD - RAW to QCOW</b><br>
 - [BZ 1427566](https://bugzilla.redhat.com/1427566) <b>Migration downtime not displayed</b><br>
 - [BZ 1376580](https://bugzilla.redhat.com/1376580) <b>Live Merge: Handle block copy still active error</b><br>
 - [BZ 1400534](https://bugzilla.redhat.com/1400534) <b>Select host as SPM will raise 'Unhandled exception' (secured object is not in safe state) in the elected SPM host</b><br>
 - [BZ 1428419](https://bugzilla.redhat.com/1428419) <b>Switch VDSM dependency from ntp to chrony</b><br>
 - [BZ 1427202](https://bugzilla.redhat.com/1427202) <b>VM doesn't start with VFIO+SR-IOV</b><br>Previously, if VM was started with host device AND sr-iov nic, the runtime could fail and leak the VF (render it unusable). This is now fixed and such combination of devices can be used.

#### VDSM JSON-RPC Java

 - [BZ 1420427](https://bugzilla.redhat.com/1420427) <b>java exception visible in Events when upgrade check is done on recently fenced host</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1433718](https://bugzilla.redhat.com/1433718) <b>Add reasonable timeout for the Python SDK requests</b><br>

#### oVirt Engine Dashboard

 - [BZ 1420448](https://bugzilla.redhat.com/1420448) <b>numbers in storage inventory don't correspond with search result on the links</b><br>

#### oVirt Engine Metrics

 - [BZ 1439544](https://bugzilla.redhat.com/1439544) <b>Statsd host nic and storage metrics - nic and storage names should be in plugin_instance instead of type_instance</b><br>
 - [BZ 1439536](https://bugzilla.redhat.com/1439536) <b>The collect.type_instance for hosts elapsed_time metrics should be empty</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1433287](https://bugzilla.redhat.com/1433287) <b>Update generated gdeploy config file to restart glusterd post setting up systemd slice for glusterfs</b><br>
 - [BZ 1431094](https://bugzilla.redhat.com/1431094) <b>change the text message when mount point and LV name is not specified.</b><br>

#### oVirt Windows Guest Tools

 - [BZ 1418831](https://bugzilla.redhat.com/1418831) <b>Unsupported Windows Version Windows Server 2016</b><br>

#### imgbased

 - [BZ 1431158](https://bugzilla.redhat.com/1431158) <b>There are warnings when running lvm commands</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1449084](https://bugzilla.redhat.com/1449084) <b>Can't connect to engine web ui with chrome 58 (due to missing subjectAltName)</b><br>
 - [BZ 1438188](https://bugzilla.redhat.com/1438188) <b>Failed to create template from snapshot (At most one USB controller expected)</b><br>
 - [BZ 1440071](https://bugzilla.redhat.com/1440071) <b>Can't create gluster georeplication</b><br>
 - [BZ 1435088](https://bugzilla.redhat.com/1435088) <b>[Upgrade] Auto-Import of HostedEngine VM fails due to missing CPU Profile Permissions</b><br>
 - [BZ 1428863](https://bugzilla.redhat.com/1428863) <b>Getting ticket for VM that is down fails with NPE</b><br>
 - [BZ 1402838](https://bugzilla.redhat.com/1402838) <b>Block memory over-commitment when KSM and ballooning are not being used</b><br>
 - [BZ 1383156](https://bugzilla.redhat.com/1383156) <b>Enable HE deploy option in 3.6 cluster compatibility and add note in hosted engine tab that it will only work in host that are 4.0 and above.</b><br>
 - [BZ 1329119](https://bugzilla.redhat.com/1329119) <b>Engine fails to start if machine's memory is reduced by 75%</b><br>
 - [BZ 1291064](https://bugzilla.redhat.com/1291064) <b>Change vm memory and cpu number not update automatically VNUMA nodes memory and cpu number</b><br>
 - [BZ 1444848](https://bugzilla.redhat.com/1444848) <b>Error while importing a VM from 4.0 data domain</b><br>
 - [BZ 1444982](https://bugzilla.redhat.com/1444982) <b>Host can be moved to maintenance while it there are jobs running on it</b><br>
 - [BZ 1424986](https://bugzilla.redhat.com/1424986) <b>Increase the default factor for the CPU weight modules to preserve balance behavior for the PowerSaving and EvenDistribution policy</b><br>
 - [BZ 1431412](https://bugzilla.redhat.com/1431412) <b>Reduce number of transactions in commands that use NetworkClusterHelper.setStatus</b><br>

### VDSM

 - [BZ 1336840](https://bugzilla.redhat.com/1336840) <b>Prevent import of VMware machines with snapshot</b><br>
 - [BZ 1428514](https://bugzilla.redhat.com/1428514) <b>RHEL guests cannot recognize attached CD after CD change</b><br>

### oVirt Log collector

 - [BZ 1227019](https://bugzilla.redhat.com/1227019) <b>Require sos >= 3.3 when available - ovirt sosreport plugin doesn't obfuscate password used in aaa extensions</b><br>

### oVirt Hosted Engine HA

 - [BZ 1441570](https://bugzilla.redhat.com/1441570) <b>After hosted engine upgrade from 4.1.0 to 4.1.1 the ability to connect to the vm via console is lost</b><br>
 - [BZ 1419326](https://bugzilla.redhat.com/1419326) <b>Migration of the HE VM via engine will drop source host to the status 'EngineUnexpectedlyDown'</b><br>

### OTOPI

 - [BZ 1405838](https://bugzilla.redhat.com/1405838) <b>otopi updated iproute package during ovirt-host-mgmt</b><br>

### oVirt Engine Metrics

 - [BZ 1438863](https://bugzilla.redhat.com/1438863) <b>Collectd Processes plugin does not report correctly values for vdsm, libvirt, qemu</b><br>

### oVirt Cockpit Plugin

 - [BZ 1433925](https://bugzilla.redhat.com/1433925) <b>poolmetadatasize for the thinpool created on arbiter node should not be 16GB</b><br>
 - [BZ 1438596](https://bugzilla.redhat.com/1438596) <b>Include gdeploy multipath disable script</b><br>

### oVirt Host Deploy

 - [BZ 1443064](https://bugzilla.redhat.com/1443064) <b>vdsm.conf isn't being written due to vintage condition</b><br>

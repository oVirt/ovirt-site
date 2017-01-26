---
title: oVirt 4.1.0 Release Notes
category: documentation
authors: sandrobonazzola
---

# oVirt 4.1.0 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.0
Second Release Candidate as
of January 26, 2017.

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


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.


In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm)






### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding Red Hat Virtualization
[Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding Red Hat Virtualization
[Upgrade Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/upgrade-guide/)## What's New in 4.1.0?

### Deprecated Functionality

#### oVirt Host Deploy

##### Team: SLA

 - [BZ 1372237](https://bugzilla.redhat.com/1372237) <b>Remove workaround for vdsm-jsonrpc deprecation warning</b><br>This release removes a no-longer-needed workaround for the vdsm-jsonrpc deprecation warning.

### Enhancement

#### oVirt Release Package

##### Team: Integration

 - [BZ 1398321](https://bugzilla.redhat.com/1398321) <b>add back fedora 24 virt-preview repo</b><br>oVirt release now enables by default virt-preview repository on Fedora 24. For more information about the repository see its Fedora wiki page at https://fedoraproject.org/wiki/Virtualization_Preview_Repository
 - [BZ 1366118](https://bugzilla.redhat.com/1366118) <b>[RFE] Move GlusterFS repos to version 3.8</b><br>oVirt release now provides repository configuration files for enabling GlusterFS 3.8 repositories on Red Hat Enterprise Linux, CentOS Linux and similar.

##### Team: Node

 - [BZ 1382843](https://bugzilla.redhat.com/1382843) <b>RHV-H 4.0 does not have 'sysstat' installed</b><br>RHV-H now includes sysstat as part of the base image.
 - [BZ 1379763](https://bugzilla.redhat.com/1379763) <b>screen package is not available in RHV 4.0 - despite warnings to run HE deploy within screen session</b><br>The "screen" package is now available as part of the base RHVH image.

#### oVirt Engine

##### Team: Gluster

 - [BZ 1398593](https://bugzilla.redhat.com/1398593) <b>RFE: Integrate geo-replication based DR sync for storage domain</b><br>Feature: Integrate setup for data sync to a remote location using geo-replication for gluster based storage domains<br><br>Reason: Helps with disaster recovery flow<br><br>Result: User is able to schedule data sync to remote location from oVirt UI
 - [BZ 1196433](https://bugzilla.redhat.com/1196433) <b>[RFE] [HC] entry into maintenance mode should consider whether self-heal is ongoing</b><br>Previously, in GlusterFS, if a node went down and then returned, GlusterFS would automatically initiate  a self-heal operation. During this operation, which could be timely, a subsequent maintenance mode action within the same GlusterFS replica set could result in a split brain scenario. <br>In this release, if a Gluster host is performing a self-heal activity, administrators will not be able to move it into maintenance mode. In extreme cases, administrators can use the force option to forcefully move a host into maintenance mode.
 - [BZ 1182369](https://bugzilla.redhat.com/1182369) <b>[RFE][HC] - glusterfs volume create/extend should fail when bricks from the same server</b><br>Feature: Enforce that bricks are not from same server while creating a replica set in a hyperconverged cluster.<br><br>Reason: In a hyperconverged cluster, the solution should be able to function on a single server failure. This will not be possible if 2 bricks from a replica set are on a single server.
 - [BZ 1177782](https://bugzilla.redhat.com/1177782) <b>[RFE][HC] – link to gluster volumes while creating storage domains</b><br>Feature: Provides a link to gluster volume while creating a gluster storage domain<br><br>Reason: Enables auto-population of mount option backup-volfile-servers and paves the way for integration features like Disaster Recovery setup using gluster geo-replication
 - [BZ 1364999](https://bugzilla.redhat.com/1364999) <b>[RFE] Show gluster volume info in ovirt dashboard</b><br>Feature: <br><br>Show gluster volume info in ovirt dashboard<br> <br>Reason: <br><br>oVirt dashboard has all the Virt specific information, but in a hyper-converged setup, it will be useful to show the gluster volume information also in the dashboard.<br><br><br>Result: <br><br>Gluster volume information will be shown in the oVirt dashboard. User can see the summary of all gluster volume in the system.

##### Team: Infra

 - [BZ 1347631](https://bugzilla.redhat.com/1347631) <b>[RFE] adding logging to REST API calls</b><br>This feature adds the /var/log/httpd/ovirt-requests-log file which will now log all requests made to the ovirt engine via HTTPS and how long the the request took. There will be the 'Correlation-Id' header included, for easier comparison of requests with the engine.log <br>CorrelationIds are now generated for every request automatically and can be passed to the REST Api per Correlation-Id header or correlation\_id query parameter.
 - [BZ 1406814](https://bugzilla.redhat.com/1406814) <b>[RFE] Add ability to disable automatic checks for upgrades on hosts</b><br>Feature: <br><br>Interval between engine tries to find out available upgrades on hosts could be changed using engine-config option HostPackagesUpdateTimeInHours. But there was no way to disable that periodical checks in cases where it's not needed (for example when you manage your hosts using Satellite).<br><br>Reason: <br><br>Result: <br><br>This fix allows administrators to set HostPackagesUpdateTimeInHours to 0 which disables automatic periodical checks for upgrades.
 - [BZ 1279378](https://bugzilla.redhat.com/1279378) <b>[RFE] Add manual execution of 'Check for upgrades' into webadmin and RESTAPI</b><br>A new menu item 'Check for Upgrade' has been added to Webadmin Installation menu. This can be used to trigger checking for upgrades on the host.<br><br>The check for upgrades can also be trigger by using rest api using the hosts upgradecheck endpoint.
 - [BZ 1381279](https://bugzilla.redhat.com/1381279) <b>[RFE] Rebase on  snmp4j-2.4.1</b><br>
 - [BZ 1286632](https://bugzilla.redhat.com/1286632) <b>[RFE] When editing fence agents, options displayed should be specific to that agent</b><br>Feature: <br>Adding a link to the add/edit fence agent form that points to an online help on the available parameters that can be sent toa fence agent<br><br>Reason: <br>Provide help for users to set correct fence agent parameters <br><br>Result: <br>The user can now click on the link in the add/edit fence agent form and see an online help on the available parameters
 - [BZ 1343562](https://bugzilla.redhat.com/1343562) <b>Updates should not be checked on hosts on maintenance</b><br>Before this patch we checked for updates all hosts that were in status Up, Maintenance or NonOperational. Unfortunately hosts in status Maintenance may not be reachable, which caused unnecessary errors shown in Events. <br>So from now only hosts in status Up or NonOperational are being checked for upgrades.<br>
 - [BZ 1295678](https://bugzilla.redhat.com/1295678) <b>[RFE] better error messages for beanvalidation validation failures.</b><br>
 - [BZ 1024063](https://bugzilla.redhat.com/1024063) <b>[RFE] Provide way to reboot host without using Power Management</b><br>Feature: <br>Reboot host using SSH management<br><br>Reason: <br>It was not possible to reboot host without power managemant<br><br>Result: <br>New management buttons which run SSH reboot and SSH shutdown action
 - [BZ 1092907](https://bugzilla.redhat.com/1092907) <b>[RFE][notifier] Implement logging of successful sending of mail notification</b><br>Previously, when notification emails were successfully sent to a configured SMTP server, a success message did not appear in the notifier.log file.In this release, when a message is successfully sent to an SMTP server, the following message appears in the notifier.log file:<br>E-mail subject='...' to='...' sent successfully
 - [BZ 1126753](https://bugzilla.redhat.com/1126753) <b>[RFE]Map PM iLO3 and iLO4 to their native agents</b><br>iLO3/iLO4 fence agents are no longer mapped to IPMILAN agents and fence_ilo3/fence_ilo4 agents are used to execute power management operations.

##### Team: Integration

 - [BZ 1235200](https://bugzilla.redhat.com/1235200) <b>[RFE] Make it easier to remove hosts when restoring hosted-engine from backup</b><br>Restoring a backup of hosted-engine on a different environment for disaster recovery purposes could require to remove the previous hosts from the engine. Up to now there wasn't a clean way to do it without manually touching the engine DB with the related risks.<br>This enhancement introduces a CLI option to do it directly from engine-backup at restore time.
 - [BZ 1270719](https://bugzilla.redhat.com/1270719) <b>[RFE] Add an option to automatically accept defaults</b><br>Feature: Add an option `--accept-defaults` to engine-setup, that makes it not prompt for answers, in questions that supply a default one, but instead accept the default.<br><br>Reason: <br>1. Save users from repeatedly pressing Enter if they already know that the defaults are good enough for them.<br>2. Lower the maintenance for other tools that want to run engine-setup unattended - if they use this option, they will not break when a question is added in the future, if this question has a default answer
 - [BZ 1300947](https://bugzilla.redhat.com/1300947) <b>engine-backup user experience need to be improved</b><br>

##### Team: Network

 - [BZ 1317447](https://bugzilla.redhat.com/1317447) <b>[RFE] Ability to choose new Mac address from pool when importing VMs from data storage domain.</b><br>
 - [BZ 1277675](https://bugzilla.redhat.com/1277675) <b>[RFE] Ability to change network information in a VM import from storage domain in DR scenario</b><br>
 - [BZ 1226206](https://bugzilla.redhat.com/1226206) <b>[RFE] Ability to choose new Mac address from pool when importing VMs from data storage domain.</b><br>
 - [BZ 994283](https://bugzilla.redhat.com/994283) <b>[RFE] Per cluster MAC address pool</b><br>Feature: MAC Pool association was altered, so that it's possible to attach different MAC Pool to each individual cluster.<br><br>Reason: Future demise of DataCenter concept.<br><br>Result: Done.
 - [BZ 1038550](https://bugzilla.redhat.com/1038550) <b>[RFE] RHEV-M portal should highlight primary interface in bond configured using 'primary' option in custom mode.</b><br>-

##### Team: SLA

 - [BZ 1404660](https://bugzilla.redhat.com/1404660) <b>VM affinity: enforcement mechanism adjustments</b><br>Feature: Rule enforcement support for VM to host affinity was added. <br><br>For detailed information please visit - <br><br>http://www.ovirt.org/develop/release-management/features/sla/soft-host-to-vm-affinity-support/<br><br>https://bugzilla.redhat.com/show_bug.cgi?id=1392393<br><br>Reason: The new addition of VM to host affinity groups requires the affinity rule enforcer to handle these affinity groups in addition to the exiting enforcement of VM to VM affinity.<br><br>Result: The rule enforcer will now be able to find VM to host affinity violations and choose a VM to migrate according to these violations.
 - [BZ 1392393](https://bugzilla.redhat.com/1392393) <b>[RFE] Soft host to VM affinity support</b><br>Feature: Support for VM to host affinity was added, enabling to create affinity groups for VMs to be associated with designated hosts. VM to VM affinity can be disabled/enabled by request.<br>For detailed information please visit - <br><br>http://www.ovirt.org/develop/release-management/features/sla/soft-host-to-vm-affinity-support/<br><br>https://bugzilla.redhat.com/show_bug.cgi?id=1404660<br><br>Reason: There are several reasons VM to host affinity can be useful -<br>hosts with specific hardware are needed by certain VMs, certain set of VMs form a logical management unit should run on a certain set of hosts for SLA or management (e.g. a separate rack for each customer), VMs with licensed software must run on specific physical machines,avoid scheduling VMs to hosts that need to be decommissioned or upgraded,etc.<br> <br>Result: VM to host affinity groups can be created (currently via rest) with the applicable new policy units and rule enforcer manager handling them.
 - [BZ 1392418](https://bugzilla.redhat.com/1392418) <b>[RFE] - improve usability of global maintenance buttons for HE environments.</b><br>Feature: Modify the "Enable HA Global Maintenance" and "Disable HA Global Maintenance" buttons to display on the right-click menu for hosts instead of VMs and to reflect the global maintenance state of the host by disabling the button matching the host's current HA global maintenance state.<br><br>Reason: The HA global maintenance options should be displayed for hosts, not VMs. The previous method of displaying the options for VMs is unintuitive and could be confusing for users. Additionally, prior to this change, both the enable and disable options remained available regardless of whether or not the host was in HA global maintenance mode. This is also a source of confusion as there is no indication as to the host's current HA global maintenance state and/or whether or not a requested action to enable or disable it was successful.<br><br>Result: The user experience around HA global maintenance is greatly improved by making the options available in a more logical location and providing a visual indication as to the current state of HA global maintenance for a given host.
 - [BZ 1392407](https://bugzilla.redhat.com/1392407) <b>[RFE] - HE hosts should have indicators and a way to filter them from the rest of the hosts.</b><br>
 - [BZ 1392412](https://bugzilla.redhat.com/1392412) <b>[RFE] - HE storage should have a indicator.</b><br>
 - [BZ 1135976](https://bugzilla.redhat.com/1135976) <b>Edit pinned vm placement option clear vm cpu pinning options without any error message</b><br>Feature: <br>Added a dialog warning the user of loosing CPU pinning information when saving a VM.<br><br>Reason: <br>Previously, CPU pinning information was silently lost.<br><br>Result: <br>Now user gets notified if it will be lost, with a chance to cancel the operation.
 - [BZ 1306263](https://bugzilla.redhat.com/1306263) <b>Normalize policy unit weights</b><br>Feature: <br><br>The weighting step of VM scheduling changed and the best host is now selected using weighted rank algorithm instead of a pure sum of weights.<br><br>Separate Rank is computed for policy unit and host and represents the number of hosts that were worse according to the policy unit.<br><br>The weight multiplier is then used to multiply the ranks for the given policy unit.<br><br>The host with greatest sum of ranks wins.<br><br>For details please see: http://www.ovirt.org/develop/release-management/features/sla/scheduling-weight-normalization/<br><br>Reason: <br><br>The currently used weight policy units do not use any common result value range. Each unit reports numbers as needed and this causes issues with user configured preferences (policy unit multiplier), because for example memory (very high numbers) always wins over CPU (0-100).<br><br>Result: <br><br>The impact of the policy unit multiplier (from the scheduling policy configuration) is much more predictable. However users that are using it should check their configuration for sanity.

##### Team: Storage

 - [BZ 1314387](https://bugzilla.redhat.com/1314387) <b>[RFE][Tracker] -  Provide streaming API for oVirt</b><br>Feature:<br>This feature adds the possibility to download ovirt images (E.g VM disks) using oVirt's API.
 - [BZ 1246114](https://bugzilla.redhat.com/1246114) <b>[RFE][scale] Snapshot deletion of poweredoff VM takes longer time.</b><br>Previously, when the Virtual Machine was powered down, deleting a snapshot could potentially be a very long process. This was due to the need to copy the data from the base snapshot to the top snapshot, where the base snapshot is usually larger than the top snapshot.<br><br>Now, when deleting a snapshot when the Virtual Machine is powered down, data is copied from the top snapshot to the base snapshot, which significantly reduces the time required to delete the snapshot.
 - [BZ 1342919](https://bugzilla.redhat.com/1342919) <b>[RFE] Make discard configurable by a storage domain rather than a host</b><br>This feature makes it possible to configure "Discard After Delete" (DAD) per block storage domain.<br><br>Up until now, one could get a similar functionality by configuring the discard_enable parameter in VDSM config file (please refer to BZ 981626 for more info). That would have caused each logical volume (disk or snapshot) that was about to be removed by this specific host to be discarded first.<br>Now, one can enable DAD for a block storage domain rather then a host, and therefore decouple the functionality from the execution. That is, no matter which host will actually remove the logical volume, if DAD is enabled for a storage domain, each logical volume under this domain will be discarded before it is removed.<br><br>For more information, please refer to the feature page:<br>http://www.ovirt.org/develop/release-management/features/storage/discard-after-delete/
 - [BZ 1380365](https://bugzilla.redhat.com/1380365) <b>[RFE][HC] - allow forcing import of a VM from a storage domain, even if some of its disks are not accessible.</b><br>Feature: <br>Add the ability to import partial VM<br><br>Reason: <br>HCI DR solution is based on the concept that only data disks are replicated and system disks are not. Currently if some of the VM's disks are not replicated the import of the VM fails. Since some of the disks have snapshots, they can not be imported as floating disks.<br>To allow the DR to works we need to force import of a VM from a storage domain, even if some of its disks are not accessible.<br><br>Result: <br><br>Add the ability to import partial VMs only through REST.<br>The following is a REST request for importing a partial unregistered VM (Same goes for Template)<br><br>POST /api/storagedomains/xxxxxxx-xxxx-xxxx-xxxxxx/vms/xxxxxxx-xxxx-xxxx-xxxxxx/register HTTP/1.1<br>Accept: application/xml<br>Content-type: application/xml<br><br><action><br>    <cluster id='bf5a9e9e-5b52-4b0d-aeba-4ee4493f1072'></cluster><br>    <allow_partial_import>true</allow_partial_import><br></action>
 - [BZ 1241106](https://bugzilla.redhat.com/1241106) <b>[RFE] Allow TRIM from within the guest to shrink thin-provisioned disks on iSCSI and FC storage domains</b><br>A new property was added to virtual machines disks - "Pass Discard".<br><br>When true, and if all the restrictions [1] are met, discard commands (UNMAP SCSI commands) that are sent from the guest will not be ignored by qemu and will be passed on to the underlying storage.<br>Then, the reported unused blocks in the underlying storage thinly provisioned luns will be marked as free so that others can use them, and the reported consumed space of these luns will reduce.<br><br><br>[1] For more information, please refer to the feature page "Pass discard from guest to underlying storage" - http://www.ovirt.org/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage/
 - [BZ 1302185](https://bugzilla.redhat.com/1302185) <b>[RFE] Allow attaching shared storage domains to a local DC</b><br>Feature: <br>Allow attaching shared storage domains to a local DC<br><br>Reason: <br>With the ability to attach and detach a data domain (introduced in 3.5), data domains became a better option for moving VMs/Templates around than an export domain. In order to gain this ability in local DCs, it should be possible to attach a Storage Domain of a shared type to that DC.<br><br>Result: <br>The user will now have the ability to change an initialized Data Center type (Local vs Shared). The following updates will be available: <br>1. Shared to Local - Only for a Data Center that does not contain more than one Host and more than one cluster, since local Data Center does not support it. The engine should validate and block this operation with the following messages:<br><br>CLUSTER_CANNOT_ADD_MORE_THEN_ONE_HOST_TO_LOCAL_STORAGE<br>VDS_CANNOT_ADD_MORE_THEN_ONE_HOST_TO_LOCAL_STORAGE<br><br>2. Local to Shared - Only for a Data Center that does not contain a local Storage Domain. The engine should validate and block this operation with the following message ERROR_CANNOT_CHANGE_STORAGE_POOL_TYPE_WITH_LOCAL.
 - [BZ 827529](https://bugzilla.redhat.com/827529) <b>[RFE] QCOW2 v3 Image Format</b><br>Feature: <br>Make QCOW2 v3 image format available in oVirt<br><br>Reason: <br>The QCOW image format includes a version number to allow introducing new features that change the image format in an incompatible way. Newer QEMU versions (1.7 and above) support a new format of QCOW2 version 3, which is not backwards compatible and introduce many improvements like zero clusters, and performance improvement.<br><br>Result: <br>New QCOW volumes that will be created on a V4 Storage Domains will be created with 1.1 compatibility level. That also includes snapshots, so theoretically we could have an old disk with a chain of volumes that some of the volumes will be with compatibility level of 0.10, and others (like new snapshots) that will be with 1.1 compatibility level based on those 0.10 volumes. Those types of chains are supported by QEMU, and oVirt will also introduce the user the ability to upgrade any disk, so all its volumes will be with the same QCOW compatibility version through a REST update command which will be described later in this document.
 - [BZ 1408876](https://bugzilla.redhat.com/1408876) <b>Deactivating a storage domain containing leases of running VMs should be blocked</b><br>This release enables Virtual Machines to lease areas on the storage domain. If a Virtual Machine has a lease on a storage domain, it will not be possible to move this storage domain into maintenance mode.<br>If the user attempts to do so, an error message will appear explaining that a virtual machine currently has a lease on this storage.

##### Team: UX

 - [BZ 1353556](https://bugzilla.redhat.com/1353556) <b>UX: login to the admin portal is going first to the VMs tab, then hops to the dashboard UI plugin</b><br>Feature: oVirt 4.0 introduced new "Dashboard" tab in WebAdmin UI. This tab is implemented via oVirt UI plugin (ovirt-engine-dashboard) and therefore loaded asynchronously.<br><br>Reason: When loading WebAdmin UI, user lands at "Virtual Machines" tab, followed by immediate switch to "Dashboard" tab. This hinders overall user experience, since the general intention is to have the user landing at "Dashboard" tab.<br><br>Result: Improved UI plugin infra to allow pre-loading UI plugins, such as ovirt-engine-dashboard. The end result is user landing directly at "Dashboard" tab (no intermediate switch to "Virtual Machines").

##### Team: Virt

 - [BZ 734120](https://bugzilla.redhat.com/734120) <b>[RFE] use virt-sparsify to reduce image size</b><br>See "Sparsifying a Virtual Disk" in http://www.ovirt.org/documentation/admin-guide/administration-guide/
 - [BZ 1344521](https://bugzilla.redhat.com/1344521) <b>[RFE] when GA data are missing, a warning should be shown in webadmin asking the user to install/start the GA</b><br>Feature: <br>Show a message, that the guest agent needs to be installed and running in the guest, in the hover text at the exclamation marks in the WebAdmin portal VM overview.<br><br>Reason: <br>Previously the information has been confusing if the guest agent wasn't running or was out of date, the hover text might have said that the operating system wasn't matching or the timezone configuration wasn't correct.
 - [BZ 1097589](https://bugzilla.redhat.com/1097589) <b>[RFE] [7.3] Hot Un-Plug CPU - Support dynamic virtual CPU deallocation</b><br>This release adds support for CPU hot unplug to Red Hat Virtualization. Note that the guest operating system must also support the feature, and only previously hot plugged CPUs can be hot unplugged.
 - [BZ 1036221](https://bugzilla.redhat.com/1036221) <b>[RFE] Automatic prompt for cert import for HTML5 console</b><br>Feature: <br><br>Reason: <br><br>Result: <br>If web console (noVnc or spice html 5) can't connect to websocket proxy server, popup is shown suggesting what should be checked. The popup contains a link to default CA certificate.
 - [BZ 1294629](https://bugzilla.redhat.com/1294629) <b>Improve loading external VMs speed</b><br>Feature: Improve the loading performance of external VMs from external server. Done for the following sources: VMware, KVM, Xen. <br><br>Reason: For displaying the lists of VMs to import in the first dialog, there is no need to ask libvirt for the full information per each VM and since it takes few seconds per VM, we can improve that by receiving the vm name only in that phase. <br><br>Result: displaying VMs names only in the 1st phase, i.e. in the 1st import dialog, and only when choosing the VMS to import and clicking on the "Next" button, then the full VMs data list is displayed on the 2nd dialog.
 - [BZ 1381184](https://bugzilla.redhat.com/1381184) <b>[RFE] allow starting VMs without graphical console (headless)</b><br>Feature: support a headless VM (a VM that runs without any graphical console and without any display device) in engine.<br><br>Reason: till now oVirt engine always added graphical console(s) and video device(s) to a running VM. There wasn't an option in engine to allow running a headless VM, although sometimes is is required . This feature supports running a headless VM from start or after the initial setup (next run after "Run Once"). <br><br>Result: running a headless VM is now supported in engine from start or after the first run with "Run Once". <br>It can be enabled/disabled for a new/existing VM at any time. <br>This headless mode is also supported for templates, pools and instance types.
 - [BZ 1360983](https://bugzilla.redhat.com/1360983) <b>Setting VM name as hostname automatically missing in RunOnce</b><br>Feature: Host name is set automatically to VM name in RunOnce<br><br>Reason: More user-friendly<br><br>Result: The host name is set to VM name by default in RunOnce dialog. The user can change it, if needed.
 - [BZ 1374227](https://bugzilla.redhat.com/1374227) <b>Add /dev/urandom as entropy source for virtio-rng</b><br>random number generator source '/dev/random' is no longer optional (checkbox in cluster dialogs was removed) and is required from all hosts.<br><br>random number generator (RNG) device was added to Blank template and predefined instance types. This means that new VMs will have RNG device by default.<br><br>Note: RNG device was not added to user-created instance types or templates (to avoid unexpected changes in behavior) so if user wants to have RNG device on new VMs that are created based on custom instance types or templates RNG device needs to be added to these instance types / templates manually.
 - [BZ 1392872](https://bugzilla.redhat.com/1392872) <b>[RFE] Add Skylake CPU model</b><br>Intel Skylake family CPUs are now supported
 - [BZ 1399142](https://bugzilla.redhat.com/1399142) <b>[RFE] Change disk default interface to virtio-scsi</b><br>Feature: Change default disk interface type from virtio-blk to virtio-scsi.<br><br>Reason: Motivate users to use better and more modern default for disk interfaces. (virtio-blk will still be supported)<br><br>Result: Now when creating or attaching a disk to VM the virtio-scsi interface type will be selected as default.
 - [BZ 1081536](https://bugzilla.redhat.com/1081536) <b>[RFE] Making VM pools able to allocate VMs to multiple storage domains to balance disk usage</b><br>With this release, when creating virtual machine pools using a template that is present in more than one storage domain, virtual machine disks can be distributed to multiple storage domains by selecting "Auto select target" in New Pool -> Resource Allocation -> Disk Allocation.
 - [BZ 1161625](https://bugzilla.redhat.com/1161625) <b>[RFE] Expose creator of vm via api and/or gui</b><br>Feature: Search VMs on CREATED_BY_USER_ID <br><br>Reason: The user can query VMs on CREATED_BY_USER_ID (REST API).<br><br>Result: <br>The REST API search query is extended for:<br>  .../api/vms?search=created_by_user_id%3D[USER_ID]<br><br>The User ID can be retrieved i.e. by following REST call:<br>  .../api/users<br><br>Please note, the user might be removed from the system since the VM creation.<br><br>In addition, the Administration Portal shows the creators name (or login) in the VM General Subtab.
 - [BZ 1364456](https://bugzilla.redhat.com/1364456) <b>VM's cluster compatibility version override does not change the default machine type</b><br>VM snapshots with memory taken in previous cluster version can be previewed. <br><br>VM's custom compatibility version is temporarily set to the previous version of the cluster.<br>Such a custom compatibility version is reverted by either Undo the preview or cold reboot (shut down and restart).
 - [BZ 1388245](https://bugzilla.redhat.com/1388245) <b>[RFE] Configurable maximum memory size</b><br>This release adds the ability to specify a Maximum Memory value in all VM-like dialogs (Virtual Machine, Template, Pool, and Instance Type). It is accessible in the `{vm, template, instance_type}/memory_policy/max` tag in the REST API. The value defines the upper limit to which memory hot plug can be performed. The default value is 4x memory size.
 - [BZ 1337101](https://bugzilla.redhat.com/1337101) <b>[RFE] enable virtio-rng /dev/urandom by default</b><br>random number generator source '/dev/random' is no longer optional (checkbox in cluster dialogs was removed) and is required from all hosts.<br><br>random number generator (RNG) device was added to Blank template and predefined instance types. This means that new VMs will have RNG device by default.<br><br>Note: RNG device was not added to user-created instance types or templates (to avoid unexpected changes in behavior) so if user wants to have RNG device on new VMs that are created based on custom instance types or templates RNG device needs to be added to these instance types / templates manually.
 - [BZ 1383342](https://bugzilla.redhat.com/1383342) <b>[RFE] API ticket support in graphics devices</b><br>Feature: Allow requesting console ticket for specific graphics device via REST API.<br><br>Reason: The existing endpoint /api/vms/{vmId}/ticket defaulted to SPICE in scenarios when SPICE+VNC was configured as the graphics protocol making it impossible to request a VNC ticket.<br><br>Result: A ticket action was added to the /api/vms/{vmId}/graphicsconsoles/{consoleId} resource making it possible to request ticket for specific console. Usage of this specific endpoints should be preferred from now on and the preexisting per-vm endpoint /api/vms/{vmId}/ticket should be considered deprecated.
 - [BZ 1333436](https://bugzilla.redhat.com/1333436) <b>[RFE] drop Legacy USB</b><br>Feature: Remove the deprecated Legacy USB support<br><br>Reason: It has been deprecated the last version, now dropping<br><br>Result: Currently, the USB can be either enabled or disabled. Previously it was enabled legacy, enabled native or disabled.
 - [BZ 1333045](https://bugzilla.redhat.com/1333045) <b>original template field is not exposed to REST API</b><br>Feature: New 'original_template' property is introduced for the 'vm' REST API resource.<br><br>Reason: Cloned VM has it's template set to Blank, no matter of  what template was original VM based on.<br><br>Result: The user can now get information about template, the VM was based on before cloning.
 - [BZ 1341153](https://bugzilla.redhat.com/1341153) <b>[RFE] 'Remove' template dialog on an export domain should show subversion name</b><br>Feature: Include Templates subversion-name and subversion-number into the "remove template(s)" dialogs. <br><br>Reason: When choosing templates to remove, the remove template(s) dialog showed only templates name and it was hard to identify between templates with subversion<br><br>Result: After the fix,the two template(s) remove dialogs display the following:<br>Are you sure you want to remove the following items?<br>- template-name (Version: subversion-name(subversion-number))

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1353556](https://bugzilla.redhat.com/1353556) <b>UX: login to the admin portal is going first to the VMs tab, then hops to the dashboard UI plugin</b><br>Feature: oVirt 4.0 introduced new "Dashboard" tab in WebAdmin UI. This tab is implemented via oVirt UI plugin (ovirt-engine-dashboard) and therefore loaded asynchronously.<br><br>Reason: When loading WebAdmin UI, user lands at "Virtual Machines" tab, followed by immediate switch to "Dashboard" tab. This hinders overall user experience, since the general intention is to have the user landing at "Dashboard" tab.<br><br>Result: Improved UI plugin infra to allow pre-loading UI plugins, such as ovirt-engine-dashboard. The end result is user landing directly at "Dashboard" tab (no intermediate switch to "Virtual Machines").

#### VDSM

##### Team: Gluster

 - [BZ 1361115](https://bugzilla.redhat.com/1361115) <b>[RFE] Add fencing policies for gluster hosts</b><br>Feature: <br><br>Add gluster related fencing policies for hyper-converged clusters.<br><br>Reason: <br><br>Currently available fencing policies doesn't  care about Gluster processes. But in Hyper-converged mode,  we need fencing policies that ensure that a host is not fenced if<br><br>1. there's a brick process running <br>2. shutting down the host with active brick will cause loss of quorum<br><br>Result: <br><br>Following fencing policies are added to Hyper-converged cluster.<br><br>1. SkipFencingIfGlusterBricksUp<br>    Fencing will be skipped if bricks are running and can be reached from other peers.<br><br>2. SkipFencingIfGlusterQuorumNotMet<br>    Fencing will be skipped if  bricks are running  and shutting down the host will cause loss of quorum

##### Team: Infra

 - [BZ 1141422](https://bugzilla.redhat.com/1141422) <b>[RFE] Show vdsm thread name in system monitoring tools</b><br>Feature: show the thread name in the system monitoring tools<br>Reason: Vdsm uses many threads. Make it easier to track the resource usages of the threads.<br>Result: now Vdsm use explicative system names for its threads.

##### Team: Network

 - [BZ 1326798](https://bugzilla.redhat.com/1326798) <b>[RFE] Run Vdsm while NM is running</b><br>

##### Team: Storage

 - [BZ 1246114](https://bugzilla.redhat.com/1246114) <b>[RFE][scale] Snapshot deletion of poweredoff VM takes longer time.</b><br>Previously, when the Virtual Machine was powered down, deleting a snapshot could potentially be a very long process. This was due to the need to copy the data from the base snapshot to the top snapshot, where the base snapshot is usually larger than the top snapshot.<br><br>Now, when deleting a snapshot when the Virtual Machine is powered down, data is copied from the top snapshot to the base snapshot, which significantly reduces the time required to delete the snapshot.
 - [BZ 1342919](https://bugzilla.redhat.com/1342919) <b>[RFE] Make discard configurable by a storage domain rather than a host</b><br>This feature makes it possible to configure "Discard After Delete" (DAD) per block storage domain.<br><br>Up until now, one could get a similar functionality by configuring the discard_enable parameter in VDSM config file (please refer to BZ 981626 for more info). That would have caused each logical volume (disk or snapshot) that was about to be removed by this specific host to be discarded first.<br>Now, one can enable DAD for a block storage domain rather then a host, and therefore decouple the functionality from the execution. That is, no matter which host will actually remove the logical volume, if DAD is enabled for a storage domain, each logical volume under this domain will be discarded before it is removed.<br><br>For more information, please refer to the feature page:<br>http://www.ovirt.org/develop/release-management/features/storage/discard-after-delete/
 - [BZ 1241106](https://bugzilla.redhat.com/1241106) <b>[RFE] Allow TRIM from within the guest to shrink thin-provisioned disks on iSCSI and FC storage domains</b><br>A new property was added to virtual machines disks - "Pass Discard".<br><br>When true, and if all the restrictions [1] are met, discard commands (UNMAP SCSI commands) that are sent from the guest will not be ignored by qemu and will be passed on to the underlying storage.<br>Then, the reported unused blocks in the underlying storage thinly provisioned luns will be marked as free so that others can use them, and the reported consumed space of these luns will reduce.<br><br><br>[1] For more information, please refer to the feature page "Pass discard from guest to underlying storage" - http://www.ovirt.org/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage/
 - [BZ 827529](https://bugzilla.redhat.com/827529) <b>[RFE] QCOW2 v3 Image Format</b><br>Feature: <br>Make QCOW2 v3 image format available in oVirt<br><br>Reason: <br>The QCOW image format includes a version number to allow introducing new features that change the image format in an incompatible way. Newer QEMU versions (1.7 and above) support a new format of QCOW2 version 3, which is not backwards compatible and introduce many improvements like zero clusters, and performance improvement.<br><br>Result: <br>New QCOW volumes that will be created on a V4 Storage Domains will be created with 1.1 compatibility level. That also includes snapshots, so theoretically we could have an old disk with a chain of volumes that some of the volumes will be with compatibility level of 0.10, and others (like new snapshots) that will be with 1.1 compatibility level based on those 0.10 volumes. Those types of chains are supported by QEMU, and oVirt will also introduce the user the ability to upgrade any disk, so all its volumes will be with the same QCOW compatibility version through a REST update command which will be described later in this document.

##### Team: Virt

 - [BZ 1354343](https://bugzilla.redhat.com/1354343) <b>[RFE] Add support for post copy migration (tech preview)</b><br>Feature: <br><br>Post-copy migration (tech preview)<br><br>Reason: <br><br>Providing a migration policy that is guaranteed to converge.<br><br>Result: <br><br>Post-copy migration policy is similar to Minimal Downtime policy, but the last step is to turn to post-copy migration. Post-copy migration (http://wiki.qemu.org/Features/PostCopyLiveMigration#Summary) guarantees that the migration will eventually converge, with very short downtime. Nevertheless there are also disadvantages. In the post-copy phase the VM may slow down significantly as the missing parts of memory contents being accessed are transferred between the hosts on demand. And if anything wrong happens during the post-copy phase (e.g. network failure between the hosts) then the running VM instance is lost; for that reason it is not possible to abort a migration in the post-copy phase.
 - [BZ 734120](https://bugzilla.redhat.com/734120) <b>[RFE] use virt-sparsify to reduce image size</b><br>See "Sparsifying a Virtual Disk" in http://www.ovirt.org/documentation/admin-guide/administration-guide/
 - [BZ 1294629](https://bugzilla.redhat.com/1294629) <b>Improve loading external VMs speed</b><br>Feature: Improve the loading performance of external VMs from external server. Done for the following sources: VMware, KVM, Xen. <br><br>Reason: For displaying the lists of VMs to import in the first dialog, there is no need to ask libvirt for the full information per each VM and since it takes few seconds per VM, we can improve that by receiving the vm name only in that phase. <br><br>Result: displaying VMs names only in the 1st phase, i.e. in the 1st import dialog, and only when choosing the VMS to import and clicking on the "Next" button, then the full VMs data list is displayed on the 2nd dialog.
 - [BZ 1356161](https://bugzilla.redhat.com/1356161) <b>[RFE] prefer numa nodes close to host devices when using hostdev passthrough</b><br>This RFE is related to host devices and should be reflected in virtual machine management guide as a note (somewhere close to Procedure 6.15. Adding Host Devices to a Virtual Machine).<br><br>For some context, the feature tries to do best effort to implement https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7-Beta/html/Virtualization_Tuning_and_Optimization_Guide/sect-Virtualization_Tuning_Optimization_Guide-NUMA-NUMA_and_libvirt.html#sect-Virtualization_Tuning_Optimization_Guide-NUMA-Node_Locality_for_PCI<br><br>If the user does not specify any NUMA mapping himself, oVirt now tries to prefer NUMA node where device MMIO is. Main constraint is that we only *prefer* such node rather than strictly requiring memory from it. Implication is that the optimization may or may not be active depending on host's memory load AND only works as long as all assigned devices are from single NUMA node.
 - [BZ 1350465](https://bugzilla.redhat.com/1350465) <b>[RFE] Store detailed log of virt-v2v when importing VM</b><br>Feature:<br><br>Complete logs of the VM import with virt-v2v are now stored in /var/log/vdsm/import directory.<br><br>Reason: <br><br>When import of a VM fails it is usually necessary to have complete logs of virt-v2v to properly investigate the reason. The output of virt-v2v was not previously available and the import had to be reproduced manually. This not only prolongs the investigation of the issue, but replicating the VDSM environment for virt-v2v is also not completely straightforward.<br><br>Result: <br><br>Output of virt-v2v is now stored in directory /var/log/vdsm/import. All logs older than 30 days are automatically removed.
 - [BZ 1321010](https://bugzilla.redhat.com/1321010) <b>[RFE] use virtlogd as introduced in libvirt >= 1.3.0</b><br>
 - [BZ 1349907](https://bugzilla.redhat.com/1349907) <b>RFE: Guest agent hooks for hibernation should be always executed.</b><br>This feature will have the before_hibernation / after_hibernation hooks executed on the guest operating system (with the ovirt guest agent) always in case of suspending / resuming a Virtual Machine

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1001181](https://bugzilla.redhat.com/1001181) <b>[RFE] Provide clean up script for complete cleaning the hosted engine VM installation after failed installation.</b><br>Provide a clean up script for complete cleaning the host after a failed attempt installing hosted-engine
 - [BZ 1393918](https://bugzilla.redhat.com/1393918) <b>Move ancillary commands to jsonrpc</b><br>Some ancillary hosted-engine commands were still based on xmlrpc, moving them to jsonrpc.
 - [BZ 1349301](https://bugzilla.redhat.com/1349301) <b>[RFE] Successfully complete hosted engine setup without appliance pre-installed.</b><br>Feature: <br>Let the user install the appliance rpm directly from ovirt-hosted-engine-setup<br><br>Reason: <br>ovirt-hosted-engine-setup supports now only the appliance based flow<br><br>Result:<br>The user can install ovirt-egnine-appliance directly from ovirt-hosted-engine-setup
 - [BZ 1331858](https://bugzilla.redhat.com/1331858) <b>[RFE] Allow user to enable ssh access for RHEV-M appliance during hosted-engine deploy</b><br>Feature: <br>Let the user optionally enable ssh access for RHEV-M appliance during hosted-engine deploy.<br>The user can choose between yes, no and without-password.<br>The user can also pass a public ssh key for the root user at hosted-engine-setup time.
 - [BZ 1366183](https://bugzilla.redhat.com/1366183) <b>[RFE] - Remove all bootstrap flows other than appliance and remove addition of additional hosts via CLI.</b><br>Having now the capability to deploy additional hosted-engine hosts from the engine with host-deploy, the capability to deploy additional hosted-engine hosts from hosted-engine setup is not required anymore. Removing it.<br>The engine-appliance has proved to be the easiest flow to have a working hosted-engine env; removing all other bootstrap flows.
 - [BZ 1300591](https://bugzilla.redhat.com/1300591) <b>[RFE] let the user customize the engine VM disk size also using the engine-appliance</b><br>Let the user customize the engine VM disk size also if he choose to use the engine-appliance.
 - [BZ 1402435](https://bugzilla.redhat.com/1402435) <b>HE still uses 6.5-based  machine type</b><br>Upgrade the machine type since the engine VM is running for sure on el7
 - [BZ 1365022](https://bugzilla.redhat.com/1365022) <b>[RFE] hosted-engine --deploy question ordering improvements</b><br>
 - [BZ 1318350](https://bugzilla.redhat.com/1318350) <b>[RFE] configure the timezone for the engine VM as the host one via cloudinit</b><br>Feature: Ask customer about NTP configuration inside the appliance<br><br>Reason: <br><br>Result:

#### oVirt Hosted Engine HA

##### Team: Integration

 - [BZ 1001181](https://bugzilla.redhat.com/1001181) <b>[RFE] Provide clean up script for complete cleaning the hosted engine VM installation after failed installation.</b><br>Provide a clean up script for complete cleaning the host after a failed attempt installing hosted-engine
 - [BZ 1396672](https://bugzilla.redhat.com/1396672) <b>modify output of the hosted engine CLI to show info on auto import process</b><br>Since Red Hat Enterprise Virtualization 3.6, ovirt-ha-agent has read its configuration, and the Manager virtual machine specification, from shared storage. Previously, they were just local files replicated on each involved host. This enhancement modifies the output of hosted-engine --vm-status to show if the configuration and the Manager virtual machine specification has been, on each reported host, correctly read from the shared storage.
 - [BZ 1101554](https://bugzilla.redhat.com/1101554) <b>[RFE] HE-ha: use vdsm api instead of vdsClient</b><br>vdsClient uses xmlrpc that got deprecated in 4.0. Directly using vdsm api to take advantages of jsonrpc.

#### oVirt Windows Guest Agent

##### Team: Integration

 - [BZ 1310621](https://bugzilla.redhat.com/1310621) <b>[RFE] oVirt Guest Tools name should include version in install apps list</b><br>

#### oVirt Cockpit Plugin

##### Team: Gluster

 - [BZ 1325864](https://bugzilla.redhat.com/1325864) <b>[RFE] Cockpit plugin for gdeploy</b><br>Feature: <br><br>Add support for deploying gluster as part of hosted engine deployment through Cockpit UI.<br><br>Reason:<br><br>Deploying a Hyperconverged solution using oVirt and Gluster was not straight forward. User has to deploy gluster using gdeploy first then deploy the hosted-engine using Cockpit UI. It requires lot of editing in the config files. This feature helps to deploy Gluster using Gdeploy through Cockpit UI.<br><br>Result: <br><br>In a Gluster and oVirt Hyperconverged environment, user no longer required to deploy gluster separately. He can deploy gluster using Cockpit UI as part of ovirt hosted engine deployment.

#### imgbased

##### Team: Node

 - [BZ 1361230](https://bugzilla.redhat.com/1361230) <b>[RFE] Simple mechanism to apply rpms after upgrades</b><br>Feature: 4.0 hypervisor images allow for the installation of RPMs, but any RPMs installed this way were lost on upgrades. The hypervisor now contains a yum plugin which will save and reinstall any packages installed via RPM on upgrades.<br><br>Reason: In order to provide a consistent experience for users, packages which are installed should stay installed.<br><br>Result: RPMs installed via yum are now kept after upgrade.
 - [BZ 1338744](https://bugzilla.redhat.com/1338744) <b>[RFE] Validate pre-conditions during installation</b><br>
 - [BZ 1331278](https://bugzilla.redhat.com/1331278) <b>[RFE] Raise a meaningful error of the layout can not be created (i.e. no thinpool available)</b><br>

### No Doc Update

#### oVirt Engine

##### Team: SLA

 - [BZ 1346669](https://bugzilla.redhat.com/1346669) <b>Can't start a VM (NPE around scheduling.SchedulingManager.selectBestHost(SchedulingManager.java:434) )</b><br>undefined
 - [BZ 1377632](https://bugzilla.redhat.com/1377632) <b>Provide information in the logs about who and why the VM was migrated automatically by the system</b><br>undefined
 - [BZ 1148039](https://bugzilla.redhat.com/1148039) <b>When create vm NUMA node it useless to specify host numa node index</b><br>undefined
 - [BZ 1306698](https://bugzilla.redhat.com/1306698) <b>NUMA memory mapping is not generated correctly</b><br>undefined
 - [BZ 1346960](https://bugzilla.redhat.com/1346960) <b>Creating template from VM snapshot causes FE ClassCastException</b><br>undefined

##### Team: Virt

 - [BZ 1320879](https://bugzilla.redhat.com/1320879) <b>Can't edit running stateless VM</b><br>undefined
 - [BZ 1356996](https://bugzilla.redhat.com/1356996) <b>Typo in log message - exteral instead of external</b><br>undefined

#### VDSM

##### Team: SLA

 - [BZ 1306698](https://bugzilla.redhat.com/1306698) <b>NUMA memory mapping is not generated correctly</b><br>undefined

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1313916](https://bugzilla.redhat.com/1313916) <b>we should default to current hostname for host name in engine in initial HE setup</b><br>undefined

### Release Note

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1343882](https://bugzilla.redhat.com/1343882) <b>Now, with the appliance flow, drop the virt-viewer dependency and just document this requirement</b><br>Curently hosted-engine-setup requires virt-viewer. This is pulling in a graphics stack (and many megabytes of packages).<br>With the appliance flow in place the virt-viewer will no longer be required by default.

### Unclassified

#### oVirt image transfer daemon and proxy

##### Team: Integration

 - [BZ 1379674](https://bugzilla.redhat.com/1379674) <b>urllib2 is not in python3</b><br>

##### Team: Storage

 - [BZ 1402279](https://bugzilla.redhat.com/1402279) <b>Improve daemon logging</b><br>

#### oVirt Release Package

##### Team: Node

 - [BZ 1375568](https://bugzilla.redhat.com/1375568) <b>tcpdump is not installed on rhev-hypervisor7-ng</b><br>
 - [BZ 1362604](https://bugzilla.redhat.com/1362604) <b>Inlcude rng-tools package</b><br>

#### oVirt Engine

##### Team: Gluster

 - [BZ 1408803](https://bugzilla.redhat.com/1408803) <b>Unable to add a volume option on the gluster volume</b><br>
 - [BZ 1366167](https://bugzilla.redhat.com/1366167) <b>Replica count does not get displayed until the "Volume Types" are refreshed.</b><br>
 - [BZ 1365604](https://bugzilla.redhat.com/1365604) <b>Mouse hovering on the volume  does not display any tool tip</b><br>
 - [BZ 1409523](https://bugzilla.redhat.com/1409523) <b>Number of bricks information in general sub tab of volume should be modified if user creates/syncs  an arbiter volume from UI</b><br>
 - [BZ 1380739](https://bugzilla.redhat.com/1380739) <b>virtual-host to be default tuned profile when cluster has both virt+gluster enabled.</b><br>
 - [BZ 1368827](https://bugzilla.redhat.com/1368827) <b>optimizing the gluster volume from UI should set the network.ping-timeout value to 30 seconds</b><br>
 - [BZ 1386265](https://bugzilla.redhat.com/1386265) <b>Variable names are displayed in error dialog as against the actual values, when moving 2 of the nodes in the hc cluster to maintenance state</b><br>
 - [BZ 1379754](https://bugzilla.redhat.com/1379754) <b>Host can't be removed (FE exception)</b><br>

##### Team: Infra

 - [BZ 1404803](https://bugzilla.redhat.com/1404803) <b>Error: Package: ovirt-engine-tools-4.1.0-0.0.master.20161201071307.gita5ff876.el7.centos.noarch - Broken 4.1 dependencies for upstream http://resources.ovirt.org/pub/yum-repo/ovirt-release41-pre.rpm</b><br>
 - [BZ 1413928](https://bugzilla.redhat.com/1413928) <b>If host, where hosted engine VM is running, become NonResponsive, it's not properly fenced, so HA VMs executed on that host are not restarted automatically on different host</b><br>
 - [BZ 1408843](https://bugzilla.redhat.com/1408843) <b>Exception thrown when viewing Errata information</b><br>
 - [BZ 1378902](https://bugzilla.redhat.com/1378902) <b>vv file can't be obtained using SDK</b><br>
 - [BZ 1408159](https://bugzilla.redhat.com/1408159) <b>[RFE] Add log_type and log_name to engine events logs.</b><br>
 - [BZ 1393459](https://bugzilla.redhat.com/1393459) <b>Command execution context information is only partially persisted in the db</b><br>
 - [BZ 1405810](https://bugzilla.redhat.com/1405810) <b>[RFE] Make update manager also update collectd/fluentd and plugins</b><br>
 - [BZ 1387996](https://bugzilla.redhat.com/1387996) <b>Use TLS negotiation for engine <-> SSO module communication</b><br>
 - [BZ 1393714](https://bugzilla.redhat.com/1393714) <b>Servers state isn't stable and they changing state to non-responsive every few minutes, if one host in the DC is non-responsive with the engine</b><br>
 - [BZ 1356560](https://bugzilla.redhat.com/1356560) <b>[scale] Getting user VMs from user portal is taking too long</b><br>
 - [BZ 1393345](https://bugzilla.redhat.com/1393345) <b>ovirt-fence-kdump-listener service unit file for systemd does not contain dependency on postgresql</b><br>
 - [BZ 1404051](https://bugzilla.redhat.com/1404051) <b>End external job expects a status to be provided, but it's not declared in the api model</b><br>
 - [BZ 1411416](https://bugzilla.redhat.com/1411416) <b>Session expired message shown on SSO login page after session expiration</b><br>
 - [BZ 1411648](https://bugzilla.redhat.com/1411648) <b>Limit thread pool size for host upgrade checks</b><br>
 - [BZ 1409110](https://bugzilla.redhat.com/1409110) <b>New Host window contains a checkbox without a label under the "General" tab -> "Advanced Parameters"</b><br>
 - [BZ 1399479](https://bugzilla.redhat.com/1399479) <b>[SSO][Regression] SSO failure when LoginOnBehalf is called</b><br>
 - [BZ 1400500](https://bugzilla.redhat.com/1400500) <b>If AvailableUpdatesFinder finds already running process it should not be ERROR level</b><br>
 - [BZ 1380128](https://bugzilla.redhat.com/1380128) <b>[RFE] Use authz name instead of profile name as domain for Cloud-Init/Sysprep for windows guests.</b><br>
 - [BZ 1381419](https://bugzilla.redhat.com/1381419) <b>Events tab in UI displays updates available as "UNKNOWN" when there are no updates present for the node.</b><br>
 - [BZ 1390484](https://bugzilla.redhat.com/1390484) <b>Postgres DB overloads the CPU when specific bookmarks queries are triggered.</b><br>
 - [BZ 1388421](https://bugzilla.redhat.com/1388421) <b>Remove connection check before each query</b><br>
 - [BZ 1388117](https://bugzilla.redhat.com/1388117) <b>Hide tracebacks in engine.log when host is not responsive</b><br>
 - [BZ 1383224](https://bugzilla.redhat.com/1383224) <b>RHVH-NG is automatically activated after upgrade.</b><br>
 - [BZ 1383020](https://bugzilla.redhat.com/1383020) <b>Wrong cluster in "Edit host" dialog</b><br>
 - [BZ 1375668](https://bugzilla.redhat.com/1375668) <b>[REST API] href links  are missing under api/datacenters/<dc id>/networks</b><br>
 - [BZ 1373242](https://bugzilla.redhat.com/1373242) <b>serialization of command parameters allows serialization of immutable objects.</b><br>
 - [BZ 1371501](https://bugzilla.redhat.com/1371501) <b>remove deprecated changedbowner.sh script</b><br>
 - [BZ 1368030](https://bugzilla.redhat.com/1368030) <b>Upgrade manager: log for failure is not well phrased: with message 'java.nio.channels.UnresolvedAddressException'."</b><br>
 - [BZ 1369413](https://bugzilla.redhat.com/1369413) <b>Add 3.6 host fails in rhv-m 3.6.8 from time to time and after few minutes it auto recovering and comes up</b><br>
 - [BZ 1362472](https://bugzilla.redhat.com/1362472) <b>[RFE] Remove dependency on fop and its transitive dependencies</b><br>
 - [BZ 1367438](https://bugzilla.redhat.com/1367438) <b>When failing on execute() when using COCO the end method is called before the child commands ends</b><br>
 - [BZ 1361511](https://bugzilla.redhat.com/1361511) <b>During host upgrade Upgrade process terminated info message shown</b><br>
 - [BZ 1347628](https://bugzilla.redhat.com/1347628) <b>[RFE] hystrix monitoring integration</b><br>

##### Team: Integration

 - [BZ 1379674](https://bugzilla.redhat.com/1379674) <b>urllib2 is not in python3</b><br>
 - [BZ 1354180](https://bugzilla.redhat.com/1354180) <b>[RFE] remove 'FIX_RELEASE=' from version.mak file</b><br>
 - [BZ 1351668](https://bugzilla.redhat.com/1351668) <b>Automatic provisioning of dwh db keeps password in answer file if engine is installed</b><br>
 - [BZ 1405813](https://bugzilla.redhat.com/1405813) <b>[RFE] Configure collectd and fluentd on hosts</b><br>
 - [BZ 1379354](https://bugzilla.redhat.com/1379354) <b>README: Maven-3 is written as "optional" and "required" at the Prerequisites section</b><br>

##### Team: Network

 - [BZ 1408175](https://bugzilla.redhat.com/1408175) <b>SetupNetworks fails if connection to Vdsm is RST while it takes place</b><br>
 - [BZ 1410189](https://bugzilla.redhat.com/1410189) <b>04_01_0010_add_mac_pool_id_to_vds_group.sql Fails upgrade if engine has cluster not attached to DC</b><br>upgrade script 04_01_0010_add_mac_pool_id_to_vds_group.sql assumed, that there cannot exist clusters without relation to some data center. Such clusters won't be able to run any VM and would have other serious problems, therefore it was assumed, that no one has this setup. This assumption was wrong and because of that db script failed on creation not null db constraint. After this fix upgrade works also for environments containing such clusters.
 - [BZ 1408834](https://bugzilla.redhat.com/1408834) <b>[SR-IOV] - VF leakage on destination host in case of migration failure</b><br>
 - [BZ 1408669](https://bugzilla.redhat.com/1408669) <b>Import VM - Exception: java.lang.NullPointerException when trying to remap 'empty' source network/profile</b><br>
 - [BZ 1405761](https://bugzilla.redhat.com/1405761) <b>MAC addresses are not freed when a storage domain is detached from dc</b><br>
 - [BZ 1388957](https://bugzilla.redhat.com/1388957) <b>"No network filter" option is missing</b><br>
 - [BZ 1372955](https://bugzilla.redhat.com/1372955) <b>Clusters with no display network after upgrade</b><br>
 - [BZ 1411780](https://bugzilla.redhat.com/1411780) <b>MAC addresses that has been re-assigned are not freed when detaching data domain</b><br>
 - [BZ 1404130](https://bugzilla.redhat.com/1404130) <b>Network Interfaces with duplicate MACs are automatically unplugged when VM started as stateless</b><br>
 - [BZ 1341162](https://bugzilla.redhat.com/1341162) <b>[SR-IOV] - Specific networks list in the edit VFs dialog(in the PF) is out of the dialog range in case of multiple networks in the DC</b><br>
 - [BZ 1402703](https://bugzilla.redhat.com/1402703) <b>[SR-IOV] - Only 'passthrough' vNIC can be marked as 'migratable'</b><br>
 - [BZ 1383449](https://bugzilla.redhat.com/1383449) <b>New external network doesn't get attached to all DC clusters by default</b><br>
 - [BZ 1391130](https://bugzilla.redhat.com/1391130) <b>[UI] - The edit bond interface dialog window is broken once choosing the bonding mode 'Custom'</b><br>
 - [BZ 1338685](https://bugzilla.redhat.com/1338685) <b>REST openstacknetworkproviders returns incorrect results</b><br>
 - [BZ 1360630](https://bugzilla.redhat.com/1360630) <b>[UI] - Exception when trying to break a bond with an unmanaged network attached to him</b><br>
 - [BZ 1349912](https://bugzilla.redhat.com/1349912) <b>GET of an unknown network id should return error 404</b><br>
 - [BZ 1410346](https://bugzilla.redhat.com/1410346) <b>[Text] - Misspelling for “of” as “ouf” in the warning for MAC address(es) 00:00:00:00:00:20, which is/are out ouf its MAC pool definitions</b><br>
 - [BZ 1396995](https://bugzilla.redhat.com/1396995) <b>when Add nic fail on Mac address is already in use, the Mac address is not mentioned in any log</b><br>
 - [BZ 1406808](https://bugzilla.redhat.com/1406808) <b>[SR-IOV] - Labels list in the "Edit Virtual Functions" dialog has improper size</b><br>
 - [BZ 1362401](https://bugzilla.redhat.com/1362401) <b>[OVS] [UI][RFE] - Add column to the 'Clusters' main tab that will indicate the cluster's switch type</b><br>
 - [BZ 1362042](https://bugzilla.redhat.com/1362042) <b>Add provider window- the 'read only' checkbox should be 'read-only'.</b><br>

##### Team: SLA

 - [BZ 1410040](https://bugzilla.redhat.com/1410040) <b>VM enter to the migration loop when the engine has both VM to host soft affinity group and load balancer</b><br>
 - [BZ 1390675](https://bugzilla.redhat.com/1390675) <b>Hosted Engine CPU usage is always shown as  100 % in the web UI</b><br>
 - [BZ 1401974](https://bugzilla.redhat.com/1401974) <b>Failed to start VM under preferred NUMA mode</b><br>
 - [BZ 1404231](https://bugzilla.redhat.com/1404231) <b>RunVMCommand fails with NPE during scheduling</b><br>
 - [BZ 1392389](https://bugzilla.redhat.com/1392389) <b>[RFE] Add indicator to the HE VM in the VM grid.</b><br>
 - [BZ 1409112](https://bugzilla.redhat.com/1409112) <b>After backup-restore operation HE storage domain stuck in the 'Locked' state</b><br>
 - [BZ 1349460](https://bugzilla.redhat.com/1349460) <b>[RFE][UI] - Engine should warn user removing a HE host that, he should first undeploy HE from it.</b><br>

##### Team: Storage

 - [BZ 1405817](https://bugzilla.redhat.com/1405817) <b>Remove snapshot fail to GetVolumeInfoVDS, error = (-227, 'Unable to read resource owners', 'Sanlock exception'), code = 100</b><br>
 - [BZ 1408841](https://bugzilla.redhat.com/1408841) <b>[RFE] Add an API for identifying HSM selection with new Task infrastructure without Master File system Persistency</b><br>
 - [BZ 1402789](https://bugzilla.redhat.com/1402789) <b>Engine - Prevent deactivation of hosted engine storage domain</b><br>
 - [BZ 1379131](https://bugzilla.redhat.com/1379131) <b>Snapshot not removed on commit of previous one</b><br>
 - [BZ 1394114](https://bugzilla.redhat.com/1394114) <b>Migration of HE Disk ends up in Locked State</b><br>
 - [BZ 1384466](https://bugzilla.redhat.com/1384466) <b>Wrong error when attaching an NFS USI domain to default cluster: "Storage domain does not exist" instead of a mount error</b><br>
 - [BZ 1373181](https://bugzilla.redhat.com/1373181) <b>Error while executing action Attach Storage Domain: Internal Engine Error when importing iscsi storage domain</b><br>
 - [BZ 1363696](https://bugzilla.redhat.com/1363696) <b>Image upload: message: Failed to resume upload: size of prior file.. is misplaced (appears too low)</b><br>
 - [BZ 1379771](https://bugzilla.redhat.com/1379771) <b>Introduce a 'force' flag for updating a storage server connection</b><br>In order to update a storage server connection regardless to the associated storage domain status (i.e. updating also when the domain is *not* in status Maintenance) - introduced a 'force' flag.<br><br>E.g. PUT /ovirt-engine/api/storageconnections/123?force
 - [BZ 1348405](https://bugzilla.redhat.com/1348405) <b>RHEV: limit number of images in an image chain (snapshots)</b><br>Problem: Due to the maximum path length in qemu, snapshots operations start to fail around the 98th image in the chain. the VM won't migrate/restart<br><br>Solution: Limit the number of snapshots per disk in the engine<br><br>Fix:<br>Introducing a new config value called MaxImagesInChain with a limit number of 90.<br>The limit includes all the image chain, the active volume and the image's snapshots.<br>For example if a disk will have 89 snapshots, the next snapshot that will be created will be blocked by a CDA.<br><br>Other related operations which uses snapshots like live migrate disk or running a stateless VM will also apply to the same limitation to avoid failure
 - [BZ 1367399](https://bugzilla.redhat.com/1367399) <b>[RFE] add the option to set spm priority to Never in engine GUI</b><br>
 - [BZ 1353134](https://bugzilla.redhat.com/1353134) <b>Reconstructing master should prefer shared domains over local domains</b><br>
 - [BZ 1353137](https://bugzilla.redhat.com/1353137) <b>Memory volume placement should prefer shared to local domains</b><br>
 - [BZ 1357882](https://bugzilla.redhat.com/1357882) <b>Sort the 'Use Host' list alphabetically in the add Direct Lun dialog</b><br>
 - [BZ 1390072](https://bugzilla.redhat.com/1390072) <b>Stopping a stateless VM does not erase state snapshot</b><br>
 - [BZ 1370167](https://bugzilla.redhat.com/1370167) <b>row with 'Used by' checkboxes has left-margin in Storage section</b><br>
 - [BZ 1414675](https://bugzilla.redhat.com/1414675) <b>core: StorageJobCallback - npe when there is no executing host</b><br>
 - [BZ 1345787](https://bugzilla.redhat.com/1345787) <b>Logging: useless alert on engine side: command failed: Cannot find master domain: ... (followed with UUIDs)</b><br>
 - [BZ 1414288](https://bugzilla.redhat.com/1414288) <b>DownloadImageCommandParameters fail to store to DB</b><br>
 - [BZ 1414100](https://bugzilla.redhat.com/1414100) <b>Wrong NFS version selected by default</b><br>
 - [BZ 1413961](https://bugzilla.redhat.com/1413961) <b>When creating a VM with lease the destination storage domain should be validated</b><br>
 - [BZ 1411123](https://bugzilla.redhat.com/1411123) <b>[REST-API] Glance image import: Imported image ID is missing from response body</b><br>
 - [BZ 1412230](https://bugzilla.redhat.com/1412230) <b>Add REST API for VM leases</b><br>
 - [BZ 1409125](https://bugzilla.redhat.com/1409125) <b>SPDM job commands may not end while the performing host is non responsive</b><br>
 - [BZ 1413397](https://bugzilla.redhat.com/1413397) <b>Creation of VM leases should be blocked for data center versions lower than 4.1</b><br>
 - [BZ 1408143](https://bugzilla.redhat.com/1408143) <b>Failure to amend a volume will cause the volume to become illegal</b><br>
 - [BZ 1411111](https://bugzilla.redhat.com/1411111) <b>Cold Merge: bad audit message</b><br>
 - [BZ 1411479](https://bugzilla.redhat.com/1411479) <b>Clone vm from template may fail on block domain because of the initial volume size is too big</b><br>
 - [BZ 1411110](https://bugzilla.redhat.com/1411110) <b>Cold Merge: Improve polling of prepareMerge and finalizeMerge steps</b><br>
 - [BZ 1410019](https://bugzilla.redhat.com/1410019) <b>Disks with illegal Pass Discard value are not logged</b><br>
 - [BZ 1410017](https://bugzilla.redhat.com/1410017) <b>Audit log shows wrong disks' ids for disks with illegal Pass Discard</b><br>
 - [BZ 1409995](https://bugzilla.redhat.com/1409995) <b>Failed to start a VM with deactivated disk</b><br>
 - [BZ 1391463](https://bugzilla.redhat.com/1391463) <b>VM's disk removal is not logged in VM's Events subtab</b><br>
 - [BZ 1410115](https://bugzilla.redhat.com/1410115) <b>Free space validation when removing multiple devices from a storage domain</b><br>
 - [BZ 1408877](https://bugzilla.redhat.com/1408877) <b>Detaching a storage domain containing leases of VMs or templates should be blocked</b><br>
 - [BZ 1408920](https://bugzilla.redhat.com/1408920) <b>Discard after delete should be checked when attaching a storage domain to a data center</b><br>
 - [BZ 1403578](https://bugzilla.redhat.com/1403578) <b>[engine-webadmin] VM name text box in Import VM prompt doesn't get highlighted in case the VM name exists in the setup</b><br>
 - [BZ 1380678](https://bugzilla.redhat.com/1380678) <b>Disk snapshots cannot be sorted by status (regression)</b><br>
 - [BZ 1408726](https://bugzilla.redhat.com/1408726) <b>Add the ability to attach older storage domains into to a new Data Center</b><br>
 - [BZ 1347113](https://bugzilla.redhat.com/1347113) <b>When creating a new VM disk with an IDE interface, the "Read Only" field should not be displayed at all</b><br>
 - [BZ 1364152](https://bugzilla.redhat.com/1364152) <b>Attaching a disk through new VM popup when no data center is active throws an exception</b><br>
 - [BZ 1405940](https://bugzilla.redhat.com/1405940) <b>Auto-generated snapshot remains locked when trying to move disk between local and shared SDs</b><br>
 - [BZ 1404727](https://bugzilla.redhat.com/1404727) <b>Storage domain remain locked after engine restart while attachment is in progress due to NPE in the compensation infrastructure</b><br>
 - [BZ 1402455](https://bugzilla.redhat.com/1402455) <b>Clicking on "login" multiple times results in duplicate entries in the Storage Domain table</b><br>
 - [BZ 1402315](https://bugzilla.redhat.com/1402315) <b>VM MaxDiskSize is limited to 8191GB</b><br>
 - [BZ 1402088](https://bugzilla.redhat.com/1402088) <b>General command validation failure on validateMacs when importing an unregistered VM with wrong id</b><br>
 - [BZ 1399860](https://bugzilla.redhat.com/1399860) <b>Removing an audit log for no OVF_STORE disks when attaching a storage domain</b><br>
 - [BZ 1394567](https://bugzilla.redhat.com/1394567) <b>creating iscsi storage domain for the first time via admin GUI does not show volumes</b><br>
 - [BZ 1395746](https://bugzilla.redhat.com/1395746) <b>Live Storage Migration fails and leaves disks in locked state</b><br>
 - [BZ 1394564](https://bugzilla.redhat.com/1394564) <b>Adding direct LUN disk via REST API is failed with NullPointerException</b><br>
 - [BZ 1362152](https://bugzilla.redhat.com/1362152) <b>Code change - move is_using_scsi_reservation to DiskVmElement</b><br>
 - [BZ 1383220](https://bugzilla.redhat.com/1383220) <b>[UI] - Not possible to create new disks for existing VMs in UI</b><br>
 - [BZ 1385533](https://bugzilla.redhat.com/1385533) <b>Can not copy or move disks from one storage domain to another</b><br>
 - [BZ 1381322](https://bugzilla.redhat.com/1381322) <b>VM disks in the VM configuration gui are shown in no particular order.</b><br>
 - [BZ 1381807](https://bugzilla.redhat.com/1381807) <b>Adding direct LUN fails with an NPE @ DiskVmElementValidator.isVirtioScsiControllerAttached(DiskVmElementValidator.java:71)</b><br>
 - [BZ 1371960](https://bugzilla.redhat.com/1371960) <b>When extending a storage domain with a new lun, the old information of the lun is saved in the db</b><br>Previously, when extending a block domain with a new lun, wrong information about this lun was saved in the DB.<br>Thus, when editing the storage domain, the new lun's information that was shown in the view was incorrect.<br>Now we save the right information, and therefore the new lun's information that is shown in the luns view when editing the domain is correct.
 - [BZ 1371833](https://bugzilla.redhat.com/1371833) <b>OVF data upload to disk fails because of ClassCastException</b><br>

##### Team: UX

 - [BZ 1368101](https://bugzilla.redhat.com/1368101) <b>RHV-M Web UI performance degrades over time</b><br>
 - [BZ 1391013](https://bugzilla.redhat.com/1391013) <b>UX: exception when trying to sort by size (images listed from a Glance image repository)</b><br>
 - [BZ 1399610](https://bugzilla.redhat.com/1399610) <b>pinning VM to host setting doesn't persist</b><br>
 - [BZ 1344428](https://bugzilla.redhat.com/1344428) <b>[scale] The Dashboard takes a long time to load on a medium scale system (39 Hosts/3K VMs)</b><br>
 - [BZ 1349877](https://bugzilla.redhat.com/1349877) <b>Clicking on "feedback" button opens a 404 page</b><br>
 - [BZ 1375646](https://bugzilla.redhat.com/1375646) <b>cannot edit host: Uncaught exception occurred</b><br>
 - [BZ 1389549](https://bugzilla.redhat.com/1389549) <b>UX help button for iSCSI Multipathing broken</b><br>
 - [BZ 1396915](https://bugzilla.redhat.com/1396915) <b>[UI] - Tooltips in the SetupNetworks dialog show HTML instead of text and images</b><br>
 - [BZ 1346817](https://bugzilla.redhat.com/1346817) <b>[ALL LANG] 'New' and 'Import' buttons of 'Networks' tab are overlapping in resized browser window</b><br>
 - [BZ 1362412](https://bugzilla.redhat.com/1362412) <b>dashboard: don't show starting-up VMs as warning</b><br>
 - [BZ 1404674](https://bugzilla.redhat.com/1404674) <b>[engine-webadmin] 'Use Host' drop down is not highlighted when committing storage domain creation for a DC with no active hosts</b><br>
 - [BZ 1367072](https://bugzilla.redhat.com/1367072) <b>tags are not removed properly from filters when deactivated</b><br>
 - [BZ 1396512](https://bugzilla.redhat.com/1396512) <b>Guide Me tooltip for 'Configure Storage' has an extra preceding comma</b><br>
 - [BZ 1396517](https://bugzilla.redhat.com/1396517) <b>Undismisable tooltip after Guide Me menu</b><br>
 - [BZ 1378935](https://bugzilla.redhat.com/1378935) <b>[tracker] oVirt UI / Internet Explorer performance improvements</b><br>
 - [BZ 1396483](https://bugzilla.redhat.com/1396483) <b>Remove INFO message about context-sensitive help missing</b><br>
 - [BZ 1390271](https://bugzilla.redhat.com/1390271) <b>in few of ui dialogs the fields position is pushed down or cut after replacing to the new list boxes</b><br>
 - [BZ 1390242](https://bugzilla.redhat.com/1390242) <b>an event is not raised as required in case of choosing an empty/null entry in the new list boxes</b><br>
 - [BZ 1379312](https://bugzilla.redhat.com/1379312) <b>Closing a remove dialog with ESC causes a UI exception to be thrown</b><br>

##### Team: Virt

 - [BZ 1411739](https://bugzilla.redhat.com/1411739) <b>UI shows running vm on host though vm status on vdsm is down</b><br>
 - [BZ 1400642](https://bugzilla.redhat.com/1400642) <b>order VMs by Network doesn't work</b><br>
 - [BZ 1406749](https://bugzilla.redhat.com/1406749) <b>Starting a VM that has memory equal to the max memory raising QEMU error</b><br>
 - [BZ 1409579](https://bugzilla.redhat.com/1409579) <b>cluster compatibility version upgrade fails if there's a template in the cluster</b><br>
 - [BZ 1387699](https://bugzilla.redhat.com/1387699) <b>Sysprep floppy is unable to install Windows 10</b><br>
 - [BZ 1382746](https://bugzilla.redhat.com/1382746) <b>Upgrade from 3.6 to 4.0 fails on 04_00_0140_convert_memory_snapshots_to_disks.sql</b><br>
 - [BZ 1377827](https://bugzilla.redhat.com/1377827) <b>VM with next run snapshot can't be edited</b><br>
 - [BZ 1374216](https://bugzilla.redhat.com/1374216) <b>engine doesn't accept RNG sources other than random and hwrng</b><br>
 - [BZ 1367023](https://bugzilla.redhat.com/1367023) <b>Power-off takes too long</b><br>
 - [BZ 1380198](https://bugzilla.redhat.com/1380198) <b>vms tab under hosts tab showing 0 statistics.</b><br>
 - [BZ 1367405](https://bugzilla.redhat.com/1367405) <b>Cannot set custom compatibility version via UI</b><br>
 - [BZ 1359883](https://bugzilla.redhat.com/1359883) <b>[API v4] When there are no hosts available in cluster addVmPool fails with NullPointerException</b><br>
 - [BZ 1364494](https://bugzilla.redhat.com/1364494) <b>FE exception when Containers subtab selected</b><br>
 - [BZ 1367411](https://bugzilla.redhat.com/1367411) <b>[API] Setting custom compatibility version with bad values produces a general exception</b><br>
 - [BZ 1378034](https://bugzilla.redhat.com/1378034) <b>Import a template from an export domain - dialogue has no name</b><br>
 - [BZ 1363813](https://bugzilla.redhat.com/1363813) <b>Line way too long in engine.log</b><br>
 - [BZ 1366022](https://bugzilla.redhat.com/1366022) <b>List of VM names leaking out of confirmation dialog in Host subtab "Virtual Machines"</b><br>
 - [BZ 1346283](https://bugzilla.redhat.com/1346283) <b>Improve 'Map control-alt-del' label text</b><br>
 - [BZ 1373475](https://bugzilla.redhat.com/1373475) <b>UI error occurs when migrating VM</b><br>
 - [BZ 1364466](https://bugzilla.redhat.com/1364466) <b>Wrong hash-name of VM > Containers subtab</b><br>
 - [BZ 1356492](https://bugzilla.redhat.com/1356492) <b>ui: source column is not needed in Pools "Disk Allocation" in edit vm pool</b><br>
 - [BZ 1395602](https://bugzilla.redhat.com/1395602) <b>[UI] - VM Pool <UNKNOWN> was removed by admin@internal-authz.</b><br>
 - [BZ 1408691](https://bugzilla.redhat.com/1408691) <b>Number of monitors is not updated after reboot</b><br>
 - [BZ 1408599](https://bugzilla.redhat.com/1408599) <b>Cannot allocate a prestarted vm from a pool as user with permissions via API</b><br>
 - [BZ 1391016](https://bugzilla.redhat.com/1391016) <b>[User Portal] When creating template in User Portal one can use Custom Properties</b><br>
 - [BZ 1410475](https://bugzilla.redhat.com/1410475) <b>No way to set custom migration bandwidth using webadmin</b><br>
 - [BZ 1408577](https://bugzilla.redhat.com/1408577) <b>Update vm pool via REST API fails because vm.vmStatic.maxMemorySizeMb is None</b><br>
 - [BZ 1404400](https://bugzilla.redhat.com/1404400) <b>virt-v2v fails to convert a vm from vmware to rhev if the disk name has a space.</b><br>
 - [BZ 1406304](https://bugzilla.redhat.com/1406304) <b>V2V import fails on vm entity validation because vm.vmStatic.maxMemorySizeMb is None</b><br>
 - [BZ 1384585](https://bugzilla.redhat.com/1384585) <b>virt-v2v REST api: externalvmimports link is missing</b><br>
 - [BZ 1366507](https://bugzilla.redhat.com/1366507) <b>[RFE] Enable virtio-scsi dataplane for el7.3</b><br>
 - [BZ 1343870](https://bugzilla.redhat.com/1343870) <b>cannot remove host device placeholder when removing whole group</b><br>
 - [BZ 1392209](https://bugzilla.redhat.com/1392209) <b>VM statistics always show zero consumption via REST API</b><br>
 - [BZ 1391155](https://bugzilla.redhat.com/1391155) <b>Memory hotplug is not working</b><br>
 - [BZ 1389996](https://bugzilla.redhat.com/1389996) <b>It's impossible to suspend VM</b><br>
 - [BZ 1368817](https://bugzilla.redhat.com/1368817) <b>NPE on detection of unmanaged VM</b><br>
 - [BZ 1351208](https://bugzilla.redhat.com/1351208) <b>the hotpluggable fields are checked only if there are some which are not hotpluggable</b><br>
 - [BZ 1349321](https://bugzilla.redhat.com/1349321) <b>[RFE] Implement option for adding XEN as external providers</b><br>User can save a provider for external Xen on Rhel connection in the providers tree sections.<br>When user will try to import a VM from Xen on Rhel to oVirt environment it will easily access to the saved provider address instead of re-entering the address.
 - [BZ 1348107](https://bugzilla.redhat.com/1348107) <b>[RFE] Implement option for adding KVM as external providers</b><br>User can save a provider for external libvirt connection in the providers tree sections.<br>When user will try to import a VM from libvirt+kvm to oVirt environment it will easily access to the saved provider address instead of re-entering the address.

#### oVirt Host Deploy

##### Team: Gluster

 - [BZ 1380739](https://bugzilla.redhat.com/1380739) <b>virtual-host to be default tuned profile when cluster has both virt+gluster enabled.</b><br>

##### Team: Integration

 - [BZ 1371530](https://bugzilla.redhat.com/1371530) <b>[RFE][Metrics Store] Install Collectd and fluentd with relevant plugins</b><br>

#### OTOPI

##### Team: Integration

 - [BZ 1401962](https://bugzilla.redhat.com/1401962) <b>otopi fails not nicely on python < 2.7</b><br>
 - [BZ 1365776](https://bugzilla.redhat.com/1365776) <b>otopi fails with python3 due to uninitialized variable 'm'</b><br>
 - [BZ 1365751](https://bugzilla.redhat.com/1365751) <b>force_fail plugin fails with python3</b><br>
 - [BZ 1361888](https://bugzilla.redhat.com/1361888) <b>[FC24] otopi fails on fedora 24 with 'Aborted (core dumped)'</b><br>

#### VDSM JSON-RPC Java

##### Team: Infra

 - [BZ 1393714](https://bugzilla.redhat.com/1393714) <b>Servers state isn't stable and they changing state to non-responsive every few minutes, if one host in the DC is non-responsive with the engine</b><br>
 - [BZ 1412092](https://bugzilla.redhat.com/1412092) <b>Hosts moving to connecting state if one of the servers in the DC is in non-responsive state</b><br>
 - [BZ 1360181](https://bugzilla.redhat.com/1360181) <b>[RFE] vdsm-jsonrpc-java: usage of java 1.8</b><br>
 - [BZ 1387949](https://bugzilla.redhat.com/1387949) <b>Engine commands stuck on hosts with: Unrecognized protocol: 'SUBSCRI'.</b><br>

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1389382](https://bugzilla.redhat.com/1389382) <b>Storage in Global utilization shows 0.0 Available of 0 TiB but sparkline shows values greater than 0</b><br>
 - [BZ 1372667](https://bugzilla.redhat.com/1372667) <b>Dashboard: top utilized - memory/storage - number - used value overlapping to graph</b><br>

#### VDSM

##### Team: Gluster

 - [BZ 1409052](https://bugzilla.redhat.com/1409052) <b>Values for space used and capacity columns for gluster volumes are displayed incorrectly</b><br>
 - [BZ 1367817](https://bugzilla.redhat.com/1367817) <b>Help for vdsClient for glusterVolumehealInfo has unreadable formatting</b><br>

##### Team: Infra

 - [BZ 1372093](https://bugzilla.redhat.com/1372093) <b>vdsm sos plugin should collect 'nodectl info' output</b><br>
 - [BZ 1392784](https://bugzilla.redhat.com/1392784) <b>Enable metrics by default</b><br>
 - [BZ 1410224](https://bugzilla.redhat.com/1410224) <b>add vdsm-client script</b><br>
 - [BZ 1365007](https://bugzilla.redhat.com/1365007) <b>[RFE] dump_volume_chains: migrate to jsonrpcvdscli</b><br>

##### Team: Network

 - [BZ 1396996](https://bugzilla.redhat.com/1396996) <b>Update vNIC profile on running VM failed when try to change the network profile</b><br>
 - [BZ 1349391](https://bugzilla.redhat.com/1349391) <b>Remove all reference of the vintage ovirt-node code from master - network</b><br>
 - [BZ 1379115](https://bugzilla.redhat.com/1379115) <b>[OVS] Use Linux bonds with OVS networks (instead of OVS Bonds)</b><br>

##### Team: SLA

 - [BZ 1392957](https://bugzilla.redhat.com/1392957) <b>[RFE] Report status of hosted engine deployment in getVdsCapabilities call</b><br>
 - [BZ 1409112](https://bugzilla.redhat.com/1409112) <b>After backup-restore operation HE storage domain stuck in the 'Locked' state</b><br>

##### Team: Storage

 - [BZ 1405817](https://bugzilla.redhat.com/1405817) <b>Remove snapshot fail to GetVolumeInfoVDS, error = (-227, 'Unable to read resource owners', 'Sanlock exception'), code = 100</b><br>
 - [BZ 1408977](https://bugzilla.redhat.com/1408977) <b>Failed to cold merge snapshot on Command 'PrepareMerge' ended with failure code = 100</b><br>
 - [BZ 1399493](https://bugzilla.redhat.com/1399493) <b>Configure local storage domain format V4 fails</b><br>
 - [BZ 1410428](https://bugzilla.redhat.com/1410428) <b>Failure to cold-merge a in-between snapshot</b><br>
 - [BZ 1413918](https://bugzilla.redhat.com/1413918) <b>Cold Merge Fixes</b><br>
 - [BZ 1408143](https://bugzilla.redhat.com/1408143) <b>Failure to amend a volume will cause the volume to become illegal</b><br>
 - [BZ 1410182](https://bugzilla.redhat.com/1410182) <b>getVGInfo - report of free/used extents on each device</b><br>
 - [BZ 1409380](https://bugzilla.redhat.com/1409380) <b>storage: update volume attributes on any host</b><br>
 - [BZ 1408307](https://bugzilla.redhat.com/1408307) <b>Temporary file descriptor leak after running storage job</b><br>
 - [BZ 1405938](https://bugzilla.redhat.com/1405938) <b>volumes will become illegal on failure for modules which use jobs and are based on the CopyDataDivEndpoint logic</b><br>
 - [BZ 1400707](https://bugzilla.redhat.com/1400707) <b>Live merge failed on "timeout which can be caused by communication issues"</b><br>
 - [BZ 1393458](https://bugzilla.redhat.com/1393458) <b>Error in slot allocation when adding a new disk volume</b><br>

##### Team: Virt

 - [BZ 1398572](https://bugzilla.redhat.com/1398572) <b>hostdev listing takes large amount of time</b><br>
 - [BZ 1396910](https://bugzilla.redhat.com/1396910) <b>Numa sampling causes very high load on the hypervisor.</b><br>Numa sampling could previously cause unnecessarily high load on complex host. We therefore reduced the sample interval to 10 minutes as that is enough for rarely-changing NUMA topology.
 - [BZ 1396816](https://bugzilla.redhat.com/1396816) <b>Internal server error, @ Global.getAllVmStats -  argument type error</b><br>
 - [BZ 1382578](https://bugzilla.redhat.com/1382578) <b>Periodic functions may continue running after VM is down.</b><br>Previously, if a VM shutdown was too slow, the state of the said VM could have been misreported as unresponsive, even though the VM was operating correctly, albeit too slowly.<br>This was caused by a too aggressive checking on startup and shutdown. The patch takes in account slowdowns in startup and shutdown, avoiding false positive reports.
 - [BZ 1382583](https://bugzilla.redhat.com/1382583) <b>Periodic functions/monitor start before VM is run.</b><br>Previously, if a VM shutdown was too slow, the state of the said VM could have been misreported as unresponsive, even though the VM was operating correctly, albeit too slowly.<br>This was caused by a too aggressive checking on startup and shutdown. The patch takes in account slowdowns in startup and shutdown, avoiding false positive reports.
 - [BZ 1361028](https://bugzilla.redhat.com/1361028) <b>VMs flip to non-responsive state for ever.</b><br>A bug in the monitoring code made Vdsm failed to detect the event which means that a stuck QEMU process recovered and it is responsive again.
 - [BZ 1405058](https://bugzilla.redhat.com/1405058) <b>Import KVM guest image: loading available VMs to import failed if one of the KVM storage pools is inaccessible.</b><br>
 - [BZ 1378340](https://bugzilla.redhat.com/1378340) <b>v2v: Extended support for block device</b><br>
 - [BZ 1400168](https://bugzilla.redhat.com/1400168) <b>ChangeCD fails when running a vm with q35 emulated machine</b><br>
 - [BZ 1388596](https://bugzilla.redhat.com/1388596) <b>Virt-v2v is failing with python error when importing VM from KVM</b><br>
 - [BZ 1347669](https://bugzilla.redhat.com/1347669) <b>Add /dev/urandom as entropy source for virtio-rng</b><br>/dev/urandom is another linux backend to randomness pool. Unlike /dev/random, it does not block when entropy estimation falls below certain threshold. That doesn't mean data provided by /dev/urandom are cryptographically flawed, rather that they are older than the ones provided by /dev/random.<br><br>We therefore provide /dev/urandom as RNG for virtual machines for the benefit of lower possibility of being blocked by rate limiting functionality of /dev/random.
 - [BZ 1357798](https://bugzilla.redhat.com/1357798) <b>VMs are not reported as non-responding even though  qemu process does not responds.</b><br>Due to a bug in the monitoring code, unresponsive QEMU processes were misreported responsive, while they were not.<br>This bug made Vdsm wrongly report that the QEMU process recovered and was responsive again after a short amonunt of time, while it was actually still unresponsive.
 - [BZ 1409834](https://bugzilla.redhat.com/1409834) <b>Exception on VDSM after host becomes non-responsive</b><br>
 - [BZ 1371843](https://bugzilla.redhat.com/1371843) <b>Improve OVA import compatibility</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1410501](https://bugzilla.redhat.com/1410501) <b>If an engine API call got stuck, ovirt-hosted-engine-setup will wait forever</b><br>The API call can get lost due to the restart of the firewall by host-deploy: add a timeout and eventually retry
 - [BZ 1370041](https://bugzilla.redhat.com/1370041) <b>[Text] The HE upgrade tool should point users at the upgrade helper</b><br>
 - [BZ 1402417](https://bugzilla.redhat.com/1402417) <b>Mount options are lost when storage is imported to the engine, please block it from the setup.</b><br>
 - [BZ 1376114](https://bugzilla.redhat.com/1376114) <b>[TEXT][HE] Warn on addition of new HE host via host-deploy</b><br>
 - [BZ 1352384](https://bugzilla.redhat.com/1352384) <b>Creating the DB on hosted engine takes more than 600 seconds - increase timeout to half an hour to compensate for slow network/storage</b><br>
 - [BZ 1411318](https://bugzilla.redhat.com/1411318) <b>Fail to deploy host with spice/qxl</b><br>
 - [BZ 1406415](https://bugzilla.redhat.com/1406415) <b>HE deployment allows input of two MAC addresses at once for the engine.</b><br>
 - [BZ 1379674](https://bugzilla.redhat.com/1379674) <b>urllib2 is not in python3</b><br>
 - [BZ 1377851](https://bugzilla.redhat.com/1377851) <b>[TEXT] hosted-engine --deploy requires gluster-server should be glusterfs-server</b><br>packaging: gluster: fix a typo in packages plugin Fixed gluster-server -> glusterfs-server typo.
 - [BZ 1340912](https://bugzilla.redhat.com/1340912) <b>Hosted-engine-setup accepts /root as a valid alternative scratch dir but then fails since it's not readable by VDSM user</b><br>
 - [BZ 1405065](https://bugzilla.redhat.com/1405065) <b>upgrade-appliance: prevent any flow different than 3.6/el6 -> 4.0/el7</b><br>
 - [BZ 1403854](https://bugzilla.redhat.com/1403854) <b>Failed to "hosted-engine --upgrade-appliance" with Failed to execute stage 'Setup validation': 'OVEHOSTED_NETWORK/fqdnReverseValidation' error.</b><br>

##### Team: Storage

 - [BZ 1397305](https://bugzilla.redhat.com/1397305) <b>[hosted-engine-setup] Deployment is broken for FC: "Failed to execute stage 'Environment customization': 'Plugin' object has no attribute '_customize_mnt_options'"</b><br>

#### oVirt Hosted Engine HA

##### Team: Integration

 - [BZ 1374317](https://bugzilla.redhat.com/1374317) <b>Logging: improve error when cannot extract HEVM OVF</b><br>

##### Team: SLA

 - [BZ 1411783](https://bugzilla.redhat.com/1411783) <b>Update of the HE VM does not work</b><br>
 - [BZ 1368027](https://bugzilla.redhat.com/1368027) <b>Hosted Engine VM needs RNG for entropy</b><br>
 - [BZ 1392957](https://bugzilla.redhat.com/1392957) <b>[RFE] Report status of hosted engine deployment in getVdsCapabilities call</b><br>

#### oVirt Engine SDK 4 Ruby

##### Team: Infra

 - [BZ 1370464](https://bugzilla.redhat.com/1370464) <b>Ruby-SDK: Enable HTTP compression by default</b><br>
 - [BZ 1387951](https://bugzilla.redhat.com/1387951) <b>Disk Issues via API and SDK</b><br>

#### imgbased

##### Team: Node

 - [BZ 1408748](https://bugzilla.redhat.com/1408748) <b>[RHVH 4.1]Miss new build boot entry after upgrade to rhvh-4.1-0.20161222.0</b><br>
 - [BZ 1392904](https://bugzilla.redhat.com/1392904) <b>Unable to v2v Vmware ESX guests due supermin issue</b><br>
 - [BZ 1376607](https://bugzilla.redhat.com/1376607) <b>[RFE] Improve error message in case that the layout is already initialized</b><br>
 - [BZ 1376042](https://bugzilla.redhat.com/1376042) <b>New base layers do not have enough available space for hosted engine setup</b><br>
 - [BZ 1364042](https://bugzilla.redhat.com/1364042) <b>Command "imgbase layout" fail when login with non-root account.</b><br>
 - [BZ 1378092](https://bugzilla.redhat.com/1378092) <b>Do not change /etc/motd</b><br>
 - [BZ 1412056](https://bugzilla.redhat.com/1412056) <b>The format of error message is inaccurate when no thin pool</b><br>
 - [BZ 1412094](https://bugzilla.redhat.com/1412094) <b>The format of error message is inaccurate when using imgbase layout --init after installation finished</b><br>

#### oVirt Engine SDK 4 Java

##### Team: Infra

 - [BZ 1370485](https://bugzilla.redhat.com/1370485) <b>Java-SDK: Enable HTTP compression by default</b><br>SDK by default ask the server to send compressed responses.

#### oVirt Engine SDK 4 Python

##### Team: Infra

 - [BZ 1367826](https://bugzilla.redhat.com/1367826) <b>[scale] - Python SDK: Enable HTTP compression by default</b><br>SDK by default ask the server to send compressed responses.

## Bug fixes

### oVirt image transfer daemon and proxy

#### Team: Integration

 - [BZ 1263785](https://bugzilla.redhat.com/1263785) <b>Remove constants duplication in ovirt-engine-dwh and ovirt-engine-setup</b><br>

### oVirt Engine

#### Team: Gluster

 - [BZ 1296786](https://bugzilla.redhat.com/1296786) <b>Gluster: Tooltip for brick "Down" status shows the text "Up"</b><br>
 - [BZ 1269132](https://bugzilla.redhat.com/1269132) <b>[ALL_LANG] Unlocalized warning messages on volume->geo replication->add pane.</b><br>

#### Team: Infra

 - [BZ 1372320](https://bugzilla.redhat.com/1372320) <b>"Started - Finished" Messages in the audit log without any information</b><br>
 - [BZ 1366205](https://bugzilla.redhat.com/1366205) <b>[Admin Portal] Disable removal of system permissions from built-in 'Everyone' group</b><br>
 - [BZ 1320774](https://bugzilla.redhat.com/1320774) <b>[RFE] Add support to specify metadata on column to be able to use comma separated list of values during search</b><br>

#### Team: Integration

 - [BZ 1263785](https://bugzilla.redhat.com/1263785) <b>Remove constants duplication in ovirt-engine-dwh and ovirt-engine-setup</b><br>

#### Team: Network

 - [BZ 1406337](https://bugzilla.redhat.com/1406337) <b>[REST-API] set 'migratable' not working</b><br>
 - [BZ 1395462](https://bugzilla.redhat.com/1395462) <b>[Vm Pool] VMs are created with duplicate MAC addresses</b><br>
 - [BZ 1315878](https://bugzilla.redhat.com/1315878) <b>NICs are presented to the VM in alphabetical ordering (so with 10 NICs and more - nic1, nic10, nic2 ... whereas you'd expect nic1, nic2, ...) - need to natural order them</b><br>
 - [BZ 1294354](https://bugzilla.redhat.com/1294354) <b>[Text] - Improve the format of the error message for detaching networks that are in use by VMs from SetupNetwork</b><br>
 - [BZ 1279771](https://bugzilla.redhat.com/1279771) <b>[Host QoS] - Updating/changing value/s on the Host QoS entity via DC while a network that using this entity and attached to server doesn't invoke sync</b><br>
 - [BZ 1324482](https://bugzilla.redhat.com/1324482) <b>[Text] - Improve error message for 'network attachment not exist entity' for updating and removing network</b><br>
 - [BZ 1260491](https://bugzilla.redhat.com/1260491) <b>Cell table widget column header 'Allow All' is missing and not working under [Networks] > 'Import' > 'Networks to import' > no 'Allow All' header</b><br>
 - [BZ 1255257](https://bugzilla.redhat.com/1255257) <b>[ja_JP] [Admin Portal]: The alignment needs to be adjusted on data center->logical networks->new->vNIC profile page.</b><br>

#### Team: SLA

 - [BZ 1410431](https://bugzilla.redhat.com/1410431) <b>HE VM update via webadmin does not work</b><br>
 - [BZ 1297210](https://bugzilla.redhat.com/1297210) <b>[quota] Quota field is mandatory for disk creation for storage domain that doesn't have quota rule while quota is configured for specific domains in the DC</b><br>
 - [BZ 1350230](https://bugzilla.redhat.com/1350230) <b>Define to long name to the affinity label raise exception under engine.log</b><br>
 - [BZ 1291064](https://bugzilla.redhat.com/1291064) <b>Change vm memory and cpu number not update automatically VNUMA nodes memory and cpu number</b><br>
 - [BZ 1404249](https://bugzilla.redhat.com/1404249) <b>VM host pinning disappears</b><br>
 - [BZ 1147858](https://bugzilla.redhat.com/1147858) <b>Numa nodes icons is down, also when vm up</b><br>
 - [BZ 1363951](https://bugzilla.redhat.com/1363951) <b>Mouseover on hosted engine "crown" icon, is not showing correct tooltip description.</b><br>
 - [BZ 1287540](https://bugzilla.redhat.com/1287540) <b>[Admin Portal] List of problematic clusters missing in operation failure dialog (edit DC - bump up compat level)</b><br>
 - [BZ 1301353](https://bugzilla.redhat.com/1301353) <b>memory overcommit accepts negative values and sets them to 200%</b><br>
 - [BZ 1369046](https://bugzilla.redhat.com/1369046) <b>User can't assign CPU profile after upgrade from 3.6 to 4.0</b><br>
 - [BZ 1326512](https://bugzilla.redhat.com/1326512) <b>Consolidation of VM and VDS "Editable" Annotations</b><br>

#### Team: Storage

 - [BZ 1305011](https://bugzilla.redhat.com/1305011) <b>Sorting of LUNs doesn't work</b><br>
 - [BZ 1306110](https://bugzilla.redhat.com/1306110) <b>New / Edit Domain "Use Host" is misleading for translators</b><br>
 - [BZ 1186817](https://bugzilla.redhat.com/1186817) <b>VM fails to start after changing IDE disk boot order</b><br>
 - [BZ 1279407](https://bugzilla.redhat.com/1279407) <b>[admin portal] When importing a VM, the default storage domain should have enough space to perform the import</b><br>
 - [BZ 1302562](https://bugzilla.redhat.com/1302562) <b>Add a popup notification when importing an image from an external provider, similar to the one we get when importing a VM from an export domain</b><br>
 - [BZ 1331335](https://bugzilla.redhat.com/1331335) <b>[engine-backend] An attempt to import an image back to the data domain while the original one has "_remove_me" in its ID fails on "java.lang.NumberFormatException"</b><br>
 - [BZ 1309212](https://bugzilla.redhat.com/1309212) <b>Allow changing DC type from local to shared and vice versa [if the SD types permit it]</b><br>

#### Team: UX

 - [BZ 1267259](https://bugzilla.redhat.com/1267259) <b>New/Edit Cluster dialog ui is inconsistent</b><br>
 - [BZ 1326513](https://bugzilla.redhat.com/1326513) <b>CSS overflow detection algorithms perform badly, are really slow</b><br>

#### Team: Virt

 - [BZ 1356767](https://bugzilla.redhat.com/1356767) <b>Special characters in VMware cluster and data center name should be handled correctly</b><br>
 - [BZ 1366786](https://bugzilla.redhat.com/1366786) <b>[InClusterUpgrade] Possible race condition with large amount of VMs in cluster</b><br>
 - [BZ 1375379](https://bugzilla.redhat.com/1375379) <b>VM names not updating on host side after being renamed from RHEV manager GUI.</b><br>
 - [BZ 1310553](https://bugzilla.redhat.com/1310553) <b>'change cd' (Forgein Menu) works only in SPICE and not in  VNC console and not at all from REST</b><br>
 - [BZ 1317584](https://bugzilla.redhat.com/1317584) <b>VM Maintenance reason popup not visible in admin portal</b><br>
 - [BZ 1293591](https://bugzilla.redhat.com/1293591) <b>v2v: external provider "test" button failed when using "any data center" value.</b><br>
 - [BZ 1303450](https://bugzilla.redhat.com/1303450) <b>[REST] Increasing the CPU sockets to a amount of CPU's that the host doesn't have, Shouldn't be possible via REST</b><br>
 - [BZ 1409246](https://bugzilla.redhat.com/1409246) <b>VM migration failing with "Returning backwards compatible migration error code"</b><br>
 - [BZ 1376339](https://bugzilla.redhat.com/1376339) <b>[UI] Impossible to create / attach disk after changing Template value</b><br>
 - [BZ 1390993](https://bugzilla.redhat.com/1390993) <b>[Admin Portal] disable user strick checking change is not remembered in UI</b><br>
 - [BZ 1323475](https://bugzilla.redhat.com/1323475) <b>Instance type Graphics protocol is not aligned with Video type</b><br>
 - [BZ 1327869](https://bugzilla.redhat.com/1327869) <b>an exception while trying to open a noVNC console for VM and FF is set to block popups</b><br>
 - [BZ 1326076](https://bugzilla.redhat.com/1326076) <b>Userportal extended: Guest Information subtab can't be accessed for pool VMs</b><br>

### oVirt Engine DWH

#### Team: Integration

 - [BZ 1332892](https://bugzilla.redhat.com/1332892) <b>Automatic provisioning of engine db keeps password in answer file if dwh is installed</b><br>
 - [BZ 1263785](https://bugzilla.redhat.com/1263785) <b>Remove constants duplication in ovirt-engine-dwh and ovirt-engine-setup</b><br>

### oVirt Setup Lib

#### Team: Integration

 - [BZ 1366270](https://bugzilla.redhat.com/1366270) <b>hosted-engine-setup (and cockpit) accepts host address with an underscore while the engine correctly refuses them</b><br>

### VDSM

#### Team: Infra

 - [BZ 1326940](https://bugzilla.redhat.com/1326940) <b>After ovirt-engine is restarted, hypervisors stop listening on 54321 until vdsm is restarted.</b><br>
 - [BZ 1403846](https://bugzilla.redhat.com/1403846) <b>Remove 3.6 from the supportedEngines reported by VDSM</b><br>

#### Team: Network

 - [BZ 1242532](https://bugzilla.redhat.com/1242532) <b>vdsm fails to start if one network fails to be restored</b><br>
 - [BZ 1141267](https://bugzilla.redhat.com/1141267) <b>do not silently ignore failure to read ifcfg files</b><br>

#### Team: Storage

 - [BZ 1308306](https://bugzilla.redhat.com/1308306) <b>iscsi: vdsm explicitly ignores ipv6 targets</b><br>
 - [BZ 1334274](https://bugzilla.redhat.com/1334274) <b>AttributeErrors from ioprocess during shutdown when vdsm tests finish</b><br>

#### Team: Virt

 - [BZ 1382404](https://bugzilla.redhat.com/1382404) <b>Importing VMs from VMware ova file fails with block storage domain and thin provisioned disk</b><br>
 - [BZ 1238536](https://bugzilla.redhat.com/1238536) <b>vdsm before_vm_hibernate hook failure leaves vm in the wrong state (paused)</b><br>
 - [BZ 1134974](https://bugzilla.redhat.com/1134974) <b>"Domain not found: no domain with matching uuid" error logged to audit_log after live migration fails due to timeout exceeded</b><br>
 - [BZ 1341106](https://bugzilla.redhat.com/1341106) <b>HA vms do not start after successful power-management.</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1313881](https://bugzilla.redhat.com/1313881) <b>[networking] Adapt to the lack of CFG property of NICS in VDSM netinfo</b><br>
 - [BZ 1366270](https://bugzilla.redhat.com/1366270) <b>hosted-engine-setup (and cockpit) accepts host address with an underscore while the engine correctly refuses them</b><br>

#### Team: SLA

 - [BZ 1301681](https://bugzilla.redhat.com/1301681) <b>[RFE] - Once HE deployed, it's not possible to change notifications settings later on shared storage.</b><br>

### oVirt Hosted Engine HA

#### Team: Integration

 - [BZ 1398443](https://bugzilla.redhat.com/1398443) <b>ovirt-ha-agent fails reading the HE vm configuration from the OVF_STORE due to a change in vdsm sudoers policy</b><br>

#### Team: SLA

 - [BZ 1301681](https://bugzilla.redhat.com/1301681) <b>[RFE] - Once HE deployed, it's not possible to change notifications settings later on shared storage.</b><br>
 - [BZ 1411319](https://bugzilla.redhat.com/1411319) <b>After successful migration of HE vm from host a to host b, immediately migrating back to host a fails with "Operation Canceled" from rhev manager portal.</b><br>

### oVirt Cockpit Plugin

#### Team: Node

 - [BZ 1379146](https://bugzilla.redhat.com/1379146) <b>HE install via CockPit cut the install text allow only a few dozen lines of history.</b><br>
 - [BZ 1334695](https://bugzilla.redhat.com/1334695) <b>HE paragraph needs margin for reduced size windows</b><br>

### imgbased

#### Team: Node

 - [BZ 1380797](https://bugzilla.redhat.com/1380797) <b>Node upgrade doesn't keep service enable/disable configuration</b><br>


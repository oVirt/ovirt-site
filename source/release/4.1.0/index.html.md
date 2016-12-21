---
title: oVirt 4.1.0 Release Notes
category: documentation
authors: sandrobonazzola
---

# oVirt 4.1.0 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.0
Second Beta as of December 21st, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3, CentOS Linux 7.3
(or similar).


Please note that new qemu / kvm features introduced in Red Hat Enterprise Linux 7.3
are not yet available on ppc64le since CentOS 7.3 has not been released at the time of
this BETA compose.

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

In order to install this BETA RELEASE you will need to enable pre-release repository.


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

#### oVirt Engine

##### Team: Integration

 - [BZ 1381223](https://bugzilla.redhat.com/1381223) <b>Retire ovirt-image-uploader</b><br>In 4.0 we deprecated ovirt-image-uplaoder in favor of ovirt-imageio.<br>In 4.1 we're going to retire ovirt-image-uploader.

### Enhancement

#### oVirt Release Package

##### Team: Integration

 - [BZ 1398321](https://bugzilla.redhat.com/1398321) <b>add back fedora 24 virt-preview repo</b><br>oVirt release now enables by default virt-preview repository on Fedora 24. For more information about the repository see its Fedora wiki page at https://fedoraproject.org/wiki/Virtualization_Preview_Repository
 - [BZ 1366118](https://bugzilla.redhat.com/1366118) <b>[RFE] Move GlusterFS repos to version 3.8</b><br>oVirt release now provides repository configuration files for enabling GlusterFS 3.8 repositories on Red Hat Enterprise Linux, CentOS Linux and similar.

#### oVirt Engine

##### Team: Infra

 - [BZ 1279378](https://bugzilla.redhat.com/1279378) <b>[RFE] Add manual execution of 'Check for upgrades' into webadmin and RESTAPI</b><br>A new menu item 'Check for Upgrade' has been added to Webadmin Installation menu. This can be used to trigger checking for upgrades on the host.<br><br>The check for upgrades can also be trigger by using rest api using the hosts upgradecheck endpoint.
 - [BZ 1381279](https://bugzilla.redhat.com/1381279) <b>[RFE] Rebase on  snmp4j-2.4.1</b><br>
 - [BZ 1286632](https://bugzilla.redhat.com/1286632) <b>[RFE] When editing fence agents, options displayed should be specific to that agent</b><br>Feature: <br>Adding a link to the add/edit fence agent form that points to an online help on the available parameters that can be sent toa fence agent<br><br>Reason: <br>Provide help for users to set correct fence agent parameters <br><br>Result: <br>The user can now click on the link in the add/edit fence agent form and see an online help on the available parameters
 - [BZ 1343562](https://bugzilla.redhat.com/1343562) <b>Updates should not be checked on hosts on maintenance</b><br>Feature: <br><br>Before this patch we checked for updates all hosts that were in status Up, Maintenance or NonOperational. Unfortunately hosts in status Maintenance may not be reachable, which caused unnecessary errors shown in Events. <br>So from now only hosts in status Up or NonOperational are being checked for upgrades.<br><br>Reason: <br><br>Result:
 - [BZ 1295678](https://bugzilla.redhat.com/1295678) <b>[RFE] better error messages for beanvalidation validation failures.</b><br>

##### Team: Integration

 - [BZ 1235200](https://bugzilla.redhat.com/1235200) <b>[RFE] Make it easier to remove hosts when restoring hosted-engine from backup</b><br>Restoring a backup of hosted-engine on a different environment for disaster recovery purposes could require to remove the previous hosts from the engine. Up to now there wasn't a clean way to do it without manually touching the engine DB with the related risks.<br>This enhancement introduces a CLI option to do it directly from engine-backup at restore time.
 - [BZ 1270719](https://bugzilla.redhat.com/1270719) <b>[RFE] Add an option to automatically accept defaults</b><br>Feature: <br><br>Add an option '--accept-defaults' to engine-setup, that makes it not prompt for answers, in questions that supply a default one, but instead accept the default.<br><br>Reason: <br><br>1. Save users from repeatedly pressing Enter if they already know that the defaults are good enough for them.<br><br>2. Lower the maintenance for other tools that want to run engine-setup unattended - if they use this option, they will not break when a question is added in the future, if this question has a default answer<br><br>Result: <br><br>See above.<br><br>Also see comment 12.
 - [BZ 1300947](https://bugzilla.redhat.com/1300947) <b>engine-backup user experience need to be improved</b><br>

##### Team: SLA

 - [BZ 1135976](https://bugzilla.redhat.com/1135976) <b>Edit pinned vm placement option clear vm cpu pinning options without any error message</b><br>Feature: <br>Added a dialog warning the user of loosing CPU pinning information when saving a VM.<br><br>Reason: <br>Previously, CPU pinning information was silently lost.<br><br>Result: <br>Now user gets notified if it will be lost, with a chance to cancel the operation.

##### Team: Storage

 - [BZ 1314387](https://bugzilla.redhat.com/1314387) <b>[RFE][Tracker] -  Provide streaming API for oVirt</b><br>Feature:<br>This feature adds the possibility to download ovirt images (E.g VM disks) using oVirt's API.
 - [BZ 1380365](https://bugzilla.redhat.com/1380365) <b>[RFE][HC] - allow forcing import of a VM from a storage domain, even if some of its disks are not accessible.</b><br>Feature: <br>Add the ability to import partial VM<br><br>Reason: <br>HCI DR solution is based on the concept that only data disks are replicated and system disks are not. Currently if some of the VM's disks are not replicated the import of the VM fails. Since some of the disks have snapshots, they can not be imported as floating disks.<br>To allow the DR to works we need to force import of a VM from a storage domain, even if some of its disks are not accessible.<br><br>Result: <br><br>Add the ability to import partial VMs only through REST.<br>The following is a REST request for importing a partial unregistered VM (Same goes for Template)<br><br>POST /api/storagedomains/xxxxxxx-xxxx-xxxx-xxxxxx/vms/xxxxxxx-xxxx-xxxx-xxxxxx/register HTTP/1.1<br>Accept: application/xml<br>Content-type: application/xml<br><br><action><br>    <cluster id='bf5a9e9e-5b52-4b0d-aeba-4ee4493f1072'></cluster><br>    <allow_partial_import>true</allow_partial_import><br></action>
 - [BZ 1241106](https://bugzilla.redhat.com/1241106) <b>[RFE] Allow TRIM from within the guest to shrink thin-provisioned disks on iSCSI and FC storage domains</b><br>A new property was added to virtual machines disks - "Pass Discard".<br><br>When true, and if all the restrictions [1] are met, discard commands (UNMAP SCSI commands) that are sent from the guest will not be ignored by qemu and will be passed on to the underlying storage.<br>Then, the reported unused blocks in the underlying storage thinly provisioned luns will be marked as free so that others can use them, and the reported consumed space of these luns will reduce.<br><br><br>[1] For more information, please refer to the feature page "Pass discard from guest to underlying storage" - http://www.ovirt.org/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage/
 - [BZ 1302185](https://bugzilla.redhat.com/1302185) <b>[RFE] Allow attaching shared storage domains to a local DC</b><br>Feature: <br>Allow attaching shared storage domains to a local DC<br><br>Reason: <br>With the ability to attach and detach a data domain (introduced in 3.5), data domains became a better option for moving VMs/Templates around than an export domain. In order to gain this ability in local DCs, it should be possible to attach a Storage Domain of a shared type to that DC.<br><br>Result: <br>The user will now have the ability to change an initialized Data Center type (Local vs Shared). The following updates will be available: <br>1. Shared to Local - Only for a Data Center that does not contain more than one Host and more than one cluster, since local Data Center does not support it. The engine should validate and block this operation with the following messages:<br><br>CLUSTER_CANNOT_ADD_MORE_THEN_ONE_HOST_TO_LOCAL_STORAGE<br>VDS_CANNOT_ADD_MORE_THEN_ONE_HOST_TO_LOCAL_STORAGE<br><br>2. Local to Shared - Only for a Data Center that does not contain a local Storage Domain. The engine should validate and block this operation with the following message ERROR_CANNOT_CHANGE_STORAGE_POOL_TYPE_WITH_LOCAL.

##### Team: UX

 - [BZ 1353556](https://bugzilla.redhat.com/1353556) <b>UX: login to the admin portal is going first to the VMs tab, then hops to the dashboard UI plugin</b><br>Feature: oVirt 4.0 introduced new "Dashboard" tab in WebAdmin UI. This tab is implemented via oVirt UI plugin (ovirt-engine-dashboard) and therefore loaded asynchronously.<br><br>Reason: When loading WebAdmin UI, user lands at "Virtual Machines" tab, followed by immediate switch to "Dashboard" tab. This hinders overall user experience, since the general intention is to have the user landing at "Dashboard" tab.<br><br>Result: Improved UI plugin infra to allow pre-loading UI plugins, such as ovirt-engine-dashboard. The end result is user landing directly at "Dashboard" tab (no intermediate switch to "Virtual Machines").

##### Team: Virt

 - [BZ 1344521](https://bugzilla.redhat.com/1344521) <b>[RFE] when GA data are missing, a warning should be shown in webadmin asking the user to install/start the GA</b><br>Feature: <br>Show a message, that the guest agent needs to be installed and running in the guest, in the hover text at the exclamation marks in the WebAdmin portal VM overview.<br><br>Reason: <br>Previously the information has been confusing if the guest agent wasn't running or was out of date, the hover text might have said that the operating system wasn't matching or the timezone configuration wasn't correct.
 - [BZ 1294629](https://bugzilla.redhat.com/1294629) <b>Improve loading external VMs speed</b><br>Feature: Improve the loading performance of external VMs from external server. Done for the following sources: VMware, KVM, Xen. <br><br>Reason: For displaying the lists of VMs to import in the first dialog, there is no need to ask libvirt for the full information per each VM and since it takes few seconds per VM, we can improve that by receiving the vm name only in that phase. <br><br>Result: displaying VMs names only in the 1st phase, i.e. in the 1st import dialog, and only when choosing the VMS to import and clicking on the "Next" button, then the full VMs data list is displayed on the 2nd dialog.
 - [BZ 1399142](https://bugzilla.redhat.com/1399142) <b>[RFE] Change disk default interface to virtio-scsi</b><br>Feature: Change default disk interface type from virtio-blk to virtio-scsi.<br><br>Reason: Motivate users to use better and more modern default for disk interfaces. (virtio-blk will still be supported)<br><br>Result: Now when creating or attaching a disk to VM the virtio-scsi interface type will be selected as default.
 - [BZ 1374227](https://bugzilla.redhat.com/1374227) <b>Add /dev/urandom as entropy source for virtio-rng</b><br>random number generator source '/dev/random' is no longer optional (checkbox in cluster dialogs was removed) and is required from all hosts.<br><br>random number generator (RNG) device was added to Blank template and predefined instance types. This means that new VMs will have RNG device by default.<br><br>Note: RNG device was not added to user-created instance types or templates (to avoid unexpected changes in behavior) so if user wants to have RNG device on new VMs that are created based on custom instance types or templates RNG device needs to be added to these instance types / templates manually.
 - [BZ 1161625](https://bugzilla.redhat.com/1161625) <b>[RFE] Expose creator of vm via api and/or gui</b><br>Feature: Search VMs on CREATED_BY_USER_ID <br><br>Reason: The user can query VMs on CREATED_BY_USER_ID (REST API).<br><br>Result: <br>The REST API search query is extended for:<br>  .../api/vms?search=created_by_user_id%3D[USER_ID]<br><br>The User ID can be retrieved i.e. by following REST call:<br>  .../api/users<br><br>Please note, the user might be removed from the system since the VM creation.<br><br>In addition, the Administration Portal shows the creators name (or login) in the VM General Subtab.
 - [BZ 1383342](https://bugzilla.redhat.com/1383342) <b>[RFE] API ticket support in graphics devices</b><br>Feature: Allow requesting console ticket for specific graphics device via REST API.<br><br>Reason: The existing endpoint /api/vms/{vmId}/ticket defaulted to SPICE in scenarios when SPICE+VNC was configured as the graphics protocol making it impossible to request a VNC ticket.<br><br>Result: A ticket action was added to the /api/vms/{vmId}/graphicsconsoles/{consoleId} resource making it possible to request ticket for specific console. Usage of this specific endpoints should be preferred from now on and the preexisting per-vm endpoint /api/vms/{vmId}/ticket should be considered deprecated.
 - [BZ 1333436](https://bugzilla.redhat.com/1333436) <b>[RFE] drop Legacy USB</b><br>Feature: Remove the deprecated Legacy USB support<br><br>Reason: It has been deprecated the last version, now dropping<br><br>Result: Currently, the USB can be either enabled or disabled. Previously it was enabled legacy, enabled native or disabled.
 - [BZ 1337101](https://bugzilla.redhat.com/1337101) <b>[RFE] enable virtio-rng /dev/urandom by default</b><br>random number generator source '/dev/random' is no longer optional (checkbox in cluster dialogs was removed) and is required from all hosts.<br><br>random number generator (RNG) device was added to Blank template and predefined instance types. This means that new VMs will have RNG device by default.<br><br>Note: RNG device was not added to user-created instance types or templates (to avoid unexpected changes in behavior) so if user wants to have RNG device on new VMs that are created based on custom instance types or templates RNG device needs to be added to these instance types / templates manually.
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

##### Team: Storage

 - [BZ 1241106](https://bugzilla.redhat.com/1241106) <b>[RFE] Allow TRIM from within the guest to shrink thin-provisioned disks on iSCSI and FC storage domains</b><br>A new property was added to virtual machines disks - "Pass Discard".<br><br>When true, and if all the restrictions [1] are met, discard commands (UNMAP SCSI commands) that are sent from the guest will not be ignored by qemu and will be passed on to the underlying storage.<br>Then, the reported unused blocks in the underlying storage thinly provisioned luns will be marked as free so that others can use them, and the reported consumed space of these luns will reduce.<br><br><br>[1] For more information, please refer to the feature page "Pass discard from guest to underlying storage" - http://www.ovirt.org/develop/release-management/features/storage/pass-discard-from-guest-to-underlying-storage/

##### Team: Virt

 - [BZ 1294629](https://bugzilla.redhat.com/1294629) <b>Improve loading external VMs speed</b><br>Feature: Improve the loading performance of external VMs from external server. Done for the following sources: VMware, KVM, Xen. <br><br>Reason: For displaying the lists of VMs to import in the first dialog, there is no need to ask libvirt for the full information per each VM and since it takes few seconds per VM, we can improve that by receiving the vm name only in that phase. <br><br>Result: displaying VMs names only in the 1st phase, i.e. in the 1st import dialog, and only when choosing the VMS to import and clicking on the "Next" button, then the full VMs data list is displayed on the 2nd dialog.
 - [BZ 1356161](https://bugzilla.redhat.com/1356161) <b>[RFE] prefer numa nodes close to host devices when using hostdev passthrough</b><br>This RFE is related to host devices and should be reflected in virtual machine management guide as a note (somewhere close to Procedure 6.15. Adding Host Devices to a Virtual Machine).<br><br>For some context, the feature tries to do best effort to implement https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7-Beta/html/Virtualization_Tuning_and_Optimization_Guide/sect-Virtualization_Tuning_Optimization_Guide-NUMA-NUMA_and_libvirt.html#sect-Virtualization_Tuning_Optimization_Guide-NUMA-Node_Locality_for_PCI<br><br>If the user does not specify any NUMA mapping himself, oVirt now tries to prefer NUMA node where device MMIO is. Main constraint is that we only *prefer* such node rather than strictly requiring memory from it. Implication is that the optimization may or may not be active depending on host's memory load AND only works as long as all assigned devices are from single NUMA node.
 - [BZ 1350465](https://bugzilla.redhat.com/1350465) <b>[RFE] Store detailed log of virt-v2v when importing VM</b><br>Feature:<br><br>Complete logs of the VM import with virt-v2v are now stored in /var/log/vdsm/import directory.<br><br>Reason: <br><br>When import of a VM fails it is usually necessary to have complete logs of virt-v2v to properly investigate the reason. The output of virt-v2v was not previously available and the import had to be reproduced manually. This not only prolongs the investigation of the issue, but replicating the VDSM environment for virt-v2v is also not completely straightforward.<br><br>Result: <br><br>Output of virt-v2v is now stored in directory /var/log/vdsm/import. All logs older than 30 days are automatically removed.
 - [BZ 1321010](https://bugzilla.redhat.com/1321010) <b>[RFE] use virtlogd as introduced in libvirt >= 1.3.0</b><br>
 - [BZ 1349907](https://bugzilla.redhat.com/1349907) <b>RFE: Guest agent hooks for hibernation should be always executed.</b><br>This feature will have the before_hibernation / after_hibernation hooks executed on the guest operating system (with the ovirt guest agent) always in case of suspending / resuming a Virtual Machine

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1349301](https://bugzilla.redhat.com/1349301) <b>[RFE] Successfully complete hosted engine setup without appliance pre-installed.</b><br>Feature: <br>Let the user install the appliance rpm directly from ovirt-hosted-engine-setup<br><br>Reason: <br>ovirt-hosted-engine-setup supports now only the appliance based flow<br><br>Result:<br>The user can install ovirt-egnine-appliance directly from ovirt-hosted-engine-setup
 - [BZ 1331858](https://bugzilla.redhat.com/1331858) <b>[RFE] Allow user to enable ssh access for RHEV-M appliance during hosted-engine deploy</b><br>Feature: <br>Let the user optionally enable ssh access for RHEV-M appliance during hosted-engine deploy.<br>The user can choose between yes, no and without-password.<br>The user can also pass a public ssh key for the root user at hosted-engine-setup time.
 - [BZ 1263602](https://bugzilla.redhat.com/1263602) <b>[RFE] Ability to set different mount options for hosted_engine nfs storage than the default</b><br>Feature: <br>To accomplish user needs and special scenarios, it should be possible to enter additional mount options for the hosted-engine storage domain as the user can do from the engine for regular storage domains.
 - [BZ 1366183](https://bugzilla.redhat.com/1366183) <b>[RFE] - Remove all bootstrap flows other than appliance and remove addition of additional hosts via CLI.</b><br>Having now the capability to deploy additional hosted-engine hosts from the engine with host-deploy, the capability to deploy additional hosted-engine hosts from hosted-engine setup is not required anymore. Removing it.<br>The engine-appliance has proved to be the easiest flow to have a working hosted-engine env; removing all other bootstrap flows.
 - [BZ 1300591](https://bugzilla.redhat.com/1300591) <b>[RFE] let the user customize the engine VM disk size also using the engine-appliance</b><br>Let the user customize the engine VM disk size also if he choose to use the engine-appliance.
 - [BZ 1365022](https://bugzilla.redhat.com/1365022) <b>[RFE] hosted-engine --deploy question ordering improvements</b><br>
 - [BZ 1318350](https://bugzilla.redhat.com/1318350) <b>[RFE] configure the timezone for the engine VM as the host one via cloudinit</b><br>Feature: Ask customer about NTP configuration inside the appliance<br><br>Reason: <br><br>Result:

#### oVirt Windows Guest Agent

##### Team: Integration

 - [BZ 1310621](https://bugzilla.redhat.com/1310621) <b>[RFE] oVirt Guest Tools name should include version in install apps list</b><br>

### No Doc Update

#### oVirt Engine

##### Team: SLA

 - [BZ 1346669](https://bugzilla.redhat.com/1346669) <b>Can't start a VM (NPE around scheduling.SchedulingManager.selectBestHost(SchedulingManager.java:434) )</b><br>undefined
 - [BZ 1377632](https://bugzilla.redhat.com/1377632) <b>Provide information in the logs about who and why the VM was migrated automatically by the system</b><br>undefined
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

#### oVirt Engine

##### Team: Gluster

 - [BZ 1365604](https://bugzilla.redhat.com/1365604) <b>Mouse hovering on the volume  does not display any tool tip</b><br>
 - [BZ 1386265](https://bugzilla.redhat.com/1386265) <b>Variable names are displayed in error dialog as against the actual values, when moving 2 of the nodes in the hc cluster to maintenance state</b><br>
 - [BZ 1379754](https://bugzilla.redhat.com/1379754) <b>Host can't be removed (FE exception)</b><br>

##### Team: Infra

 - [BZ 1393714](https://bugzilla.redhat.com/1393714) <b>Servers state isn't stable and they changing state to non-responsive every few minutes, if one host in the DC is non-responsive with the engine</b><br>
 - [BZ 1356560](https://bugzilla.redhat.com/1356560) <b>[scale] Getting user VMs from user portal is taking too long</b><br>
 - [BZ 1381419](https://bugzilla.redhat.com/1381419) <b>Events tab in UI displays updates available as "UNKNOWN" when there are no updates present for the node.</b><br>
 - [BZ 1390484](https://bugzilla.redhat.com/1390484) <b>Postgres DB overloads the CPU when specific bookmarks queries are triggered.</b><br>
 - [BZ 1388421](https://bugzilla.redhat.com/1388421) <b>Remove connection check before each query</b><br>
 - [BZ 1388117](https://bugzilla.redhat.com/1388117) <b>Hide tracebacks in engine.log when host is not responsive</b><br>
 - [BZ 1383224](https://bugzilla.redhat.com/1383224) <b>RHVH-NG is automatically activated after upgrade.</b><br>
 - [BZ 1383020](https://bugzilla.redhat.com/1383020) <b>Wrong cluster in "Edit host" dialog</b><br>
 - [BZ 1375668](https://bugzilla.redhat.com/1375668) <b>[REST API] href links  are missing under api/datacenters/<dc id>/networks</b><br>
 - [BZ 1373242](https://bugzilla.redhat.com/1373242) <b>serialization of command parameters allows serialization of immutable objects.</b><br>
 - [BZ 1371501](https://bugzilla.redhat.com/1371501) <b>changedbowner.sh script hangs and never finishes unless aborted</b><br>
 - [BZ 1368030](https://bugzilla.redhat.com/1368030) <b>Upgrade manager: log for failure is not well phrased: with message 'java.nio.channels.UnresolvedAddressException'."</b><br>
 - [BZ 1369413](https://bugzilla.redhat.com/1369413) <b>Add 3.6 host fails in rhv-m 3.6.8 from time to time and after few minutes it auto recovering and comes up</b><br>
 - [BZ 1362472](https://bugzilla.redhat.com/1362472) <b>[RFE] Remove dependency on fop and its transitive dependencies</b><br>
 - [BZ 1367438](https://bugzilla.redhat.com/1367438) <b>When failing on execute() when using COCO the end method is called before the child commands ends</b><br>
 - [BZ 1361511](https://bugzilla.redhat.com/1361511) <b>During host upgrade Upgrade process terminated info message shown</b><br>
 - [BZ 1347628](https://bugzilla.redhat.com/1347628) <b>[RFE] hystrix monitoring integration</b><br>

##### Team: Integration

 - [BZ 1354180](https://bugzilla.redhat.com/1354180) <b>[RFE] remove 'FIX_RELEASE=' from version.mak file</b><br>
 - [BZ 1351668](https://bugzilla.redhat.com/1351668) <b>Automatic provisioning of dwh db keeps password in answer file if engine is installed</b><br>
 - [BZ 1379354](https://bugzilla.redhat.com/1379354) <b>README: Maven-3 is written as "optional" and "required" at the Prerequisites section</b><br>

##### Team: Network

 - [BZ 1391130](https://bugzilla.redhat.com/1391130) <b>[UI] - The edit bond interface dialog window is broken once choosing the bonding mode 'Custom'</b><br>
 - [BZ 1362042](https://bugzilla.redhat.com/1362042) <b>Add provider window- the 'read only' checkbox should be 'read-only'.</b><br>
 - [BZ 1362401](https://bugzilla.redhat.com/1362401) <b>[OVS] [UI][RFE] - Add column to the 'Clusters' main tab that will indicate the cluster's switch type</b><br>

##### Team: Storage

 - [BZ 1394114](https://bugzilla.redhat.com/1394114) <b>Migration of HE Disk ends up in Locked State</b><br>
 - [BZ 1379771](https://bugzilla.redhat.com/1379771) <b>Introduce a 'force' flag for updating a storage server connection</b><br>In order to update a storage server connection regardless to the associated storage domain status (i.e. updating also when the domain is *not* in status Maintenance) - introduced a 'force' flag.<br><br>E.g. PUT /ovirt-engine/api/storageconnections/123?force
 - [BZ 1348405](https://bugzilla.redhat.com/1348405) <b>RHEV: limit number of images in an image chain (snapshots)</b><br>Problem: Due to the maximum path length in qemu, snapshots operations start to fail around the 98th image in the chain. the VM won't migrate/restart<br><br>Solution: Limit the number of snapshots per disk in the engine<br><br>Fix:<br>Introducing a new config value called MaxImagesInChain with a limit number of 90.<br>The limit includes all the image chain, the active volume and the image's snapshots.<br>For example if a disk will have 89 snapshots, the next snapshot that will be created will be blocked by a CDA.<br><br>Other related operations which uses snapshots like live migrate disk or running a stateless VM will also apply to the same limitation to avoid failure
 - [BZ 1367399](https://bugzilla.redhat.com/1367399) <b>[RFE] add the option to set spm priority to Never in engine GUI</b><br>
 - [BZ 1353134](https://bugzilla.redhat.com/1353134) <b>Reconstructing master should prefer shared domains over local domains</b><br>
 - [BZ 1353137](https://bugzilla.redhat.com/1353137) <b>Memory volume placement should prefer shared to local domains</b><br>
 - [BZ 1357882](https://bugzilla.redhat.com/1357882) <b>Sort the 'Use Host' list alphabetically in the add Direct Lun dialog</b><br>
 - [BZ 1390072](https://bugzilla.redhat.com/1390072) <b>Stopping a stateless VM does not erase state snapshot</b><br>
 - [BZ 1370167](https://bugzilla.redhat.com/1370167) <b>row with 'Used by' checkboxes has left-margin in Storage section</b><br>
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
 - [BZ 1375646](https://bugzilla.redhat.com/1375646) <b>cannot edit host: Uncaught exception occurred</b><br>
 - [BZ 1344428](https://bugzilla.redhat.com/1344428) <b>[scale] The Dashboard takes a long time to load on a medium scale system (39 Hosts/3K VMs)</b><br>
 - [BZ 1396915](https://bugzilla.redhat.com/1396915) <b>[UI] - Tooltips in the SetupNetworks dialog show HTML instead of text and images</b><br>
 - [BZ 1346817](https://bugzilla.redhat.com/1346817) <b>[ALL LANG] 'New' and 'Import' buttons of 'Networks' tab are overlapping in resized browser window</b><br>
 - [BZ 1396483](https://bugzilla.redhat.com/1396483) <b>Remove INFO message about context-sensitive help missing</b><br>
 - [BZ 1390271](https://bugzilla.redhat.com/1390271) <b>in few of ui dialogs the fields position is pushed down or cut after replacing to the new list boxes</b><br>
 - [BZ 1390242](https://bugzilla.redhat.com/1390242) <b>an event is not raised as required in case of choosing an empty/null entry in the new list boxes</b><br>
 - [BZ 1379312](https://bugzilla.redhat.com/1379312) <b>Closing a remove dialog with ESC causes a UI exception to be thrown</b><br>

##### Team: Virt

 - [BZ 1382746](https://bugzilla.redhat.com/1382746) <b>Upgrade from 3.6 to 4.0 fails on 04_00_0140_convert_memory_snapshots_to_disks.sql</b><br>
 - [BZ 1377827](https://bugzilla.redhat.com/1377827) <b>VM with next run snapshot can't be edited</b><br>
 - [BZ 1374216](https://bugzilla.redhat.com/1374216) <b>engine doesn't accept RNG sources other than random and hwrng</b><br>
 - [BZ 1380198](https://bugzilla.redhat.com/1380198) <b>vms tab under hosts tab showing 0 statistics.</b><br>
 - [BZ 1367405](https://bugzilla.redhat.com/1367405) <b>Cannot set custom compatibility version via UI</b><br>
 - [BZ 1359883](https://bugzilla.redhat.com/1359883) <b>[API v4] When there are no hosts available in cluster addVmPool fails with NullPointerException</b><br>
 - [BZ 1364494](https://bugzilla.redhat.com/1364494) <b>FE exception when Containers subtab selected</b><br>
 - [BZ 1363813](https://bugzilla.redhat.com/1363813) <b>Line way too long in engine.log</b><br>
 - [BZ 1366022](https://bugzilla.redhat.com/1366022) <b>List of VM names leaking out of confirmation dialog in Host subtab "Virtual Machines"</b><br>
 - [BZ 1346283](https://bugzilla.redhat.com/1346283) <b>Improve 'Map control-alt-del' label text</b><br>
 - [BZ 1373475](https://bugzilla.redhat.com/1373475) <b>UI error occurs when migrating VM</b><br>
 - [BZ 1364466](https://bugzilla.redhat.com/1364466) <b>Wrong hash-name of VM > Containers subtab</b><br>
 - [BZ 1356492](https://bugzilla.redhat.com/1356492) <b>ui: source column is not needed in Pools "Disk Allocation" in edit vm pool</b><br>
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

#### OTOPI

##### Team: Integration

 - [BZ 1365751](https://bugzilla.redhat.com/1365751) <b>force_fail plugin fails with python3</b><br>
 - [BZ 1361888](https://bugzilla.redhat.com/1361888) <b>[FC24] otopi fails on fedora 24 with 'Aborted (core dumped)'</b><br>

#### VDSM JSON-RPC Java

##### Team: Infra

 - [BZ 1393714](https://bugzilla.redhat.com/1393714) <b>Servers state isn't stable and they changing state to non-responsive every few minutes, if one host in the DC is non-responsive with the engine</b><br>
 - [BZ 1387949](https://bugzilla.redhat.com/1387949) <b>Engine commands stuck on hosts with: Unrecognized protocol: 'SUBSCRI'.</b><br>

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1372667](https://bugzilla.redhat.com/1372667) <b>Dashboard: top utilized - memory/storage - number - used value overlapping to graph</b><br>

#### VDSM

##### Team: Infra

 - [BZ 1372093](https://bugzilla.redhat.com/1372093) <b>vdsm sos plugin should collect 'nodectl info' output</b><br>
 - [BZ 1392784](https://bugzilla.redhat.com/1392784) <b>Enable metrics by default</b><br>
 - [BZ 1365007](https://bugzilla.redhat.com/1365007) <b>[RFE] dump_volume_chains: migrate to jsonrpcvdscli</b><br>

##### Team: Network

 - [BZ 1396996](https://bugzilla.redhat.com/1396996) <b>Update vNIC profile on running VM failed when try to change the network profile</b><br>
 - [BZ 1379115](https://bugzilla.redhat.com/1379115) <b>[OVS] Use Linux bonds with OVS networks (instead of OVS Bonds)</b><br>

##### Team: SLA

 - [BZ 1392957](https://bugzilla.redhat.com/1392957) <b>[RFE] Report status of hosted engine deployment in getVdsCapabilities call</b><br>

##### Team: Storage

 - [BZ 1399493](https://bugzilla.redhat.com/1399493) <b>Configure local storage domain format V4 fails</b><br>
 - [BZ 1393458](https://bugzilla.redhat.com/1393458) <b>Error in slot allocation when adding a new disk volume</b><br>

##### Team: Virt

 - [BZ 1396910](https://bugzilla.redhat.com/1396910) <b>Numa sampling causes very high load on the hypervisor.</b><br>
 - [BZ 1396816](https://bugzilla.redhat.com/1396816) <b>Internal server error, @ Global.getAllVmStats -  argument type error</b><br>
 - [BZ 1382578](https://bugzilla.redhat.com/1382578) <b>Periodic functions may continue running after VM is down.</b><br>Previously, if a VM shutdown was too slow, the state of the said VM could have been misreported as unresponsive, even though the VM was operating correctly, albeit too slowly.<br>This was caused by a too aggressive checking on startup and shutdown. The patch takes in account slowdowns in startup and shutdown, avoiding false positive reports.
 - [BZ 1382583](https://bugzilla.redhat.com/1382583) <b>Periodic functions/monitor start before VM is run.</b><br>Previously, if a VM shutdown was too slow, the state of the said VM could have been misreported as unresponsive, even though the VM was operating correctly, albeit too slowly.<br>This was caused by a too aggressive checking on startup and shutdown. The patch takes in account slowdowns in startup and shutdown, avoiding false positive reports.
 - [BZ 1361028](https://bugzilla.redhat.com/1361028) <b>VMs flip to non-responsive state for ever.</b><br>A bug in the monitoring code made Vdsm failed to detect the event which means that a stuck QEMU process recovered and it is responsive again.
 - [BZ 1388596](https://bugzilla.redhat.com/1388596) <b>Virt-v2v is failing with python error when importing VM from KVM</b><br>
 - [BZ 1347669](https://bugzilla.redhat.com/1347669) <b>Add /dev/urandom as entropy source for virtio-rng</b><br>
 - [BZ 1357798](https://bugzilla.redhat.com/1357798) <b>VMs are not reported as non-responding even though  qemu process does not responds.</b><br>Due to a bug in the monitoring code, unresponsive QEMU processes were misreported responsive, while they were not.<br>This bug made Vdsm wrongly report that the QEMU process recovered and was responsive again after a short amonunt of time, while it was actually still unresponsive.
 - [BZ 1371843](https://bugzilla.redhat.com/1371843) <b>Improve OVA import compatibility</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1376114](https://bugzilla.redhat.com/1376114) <b>[TEXT][HE] Warn on addition of new HE host via host-deploy</b><br>

##### Team: Storage

 - [BZ 1397305](https://bugzilla.redhat.com/1397305) <b>[hosted-engine-setup] Deployment is broken for FC: "Failed to execute stage 'Environment customization': 'Plugin' object has no attribute '_customize_mnt_options'"</b><br>

#### oVirt Hosted Engine HA

##### Team: SLA

 - [BZ 1392957](https://bugzilla.redhat.com/1392957) <b>[RFE] Report status of hosted engine deployment in getVdsCapabilities call</b><br>

#### oVirt Engine SDK 4 Ruby

##### Team: Infra

 - [BZ 1370464](https://bugzilla.redhat.com/1370464) <b>Ruby-SDK: Enable HTTP compression by default</b><br>
 - [BZ 1387951](https://bugzilla.redhat.com/1387951) <b>Disk Issues via API and SDK</b><br>

#### oVirt Engine SDK 4 Java

##### Team: Infra

 - [BZ 1370485](https://bugzilla.redhat.com/1370485) <b>Java-SDK: Enable HTTP compression by default</b><br>SDK by default ask the server to send compressed responses.

#### oVirt Engine SDK 4 Python

##### Team: Infra

 - [BZ 1367826](https://bugzilla.redhat.com/1367826) <b>[scale] - Python SDK: Enable HTTP compression by default</b><br>SDK by default ask the server to send compressed responses.

## Bug fixes

### oVirt Engine

#### Team: Infra

 - [BZ 1372320](https://bugzilla.redhat.com/1372320) <b>"Started - Finished" Messages in the audit log without any information</b><br>
 - [BZ 1320774](https://bugzilla.redhat.com/1320774) <b>[RFE] Add support to specify metadata on column to be able to use comma separated list of values during search</b><br>

#### Team: Network

 - [BZ 1255257](https://bugzilla.redhat.com/1255257) <b>[ja_JP] [Admin Portal]: The alignment needs to be adjusted on data center->logical networks->new->vNIC profile page.</b><br>

#### Team: SLA

 - [BZ 1297210](https://bugzilla.redhat.com/1297210) <b>[quota] Quota field is mandatory for disk creation for storage domain that doesn't have quota rule while quota is configured for specific domains in the DC</b><br>
 - [BZ 1350230](https://bugzilla.redhat.com/1350230) <b>Define to long name to the affinity label raise exception under engine.log</b><br>
 - [BZ 1148039](https://bugzilla.redhat.com/1148039) <b>When create vm NUMA node it useless to specify host numa node index</b><br>
 - [BZ 1147858](https://bugzilla.redhat.com/1147858) <b>Numa nodes icons is down, also when vm up</b><br>
 - [BZ 1363951](https://bugzilla.redhat.com/1363951) <b>Mouseover on hosted engine "crown" icon, is not showing correct tooltip description.</b><br>
 - [BZ 1287540](https://bugzilla.redhat.com/1287540) <b>[Admin Portal] List of problematic clusters missing in operation failure dialog (edit DC - bump up compat level)</b><br>
 - [BZ 1301353](https://bugzilla.redhat.com/1301353) <b>memory overcommit accepts negative values and sets them to 200%</b><br>
 - [BZ 1369046](https://bugzilla.redhat.com/1369046) <b>User can't assign CPU profile after upgrade from 3.6 to 4.0</b><br>
 - [BZ 1326512](https://bugzilla.redhat.com/1326512) <b>Consolidation of VM and VDS "Editable" Annotations</b><br>

#### Team: Storage

 - [BZ 1186817](https://bugzilla.redhat.com/1186817) <b>VM fails to start after changing IDE disk boot order</b><br>
 - [BZ 1309212](https://bugzilla.redhat.com/1309212) <b>Allow changing DC type from local to shared and vice versa [if the SD types permit it]</b><br>

#### Team: UX

 - [BZ 1267259](https://bugzilla.redhat.com/1267259) <b>New/Edit Cluster dialog ui is inconsistent</b><br>
 - [BZ 1326513](https://bugzilla.redhat.com/1326513) <b>CSS overflow detection algorithms perform badly, are really slow</b><br>

#### Team: Virt

 - [BZ 1356767](https://bugzilla.redhat.com/1356767) <b>Special characters in VMware cluster and data center name should be handled correctly</b><br>
 - [BZ 1366786](https://bugzilla.redhat.com/1366786) <b>[InClusterUpgrade] Possible race condition with large amount of VMs in cluster</b><br>
 - [BZ 1310553](https://bugzilla.redhat.com/1310553) <b>'change cd' (Forgein Menu) works only in SPICE and not in  VNC console and not at all from REST</b><br>
 - [BZ 1317584](https://bugzilla.redhat.com/1317584) <b>VM Maintenance reason popup not visible in admin portal</b><br>
 - [BZ 1293591](https://bugzilla.redhat.com/1293591) <b>v2v: external provider "test" button failed when using "any data center" value.</b><br>
 - [BZ 1303450](https://bugzilla.redhat.com/1303450) <b>[REST] Increasing the CPU sockets to a amount of CPU's that the host doesn't have, Shouldn't be possible via REST</b><br>
 - [BZ 1376339](https://bugzilla.redhat.com/1376339) <b>[UI] Impossible to create / attach disk after changing Template value</b><br>
 - [BZ 1390993](https://bugzilla.redhat.com/1390993) <b>[Admin Portal] disable user strick checking change is not remembered in UI</b><br>
 - [BZ 1323475](https://bugzilla.redhat.com/1323475) <b>Instance type Graphics protocol is not aligned with Video type</b><br>
 - [BZ 1327869](https://bugzilla.redhat.com/1327869) <b>an exception while trying to open a noVNC console for VM and FF is set to block popups</b><br>
 - [BZ 1326076](https://bugzilla.redhat.com/1326076) <b>Userportal extended: Guest Information subtab can't be accessed for pool VMs</b><br>

### oVirt Engine DWH

#### Team: Integration

 - [BZ 1332892](https://bugzilla.redhat.com/1332892) <b>Automatic provisioning of engine db keeps password in answer file if dwh is installed</b><br>

### oVirt Setup Lib

#### Team: Integration

 - [BZ 1366270](https://bugzilla.redhat.com/1366270) <b>hosted-engine-setup (and cockpit) accepts host address with an underscore while the engine correctly refuses them</b><br>

### VDSM

#### Team: Infra

 - [BZ 1326940](https://bugzilla.redhat.com/1326940) <b>After ovirt-engine is restarted, hypervisors stop listening on 54321 until vdsm is restarted.</b><br>

#### Team: Network

 - [BZ 1141267](https://bugzilla.redhat.com/1141267) <b>do not silently ignore failure to read ifcfg files</b><br>

#### Team: Storage

 - [BZ 1334274](https://bugzilla.redhat.com/1334274) <b>AttributeErrors from ioprocess during shutdown when vdsm tests finish</b><br>

#### Team: Virt

 - [BZ 1238536](https://bugzilla.redhat.com/1238536) <b>vdsm before_vm_hibernate hook failure leaves vm in the wrong state (paused)</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1313881](https://bugzilla.redhat.com/1313881) <b>[networking] Adapt to the lack of CFG property of NICS in VDSM netinfo</b><br>
 - [BZ 1366270](https://bugzilla.redhat.com/1366270) <b>hosted-engine-setup (and cockpit) accepts host address with an underscore while the engine correctly refuses them</b><br>

### oVirt Hosted Engine HA

#### Team: Integration

 - [BZ 1398443](https://bugzilla.redhat.com/1398443) <b>ovirt-ha-agent fails reading the HE vm configuration from the OVF_STORE due to a change in vdsm sudoers policy</b><br>


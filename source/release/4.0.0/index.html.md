---
title: OVirt 4.0.0 Release Notes
category: documentation
authors: rafaelmartins
---

# oVirt 4.0.0 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.0 alpha1 release as of April 5th, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

This is pre-release software. Please take a look at our [community page](http://www.ovirt.org/community/) to know how to ask questions and interact with developers and users. All issues or bugs should be reported via the [Red Hat Bugzilla](https://bugzilla.redhat.com/). The oVirt Project makes no guarantees as to its suitability or usefulness. This pre-release should not to be used in production, and it is not feature complete.

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](http://www.ovirt.org/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

## ALPHA RELEASE

In order to install oVirt 4.0.0 Alpha Release you will need to enable oVirt 4.0.0 alpha1 release repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://plain.resources.ovirt.org/pub/ovirt-4.0_alpha1/rpm/el7/noarch/ovirt-release40.rpm`](http://plain.resources.ovirt.org/pub/ovirt-4.0_alpha1/rpm/el7/noarch/ovirt-release40.rpm)

To test oVirt 4.0.0 alpha1 release, you should read our [Quick Start Guide](Quick Start Guide).

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.


## Enhancement

### ovirt-engine

 - [BZ 1054070](https://bugzilla.redhat.com/1054070) <b>[RFE] add ability to cold restart of a VM when it run by Run Once and reboots</b>
 - [BZ 1285446](https://bugzilla.redhat.com/1285446) <b>Random sub-template of given name is used to create VM Pool via REST</b>g
 - [BZ 1139306](https://bugzilla.redhat.com/1139306) <b>[RFE][AAA] Transfer message from aaa filters to login screen</b>
 - [BZ 1277495](https://bugzilla.redhat.com/1277495) <b>remove the pre-3.6 setupnetworks api</b>
 - [BZ 1267508](https://bugzilla.redhat.com/1267508) <b>[RFE] Replace python-cheetah with python-jinja2 within ovirt-engine</b><br>
Replaced python-cheetah with python-jinja2 as template-engine for services configuration files, as python-cheetah didn't receive updates since 2012 and is not available on RHEL 7.2.<br>
 - [BZ 1172390](https://bugzilla.redhat.com/1172390) <b>[RFE] GUI should have a field/column chooser in the UI</b>
 - [BZ 1126286](https://bugzilla.redhat.com/1126286) <b>[RFE][Admin GUI] missing indicator in 'Add Users and Groups' dialog when the search took more than few seconds.</b>
 - [BZ 1176217](https://bugzilla.redhat.com/1176217) <b>[RFE] Rename "Edit" button in Storage Domains tab to "Manage Domain"</b>
 - [BZ 1060791](https://bugzilla.redhat.com/1060791) <b>[RFE] Cleanup, remove IP information guest_info section from VM resource</b>
 - [BZ 1110577](https://bugzilla.redhat.com/1110577) <b>[RFE] introduce Italian</b>
 - [BZ 1250102](https://bugzilla.redhat.com/1250102) <b>[RFE] - Show user/group icons in search results for users</b>
 - [BZ 1223732](https://bugzilla.redhat.com/1223732) <b>[RFE] Add authz provider column for user session management</b>
 - [BZ 1290737](https://bugzilla.redhat.com/1290737) <b>[AAA] add credentials modify sequence</b>
 - [BZ 1273041](https://bugzilla.redhat.com/1273041) <b>[RFE] extend Permission tab with list of 'My groups'</b>
 - [BZ 1194989](https://bugzilla.redhat.com/1194989) <b>[RFE] Provide option to remove / replace base template while template sub-version exists</b>
 - [BZ 1317468](https://bugzilla.redhat.com/1317468) <b>[RFE]Email notification when the number of LVs in SD are reaching/more than 350</b>
 - [BZ 1240954](https://bugzilla.redhat.com/1240954) <b>[RFE][webadmin-portal] Cannot override template's name when importing an image as template from glance</b>
It is now possible to specify a custom name for the template when importing a Glance disk through the Web Admin portal.<br>
 - [BZ 1216888](https://bugzilla.redhat.com/1216888) <b>[RFE] engine-backup should not depend on the engine</b>
 - [BZ 1271698](https://bugzilla.redhat.com/1271698) <b>Change terminology from "virtual machine disk" to "virtual disk"</b>
 - [BZ 1273025](https://bugzilla.redhat.com/1273025) <b>User portal's permission tab offers to add permissions which cannot be added</b>
 - [BZ 1197449](https://bugzilla.redhat.com/1197449) <b>[RFE] add source_ip to the sessions table</b>
 - [BZ 1317461](https://bugzilla.redhat.com/1317461) <b>[RFE] Rename "Edit" button in Storage Domains tab to "Manage Domain"</b>
 - [BZ 1104107](https://bugzilla.redhat.com/1104107) <b>[RFE][AAA] support only UPN format for usernames</b>
rhevm-2.x SAM user format of profile\user is not supported any more.<br>
 - [BZ 1150239](https://bugzilla.redhat.com/1150239) <b>[RFE] [pre-4.0] Model memory volumes as disks in the database/backend</b>
 - [BZ 1037844](https://bugzilla.redhat.com/1037844) <b>[RFE][AAA] Allow the user to change an expired password as a part of the User Portal login process</b>
 - [BZ 1285640](https://bugzilla.redhat.com/1285640) <b>[RFE][Backend] support pagination for Katello ERRATA</b>
 - [BZ 1208860](https://bugzilla.redhat.com/1208860) <b>Template versions have non-unique name in Disk tab</b>
 - [BZ 1253710](https://bugzilla.redhat.com/1253710) <b>[RFE] Add template methods to work with Cloud-Init/Sysprep settings through RHEVM API</b>
 
### RFEs

 - [BZ 957600](https://bugzilla.redhat.com/957600) <b>[RFE] RHEV-M should have a field/column chooser in the UI that is saved for the logged in user.</b>
 - [BZ 1199933](https://bugzilla.redhat.com/1199933) <b>[RFE] Add Fencing of Ilo3/4 via ssh fencing to RHEV-M</b>
 - [BZ 1275182](https://bugzilla.redhat.com/1275182) <b>[RFE]Email notification when the number of LVs in SD are reaching/more than 350</b>

### oVirt Engine SDK Ruby

 - [BZ 1291365](https://bugzilla.redhat.com/1291365) <b>[RFE] Create a Ruby SDK for the oVirt API</b>


### oVirt Host Deploy

 - [BZ 1200469](https://bugzilla.redhat.com/1200469) <b>[RFE] add support for hosted-engine deployment on additional hosts</b>


### vdsm

 - [BZ 1140245](https://bugzilla.redhat.com/1140245) <b>[RFE] Add hook for multiple IPv4 addresses per host network</b>
 - [BZ 1182092](https://bugzilla.redhat.com/1182092) <b>[RFE] Make plug-able API for supervdsm</b>

### ovirt-engine-sdk-python

 - [BZ 1096137](https://bugzilla.redhat.com/1096137) <b>[RFE] [oVirt 4.0] add python 3.x support to the sdk</b>
 - [BZ 1221238](https://bugzilla.redhat.com/1221238) <b>[RFE][performance] - generate large scale list running too slow.</b>
 - [BZ 1305575](https://bugzilla.redhat.com/1305575) <b>[RFE] Python SDK 4.0 - make boot device syntax more pythonic</b>

### ovirt-engine-cli

 - [BZ 1255409](https://bugzilla.redhat.com/1255409) <b>[RFE] Add ovirt-shell support for Mac OS</b>



## Deprecated Functionalities

### oVirt Engine

 - [BZ 1320515](https://bugzilla.redhat.com/1320515) <b>Removed deprecated api/vms/&lt;id&gt;/move</b><br>
The API of /vms/&lt;vmid&gt;/move has been removed, after been deprecated since 3.1<br>
 - [BZ 1282798](https://bugzilla.redhat.com/1282798) <b>Dropped All-in-One support</b><br>
All-In-One setup support has been dropped in favor of Hosted Engine.<br>

### oVirt Host Deploy

 - [BZ 1314790](https://bugzilla.redhat.com/1314790) <b>Drop ovirt-host-deploy-offline</b><br>
ovirt-host-deploy-offline won't be available anymore in 4.0<br>


## Bugs fixed

### oVirt Engine

 - [BZ 1277664](https://bugzilla.redhat.com/1277664) <b>New domain dialog suggests keeping non-existent defaults</b>
 - [BZ 1295779](https://bugzilla.redhat.com/1295779) <b>Untranslated job name for vm-logon and CloneVm</b>
 - [BZ 1302667](https://bugzilla.redhat.com/1302667) <b>[FC23] engine-setup fails to configure nfs</b>
 - [BZ 1261335](https://bugzilla.redhat.com/1261335) <b>[engine-setup][text] The error for a missing update in the sql performing the validation should be fixed.</b>
 - [BZ 1273447](https://bugzilla.redhat.com/1273447) <b>After a command is finished tasks are not cleared and stay in executing status</b>
 - [BZ 1310705](https://bugzilla.redhat.com/1310705) <b>Problem when configuring ovirt-engine with dockerc plugin enabled</b>
 - [BZ 1273094](https://bugzilla.redhat.com/1273094) <b>4.0: can't remove vm template - the disks are removed and the template stays locked</b>
 - [BZ 1225109](https://bugzilla.redhat.com/1225109) <b>Sending a DELETE request with a Content-Type selects wrong "remove" method</b>
 - [BZ 1302794](https://bugzilla.redhat.com/1302794) <b>[scale] - storage_domains view generate inefficient query</b>
 - [BZ 1234328](https://bugzilla.redhat.com/1234328) <b>SR-IOV --> add support for Hotplug/unplug of VFs</b>
 - [BZ 1273970](https://bugzilla.redhat.com/1273970) <b>Automation of UI tests needs way to check status of VM in userportal</b>
 - [BZ 1286810](https://bugzilla.redhat.com/1286810) <b>Log out from userportal doesn't work for non-admins</b>
 - [BZ 1299233](https://bugzilla.redhat.com/1299233) <b>NPE when importing image as template from glance</b>
 - [BZ 1303548](https://bugzilla.redhat.com/1303548) <b>[RFE] Add ability to import RHEL Xen guest images directly into oVirt</b>
 - [BZ 1303346](https://bugzilla.redhat.com/1303346) <b>XSD value object requires at least 1 occurrence of datum but doesnt always have it in nic statistics</b>
 - [BZ 1279791](https://bugzilla.redhat.com/1279791) <b>[engine-backend] "Given Network Attachment (id '${NETWORK_ATTACHMENT_NOT_EXISTS_ENTITY}') does not exist" when confirming setup networks</b>
 - [BZ 1284481](https://bugzilla.redhat.com/1284481) <b>4.0: NPE when trying to delete template from export domain</b>
 - [BZ 1267910](https://bugzilla.redhat.com/1267910) <b>PSQLException when insert value to audit log if input string is too long</b>
 - [BZ 1293944](https://bugzilla.redhat.com/1293944) <b>Log common locking management actions</b>
 - [BZ 1306603](https://bugzilla.redhat.com/1306603) <b>[Admin Portal] Uncaught exception occurred when switching between individual hosts/VM subtab in Hosts maintab</b>
 - [BZ 1304653](https://bugzilla.redhat.com/1304653) <b>ACTION_TYPE_FAILED_VM_SNAPSHOT_TYPE_NOT_ALLOWED message isn't i18n comptaible</b>
 - [BZ 1286752](https://bugzilla.redhat.com/1286752) <b>Inconsistent use of placeholders in login form</b>
 - [BZ 1277667](https://bugzilla.redhat.com/1277667) <b>ISO domain can't be created</b>
 - [BZ 1274220](https://bugzilla.redhat.com/1274220) <b>Setup can't be canceled using Ctrl + C when setting Local ISO domain path</b>
 - [BZ 1275747](https://bugzilla.redhat.com/1275747) <b>Cancel migration VDSErrorException  Failed to DestroyVDS on destination host</b>
 - [BZ 1267259](https://bugzilla.redhat.com/1267259) <b>New/Edit Cluster dialog ui is inconsistent</b>
 - [BZ 1305343](https://bugzilla.redhat.com/1305343) <b>Irrelevant warnings are logged when attaching an export domain to a dc</b>
 - [BZ 1246886](https://bugzilla.redhat.com/1246886) <b>Remove vm-pool fails if vms are running</b>
 - [BZ 1322923](https://bugzilla.redhat.com/1322923) <b>java.lang.IllegalArgumentException: No type specified for option: 'encrypt_options' in /api/capabilities</b>
 - [BZ 1253440](https://bugzilla.redhat.com/1253440) <b>RadioButton "Specific" in New VM dialog > Hosts is not controlled by its label</b>
 - [BZ 994403](https://bugzilla.redhat.com/994403) <b>All options “Create Snapshot“ during VM “In Preview” status, should be grayed out</b>
 - [BZ 1221189](https://bugzilla.redhat.com/1221189) <b>Add warning when adding external FCP lun to VM although it is part of existing storage domain</b>
 - [BZ 1280358](https://bugzilla.redhat.com/1280358) <b>Disk Alias and Description maximum size isn't restricted to max size</b>
 - [BZ 1318666](https://bugzilla.redhat.com/1318666) <b>Remove VM fails with HTTP400 - bad request</b>
 - [BZ 1191592](https://bugzilla.redhat.com/1191592) <b>drop spring-asm dependency</b>
 - [BZ 1268949](https://bugzilla.redhat.com/1268949) <b>Wrong error message while changing template of vm</b>
 - [BZ 1259620](https://bugzilla.redhat.com/1259620) <b>Missing Cpu.setType api</b>
 - [BZ 1275719](https://bugzilla.redhat.com/1275719) <b>remove ie8, ie9 permutations from GWT compilations</b>
 - [BZ 1269413](https://bugzilla.redhat.com/1269413) <b>running master on FC22 server.log shows several warnings about java modules.</b>
 - [BZ 1278738](https://bugzilla.redhat.com/1278738) <b>The "virtio_scsi" element isn't populated when a VM is requested</b>
 - [BZ 1167698](https://bugzilla.redhat.com/1167698) <b>[SetupNetworks]> Unmanaged network on host NIC should prevent attaching new networks to this NIC, until unmanaged network is removed</b>
 - [BZ 1215727](https://bugzilla.redhat.com/1215727) <b>Whenever an exception is thrown in the front end code, unrelated parts of the GUI tend to stop working (e.g. 'new' and 'import' buttons under Networks tab)</b>
 - [BZ 1310642](https://bugzilla.redhat.com/1310642) <b>Provide more details in the Events/Tasks tab message when importing an image as template from an external provider</b>
 - [BZ 1229743](https://bugzilla.redhat.com/1229743) <b>New host info is cleared after disabling use of Host Foreman provider</b>
 - [BZ 1057009](https://bugzilla.redhat.com/1057009) <b>Taking a memory snapshot should alert the user that the VM will be paused for creation duration.</b>
 - [BZ 1317947](https://bugzilla.redhat.com/1317947) <b>engine-setup should default to not create NFS ISO domain</b>
 - [BZ 1221163](https://bugzilla.redhat.com/1221163) <b>[TEXT][REST] Wrong error is thrown when attempting an update command on a detached storage domain</b>
 - [BZ 1301383](https://bugzilla.redhat.com/1301383) <b>Search query returns wrong value for tag association</b>
 - [BZ 1317581](https://bugzilla.redhat.com/1317581) <b>Neutron | missing REST-API to import networks from neutron external provider</b>
 - [BZ 1215402](https://bugzilla.redhat.com/1215402) <b>Posix ISO domain sometimes fails to Detach after A VM which used a CD/DVD ISO image powers on and then powers off</b>
 - [BZ 1321452](https://bugzilla.redhat.com/1321452) <b>[REST API] storage_manager object/tag is missing in host details</b>
 - [BZ 1314781](https://bugzilla.redhat.com/1314781) <b>Add Cockpit port to the default ports to be opened when Engine manages the firewall</b>
 - [BZ 1283499](https://bugzilla.redhat.com/1283499) <b>Impossible to POST key value using REST API</b>
 - [BZ 1317279](https://bugzilla.redhat.com/1317279) <b>iscsi login fails in v3</b>
 - [BZ 1296520](https://bugzilla.redhat.com/1296520) <b>[engine-backup] Misleading error msg when log parameter is not passed</b>
 - [BZ 1297689](https://bugzilla.redhat.com/1297689) <b>No error message is shown on getDevicelist failure when adding a new FC storage domain</b>
 - [BZ 1285390](https://bugzilla.redhat.com/1285390) <b>REST error message suggests description but there is none</b>
 - [BZ 1261951](https://bugzilla.redhat.com/1261951) <b>Improve error message when OVF cannot be parsed from export domain</b>
 - [BZ 1197808](https://bugzilla.redhat.com/1197808) <b>Unable to remove VM previewing a snapshot</b>
 - [BZ 1242230](https://bugzilla.redhat.com/1242230) <b>[New HostSetupNetworks] ui code refactoring</b>
 - [BZ 1277209](https://bugzilla.redhat.com/1277209) <b>Double click on split table checkbox column shouldn't initiate item move</b>
 - [BZ 1275268](https://bugzilla.redhat.com/1275268) <b>VM on cluster 3.6 that was upgraded from 3.5 will fail to start due to emulated machine</b>
 - [BZ 1261795](https://bugzilla.redhat.com/1261795) <b>A minor typo found during translation "Cannot ${action} ${type}. At most one VLAN-untagged Logical Network is allowed on a NIC (optionally in conjunction with several VLAN Logical Networks). The following Network Interfaces violate that : ${NETWORK_INTERF</b>
 - [BZ 1306743](https://bugzilla.redhat.com/1306743) <b>Live Merge does not update the database properly upon failure</b>
 - [BZ 1310837](https://bugzilla.redhat.com/1310837) <b>oVirt cannot be accessed through IPv6 address</b>
 - [BZ 1267228](https://bugzilla.redhat.com/1267228) <b>Asynchronous frontend validation of icons</b>
 - [BZ 1273932](https://bugzilla.redhat.com/1273932) <b>RestAPI returns 500 instead of 400 when sending invalid JSON</b>
 - [BZ 1277496](https://bugzilla.redhat.com/1277496) <b>remove oldest network api (3.0? — preceding existence of setsupnetworks) and internal usage thereof</b>
 - [BZ 1219383](https://bugzilla.redhat.com/1219383) <b>[MAC pool] limit range to 2^31 addresses</b>
 - [BZ 1283151](https://bugzilla.redhat.com/1283151) <b>external VMs are not added when storage is not configured</b>

### oVirt Hosted Engine Setup

 - [BZ 1308951](https://bugzilla.redhat.com/1308951) <b>hosted-engine fails on master</b>

### oVirt Host Deploy

 - [BZ 1320059](https://bugzilla.redhat.com/1320059) <b>vdsm _reconfigure should be called before _start</b>

### oVirt ISO Uploader

 - [BZ 1264542](https://bugzilla.redhat.com/1264542) <b>change ovirt-engine api endpoint</b>

### oVirt Image Uploader

 - [BZ 1104661](https://bugzilla.redhat.com/1104661) <b>zero returncode on error</b>
 - [BZ 1264424](https://bugzilla.redhat.com/1264424) <b>change ovirt-engine api endpoint</b>

### oVirt Log Collector

 - [BZ 1254654](https://bugzilla.redhat.com/1254654) <b>[F23] ovirt-log-collector fails to build on fedora >= 23</b>

### oVirt Engine CLI

 - [BZ 1303635](https://bugzilla.redhat.com/1303635) <b>[ovirt-shell] sys.stdin.flush() issue on BSD, MacOS</b>

### oVirt Engine DWH

 - [BZ 1311149](https://bugzilla.redhat.com/1311149) <b>change vds_groups in etl to cluster</b>
 - [BZ 1312638](https://bugzilla.redhat.com/1312638) <b>Remove DWH views that will not be supported anymore</b>
 - [BZ 1301962](https://bugzilla.redhat.com/1301962) <b>engine-setup fails with: Internal error: cannot import name dialog</b>

### oVirt Engine SDK Python

 - [BZ 1321571](https://bugzilla.redhat.com/1321571) <b>Python-SDK: dc.set_quota_mode('whatever') works - the mode is ignored.</b>

### oVirt Engine Reports

 - [BZ 1316471](https://bugzilla.redhat.com/1316471) <b>[4.0] Traceback upgrading reports to master</b>

### oVirt Live

 - [BZ 1282799](https://bugzilla.redhat.com/1282799) <b>Import all-in-one plugins from ovirt-engine into ovirt-live</b>
 - [BZ 1316029](https://bugzilla.redhat.com/1316029) <b>vdsm - caps/machinetype API changes broke setup</b>

### OTOPI

 - [BZ 1316908](https://bugzilla.redhat.com/1316908) <b>hosted-engine --deploy fails when you have i18n chars in /root/.ssh/authorized_keys</b>
 - [BZ 1295887](https://bugzilla.redhat.com/1295887) <b>Certificate organization with characters outside the ASCII causes a setup failure</b>

### VDSM

 - [BZ 1261056](https://bugzilla.redhat.com/1261056) <b>Place bonding-defaults.json outside of /var/lib/vdsm</b>
 - [BZ 1201355](https://bugzilla.redhat.com/1201355) <b>[4.0] [HC] Hosted Engine storage domains disappear while running ovirt-host-deploy in Hyper Converged configuration</b>
 - [BZ 1278414](https://bugzilla.redhat.com/1278414) <b>drop requirement of 'umask' argument on cpopen</b>
 - [BZ 1296144](https://bugzilla.redhat.com/1296144) <b>vdsm keeps reporting dhcp lease although it was changed to static ip</b>
 - [BZ 1305197](https://bugzilla.redhat.com/1305197) <b>libvirt does not start after installing vdsm</b>
 - [BZ 1305768](https://bugzilla.redhat.com/1305768) <b>Couldn't create local storage domain with SELinux enforcing</b>
 - [BZ 1189200](https://bugzilla.redhat.com/1189200) <b>traceback in ioprocess while restarting VDSM</b>
 - [BZ 1269175](https://bugzilla.redhat.com/1269175) <b>nic removed from bond can not be bound to another bond</b>
 - [BZ 1191514](https://bugzilla.redhat.com/1191514) <b>Missing storage related VDSM error codes</b>
 - [BZ 1314705](https://bugzilla.redhat.com/1314705) <b>[ovirt-node] Can't register node to engine through TUI</b>
 - [BZ 1270220](https://bugzilla.redhat.com/1270220) <b>SPM is not tolerant for very slow NFS file deletes</b>
 - [BZ 1274622](https://bugzilla.redhat.com/1274622) <b>getImagesList fails if called on a file based storageDomain which is not connected to any storage pool</b>
 - [BZ 1265144](https://bugzilla.redhat.com/1265144) <b>Reduce time in filtering JSON Data received from the guest agent</b>
 - [BZ 1274670](https://bugzilla.redhat.com/1274670) <b>VM migration doesn't work with current VDSM master</b>
 - [BZ 1300640](https://bugzilla.redhat.com/1300640) <b>spec: require python-six >= 1.9</b>

### oVirt Node

 - [BZ 1322727](https://bugzilla.redhat.com/1322727) <b>Usb driver boot fail when using "dd" to make boot.iso in usb-disk</b>
 - [BZ 1322333](https://bugzilla.redhat.com/1322333) <b>Failed to add NGN4.0(for 3.6 branch) to engine 3.6</b>
 - [BZ 1320121](https://bugzilla.redhat.com/1320121) <b>Stream name does not match the image stream</b>

### ovirt-vmconsole

 - [BZ 1313864](https://bugzilla.redhat.com/1313864) <b>Make sure code is python2 compatible</b>

### vdsm-jsonrpc-java

 - [BZ 1303584](https://bugzilla.redhat.com/1303584) <b>check the sslengine creation</b>


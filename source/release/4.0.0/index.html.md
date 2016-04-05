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

## Bugs fixed

### oVirt Engine

- [BZ 957600](https://bugzilla.redhat.com/957600) - [RFE] RHEV-M should have a field/column chooser in the UI that is saved for the logged in user.
- [BZ 994403](https://bugzilla.redhat.com/994403) - All options “Create Snapshot“ during VM “In Preview” status, should be grayed out
- [BZ 1037844](https://bugzilla.redhat.com/1037844) - [RFE][AAA] Allow the user to change an expired password as a part of the User Portal login process
- [BZ 1054070](https://bugzilla.redhat.com/1054070) - [RFE] add ability to cold restart of a VM when it run by Run Once and reboots
- [BZ 1057009](https://bugzilla.redhat.com/1057009) - Taking a memory snapshot should alert the user that the VM will be paused for creation duration.
- [BZ 1060791](https://bugzilla.redhat.com/1060791) - [RFE] Cleanup, remove IP information guest_info section from VM resource
- [BZ 1110577](https://bugzilla.redhat.com/1110577) - [RFE] introduce Italian
- [BZ 1150239](https://bugzilla.redhat.com/1150239) - [RFE] [pre-4.0] Model memory volumes as disks in the database/backend
- [BZ 1167698](https://bugzilla.redhat.com/1167698) - [SetupNetworks]> Unmanaged network on host NIC should prevent attaching new networks to this NIC, until unmanaged network is removed
- [BZ 1172390](https://bugzilla.redhat.com/1172390) - [RFE] GUI should have a field/column chooser in the UI
- [BZ 1176217](https://bugzilla.redhat.com/1176217) - [RFE] Rename "Edit" button in Storage Domains tab to "Manage Domain"
- [BZ 1194989](https://bugzilla.redhat.com/1194989) - [RFE] Provide option to remove / replace base template while template sub-version exists
- [BZ 1197449](https://bugzilla.redhat.com/1197449) - [RFE] add source_ip to the sessions table
- [BZ 1197808](https://bugzilla.redhat.com/1197808) - Unable to remove VM previewing a snapshot
- [BZ 1199933](https://bugzilla.redhat.com/1199933) - [RFE] Add Fencing of Ilo3/4 via ssh fencing to RHEV-M
- [BZ 1208860](https://bugzilla.redhat.com/1208860) - Template versions have non-unique name in Disk tab
- [BZ 1216888](https://bugzilla.redhat.com/1216888) - [RFE] engine-backup should not depend on the engine
- [BZ 1219383](https://bugzilla.redhat.com/1219383) - [MAC pool] limit range to 2^31 addresses
- [BZ 1221163](https://bugzilla.redhat.com/1221163) - [TEXT][REST] Wrong error is thrown when attempting an update command on a detached storage domain
- [BZ 1221189](https://bugzilla.redhat.com/1221189) - Add warning when adding external FCP lun to VM although it is part of existing storage domain
- [BZ 1223732](https://bugzilla.redhat.com/1223732) - [RFE] Add authz provider column for user session management
- [BZ 1229743](https://bugzilla.redhat.com/1229743) - New host info is cleared after disabling use of Host Foreman provider
- [BZ 1240954](https://bugzilla.redhat.com/1240954) - [RFE][webadmin-portal] Cannot override template's name when importing an image as template from glance
- [BZ 1246886](https://bugzilla.redhat.com/1246886) - Remove vm-pool fails if vms are running
- [BZ 1250102](https://bugzilla.redhat.com/1250102) - [RFE] - Show user/group icons in search results for users
- [BZ 1253440](https://bugzilla.redhat.com/1253440) - RadioButton "Specific" in New VM dialog > Hosts is not controlled by its label
- [BZ 1253710](https://bugzilla.redhat.com/1253710) - [RFE] Add template methods to work with Cloud-Init/Sysprep settings through RHEVM API
- [BZ 1254654](https://bugzilla.redhat.com/1254654) - [F23] ovirt-log-collector fails to build on fedora >= 23
- [BZ 1259620](https://bugzilla.redhat.com/1259620) - Missing Cpu.setType api
- [BZ 1261335](https://bugzilla.redhat.com/1261335) - [engine-setup][text] The error for a missing update in the sql performing the validation should be fixed.
- [BZ 1261795](https://bugzilla.redhat.com/1261795) - A minor typo found during translation "Cannot ${action} ${type}. At most one VLAN-untagged Logical Network is allowed on a NIC (optionally in conjunction with several VLAN Logical Networks). The following Network Interfaces violate that : ${NETWORK_INTERF
- [BZ 1261951](https://bugzilla.redhat.com/1261951) - Improve error message when OVF cannot be parsed from export domain
- [BZ 1267228](https://bugzilla.redhat.com/1267228) - Asynchronous frontend validation of icons
- [BZ 1267259](https://bugzilla.redhat.com/1267259) - New/Edit Cluster dialog ui is inconsistent
- [BZ 1267508](https://bugzilla.redhat.com/1267508) - [RFE] Replace python-cheetah with python-jinja2 within ovirt-engine
- [BZ 1267910](https://bugzilla.redhat.com/1267910) - PSQLException when insert value to audit log if input string is too long
- [BZ 1268949](https://bugzilla.redhat.com/1268949) - Wrong error message while changing template of vm
- [BZ 1269413](https://bugzilla.redhat.com/1269413) - running master on FC22 server.log shows several warnings about java modules.
- [BZ 1269953](https://bugzilla.redhat.com/1269953) - Console Client Resources page - cannot scroll
- [BZ 1271698](https://bugzilla.redhat.com/1271698) - Change terminology from "virtual machine disk" to "virtual disk"
- [BZ 1273025](https://bugzilla.redhat.com/1273025) - User portal's permission tab offers to add permissions which cannot be added
- [BZ 1273041](https://bugzilla.redhat.com/1273041) - [RFE] extend Permission tab with list of 'My groups'
- [BZ 1273094](https://bugzilla.redhat.com/1273094) - 4.0: can't remove vm template - the disks are removed and the template stays locked
- [BZ 1273932](https://bugzilla.redhat.com/1273932) - RestAPI returns 500 instead of 400 when sending invalid JSON
- [BZ 1274220](https://bugzilla.redhat.com/1274220) - Setup can't be canceled using Ctrl + C when setting Local ISO domain path
- [BZ 1274338](https://bugzilla.redhat.com/1274338) - Upgrade WildFly to 8.2.1
- [BZ 1275182](https://bugzilla.redhat.com/1275182) - [RFE]Email notification when the number of LVs in SD are reaching/more than 350
- [BZ 1275719](https://bugzilla.redhat.com/1275719) - remove ie8, ie9 permutations from GWT compilations
- [BZ 1275747](https://bugzilla.redhat.com/1275747) - Cancel migration VDSErrorException  Failed to DestroyVDS on destination host
- [BZ 1277209](https://bugzilla.redhat.com/1277209) - Double click on split table checkbox column shouldn't initiate item move
- [BZ 1277495](https://bugzilla.redhat.com/1277495) - remove the pre-3.6 setupnetworks api
- [BZ 1277496](https://bugzilla.redhat.com/1277496) - remove oldest network api (3.0? — preceding existence of setsupnetworks) and internal usage thereof
- [BZ 1277664](https://bugzilla.redhat.com/1277664) - New domain dialog suggests keeping non-existent defaults
- [BZ 1277667](https://bugzilla.redhat.com/1277667) - ISO domain can't be created
- [BZ 1278738](https://bugzilla.redhat.com/1278738) - The "virtio_scsi" element isn't populated when a VM is requested
- [BZ 1280358](https://bugzilla.redhat.com/1280358) - Disk Alias and Description maximum size isn't restricted to max size
- [BZ 1282798](https://bugzilla.redhat.com/1282798) - Drop All-in-One support
- [BZ 1283151](https://bugzilla.redhat.com/1283151) - external VMs are not added when storage is not configured
- [BZ 1283499](https://bugzilla.redhat.com/1283499) - Impossible to POST key value using REST API
- [BZ 1285390](https://bugzilla.redhat.com/1285390) - REST error message suggests description but there is none
- [BZ 1285446](https://bugzilla.redhat.com/1285446) - Random sub-template of given name is used to create VM Pool via REST
- [BZ 1286752](https://bugzilla.redhat.com/1286752) - Inconsistent use of placeholders in login form
- [BZ 1286810](https://bugzilla.redhat.com/1286810) - Log out from userportal doesn't work for non-admins
- [BZ 1290737](https://bugzilla.redhat.com/1290737) - [AAA] add credentials modify sequence
- [BZ 1293881](https://bugzilla.redhat.com/1293881) - Host installation fails with "java.lang.Integer cannot be cast to java.lang.String"
- [BZ 1293944](https://bugzilla.redhat.com/1293944) - Log common locking management actions
- [BZ 1295779](https://bugzilla.redhat.com/1295779) - Untranslated job name for vm-logon and CloneVm
- [BZ 1296520](https://bugzilla.redhat.com/1296520) - [engine-backup] Misleading error msg when log parameter is not passed
- [BZ 1297689](https://bugzilla.redhat.com/1297689) - No error message is shown on getDevicelist failure when adding a new FC storage domain
- [BZ 1299233](https://bugzilla.redhat.com/1299233) - NPE when importing image as template from glance
- [BZ 1302667](https://bugzilla.redhat.com/1302667) - [FC23] engine-setup fails to configure nfs
- [BZ 1303346](https://bugzilla.redhat.com/1303346) - XSD value object requires at least 1 occurrence of datum but doesnt always have it in nic statistics
- [BZ 1304653](https://bugzilla.redhat.com/1304653) - ACTION_TYPE_FAILED_VM_SNAPSHOT_TYPE_NOT_ALLOWED message isn't i18n comptaible
- [BZ 1305343](https://bugzilla.redhat.com/1305343) - Irrelevant warnings are logged when attaching an export domain to a dc
- [BZ 1306743](https://bugzilla.redhat.com/1306743) - Live Merge does not update the database properly upon failure
- [BZ 1310642](https://bugzilla.redhat.com/1310642) - Provide more details in the Events/Tasks tab message when importing an image as template from an external provider
- [BZ 1310705](https://bugzilla.redhat.com/1310705) - Problem when configuring ovirt-engine with dockerc plugin enabled
- [BZ 1310837](https://bugzilla.redhat.com/1310837) - oVirt cannot be accessed through IPv6 address
- [BZ 1314781](https://bugzilla.redhat.com/1314781) - Add Cockpit port to the default ports to be opened when Engine manages the firewall
- [BZ 1317279](https://bugzilla.redhat.com/1317279) - iscsi login fails in v3
- [BZ 1317581](https://bugzilla.redhat.com/1317581) - Neutron | missing REST-API to import networks from neutron external provider
- [BZ 1317947](https://bugzilla.redhat.com/1317947) - engine-setup should default to not create NFS ISO domain
- [BZ 1318666](https://bugzilla.redhat.com/1318666) - Remove VM fails with HTTP400 - bad request
- [BZ 1320515](https://bugzilla.redhat.com/1320515) - Remove deprecated api/vms/<id>/move
- [BZ 1320964](https://bugzilla.redhat.com/1320964) - REST API: Can't set quota for DC (in v3 compatibility mode at least) - "No enum constant org.ovirt.engine.api.model.QuotaModeType.disabled"
- [BZ 1321452](https://bugzilla.redhat.com/1321452) - [REST API] storage_manager object/tag is missing in host details
- [BZ 1322923](https://bugzilla.redhat.com/1322923) - java.lang.IllegalArgumentException: No type specified for option: 'encrypt_options' in /api/capabilities

### oVirt Hosted Engine Setup

- [BZ 1186388](https://bugzilla.redhat.com/1186388) - [TEXT][HE] Ask user to choose an existing cluster during installation
- [BZ 1221176](https://bugzilla.redhat.com/1221176) - hosted-engine accepts FQDNs with underscore while the engine correctly fails on that
- [BZ 1259266](https://bugzilla.redhat.com/1259266) - engine_api.hosts.add fails if called passing reboot_after_installation optional parameter
- [BZ 1298592](https://bugzilla.redhat.com/1298592) - Deploy of the second host failed if I have root password of the first host under answer file
- [BZ 1306573](https://bugzilla.redhat.com/1306573) - hosted engine appliance deployment fails with insufficient information.
- [BZ 1316094](https://bugzilla.redhat.com/1316094) - [HE] VDSM API - netinfo.CachingNetInfo doesn't exist anymore
- [BZ 1318652](https://bugzilla.redhat.com/1318652) - hosted-engine deploy failure: 'module' object has no attribute 'Ssh'

### oVirt Host Deploy

- [BZ 1200469](https://bugzilla.redhat.com/1200469) - [RFE] add support for hosted-engine deployment on additional hosts
- [BZ 1314790](https://bugzilla.redhat.com/1314790) - Drop ovirt-host-deploy-offline
- [BZ 1320059](https://bugzilla.redhat.com/1320059) - vdsm \_reconfigure should be called before \_start

### oVirt ISO Uploader

- [BZ 1264542](https://bugzilla.redhat.com/1264542) - change ovirt-engine api endpoint

### oVirt Image Uploader

- [BZ 1104661](https://bugzilla.redhat.com/1104661) - zero returncode on error
- [BZ 1264424](https://bugzilla.redhat.com/1264424) - change ovirt-engine api endpoint

### oVirt Log Collector

- [BZ 1254654](https://bugzilla.redhat.com/1254654) - [F23] ovirt-log-collector fails to build on fedora >= 23

### oVirt Engine CLI

- [BZ 1303635](https://bugzilla.redhat.com/1303635) - [ovirt-shell] sys.stdin.flush() issue on BSD, MacOS

### oVirt Engine Setup DWH

- [BZ 1301962](https://bugzilla.redhat.com/1301962) - engine-setup fails with: Internal error: cannot import name dialog
- [BZ 1311149](https://bugzilla.redhat.com/1311149) - change vds_groups in etl to cluster
- [BZ 1312638](https://bugzilla.redhat.com/1312638) - Remove DWH views that will not be supported anymore

### oVirt Engine SDK Python

- [BZ 1096137](https://bugzilla.redhat.com/1096137) - [RFE] [oVirt 4.0] add python 3.x support to the sdk
- [BZ 1260865](https://bugzilla.redhat.com/1260865) - ovirt-engine-sdk-python for el7 is failing on missing python3 dependencies

### oVirt Engine Reports

- [BZ 1316471](https://bugzilla.redhat.com/1316471) - [4.0] Traceback upgrading reports to master

### oVirt Live

- [BZ 1282799](https://bugzilla.redhat.com/1282799) - Import all-in-one plugins from ovirt-engine into ovirt-live
- [BZ 1316029](https://bugzilla.redhat.com/1316029) - vdsm - caps/machinetype API changes broke setup

### otopi

- [BZ 1295887](https://bugzilla.redhat.com/1295887) - Certificate organization with characters outside the ASCII causes a setup failure
- [BZ 1316908](https://bugzilla.redhat.com/1316908) - hosted-engine --deploy fails when you have i18n chars in /root/.ssh/authorized_keys

### VDSM

- [BZ 1182092](https://bugzilla.redhat.com/1182092) - [RFE] Make plug-able API for supervdsm
- [BZ 1189200](https://bugzilla.redhat.com/1189200) - traceback in ioprocess while restarting VDSM
- [BZ 1261056](https://bugzilla.redhat.com/1261056) - Place bonding-defaults.json outside of /var/lib/vdsm
- [BZ 1269175](https://bugzilla.redhat.com/1269175) - nic removed from bond can not be bound to another bond
- [BZ 1270220](https://bugzilla.redhat.com/1270220) - SPM is not tolerant for very slow NFS file deletes
- [BZ 1274670](https://bugzilla.redhat.com/1274670) - VM migration doesn't work with current VDSM master
- [BZ 1278414](https://bugzilla.redhat.com/1278414) - drop requirement of 'umask' argument on cpopen
- [BZ 1300640](https://bugzilla.redhat.com/1300640) - spec: require python-six >= 1.9
- [BZ 1305768](https://bugzilla.redhat.com/1305768) - Couldn't create local storage domain with SELinux enforcing
- [BZ 1314705](https://bugzilla.redhat.com/1314705) - [ovirt-node] Can't register node to engine through TUI

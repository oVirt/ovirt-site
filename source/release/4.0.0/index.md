---
title: oVirt 4.0.0 Release Notes
category: documentation
toc: true
authors: rafaelmartins
page_classes: releases
---

# oVirt 4.0.0 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.0 Release as of June 23rd, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm)

If you're upgrading from a previous release on Enterprise Linux 7 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
      # yum update "ovirt-engine-setup*"
      # engine-setup

Upgrade on Fedora 22 and Enterprise Linux 6 is not supported and you should follow our [Migration Guide](../../documentation/migration-engine-36-to-40/) in order to migrate to Enterprise Linux 7 or Fedora 23.



## Known issues

 - [BZ 1297835](https://bugzilla.redhat.com/1297835) <b>Host install fails on Fedora 23 due to lack of dep on python2-dnf</b><br>On Fedora >= 23 dnf package manager with python 3 is used by default while
ovirt-host-deploy is executed by ovirt-engine using python2. This cause Host install to fail on Fedora >= 23 due to lack of python2-dnf in the default environment. As workaround please install manually python2-dnf on the host before trying to add it to the engine.

## What's New in 4.0.0?

### Enhancement

#### oVirt Engine

##### Team: UX

 - [BZ 1224423](https://bugzilla.redhat.com/1224423) <b>[RFE] eliminate pushing duplicated strings to Zanata due to resource files inheritance</b><br>
 - [BZ 1172390](https://bugzilla.redhat.com/1172390) <b>[RFE] GUI should have a field/column chooser in the UI</b><br>Data tables in WebAdmin UI now support "column control" context menu, triggered by right-clicking the table header area.<br><br>This context menu allows controlling visibility and position of individual columns. This is useful for users who don't need to see all columns or want to re-order columns to their liking.

##### Team: Virt

 - [BZ 1347754](https://bugzilla.redhat.com/1347754) <b>[RFE] [moVirt] Android mobile oVirt client</b><br>A mobile client for oVirt is provided for Android devices, compatible with oVirt/RHEV 3.5+ using REST API 
 - [BZ 1252426](https://bugzilla.redhat.com/1252426) <b>[RFE] Migration improvements (convergence, bandwidth utilization)</b><br>Tab 'Resilience policy' in Cluster dialogs was renamed to 'Migration'. The content of the tab remains part of 'Migration' dialog.
 - [BZ 1301104](https://bugzilla.redhat.com/1301104) <b>[RFE] Automate configuration of host's boot parameters to support VFIO passthrough</b><br>In the past, any modification to kernel command line had to be executed and maintained by administrators. The process was even more difficult in ovirt-node/RHEVH, where the filesystem had to be (manually) remounted as writable to even do the change.<br><br>This feature adds new UI selection when adding or editing a host that allows for kernel line modifications directly from web administration. These changes are then maintained by oVirt/RHEV.<br>Supported modifications are supported as checkboxes, but we also allow free text entry for more complex modifications (e.g. pci-stubbing GPU devices etc.).
 - [BZ 1273399](https://bugzilla.redhat.com/1273399) <b>[RFE] Support for reporting Docker containers active on the Virtual Machine</b><br>Feature: Reporting running docker containers from within guest operating systems managed by oVirt in the oVirt Webadmin Portal<br><br>With this feature the webadmin portal reports now the id, image, executed command, state and the names of the container.
 - [BZ 1234394](https://bugzilla.redhat.com/1234394) <b>[RFE] VM Pools allow stateful VMs</b><br>Stateful VM Pools feature was added.<br><br>VMs from a stateful VM Pool are always started in stateful mode. The state of the VM is preserved even when VM is passed to a different user.
 - [BZ 1277569](https://bugzilla.redhat.com/1277569) <b>[RFE] Atomic guest OS support</b><br>Support for RHEL Atomic Host as a configurable system has been added to the RHEVM WebAdmin and User Portal
 - [BZ 1305900](https://bugzilla.redhat.com/1305900) <b>use different bus for cdrom when q35 chipset is used</b><br>Added possibility to configure different bus interfaces (IDE, SCSI, SATA) for different VM chipsets. By default, SATA interface is selected to be used for q35 chipset.
 - [BZ 1054070](https://bugzilla.redhat.com/1054070) <b>[RFE] add ability to cold restart of a VM when it run by Run Once and reboots</b><br>we wanted to improve the experience for users doing guest OS installations, when they want to use an installation CD and after finishing with OS install the CD is not used anymore and should be ejected.<br>The suggested way is to use Run Once dialog and attach the installation CD, and use "Start in paused mode" and/or "Enable boot menu" to allow you to select the boot media (CD) once. For this purpose the layout was change a bit and these options are now right next to the Attach CD dropdown
 - [BZ 1150239](https://bugzilla.redhat.com/1150239) <b>[RFE] [pre-4.0] Model memory volumes as disks in the database/backend</b><br>
 - [BZ 1194989](https://bugzilla.redhat.com/1194989) <b>[RFE] Provide option to remove / replace base template while template sub-version exists</b><br>Previously it was only possible to remove base template if there were to template sub-version based on it.<br><br>These patches allows to remove a base template even if there are some template sub-version based on it. The sub-version with lowest version number become the next base template for all other sub-version. Version number are not touched. I.e. Version number of base template no longer needs to be 1.
 - [BZ 1296558](https://bugzilla.redhat.com/1296558) <b>v2v:sort the list of VMs by name</b><br>Feature: <br>In the "Import Virtual Machine(s)" dialog both lists of VMs are now sorted in an alphabetically order.<br>Reason: <br>VMs listed under "virtual machines on source"/"virtual machines to import" were not listed by any logical order. <br>Result: <br>VMs listed under "virtual machines on source"/"virtual machines to import" are now sorted.<br>in an alphabetically order by VM name (the same order as displayed in the Storage->VM Import list).<br>Lists remain sorted even after dragging VMs from list to list.
 - [BZ 1304346](https://bugzilla.redhat.com/1304346) <b>[RFE] Prepare a method to compute (guess) the required memory for starting a VM</b><br>
 - [BZ 1264767](https://bugzilla.redhat.com/1264767) <b>[RFE] Enforce a specific(latest) spice client version</b><br>Feature: enforce minimal version of remote-viewer <br><br>Enforces the minimal version of remote-viewer to versions:<br>windows: 2.0-128<br>rhel7: 2.0-6<br>rhel6: 2.0-14<br><br>If the remote-viewer is older than the specified one, remote-viewer will show a link to documentation describing how to update.
 - [BZ 1302657](https://bugzilla.redhat.com/1302657) <b>[RFE] Switch from vnc/cirrus to vnc/vga</b><br>Feature: Default VNC graphics is VGA in 4.0<br><br>Imported VMs with VNC/Cirrus and originating in previous compatibility versions are automatically upgraded to VNC/VGA.<br><br>The user can still switch the VNC graphics to Cirrus if needed.<br><br>No matter of this change, the QXL shall be preffered as default graphics if the guest OS supports it.
 - [BZ 1121653](https://bugzilla.redhat.com/1121653) <b>[RFE] "Open in full screen" checkbox should be controlled by a global setting in "rhevm-config"</b><br>Feature: Configure default for Console's Open In Fullscreen<br><br>Reason: Open In Fullscreen default behavior shall be configurable by user.<br><br>Result: Using engine-config, the user can set weather the console's window is going to be open in full screen by default. <br>The value can be set independently for Administrtion Portal, Basic User portal, Extended User Portal.<br>Console retrieved via REST shares setting with the Administration Portal.<br><br>Default can be set via engine-config by setting FullScreenWebadminDefault, FullScreenUserportalBasicDefault, FullScreenUserportalExtendedDefault options.
 - [BZ 1208860](https://bugzilla.redhat.com/1208860) <b>Template versions have non-unique name in Disk tab</b><br>Feature: The Disk Tab displays template version along with its name.<br><br>Reason: There was confusion in listing of template disks, since just the name of a template was displayed.<br><br>Result: Improved user experience. User can simply decide which template version the disk belongs to.
 - [BZ 1253710](https://bugzilla.redhat.com/1253710) <b>[RFE] Add template methods to work with Cloud-Init/Sysprep settings through RHEVM API</b><br>Cloud-init and sysprep are now can be added via REST API
 - [BZ 1316077](https://bugzilla.redhat.com/1316077) <b>[RFE] Mention the vcenter hierarchy at Data Center option when import guest from vmware in rhevm</b><br>There is an '?' (question mark) near the data-center field that explain that folder can be in data-center as well:<br>e.g:<br>mydatacenter<br>or<br>mydatacenter/myfolder
 - [BZ 1273025](https://bugzilla.redhat.com/1273025) <b>User portal's permission tab offers to add permissions which cannot be added</b><br>Feature: User portal lists only roles which can be actually assigned.<br><br>Reason: All roles were displayed causing user's confusion.<br><br>Result: Improved user experience.
 - [BZ 1313295](https://bugzilla.redhat.com/1313295) <b>[RFE] noVNC: Include VM name in the web page title instead of "noVNC" title.</b><br>Feature: Include VM name into the title of both noVNC and SPICE HTML5 windows.<br><br>Reason: Since the noVNC always had a title "noVNC", it was hard to know which VM is this console connected to. The same goes for the SPICE HTML5 window which had a title "Spice Javascript Client".<br><br>Result: The title of the noVNC window is now: <br>\<vm name\> - noVNC<br>The title of the SPICE HTML5 window is now: <br>\<vm name\> - Spice Javascript Client
 - [BZ 1310804](https://bugzilla.redhat.com/1310804) <b>[RFE] Override instance type on VmPools in Python-SDK</b><br>Feature: <br>add instance type support for REST API for vm pools<br><br>Reason: <br>It can be set in webadmin/userportal but it was missing from the REST API and from the SDKs<br><br>Result: <br>Now it is possible to set the instance type also from the REST API/SDKs
 - [BZ 1285446](https://bugzilla.redhat.com/1285446) <b>Random sub-template of given name is used to create VM Pool via REST</b><br>Feature: The latest template version is used within VM creation via REST when just the template name (or Blank) is provided.<br><br>Reason: Prior this enhancement, the template version had to be specified in the REST create VM command explicitly or a random version was selected otherwise.<br><br>Result: The user can rely on default template version selection when creating VM via REST.

##### Team: Storage

 - [BZ 1317253](https://bugzilla.redhat.com/1317253) <b>[RFE] Disk image uploader in the GUI</b><br>This feature is an addition for the webadmin, and it lets users to upload VM disks from their PC to oVirt's storage, and use it with oVirt's VMs.<br>For doing that, the user needs to press the "upload" button, which is located in both Storage->Disks tab, and Disks main tab.<br>The user will need to choose a file for uploading, enter the disk's virtual size, and press "ok". The chosen file needs to be a QEMU compatible image file, that can be connected to QEMU VMs. <br>Note that ovirt-imageio-proxy project needs to be installed alongside ovirt-engine for this feature to work.
 - [BZ 1142762](https://bugzilla.redhat.com/1142762) <b>[RFE][Tracker][CodeChange] Refactor Disks' class hierarchy</b><br>
 - [BZ 1317434](https://bugzilla.redhat.com/1317434) <b>[RFE] Implement live merge of auto-generated snapshot and backing file after live storage migration</b><br>Feature: <br>Remove auto-generated snapshot after LSM<br><br>Reason: <br>During LSM, an auto-generated snapshot is created and it has to be manually removed after LSM<br><br>Result: <br>The auto-generated snapshot is automatically deleted after LSM
 - [BZ 1138139](https://bugzilla.redhat.com/1138139) <b>[RFE][ImportDomain] Adding a button to import floating and unregistered disks</b><br>Feature: <br>Register unregistered floating disks through the GUI.<br><br>Reason: <br>Since floating disks are not part of any VM/Template, the user can't register floating disks explicitly from the GUI but only from the REST.<br><br>Result:<br>Added a subtab in the GUI called "Import Disk" which support the ability toe register a floating disk into the setup.<br><br>A storage domain also supports a functionality called "Scan Disks" which scans the Storage Domain for unregistered floating disks that are not reflected in the setup.<br>This can be much helpful for managing underline copies of disks from an external Storage Domain.
 - [BZ 1282764](https://bugzilla.redhat.com/1282764) <b>[RFE][scale] Visualize the number of queued SPM calls on RHEV-M in the logs</b><br>
 - [BZ 1275182](https://bugzilla.redhat.com/1275182) <b>[RFE]Email notification when the number of LVs in SD are reaching/more than 300</b><br>Previously, when the number of LVs in a storage domain reached the recommended maximum, we logged it and a message was shown in the events pane.<br>Now, one can register to the event notifier and get an email when it happens.
 - [BZ 1336214](https://bugzilla.redhat.com/1336214) <b>Implement live merge of auto-generated snapshot and backing file after LSM fails</b><br>This update ensures that the auto-generated snapshot that is created during live storage migration (LSM) is automatically deleted if LSM fails.
 - [BZ 1271988](https://bugzilla.redhat.com/1271988) <b>[RFE] Add support for qcow2 disks, adding the ability to choose qcow2 disk format when creating a VM from template.</b><br>Feature: <br>When creating a Vm from a template, the user is able to choose the Volume Format of the disks : either Raw or QCOW2.<br><br>Reason: <br>The user wants to be able to specify the volume format of the disks when creating a template based VM.<br><br>Result: <br>When creating a Vm from a template, the user is able to choose the Volume Format of the disks : either Raw or QCOW2.<br>The Allocation Policy is now hidden.<br>If the Template Provisioning is Thin, the volume format of the disks will be marked as QCOW2 and the user won't be able to change it.<br>If the Template Provisioning is Clone, the user will be able to choose the volume format (QCOW2 or Raw)
 - [BZ 1279398](https://bugzilla.redhat.com/1279398) <b>[RFE] [admin portal] Sort ISOs from ISO domain in lists in natural (version) sort order</b><br>Feature:<br>Sort ISO domain files while taking into consideration version numbers.<br><br>Reason:<br>Up until now, the files were ordered alphabetically, i.e a file named RHEV_3.5.10.iso used to come before a file named RHEV_3.5.5.iso.<br>This feature sorts the files alphabetically, but while taking into consideration the version numbers.<br><br>Result:<br>A file named RHEV_3.5.10.iso will come after a file named RHEV_3.5.5.iso and not before it.
 - [BZ 1271698](https://bugzilla.redhat.com/1271698) <b>Change terminology from "virtual machine disk" to "virtual disk"</b><br>
 - [BZ 1176217](https://bugzilla.redhat.com/1176217) <b>[RFE] Rename "Edit" button in Storage Domains tab to "Manage Domain"</b><br>
 - [BZ 1240954](https://bugzilla.redhat.com/1240954) <b>[RFE][webadmin-portal] Cannot override template's name when importing an image as template from glance</b><br>It is now possible to specify a custom name for the template when importing a Glance disk through the Web Admin portal.
 - [BZ 1308350](https://bugzilla.redhat.com/1308350) <b>[SCALE] Improve GetDeviceList verb call through the REST API to work in scale.</b><br>Adding support for skipping the LUN status check in the REST API.<br>Checking the status of the LUN is a heavyweight operation and this data is not always needed by the user.<br><br>The default is `true` for backward compatibility.<br>The parameter `report_status` is available both on getting the list of a host storages or a specific host storage<br>

##### Team: Gluster

 - [BZ 1205641](https://bugzilla.redhat.com/1205641) <b>[RFE][HC] - Monitor if self-heal is ongoing on a gluster volume</b><br>Feature: Monitor Self-Heal for gluster volumes.<br><br>Reason: For a replicate volume, the engine should monitor if self-heal is ongoing on a volume. There should be an indication in the UI for self-heal activity.<br><br>Result: Ovirt will monitor the unsycned entries(which needs healing) in all the replicate  volumes. Unsynced entries will be shown in the bricks sub per brick with expected time to heal the entries. There will be a warning icon added to the volume and bricks status column when there is a unsynced entry.
 - [BZ 1213309](https://bugzilla.redhat.com/1213309) <b>[RFE][HC] - Support replace brick from UI</b><br>Feature: Support replacing brick from engine for replicate type gluster volumes<br><br>Reason: Required to perform maintenance of gluster volumes/host from UI
 - [BZ 1182363](https://bugzilla.redhat.com/1182363) <b>[RFE][HC] - when creating a glusterfs volume unsupported volume types should be hidden in the downstream product</b><br>Feature: Show only supported volume types while managing volumes from engine<br><br>Reason: We do not want users to end up with unsupported configurations

##### Team: Infra

 - [BZ 1296274](https://bugzilla.redhat.com/1296274) <b>[RFE] Login page have a configurable default</b><br>A new config variable 'ovirt.engine.aaa.authn.default.profile' has been added to authn configuration files. Adding this to authn configuration file for selected profile and setting the value to true, will ensure that the first time a user is redirected to the login page the profile marked as default will be selected from the drop down list.<br><br>ovirt.engine.aaa.authn.default.profile=true<br><br>ovirt-engine service needs to be restarted after adding this value to selected authn configuration files.<br><br>If no authn extension has been configured to be the default profile, then internal authn is used as default.
 - [BZ 1284903](https://bugzilla.redhat.com/1284903) <b>[RFE] Command Infrastructure - support flows</b><br>
 - [BZ 1318746](https://bugzilla.redhat.com/1318746) <b>[RFE] Sessions tab: improve usability</b><br>New fields have been added to session tab in webadmin to show the client ip address, the session start time and the session last access time.
 - [BZ 1197449](https://bugzilla.redhat.com/1197449) <b>[RFE] add source_ip to the sessions table</b><br>New column 'Source IP' was added into Active Users Sessions view, to be able to identify client host from which users connects to engine
 - [BZ 1092744](https://bugzilla.redhat.com/1092744) <b>[RFE][AAA] Introduce uniform login services</b><br>A single sign on module has been added that authenticates the user once and allows access to webadmin and userportal. Signing off from one portal closes the session on SSO and the user is logged out of all portals.
 - [BZ 1199933](https://bugzilla.redhat.com/1199933) <b>[RFE] Add Fencing of Ilo3/4 via ssh fencing to RHEV-M</b><br>Feature: <br>Add Fencing of Ilo3/4 via ssh fencing<br><br>Reason: <br>Customer requirement <br><br>Result: <br>Fencing of Ilo3/4 via ssh is supported
 - [BZ 1346218](https://bugzilla.redhat.com/1346218) <b>Include the API HTML documentation</b><br>Feature: <br><br>Include the API HTML documentation in the server.<br><br>Reason: <br><br>Currently the API HTML documentation is automatically generated from the specification of the API, but it isn't available in the live server, using it requires going to a different web site.<br><br>Result: <br><br>The API HTML documentation will be available from any live engine, from the /ovirt-engine/api/model URL, so that users won't need to go to a different server to obtain it.
 - [BZ 1322940](https://bugzilla.redhat.com/1322940) <b>[RFE] AAA - Make Kerberos work with Java Authentication Framework</b><br>Provide a way how to configure gssapi using ticket cache for authz pool.<br>
 - [BZ 1083661](https://bugzilla.redhat.com/1083661) <b>[RFE] display cluster compatibility version for host</b><br>'Cluster Compatibility Version' field, which shows cluster version supported by the host, were added into Hosts view, General Tab, Info subtab
 - [BZ 1037844](https://bugzilla.redhat.com/1037844) <b>[RFE][AAA] Allow the user to change an expired password as a part of the User Portal login process</b><br>Previously if the user password has expired they needed to be set on the ldap server. Now there is a new capability added to the ldap and jdbc extensions to enable changing passwords from the front end in a new change password screen.
 - [BZ 1223732](https://bugzilla.redhat.com/1223732) <b>[RFE] Add authz provider column for user session management</b><br>Feature: <br>User session management.<br><br>Reason: <br>There was no authz information for users in session management table, so we were not able to distinguish between two users with the same name from two different profiles (domains).<br><br>Result: <br>In session management table, users can now see authz provider name where users belongs.
 - [BZ 1250102](https://bugzilla.redhat.com/1250102) <b>[RFE] - Show user/group icons in search results for users</b><br>
 - [BZ 1290737](https://bugzilla.redhat.com/1290737) <b>[AAA] add credentials modify sequence</b><br>
 - [BZ 1273041](https://bugzilla.redhat.com/1273041) <b>[RFE] extend Permission tab with list of 'My groups'</b><br>The add permissions dialog now has a new radio button "My Groups" which lists the currently logged in user's groups. The user can use this option to grant permissions to other users in his group.
 - [BZ 1060791](https://bugzilla.redhat.com/1060791) <b>[RFE] Cleanup, remove IP information guest_info section from VM resource</b><br>

##### Team: i18n

 - [BZ 1110577](https://bugzilla.redhat.com/1110577) <b>[RFE] introduce Italian</b><br>The product is now translated also to Italian.

##### Team: Integration

 - [BZ 1318580](https://bugzilla.redhat.com/1318580) <b>[RFE] restore: ensure that 3.6 backup can be restored on clean 4.0</b><br>Feature: <br><br>Allow engine-backup of version 4.0 to restore backups taken on 3.6.<br><br>Reason: <br><br>engine 4.0 does not support el6. Users that want to upgrade from 3.6 on el6 to 4.0 on el7 have to do this by backing up the engine on 3.6/el6 and restore on 4.0/el7.<br><br>Result: <br><br>Using this flow, it's possible to migrate a 3.6/el6 setup to 4.0/el7:<br><br>On the existing engine machine run:<br>1. engine-backup --mode=backup --file=engine-3.6.bck --log=backup.log<br><br>On a new el7 machine:<br>2. Install engine 4.0, including dwh if it was set up on 3.6.<br>3. Copy engine-3.6.bck to the el7 machine<br>4. engine-backup --mode=restore --file=engine-3.6.bck --log=restore.log --provision-db --no-restore-permissions<br>5. engine-setup<br><br>Check engine-backup documentation for other options, including using remote databases, extra grants/permissions, etc.<br><br>Notes:<br><br>1. As of writing this doc-text, Reports is not built for 4.0. If/when it will be, need to update.<br>2. You (doc team) probably want to add relevant material to the main docs.<br><br>See also:<br>https://bugzilla.redhat.com/show_bug.cgi?id=1323201<br>https://bugzilla.redhat.com/show_bug.cgi?id=1319457
 - [BZ 1216888](https://bugzilla.redhat.com/1216888) <b>[RFE] engine-backup should not depend on the engine</b><br>In order to allow backup of machines running ovirt services, but not running ovirt-engine, the engine-backup script does not depends on ovirt-engine anymore.
 - [BZ 1318665](https://bugzilla.redhat.com/1318665) <b>[RFE] - make DWH required for engine.</b><br>
 - [BZ 1267508](https://bugzilla.redhat.com/1267508) <b>[RFE] Replace python-cheetah with python-jinja2 within ovirt-engine</b><br>Replaced python-cheetah with python-jinja2 as template-engine for services configuration files, as python-cheetah didn't receive updates since 2012 and is not available on RHEL 7.2.
 - [BZ 1218674](https://bugzilla.redhat.com/1218674) <b>[RFE][TEXT] - During restore alert user that objects might be missing in the system afterwards.</b><br>

##### Team: DWH

 - [BZ 1328805](https://bugzilla.redhat.com/1328805) <b>[RFE] Add option to run DWH in a "minimal" mode for collecting data for the dashboards</b><br>
 - [BZ 1327012](https://bugzilla.redhat.com/1327012) <b>[RFE] Remove dwh_datacenter_history_view from engine db</b><br>

##### Team: SLA

 - [BZ 1254818](https://bugzilla.redhat.com/1254818) <b>[RFE] : Need  VM affinity rule for "hypervisor pools" within a cluster</b><br>Feature: <br><br>Affinity label support was added to REST aPI for hosts and VMs. A VM can only be scheduled on a host that is labelled with all the affinity labels the VM has. Any extra labels on the host make no difference.<br><br>Reason: <br><br>There are many use cases where a sub-cluster is needed. Server locality, licensing agreements (number of nodes with certain software), special hardware...<br><br>Result: <br><br>It is possible to use REST API to manipulate affinity labels and assign them to hosts and VMs.
 - [BZ 1167262](https://bugzilla.redhat.com/1167262) <b>[RFE][Tracker] Hosted-Engine: allow to deploy additional hosts from webadmin portal</b><br>Feature: Deploy or Undeploy additinonal HE hosts via the engine<br><br>Reason: 1. ease of management, deployment 2.make the deployment more scriptable 3. hold a single source of info on the cluster members (specifically host ids) and the deployment attributes. <br><br>Result: After the HE setup is passed bootstrap, i.e HE is imported into the engine, it is possible to add/remove the HE functionality to a host using both the UI or the REST API
 - [BZ 1201482](https://bugzilla.redhat.com/1201482) <b>Storage QoS is not applying on a Live VM/disk</b><br>Feature: <br><br>MOM now knows how to read the IO QoS settings from metadata and set the respective ioTune limits to a running VM's disk.<br><br>Reason: <br><br>This feature is needed to properly support disk hotplug and changes to disk QoS for an already running VM.<br><br>Result: <br><br>MOM properly processes disk QoS updates and the limits are updated.
 - [BZ 1308861](https://bugzilla.redhat.com/1308861) <b>[RFE] Indicate which host is running the HE VM</b><br>A visual indicator has been added to the Hosts tab of the Administration Portal to identify the host running the self-hosted engine Manager virtual machine in self-hosted engine installations.

##### Team: Network

 - [BZ 1314375](https://bugzilla.redhat.com/1314375) <b>[RFE] - Provide external network partners API</b><br>This feature introduces changes to the existing Openstack Network Providers allowing to add any external provider which implements the Openstack API.<br>The external providers must implement the Openstack Neutron rest API, which is used by the engine to communicate with the provider. <br>The external provider does not use the Neutron agent as the virtual interface driver implementation on the host. Instead the virtual interface driver should be provided by the implementor of the external provider.<br><br>A reference implementation of an external provider and a virtual interface driver is available at: https://github.com/mmirecki/ovirt-provider-mock<br><br>The feature also adds a "read-only" feature to network providers. This prevents the user from changing the provider from ovirt. No networks or subnets can be added/modified/deleted. <br><br>The feature page for this bug: /develop/release-management/features/external-network-provider/
 - [BZ 1317441](https://bugzilla.redhat.com/1317441) <b>[RFE] Allow MAC Anti-Spoofing per interface instead of globally</b><br>
 - [BZ 1277495](https://bugzilla.redhat.com/1277495) <b>remove the pre-3.6 setupnetworks api</b><br>

#### VDSM

##### Team: Virt

 - [BZ 1252426](https://bugzilla.redhat.com/1252426) <b>[RFE] Migration improvements (convergence, bandwidth utilization)</b><br>Tab 'Resilience policy' in Cluster dialogs was renamed to 'Migration'. The content of the tab remains part of 'Migration' dialog.
 - [BZ 1301104](https://bugzilla.redhat.com/1301104) <b>[RFE] Automate configuration of host's boot parameters to support VFIO passthrough</b><br>In the past, any modification to kernel command line had to be executed and maintained by administrators. The process was even more difficult in ovirt-node/RHEVH, where the filesystem had to be (manually) remounted as writable to even do the change.<br><br>This feature adds new UI selection when adding or editing a host that allows for kernel line modifications directly from web administration. These changes are then maintained by oVirt/RHEV.<br>Supported modifications are supported as checkboxes, but we also allow free text entry for more complex modifications (e.g. pci-stubbing GPU devices etc.).
 - [BZ 1270581](https://bugzilla.redhat.com/1270581) <b>[RFE] Hostdev_passthrough: support SCSI FC tape device</b><br>Previously, oVirt/RHEV only allowed hostdev passthrough of USB and PCI devices. To assign storage cards directly to VM, users had to assign the whole adapter as PCI device. The problem with this approach is that PCI passthrough has specific hardware requirements.<br><br>This feature allows administrators to passthrough a LUN directly to a VM, allowing for full set of SG commands - meaning tapes, changers and anything speaking SCSI protocol can be assigned directly, without specific hardware requirements (except for assigned device itself).
 - [BZ 1298120](https://bugzilla.redhat.com/1298120) <b>[RFE] Support for hooks in the guest agent</b><br>Doc Text in https://bugzilla.redhat.com/show_bug.cgi?id=1287544
 - [BZ 1273399](https://bugzilla.redhat.com/1273399) <b>[RFE] Support for reporting Docker containers active on the Virtual Machine</b><br>Feature: Reporting running docker containers from within guest operating systems managed by oVirt in the oVirt Webadmin Portal<br><br>With this feature the webadmin portal reports now the id, image, executed command, state and the names of the container.
 - [BZ 1324375](https://bugzilla.redhat.com/1324375) <b>[RFE] Use 10s timeout for boot menu</b><br>Boot menu timeout was increased to 10 seconds. This should make the boot menu more accessible when pause mode is not enabled.

##### Team: Infra

 - [BZ 1182092](https://bugzilla.redhat.com/1182092) <b>[RFE] Make plug-able API for supervdsm</b><br>

##### Team: Network

 - [BZ 1334745](https://bugzilla.redhat.com/1334745) <b>[RFE] Add hook to handle FCOE storages</b><br>Feature: configure fcoe on host NIC<br><br>Reason: RHEV can consume FCoE block storage. Depending on the FCoE card on the hosts, special configuration may be needed as described in https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/fcoe-config.html<br><br>Result: to enable fcoe on a NIC, attach a network to it, and set the "fcoe" network custom property to enable=yes[,dcb=yes][,auto_vlan=yes]
 - [BZ 1334748](https://bugzilla.redhat.com/1334748) <b>[RFE] Add hook to handle FCOE storages</b><br>Feature: configure fcoe on host NIC<br><br>Reason: RHEV can consume FCoE block storage. Depending on the FCoE card on the hosts, special configuration may be needed as described in https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/fcoe-config.html<br><br>Result: to enable fcoe on a NIC, attach a network to it, and set the "fcoe" network custom property to enable=yes[,dcb=yes][,auto_vlan=yes]
 - [BZ 1234328](https://bugzilla.redhat.com/1234328) <b>[RFE] SR-IOV --> add support for Hotplug/unplug of VFs</b><br>Feature: hotplug (and hot unplug) SR-IOV vNICs to running VM<br><br>Reason: RHEV-3.6 introduced passthrough of SR-IOV VFs to newly-created VMs, but was unable to attach such a VF to a running VM<br><br>Result: RHEV-4.0 allows to add and to remove VFs

##### Team: SLA

 - [BZ 1201482](https://bugzilla.redhat.com/1201482) <b>Storage QoS is not applying on a Live VM/disk</b><br>Feature: <br><br>MOM now knows how to read the IO QoS settings from metadata and set the respective ioTune limits to a running VM's disk.<br><br>Reason: <br><br>This feature is needed to properly support disk hotplug and changes to disk QoS for an already running VM.<br><br>Result: <br><br>MOM properly processes disk QoS updates and the limits are updated.

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1324923](https://bugzilla.redhat.com/1324923) <b>[RFE] hosted-engine --vm-status should be able to output the raw response</b><br>Feature: hosted-engine --vm-status should be able to output the raw response<br><br>Reason: <br><br>Result:
 - [BZ 1324921](https://bugzilla.redhat.com/1324921) <b>[RFE] hosted-engine should have a flag to check whether the engine is deployed</b><br>Feature: hosted-engine should have a flag to check whether the engine is deployed<br><br>Reason: <br><br>Result:
 - [BZ 1228641](https://bugzilla.redhat.com/1228641) <b>[RFE] Switch from XML-RPC to JSON-RPC API for HE setup</b><br>XmlRpc is going to be deprecated by JsonRpc. Moving to the new API.

#### oVirt Hosted Engine HA

##### Team: SLA

 - [BZ 1324673](https://bugzilla.redhat.com/1324673) <b>Include hostname in ovirt-ha-agent emails</b><br>Feature: Include hosted-engine hostname in ovirt-ha-agent emails<br><br>Reason: The e-mails were not cleared about the hosted engine host.<br><br>Result: The email body will look like that: <br>Hosted engine host: {hostname} changed state: {detail}.

#### oVirt Engine DWH

##### Team: DWH

 - [BZ 1328805](https://bugzilla.redhat.com/1328805) <b>[RFE] Add option to run DWH in a "minimal" mode for collecting data for the dashboards</b><br>
 - [BZ 1302598](https://bugzilla.redhat.com/1302598) <b>[RFE] Add to ovirt_engine_history views that simplifies users usage of dwh views</b><br>Feature: <br>Added for each time period (sample/hourly/daily) views that join the configuration views with statistics views of the entities it relates to, like network interface and disks.<br><br>Reason: <br>In order to simplify the use of views for the users.<br><br>Result: <br>3 new views for vms and 3 new views for hosts.
 - [BZ 1324440](https://bugzilla.redhat.com/1324440) <b>[RFE] Add log message with the Application Settings</b><br>Feature: <br>A log message with the dwh application settings, that can be updated by the user, was added to the log file.<br>The log is added each time the dwh is started.<br><br>Reason: <br>Add better way to debug and monitor the dwh settings. <br><br>Result:
 - [BZ 1302611](https://bugzilla.redhat.com/1302611) <b>[RFE] - Upgrade the Talend to latest version that supports OpenJDK 1.8.</b><br>
 - [BZ 1285788](https://bugzilla.redhat.com/1285788) <b>[RFE] Enable logging of dwh ETL process in debug mode</b><br>Feature:<br>We added a DEBUG mode for logging of Sampling, Hourly and Daily jobs time.<br><br>In order to start DEBUG mode, you should add a conf file and set DWH_AGGREGATION_DEBUG=true. <br><br>Reason:<br>In order to debug the Sampling, Hourly and Daily jobs.<br><br>Result:<br>The ovirt-engine-dwhd.log will include the start and wnd of each job.<br><br>This is usually for qa only.

##### Team: Integration

 - [BZ 1318665](https://bugzilla.redhat.com/1318665) <b>[RFE] - make DWH required for engine.</b><br>

#### oVirt Setup Lib

##### Team: Integration

 - [BZ 1328776](https://bugzilla.redhat.com/1328776) <b>Show the question key when dumping the env vars</b><br>ovirt-setup-lib now includes the question keys when dumping environment variables to logs.

#### oVirt vmconsole

##### Team: Virt

 - [BZ 1328854](https://bugzilla.redhat.com/1328854) <b>[RFE] provide alphabetic order when displaying available vm consoles</b><br>

#### oVirt Log collector

##### Team: Integration

 - [BZ 1294984](https://bugzilla.redhat.com/1294984) <b>[RFE][TEXT] - add warning when running log collector without filters.</b><br>In order to avoid collecting hours of log collection in large scale environments, ovirt-log-collector now shows a warning if called without any filters.

#### oVirt Engine SDK Ruby

##### Team: Infra

 - [BZ 1291365](https://bugzilla.redhat.com/1291365) <b>[RFE] Create a Ruby SDK for the oVirt API</b><br>Feature: Ruby SDK for the oVirt API is now available<br><br>Reason: <br><br>Result:

#### oVirt Host Deploy

##### Team: Virt

 - [BZ 1301104](https://bugzilla.redhat.com/1301104) <b>[RFE] Automate configuration of host's boot parameters to support VFIO passthrough</b><br>In the past, any modification to kernel command line had to be executed and maintained by administrators. The process was even more difficult in ovirt-node/RHEVH, where the filesystem had to be (manually) remounted as writable to even do the change.<br><br>This feature adds new UI selection when adding or editing a host that allows for kernel line modifications directly from web administration. These changes are then maintained by oVirt/RHEV.<br>Supported modifications are supported as checkboxes, but we also allow free text entry for more complex modifications (e.g. pci-stubbing GPU devices etc.).

##### Team: Integration

 - [BZ 1200469](https://bugzilla.redhat.com/1200469) <b>[RFE] add support for hosted-engine deployment on additional hosts</b><br>Feature: support for hosted-engine deployment on additional hosts has been added to ovirt-host-deploy<br><br>Reason: to ease hosted-engine additional node deployment<br><br>Result: ovirt-engine can now use ovirt-host-deploy for deploying hosted engine additional nodes

#### OTOPI

##### Team: Integration

 - [BZ 1216888](https://bugzilla.redhat.com/1216888) <b>[RFE] engine-backup should not depend on the engine</b><br>In order to allow backup of machines running ovirt services, but not running ovirt-engine, the engine-backup script does not depends on ovirt-engine anymore.
 - [BZ 1336250](https://bugzilla.redhat.com/1336250) <b>[RFE] The machine dialog format for hosted-engine-setup should set a flag if it's a field which should be masked</b><br>

#### Cockpit oVirt

##### Team: Node

 - [BZ 1318415](https://bugzilla.redhat.com/1318415) <b>[RFE] [Cockpit] Add Hosted Engine status to dashboard</b><br>
 - [BZ 1334651](https://bugzilla.redhat.com/1334651) <b>[RFE] Should not change the virtual machines count every times when enter dashboard page</b><br>

### Deprecated Functionality

#### oVirt Engine

##### Team: Virt

 - [BZ 1316560](https://bugzilla.redhat.com/1316560) <b>[RFE] remove the plugin support for spice connection</b><br>The Spice plugin is not supported in Red Hat Enterprise Virtualization 4.0. The 'Native' spice connection should be used as a replacement.<br><br>If 'Plugin' is set as the default for Spice connections by user (via engine-config), it is automatically switched to 'Native' by calling engine-setup during upgrade.
 - [BZ 1337055](https://bugzilla.redhat.com/1337055) <b>[RFE] deprecate Legacy USB</b><br>The Legacy USB option has been deprecated and will be removed in the next Red Hat Enterprise Virtualization version. The functionality has been superseded by "Native" with the UsbDk drivers (available since Red Hat Enterprise Virtualization 3.6).

##### Team: Storage

 - [BZ 1320515](https://bugzilla.redhat.com/1320515) <b>Remove deprecated api/vms/<id>/move</b><br>The "/vms/<vmid>/move" API has been removed after being deprecated in Red Hat Enterprise Virtualization 3.1.

##### Team: UX

 - [BZ 1236976](https://bugzilla.redhat.com/1236976) <b>[RFE] UIPlugins should not use restapi http session</b><br>The user interface (UI) code is now aligned with the Manager's SSO infrastructure by dropping reliance on the REST webapp's HTTP session mechanism in favor of using SSO tokens.<br><br>This impacts, and potentially breaks all UI plugins because the "RestApiSessionAcquired" callback has been removed.<br><br>From now on, UI plugins should use the new "api.ssoToken" function when authenticating Manager (e.g. REST API) requests:<br><br>  var xhr = new XMLHttpRequest();<br>  xhr.open('GET', 'http://example.com/ovirt-engine/api');<br>  xhr.setRequestHeader('Authorization', 'Bearer ' + api.ssoToken());<br>  xhr.setRequestHeader('Accept', 'application/json');<br>  xhr.addEventListener('load', function () {<br>    // response loaded OK, parse JSON data<br>    var data = JSON.parse(this.responseText);<br>  });<br>  xhr.send();<br><br>The UI plugins no longer need to use session-specific request headers like "Prefer:persistent-auth" and "JSESSIONID:xxx", which simplifies their code.

##### Team: Integration

 - [BZ 1282798](https://bugzilla.redhat.com/1282798) <b>Drop All-in-One support</b><br>All-In-One setup support has been dropped in favor of Hosted Engine.

#### oVirt Engine DWH

##### Team: DWH

 - [BZ 1323605](https://bugzilla.redhat.com/1323605) <b>[RFE] Remove collection from dwh_disk_vm_map_history_view</b><br>The collection from the Manager view dwh_disk_vm_map_history_view was replaced by the collection from dwh_vm_device_history_view on Red Hat Enterprise Virtualization 3.1,  but was not removed to ensure legacy compatibility.<br><br>In Red Hat Enterprise Virtualization 4.0, legacy compatibility will be for Red Hat Enterprise Virtualization 3.6 only. Therefore, the following has now been removed:<br>- The collection of disks_vm_map.<br>- disks_vm_map table from the history database.<br>- dwh_vm_disk_configuration_history_view from the Manager database.
 - [BZ 1300328](https://bugzilla.redhat.com/1300328) <b>[RFE] Remove collection of data centers statistics</b><br>Removed data center statistic tables and views which provided meaningless status statistics.

#### oVirt Image Uploader

##### Team: Integration

 - [BZ 1306637](https://bugzilla.redhat.com/1306637) <b>ovirt-image-uploader should warn it's deprecated and will be removed in next version</b><br>The ovirt-image-uploader tool has been deprecated in Red Hat Virtualization 4.0, and will be removed in Red Hat Virtualization 4.1.

#### oVirt Host Deploy

##### Team: Integration

 - [BZ 1314790](https://bugzilla.redhat.com/1314790) <b>Drop ovirt-host-deploy-offline</b><br>The ovirt-host-deploy-offline package will no longer be available in Red Hat Virtualization 4.0

### Release Note

#### oVirt Engine

##### Team: UX

 - [BZ 1285432](https://bugzilla.redhat.com/1285432) <b>[RFE] Expose global alert messages via UI plugin API</b><br>New UI plugin API function `showAlert` has been added, allowing UI plugins to show "global" alert boxes in top center part of the WebAdmin UI.<br><br>This can be useful when a UI plugin wants to inform the user about some important event. The `showAlert` function supports different alert types (danger, warning, success, info) as well as optional auto-hide after given time period.

### No Doc Update

#### oVirt Engine

##### Team: Virt

 - [BZ 1342795](https://bugzilla.redhat.com/1342795) <b>Starting a VM from Pool from userportal hangs on stateless snapshot creation</b><br>undefined

##### Team: Network

 - [BZ 1325978](https://bugzilla.redhat.com/1325978) <b>Not possible to change the boot protocol from static ip to dhcp via ui</b><br>undefined

#### oVirt Hosted Engine Setup

##### Team: Node

 - [BZ 1332927](https://bugzilla.redhat.com/1332927) <b>The hosted engine deploy via appliance failed on the engine-setup stage</b><br>undefined

##### Team: Integration

 - [BZ 1318652](https://bugzilla.redhat.com/1318652) <b>hosted-engine deploy failure: 'module' object has no attribute 'Ssh'</b><br>undefined

### Unclassified

#### oVirt Engine

##### Team: Virt

 - [BZ 1339287](https://bugzilla.redhat.com/1339287) <b>REST API vmpool increase won't join domain</b><br>When adding VMs to an existing VM-Pool via the API the VMs didn't got the right initialized parameters (for sysprep/cloud-init).
 - [BZ 1339668](https://bugzilla.redhat.com/1339668) <b>can not create Vm in userportal</b><br>An exception in power user portal's new VM dialog prevented the user from creating a new VM.
 - [BZ 1339538](https://bugzilla.redhat.com/1339538) <b>Cluster->migration tab fixes</b><br>
 - [BZ 1338834](https://bugzilla.redhat.com/1338834) <b>Option to override cluster migration policy in vm level is absent</b><br>
 - [BZ 1342818](https://bugzilla.redhat.com/1342818) <b>Unmanaged VMs are added without the host they run on</b><br>
 - [BZ 1339649](https://bugzilla.redhat.com/1339649) <b>division by zero in user portal Resources tab</b><br>
 - [BZ 1338723](https://bugzilla.redhat.com/1338723) <b>v2v: import dialog - few fields are not aligned in place</b><br>
 - [BZ 1341145](https://bugzilla.redhat.com/1341145) <b>Internal engine error when editing cluster if there is an external VM</b><br>
 - [BZ 1343134](https://bugzilla.redhat.com/1343134) <b>Host dialog > Kernel cmdline typo</b><br>
 - [BZ 1338740](https://bugzilla.redhat.com/1338740) <b>v2v: import dialog - moving VMs between lists got stuck after a while</b><br>
 - [BZ 1338843](https://bugzilla.redhat.com/1338843) <b>Name of migration policy 'safe but not may not converge' is not clear</b><br>
 - [BZ 1339539](https://bugzilla.redhat.com/1339539) <b>The current kernel cmd line is not reported</b><br>

##### Team: UX

 - [BZ 1342098](https://bugzilla.redhat.com/1342098) <b>vm_disk_size_mb equals zero causes the dashboard to fail</b><br>
 - [BZ 1343169](https://bugzilla.redhat.com/1343169) <b>oVirt 4.0 translation cycle 1</b><br>
 - [BZ 1340937](https://bugzilla.redhat.com/1340937) <b>Selecting 'Errata' System tree node while on Dashboard tab makes GUI partially stuck or totally unresponsive (browser dependent)</b><br>
 - [BZ 1340928](https://bugzilla.redhat.com/1340928) <b>UI traceback thrown after selecting any item from System tree (Cannot read property 'length' of undefined)</b><br>
 - [BZ 1337606](https://bugzilla.redhat.com/1337606) <b>Global utilization: wrong initial values for available & total amount of CPU/Memory/Storage</b><br>
 - [BZ 1336896](https://bugzilla.redhat.com/1336896) <b>Storage utilization: negative available space is reported after removing one storage</b><br>

##### Team: Storage

 - [BZ 1342133](https://bugzilla.redhat.com/1342133) <b>Import of a VM from KVM fails</b><br>
 - [BZ 1340607](https://bugzilla.redhat.com/1340607) <b>NPE when listing VMs via REST</b><br>
 - [BZ 1339658](https://bugzilla.redhat.com/1339658) <b>OvfManager is not tested for disks info consistency in import/export</b><br>
 - [BZ 1337909](https://bugzilla.redhat.com/1337909) <b>NPE when trying to add a direct LUN disk</b><br>
 - [BZ 1338545](https://bugzilla.redhat.com/1338545) <b>Add AlertOnNumberOfLVs to engine-config.sh</b><br>
 - [BZ 1346752](https://bugzilla.redhat.com/1346752) <b>REST-API V3 | Failed to update VM disk bootable flag</b><br>
 - [BZ 1343618](https://bugzilla.redhat.com/1343618) <b>Can't stop the SPM due to uncleared task in HE config retrieval flow</b><br>
 - [BZ 1344516](https://bugzilla.redhat.com/1344516) <b>"deletion has been completed" written to audit log at onset of disk-specific Live Merge</b><br>
 - [BZ 1344048](https://bugzilla.redhat.com/1344048) <b>When importing an image as a template from Glance via the REST API, the template's name is ignored and a default one is generated</b><br>
 - [BZ 1342322](https://bugzilla.redhat.com/1342322) <b>Image Upload - PKI setup for secure communications with Image I/O Proxy</b><br>
 - [BZ 1343172](https://bugzilla.redhat.com/1343172) <b>UI exception thrown when listing VM disks when importing from external provider</b><br>
 - [BZ 1343168](https://bugzilla.redhat.com/1343168) <b>Disable boot checkboxes in attach disk to VM dialog if a bootable disk was already chosen from the list</b><br>
 - [BZ 1342110](https://bugzilla.redhat.com/1342110) <b>Wrong audit log on creation of diskless snapshot without memory</b><br>
 - [BZ 1341737](https://bugzilla.redhat.com/1341737) <b>Disable boot checkboxes in attach disk to VM dialog if a bootable disk is already attached</b><br>
 - [BZ 1339686](https://bugzilla.redhat.com/1339686) <b>REST-API | Cannot delete template that was import from export_domain</b><br>
 - [BZ 1338510](https://bugzilla.redhat.com/1338510) <b>Can't create VM with disk via webadmin</b><br>
 - [BZ 1339566](https://bugzilla.redhat.com/1339566) <b>UI exception thrown when creating a VM from template</b><br>
 - [BZ 1339536](https://bugzilla.redhat.com/1339536) <b>ChildCommandsCallbackBase: getSucceeded() will return wrong persisted value</b><br>
 - [BZ 1338665](https://bugzilla.redhat.com/1338665) <b>Template of Glance imported VMs have Ballooning device disabled</b><br>
 - [BZ 1339330](https://bugzilla.redhat.com/1339330) <b>NPE in CreateOvfVolumeForStorageDomainCommand</b><br>
 - [BZ 1339300](https://bugzilla.redhat.com/1339300) <b>Error creating a Cinder disk in a VM</b><br>
 - [BZ 1338526](https://bugzilla.redhat.com/1338526) <b>HE VM auto-import failed with NullPointerException</b><br>
 - [BZ 1338509](https://bugzilla.redhat.com/1338509) <b>Template is broken when created from Glance image</b><br>

##### Team: Network

 - [BZ 1341260](https://bugzilla.redhat.com/1341260) <b>[ipv6autoconf] - Engine should not configure IPv6 on host install</b><br>
 - [BZ 1340702](https://bugzilla.redhat.com/1340702) <b>Can't assign static ip for a network that is attached to the same interface as the management network</b><br>
 - [BZ 1340624](https://bugzilla.redhat.com/1340624) <b>Can't attach network to bond, network sent without boot protocol</b><br>
 - [BZ 1338601](https://bugzilla.redhat.com/1338601) <b>[SR-IOV] - It is possible to add(hotplug) 'passthrough' vNIC to running VM, while there are no available VFs on the host</b><br>
 - [BZ 1342782](https://bugzilla.redhat.com/1342782) <b>[Network Filter] - Remove 'allow-dhcp-server' filter from the network filters list in the vNIC profile dialog</b><br>
 - [BZ 1344355](https://bugzilla.redhat.com/1344355) <b>Add hosts fails for network conf issue</b><br>
 - [BZ 1342943](https://bugzilla.redhat.com/1342943) <b>Typos found while translating oVirt 4.0 UI strings</b><br>
 - [BZ 1341719](https://bugzilla.redhat.com/1341719) <b>SetupNetworks - Wrong ip on moved network</b><br>

##### Team: Infra

 - [BZ 1347478](https://bugzilla.redhat.com/1347478) <b>User and admin portal logout after a minute when using console</b><br>
 - [BZ 1342054](https://bugzilla.redhat.com/1342054) <b>REST-API (V3) | Change vNIC interface type reset vNIC network to ovirtmgmt</b><br>
 - [BZ 1345986](https://bugzilla.redhat.com/1345986) <b>oVirt engine RESTAPI cannot be deployed on Fedora 23 due to fop 2.0</b><br>
 - [BZ 1338522](https://bugzilla.redhat.com/1338522) <b>REST-API | Missing '/' in HostNIC labels link</b><br>
 - [BZ 1338502](https://bugzilla.redhat.com/1338502) <b>Update watchdog device without specify model via REST, raise NullPointerException</b><br>
 - [BZ 1338503](https://bugzilla.redhat.com/1338503) <b>Failed to remove watchdog device from template via REST</b><br>
 - [BZ 1342226](https://bugzilla.redhat.com/1342226) <b>REST-API V4 | Remove /api/capabilities href</b><br>
 - [BZ 1344337](https://bugzilla.redhat.com/1344337) <b>If connection issues happened, fallback to XMLRPC protocol is much faster than expected</b><br>
 - [BZ 1342070](https://bugzilla.redhat.com/1342070) <b>ovirt-engine-dashboard is not installed automatically</b><br>
 - [BZ 1343574](https://bugzilla.redhat.com/1343574) <b>branding.jar is stored inside enginesso.war instead of being linked</b><br>
 - [BZ 1341204](https://bugzilla.redhat.com/1341204) <b>Host deploy fails (from time to time!) on KeyExchange signature verification failed</b><br>
 - [BZ 1339907](https://bugzilla.redhat.com/1339907) <b>REST-API V3| Update network with invalid VLAN id get NPE massage response</b><br>
 - [BZ 1340164](https://bugzilla.redhat.com/1340164) <b>Failed to delete a specified storage domain in the system</b><br>
 - [BZ 1337181](https://bugzilla.redhat.com/1337181) <b>Disable VM host-host-passthrough mode not save on backward compatibility to API version 3</b><br>
 - [BZ 1337145](https://bugzilla.redhat.com/1337145) <b>Get statistics under version 3 failed with 404 error</b><br>

#### VDSM

##### Team: Storage

 - [BZ 1344900](https://bugzilla.redhat.com/1344900) <b>Hosted Engine deployment failed</b><br>

##### Team: Network

 - [BZ 1339604](https://bugzilla.redhat.com/1339604) <b>Modify a VM network when it is used not working</b><br>
 - [BZ 1340454](https://bugzilla.redhat.com/1340454) <b>Fail to set ethtool_opts on BOND</b><br>
 - [BZ 1338751](https://bugzilla.redhat.com/1338751) <b>Management network's gateway wiped out after detaching a network with gateway(different subnet) from host</b><br>
 - [BZ 1338818](https://bugzilla.redhat.com/1338818) <b>vdsmd is not running and restore networks failed after server reboot</b><br>

##### Team: Infra

 - [BZ 1343005](https://bugzilla.redhat.com/1343005) <b>OSError: [Errno 24] Too many open files - ovirt-ha-agent is dead</b><br>

#### oVirt Hosted Engine Setup

##### Team: Integration

 - [BZ 1342988](https://bugzilla.redhat.com/1342988) <b>Engine status show as "Can't connect to HA daemon" after reboot RHEV-H.</b><br>
 - [BZ 1343434](https://bugzilla.redhat.com/1343434) <b>Too early timed out while waiting for the disk to be created during upgrade-appliance action</b><br>

#### oVirt Engine DWH

##### Team: DWH

 - [BZ 1342129](https://bugzilla.redhat.com/1342129) <b>DWH service fails to start - java.lang.NumberFormatException: For input string: "0.1"</b><br>
 - [BZ 1339597](https://bugzilla.redhat.com/1339597) <b>When removing collection of data center statistics did not remove all references</b><br>

#### Cockpit oVirt

##### Team: Node

 - [BZ 1341076](https://bugzilla.redhat.com/1341076) <b>NGN always wait for vm shutdown although vm is shutdown after deploy HE.</b><br>

##### Team: Virt

 - [BZ 1341044](https://bugzilla.redhat.com/1341044) <b>Error infos flush the Virtual machines page repeatly</b><br>
 - [BZ 1341046](https://bugzilla.redhat.com/1341046) <b>No jump when click "VDSM Service Management" in VDSM page</b><br>
 - [BZ 1341077](https://bugzilla.redhat.com/1341077) <b>Miss button icon for "Login to Engine" in Virtual Machines page</b><br>

## Bug fixes

### oVirt Engine

#### Team: UX

 - [BZ 1273970](https://bugzilla.redhat.com/1273970) <b>Automation of UI tests needs way to check status of VM in userportal</b><br>
 - [BZ 1269953](https://bugzilla.redhat.com/1269953) <b>Console Client Resources page - cannot scroll</b><br>
 - [BZ 1275719](https://bugzilla.redhat.com/1275719) <b>remove ie8, ie9 permutations from GWT compilations</b><br>
 - [BZ 1183741](https://bugzilla.redhat.com/1183741) <b>User Portal: "Simple" user: Too much vertical space between top-banner and content in case the "Basic | Extended" bar is hidden</b><br>
 - [BZ 1342476](https://bugzilla.redhat.com/1342476) <b>Install Host dialog misses checkbox labels</b><br>
 - [BZ 1335199](https://bugzilla.redhat.com/1335199) <b>home page has link to reports, but reports won't be in 4.0</b><br>
 - [BZ 1302236](https://bugzilla.redhat.com/1302236) <b>Uncaught exception occurred. in the UI while choosing CPU Architecture as 'undefined' in the New Cluster dialog</b><br>
 - [BZ 1331079](https://bugzilla.redhat.com/1331079) <b>Migrating icon keeps floating when scrolling</b><br>
 - [BZ 1322435](https://bugzilla.redhat.com/1322435) <b>Radio buttons in Install host dialog are not clickable when window is too narrow</b><br>
 - [BZ 1277209](https://bugzilla.redhat.com/1277209) <b>Double click on split table checkbox column shouldn't initiate item move</b><br>
 - [BZ 1215727](https://bugzilla.redhat.com/1215727) <b>Whenever an exception is thrown in the front end code, unrelated parts of the GUI tend to stop working (e.g. 'new' and 'import' buttons under Networks tab)</b><br>

#### Team: Virt

 - [BZ 1339291](https://bugzilla.redhat.com/1339291) <b>VM split brain during networking issues</b><br>
 - [BZ 1339308](https://bugzilla.redhat.com/1339308) <b>stateless vms fail to start - stateless snapshot is locked forever</b><br>
 - [BZ 1336527](https://bugzilla.redhat.com/1336527) <b>Cluster level can be changed while there are running VMs</b><br>
 - [BZ 1336405](https://bugzilla.redhat.com/1336405) <b>Failed to import template from export domain with 'General command validation failure.'</b><br>
 - [BZ 1268216](https://bugzilla.redhat.com/1268216) <b>Query count grows linear with vm count for /api/vms endpoint</b><br>
 - [BZ 1335186](https://bugzilla.redhat.com/1335186) <b>hosted-engine vm and storage domain not displayed in the admin web ui</b><br>
 - [BZ 1325938](https://bugzilla.redhat.com/1325938) <b>VM stay in 'powering down' after stopping VM</b><br>
 - [BZ 1332039](https://bugzilla.redhat.com/1332039) <b>VM can be "down" and "migrating" at the same time</b><br>
 - [BZ 1328737](https://bugzilla.redhat.com/1328737) <b>Editing a sub attribute of vm/template initialization attr via API overrides all other sub_attributes</b><br>
 - [BZ 1328011](https://bugzilla.redhat.com/1328011) <b>Engine: internal admin cannot migrate VM (permission issue)</b><br>
 - [BZ 1317789](https://bugzilla.redhat.com/1317789) <b>Template tab doesn't show all templates</b><br>
 - [BZ 1310426](https://bugzilla.redhat.com/1310426) <b>VmPool related jobs are stuck in job and steps tables in DB when several consecutive actions are called</b><br>
 - [BZ 1308478](https://bugzilla.redhat.com/1308478) <b>[SCALE] Create new VM in webadmin portal shows only spinning ring.</b><br>
 - [BZ 1343901](https://bugzilla.redhat.com/1343901) <b>Fix websocket proxy for python-websockify 0.8.0</b><br>
 - [BZ 1313379](https://bugzilla.redhat.com/1313379) <b>Wrong ca entry in [ovirt] section of .vv file</b><br>
 - [BZ 1293154](https://bugzilla.redhat.com/1293154) <b>New VM dialog offers each VM template twice</b><br>
 - [BZ 1298293](https://bugzilla.redhat.com/1298293) <b>v2v: import dialog - source VM list is not updated correctly.</b><br>
 - [BZ 1320343](https://bugzilla.redhat.com/1320343) <b>VirtIO serial console is not working with SuperUser role.</b><br>
 - [BZ 1296529](https://bugzilla.redhat.com/1296529) <b>VM cpu/mem/net usage text is overlapping graph</b><br>
 - [BZ 1060573](https://bugzilla.redhat.com/1060573) <b>Spice shared session: Obey connected=keep settings during setTicket</b><br>
 - [BZ 1324066](https://bugzilla.redhat.com/1324066) <b>WebAdmin Portal Uncaught exception occurred when selecting another host</b><br>
 - [BZ 1330988](https://bugzilla.redhat.com/1330988) <b>drop device addresses when changing machine type</b><br>
 - [BZ 1260969](https://bugzilla.redhat.com/1260969) <b>[PPC64LE] Add validation when create vm with memory, that no multiplier of 256</b><br>
 - [BZ 1331940](https://bugzilla.redhat.com/1331940) <b>"VmWare" should be changed to "VMware"</b><br>
 - [BZ 1328463](https://bugzilla.redhat.com/1328463) <b>creating a new vm from templates tab overrides template's initialization parameters</b><br>
 - [BZ 1187752](https://bugzilla.redhat.com/1187752) <b>Hypervisor CPU family and name mismatch between API and webUI</b><br>
 - [BZ 1275747](https://bugzilla.redhat.com/1275747) <b>Cancel migration VDSErrorException  Failed to DestroyVDS on destination host</b><br>
 - [BZ 1261951](https://bugzilla.redhat.com/1261951) <b>Improve error message when OVF cannot be parsed from export domain</b><br>
 - [BZ 1336099](https://bugzilla.redhat.com/1336099) <b>Rename Verify Credentials to Skip SSL verification during v2v</b><br>
 - [BZ 1277202](https://bugzilla.redhat.com/1277202) <b>Excessive spacing in Add Host Devices dialog</b><br>
 - [BZ 1288089](https://bugzilla.redhat.com/1288089) <b>[events] "untranslated" VM_MIGRATION_TO_SERVER_FAILED event for subscription</b><br>
 - [BZ 1331939](https://bugzilla.redhat.com/1331939) <b>A minor typo found during translation</b><br>
 - [BZ 1296127](https://bugzilla.redhat.com/1296127) <b>string showing number of cores of VM in basictab in 3.6 is harder to read than in 3.5</b><br>
 - [BZ 1197808](https://bugzilla.redhat.com/1197808) <b>Unable to remove VM previewing a snapshot</b><br>
 - [BZ 1246886](https://bugzilla.redhat.com/1246886) <b>Remove vm-pool fails if vms are running</b><br>
 - [BZ 994403](https://bugzilla.redhat.com/994403) <b>All options “Create Snapshot“ during VM “In Preview” status, should be grayed out</b><br>
 - [BZ 1057009](https://bugzilla.redhat.com/1057009) <b>Taking a memory snapshot should alert the user that the VM will be paused for creation duration.</b><br>
 - [BZ 1253440](https://bugzilla.redhat.com/1253440) <b>RadioButton "Specific" in New VM dialog > Hosts is not controlled by its label</b><br>
 - [BZ 1282218](https://bugzilla.redhat.com/1282218) <b>After detaching VMs from pool the number of pre started VMs in pool isn't changed</b><br>
 - [BZ 1283499](https://bugzilla.redhat.com/1283499) <b>Impossible to POST key value using REST API</b><br>
 - [BZ 1295779](https://bugzilla.redhat.com/1295779) <b>Untranslated job name for vm-logon and CloneVm</b><br>
 - [BZ 1299233](https://bugzilla.redhat.com/1299233) <b>NPE when importing image as template from glance</b><br>
 - [BZ 1268949](https://bugzilla.redhat.com/1268949) <b>Wrong error message while changing template of vm</b><br>
 - [BZ 1278738](https://bugzilla.redhat.com/1278738) <b>The "virtio_scsi" element isn't populated when a VM is requested</b><br>
 - [BZ 1283151](https://bugzilla.redhat.com/1283151) <b>external VMs are not added when storage is not configured</b><br>
 - [BZ 1267228](https://bugzilla.redhat.com/1267228) <b>Asynchronous frontend validation of icons</b><br>

#### Team: Storage

 - [BZ 1290427](https://bugzilla.redhat.com/1290427) <b>snapshot without disks gets deleted automatically once a snapshot gets commited</b><br>
 - [BZ 1314082](https://bugzilla.redhat.com/1314082) <b>Live Merge times out on the engine but actually succeeds on the host</b><br>
 - [BZ 1334105](https://bugzilla.redhat.com/1334105) <b>VMs from auto-start pool randomly stop getting started</b><br>
 - [BZ 1324780](https://bugzilla.redhat.com/1324780) <b>[engine-webadmin] When importing an image as a template from Glance, if the template's name is not specified, then it is logged as <UNKNOWN></b><br>
 - [BZ 1333342](https://bugzilla.redhat.com/1333342) <b>snapshot disk actual size is not refreshing after merge</b><br>
 - [BZ 1328071](https://bugzilla.redhat.com/1328071) <b>Template deletion should not fail even if its disk's deletion fails</b><br>
 - [BZ 1335502](https://bugzilla.redhat.com/1335502) <b>Exception while importing template</b><br>
 - [BZ 1335464](https://bugzilla.redhat.com/1335464) <b>No validation for missing storage domain id when importing a block storage domain through the sdk</b><br>
 - [BZ 1325785](https://bugzilla.redhat.com/1325785) <b>permissions on Database Object don't allow  "add direct LUN" to virtual machine.</b><br>
 - [BZ 1332960](https://bugzilla.redhat.com/1332960) <b>Detach a vm's disk using the API will remove the disk permanently</b><br>
 - [BZ 1332239](https://bugzilla.redhat.com/1332239) <b>[REST-API] rsdl: wrong parameter name under copy disk template action</b><br>
 - [BZ 1329906](https://bugzilla.redhat.com/1329906) <b>Storage domain ownership of LUN not displayed.</b><br>
 - [BZ 1326003](https://bugzilla.redhat.com/1326003) <b>Can't update direct lun using the API</b><br>
 - [BZ 1310642](https://bugzilla.redhat.com/1310642) <b>Provide more details in the Events/Tasks tab message when importing an image as template from an external provider</b><br>
 - [BZ 1306743](https://bugzilla.redhat.com/1306743) <b>Live Merge does not update the database properly upon failure</b><br>
 - [BZ 1305343](https://bugzilla.redhat.com/1305343) <b>Irrelevant warnings are logged when attaching an export domain to a dc</b><br>
 - [BZ 1304653](https://bugzilla.redhat.com/1304653) <b>ACTION_TYPE_FAILED_VM_SNAPSHOT_TYPE_NOT_ALLOWED message isn't i18n comptaible</b><br>
 - [BZ 1221189](https://bugzilla.redhat.com/1221189) <b>Add warning when adding external FCP lun to VM although it is part of existing storage domain</b><br>
 - [BZ 1297689](https://bugzilla.redhat.com/1297689) <b>No error message is shown on getDevicelist failure when adding a new FC storage domain</b><br>
 - [BZ 1191514](https://bugzilla.redhat.com/1191514) <b>Missing storage related VDSM error codes</b><br>
 - [BZ 1280358](https://bugzilla.redhat.com/1280358) <b>Disk Alias and Description maximum size isn't restricted to max size</b><br>
 - [BZ 1277667](https://bugzilla.redhat.com/1277667) <b>ISO domain can't be created</b><br>
 - [BZ 1221163](https://bugzilla.redhat.com/1221163) <b>[TEXT][REST] Wrong error is thrown when attempting an update command on a detached storage domain</b><br>

#### Team: Integration

 - [BZ 1302667](https://bugzilla.redhat.com/1302667) <b>[FC23] engine-setup fails to configure nfs</b><br>
 - [BZ 1317947](https://bugzilla.redhat.com/1317947) <b>engine-setup should default to not create NFS ISO domain</b><br>
 - [BZ 1261335](https://bugzilla.redhat.com/1261335) <b>[engine-setup][text] The error for a missing update in the sql performing the validation should be fixed.</b><br>
 - [BZ 1241869](https://bugzilla.redhat.com/1241869) <b>Typo in option name OVESETUP_WSP_RPMDISRO_PACKAGES</b><br>
 - [BZ 1274220](https://bugzilla.redhat.com/1274220) <b>Setup can't be canceled using Ctrl + C when setting Local ISO domain path</b><br>
 - [BZ 1329383](https://bugzilla.redhat.com/1329383) <b>engine-backup message are not helpful</b><br>
 - [BZ 1323826](https://bugzilla.redhat.com/1323826) <b>engine-setup stage 'Setup validation' takes too long to complete</b><br>
 - [BZ 1310705](https://bugzilla.redhat.com/1310705) <b>Problem when configuring ovirt-engine with dockerc plugin enabled</b><br>
 - [BZ 1254654](https://bugzilla.redhat.com/1254654) <b>[F23] ovirt-log-collector fails to build on fedora >= 23</b><br>
 - [BZ 1296520](https://bugzilla.redhat.com/1296520) <b>[engine-backup] Misleading error msg when log parameter is not passed</b><br>

#### Team: Infra

 - [BZ 1317279](https://bugzilla.redhat.com/1317279) <b>iscsi login fails in v3</b><br>
 - [BZ 1320964](https://bugzilla.redhat.com/1320964) <b>REST API: Can't set quota for DC (in v3 compatibility mode at least) - "No enum constant org.ovirt.engine.api.model.QuotaModeType.disabled"</b><br>
 - [BZ 1318666](https://bugzilla.redhat.com/1318666) <b>Remove VM fails with HTTP400 - bad request</b><br>
 - [BZ 1333354](https://bugzilla.redhat.com/1333354) <b>[REST API V3] Adding a vm with custom_properties fails via api version 3</b><br>
 - [BZ 1301031](https://bugzilla.redhat.com/1301031) <b>[events] Strange reason when putting host to maintenance - No reason was returned for this operation failure. See logs for further details.</b><br>
 - [BZ 1229743](https://bugzilla.redhat.com/1229743) <b>New host info is cleared after disabling use of Host Foreman provider</b><br>
 - [BZ 1308563](https://bugzilla.redhat.com/1308563) <b>Adding a host with a name that is already in use returns a Bad Request (code 400)</b><br>
 - [BZ 1340471](https://bugzilla.redhat.com/1340471) <b>Automatic logout does not terminate user session</b><br>
 - [BZ 1336838](https://bugzilla.redhat.com/1336838) <b>engine doesn't trust externally-issued web certificate for internal authentication in spite of issuer being in system (and java) trust store</b><br>
 - [BZ 1334098](https://bugzilla.redhat.com/1334098) <b>Scheduling policy doesnt get updated in REST (v3)</b><br>
 - [BZ 1323631](https://bugzilla.redhat.com/1323631) <b>Closing a connection should not require 'filter' header.</b><br>
 - [BZ 1334096](https://bugzilla.redhat.com/1334096) <b>REST API: Search cluster request returns empty result (v3)</b><br>
 - [BZ 1303694](https://bugzilla.redhat.com/1303694) <b>bad string in error message when testing external provider without permissions</b><br>
 - [BZ 1330209](https://bugzilla.redhat.com/1330209) <b>/api/hosts/{host:id}/install fails</b><br>
 - [BZ 1330168](https://bugzilla.redhat.com/1330168) <b>[Admin Portal] not able to get admin portal login screen after ovirt-engine-rename</b><br>
 - [BZ 1332986](https://bugzilla.redhat.com/1332986) <b>Snapshot operation names changed from <op_name>_snapshot to <op_name>snapshot</b><br>
 - [BZ 1148514](https://bugzilla.redhat.com/1148514) <b>Engine may kill session that is still in use</b><br>
 - [BZ 1328404](https://bugzilla.redhat.com/1328404) <b>[REST-API] refresh host capabilities not working</b><br>
 - [BZ 1326578](https://bugzilla.redhat.com/1326578) <b>Email notification can't be configured in engine. "Operation Canceled Error while executing action: A Request to the Server failed with the following Status Code: 500"</b><br>
 - [BZ 1322019](https://bugzilla.redhat.com/1322019) <b>Admin user reported as "admin@internal@internal-authz"</b><br>
 - [BZ 1302034](https://bugzilla.redhat.com/1302034) <b>It's possible to remove inherited permissions from Everyone's group</b><br>
 - [BZ 1268224](https://bugzilla.redhat.com/1268224) <b>Query count grows linear with host count for /api/hosts endpoint</b><br>
 - [BZ 1322923](https://bugzilla.redhat.com/1322923) <b>java.lang.IllegalArgumentException: No type specified for option: 'encrypt_options' in /api/capabilities</b><br>
 - [BZ 1285390](https://bugzilla.redhat.com/1285390) <b>REST error message suggests description but there is none</b><br>
 - [BZ 1321452](https://bugzilla.redhat.com/1321452) <b>[REST API] storage_manager object/tag is missing in host details</b><br>
 - [BZ 1310837](https://bugzilla.redhat.com/1310837) <b>oVirt cannot be accessed through IPv6 address</b><br>
 - [BZ 1303346](https://bugzilla.redhat.com/1303346) <b>XSD value object requires at least 1 occurrence of datum but doesnt always have it in nic statistics</b><br>
 - [BZ 1293944](https://bugzilla.redhat.com/1293944) <b>Log common locking management actions</b><br>
 - [BZ 1286752](https://bugzilla.redhat.com/1286752) <b>Inconsistent use of placeholders in login form</b><br>
 - [BZ 1286810](https://bugzilla.redhat.com/1286810) <b>Log out from userportal doesn't work for non-admins</b><br>
 - [BZ 1279589](https://bugzilla.redhat.com/1279589) <b>Incorrect type usage of extension api</b><br>
 - [BZ 1267910](https://bugzilla.redhat.com/1267910) <b>PSQLException when insert value to audit log if input string is too long</b><br>
 - [BZ 1273932](https://bugzilla.redhat.com/1273932) <b>RestAPI returns 500 instead of 400 when sending invalid JSON</b><br>
 - [BZ 1274338](https://bugzilla.redhat.com/1274338) <b>Upgrade WildFly to 8.2.1</b><br>
 - [BZ 1273447](https://bugzilla.redhat.com/1273447) <b>After a command is finished tasks are not cleared and stay in executing status</b><br>
 - [BZ 1273094](https://bugzilla.redhat.com/1273094) <b>4.0: can't remove vm template - the disks are removed and the template stays locked</b><br>
 - [BZ 1269413](https://bugzilla.redhat.com/1269413) <b>running master on FC22 server.log shows several warnings about java modules.</b><br>
 - [BZ 1259620](https://bugzilla.redhat.com/1259620) <b>Missing Cpu.setType api</b><br>

#### Team: DWH

 - [BZ 1325699](https://bugzilla.redhat.com/1325699) <b>Remove dwh_disk_vm_map_history_view from engine db</b><br>

#### Team: SLA

 - [BZ 1342500](https://bugzilla.redhat.com/1342500) <b>Host can't be added directly to 3.6 cluster</b><br>
 - [BZ 1327267](https://bugzilla.redhat.com/1327267) <b>HE Vm's ovf isn't updated according to 'OvfUpdateIntervalInMinutes' value</b><br>
 - [BZ 1226767](https://bugzilla.redhat.com/1226767) <b>New Virtual Machine window-> CPU Shares & CPU Pinning Topology should not be greyed out when usable</b><br>
 - [BZ 1260732](https://bugzilla.redhat.com/1260732) <b>[BACKWARDS COMPATIBILITY CLEANUP] Remove support for pinning VM to only one CPU</b><br>
 - [BZ 1256683](https://bugzilla.redhat.com/1256683) <b>UI not show all "Run on" hosts under vm general tab</b><br>

#### Team: Network

 - [BZ 1336401](https://bugzilla.redhat.com/1336401) <b>[Network Filter] - New vNIC profiles for new networks created without network filter</b><br>
 - [BZ 1325670](https://bugzilla.redhat.com/1325670) <b>[UI] - IP address is not shown for dhcp boot protocol in the edit network dialog</b><br>
 - [BZ 1271094](https://bugzilla.redhat.com/1271094) <b>[Host QoS] - Updating second network with host QoS when it attached to host NIC with another network that is out-of-sync, considered as synced</b><br>
 - [BZ 1317581](https://bugzilla.redhat.com/1317581) <b>Neutron | missing REST-API to import networks from neutron external provider</b><br>
 - [BZ 1321459](https://bugzilla.redhat.com/1321459) <b>[WebAdmin UI] - 'Network Interfaces' under 'Hosts' main tab is not clear (used to be in 3.6) - partially missing grid</b><br>
 - [BZ 1283062](https://bugzilla.redhat.com/1283062) <b>Updates and/or calls to MAC address Pool are not bound to DB transaction.</b><br>
 - [BZ 1322515](https://bugzilla.redhat.com/1322515) <b>The "Default" cluster doesn't have Display and Migration networks set out of the box</b><br>
 - [BZ 1277496](https://bugzilla.redhat.com/1277496) <b>remove oldest network api (3.0? — preceding existence of setsupnetworks) and internal usage thereof</b><br>
 - [BZ 1167698](https://bugzilla.redhat.com/1167698) <b>[SetupNetworks]> Unmanaged network on host NIC should prevent attaching new networks to this NIC, until unmanaged network is removed</b><br>
 - [BZ 1293881](https://bugzilla.redhat.com/1293881) <b>Host installation fails with "java.lang.Integer cannot be cast to java.lang.String"</b><br>
 - [BZ 1261795](https://bugzilla.redhat.com/1261795) <b>A minor typo found during translation "Cannot ${action} ${type}. At most one VLAN-untagged Logical Network is allowed on a NIC (optionally in conjunction with several VLAN Logical Networks). The following Network Interfaces violate that : ${NETWORK_INTERF</b><br>
 - [BZ 1264405](https://bugzilla.redhat.com/1264405) <b>Remove List<VdsNetworkInterface> nics from and pass only relevant information</b><br>
 - [BZ 1271220](https://bugzilla.redhat.com/1271220) <b>[REST] [Host network QoS] It's possible to configure weighted share and rate limit on the network to be bigger than the max value configured on engine</b><br>
 - [BZ 1219383](https://bugzilla.redhat.com/1219383) <b>[MAC pool] limit range to 2^31 addresses</b><br>
 - [BZ 1340862](https://bugzilla.redhat.com/1340862) <b>Can not create Openstack network provider in rest v3</b><br>
 - [BZ 1322947](https://bugzilla.redhat.com/1322947) <b>Management network can't be moved to other host NIC</b><br>

### VDSM

#### Team: Virt

 - [BZ 1339464](https://bugzilla.redhat.com/1339464) <b>Broken Dependencies for vdsm on ppc64le</b><br>
 - [BZ 1339291](https://bugzilla.redhat.com/1339291) <b>VM split brain during networking issues</b><br>
 - [BZ 1309884](https://bugzilla.redhat.com/1309884) <b>In RHEL7, VDSM is no longer calling _destroyVmForceful() if SIGTERM fails</b><br>
 - [BZ 1260686](https://bugzilla.redhat.com/1260686) <b>/dev/hwrng can't be accessed</b><br>
 - [BZ 1060573](https://bugzilla.redhat.com/1060573) <b>Spice shared session: Obey connected=keep settings during setTicket</b><br>
 - [BZ 1318550](https://bugzilla.redhat.com/1318550) <b>Vm.status() causes crash of MoM GuestManager</b><br>
 - [BZ 912390](https://bugzilla.redhat.com/912390) <b>vdsm: race between create and destory of VM leaves VM running on host while engine thinks its down.</b><br>
 - [BZ 1274670](https://bugzilla.redhat.com/1274670) <b>VM migration doesn't work with current VDSM master</b><br>

#### Team: Storage

 - [BZ 1081962](https://bugzilla.redhat.com/1081962) <b>[SCALE] block storage domain monitoring thread slows down when storage operations are running</b><br>
 - [BZ 1319987](https://bugzilla.redhat.com/1319987) <b>Storage activities are failing with error "Image is not a legal chain"</b><br>
 - [BZ 1305529](https://bugzilla.redhat.com/1305529) <b>[vdsm] On POSIXFS storage domain creation, if nothing is given after '/' in the path, the '/' is ignored in the mount command that vdsm executes</b><br>
 - [BZ 1270220](https://bugzilla.redhat.com/1270220) <b>SPM is not tolerant for very slow NFS file deletes</b><br>
 - [BZ 1283278](https://bugzilla.redhat.com/1283278) <b>Add dependency when fix for bug 1283116 (7.2.z) is in ([abrt] qemu-img: get_block_status(): qemu-img killed by SIGABRT)</b><br>
 - [BZ 1214342](https://bugzilla.redhat.com/1214342) <b>After a failed snapshot, Live Snapshot Merge operation fails</b><br>
 - [BZ 1295429](https://bugzilla.redhat.com/1295429) <b>Remove file=path workaround for live snapshot on block storage due to libvirt prior to 1.2.2</b><br>
 - [BZ 1128855](https://bugzilla.redhat.com/1128855) <b>Take advantage of libvirt blockInfo support on root_squash NFS</b><br>
 - [BZ 1333627](https://bugzilla.redhat.com/1333627) <b>Growing backing file length in qcow2 header causes 'Backing file name too long' error.</b><br>

#### Team: Network

 - [BZ 1323782](https://bugzilla.redhat.com/1323782) <b>vdsm-restore-network leaves inconsistent RunningConfig after a failed restoration</b><br>
 - [BZ 1261056](https://bugzilla.redhat.com/1261056) <b>Place bonding-defaults.json outside of /var/lib/vdsm</b><br>
 - [BZ 1305338](https://bugzilla.redhat.com/1305338) <b>Issue with vdsm-hook-vmfex-dev-4.16.33-1 - "InvalidatedWeakRef"</b><br>
 - [BZ 1269175](https://bugzilla.redhat.com/1269175) <b>nic removed from bond can not be bound to another bond</b><br>

#### Team: Infra

 - [BZ 1300640](https://bugzilla.redhat.com/1300640) <b>spec: require python-six >= 1.9</b><br>
 - [BZ 1325664](https://bugzilla.redhat.com/1325664) <b>No failure message appears when setting a power management test fails</b><br>
 - [BZ 1314705](https://bugzilla.redhat.com/1314705) <b>[ovirt-node] Can't register node to engine through TUI</b><br>
 - [BZ 1320281](https://bugzilla.redhat.com/1320281) <b>Vdsm is missing arch specific dependencies</b><br>
 - [BZ 1278414](https://bugzilla.redhat.com/1278414) <b>drop requirement of 'umask' argument on cpopen</b><br>
 - [BZ 1334473](https://bugzilla.redhat.com/1334473) <b>vdsm latest master requires python-yaml on el7, but it's not on any repos</b><br>
 - [BZ 1321325](https://bugzilla.redhat.com/1321325) <b>stompTests.StompTests test_echo(4096, False) ERROR</b><br>
 - [BZ 1332923](https://bugzilla.redhat.com/1332923) <b>Hosted engine deploy failed with error: TypeError: success() argument after ** must be a mapping, not str</b><br>
 - [BZ 1323969](https://bugzilla.redhat.com/1323969) <b>race on recovery prevents events to be delivered</b><br>
 - [BZ 1189200](https://bugzilla.redhat.com/1189200) <b>traceback in ioprocess while restarting VDSM</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1331626](https://bugzilla.redhat.com/1331626) <b>It always report "Invalid number of cpu specified" and will lead to HE deploy can not be continued.</b><br>
 - [BZ 1316094](https://bugzilla.redhat.com/1316094) <b>[HE] VDSM API - netinfo.CachingNetInfo doesn't exist anymore</b><br>
 - [BZ 1156060](https://bugzilla.redhat.com/1156060) <b>[text] engine admin password prompt consistency</b><br>
 - [BZ 1306573](https://bugzilla.redhat.com/1306573) <b>hosted engine appliance deployment fails with insufficient information.</b><br>
 - [BZ 1186388](https://bugzilla.redhat.com/1186388) <b>[TEXT][HE] Ask user to choose an existing cluster during installation</b><br>
 - [BZ 1221176](https://bugzilla.redhat.com/1221176) <b>hosted-engine accepts FQDNs with underscore while the engine correctly fails on that</b><br>
 - [BZ 1228149](https://bugzilla.redhat.com/1228149) <b>[hosted-engine][text] [ ERROR ] Not enough space in the temporary directory</b><br>
 - [BZ 1321381](https://bugzilla.redhat.com/1321381) <b>hosted-engine-setup trusts also the system defined CA certs while the oVirt python SDK ignores them</b><br>
 - [BZ 1298592](https://bugzilla.redhat.com/1298592) <b>Deploy of the second host failed if I have root password of the first host under answer file</b><br>
 - [BZ 1259266](https://bugzilla.redhat.com/1259266) <b>engine_api.hosts.add fails if called passing reboot_after_installation optional parameter</b><br>

### oVirt Engine DWH

#### Team: DWH

 - [BZ 1338495](https://bugzilla.redhat.com/1338495) <b>Collect the new disk_vm_element table and remove collection of vm_disk_interface from base_disks</b><br>
 - [BZ 1321517](https://bugzilla.redhat.com/1321517) <b>RHEV DWH database growing excessively</b><br>
 - [BZ 1311149](https://bugzilla.redhat.com/1311149) <b>change vds_groups in etl to cluster</b><br>
 - [BZ 1328769](https://bugzilla.redhat.com/1328769) <b>[nightly 4.0] setup-engine Failed to execute stage 'Misc configuration' because of DWH scripts</b><br>
 - [BZ 1312638](https://bugzilla.redhat.com/1312638) <b>Remove DWH views that will not be supported anymore</b><br>

#### Team: Integration

 - [BZ 1328860](https://bugzilla.redhat.com/1328860) <b>[dwh] engine-cleanup on separate dwh machine does not reset dwh_history_timekeeping</b><br>
 - [BZ 1301962](https://bugzilla.redhat.com/1301962) <b>engine-setup fails with: Internal error: cannot import name dialog</b><br>

### oVirt vmconsole

#### Team: Virt

 - [BZ 1330503](https://bugzilla.redhat.com/1330503) <b>ovirt-vmconsole-1.0.2 fails make distcheck</b><br>

### oVirt Log collector

#### Team: Integration

 - [BZ 1254654](https://bugzilla.redhat.com/1254654) <b>[F23] ovirt-log-collector fails to build on fedora >= 23</b><br>

### oVirt Image Uploader

#### Team: Integration

 - [BZ 1104661](https://bugzilla.redhat.com/1104661) <b>zero returncode on error</b><br>
 - [BZ 1264424](https://bugzilla.redhat.com/1264424) <b>change ovirt-engine api endpoint</b><br>

### oVirt ISO Uploader

#### Team: Integration

 - [BZ 1264542](https://bugzilla.redhat.com/1264542) <b>change ovirt-engine api endpoint</b><br>

### oVirt Host Deploy

#### Team: Virt

 - [BZ 1279434](https://bugzilla.redhat.com/1279434) <b>ovirt-vmconsole-host-sshd service is not started automatically at boot</b><br>

#### Team: Integration

 - [BZ 1320059](https://bugzilla.redhat.com/1320059) <b>vdsm _reconfigure should be called before _start</b><br>

### oVirt Live

#### Team: Integration

 - [BZ 1316029](https://bugzilla.redhat.com/1316029) <b>vdsm - caps/machinetype API changes broke setup</b><br>
 - [BZ 1282799](https://bugzilla.redhat.com/1282799) <b>Import all-in-one plugins from ovirt-engine into ovirt-live</b><br>

### oVirt Engine Extension AAA LDAP

#### Team: Infra

 - [BZ 1333878](https://bugzilla.redhat.com/1333878) <b>ovirt-engine-extension-aaa-ldap-setup appends '-authz' behind the scene, impacts SSO by default</b><br>

### OTOPI

#### Team: Integration

 - [BZ 1316908](https://bugzilla.redhat.com/1316908) <b>hosted-engine --deploy fails when you have i18n chars in /root/.ssh/authorized_keys</b><br>

### Cockpit oVirt

#### Team: Node

 - [BZ 1334720](https://bugzilla.redhat.com/1334720) <b>once started HE deploy, can't stop it while running</b><br>
 - [BZ 1334740](https://bugzilla.redhat.com/1334740) <b>hosted-engine deploy UI can be lost leaving the process hanging</b><br>

### oVirt Release RPM

#### Team: Node

 - [BZ 1323975](https://bugzilla.redhat.com/1323975) <b>sshd service not started after first boot</b><br>
 - [BZ 1335503](https://bugzilla.redhat.com/1335503) <b>Add mailx requirement to be able to read emails (i.e. from ha-agent) on  NGN</b><br>
 - [BZ 1301966](https://bugzilla.redhat.com/1301966) <b>postfix-2.10.1-6.el7.x86_64 component dependency is missing for ovirt-hosted-engine-setup-1.3.2.2-2.el7ev.noarch on RHEVH (20160113.0.el7ev)</b><br>
 - [BZ 1285024](https://bugzilla.redhat.com/1285024) <b>Add an ovirt-releaseXY-host-node subpackage for image dependencies</b><br>

#### Team: Integration

 - [BZ 1294083](https://bugzilla.redhat.com/1294083) <b>Wrong URL for CentOS VIrt SIG repository when using EL7 Server variant</b><br>
 - [BZ 1278398](https://bugzilla.redhat.com/1278398) <b>Unable to build master on EL7 due to missing objenesis package dependency</b><br>

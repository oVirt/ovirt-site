---
title: oVirt 3.4.1 release notes
category: documentation
toc: true
authors:
  - dougsland
  - sandrobonazzola
  - sven
---

# oVirt 3.4.1 release notes

The oVirt Project is pleased to announce the availability of oVirt 3.4.1 release.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4 Release Notes](/develop/release-management/releases/3.4/), [oVirt 3.3.5 release notes](/develop/release-management/releases/3.3.5/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/). For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide.html) and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm)


If you're upgrading from a previous version you should have ovirt-release package already installed on your system.

You can then install ovirt-release34.rpm as in a clean install side-by-side.

If you're upgrading from oVirt 3.4.0 you can now remove ovirt-release package:

      # yum remove ovirt-release
      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from 3.3.2 or later, keep ovirt-release rpm in place until the upgrade is completed.

      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from oVirt <= 3.3.1 you must first upgrade to oVirt 3.3.5. Please see [oVirt 3.3.5 release notes](/develop/release-management/releases/3.3.5/) for upgrading instructions.

### oVirt Node

A new oVirt Node ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-node-iso-3.4-20140508.2.el6.iso`](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-node-iso-3.4-20140508.2.el6.iso)

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-3.4.1.el6ev.iso`](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-3.4.1.el6ev.iso)

## What's New in 3.4.1?

## Known issues

*   Host deployment may fail on EL6 system due to a recent tuned regression (, ). Please downgrade tuned to previous version while waiting for a new tuned package solving this issue.
*   ovirt-log-collector installation fails on Fedora 19 due to a conflict with sos 3.0 recently introduced also on release 19 () as workaround please downgrade sos before installing ovirt-engine:

       # yum downgrade sos

*   after installing ovirt-engine yum update will fail on Fedora 19 due to sos 3.0 conflict with ovirt-log-collector () as workaround please exclude sos from yum updates adding the following line in **/etc/yum.conf**:

       exclude=sos

## Bugs fixed

### oVirt Engine

* engine: cannot remove template due to failure in commands performed on vm's which are based on template (template is marked as shared)
 - [Backend][domain_scan] NPE when scanning for unregistered images on non-existent domain
 - displayNetwork must have an IP address on host
 - After power outage, storage reported as up while none of the hosts are up
 - [engine][neutron] Port leftover if hot-plug new vNIC fails
 - [oVirt] [glance] API version not specified in provider dialog
 - [ALL_LANG][Admin Portal] Host tab -> Network Interfaces subtab ->Setup Host Networks -> remove 'menu for' header
 - [RHEVM][webadmin] remove VM network checkbox from manage network dialog
 - [ALL_LANG][Admin_Portal][User_Portal] Header -> Guide -> Missing Language message unlocalized
 - Port mirroring checkbox should be greyed out for update if that VNIC profile is located on VM
 - The engine-manage-domains tool ignores the Kerberos servers from DNS when using -ldapServers
 - Exception for corrupted ovf in export domain, is not sent to engine log.
 - [engine-backend] Guaranteed RAM memory of a VM can be set to a higher value than the actual memory size
 - Setup Host Networks dialog: Unnecessary "Add NIC to Bond" Item
 - Setup Host Networks dialog: A certain scenario leads to a Bond with only one NIC
 - Time Zone of Sri Lanka in "Initial Run" Section of "New Virtual Machine" and "Edit Virtual Machine" Configuration is WRONG
 - cloud-init: gateway shouldn't be mandatory on run once window
 - components do not have severity initialized on engine start
 - [Admin Portal] Cluster: initialized = false does not change view
 - VM update REST API call returns success instead of error on a wrongly formed xml
 - [engine-backend] [RO disks] cannot change unplugged disk r/o status while VM is running
 - setupNetworks: nic with dhcp cannot be bonded
 - After a power outage two VMs marked as HA failed to start automatically, they were required to be started manually.
 - Bookmarks do not work when the selected tree-node in the System tree is not "System"
 - SQL exception after discovery when configuring the first ISCSI data domain
 - [engine-backend] Attaching a disk as active to a running VM (hotplug), is not blocked for an IDE disk interface
 - [engine-backend] engine asks for vdsManager of a host that was removed from the system
 - [legacy upgrade 3.2->3.3] misleading information
 - High availability parameters are not fully restored on import vm/template
 - UI: Add new role permission drop below the end of the screen
 - Allow to change the version name of a sub template
 - Snapshotpane empty after autologout
 - Autologout does not work in VM view (snapshot pane open)
 - On create new network window the "Enter" key is not press "OK"
 - [RHEVM] [webadmin] improve tooltip on subnet mask in setup networks
 - Create engine-setup answer-file even if setup is aborted
 - Import domain dialog empty selectboxes
 - SSH injection via cloud-init UI doesn't work for root user
 - [RHEVM] [webadmin] [network labels] cannot assign more than 5 labels to host network interface because there in no scrollbar
 - [engine-setup] ascii check for ISO Domain name should be done immediately when defining domain name
 - When creating new VM in advanced view "Start running on" is blank for the second cluster
 - [RHEVM] [webadmin] weird dots in Setup Host Networks dialog
 - [webadmin] UI is confusing for defining a network connection to a vm
 - [RHEVM] [webadmin] [network labels] incorrect tool-tip display for logical networks assigned to host interface by labeling
 - Remove ovirt-scheduler-proxy external module failed
 - RHEVM user and admin portal logging attempt display
 - [RHEVM] [webadmin] incorrect behavior on creating new VM when rhevm runs out of MAC addresses
 - [oVirt] [Frontend] Blank template is available in New Pool dialog
 - 'engine-backup --mode=restore' fails after engine-cleanup on postgres 8
 - Every thirty minutes OnVdsDuringFailureTimer is shown in engine log
 - [webadmin] incorrect behavior of manual refresh in Host Main Tab
 - Please modify /sysprep file in /etc/ovirt-engine/sysprep folder.
 - [Neutron integration] The Neutron network UUID should be the ID of the network on RHEV
 - Run Once allows starting a ppc64 or Windows 8 VM with SPICE
 - [webadmin] use all available space for network display in Setup Host Networks dialog
 - Ambiguous hint for setting up SSH trusts [TEXT]
 - sysprep timezone is not working when create pool from template.
 - Under Even VM Count Distribution cluster policy minimal values for properties is 5
 - 'engine-backup --mode=restore' fails after engine-cleanup on postgres 8
 - When assigning permissions to user that belongs to a group indirectly, it does not inherit the group permissions
 - No host interface configuration history data for unbounded host interfaces
 - It's possible to set nonsense value of RAM size of vm/template.
 - [oVirt] [Fix] Add sPAPR VLAN in the REST API
 - rhevm-config is over writing the previous 'UserDefinedVMProperties' when used without a semicolon(;)
 - Host stays in non-operation state after unreachable required network becomes accessible
 - engine should report the interface name for which "Used Network resources of host xxxxxxxx [100%] exceeded defined threshold [95%]" message is applicable.
 - CpuOverCommitDurationMinutes limited to a single digit value by regular expression in database scripts
 - RHEVM Admin GUI [Text] - Configure - Roles - "DataCenterAdmin" Description is not fully show
 - Editing VM clears the VNIC profiles
 - [engine-backend] [single-disk-snapshot] snapshot restore to only part of VM's disks will delete all other disks attached to the VM
 - Not able to push more than one external event in 30 second using REST API
 - Tooltip descriptions for Console Invocation are vague
 - VM is not locked on run once
 - Importing image from glance as a template should be blocked on DC level lower than 3.4
 - Upgrade of Spice ActiveX plugin on IE11.
 - [engine-backend] [single-disk-snapshot] [RO-disk] snapshot of RO are not included in the VM snapshots disks table
 - [engine-backend] [RO-disk] [Single-disk-snapshot] NullPointerException for TryBackToAllSnapshotsOfVm when custom previewing a single RO disk snapshot
 - Role UserInstanceManager has import_export_vm action group, but there is no such action in UserPortal.
 - Incorrect error message when coming back from rollback
 - [webadmin] Group 'user name' should be empty value In column 'user name' in user tab.
 - [engine] imported template into domain with its original template causes the imported template to become subversion of the original tempalte
 - [engine] Attempting to import a template that is a subversion of another template when the base does not exist fails with unclear error message
 - [NetworkLabels] Networks with roles should be configured on hosts with 'DHCP' boot protocol
 - Upgrading a hypervisor automatically puts it into an Up state
 - When cache of users is refreshed wrong group id is stored for user group membership
 - [engine-webadmin] [shared-DC] Target domains should be filtered by the source domain type (file/block) for live moving disks from 'Disks' main tab
 - The Memory Size of a VM is editable when the VM is powered up.
 - Disks tab crashes with SQL Exception
 - [RHEVM] error displayed when fencing test fails is not meaningful
 - Changing the label of error network doesn't reattach the network to the nic
 - engine-config man page clarifications
 - engine-backup has no man page
 - Show only setup packages during upgrade check
 - engine should report the interface name for which "Used Network resources of host xxxxxxxx [100%] exceeded defined threshold [95%]" message is applicable.
 - There is no separation between creating a template and subversion template
 - [pki] create lock file accessible only to whom can actually enroll
 - [oVirt] [Fix] SPICE proxy wrong in Pool
 - With VNC and single pci enabled combination, rhevm3.4 failed to create guest-image vm from template
 - VdsNotRespondingTreatment Job is not marked as finished.
 - PRD34 - [RFE] REST API for importing glance image as a template
 - [WEBADMIN][TEXT] Fix popup text, when dashboard is accessed 1st time to more friendly one
 - [RHEVM] [webadmin] inconsistent behavior of gateway field for VLAN with static IP configuration
 - KeystoneAuthUrl description's example is missing the version
 - engine-setup fails on upgrade, tries to install ovirt-engine-setup instread of rhevm-setup
 - RHEVM Webadmin portal displays the vm migration completed time incorrectly
 - RHEV 3.3 - Live Migration fails with ERROR: insert or update on table "step" violates foreign key constraint "fk_step_job"
 - HA vms not starts on host with PM that restarted via engine
 - Template search bar is not working
 - [vdsm] cannot activate storage domain when iscsi multipath is configured on host
 - After host power outage HA vms, failed to run first time because ACTION_TYPE_FAILED_VDS_VM_MEMORY
 - Cannot create pool with pattern-based naming scheme for VMs
 - [RHEVM] engine-upgrade-check => Error: Package ovirt-engine-setup cannot be found
 - The 'Password' field is not visible after selecting a Foreman host in the New Host window
 - Missing "Family" string in Intel Haswell listing name
 - [TEXT] taskcleaner.sh has dangerously misleading help text
 - Not Responding Treatment is broken
 - Cannot add a floating disk from webadmin
 - Failed approved RHEVH for rhev3.2 host in rhevm av4 with Data Centers 3.2 + 3.2 Cluster
 - [Admin Portal] Hot adding 'Dual mode rtl8139, VirtIO' network iface failure - VDSErrorException: Failed to HotPlugNicVDS
 - The RSDL documentation of the cloud-init hostname property should be host.address
 - External_id should be removed from user and group
 - [host-deploy][node-upgarde] Pipe closed at the end of vdsm-upgrade
 - HA VM not start on host with PM after manual fence
 - [AAA] External user UI access unstable
 - Missing fields in snmp notifications
 - UI: Cluster dialog - filter architecture based on the supported CPUs
 - Cant Assign Quotas to external groups
 - ClassCastException when trying to add a permission to admin@internal
 - [engine-webadmin] Default cluster compatibility version isn't correlated to the DC compatibility version when using 'New DC Guide Me'
 - [RFE] 3.4 product translation: translation update 2
 - manage-domains traceback on empty password
 - [RFE] RHEL 7 Guest Support
 - [RHEVM] [welcome-screen]: Non English docs can not be opened from the welcome screen
 - Disallow domains of mixed subtypes (block/file) on data centers with version < 3.4
 - [Admin Portal] Hot adding 'Dual mode rtl8139, VirtIO' network iface failure - VDSErrorException: Failed to HotPlugNicVDS
 - Pre-seeded Apache redirect directive ignored by engine-setup
 - webadmin: wrong data in Alignment column of Disks sub-tab under Storage main-tab
 - RHEV-M server appears to send the bad authentication to the AD server repeatedly, locking the account.
 - [engine-backend] [external-provider] NullPointerException for AddVmTemplate during importing an image from glance as a template
 - Cannot create template - not possible to submit the New Template dialog
 - VM remains locked after failing to migrate
 Bugs fixed between RC and GA:

* [Admin Portal] New VM ignores osinfo properties for network card, it is always VirtIO
 - [ja_JP][Admin Portal] String 'Network Provider' broken into two lines in 'New Host' dailog.
 - can't set a static network via Cloud-Init GUI in 3.3.1-2 beta
 - [engine-backend] Engine copyImage request to vdsm is transmitted with sdUUID value of an inactive SD
 - Balancing cluster doesn't add VM's Predicted CPU load into acceptable hosts load
 - Failed to create data center with default version
 - "too many" permissions needed for creating a VM pool
 - [DWH-OTOPI-SETUP] - Backup handling was removed and restore is done automatically
 - engine-config errors when used by non-root
 - Move sparse raw disk from NFS to iSCSI domain is not supported
 - "OK" button still has focus when editing user-data
 - custom properties sheet: no '-' (remove) button in last row of sheet
 - [backup] extend backup to dwh/reports
 - External users unable to live migrate disks to new storage domain
 - No domain is listed in New VM window: Domain drop down for Windows OS.
 - [webadmin] DC subtabs - refreshes are visible
 - REST API for hosted engine maintenance operations
 - [host-deploy] ovirt-node upgrade results in null point exception if initial installation of node failed in past
 - Labels should be filtered by product (RHEV/Neutron)
 - VM's can't be started after fresh install
 - [ovirt][webadmin] SessionID for REST API stores in browser Local Storage
 - Can't configure vNIC QoS to "unlimited" once it had been set
 - [ja_JP][de_DE][User Portal] String broken into two lines in 'Console Options' dialog.
 - Tracker: oVirt 3.4.1 release
 - [REST API] NullPointerException thrown when importing a template without specifying storage domain
 - installation of rhev-h in webadmin failed due to wrong filename for version.txt
 - manage domains FileNotFoundException exception
 - Distinguish between manual fence resulted from user action and manual fence called internally by auto fence
 - [RFE][notifier] Event Notifications List Text File
 - Label reference missing under Network and HostNics in API XSD
 - [engine-backend] Engine reports that disk resize had succeeded although it failed on vdsm
 - [rhevm-cli]: update vmpool has no --description option
 - rhevm creates glusterfs SD on unsupported datacenter versions (3.2..)
 - Label reference missing under Network and HostNics in API XSD
 - [ALL_LANG][Admin_Portal] Default Storage Domain drop down box is not aligned to the text
 - [de_DE, pt_BR, es_ES, fr_FR][RHEVM-3.4.0.5] [Admin Portal] Help button overlap issue on clusters->New->Console tab.
 - [RFE] 3.4 product translation: translation update 3
 - [host-deploy] missing ssh fingerprint in registration protocol v1
 - [dbscripts] engine-setup fails: ERROR: insert or update on table "tags_user_map" violates foreign key constraint "tags_user_map_user"
 - HTTP 500 on expired session request
 - Uprgrade from is35.1 to av7 fails on dbscript
 - Guide me dialog got stuck(NPE) in DataCenter tab if exists pending approval host
 - engine-config's manual should be updated regarding new command --merge
 - db upgrade fails if there's a subscription to VDS_HIGH_NETWORK_USE event
 - [BUG] can't boot vm with cloud-init data submitted as json via REST api

### oVirt Iso Uploader

* [engine-iso-uploader] INFO: Use the -h option to see usage - when put incorrect iso domain
 - The ISO uploader assumes that the storage domain uses NFS

### oVirt Image Uploader

* Man page for rhevm-image-uploader is missing options

### oVirt Hosted Engine Setup

* hosted-engine fails when cdrom is chosen as the source for the installation.
 - hosted-engine-setup fails at "Waiting for cluster to become operational"
 - hosted-engine script fails with Traceback when cluster doesn't return a CPU type

### oVirt Hosted Engine HA

* agent dies while monitoring the engine

### VDSM

### ovirt-node-plugin-vdsm

* engine_page: use vdsm to detect mgmt interface
 - engine_page: display url/port only on available


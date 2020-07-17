---
title: oVirt 3.5 Release Notes
category: documentation
toc: true
authors: adahms, aglitke, apuimedo, danken, didi, dougsland, eedri, fromani, lveyde,
  moti, mpavlik, pkliczewski, sandrobonazzola, sradco, stirabos, yair zaslavsky, ybronhei
---

The oVirt Project is pleased to announce the availability of its sixth formal release, oVirt 3.5.

oVirt is an open source alternative to VMware vSphere, and provides an excellent KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4 release notes](/develop/release-management/releases/3.4/), [oVirt 3.3 release notes](/develop/release-management/releases/3.3/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/). For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide.html) and the [about oVirt](/community/about.html) page.

# oVirt 3.5 Release Notes

## Live Merge

If an image has one or more snapshots, oVirt 3.5's merge command will combine the data of one volume into another. [Live merges](/develop/release-management/features/storage/live-merge.html) can be performed with data is pulled from one snapshot into another snapshot. The engine can merge multiple disks at the same time and each merge can independently fail or succeed in each operation.

**Note:** This is currently a restricted use case. You must be running a Fedora 20 host that has been updated from the virt-preview yum repository. See [this page](/develop/release-management/features/storage/live-merge.html#important:-special-environment-setup) for more details.

## Import Storage Domain

This latest release expands oVirt's feature of [importing ISOs and exporting storage domains](/develop/release-management/features/storage/importstoragedomain.html) to expand support for importing an existing data storage domain. Based on information stored in the storage domain, oVirt can revive entities such as disks, virtual machines, and templates in the setup of any data center to which the storage domain is attached.

## Advanced Foreman Integration

oVirt 3.5 adds the capability to provision and add hypervisors to oVirt from bare metal. Foreman is a complete lifecycle management tool for physical and virtual servers. Through deep integration with configuration management, DHCP, DNS, TFTP, and PXE-based unattended installations, Foreman manages every stage of the lifecycle of your physical or virtual servers. Integrating Foreman with oVirt helps add hypervisor hosts managed by Foreman to the oVirt engine.

## Enhanced Authentication, Authorization and Accounting Support

A new architecture has been built for oVirt 3.5's [authentication, authorization and accounting](/develop/release-management/features/infra/aaa.html) (AAA) system. The enhancements will provide a clear separation of authentication from authorization and provide a developer API to develop custom extensions for authentication and authorization.

## New PatternFly Interface

oVirt 3.5 will have a new look and feel, using PatternFly, the open interface project. The new look and feel aims to maintain the colors and spirit associated with oVirt, while updating it with a new, modern, sleek, and minimal look. The minimal design allows complex screens to look cleaner and airier, and lets the user focus on the data and the tasks by removing all extraneous visual elements.

## Advanced Scheduling with Optaplanner

The [Optaplanner](/develop/release-management/features/sla/optaplanner.html) is a new service that takes a snapshot of a cluster (a list of hosts and VMs) and computes an optimized VM-to-Host assignment solution. Optimization will is done on per Cluster basis. The administrator can use this information as a hint to tweak the cluster to better utilize resources.

## Other Enhancements

### Infra

*   JSON remote procedure call over stomp was added to the communication layer between the engine and VDSM. This new protocol is designed to be simple, require less parsing than the currently implemented XML remote procedure calls, and introduces asynchronous communication.

### Networking

*   [Unified Persistence](/develop/release-management/features/network/networkreloaded.html#unified-persistence) is a way for oVirt-defined network configurations in hosts to be set in a format that is distribution agnostic and that closely matches the oVirt network setup API.
*   A Neutron Virtual Appliance will be available from the oVirt Image Repository (glance.ovirt.org). For 3.5, the appliance is based on OpenStack IceHouse, listed as ""Neutron Appliance (CentOS X.X) - IceHouse-YYYY.X-XX" on the provided images list.

### Integration

*   It is now possible to setup the engine and [WebSocket-Proxy](/develop/release-management/features/integration/websocketproxy-on-a-separate-host.html), [DWH](/develop/release-management/features/engine/separate-dwh-host.html), Reports on separate hosts.
*   [Hosted Engine](/develop/release-management/features/storage/read-only-disk.html) has now added support for [iSCSI storage](/develop/release-management/features/engine/self-hosted-engine-iscsi-support.html), VLAN-tagged network interfaces, bonded network interfaces, and Red Hat Enterprise Linux 7 (or similar).
*   [oVirt Windows Guest Tools](/develop/release-management/features/engine/windows-guest-tools.html) for oVirt 3.5 are now available as a release candidate.

## Install / Upgrade from Previous Versions

### Fedora / CentOS / RHEL

oVirt 3.5 is now available for use. In order to install it on a clean system, you need to install

`     # yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

If you are upgrading from a previous version, you should have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](/develop/release-management/releases/3.4.1/) for upgrade instructions.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're using pre-release repo you'll need to re-enable pre release repository:

      [ovirt-3.5-pre]
      name=Latest oVirt 3.5 Pre Release
`#baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/fc$releasever/`](http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/fc$releasever/)
`mirrorlist=`[`http://resources.ovirt.org/pub/yum-repo/mirrorlist-ovirt-3.5-pre-fc$releasever`](http://resources.ovirt.org/pub/yum-repo/mirrorlist-ovirt-3.5-pre-fc$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.5`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.5)

and to run:

          # yum update "ovirt-engine-setup*"
          # engine-setup

## oVirt Live

An oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live-el6-3.5.0.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live-el6-3.5.0.iso)

## oVirt Node

An oVirt Node build will be also available soon in:

[`http://resources.ovirt.org/pub/ovirt-3.5/iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso)

Pre-release version is still available here:

[`http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-node-iso-3.5.0.ovirt35.20140630.el6.iso`](http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-node-iso-3.5.0.ovirt35.20140630.el6.iso)

*   To circumvent some SELinux issues, please append enforcing=0 to the kernel commandline when booting the ISO.
*   The ISO is missing the plugin for Hosted Engine, but we hope to deliver an iso that includes this plugin shortly.

## <span class="mw-customtoggle-0" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Known Issues

<div  id="mw-customcollapsible-0" class="mw-collapsible mw-collapsed">
*   If you are using a Fedora 19 host, you have to download libvirt >= 1.0.2-1, which is now a hard requirement (pkg will be provided from ovirt repo, but if it not there, you can update from a Fedora 20 repo: : yum update --releasever=20 libvirt\\\* ).
*   If you cannot refresh an ISO file list after adding a host, see for a workaround.
*   Upgrading from 3.5 alpha can fail due to the structure of a table being different in 3.5 alpha to that in 3.5 beta1 and later .
*   Users that use DWH and Reports from 3.5 first beta will need to run # yum distro-sync "ovirt-engine-dwh\*" "ovirt-engine-reports\*" due to bad rpm release number for DWH and reports packages.
*   Live Merge: Limit merge operations based on hosts' capabilities
*   engine-cleanup could refuse to remove the engine due to a bad handling of not definitive version numbers. For a quick and dirty workaround, simply set RPM_VERSION = '3.5.0_master' in /usr/share/ovirt-engine/setup/ovirt_engine_setup/config.py just for the cleanup. See
*   For proper network configuration, NetworkManager and firewalld have to be turned off
*   If you're updating vdsm package you'll need to remove vdsm-api before updating in order to avoid conflicts with vdsm-jsonrpc
*   When upgrading cluster / data center version from 3.x to 3.5 the default disk profile is not added and needs to be added manually for all storage domains in the data center ( )
*   Foreman integration on CentOS is supported only on CentOS 6.6 due to java package issues

</div>
## <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
### oVirt Engine

*' Fixed in ovirt-engine-3.5.0_rc5**
 - Duplicated CD device when creating VMs from the blank template
 - Cannot start VM with attached ISO
** Fixed in ovirt-engine-3.5.0_rc4*'
 - SPICE ActiveX download fails if user performs upgrade from 3.3.0 to 3.3.1
 - [RFE] VM list of export domain should be populated in alphabetical order
 - gluster bricks marked down in ovirt after vdsm restarted
 - Update storage domain from rhevm-shell fails with java.lang.NullPointerException
 - [ALL_LANG except en_US, zh_CN][Admin Portal] Truncation observed in language selection drop-down at login page.
 - Main grid's refresh button is hidden in low screen resolution
 - On add external provider dialogue report on insufficient parameters on Test
 - [Admin GUI] missing space between left side of column to the content
 - some tabs have grids with no left spacing
 - Cold merge of snapshot hangs and leaves snapshot disks in Locked state
 - Faulty storage allocation checks when importing a VM template
 - [ImportDomain]Import glusterfs domain is not supported,the result is engine remains indifferent to the command and a popup window which never get closed automatically
 - [engine-backend][ImportDomain] Import storage domain - tasks aren't cleared
 - [ImportDomain] Add format check box when removing a Storage Domain from the setup
 - [Admin Portal] [Storage-Disks subtab] odd empty column with 'N/A' tooltip
 - VM Importer Screen does not update disk tab if more than one machine are selected for import
 - [TEXT] Wrong heading at the top of the window while editing Data centers->QOS->CPU | "Edit Storage QOS" instead of "Edit CPU QOS".
 - JBoss Servlet Exception at Page Loads :: no protocol: /ovirt/reports-interface
 - [Event log] GUI> Irrelevant message displayed- "Unrecognized audit log type has been used" after host status set to up
 - [TEXT] Bad parameter in error message when trying to remove the last disk profile of a storage domain
 - [WebAdmin] Detaching a detached domain is allowed
 - memory/configuration snapshots are not deleted when deleting VM's disk,In a case those images were created on File domain
 - RAM & Conf Block lv's are not deleted upon vm+disks removal,in case of 2 block domains
 - Search providers by type gives no result
 - memory snapshots are not deleted when removing a VM with wipe-after-delete enabled
 - non-responding host is selected as a proxy for fencing operations
 - Live Storage Migration fails when trying to return disk to its original Storage domain and Disk profile noting "Cannot move Virtual Machine Disk. Disk Profile doesn't match provided Storage Domain"
 - Operation Canceled Error while executing action: rhel-guest-image-6.6-20140918.2.x86_64: ACTION_TYPE_CPU_PROFILE_EMPTY
 - Failing to Attach a Storage Domain without Disk Profiles to a Data Center 3.5
 - radio buttons are off vertical center from their labels
 - Memory volumes not deleted when removing a vm with snapshots
 - Storage domain committed size is calculated incorrectly
 - [Fencing] stop vdsmd on one host is followed by engine connection problem to the host and to a second host, fencing flow isn't invoked
 - Snapshot locked after successful live storage migration
 - [engine-backend] Cannot put host in maintenance and remove it after a failed installation while the host is non-responsive
 - External sub tasks(step) are not posted in sequential order
 *' Fixed in ovirt-engine-3.5.0_rc3*'
 - [TEXT] Ugly error when POSIX domain creation fails using cifs
 - Faulty storage allocation checks when importing a VM
 - Faulty storage allocation checks when exporting a VM
 - nodeset of numatune is not calculated correctly
 - Missing node index when creating vm numa node
 - Missing vm numa node runtime pinning information
 - Run vm failed if the configured host numa nodes were removed
 - [engine-backend] concurrent host related operations causes to sql exceptions
 - Executing multiple "template.delete" commands in parallel to "vm.delete" commands, creates a race condition which cause the Blank template to be removed from Data Center
 - bookmark selection does not work on first try
 - foreman-integration: declare errors for foreman return values
 - the selection of data center list of storage domains cannot be changed
 - [engine-setup] Reports CSR should be saved also on filesystem
 - [foreman integration] Get generic error when adding discovered host without picking Host Group\\Compute Resource
 - Edit running VM do not fail for invalid memory value.
 - [SLA] [Text] ${detailsMessage} in case there are no available hosts with enough cores to run a VM
 - Live Merge: Engine-side recovery flow for vm restart during merge
 - 2 Entries for every VM in Templated - VMs Tab
 - [ImportDomain]Importing a destroyed storage domain(data) between different setups can cause a NullPointer failure
 - Bond slaves' MAC addresses are reported in upper cases
 - unregistered VM should be the latest one related to the Storage Domain
 - [Network label] RHEV does not allow adding label for a network being used by VMs
 - NUMA UI
 - The text and buttons not aligned in Create VM dialog
 - [ImportDomain] Engine should register existing OVF_STORE disks instead of creating new ones
 - [engine-backend] [importDomain] removal of a template that was imported from a data domain and had additional disks from previous DC is blocked on CDA
 - VMs pool disappeared after creating a Sub Template version
 - Move all maven repositories references into top level pom.xml
 - Can't drag any pop-up windows in GUI
 - [engine-webadmin] 'Configure local storage' window doesn't function
 - placeholders of child commands aren't cleared when failing during the CDA phase
 - [Admin Portal] New Cluster - Fencing Policy - ui alignment is odd
 - Active VM's snapshot Removal is available from rest-api,the result is a useless VM which cannot be activated and db exceptions
 - [engine-backend] [importDomain] Importing a template, which has disks from another domains, from an imported domain fails with PSQLException
 - [engine-webadmin] Failure to import a template from an imported domain is reported wrongly in the events tab
 - Power Management proxy selection keep selecting the same proxy first even is it constantly fails
 - RemoveDiskSnapshotTaskHandler.buildRemoveSnapshotSingleDiskParameters doesn't set the Wipe After Delete property
 - Can't create unattached data storage domain when no DC configured in the setup
 - Live Merge: Regression in DestroyImage step
 - WARN message logged versus DEBUG or INFO message with rhevm-shell provided bogus search
 - Log does not report storage domain correctly
 - Json protocol not being used inspite of selecting the check box during host installation as a part of Guide-me
 - [ovirt] [vdsm-jsonrpm] vdsm-json RPC doesn't provide advice about cluster compatibility level
 - Marshaling issue in fencing flow using jsonrpc
 - Marshaling issue in fencing policy using jsonrpc
 - Foreman discovery code fixes around field validation
 - enable host time drift validation by default
 *' Fixed in ovirt-engine-3.5.0_rc2*'
 - [admin-portal] [UX] unable to see direct lun disk after create and attach since default disk view is set to images
 - RHEVM Backend : VM can be removed while in other state than down, like migrating and powering off
 - "Soundcard enabled" VM property is not exposed in REST API
 - virtio-serial and balloon should be managed devices
 - unaligned radio buttons in edit nic dialog
 - Spice proxy information for VMs not available through the API
 - [engine] disconnectStorageServer is sent \*before\* disconnectStoragePool hosts during remove datacenter flow
 - Changing the CD of a VM that is down generates a NPE
 - [Neutron integration] unlinked vNIC with external network can be plugged to VM
 - [User Portal] 'Cannot connect to console for $VM' for not started VMs
 - [RFE] add rest api support for adding network qos entities
 - Move disk dialog gets stuck in case of a storage connectivity issue.
 - [es_ES][RHEVM-UserPortal-3.4.0-0.5] - Indentation issue found in New/Edit Network Interfaces dialog
 - Format should not be required when adding direct LUN disk
 - OVIRT35 - [RFE] Support cpu SLA features
 - OVIRT35 - [RFE] Support blkio SLA features
 - [webadmin] when creating new VM the nic1 lable is greyed out.
 - [Network labels] Removal of labelled network from DC inconsistent with removal from cluster
 - [Admin Portal] External Provider => Add/Edit => Type: OpenStack Network should be OpenStack Networking
 - [restapi] RSDL does not list import request for images (import Glance images)
 - Don't wipe disks when deleting images on file storage domains
 - [RHEVM] inconsistent required sign on externally provided networks
 - "Domain not found: no domain with matching uuid" error logged to audit_log after live migration fails due to timeout exceeded
 - [webadmin] confusing tooltip on Network label in New Logical Network
 - Create vm via REST with parameter <os type="windows_2008r2"/> will create vm with <os type="other"/>
 - Creating new vm from template with empty disk alias should be blocked
 - [RFE] 3.5 translation - cycle 3
 - Live migrating vm in paused state should warn for Live Storage Migration process
 - [Neutron integration] Provider URL field should be validated when pressing "Test"
 - Unselected disks for custom preview will remove after commit
 - [AAA] simplify login page behavior: send user-name as is (don't parse by '@', etc.), don't disable the Domain drop-down.
 - Edit Network Interface dialog has broken layout
 - bottom edge of External Network Provider drop down menu is not visible in New Host dialog
 - [engine-setup] websocket proxy CSR should be saved also on filesystem
 - [engine-setup] part 3. of engine-setup for websocket proxy (SSL) should instruct to copy files instead of cut & paste
 - [engine-backend] Storage domain activation isn't executed as part of storage domain creation
 - When setting a host to non-operational the problematic Storage domain is not indicated
 - [python-sdk] Unable to delete storageconnection object
 - Need to correct error message when Moving of Disks between Storage domains failing due to Quota limitations
 - using external provider adds redundant scrollbar in host reinstall dialog
 - [Neutron] Decent default values in external network provider dialog
 - generated answer file has duplicate keys
 - Misleading error reported when using multicast MAC address for vNIC
 - redhat logo appears on top of label in configuration menu (and in other dialogs as well, I assume - probably all of them)
 - missing (English) values for several AuditLogType keys
 - Live snapshot creation reported as failed by engine but created successfully
 - Engine remains indifferent to "Select as SPM" command
 - Could-init | enable network 'Start on Boot' without IP/NETMASK/GATEWAY (BOOTPROTO=none)
 - setupNetworks UI | arrows is not align to networks
 - [pt_BR][de_DE][ja_JP][RHEVM3.5][Admin portal] - A little overlapping icons in New Network Interface under Virtual Machine Tab
 - [pt_BR][es_ES][ja_JP][de_DE][RHEVM3.5][Admin Portal] - Check boxes overlapping with the corresponding levels New Logical Network page
 - [Windows sysprep] Run Once: Special characters are not encoded in XML sysprep files for Windows 7, 8, 2008, 2012
 - Align "wipe after delete" option for file disks between GUI and REST
 - [en_US][ALL LANG][User Portal] Broken lines in dialog 'Run Virtual Machine(s)->Display Protocol'.
 - Misalignment in 'New Cluster' dialog
 - [fr_FR][Admin/User Portal] Misalignment in 'New or Edit Network Interface'.
 - [fr_FR][Admin Portal] Misalignment in 'Run Virtual Machines'->'Initial Run'.
 - Direct FC lun disk details aren't validated
 - [Admin Portal] Import Windows VM fails - Error while executing action: Cannot import VM. Invalid time zone for given OS type.
 - Space validation for memory volumes is missing on VM hibernation
 - new Instance type: enable soundcard is not persisted
 - Shared disk is not cloned if it is the only disk defined on VM
 - jsonrpc: It should be possible to edit host "advanced" parameters to change rpc
 - Adding 'DefaultMtu' to engine-config
 - [webadmin] inconsistent column separators in manage network dialog
 - VM dialog: changing 'Optimized For' or 'Operating System' resets various VM parameter values
 - Snapshot state is unclear when custom viewing several snapshots
 - [RHEVM GUI] in 'Add Users and Groups' dialog the column size should be limited.
 - NPE on Cold move disk operation
 - [Hosts]>new/edit> For disabling kdump integration, i need to enable power management first and then disable back.
 - error and remove dialogs are missing padding
 - [webadmin] "profile" drop down in not high enough to display ovirtmgmt in New network Interface dialog
 - [Networks] New/Edit> MTU Field Breaks the window layout, it doesn't look good.
 - remove leftovers from older unsupported versions that exist in the code + DB
 - [Admin Portal]When Remove the last cluster in the right pane its not take effect in the left pane.
 - Clone VM: wrong name is shown in event log when cloning a VM
 - VM custom properties are not saved in edit VM dialogue.
 - Edit running VM vcpu setting applied immediately, though chosen to be applied later.
 - The scroll bar is not aligned with the Edit Role menu box
 - Deactivating master storage domain is allowed while other domains are in preparing_for_maintenance status
 - Unable to add description for "Affinity Group" with space character.
 - Engine don't start when SRV record for domain don't exists in DNS.
 - Unable to add cluster with engine-cli, failing on cpu-architecture
 - no GUI validation on Power Management password
 - adding new storage domain with nfsvers=4.1 fails
 - 500 internal error when adding watchdog to VM via CLI/REST
 - action and model option is missing in add watchdog for template auto-completion
 - engine.log is flooded with messages as "Executing a command: java.util.concurrent.FutureTask , but note that there are 1 tasks in the queue."
 - Missing 'disks' link when listing vm entities for export storage domains
 - [engine-backend] StopSpmOnIrs - When there are "unknown" tasks the spm isn't being stopped but it's not reflected on the execution results
 - [engine-backend] Moving SPM to maintenance fails with an unclear error (RHEL7 hosts)
 - installed VM still booting from CD although first boot device is HDD
 - [REST API] using from filter in an event search doesn't work
 - [ImportDomainGUI]cluster tab text is too similar to the background
 - SNMP trap notification has missing sysUptime field
 - Fencing with proxy from other_dc is actually performed by a proxy in the same dc
 - VM dialog- nic name and vnic profile drop down menu should be aligned
 - Some error messages are enclosed in double quotation marks that are redundant and one message contains a typo
 - Error connecting to VM using RDP if NLA is enabled
 - Delete option for functioning OVF disks should be greyed out
 - [GUI]Row item (vms,data-centers,clusters...) mirrored After remove operation
 - Connection refused when trying to activate host
 - RESTAPI: RSDL does not document all available parameters
 - [engine-webadmin] Move disk pop-up gets stuck and cannot be closed if one of the storage domains in inaccessible
 - [Cloud-init] 'start-on-boot' property is ignored for network interfaces configured by cloud-init
 - CoCo: Automatically persists commands and set status
 - client side sorting for disk/storage size behaves incorrectly
 - status column displays irrelevant values on disks tab under storage
 - Adding networks to an Iscsi Bond will remove all the other existing networks in this IscsiBond and replace them with the new added network
 - Uncheck the virtio-scsi allocation, when cloning vm from snapshot of vm with virtio-scsi disks, will still add the disks as virtio-scsi
 - "Use Foreman Hosts Providers>Provisioned Hosts" option of "new host" fails
 - improve layout of Add Event Notification dialog
 - [SetupNetworks] Network name is break out of layout when the name of the network is long with some signs usage and vlan tagged
 - No health check alert is issued in ui after first message was issued
 - Automatic provisioning ignores db password supplied in answer file
 - Disk Profile select-box shouldn't be visible on DirectLUN disk dialog
 - alignment issues in block storage/disk dialog
 - Fix operations of add,remove and list for StorageConnections in iSCSI Bond
 - vm name field is misaligned on "new vm" pop up window
 - The field of the Network labels should be chosen when creating a label for the Host NIC
 - [GUI] Clicking tab when you are in Network label field adds the first label to the field instead of moving to the next field
 - /api/jobs - HTTP Status 500
 - StorageDomainOvfStoreCount field should be exposed to engine-config tool
 - [engine-backend] Creation of an OVF_STORE disk on a gluster domain fails because shareable disk on Gluster domain is not supported
 - [engine-webadmin] Failure to create an OVF_STORE disk is reported wrongly in the events tab
 - It's possible to remove labeled network from Host NIC with setupNetwork command through rest API
 - Cleanup after failed snapshot disk removal ends with Null Pointer Exception
 - ovirt does not show foreman's compute resources which related to rhev
 - Snapshot disks in locked state after failed delete
 - engine-setup completes correctly only if the engine DB names matches the engine username
 - vNIC re-ordering for any VmCreator user
 - Discover Targets area is not expanded after navigating between available hosts or storage types
 - RNG device tab should not be present in userportal for instance creator role
 - Enabling a watchdog device on VM in edit menu does not work in some languages
 - XSD schema validation error: cpu_profile & disk_profile objects missing 'qos' element
 - Cluster doesn't have a default migration or display network
 - getVMFullList fails when processing externally managed vms
 - Cannot remove current iso cdrom (eject - dynamically remove) using rest-api/sdk
 - Make "No transport is enabled, nothing to do" error more understandable
 - engine-manage-domains always searches for KDC servers over DNS, even when --resolve-kdc is not set
 - Null pointer exception prevents network creation
 - [AAA] ExtensionManager ignores extension ENABLED
 - Edit Instance Type doesn't work
 - [engine-webadmin] [importDomain] Sub-tabs under 'VM import' window are empty
 - engine doesn't configure bridge on host
 - Add user via RESTAPI fails with wrong user_name
 - Fix issues with ActionGroup
 - UploadStreamVDSCommand fails using JsonRpc
 - CVE-2014-3573 ovirt-engine-backend: oVirt Engine: XML eXternal Entity (XXE) flaw in backend module
 - Human readable form needed for AddPosixFsStorageDomain under Tasks when adding a Data/Posix domain fails
 - [New/Edit VM] > Initial run(cloud init) > Networks > NIC section > there is a letter that stuck and can't be removed
 - Automatic provisioning ignores db password supplied in answer file
 - Minor inconsistency in Task action text for Finalizing which has a trailing period (Finalizing.) vs. Validating and Executing
 - Invalid action group identifiers in the roles_groups table trigger NPE
 - When AuthN extension doesn't have link to authZ plugin, internal provider crash
 - Storage Domain version 0 created when version 3 is requested
 - Maintenance Hosts dialog missing padding
 - compilation does not pass due to mistake in translated property files
 *' Fixed in ovirt-engine-3.5.0_rc1 refresh*'
 - [rhevm] Webadmin - Vms - SearchBox "Vms:uptime" doesn't work (Vms: uptime > [nor] Vms: uptime <)
 - No error message displayed when trying to add an already existing (but unattached) SD in a DC
 - Detaching vm disk doesn't lead to ovf update
 - Run vm with odd number of cores drop libvirt error
 - [RFE] engine networking went down, 90% of hosts were fenced causing a massive outage
 - [engine-backend] [iscsi multipath] After networks replacement in an iSCSI multipath bond had failed, the bond's networks aren't being updated back
 - [RHEVM-SETUP] - Upgrade instruction are provided at the end of clean install
 - [Admin Portal] ERROR [org.ovirt.engine.ui.frontend.server.gwt.GenericApiGWTServiceImpl] (ajp-/127.0.0.1:8702-9) Retrieving non string value from session
 - Following Link to Marketplace in FF (29) Opens Marketplace in a Protected Window
 - [webadmin] shorten columns on Host subtab in Network Main Tab
 - [webadmin] shorten column VLAN tag on Networks main Tab
 - foreman-integration: sign host as foreman's
 - NullPointerException when you delete several disks together
 - [Monitoring] Network usage indicator
 - Win7/IE9 - webadmin not usable
 - [setup network] irrelevant message appear when attaching network to nic using label
 - host -> network interfaces: split for name, bond, vlan, network is not right
 - Enable sync of LUNs after storage domain activation for FC - duplicate LUNs
 - GUI Reconnection after disconnection returns Error 500
 - The task of importing an image (as template) from glance repository is never ended
 - NPE when opening SPICE console
 - On data domain creation rest-api should use format V3 by default
 - [RFE] Do not fence hosts when more than X% of hosts are in a Non-Responding or Connecting state
 - [RFE] Option to disable fencing for a cluster
 - permissions logging
 - [en_US][ALL LANG][Admin Portal] Truncated text box 'Custom serial number' in 'New Virtual Machine->System'.
 - [en_US][ALL LANG][Admin Portal] Truncation in 'Random Generator' tab of 'Configure'->'Instance Types'->'New or Edit Instance Type' dialog or 'New VM' or 'New Pool' diglogs.
 - Create user API fails in SDK & CLI - HTTP 400 Request syntactically incorrect
 - Error complaining about missing images for exported VM
 - [fr_FR][ja_JP][Admin Portal] Misalignment in 'New Host' dialog
 - Adding hosts to RHEV-M results in error message
 - UI paging: 'next' paging button is disabled when actually it should be enabled.
 - [fr_FR][Admin Portal] Misalignment in 'Add Users and Groups' or 'Assign Users and Groups to Quota' or 'Add System Permission to User' dialogs.
 - Live Merge: Limit merge operations based on hosts' capabilities
 - instance types: does not remember advanced/basic settings from previously opened dialog
 - NPE when live migrating a disk - using REST and SDK APIs.
 - using "Use Foreman Hosts Providers" disables "Address" field in "New host" dialog
 - Kdump not configured properly on host warning is displayed even when PM is turned off
 - oVirt 3.4 installer does not store all answers in the file
 - engine-config| cannot set mac range with only one mac
 - [Cloud Init] Root password string should be changed with User password string
 - [Cloud Init] Authentication and Custom Script configuration existing in DB is missing in GUI
 - placeholders of child commands aren't cleared when failing during the execution
 - The name box at cloning vm from snapshot menu is too big and not aligned with the text
 - [Admin Portal] Add Permission to User - when a user is selected Enter does not execute 'OK' button
 - "Enable optional reason" selection box in the "Edit Cluster" dialog
 - [ovirt-branding] increment branding interface number
 - failue on SetVolumeDescription shouldn't trigger spm failover
 - Odd vCPU topology dropped by libvirt
 - Transaction issues in CommandsCacheImpl updateStatus
 - improperly calculated amount of available macs in system.
 - Live Merge hangs
 - [AAA] Create user API fails in REST & Java - class cast exception
 - Host life cycle broken for jsonrpc
 - Labels should be filtered by product (RHEV/Neutron)
 - Persist Command at end of execution
 - In Add Users and Groups dialog the namespace drop down is not aligned
 - edit sound card while vm is running isn't saved
 - NPE when attaching a non-existent disk to a VM
 - Comment is missing from snapshots, import/export and edit running vm
 - can't add host: NoSuchMethodError
 - Second suspend of a vm doesn't work
 - OvfUpdateIntervalInMinutes/OvfItemsCountPerUpdate fields should be exposed to engine-config tool
 - all-in-one: align list of supported CPUs with the ovirt-engine list
 - The layout of profiles instance type editor in vm dialog is broken
 - ProcessOvfUpdate - vms/templates without ovf can lead to NPE
 - engine-setup 3.5 with dwh/reports setup plugins 3.4 fails
 - typo in power management health check warning
 - engine-backup fails if bzip2 is not installed
 - Could not import a VM from export domain with raw sparse disks to a block storage domain
 - CoCo: execute flag should set when no exception occurs
 - FreeSpaceCriticalLowInGB variable takes negative values
 - GetAllDisksByVmId - NPE when vm is being removed
 - When importing a VM in ovirt 3.4 disks turn from thin provision to preallocated
 - [REGRESSION] Power management TEST button fails always in 3.4 DC/Cluster
 - Can't change a vm disk's storage domain from a file domain to a block domain when creating a template from a vm
 - Cannot export VM. Disk configuration (COW Preallocated) is incompatible with the storage domain type.
 *' Fixed in ovirt-engine-3.5.0_rc1*'
 - No error when inserting a non-ISO image through the REST API
 - When creating an "external provider network" in rhevm with vlan tag, the vlan tag disappears from GUI
 - comment to "restart vm after enabling virtIO-SCSI" in GUI
 - Missing storage allocation checks when running a stateless VM
 - [Admin Portal] Blank template has 'RHEV' as origin
 - VM's template information is inconsistent after upgrading to 3.4
 - Recommended size of memory is too low for RHEL6 64bit systems
 - Get rid of the fenceSpmStorage calls
 - [engine-backend] [iSCSI multipath] No indication that updating an iSCSI multipath bond doesn't trigger any operation from vdsm side
 - [engine-backend] [iSCSI multipath] It's possible to remove a network from the setup even though it participates in an iSCSI multipath bond
 - [ALL_LANG][Admin Portal] the string "Remove external network(s) from the provider(s) as well." might need some adjustment
 - [Neutron integration] It's impossible to remove a VNIC with Neutron network on it when the Neutron service is down
 - Wrong vnic profiles on vm based on template from another cluster
 - [Admin Portal] Missing tooltip help for 'Mount options' in New Domain/POSIX FS dialog
 - [RFE] 3.5 translation - cycle 2
 - Display of a NIC slave/bond reported as down on the event log with v sign instead of warning sign
 - Command Executor should persist command before submitting to pool
 - Host PM port is empty after disabling PM checkbox and save
 - Fail to update VM with any field, on missing domain name.
 - Cannot add AD group to a new VM from the user portal
 - OVF_STORE disks shows wrong Error msg on remove
 - Class cast exception when fence_apc_snmp fails
 - Editing non-VLAN network shows VLAN 0
 - Pencil on setup network> the pencil on the nic host is located down and right, not straight in the middle
 - Migration progress bar not cleaned on VM crash
 - Host stuck in "Unassinged" state when using jsonrpc and disconnection from pool failed
 - Incorrect error message when creating network with incorrect MTU value
 - [Admin Portal] Broken UI - Provide custom serial number policy
 - Create new VM | Not all selected nics are created on the VM
 - New network dialog | no field validated indication for tabs
 - '-' and '+' signs for custom properties of the VNIC profile do not reside in the same line
 - Unneeded scroll bar when editing VNIC profile or editing specific NIC in setupNetworks
 - Keep validation/event message if there is an iso update to ovirt node host.
 - [RFE][AAA] Display authz namespace at user/group add dialog
 - unlock_entity.sh fails with "psql: fe_sendauth: no password supplied"
 - command infrastructure should know when the "execute" phase finished
 - engine-cleanup should refuse removing a different version
 - ovirt-engine currently sets the disk device to "lun" for all virtio-scsi direct LUN connections and disables read-only for these devices
 - Space validation for memory volumes is missing when creating a live snapshot
 - PreDefinedNetworkCustomProperties differs between different versions of psql
 - Jobs object that contain job with "Removing Snapshot..." doesn't finish
 - [AAA] Present authz name and namespace within user and permissions tabs
 - [python-sdk] Creating a new disk as first attached directly to vm's disk collection fails
 - CommandExecutor should handle exception in CallBackMethods
 - NPE and RTE occurs when cold moving vm's disks between different domains types
 - Missing error message for CANNOT_FORCE_SELECT_SPM_VDS_ALREADY_SPM
 - Rest API operations Fail on oVirt-engine's logs
 - [AAA] Add datacenter\\template permissions to user returns HTTP 500 in REST (null pointer)
 - [AAA] Get users by domain returns partial list of users
 - jsonrpc: Edit host restores default protocol
 - GetRngDeviceQuery should be a user query
 - Custom fencing settings are not saved in DB
 - webadmin-reports SSO is broken
 - Bad error message - no link
 - Live Merge: Fix engine-side flows
 - Backport RNG enum fix
 - [es_ES][User Portal] - Wrong Indentation due to translated strings in New VM page
 - AAA - the format of profile\\user is not supported by REST-API anymore
 - Add or remove network label with Rest API fails with "User is not logged in" error
 - [fr_FR][Admin Portal] Misalignment in 'Import Pre-Configured Domain' dialog.
 - [fr_FR][Admin Portal] Overlapped in 'Import Pre-Configured Domain' dialog.
 - get rid of "Non interactive user" instead of "Unknown" once and for all
 - StackOverflowError during fencing operation
 - Can't search DCs according to compatibility version
 - Can't sort DCs according to compatibility version
 - [webadmin] Host Edit Network dialog - fix custom properties layout
 - Same disk appears multiple times (30!) in the Disks tab
 - Same cluster appears twice in the clusters table with different info
 - Try to import a VM from configuration through REST will cause NPE
 - Clone VM is blocked with ACTION_TYPE_FAILED_TEMPLATE_NOT_EXISTS_IN_CURRENT_DC
 - Squash 3.2 upgrade scripts
 - Admin UI rejects FQDNs ending in a digit when creating NFS storage domains
 **Fixed in ovirt-engine-3.5.0_beta2**
 - PRD35 - [RFE] [restapi] Display the current logged in user in API
 - Engine raises a warning that free space in /var/run/vdsm is less than 1G
 - [userportal] TemplateOwner can't edit template and add/edit vnic in userportal.
 - usability: webadmin difficulty in assigning client ip, no gateway possible
 - [command] remove the use of @LockIdNameAttribute
 - Faulty storage allocation checks when taking a snapshot
 - When openstack/neutron is installed with vlan range 200-300 and ovirt user creates network with VLAN 10, the action succeeds
 - [Neutron]QPID and Bridge mapping configuration should be a must for installing host with Network Provider
 - export types missing from "New Domain" dialog
 - [RHEVM] [webadmin] dropdown menus are not fully filled with grey color in New VM dialog
 - CPU Hotplug config value is wrong in the database creation scripts
 - badly formatted localization, localization value improperly broken to two lines
 - [ovirt][engine-api] CSRF vulnerability in REST API
 - Inconsistency in Snapshot collections links and Snapshot object
 - OVIRT35 - [RFE] add hostname attribute for windows sysprep
 - [rhevm-cli]: update vm has no --memory_policy-guaranteed option
 - There is no limitation on Network Label name length
 - rhevm-shell auto completion does not offer --usages-usage for network creation
 - Inconsistent maintenance mode handling via host-deploy
 - [Network labels] The order of the Network labels on the NIC is random
 - [Network label] When adding a new label, keyboard focus should be presented in the window for that label
 - [Network labels] The last label should be visible in the "Edit interface" window
 - [RFE] Please improve RHEVM Webadmin portal vm migration displayed only into min:sec format.
 - System is not power on after a fencing operation (ILO3).
 - Connect to storage and refresh pool when a domain returns visible
 - CPU hot plug "tool tip", in VM edit dialogue, is not clear.
 - [RFE] Long strings in dialogs adversely affect GUI
 - [engine-backend] live storage migration isn't blocked in case there is not enough free space in the source domain
 - Edit button for Setup Host Networks window should always be displayed
 - [AAA] Missing 'name' field for admin user in /ovirt-engine/api/users object
 - Unclear error message in Event log when failing on removing Neutron network from VM
 - Missing link in usage_message
 - Query execution failed due to insufficient permissions while run GET VM info using user portal credentials
 - psql table, "async_task" isn't cleared,after creation of multiple templates and restarting vdsmd service
 - [RFE] remove log collector as mandatory dependency
 - add new DataCenter mandatory/optional arguments discrepancy.
 - SetupNetwork>edit network(with pencil)>can't edit network
 - Run once vm via REST with <pause>true</pause> parameter, save this parameter true also in next runs
 - foreman-integration: use provided root\\admin password for hypervisor installation
 - foreman-integration: UI: adding hardware details on discovered host
 - fails to run VM - duplicate ID
 - BSOD - CLOCK_WATCHDOG_TIMEOUT_2 - Win 7SP1 guest, need to set hv_relaxed
 - No quota-id option in add disk auto-completion
 - engine-config does not expose VmGracefulShutdownTimeout
 - single_qxl_pci field in webadmin ui always defaults to true even if it is false
 - No link to VMs sub-collections under affinitygroups
 - Failed to remove host xxxxxxxx
 - NPE while using reflection for AsyncTask type: downloadImageFromStream
 - No links to sub-collections under /api/schedulingpolicies
 - Using POST in /api resources results in HTTP 500
 - [RHEVM] Special character handling on VM Description is not correct
 - Cannot change comment of running VM with custom properties
 - Hostname validation during all-in-one setup
 - Configure fence_kdump listener UX inconsistent
 - [setupNetworks] indicate current opened host in setupNetwork dialog title
 - Reason does not get updated when trying to shut down a VM which is Powering up of Shutting Down
 - Impossible to remove user cluster policy via REST
 - Impossible to remove filter, weight and balancing modules from user created cluster policy
 - Error: Kdump detection is enabled for host ' ', but kdump is not configured properly on host. should be warning
 - [VNIC profile] '+' sign for adding VNIC profiles is greyed out when creating a new Network
 - cannot run engine-setup to configure standalone websocket proxy
 - gluster: 'Add Bricks' button in volume creation dialog is not working
 - ERROR: missing FROM-clause entry for table "vms_with_tags"
 - Cannot edit cluster after upgrade from version 3.4 to 3.5 because cpu type (Intel Haswell) does not match
 - Error code 23 when invoking Setup Networks
 - [webadmin] Unexpected tab index in add host dialog
 - Cannot access subcollections of /api/schedulingpolicies/{id}/[filters|weights|balances]/{id}
 - Detaching network from Host when VM has the VNIC profile of that network unplugged fails
 - Live deletion of a snapshot (live merge) fails to find constructor for RemoveSnapshotSingleDiskLiveCommand
 - API: Interface name is not set via cloud-init api
 - reconstructMaster() takes exactly 10 arguments (9 given) when using jsonrpc
 - [AAA] Sort list of domains alphabetically
 - Can't regenerate Java SDK due to incorrect types in RSDL
 - Can't instanciate LiveMigrateVmDisksCommand
 - [engine-setup] engine-setup just to configure websocket proxy instructs user with wrong commands
 - Null configuration key is listed
 - [AAA] NPE is raised when searching user in domain by lastname.
 - When invalid config exists in /etc/ovirt-engine/extensions.d, engine don't start
 - [AAA] Unable to search all users via REST or UI
 - Scheduling policy update fails in REST
 - Remove network with network custom properties from Host fails
 - Warning about OVF disk when creating a domain
 - Engine throws NullPointerExceptions,after creation of multiple templates and restarting vdsmd service
 - NPE when trying to allocate VM from pool
 - Ability to sort network-related columns
 - AAA - Uses synchronization mechanism should be improved
 - [AAA] AAA Rewrite minor issues and fixups

**Fixed in ovirt-engine-3.5.0_beta1**
  - PRD35 - [RFE] Mechanism for adding additional fence agents to mgr
 - ovirt-engine-backend : uninformative error while trying to retrieve ISO list when ISO domain is inactive
 - PRD35 - [RFE] rhevm-websocket-proxy - using as standalone service - automatic configuration
 - PRD35 - [RFE] Need API to 'unlock' a running VM when connecting to it through the REST API
 - stopping the engine service while fencing is in progress might result in powered-off hosts
 - PRD35 - [RFE] Give notification to Admin User, when RHEV Storage Domain approaches the limit of 350 LVs
 - New VM window | Add NIC | The NIC name can start from any number instead of nic1
 - vm dialog -> boot order -> first device resets the second
 - OVIRT35 - [RFE] Allow long running operations converging by vm stats monitoring
 - VMs get stuck in 'Unknown' state when power management is not working.
 - [oVirt] [Fix] Enable balloon by default
 - RHEV 3.3 rhevm-shell can't change cluster policy to a custom policy
 - [engine] exporting thin-provision vm and its template in parallel fails with deadlock in db
 - When RHEV reports a problem with a storage domain, it should report \*\*which\*\* storage domain
 - [User Portal] Three squares loading indication missing in Events subtab
 - OVIRT35 - [RFE] Allow setup of ovirt-websocket-proxy on separate machine
 - OVIRT35 - [RFE] replace XML-RPC communication (engine-vdsm) with json-rpc based on bidirectional transport
 - notifier daemon is not keeping startup settings after upgrade to 3.3
 - PRD35 - [RFE] - introduction of Command-Coordination infrastructure
 - OVIRT35 - [RFE] using foreman provider to provision bare-metal hosts
 - Override MTU keeps old MTU value when disabled
 - [webadmin-ux] contextual helper window has no scroll bar
 - compensation in removeStorageCommand fails
 - Searching for objects that _do not_ have a tag in the search bar is not possible
 - [engine-backend] [iSCSI multipath] Required cluster network shouldn't be allowed to be added to an iSCSI multipath bond
 - [UI] Vmpool/cluster SPICE proxy address format info is missing.
 - Importing an Export/ISO storage domain automatically activates the domain
 - Inconsistent VirtIO direct lun disk attachment behaviour.
 - The metadata of the move and copy disk operations is ignored
 - Reduce blocking operations as part of hosts & VMs monitoring cycles
 - Possible to create template from vm without disk via REST on cluster without hosts and storage domains
 - [host-deploy] host-deploy should be able to work with (remote) /tmp as noexec
 - Refresh capabilities is greyed out for non-operational Host
 - [RHEVM] [neutron integration] change rpc_backend to neutron in neutron.conf
 - PRD35 - [RFE] Drop Linux bridge plugin support from neutron integration
 - AAA: User name contains domain name twice
 - Deadlock detected when performing plug/unplug VNIC action
 - application list database limit is too small (4000 chars)
 - [RFE] Add column sorting to VM main tab
 - Failed VM migrations do not release VM resource lock properly leading to failures in subsequent migration attempts
 - Every SearchQuery is improperly evaluated as unsafe expression.
 - improper exception handling
 - VM Pools do not properly inherit admin roles in the admin portal
 - Console USB configuration not persisted on Edit VM window
 - RHEV needs to support 4,000 GB of Memory
 - [RFE] Add column sorting to Template main tab
 - [RFE] Add column sorting to Pools main tab
 - the length of network QoS's name is inconsistent with the tooltip
 - Issue / strange behavior with GlusterFS nodes
 - [Neutron integration] Custom device properties are not passed to vdsm
 - upgrade doesn't migrate correctly from jboss-as to ovirt-engine-jboss-as
 - unable to create storage domain
 - if getReturnValue().setSucceeded(true); is called before exception is thrown command is presented as successful.
 - "e-mail" column header could use capitalization in Users tab
 - Upgrades from 3.5 on should look for Command Coordinator related changes to Aysc Tasks
 - Force remove storage domain from data center causes data corruption to remaining vm's which had disks on the removed domain
 - [AAA] Not possible to add group via REST API.
 - Custom Sysprep / Custom Script editor: Enter key appends new-line always at the end of the textarea
 - NPE on generateOvfStoreDescription
 - User fails to get attached to a prestarted pool in case messages parameter of canRunVm is null - NPE is throwed
 - vdc_options' GuestToolsSetupIsoPrefix uses downstream value, prevents auto-attaching ovirt-guest-tools
 - log is flooded with unclear message regarding vmjobs
 - [upgrade/async-tasks] 'Plugin' object has no attribute 'queryBoolean'
 - Disk image dynamic data is updated with stats reported by a vm that a snapshots of the disk is plugged to
 - [engine-manage-domains] Engine tries connect to ldap servers which are not specified in --ldap-servers option
 - Same connection is sent multiple times on ConnectStorageServer
 - Spelling issues in several engine-config keys
 - NPE on logging task with no vdsm task ID
 **Fixed in ovirt-engine-3.5.0_alpha2**
  - UserRole permission on System/DC/Cluster doesn't work as expected
 - malformated guid's cause http 500
 - webadmin: we can create a V1 format posix domain when selecting "None" option in Data Center
 - [engine] Storage Domain that was destroyed from GUI did not get completely removed from DB
 - [ja_JP][fr_FR][Admin Portal] Truncation string in the message of 'Tasks' pane.
 - [rhevm] Webadmin - SearchBox "Template: childcount <1" doesn't work anymore
 - [RHSC] Error message on failure to start remove-brick needs correction.
 - [RHSC][RFE] Sort the host column in the Clusters Services tab, when 'Show All' is used.
 - [engine-backend] Hotplug disk isn't blocked while VM is in illegal state for disk hotplug, when attaching a disk with active=true
 - [RFE] A failure in a merge operation should fallback to a partial merge, not a broken snapshot
 - [RFE] Restart HA VMs when power management reports host is in powered off state
 - [webadmin] [network labels] missing Label information in In Network main tab ---> the 'Hosts sub-tab'
 - OVIRT-CLI: async parameter counts any value except true as false when it should accept only true/false values
 - [RHSC] - Skipped file count filed should be removed from the remove-brick status dialog as it is always going to be zero.
 - [RHSC] - Rebalance icon in the activities column changes to unknown (?)
 - Provide informations about fencing in RHEV-M
 - [notifier] 'VM is down with error' event has mail subject 'VM $vmname is down. Exit message: $reason'
 - bogus DB entry - VDS_INITIATED_RUN_VM_FAIL event_up_name
 - Non operational host- audit log doesn't contain bond's name if there is also problematic nic
 - Event ID 1200 (VM rename) does not record the initating User id
 - Tool tip hovers permanently in the Virtual Machines - Disk Tab
 - [RFE] NFS custom mountoptions
 - Domain of group is not shown in general sub tab of users tab.
 - [GUI/General sub-tab] Windows-based Template & Pool: Time Zone is blank when set to the global default
 - Reboot button is not disabled for VM pools
 - [TEXT] Attaching disk to vm in 'reboot in progress' state returns a confusing Operation failed message
 - ;current should work for cdroms collection, not just for cdrom resources
 - The Expect header is ignored
 - [engine-backend] [iSCSI multipath] Internal engine error when vdsm fails to connect to storage server with IscsiNodeError
 - misaligned arrow icon in footer bar
 - Import VM fail on 3.3 "Cluster doesn't exist", though it does exist.
 - [RFE] Support logging of commands parameters
 - do not use com.google.gwt.user.client.Cookies in ReportModel
 - iscsi storage dialog - alignment issues
 - [RFE] Support single disk snapshot on preview snapshot action in REST-API
 - Run once vm via REST with <pause>true</pause> parameter, save this parameter true also in next runs
 - Cluster Compatibility Version should default to the latest version
 - In webadmin, the newly introduced Console side tab in new/edit cluster dialog to configure a SPICE proxy for individual clusters is NOT required and should be removed
 - GUI fields unaligned since Look&Feel patch
 - [engine-backend] When committing a snapshot that contains disk and conf. of the 'Active VM', engine doesn't report about the result of the operation
 - "CPU Architecture" should be removed from New/Edit Cluster dialog window
 - [engine] [RO-disk] Disbale read-only VirtIO-SCIS LUN disks in the GUI
 - Need warning message for moving sparse disk from file to block as it will become preallocated
 - [Python/Java SDK]HostNICLabel.add and NetworkLabel.add methods lacks expect and correlation_id parameters
 - After adding two power management agents to a host, impossible to remove/override second agent
 - Creating vm from template Menu has options that are redundant
 - [engine-backend] [external-provider] engine failure while createVolume task is running in vdsm (as part of importing an image from glance), leaves image in LOCKED state
 - Cannot approve hosts using REST API
 - [LOG] Ability to log org.ovirt.engine.core.common.businessentities.LUNs class
 - Incorrect schema or REST API answer
 - [REST API] Missing VM statistics field.
 - Performing Live Storage Migration when target domain equal to source domain will cause infinite loop of 'LiveMigrateDiskCommand'
 - in the Sessions sub-tab of Virtual Machine press F5 to refresh the webpage failed(display blank page)

**Fixed in ovirt-engine-3.5.0_alpha1.1**
 - [rhevm-dwh] History DB - Change Fields "Network Name" to "Logical Network Name"
 - [Admin Portal] User $user@$domain attach to VM <UNKNOWN> in VM Pool test was initiated by $user.
 - [RHEVM-RHS] iptables rules are not set on RHSS Nodes, when importing existing gluster cluster configurations
 - novnc didn't connect because the clocks of websocket proxy and the host weren't in sync.
 - Can't create network with empty VNIC profile
 - [RFE] add Debian 7 to the list of operating systems when creating a new vm
 - [RFE] Set 'save network configuration' default to 'true' on setup networks dialog
 - Venezuela Standard Time not included in timezone list for Guests (GMT -04:30)
 - Invalid target of --generate-answer option causes error indicating the entire installation has failed
 - [RFE] Add periodic power management health check to detect/warn about link-down detection of power management
 - Rename New Pool->"Pool" tab to "Type"
 - [SCALE] - storage_domains_with_hosts_view generate slow query
 - [engine-webadmin] Cannot create an export domain under local DC
 - A movement operation of raw sparse disk from file to block domain results in Raw preallocated disk, but reports its type wrongly in the webadmin
 - failed to create VM if no NUMA set is specified
 **Fixed in ovirt-engine-3.5.0_alpha1**
 - webadmin: after discovery of luns if we press the left side of the dialogue we move to the bottom of the list of luns
 - mouse-cursor stuck on resize-image after closing a dialog while re-sizing it.
 - [RFE] webadmin [TEXT]: unclear warning that template of linked vm does not exist in export domain
 - storage allocation checks when cloning a snapshot
 - [RFE] Allow guest serial number to be configurable
 - Improve quota storage related details - disk column|list
 - Escape single underscores in spice client foreign menu labels so that they aren't intepreted as hot keys
 - webadmin [TEXT]: unclear warning when exporting a vm dependent on template without the template
 - [Admin Portal] changing os type switches usb_policy to disabled
 - engine: cannot deactivate a domain when it has an inactive disk attached to a running vm
 - Password validity time related information is missing in "console.vv" for rhevm 3.2.
 - SearchQuery generates slow query on vds_with_tags and storage_domains
 - [RFE] [oVirt] [webadmin] Tree doesn't refresh
 - [RFE] Ability to dismiss alerts and events from web-admin portal
 - [RFE] Re-work engine ovirt-node host-deploy sequence
 - [RFE] [User Portal] Right hand pane in user portal takes too much space
 - If you try to create a storage connection with empty port, then it is set to 0
 - New Template: comment is not saved when creating new template
 - [RFE] rename gwt-extension.jar->ovirt-engine-gwt-extension.jar
 - Adding a new VM and choosing the OS of any linux, prevents you from changing the time zone.
 - Default route is not set properly for management network if downstream/upstream engine and VDSM are mixed
 - [RFE] Search VMs based on MAC address from RHEVM web-admin portal
 - [TEXT] Tell user to let engine know where keystone auth endpoint lives
 - [RFE] [rhevm] Webadmin - RFE - Run Once from CD should Show ISO name
 - Tools iso gets mounted to untooled VM even when CD is unchecked in "Run Once" dialog
 - remove the use of health servlet
 - [RHEVM][webadmin] adjust dimensions of Create New Bond dialog window
 - VM has 1 network interface. Assign a profile to it. appers although a profile was selected
 - [RFE] Save "domain related" OVFs on any data domain
 - [Usability] mouse-cursor range for column resizing is too narrow and asymmetric
 - Misleading message is displayed when VM image is locked and user tries to create VM via CLI
 - [RFE] Add FreeBSD to the list of VM operating systems
 - [Text] Event "State was set to Up for host <hostname>." is miss leading.
 - Cannot obtain console.vv from a mobile device browser in User Portal
 - Start service ovirt-websocket-proxy gives warning
 - After deleting image failed ui display message: Disk gluster-test was successfully removed from domain gluster with storage failure
 - Strange UI bug: tab "VM" unusable / oVirt 3.3.1+
 - [RFE] support BIOS boot device menu
 - [RHEVM][UI] redundant vertical scroll-bar in New Virtual Machine dialog
 - [Neutron integration] Importing network should choose DC from which this action took place
 - [Neutron integration] Hide incompatible Clusters when adding an external network
 - pending memory not cleared when resuming paused VM after a minute
 - [RHEVM] cannot put 3.3 host into maintenance after failed addition to 3.4 cluster
 - Faulty storage check when adding a VM with disks
 - Run Once - no way how to start without a CD if one is defined in Edit VM
 - [RFE] Allow to perform fence operations from a host in another DC
 - rhevm-manage-domains edit requires provider
 - [oVirt] DiskMapper does not map the Description field
 - there is no indication of failures in the external scheduler filters
 - Clarify CPU labels on frontend
 - [RHSC] Host does not move to non operational even after glusterd is made down .
 - Optimized for field does not display correct value when creating a pool
 - [RFE] Tree view and tabbed view are out of sync
 - [RFE] add an explanation tool-tip to the 'Feedback' button (since button behavior may be unexpected/not-understandable in some browsers/clients)
 - New/Edit VM dialog: VNC Keyboard Layout option is initially shown for SPICE protocol too
 - PRD34 - [RFE] port reports installer to otopi
 - [RFE] clone vm - support copy/duplicate virtual machines (without having to create a template)
 - [RHSC] - Rebalance icon in the activities column chnages to unknown (?)
 - engine is requesting service reports-ui & its config file
 - [RFE] Description field in Virtual machines tab
 - Remove the usage of dynamic queries from code
 - Network label name should not be used when associated with the Neutron
 - No tool-tips for truncated labels in general host info sub-tab
 - Pending memory is always decreased from dedicated host on run vm
 - Changing cluster policy to 'None' not clean properties
 - Default OS is not selected correctly
 - No pending mem & cpu is reserved on migrate to host
 - display the actual CPU allocation of a VM to manage inconsistencies
 - Potential NullPointerException at Entities.ObjectNames method
 - [engine-config] no values for versions 3.2 and up for EnableMACAntiSpoofingFilterRules
 - too long changePasswordMsg breaks the layout
 - engine: clone vm from snapshot will not clone the template origin
 - Empty properties panel for cluster policy None
 - [Neutron Integration] Default Gateway and DNS are missing when creating Network on External Provider
 - wrong boot order when trying to boot from CDROM while using cloud-init
 - Cannot run VMs on host while VM is migrating to it
 - We can not know from the DB, if VMs running with run once are using an ISO file.
 - [RFE] host right click menu is missing 'reinstall' option
 - [RFE] Maintenance operations on a VM would ask for an optional reason
 - Tooltip descriptions for Console Invocation are vague
 - [RFE] High Availability flag should be included for template when exporting/importing from Export Domain
 - [RFE] UI plugin API - add SystemTreeSelectionChange callback
 - [oVirt] [Fix] Changes in selected template does not update the OS list
 - [oVirt] [AAA] ModuleNotFoundException: extension-manager is not found in local module loader
 - [engine-backend] NullPointerException for CanDoAction failure of reconstruct master during re-initialize to a new DC from an unattached domain
 - [RFE] RHEVM GUI - Add host uptime information to the "General" tab
 - [RFE] Wipe after Delete flag modification while VM is Up
 - CpuOverCommitDurationMinutes limited to a single digit value by regular expression in database scripts
 - Misleading error message when user with ClusterAdmin role on cluster tries to add a disk to a VM without permissions on any storage domain
 - [Admin Portal] Left-pane tree not uncollapsed (to previous width) after web page refresh with double-clicking on splitter-bar
 - [Admin Portal] Left-pane tree not uncollapsed to previous width after web page refresh with button click
 - [Admin Portal] Main tabs depiction is broken after refresh/relogin when left-pane is not default width
 - [Admin Portal] Action bar broken and non existence of drop-down menu in areas with splitter-bar
 - Remove VM in preview should be blocked in the CDA phase
 - [Admin Portal] Refresh of left-pane tree collapses the tree
 - Cloud-init is enabled in the UI for non-Linux hosts but it doesn't do anything
 - [RFE] consider the event type while printing events to engine.log
 - Restapi throws ClassCastException when search by unknow value
 - [engine-webadmin] unclear error message for adding a POSIXFS domain to a 3.0 shared DC
 - [engine-backend] [external-provider] failure to import a glance image (as a template) leaves image in LOCKED state
 - Remember whether 'Show Advanced Options' is expanded or not
 - [RFE] Expose bookmarks through REST API
 - can't lower the compatibility version of the default cluster
 - Search enable domain search for Vm and Template
 - No error message is displayed, when creating several labels with the same name for the same NIC
 - Host's Compatibility Version doesn't match the Cluster's Compatibility Version
 - [RHEVM] default profile on rhevm network is named ovirtmgmt
 - Internet Explorer - Console Client Resources window is too small to display whole content
 - [Neutron integration] Incorrect error message when adding sunbet with wrong CIDR value
 - deployments take more than 60 seconds
 - User and System CPU Usage have values higher than 100%
 - [notifier] Inconsistency of console event messages
 - [vdsm] disk hotplug fails in case other disks were hotplugged while it was deactivated
 - [RFE] Display of NIC Slave/Bond fault on Event Log
 - AuditLog anti flooding mechanism could cause some messages to be missed.
 - [RFE] Enable user defined Windows Sysprep file
 - USB Support select box always shows "Disabled" choice.
 - Wrong parameter is passed to GetDomainsList query during adding a group
 - Minor typos found during translation
 - [branding] engine-setup says "login into oVirt Engine"
 - ovirt-node reinstall/approve should use root user
 - [REST-API] Can't set display network if display=false and usages.usage is display
 - Cant Assign Quotas to external groups
 - [REST API] NullPointerException thrown when importing a template without specifying storage domain
 - [engine] [RO-disk] Direct-LUN connected by Virt-IO-SCSI which is configured to be RO to a VM is writeable
 - Run once vm with attached cd, not attach payload
 - [RFE] add progress bar for VM migration
 - Hot plug causes the breach in quota enforcement
 - console.vv file does not display name of VM for VNC consoles
 - The hosts max_scheduling_memory should be updated when a live migration starts.
 - [RFE] Please add host count and guest count columns to "Clusters" tab in webadmin
 - Break bond by detaching the network label cannot be done in one step
 - template of thin provision NFS,can't be copied to block data domains
 - [Network Label] Cannot break bond with Network label attached by break bond action
 - "Failed to attach network to Cluster" error message when trying to create new network with label that used to be on Bond
 - Engine should not send defaultRoute in clusterLevel <= 3.3
 - [User Portal] Windows VNC-based VM are opened via RDP by default in User Portal
 - red rectangle is not shown if user forgets to fill in password in Install Host dialogue
 - Query GetStorageDomainByNameQuery failure: bad SQL
 - Restapi throws NPE when POST action for end job step is sent.
 - Cannot sysprep Windows VM with different time zone than the one set in VM dialog / System side-tab
 - [slow webadmin portal] multiple calls to GetVmCustomProperties, should be cached
 - SuperUser of DataCenter X cannot approve a host under this Data Center
 - [RFE] History DB should sync user's first and last name for user usage tables.
 - Null exception when unknown tag is posted
 - Extending Preallocated Read Only Disk should fail
 - Extending Thin provision Read Only Disk should block with canDoAction
 - NullPointerException raised while perform REST API request api/vms/\*\*\*/applications for VM w/o installed applications
 - New Power Savings Policy Parameters are not in Beta 3 Build
 - Failed to commit custom preview of snapshot
 - Unable to upgrade rhevh - Please select an ISO with major version 6.x
 - timeout, install failed: Sending iso from ovirt-engine to ovirt-node during upgrade
 - Neutron: Failed to install Host neseted_host_1. Failed to execute stage 'Misc configuration': list index out of range.
 - [host-deploy] support more ciphers for ssh - upgrade apache-sshd to 0.11.0
 - Block IDE disks and VirtIO-SCSI disks when attaching/updating
 - Default cluster/Data center compatibility version should be 3.5 and not 3.4
 - While executin rhsc-cleanup, it shows an error "[ ERROR ] Failed to execute stage 'Misc configuration': Command '/sbin/chkconfig' failed to execute"
 - Engine all in one fails

## VDSM

* OVIRT35 - [RFE] internationalize exitMessage; use meaningful exitCode
 - VDSM: vm with cd as first device when iso domain is blocked from host, will remain in 'wait for launch' with no pid until backend will change domain state to inactive
 - PosixFS issues
 - PRD35 - [RFE] report SELinux policy and show it in UI + warn when not enabled
 - PRD35 - [RFE] Allow guest serial number to be configurable
 - refreshStoragePool fails if domain is upgraded from format v1 to format v3
 - [RFE] Add virtio-rng support [EL 6.6 only]
 - [RFE] report BOOTPROTO, BONDING_OPTS, GATEWAY, and IPADDR independent of netdevice.cfg
 - VM live snapshot creation failed - when qemu does not support this operation
 - PRD35 - [RFE] Report guest Buffered/Cached memory
 - Vdsm silently drops a VM that crashed while Vdsm was down
 - OVIRT35 - [RFE] support BIOS boot device menu
 - VM migration back to original host fail on "file exists"
 - [RFE] How can I disable cut and paste in SPICE via RHEV?
 - [vdsm] [Scalability] When host is loaded with networks - addNetwork and getVdsCaps takes a lot of time to return.
 - Recommended default clock/timer settings
 - RHEVH doesn't connect to engine (rhevm) no retries \\ error reporting to user
 - Failure to replace a partially-removed network
 - vdsm does not reflect speed of underlying interface for VLANs
 - deprecate auto creation of REQUIRED_BONDINGS
 - PRD35 - [RFE] RHEVM GUI - Add host uptime information to the "General" tab
 - Adding an additional network over a bond incorrectly overrides the bond mtu when the new net mtu is lower
 - VDSM internal exception gathering balloon info while shutting down
 - "data has no embedded checksum" warning when attaching new storage domain
 - [RFE][host-deploy] vdsm-upgrade to use ovirt-node-upgrade
 - OVIRT35 - [RFE] Prevent host fencing while kdumping
 - vdsm depends on rsyslog
 - PRD35 - [RFE][scale]: Replace the use of oop with ioprocess
 - OVIRT35 - [RFE] NFS custom mountoptions
 - The start time for 'migration_max_time_per_gib_mem' appears to be calculated too early.
 - VDSM is consuming a lot of cpu time even with no active VMs
 - [RFE] Provide a way to attach vNICs to a bridge not managed by RHEV
 - VM Disk extended after snapshot until block storage domain is out of space
 - releaseVm() takes too much time when VM doesn't want to die
 - PRD35 - [RFE] Expose prepareImage and teardownImage commands in vdsClient
 - deleteImage command after LSM fails with Resource timeout code 851 cause image status 'Illegal'
 - [setupNetworks]IP address for BOND is not updated on the host
 - failing to start VM due to port key error
 - lastClientIface whould be reported over jsonrpc
 - [SCALE] VDSM is consuming a lot of CPU time even with no active VMs on 100 NFS storage domains
 - Missing vm numa node runtime pinning information
 - [RHEVM] adding host with VLANed network using dhcp fails
 - vdsm should advertise inifiniband speed
 - OSError: [Errno 16] Device or resource busy: '/etc/sysconfig/network-scripts/ifcfg-eth0'
 - Windows XP VM hangs after live migration
 - /var/lib/vdsm/persistence/netconf is not persistent
 - BSOD - CLOCK_WATCHDOG_TIMEOUT_2 - Win 7SP1 guest, need to set hv_relaxed
 - Missing m2crypto dependency on vdsm-python rpm
 - vdsm fails to configure libvirt module when yum updating from 4.10 version to 4.14
 - VDSM trying to restore saved network rollback
 - Unable to extend image over jsonrpc
 - Vdsm sampling threads unexpectingly stops with IOError ENODEV
 - refreshing iso list fails with: AttributeError: '_IOProcessFileUtils' object has no attribute 'validateQemuReadable'
 - Host installation fails: sasl passwd.db missing - File "/usr/lib64/python2.6/site-packages/vdsm/tool/passwd.py", line 50, in set_saslpasswd
 - StoragePool_disconnect: disconnect() takes exactly 4 arguments (3 given)
 - Shuting down protocol detector fails
 - hosted-engine-setup fails with ioprocess oop_impl enabled
 - [vdsm] live snapshot creation fails on block storage with unsupported configuration: source for disk 'vda' is not a regular file; refusing to generate external snapshot name
 - reconstructMaster() takes exactly 10 arguments (9 given) when using jsonrpc
 - network rollback does not take place
 - Extending thin provisioning disks should not rely on racy isLocked()
 - RHEV-H: vdsm not starting due to connectivity.log root ownership

## ovirt-node-plugin-vdsm

* engine_page: catch exception from vdscli.connect()
 - engine_page: replace netinfo to xmlrpc
 - engine_page: set password when no address is used
 - spec: remove uneeded sed's
 - engine_page: Display correctly proto for Manage by
 - engine_page: Remove Retrieve Certificate button
 - engine_page: network is required to register tab
 - engine_page: add exception for ENETUNREACH
 - hooks: Adding hooks for ovirt-node-upgrade
 - engine_page: remove dep. from ovirt_config_setup.engine

## oVirt DWH

## oVirt Reports

## oVirt Image Uploader

fixed in second rc

* image uploader's rpm should provide required user on install if missing
 - rhevm-image-uploader ignores insecure option
 fixed in first rc

* option insecure doesn't work
 - uploading an ovf file to an export domain creates tmp folder with vm's full size

## oVirt ISO Uploader

fixed in rc

* --insecure options still requires a valid CA cert
 - iso uploader's rpm should provide required user on install if missing
 - 'NoneType' object is not iterable error when certificate validation fails
 fixed in beta

* option nossl does not work
 fixed in alpha

* option insecure doesn't work

## oVirt Log Collector

fixed in first rc

* /etc/rhevm is not collected
 - [log-collector] no engine.log in the final archive
 fixed in beta

* engine-log-collector help default logfile path does not make sense
 - missing sosreport.html from postgresql-report-admin
 fixed in alpha

* [engine-log-collector] problem with sos3 on rhel7 as general.all_logs no longer exist
 - "rhsc-log-collector" takes too long even to prompt for the REST API password before it actually start collecting information from selected servers

## oVirt Hosted Engine Setup

Fixed in 4th rc:

* [Hosted-engine --deploy] > Can't configure management bridge over Vlan, default gateway is removed during deployment
 - Report "The specified OVF archive is not a valid OVF archive" during select boot vm from disk
 Fixed in third rc

* Failed to execute stage 'Environment setup': [Errno 2] No such file or directory: '/etc/pki/vdsm/certs/cacert.pem'
 - hosted-engine --deploy fails due to missing vdsm certificates

Fixed in second rc

* [self-hosted-engine] Adjust engine management network settings when deployed over VLAN
 - Report error as 'Hosted Engine HA service are already running on this system' when first configure hosted engine
 - Installation of second host failed, if given incorrect FQDN of first host for answer file
 - Deploy of second host with different network interface failed
 Fixed in first rc

* Need warning message, that appear when you run hosted-engine --deploy via ssh without terminal mode
 - Hosted Engine on iSCSI setup doesn't allow LUN choice
 - don't ask if the engine installation is complete when setting the second host
 - multicast mac address should be filtered by hosted-engine-setup
 Fixed in second beta

* hosted-engine --deploy does not check for NX flag
 - Failure to add initial host to Default cluster prevents the 'engine_api' variable from being set properly
 Fixed in beta

* OVIRT35 - [RFE] Allow setup of iSCSI based storage for hosted engine
 - can't setup second host when using iscsi
 - PRD35 - [RFE] At the end of the HE install wizard the default to install in "No", and if you choose it, it will forget all wizard settings.
 Fixed in alpha

* hosted engine deployment always try to add hosts to cluster named "default". If the cluster name is different host won't be automatically added to RHEVM.
 - If cluster=Default does not exist in hosted-engine it will fail and timeout
 - hosted-engine setup fails when using VLAN tagged interfaces
 - [RFE] Hosted Engine deploy should support VLAN-tagged interfaces
 - [RFE] [ovirt-hosted-engine-setup] add support for bonded interfaces
 - missing dependency

## oVirt Hosted Engine HA

Fixed in GA

* can't start hosted engine VM in cluster with 3+ hosts
 - ovirt-ha-agent goes into D state when the RHEV-M VM is hosting the ISO domain and goes offline
 Fixed in 4th rc

* E-Mail Spamming from Node during HA state changes
 Fixed in second rc

* prepareImage api call fails with [Errno 2] No such file or directory
 Fixed in first rc

* Hosted-engine --deploy failed with message "Hosted Engine HA services are already running on this system"
 - No error logged when agent restarts (ovirt-hosted-engine-ha-1.2 branch only)
 Fixed in second beta

* Migration of hosted-engine vm put target host score to zero
 - After host restart, storage domain not mounted automatically
 - If two hosts have engine status 'vm not running on this host' ha agent not start vm automatically
 Fixed in beta

* [RFE] Integrate hosted engine with vdsm using ISCSI storage doamain
 - can't setup second host when using iscsi
 Fixed in alpha

* Time shift on host may cause ha to stop responding
 - Hosted engine upgrade from 3.3 to 3.4, ovirt-ha-agent die after three errors

</div>

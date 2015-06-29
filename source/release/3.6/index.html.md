---
title: OVirt 3.6 Release Notes
category: documentation
authors: didi, mperina, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.6 Release Notes
wiki_revision_count: 34
wiki_last_updated: 2015-05-22
---

# oVirt 3.6.0 ALPHA Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.0 first Alpha release as of May 20th, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Fedora 20, Red Hat Enterprise Linux 6.6, CentOS 6.6, (or similar) and Red Hat Enterprise Linux 7.1, CentOS 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](http://www.ovirt.org/Category:Releases). For a general overview of oVirt, read [ the Quick Start Guide](Quick_Start_Guide) and the [about oVirt](about oVirt) page.

### Docker Integration

oVirt Engine setup now provides [ Cinder and Glance](CinderGlance Docker Integration) automated deployment using Docker

### Self Hosted Engine FC Support

Hosted Engine has now added support for [FC storage](Features/Self_Hosted_Engine_FC_Support)

### Self Hosted Engine Gluster Support

*   Hosted Engine has now added support for [Gluster storage](Features/Self_Hosted_Engine_Gluster_Support)
*   Hosted Engine has now added support for [Hyper Converged Gluster storage](Features/Self_Hosted_Engine_Hyper_Converged_Gluster_Support)

### oVirt Live

oVirt Live has been rebased on CentOS 7 allowing to run oVirt in 3.6 compatibility mode

### Known Issues

*   Use SELinux Permissive mode in order to avoid denials using VDSM and Gluster

<!-- -->

*   NFS startup on EL7 / Fedora20: due to other bugs ( or ), NFS service is not always able to start at first attempt (it doesn't wait the kernel module to be ready); if it happens oVirt engine setup detects it and aborts with

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

Retrying (engine-cleanup, engine-setup again) it's enough to avoid it cause the kernel module it's always ready on further attempts. Manually starting NFS service (/bin/systemctl restart nfs-server.service) before running engine setup it's enough to avoid it at all.

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

*   Upgrade of All-in-One on EL6 and FC20 are not going to be supported in 3.6. VDSM and the packages requiring it are not built anymore for EL6 and FC20.

# Install / Upgrade from previous versions

### ALPHA RELEASE

oVirt 3.6.0 Alpha release is available since 2015-06-29. In order to install it you've to enable oVirt 3.6 pre release repository.

In order to install it on a clean system, you need to run (see also [Known Issues](#Known_Issues) above):

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-pre repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.0 Alpha on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.3 Release Notes](oVirt 3.5.3 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/el7-alpha1/ovirt-live-el7-alpha1.iso`](http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/el7-alpha1/ovirt-live-el7-alpha1.iso)

# CVE Fixed

# <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
### oVirt Engine

**oVirt 3.6.0 Second Alpha**
 - [RFE] NUMA aware KSM support in RHEV-M
 - [RFE] DC and Cluster selection for New Host / Edit Host
 - [RFE] RHEV-M guest settings can differ from the actual OS/arch that's installed on a guest
 - [RFE] Implement quota support in API
 - [RFE] Allow dash ('-') in Logical Network name in RHEV
 - [RFE] VM/Template names uniqueness at DC or tenant level
 - [RFE] Reset the RHEV-M reports admin password with rhevm-config utility.
 - New Data Center dialog box get closed when same name exists in the engine already
 - [RFE] add support for disabling spice agent based file transfer support
 - [RFE] single step snapshot to template in RHEV-M (VM not running)
 - [RFE] Persistent client-side logging infrastructure
 - [RFE] avoid contradictory policies (level 1) for Affinity groups.
 - [search] Support tokens with special characters within name
 - [RFE] Export Domain - Create a new role for users who can export/import VMs
 - [RFE] Anti-Affinity policy does not trigger against currently running VMs
 - [RFE] Add "(snapshot)" besides "Thin provision" type disks if snapshots are taken on these disks which were previously pre-allocated
 - [RFE] Don't count on vdsm to report the management interface
 - [RFE] Users should be able to suppress/acknowledge events
 - User doesn't get the UserVmManager permission on a VM
 - [RFE][ImportDomain] The login button, when picking the targets for importing iSCSI Storage domain should be more noticeable in the GUI
 - When scanning a non-block disk, the error message doesn't note the specific disk name
 - [RFE] Allow use of role names in api definitions
 - [ux] Edit VM - watchdog options not clear
 - [RFE] "Attach Virtual Disks" dialog - add an option to choose which disks will be activated
 - [RFE] Add support for qcow2 disks, adding the ability to choose qcow2 disk format and make template creation/provisioning qcow2-aware on file domains
 - [RFE] Allow to avoid lock screen on spice disconnect
 - With 7.1 hosts that are crashed, RHEV-M keeps fence grace period alive with no Power Management configured.
 - Storage Tab -> import Domain -> help button is missing
 - Storage tab-> ISO Domain -> Data Center -> Attach -> help button is missing
 - [RFE] Meaningful selection of the memory snapshot's location
 - [Admin Portal] Events 'detail' button doesn't open popup window
 - [RFE] Let the user change the name of an imported block Storage Domain
 - VMS Monitoring stops with error: Failed to invoke scheduled method vmsMonitoring: null
 - [webadmin] prevent 'latest' templates from non-stateless VM creation
 - [RFE][UI] Cannot override image's name when importing an image from glance from the webadmin
 - [RFE] Add wrapper for js-import and js-export
 - [RFE] - Refactoring of Power Management tab in Host Detail
 - Roles permissions does not get translated, only the keys are presented
 - [RFE] Quicker Installs by presenting ISO domain hosted kernel images to Run Once Screen
 - [New] - Cannot create brick in UI when nodes are added to the cluster using JSON RPC.
 - [RFE] Support search based on VM Compatibility Level
 - rebase noVNC to 0.5.1
 - Host VM panel not updated after VM migration
 - [RFE] - Reduce diff between upstream and downstream management networks, use the same name for new clusters.
 - Clear all option in RHEV admin portal does not clear any alerts
 - [New] - Remove all the columns related to virt in Networks tab.
 - [New] - When user runs remove-brick on a volume he is not allowed to perform status, stop, commit and retain.
 - [New] - Do not display RAID types 1,2 and 5 in the create brick dialog.
 - Unclear alert in the Alert event in GUI - " System user root run unlock_entity script on all with db user } "
 - [RFE] Report guests Buffered/Cached memory - DWH
 - [RFE]Add additional hypervisor details to the ETL process - DWH
 - iLO2 no longer works under power fencing devices, ipmilan required instead
 - Add GB information to SD percentage threshold on edit and general tab
 - [RFE] - engine-backup should support some performance profiles
 - Add an underline explanation about the actions affected by changing the "Critical Space Action Blocker" parameter in the domain view.
 - [add host] Failed to configure management network on the host causes odd event with 'VDSM version (<UNKNOWN>)'
 - [New] - Display the unit for capacity in UI as GIB
 - [RFE] add support for IOThreads
 - [New] - Data alignment value is always passed as 1024k to pvcreate
 - [RFE] Collect total RX/TX byte statistics for hypervisor and VM network interfaces
 - Whenever an exception is thrown in the front end code, unrelated parts of the GUI tend to stop working (e.g. 'new' and 'import' buttons under Networks tab)
 - [New] - Brick which is already being used by a volume should not be listed in the Brick Directory.
 - Hosts -> General -> Hardware: Select another Host -> wrongfully jump to the VMs main tab
 - [New] - Display an error message when UI fails to sync storage devices
 - VdsNotRespondingTreatment Job remains in status STARTED even after Manual fencing the host
 - fails to detect E5-2600v3 cpu as haswell
 - Memory Balloon in a VM created from a template, that was renamed will always be disabled
 - In the 'blank' template, the cpu allocation tab is empty
 - Disk permissions are never loaded in webadmin
 - Unable to change VM OS type in a single screen/click
 - [New] - Description for the Geo-replication config options shows N/A
 - Missing IDs for several volume table elements
 - New VM dialog should not show Memory Balloon Device Enabled when using template that has this disabled
 - Add cluster name to volume identification in event log
 - [New] - Failures must be indicated with a red color 'x' symbol.
 - Log messages received from vdsm
 - RHEV 3.5.0 - User Portal no longer works Internet Explorer 8
 - [REST-RSDL] Misleading description for command 'delete' @ datacenters/storagedomains/storagedomain
 - [New] - Disable remove and add brick for disperse and distributed disperse volumes from UI
 - Host stay in 'Unassigned' state for ever, unless restarting vdsm+engine
 - [New] - User should not be allowed to remove glusternw from the interface if it is in use.
 - 3.6: user portal and webadmin login pages are not displayed for IE8, javascript exception occurs
 - [TEXT] - [GUI] > Storage domains in RHEV-M's event log have <UNKNOWN> names
 - [New] - No event message gets displayed when snapshot is synced from CLI to UI
 - Network Provider left tab should be disable for ovirt-node actions
 - CSH doesn't work unless helptag is identical to model hashname
 - Refer to Foreman as Satellite in RHEV/oVirt
 - [RFE] Provide interface to access guest serial console
 - Missing tenant_name for openstack providers in rsdl
 - When cluster architecture is set, the field in edit still shows "undefined"
 - rhevm-setup - update - pki: Enroll certs on upgrade if not exist
 - Internal Engine Error is seen while setting snapshot schedule
 - [New] - UI does not list the config option 'use_meta_volume' to start a new geo rep session.
 - Bottom events tab follows paging of top level events tab
 - [RFE] hot-plug memory
 - [New] - No confirmation popups being shown to the user when he tries to stop/remove/pause a geo rep session.
 - [New] - when user tries to remove a geo-rep session with out stopping, UI displays an unexpected exception.
 - [New] - cannot create snapshot while geo-replication session is running on the volume.
 - [engine-manage-domains] Make options of --provider parameter case insensitive
 - 3.5.1 Upgrade adds "Everyone" group to disk profile
 - Searching in templates return database error
 - It would be good to have confirmation message when user tries to edit snapshot recurrence schedule to None
 - [engine-webadmin] Tree pane shows wrong view after browsing to 'External Providers'
 - [RFE] [event notifier] event notification for available host updates
 - error upgrading db from 3.5 to 3.6 because of a null value in column "option_value"
 - Internal engine error occurs when changing external provider type.
 - [New] - Add server name to the brick create and fail event messages.
 - "Add Event Notification" toggle for for VM pausing events
 - [RFE] Require a specific spice client version when opening console
 - Changes required in create brick pop up
 - Disk which is already attached to VM still available to be chosen
 - Implement auto-completion option --ha_reservation under update cluster
 - Failed to power off VM Host: <UNKNOWN>
 - 'alias' is not documented for update disk in RSDL
 - Path of nfs storage is cut in 'General' subtab
 - Legal values "0" and "1" for boolean parameters no longer accepted in RHEV 3.5
 - RHS-C:Files are not synced to brick from newly added node added to a geo-rep participating volume
 - [RFE] Add external status to storage domain
 - Creating a vm with configuration fails (like ovf data)
 - Incorrect value is seen for "Crawl status" option in Geo-Replication Session Details window.
 - Meta volume is not used in geo-replication even with 'use meta volume' config option set to true by default.
 - When removing a VM with the "Remove Disk(s)" check box unchecked, the VM's direct LUNs are removed while disk images are not
 - Event log message shows UNKNOWN on changing the geo rep config options
 - Changes are not reflected in UI when use_meta_volume option is set to false
 - [RHGSC] Volume dialog - remove "Stripe" volume types
 - improve Korean translations
 - When VM is on suspended status, the "Activate" and "Deactivate" buttons under Virtual Machines -> Disks are available for VirtIO disks
 - Please remove the underscore from the error message "Storage Domain's warning_low_space_indicator must be an integer between 0 and 100."
 - A minor typo found during localization of 3.6 WebAdmin strings
 - When removing a VM with its disks, shareable LUNs are also removed
 - A typo in a message found
 - [PKI] ssh-keygen certificate enrollment has different cmdline in rhel-6 than upstream and rhel-7
 **oVirt 3.6.0 Alpha**
 - [BACKEND] VM dynamic table contains unused columns that should be removed.
 - [RFE] improve the resource usage graph for VM cpu/memory/network
 - [RFE] Allow setting of machine type per VM rather than cluster level
 - [RFE] engine-setup should inform the user to install ovirt engine reports and DWH.
 - [RFE] pass session id to spice via mime type to allow spice Menu Using REST
 - [RFE] Additional fields for fence_apc_snmp in the RHEV UI
 - Some AppErrors messages are grammatically incorrect (singular vs plural)
 - Templates do not incorporate user defined properties
 - [RFE] Allow filling also network prefix to 'netmask' fields of static IP configuration
 - VM pool: cannot edit comment of an existing pool
 - [Tooltips] tooltip discrepancy on Virtual Machines tab
 - [ToolTips] Hoverable tooltips should have a "hover intent" delay
 - [ToolTips] tooltips get stuck in open state
 - [RFE] Report guests Buffered/Cached memory
 - [RFE] RHEV-M admin portal should list all logged in users
 - [RFE] pre-populate ISO domain with virtio-win and ovirt-tools ISO
 - [RFE] Configure both SPICE and VNC display console
 - Unclear audit log message for corrupted ovf in export domain
 - [RFE][oVirt][network] Add "sync" column to hosts sub tab under networks main tab
 - REST: brick collection delete is missing rsdl definition
 - [RHSC] After failure of a remove-brick task on a volume, attempts to start subsequent tasks on the volume fail.
 - [RHSC] Order the Add Block Host List
 - [RFE] [engine-webadmin] refresh view is rolled up to the list head
 - [RFE][HC] - Allow choosing network interface for gluster domain traffic
 - [RFE] Add Ability to Determine OS Long Name in REST API/SDK
 - [RFE] Do not disable actions in VM context menu if multiple VMs are selected
 - Incorrect migration Duration report
 - [RHSC] - Mouse hovering on rebalance icon when rebalance is stopped from cli , needs to be changed.
 - [RFE] for dialogs with side sections (e.g. New VM, New Cluster): need to "jump" to first section with validation error upon click on "OK"
 - webadmin: there is no way of knowing if a template disk is read-only until we create the vm
 - engine: removing the RO/"Wipe After delete" tag from a vm in a pool
 - Allow to clear the cluster's emulated machine
 - Using spice proxy for html5 is allowed, though not supported.
 - VM from pool - creating comment or description not allowed
 - [RFE] Search mechanism doesn't handle particular special characters well
 - exception when selecting 'Subnets' sub tab for network imported from neutron
 - [RFE] Option to populate LUN description with LUN ID #
 - [RFE] 'engine-backup --mode=restore' should allow provisioning
 - AddStorageDomainCommand CDA wrongly allows export storage on block devices
 - [RFE][ToolTips] convert tool-tips in the GUI to PatternFly tooltips
 - Floppy is available on ppc64
 - [RFE] consume newly-reported BOOTPROTO and BONDING_OPTS independent of netdevice.cfg
 - [ENGINE-SETUP] - Once dwh & reports are not installed in the 1st install, these options are not presented in the 2nd time
 - [RFE] configurable default for wipe after delete per storage domain
 - [remove] force removal of setup generated files at engine.conf
 - Validate database max connections when applying schema
 - [RFE] Mac Addresses Pool Per DC
 - SQL errors during rollback are not checked
 - engine-cleanup should return different codes for different types of failures
 - [User Portal] Using SPICE-HTML5 console types displays 'not supported by your browser.' for IE
 - [RFE] Need a way to determine how many days a user has been attached to a pooled VM
 - [Neutron integration][webadmin] improve CIDR validation when creating network with subnet on Neutron
 - hotplug cpu - event message text is not clear
 - [RFE] Provide UI plugin API to control the search string
 - Pointless warning when adding first storage domain
 - [RFE] use MIME launch as the default console mode
 - Shareable and bootable disk shouldn't be allowed
 - [RFE] Disable VM suspend through granular permissions in User Portal
 - "re-initialize DC" should not be available when DC is up
 - Remove unused SysPrep\*Path parameters from vdc_options
 - [ToolTips] GUI: VM type tooltip doesn't dissappear after opening Edit VM dialog with doubleclick
 - [GUI] Run Once & Sysprep: entered user password is not masked
 - useless parameter in osinfo
 - [engine-backend] [iSCSI multipath] Cannot edit iSCSI multipath bond while iSCSI SD is in maintenance
 - [RFE] Get rid of the setStoragePoolDescription calls
 - [RFE][webadmin] - GuideMe can't activate hosts
 - [scale] monitoring: separate VDS and VM monitoring
 - [TEXT] rename 'Cluster Policy' to 'Scheduling Policy'
 - [RFE] Edit ISO/Export domain connection details
 - all-in-one setup should configure cluster compatibility as max common between vdsm and engine
 - [RFE] Ability to search disks according to the Wipe After Delete option
 - add Ubuntu 14.04 to the list of operating systems when creating a new vm
 - Network QOS field is missing for the VNICs of VM
 - It's possible to create the same entity of Network QOS on the same DC
 - engine cannot parse complex response string returned from OAT server
 - can't migrate vm if the hosts have same hostname
 - [Admin Portal] Display warning about defining NFS as POSIX-FS in New Domain dialog
 - [ToolTips][Admin Portal] unify style for all help tooltips [InfoIcon].
 - [RFE] log refactoring
 - engine setup sets export of local ISO domain to restrictive
 - SDK and REST ignore template's disk attributes
 - [RFE] Alternate locations for rhevm-reports backups
 - [RFE] finer grained user permissions/roles on snapshots and live storage migration
 - [ToolTips] vertical scroll is added when hover on task footer pane
 - iSCSI multipath fails to work and only succeeds after adding configuration values for network using sysctl
 - [RFE] Separate indication of incoming and outgoing live migrations in "Virtual Machines" column of "Hosts" tab
 - Cannot start VM | The host did not satisfy internal filter Network because network(s) are missing.
 - [ToolTips][webadmin] hanging tooltip on host NICs with labeled networks
 - [Admin Portal] Broken UI - Enable SPICE clipboard copy and paste
 - [ovirt-websocket-proxy] websocket proxy starts even SSL cert/key is not present (SSL_ONLY=Yes)
 - When importing a VM in RHEVM 3.4 all its disks turn from thin provision to preallocated
 - No parameter under vm in REST for "Start in pause mode" flag
 - [RFE] Create new VM directly from Template List
 - rx/tx reported over 100% when adding/removing ethtools_opts
 - [ToolTips] Running VM delta info balloon do not disappear.
 - [engine-setup] 'Execution of setup failed' message is odd if only nfs start failed
 - [Admin Portal] Error while executing action: The notification event VDS_ACTIVATE_MANUAL_HA is unsupported.
 - sorting columns and paging
 - Taking snapshot of vm in suspend state doesn't work
 - engine-backup: FATAL: Errors while restoring database with different db user
 - [de_DE][Admin Portal] Text alignment on cluster>new>cluster policies page needs to be corrected.
 - cloud-init network start on boot checkbox goes down one line
 - Can define a VM POOL as HA
 - No validation for Maximum number of VMs per user in VM POOL dialog
 - New VM Pool dialog is closed after a pool name field validation failure
 - Complex info icon tooltip message in "Edit/New Virtual Machine" windows, under the "Host" tab, right before the "Start Running On" section
 - [RFE] Support management of gluster geo-replication session from oVirt
 - [Cloud Init] Adding new network with Cloud Init shouldn't provide any value for new network interface
 - webadmin [TEXT]: misleading error message when attempting IDE hotplug
 - [RFE] add API for Cluster Fencing Policy
 - [RFE][RHEV-M webadmin] improve German translation.
 - [REST API]: VM next_run do not have all fields updated.
 - Can't change a vm disk's storage domain from a file domain to a block domain when creating a template from a vm
 - UI paging/sorting: paging/sorting using the paging-buttons/column-headers doesn't update the search text; need to eliminate paging-text/sorting-text from search-text completely
 - [RFE] While adding new disk from RHEV admin portal: move the "Allocation Policy" list box below the Storage Domain List box.
 - [RFE] turn Blank template into some kind of global defaults facility
 - When unselecting a row item such as a Datacenter or domain and then re-select, the result is throbber never completes
 - [RFE] Allow creation of new disks as copy of any existing disk
 - [GUI over REST API gaps] missing GetNumberOfActiveVmsInVdsGroupByVdsGroupId
 - [GUI over REST API gaps] missing GetVmTemplateCount
 - [GUI over REST API gaps] missing External Providers
 - [GUI over REST API gaps] missing GetStorageDomainListById
 - [GUI over REST API gaps] missing GetVmsByDiskGuid
 - Untranslated language in "Missing language: {0}" window
 - uninformative engine error message when trying to start/create vm and display network has no ip
 - Setting "Other OS" is default 32bit instead of 64bit and causes incorrect RAM size limit of 16GB for 64bit OS.
 - NPE after starting/migrating VM
 - updating SPM level for host using ovirt-shell fails due to wrong expected value type
 - [RFE] Add wipe after delete to Disks -> General tab
 - Not consistent behavior, when update pinned vm cluster via UI and REST
 - Multiple updates to VdsDynamic
 - [engine-backend] Gluster storage domain is enabled in GUI in < 3.3 compatibility versions DCs
 - Import VmTemplate fails
 - [ImportDomain] The attach operation should issue a warning, if the Storage Domain is already attached to another Data Center in another setup
 - [RFE] Support monitoring of geo-replication sessions for a gluster volume
 - [ImportDomain] Engine should add a CDA validation when trying to attach an imported Storage Domain to an un-initalized Data Center
 - no validation before calling to AddSubnetToProvider
 - Adding a Storage domain (ISO, Export, NFS) lists Datacenter and Host as <UNKNOWN> under Tasks
 - [webadmin] "double" separator in New Logical Network (Cluster)
 - When resizing: mouse-cursor is too asymmetric
 - [RFE][ToolTips] Tooltips across clickable buttons in the application provide exact same text as the button text itself
 - Initial row is automatically selected even after it in all screens where initial row selection is made
 - The Details pane sizing information isn't maintained
 - its possible to add label to external network via rest
 - its possible to change datacenterid of external network via rest
 - Using "iSCSI Bond", host does not disconnect from iSCSI targets
 - misleading audit log when host goes non operational with non matching emulated machine
 - [New/Edit VM] > Initial run(cloud init) > Networks > NIC section > Gap in the beginning of the layout
 - Dialog screens come up with full set of options and enabled OK button even when no action can be performed (such as with Add Virtual Disk with no active Data Center)
 - [Network label] RHEV does not allow adding label for a network being used by VMs
 - Cookie Attributes - Secure flag
 - [TEXT] RHEVM - cluster fencing disabled on 3.4 cluster - host is non-responsive -expected alert appears only once but will not reappear
 - [RHSC] Adding brick to pure replicate volume by increasing replica count fails from Console
 - 'operation canceled' dialog: the "Enter" key doesn't invoke the default action button ("Close")
 - [RFE][gluster] - Actual volume capacity information is not shown in the Volumes tab. Only percentage is shown
 - [RFE] split 'Add Disk' dialog into 'New' and 'Attach' dialogs
 - When Default datacenter deleted, cannot remove Default cluster or associated template
 - LogPhysicalMemoryThresholdInMB influences both VDS_LOW_MEM and VDS_LOW_SWAP
 - [RFE] Generate sysprep answers file with name matching the version of Windows
 - Fencing stop/start retry/delay configuration are not exposed to engine-config
 - Close button not work in NUMA pinning window
 - [engine-webadmin] Top row in the audit log is misaligned
 - "Migrate only Highly Available Virtual Machines" need to capitalize the "only"
 - Attach to Data Center dialog allows OK button to be clicked without choosing Data Center
 - Templates area Disks sub-tab has the first Disk row overlapping the headers
 - Import Virtual Machine(s) status check dialog for the Events tab is a bit confusing
 - engine-setup accepts an answer file with an invalid value for applicationMode
 - engine packages are versionlocked even if engine is not configured
 - [Admin portal] Odd events when migration fails - Trying to migrate to another Host (VM: sles11, Source: dell-r210ii-03, Destination: <UNKNOWN>).
 - [RFE] Support auto-convergence and XBZRLE compression during migration
 - RHEV Admin Portal Unreachable After Upgrading to 3.4.0 due to mod_proxy_ajp not loading
 - Need to improve CDA error message for storage domain creation failure due to duplicate custom mount options
 - User Portal login form should have intuitive keyboard navigation instead of current, erratic one
 - oVirt Change CD incorrectly rejecting isos with uppercase extensions (ISO vs iso)
 - Unable to authenticate if user is using <http://indeed-id.com/index.html> solution for authentication.
 - [external-task] Couldn't clear external job
 - [userportal] When vm list is empty, then waiting animation never disappear
 - [RestApi] Adding Vm to an un-initialized dc, creates an unusable, unremovable VM entitiy
 - the "Show Report" menu of Data Center is covered by the sub-tab titles
 - [RFE] add notification when host update is available
 - [RFE] Showing engine/host/VM ERRATA information from Satellite/Foreman
 - No password change url on login failure when password expires
 - [RFE] Add keystone URL for OpenStack external providers that require authentication.
 - [GUI over REST API gaps] No way to check if a VM is in "run once" mode
 - Prevent migration of VMs using scsi reservation on virtio-scsi LUNs
 - 'CPU Type' and 'CPU Architecture' fields in 'New Cluster' dialog behaves wrongly
 - [RFE][engine-backend][HC] - add the possibility to import existing Gluster and POSIXFS export domains
 - [engine-backend] SQLException while starting a VM which was stateless before and had a disk attached to it while it was in stateless
 - [RFE] Enable the configuration of the SANWipeAfterDelete property in the setup
 - [engine-webadmin] Removing a template from export domain while there are depended VMs on it should raise a warning message
 - Replace any instances of "event log" or "events log" to "Events Pane" (if text is GUI-only) or "Events" (if text can appear in REST-API-based interface as well).
 - Should add "Windows 2012R2 x64" as vm operating system options
 - [RFE] Supporting search in User-Level API
 - Pending resources are not cleared when network exception occurs.
 - [F21] ovirt-engine fails testing searchbackend.SyntaxCheckerTest
 - Prestarted vms in vm pool get useless event "VM <vm name> was restarted on Host <UNKNOWN>"
 - Wrong error message when Giving correct values at QoS
 - Sort VM by IP fails if more than one IP listed for any VM entry
 - Cannot add action to roles
 - [RFE] VM Dialog: merge template with template version
 - [ux] Typeahead box issues
 - [ux] Edit VM - migration options cut off
 - [ux] Edit VM - System tab - Advanced Parameters unfolded by default
 - [ux] virtio-rng options in Cluster dialog using different font
 - [ux] virtio-rng option not clear why not allowed
 - [ux] new VM dialog text font inconsistency
 - [ux] combo vs typeahead box text alignment
 - Latest template instance recognized by matching of name
 - [GUI]> Double clicking on 'ok' button in new windows that need approve operation creating double and the same entity
 - Un-suspended diskless VM - RunVm failed. Reasons:VAR__ACTION__RUN,VAR__TYPE__VM,VM_CANNOT_RUN_FROM_DISK_WITHOUT_DISK
 - [GUI]>[SetupNetworks]> Can't display two networks with the same name but different cases unless they have the same label
 - [Text] Minor text inconsistencies in letter casing "Error while executing action: Cannot deactivate Data Domain while there are running tasks on this data domain." (Data Domain vs. data domain)
 - Wrong validation error message when entering invalid number in a number input
 - [RFE] Provide UI plugin API to reveal given main tab
 - update through ovirt-setup should list all the packages which will be updated before confirmation
 - [engine-backend] updating a storage connection of a Gluster domain does not make any effect.
 - [RFE] Collect data for VMs "vm_disk_actual_size_mb" including snapshots and change currect column name
 - Templates tab in userportal doesn't allow to differentiate among template versions
 - RHEV-M displays and uses the same values for hypervisor cores regardless of cluster setting for "Count Threads as Cores"
 - Can't run VM with error: CanDoAction of action RunVm failed. Reasons:VAR__ACTION__RUN,VAR__TYPE__VM,ACTION_TYPE_FAILED_O BJECT_LOCKED
 - When SD size reaches less than 1GB, it's reported as N/A.
 - ovirt-engine fails on testNoStringSubstitution with Italian locale
 - engine-backup does not sanitize the environment
 - [RHEVM][REST-API] Failed template removal with REST API floods server.log with exceptions
 - [RFE] Add the "last saved query per main tab" functionality to the UI
 - oVirt UI dropdowns do not render properly in Chrome
 - Storage domain comment and description should be editable when SD is not locked.
 - Double clicking on "instance type" entity does not open edit instance type window.
 - engine-setup unconditionally enables the engine if ran on dwh/reports host
 - osinfo-defaults.properties contains incorrect value for os.other.resources.maximum.resources.ram.value
 - "Authentication Required" login screen that references RESTAPI
 - Adding host through REST API fails with cluster name but works with cluster ID
 - already provided old password is used to connect to ISCSI target although a different password was provided in a newly added connection
 - Importing an existing domain fails with SQL constraint violation exception on wipe_after_delete not null constraint
 - Can not restore backup file to rhevm with non-default lc_messages
 - When adding a host, the ip filed is not ignoring spaces.
 - Better resolution of graphics conflicts between template and vm
 - ActivateDeactivateSingleAsyncOperationFactory relies on concrete return type
 - RHEV-M managed firewall blocks NFS rpc.statd notifications
 - engine-config -s CustomDeviceProperties Deleted/Removed after rhevm-setup update
 - [New] - Missing help links for Add/Edit volume options, configure and About .
 - not null constraint violation when attempting to edit a storage domain in the webadmin
 - RHEV: Faulty storage allocation checks when importing a disk from glance
 - Missing details in engine log for "add VM Disk Profile doesn't match provided Storage Domain" failure
 - Code expects to a returned ArrayList from dao calls
 - [TEXT] When removing template error displays "${status}" parameter, if not all attached storage domains are active.
 - BatchProcedureExecutionConnectionCallback debug logging issue
 - Storage thresholds should not be inclusive
 - [RFE] Support RDMA transport type while creating/displaying gluster volumes
 - Default display type fails snapshot clone
 - Can't clone from snapshot - VM ID taken
 - REST_API | NPE when query events with empty query
 - Add rest API to support warning for attached Storage Domains on attach or import of Storage Domain
 - Manage domains does not add permissions for user
 - [ImportDomain] An operation of Importing NFS domain from rest, ends with a domain which is not attached nor detached to dc
 - Start vm that have memory and guaranteed memory above host free memory, failed with libvirtd error
 - Deformed, too narrow icons in Userportal Basic sidebar
 - [RFE] make the list of events loaded by user using REST ordered by ID
 - testJson\*Disk\* failures on F21 build
 - [GUI] DC> QoS > 'Network' should changed to 'VM Network'
 - [GUI] Configure > Mac Address pools > can't edit or remove existing pools
 - [GUI] > DC > edit DC > can't press 'new' for adding new MAC pool range to this DC
 - [GUI] > DC > New DC > MAC address pools > when pressing 'new' and then cancel, it closing the main New DC window and the new window stays
 - F21: Cannot get JAVA_HOME make sure supported JRE is installed
 - [GUI] Host QoS > Block user from entering letters and special characters in 'rate limit' and 'committed rate' fields
 - [RFE] Add CORS support to the RESTAPI
 - XSD schema validation error: macPool object missing 'allow_duplicates' element
 - [GUI] > Host QoS , 'Unlimited' outbound for committed limit should changed to 'N/A' or something else
 - [engine-webadmin] [importDomain] Importing an iSCSI domain while the storage server is not accessible fails with an ugly message
 - [RFE] Ability to Search Storage Domains According to the Wipe After Delete Option
 - [RFE][oVirt] allow renaming of the imported glance image and template
 - HTML5 Spice Proxy (Tech Preview) Not Able to be Configured
 - [New] - Removing brick with out migrating data from the bricks fails.
 - [New] - Remove the options Enable to set vm maintenance reason,/dev/random/ source and /dev/hwrng/source from new cluster dialog box in gluster only mode
 - [RFE] Host Hardware Information to be merged with General SubTab and reorganize the data inside
 - [vdsmfake] jsonrpc client heartbeats exceeded
 - failure of master migration on deactivation will leave domain locked
 - submenu within context menu not rendering in a convenient location, causing ux issues.
 - ENGINE_HEAP_MAX default value as 1G must be changed
 - [RFE] configurable thresholds for storage space per domain
 - [JSON] Force extend block domain, in JSONRPC, using a "dirty" LUN, fail
 - [New] - Title is not present for Optimize virt store dialog box.
 - [scale] cluster tab generate slow query
 - [scale] GetStorageConnectionsByStorageTypeAndStatus generate slow query
 - [search] Users: role = \* returns nothing / ERROR: column vdc_users.mla_role does not exist
 - [search] Templates: Users.usrname = causes PSQLException: ERROR: missing FROM-clause entry for table "vms"
 - unable to rename existing cluster
 - [RFE] - The engine should check when last backup was performed
 - [RFE] - Engine-backup should not restore async tasks.
 - [RFE] - Engine-backup should expose options related to backup\\restore of database that affect restore time.
 - [RFE] - engine-backup should notify via event on backup start\\completion\\failure with log path.
 - CustomDeviceProperties > SecurityGroups are not a default in 3.6
 - No auto-completion options for scheduling policy update
 - New VM with OS created by default with VNC and not SPICE
 - New Template dialog to narrow when quota is enabled
 - Error msg: Name must be unique -> Name already used in the environment, create new unique name
 - man - small typo in man page engine-cleanup(8)
 - [Engine] Engine runs out of memory - java.lang.OutOfMemoryError: Java heap space
 - Second run of Windows VM fails because of access problem to sysprep payload
 - Logging in to admin@internal fails
 - [engine-backend] [importDomain] Virt-IO-SCSI flag is disabled once the VM gets registered
 - [backend] When Host PM is disabled it should not show 'type="apc"'
 - [ToolTips] show tooltips on grid (text) cells when ellipsis is activated (i.e. when "..." suffix is added when text is cropped)
 - idle webadmin does not logout automatically if we are in the VMs main tab and there is a selected VM
 - invalid byte sequence for encoding "UTF8": 0xfd on setup
 - [notification] VDS_INITIATED_RUN_VM_FAILED mail notification is received twice
 - RHEVH Registration to default cluster fails when cluster Default does not exist or UUID is wrong
 - [events] Uppercase 'U' in 'user admin initiated console session for VM jb-w7-x64'
 - [events] No VDS_ACTIVATE_FAILURE caught
 - rest-api: templates -> disks collection - incorrect storage domains list
 - Typo - Topology is spelled topologhy in the UI
 - [RFE] download a docker image with glance and setup it as a provider for ovirt-engine
 - [RFE] download a docker image with cinder and ceph driver and setup it as a provider for ovirt-engine
 - Cloning the existing VM throws server error 500
 - vmpool collection lacks most vm properties
 - [events] odd message - ETL Service (Stopped|Started) vs History Service (stopped|started)
 - Gluster and POSIX edit domain - VFS type and mount options text boxes are not aligned with its labels.
 - [New] - Geo-replication status is shown as 'UNKNOWN' in the UI.
 - Add storage domain thresholds range validations in related CDA's
 - Run vm with one cpu and two numa nodes failed
 - Detach of Storage Domain leaves leftover of vm_interface_statistics and cause an sql exception when importing the VM again
 - Refresh host capabilities missing from Python-SDK
 - [PPC] Enable balloon device for PPC
 - Configure new user role dialog: faulty rendering due to javascript exception (missing "ActionGroup___DISK_LIVE_STORAGE_MIGRATION")
 - remove unused POWER drivers
 - "Custom Script" questions-mark under "New Virtual Machine" points to ovirt.org docs
 - Discover target in iSCSI storage server using REST-api with the given ‘target’ parameter from rsdl
 - [ImportDomain,Rest-api] Allow oVirt to discover FCp domains via 'unregisteredstoragedomainsdiscover'
 - get_management_network() returns None value instead of actual MGMT network for the Cluster object
 - [REST API] Add network to Cluster fails with Internal Server Error
 - RHEV needs to support 4TB of Memory
 - Search engine does not support tags hierarchy
 - [New] - Delete All Button under Snapshots sub tab is enabled by default.
 - VM Pool is created with 0 VMs if error occured when creating VM
 - Cannot add open stack image external provider vie RESTAPI; reason: keystone authentication url is missing
 - After activating iscsi domain, can't add a new disk due to lack of space though there should be space.
 - [New] - Do not list the clusters in the Volume Snapshot - Cluster options dialog which does not have hosts attached to it.
 - [RFE][HC] Open 100 ports for gluster bricks with base port 49217 when the host provide gluster support
 - [New] - Message in the Restore Popup is not correct when volume is online and snapshot is deactivatedt
 - [events] ...was started by null@N/A
 - [webadmin] Hosts main tab: no hosts display
 - engine-setup should unlock all entities
 - [New] - Do not display Disperse and redundancy count if the volume is not of type disperse.
 - sub-versions of Blank(Default) templates should be blocked
 - Mismatch between engine version and full version all APIs
 - No correlation-id parameter under methods of AffinityGroup
 - [New] - Add brick dialog does not show all the bricks available in the host.
 - [New] - Create Brick should be blocked if the device is already been used.
 - Import storage domain function is not setup to handle local disk hypervisors which has the same path
 - Host in Connecting state once SetupNetworks is called
 - RunOnce boot sequence is persisted after removing & adding network
 - [pki] pki-pkcs12-extract.sh fails with /dev/fd is not mounted
 - [New] - Display unit for stripe size in create brick dialog.
 - [New] - Cannot create volume using the bricks created from RHSC.
 - Instance type can't be renamed
 - New instance type dialog does not validate name for special characters
 - SPICE port is sent as 65535 to spice_html5
 - display property change is not saved when VM is running
 - XSD schema validation error: value object missing child elements
 - Network tool tip on the Edit network window in the SetupNetworks is stuck and concealing the IP/Netmask/Gateway fields, both on Chrome and Mozila
 - [RFE] enable SPICE/QXL support for Windows 8/2012 even without the QXL drivers
 - Adding a Gluster storage domain does not display the description properly in the tasks panel
 - When connecting host to a storage server the task description show "UNKNOWN" instead of the host name in the tasks panel
 - CLI auto complete option description is missing for add disk
 - POOL vm tasks doesn't ends
 - CLI auto complete options async and grace_period-expiry are missing for preview_snapshot
 - management bridge called ovirtmgmt instead of rhevm
 - [New] - Creating a brick with out providing the brick names gives "Internal Engine error"
 - [New] - Brick status is not marked down in UI when the brick goes down.
 - [New] - Do not display Disperse and Distribute Dispersed volume types in the create New volume Dialog box.
 - [engine-backup] silently ignores db credentials options when not passing --change-\*credentials
 - [engine-backup] restore fails if using change-{,dwh}-db-credentials and previous user exists
 - [New] - Snapshot creation from UI succeeds even when the bricks are not thinly provisioned.
 - Removing a Storage Domain lists DataCenter as <UNKNOWN> under Tasks
 - [New] - Snapshot creation succeeds from UI when some of the bricks in the volume are down.
 - Failed to create VM with multiple disks with ‘Disk vm_Disk1 in VM vm is already marked as boot’
 - Missing vms link under /api/.../storagedomains/{storagedomain:id}/
 - There is no Data Center version indication in the engine logs.
 - [engine-webadmin] [importDomain] Error message syntax of an unsuccessful import domain operation has to be changed
 - [CodeChange] Wrong check for domain's type in ExtendStorageDomainCommand
 - Importing storage domains into an uninitialized datacenter leads to duplicate OVF_STORE disks being created, and can cause catastrophic loss of VM configuration data
 - [RFE] UI Plugin - Control custom tab's position within the tab panel
 - Virt-IO-SCSI option is not available, although Virt-IO-SCSI flag is enabled in the resource allocation tab
 - [New] - Send alerts to the user when ever snap hard and soft limit are reached.
 - NPE when cloning a VM from snapshot WITHOUT "VirtIO-SCSI Enabled"
 - [New] - Proper error message should be displayed when user tries to delete a volume which has snapshots.
 - [New] - user should not be allowed to take snapshot when rebalance / remove-brick is running.
 - [New] - cannot sync snapshots created in CLI to UI when host is added in xml rpc mode.
 - [New] - Restoring snapshot cannot be performed while rebalance/remove-brick is running.
 - [New] - Display an error message when user tries to schedule a snapshot with out having a snap name.
 - [New] - Message shown while updating the snapshot configurations is misleading
 - Entering empty value or illegal value in size field, under 'Disks' tab does not generate an error
 - RetrieveImageDataVDSCommand log level entry should change to DEBUG instead of INFO
 - [New] - Snapshot creation is successful even after the snap-max-hard-limit is reached.
 - [engine-backup] unable to restore if backup contains read only user for DWH DB access
 - add fcp api option to 'unregisteredstoragedomainsdiscover' at oVirt's api rsdl
 - Creation of template disk does not set the disk description with json formatting
 - [REST API] when calling GET with all-content header on vms entity some initialization tag is missing parameters
 - [New] - snapshot end by date error is shown even after user sets the correct date.
 - [New] - Editing a snapshot schedule gives Operation Cancelled and the edit snapshot schedule hangs
 - [REST-API] missing details in rsdl for Glance image import
 - [SAP] Adding a custom property to a running vm causes all previously defined properties to be removed
 - [New] - Cannot create new snapshot when host is added using xml rpc
 - [New] - When user tries to schedule a snapshot with the current date and time it says operational cancelled
 - [New] - snapshot scheduling icon should be removed from the info column once the scheduled date and time are expired
 - [New] - UI fails to remove the brick when of the host UUID is zero and does not check further to update any new bricks.
 - [REST] Adding a disk to a vm fails with NullPointerException if not disk.storage_domains is provided (even for direct lun disks)
 - Remove UserRefreshRate from engine-config
 - Typos in gluster geo-replication messages
 - Grammar mistake in network cluster message
 - Typo in VM reboot message
 - [ovirt] [engine-backup] Engine backup fails with scope "db" on postgres 8
 - [ovirt] [engine-backup] pg_dump failure description not logged

### oVirt Hosted Engine Setup

**oVirt 3.6.0 Second Alpha**
 - [RFE] Keep hosted engine VM configuration in the shared storage
 - [RFE] allow to retry adding the host if a failure occurs
 - [RFE] Auto-detect available appliance images and suggest them to be used
 - [HE] Failed to deploy additional host using NFS
 - Failed to deploy additional host due to unconfigured iptables
 - hosted-engine fails to transfer the appliance image to the storage domain due to bad permissions
 - Let the user specify a static network configuration for the engine appliance
 - [TEXT ONLY] - Hosted Engine - Instructions for handling Invalid Storage Domain error
 - ovirt-hosted-engine-setup accepts localhost as a valid FQDN
 **oVirt 3.6.0 Alpha**
 - [RFE] Possibility to install host into engine VM without running through the whole installation process again.
 - [RFE] Hosted Engine on FC
 - [RFE] Hosted Engine - Support easier deployment flow out of the box with the Virtual Appliance image
 - [RFE][HC] make override of iptables configurable when using hosted-engine
 - [HE-setup] Use vdsm api instead of vdsClient
 - [RFE] Prompt again for admin password during hosted-engine --deploy
 - [RFE] Wait for user input to shutdown vm in the end of hosted-engine deployment process
 - hosted engine setup doesn't detect volume creation failures
 - [RFE] refactor VM startup code using VDSM API and don't try to set ticket until VM is up
 - [hosted-engine] [iSCSI support] connectStoragePools fails with "SSLError: The read operation timed out" while adding a new host to the setup
 - [hosted-engine] Bad check of iso image permission
 - vdsClient/vdscli SSLError timeout error
 - [RFE][HC] - Hosted Engine Support for GlusterFS
 - [RFE][HC] - Hosted Engine Support for Hyper Converged GlusterFS
 - [RFE] [hosted-engine-setup] [iSCSI support] Add more information to LUNs list provided during deployment
 - [RFE] Add the capability to attach an ISO image for cloud-init configuration
 - Validate the required number of CPU for the VM before trying to start it
 - engine VM doesn't start deploying from disk or appliance
 - [TEXT ONLY] - Hosted Engine - Instructions for handling Invalid Storage Domain error
 - [RFE] Let the user customize rhevm appliance memory size from deployment scripts
 - [HC] hosted-engine --deploy fails on additional host with external glusterfs
 - [self-hosted] Can't add 2nd host into self-hosted env: The VDSM host was found in a failed state... Unable to add slot-5b to the manager
 - [hosted-engine-setup] [FC support] In case there are no LUNs exposed to the host, fc_get_lun_list is called Infinitely

### oVirt Hosted Engine HA

**oVirt 3.6.0 Alpha**
 - Log entries should explain why HE agent try to start vms on both hosts
 - ovirt-hosted-engine-ha rpm should depend on otopi
 - bogus line during installer boot

### oVirt Log Collector

**oVirt 3.6.0 Second Alpha**
 - [RHEL6.7][log-collector] Missing some info from engine's collected logs
 **oVirt 3.6.0 Alpha**
 - [RFE] Log collector does not collect hosted engine information
 - log-collector tar files change "." permissions when extracted
 - [RFE] log collector should collect engine-config settings and domain information
 - split rhevm-log-collector moving sos plugins to subpackage

### oVirt Image Uploader

**oVirt 3.6.0 Alpha**
 - [RFE] add progress bar to image uploader

### oVirt ISO Uploader

**oVirt 3.6.0 Second Alpha**
 - [RFE] Provide more informative error messages for iso-uploader failures
 **oVirt 3.6.0 Alpha**
 - [RFE] add progress bar to image uploader
 - [engine-iso-uploader] engine-iso-uploader does not work with Local ISO domain

### oVirt Live

**oVirt 3.6.0 Alpha**
 - [RFE] Enable the configuration of the SANWipeAfterDelete property in the setup
 - [RFE] Rebase oVirt Live on CentOS 7.z

<Category:Documentation> <Category:Releases>

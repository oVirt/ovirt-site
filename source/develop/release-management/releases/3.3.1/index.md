---
title: oVirt 3.3.1 release notes
category: documentation
toc: true
authors: danken, dougsland, fabiand, herrold, iheim, moti, sandrobonazzola
---

# oVirt 3.3.1 release notes

The oVirt Project is pleased to announce the availability of oVirt 3.3.1 release.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3 release notes](/develop/release-management/releases/3.3/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/). For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide.html) and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


If you're upgrading from oVirt 3.3 you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2 you should read [oVirt 3.2 to 3.3 upgrade](/develop/release-management/releases/3.2/to-3.3-upgrade.html)

If you're upgrading from oVirt 3.1 you should upgrade to 3.2 before upgrading to 3.3.1. Please read [oVirt 3.1 to 3.2 upgrade](/develop/release-management/releases/3.1/to-3.2-upgrade.html) before starting the upgrade.
On CentOS and RHEL: For upgrading to 3.2 you'll need 3.2 stable repository.
So, first step is disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

      [ovirt-32]
      name=Stable builds of the oVirt 3.2 project
      baseurl=https://resources.ovirt.org/releases/3.2/rpm/EL/$releasever/
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

Then

      # yum update ovirt-engine-setup

should install ovirt-engine-setup-3.2.3-1.el6.noarch.rpm
if you have already updated to 3.3.x please use distro-sync or downgrade instead of update.
Then:

      # engine-upgrade

this will upgrade your system to latest 3.2.
Once you've all working on 3.2, enable 3.3/stable repository, then just

      # yum update ovirt-engine-setup
      # engine-setup

will upgrade to latest 3.3.

### Gentoo

Experimental Gentoo support for ovirt-engine-3.3.1 is available at <https://github.com/alonbl/ovirt-overlay>

Instructions on how to install it can be found at <http://wiki.gentoo.org/wiki/OVirt>

Feedback is welcomed.

### oVirt Node

The updates for oVirt Node can be found [here](http://resources.ovirt.org/releases/3.3/iso/). Images:

*   [Fedora 19 based image](http://resources.ovirt.org/releases/3.3/iso/ovirt-node-iso-3.0.3-1.1.vdsm.fc19.iso)

**Note:** Currently there is only an ISO based on Fedora 19. A CentOS based image will follow.

**Note:** An RPM containing the oVirt Node image is also missing, this currently prevents an update through oVirt Engine.


## What's New in 3.3.1?

### Vnic Profiles

The [vnic profiles](/develop/release-management/features/sla/vnic-profiles.html) feature was developed as a requirement for the Network QoS feature. Users can now limit the inbound and outbound network traffic on a virtual NIC level by applying profiles which define custom properties such as port mirroring or quality of service (QoS).

**Important note:**

This feature has been identified as an area of specific attention for beta testing.

### Neutron Host Deploy

It is now possible to specify a Neutron external network provider when re-installing a host in order to configure it for Neutron networking (rather than only when deploying a new one).

### Neutron UI Links

Linking has been added between network providers and their provided networks; this enables quick navigation from the providers tab where a provider might be configured to a provided network's main tab view where most of the management will be performed.

### Add / remove vnics in add/edit VM dialog

It is now possible to add/remove network interfaces in the add/edit VM dialog, which enables further customization of a VM's networking configuration as soon as it's created (complement to Instance Types feature).

### Manage Storage Connections

The [Manage Storage Connections](/develop/release-management/features/storage/manage-storage-connections.html) adds the ability to add, edit and delete storage connections. This helps supporting configuration changes such as adding paths (multipathing), changes of hardware, and ease failover to remote sites, by quickly switching to work with another storage that holds a backup/sync of the contents of the current storage.

### Multiple Monitors

[Multiple Monitors](/develop/release-management/features/virt/multiplemonitors.html) feature added the ability to channel Spice display protocol up to 4 different PCI channels in a single VM

### oVirt Scheduler

oVirt now includes a new scheduler to handle VM placement, allowing users to create new scheduling policies, and also write their own logic in Python and include it in a policy.

The new oVirt scheduler serves VM scheduling requests during VM running or migration. The scheduling process is done by applying hard constraints and soft constraints to get the optimal host for that request at this point of time.

**Scheduling policy elements**:

*   Filter: a basic logic unit which filters out hypervisors who do not satisfy the hard constraints for placing a given VM.
*   Weight function: a function that calculates a score to a given host based on its internal logic. This is a way to implement soft constraints in the scheduling process. Since these are weights, low score is considered to be better.
*   Load balancing module: code implementing a logic to distribute the load. So far the definition of load was mostly CPU related, so migrating a VM would help to resolve that. The new scheduler allows users to write their own logic to handle other load types (network, I/O, etc) by other means such as integrating with 3rd party systems.

**Scheduling process description**

Every cluster has a scheduling policy. So far we had 3 main policies (None, Even distribution and Power saving), and now administrators can create their own policies or use he built-in policies. Each policy contains a list of filters, weight functions (one or more) and a single load balancing module. The scheduling process takes all relevant hosts and run them through the relevant filters of a specific policy. Note that Filter order is meaningless. The filtered host list is then used as an input to the relevant weight functions of that policy, which creates a cost table. The cost table indicates the host with the lowest weight (cost), which is the optimal solution for the given request. Multiple Weight functions may be prioritized using a factor.

**Important note:**

New scheduling policies created by administrators are not validated by the system. This may end up with unexpected results, so it is highly important to verify a new policy is not introducing issues or instability to the system.

**Adding User Code:**

The infrastructure allowing users to extend the new scheduler, is based on a service called ovirt-scheduler-proxy. The service's purpose is for RHEV admins to extend the scheduling process with custom python filters, weight functions and load balancing modules.

The daemon is waiting for engine requests using XML-RPC. Engine request may be one of:

*   runDiscover: returns an XML containing all available policy units and configurations (configuration is optional).
*   runFilters: executes a set of filters plugins sequentially (provided as a name list).
*   runScores: executes a set of weight function plugins sequentially (provided as a name list), then calculate a cost table (using factors) and return

it to the engine.

*   runBalance: executes the balance plugin named {balance name} on the hosts using the given properties_map.

Any plugin file {NAME}.py the user writes must implement at least one of the functions (do_filter, do_scores, do_balance). These files reside in $PYTHONPATH/ovirt_scheduler/plugins folder, unless changes in the proxy's configuration file /etc/ovirt/scheduler/scheduler.conf. For more information on user code you can check the provided samples.

During the daemon initialization, it will scan this folder to detect user files, and analyse the files for the relevant functionality. The results are kept in the daemon's cache, and provided to the engine when the runDiscover is called. Note that the engine will call it only when it starts up, so in order to introduce a new code, the administrator needs to restart the proxy service, and then restart the ovirt-engine.

The scheduling proxy is packaged as a separate optional RPM which is not installed by default. After installing it, the admin needs to allow it in ovirt-engine DB by setting ExternalSchedulerEnabled to True using the configuration utility (engine-config).

**Important note:**

Using user provided code may have a performance impact, so administrators are advised to carefully test their code and the general performance changes before using it in live setups.

## Known issues

The Vdsm rebase during ovirt-3.3.1 caused an unintended change in how gluster storage domains are implemented: Instead of using glusterfs, it is using gluster-fuse.

This change has a positive side effect:  - "Snapshots on GlusterFS w/ libgfapi enabled" makes it impossible to use gluster VMs with snapshots on ovirt-3.3.0; that should be possible now.

If you would like to maintain the former behavior, you can apply a hackish patch <http://gerrit.ovirt.org/21151/> to your Vdsms.

## Bugs fixed

### oVirt Engine

* domain selection list in login screen should be sorted alphabetically
 - support for multiple monitors on QXL device (single device with more RAM)
 - webadmin [Tree]: when "x" main tab is displayed and "x1" (type "x") item is selected on the tree, hide "New" + "Remove" actions, and disable Name editing of the item.
 - [RHEVM] [backend] [Host Networking] [TEXT] Bridged network rhevm is attached to multiple interfaces: <UNKNOWN> on Host
 - ovirt-engine-backend: No event for ticket VM command
 - engine: rerun of HA vm fails when vm's pid is killed during live storage migration
 - Disk permission don't disappear after disk is deleted(is shown as 'null(Disk)').
 - Database functions not fully optimized
 - [User Portal] A user with PowerUserRole|NetworkUser on DC doesn't see own diskless templates when creating new VM
 - UI event notification - host events - "Host state...Storage Domain" event text overlaps it's following.
 - mouse cursor wrongfully changes to progress-icon upon login failure due to validation error (e.g. empty username and/or password)
 - [TEXT][engine] CancellationException is logged as ERROR even though it is expected
 - User who can't manipulate users, can add user if he has manipulate_permission action group.
 - [user-portal] User has insufficient permissions on url /domain/domain_id/users
 - [RHEVM] [UI] redundant scroll bar in VM migration dialog
 - [Network Tab] the cluster pane is missing the required field per cluster when creating/editing a logical network
 - rhevm-config | no validation when setting MacPoolRanges
 - engine [UPGRADE]: reinitialize a pool which is format 3 domains with domain which is format 1 will upgrade the MTD in vdsm but engine will leave the domain as format 1
 - Underscores in tag names break tags
 - ovirt-engine-backend: Add external event error messages need to be improved [TEXT]
 - ovirt-engine-webadmin-portal : user who added external events does not appear in UI
 - webadmin: edit of master domain will show domain format as v2 when domain is in v1 format
 - [webadmin] All LUNs from each target listed under all targets
 - Race between VM migration and other virt/storage operations
 - engine [UPGRADE]: when connectivity is restored to all the hosts after upgrade hosts moves to non-operational for compatibility version mismatch
 - RHEVM-RESTAPI power management types are not updated.
 - engine: cannot move an inactive disk attached to a vm if live storage migration is in progress on a second disk attached to the same vm
 - engine: move of inactive disk is blocked on unrelated live ops (live migration of the vm, live storage migration, etc)
 - [REST-API] Throw error when the value of url 'max' param is not convertible to int
 - [REST-API] Update of power management by sending entire host representation is ignored
 - check DB objects before upgrade (owner engine)
 - engine: cannot run unlock_entity on multiple objects
 - QueryData2 generates slow SQL for AuditLog with no parameters
 - [rhevm-dwh] - ETL Reports error when a Single Host in setup is Non-Responsive ("ETL service sampling has encountered an error")
 - Search query "sortby" return some wrongly sorted results
 - Changing vmpool's quota is ignored.
 - [RHEVM][backend] VM NewPool-1 was restarted on Host <UNKNOWN>
 - backup.sh return code always 0 even on error
 - engine: AutoRecovery of host fails and host is set as NonOperational when export domain continues to be reported with error code 358
 - When an export of a template fails, the leftovers on the export domain are not cleaned
 - [RHEVM][backend] cannot assign VLAN to bond which is named other than bond[0-4]
 - webadmin: after ovirt-engine restart, if we do not reload the UI before log in, CanDoAction alerts will not appear for the user
 - Refactor unnecessary while loop in JndiAction class
 - engine: unexpected exception error when trying to hotplug a disk when its domain is in maintenance
 - Run Once - do not offer network device if the card is unplugged
 - It's impossible to update the tagged network on DC to become untagged through API
 - [RHEVM][webadmin][TEXT] wrong capitalization of VNIC/NIC on Networks -> Virtual Machines subtab
 - webadmin: Events main tab: When applying an Events search filter (which results in few items) by hitting "Enter" - duplicate entries are shown.
 - REST allow adding a VM nics with the same mac
 - REST allow adding nics with special characters
 - [engine-web-admin] engine reports that host cannot join to cluster due to rhev compatibility version issues when it should report about the real issue, which is vdsm compatiblity versions in it's DB
 - Changing Quota from Disabled to Audit is triggering the "Enforcing" warning message.
 - Unable to search on domain for users with some search options.
 - VM migration fails when required network, configured with migration usages is turned down
 - It's impossible to detach the network from NIC by dragging it out
 - Share the engine's os info with DWH through a translation table
 - Unable to put a host into maintenance because VMs previously managed by vdsm are running on the host
 - java.lang.NullPointerException when sending setupNetwork command without interface attached to network
 - GUI: Assign/Unassign Networks tab should be changed to more descriptive name
 - Attaching a network to a host's nic inherits the host nic's IP to the new network
 - [Admin Portal] there's twice 'Default OS' value in 'Operating System' selection box
 - [engine-backend] Null Pointer Exception for action CreateAllSnapshotsFromVm after failure in create snapshot
 - VM UUID is not shown prominently in Web UI
 - Disk entries remain in database after deleting the datacenter
 - Fence via second power management not working
 - Provide MoTD on logon screen
 - [RHEVM] [webadmin] sync network button does not appear when network gets out of sync with host
 - [engine-backend] engine fails to revert a failed cloneImage task, after that, user cannot do anything on the system
 - Cannot start a VM with USB Native - Exit message: internal error Could not format channel target type.
 - [webadmin] Host appears twice in hosts view
 - Failed to create a VM from a template, image is in locked state forever
 - unable to add to an AD domain (Exception message is: Comparison method violates its general contract!)
 - Changing email address for event notification results in error "User is already subscribed to this event with the same Notification method"
 - spmStop is failing with a SecureError
 - Adding provider with wrong name close add provider window
 - [RHSC] Add brick displays an improper message while adding a brick to the volume.
 - Live Storage Migration attempted on an unplugged disk of a running VM (instead of a simple cold move)
 - Template selector in pool popup is not refreshed
 - External events' audit logs has not records in AuditLogMessages.properties
 - guide button at top navigation bar in user and admin portals opens portal selection page
 - Error when selecting host as SPM in uninitialized data center
 - when selecting a bookmark, the only main tabs that should appear are the ones displayed when "System" is selected in the system tree (i.e. without Quota, Providers, Dashboard)
 - The VM subtree doesn't display the VM tab. It changes the name of the tree but doesn't display the VMs tab content
 - OK'ing in the new host dialog with an empty SSH port creates an unresponsive power management dialog
 - engine-setup after partial engine-cleanup fails
 - Error message should be changed when trying to set VNC keyboard layout for suspended VM
 - Text is unreadable due to spillover in the "Add Event Notification" dialog
 - [oVirt] [glance] Provider type should be spelled "OpenStack"
 - engine-config should return the list of possible VNC keyboard layouts
 - Error dialog while editing Network QoS has $(type) in output
 - vm - 'run once' icon is not displayed, instead the regular "up" icon is displayed
 - [oVirt] [foreman] Adding default config fails
 - Live snapshot leaves disks with no name on storage domains
 - [engine-webadmin] user cannot perform any operation under VM tab from the tree pane on UI
 - Updating host's cluster leads to cloning the host
 - We get enum instead of a message when user tries to run more VMs from the User portal then he has permissions to
 - edit vm - unnecessary update of nics is performed and appears in event log
 - We should have maximum value for Maximum number of VMs per user
 - [REST-API] Adding a cluster with incomplete version fails with exception
 - [ExternalTasks] Cannot add sub-step under existing (parent) step
 - [ExternalTasks] When adding new step, type is always EXECUTING
 - [ExternalTasks] When adding new step, state is always STARTED
 - [ExternalTasks] Step cannot be ended as not successful
 - [ExternalTasks] Cannot end existing job
 - [Admin Portal] Cannot update VM properties - Field timeZone can not be updated when status is Up
 - SshSoftFencing has no task description
 - Vm is trying to run on host which is in maintenance
 - No order of jobs via start time under /api/jobs
 - [GUI]When creating bond with setupNetwork default bond name should be proposed (for example bond0)
 - can't add host to engine when all hosts in cluster are in Install Failed state
 - vms_sp.sql argument error in InsertVm function
 - Failed manually set SPM Priority - Field sshPort can not be updated when status is Up
 - [Neutron] can select external provider for new network only if creating network in network main tab
 - RunVmOnce transaction timeout on updating vds memory
 - Strange behavior when trying to add VM without existing data domain
 - Creating multiple network with the same name
 - Template removal leaves record in async_tasks table
 - network from external network provider shouldn't be displayed in setupNetwork.
 - [RHEVM][TEXT] improve error message displayed in GUI when obtaining IP from DHCP fails
 - No REST API to import/export images from Glance
 - Neutron | import network | import button should be enable only if imported list in not empty
 - webadmin: login: in case of login error, error-message key is displayed (instead of error-message value)
 - Red Hat Storage nodes, attached to 'Gluster Enabled Cluster', are shown in drop-down box for choosing host, while removing Storage Domain
 - [engine-backend] host cannot be activated after it had been updated to maintenance in DB, while engine has never got the response for DisconnectStoragePool
 - storage domain creation fails if its storage connection is not mounted
 - Cannot add users from API using a principal name (user@domain) format when using an open ldap domain
 - Cannot log into User Portal - login page is stuck after being submitted
 - [RHEVM] [ux] Migration Options field is too narrow in New Virtual Machine dialog
 - [engine-backend] when attaching a local ISO domain from one host, engine does not send ConnectStorageServer to other cluster's hosts
 - java.lang.ClassCastException when updating direct LUN disk.
 - REST-API doesn't return statistics for VLAN tagged interfaces
 - "Is shareable" option not updated when changing disk's allocation policy between Preallocated and Thin Provision.
 - During create snapshot get unuseful check box “Save Memory”
 - engine-setup is not storing an answer to the "Do you want to install with memory less than recommended?" question
 - VM fails to start due to duplicate device ID
 - [Admin Portal] RunOnce Cloud-init Error / interfaces.BackendLocal.RunAction(org.ovirt.engine.core.common.acti on.VdcActionType,org.ovirt.engine.core.common.action.VdcActionParametersBase): javax.ejb.EJBException: JBAS014580: Unexpected Error
 - [rhevm-manage-domains] /var/log/ovirt-engine/engine-manage-domains.log doesn't exist
 - engine-install with all-in-one fails if ssh is configure for non-standard port
 - VM failed to start running after changing the interface of bootable disk in UI.
 - [engine-backend] LocalAdminPassword exception after RHEVM host reboot
 - Failed attached Export Storage Domain - Could not obtain lock
 - Users cannot log into UserPortal
 - Newly added Cluster policy populates the list in random position
 - VM image stays locked when creating template and closing engine
 - Gateway blank for non-management networks
 - [RHEVM][backend] Error "MAC address is required" shows on editing VM description
 - [host-deploy] block concurrent installation for same host
 - webadmin [Tree]: fix hardcoded non-i18n strings in tree context info messages
 - ImportVmTemplateParameters fails (Unexpected token)
 - GWT: Tooltip not shown on overflowing content when hovering over cell
 - CanDoAction on UpdateVmInterfaceCommand when creating VM from template.
 - [RHEVM][webadmin] Edit Logical Network dialog has insufficient size
 - [Admin Portal] Configure Local Storage has odd UI style
 - Force remove of data center fails
 - [engine-config] /var/log/ovirt-engine/engine-config.log doesn't exist
 - Installation fails with message of "Failed to execute stage 'Misc configuration': Command '/usr/share/ovirt-engine/dbscripts/create_schema.sh' failed to execute"
 - [engine-backend] engine fails with ClassCastException during FullListVdsCommand when it detect a running VM that does not exist in DB
 - Problems in ListModelTypeAheadListBoxEditor
 - SSH Port in Edit host is always 22
 - wrong favicon.ico of ovirt instead of rhev
 - "Migrating" status icon needs adjustment, Image for disabled "Suspend" button is too contrasted
 - Cannot get snapshots collection via API after live snapshot creation
 - [Local] Failed add a host via “Guide Me” on Local Data Center
 - Updated user information in OpenLDAP are not propagated to engine
 - vnic_profile_id gets lost when snapshot is previewed
 - When selecting an active VM the console button is not enabled immediately
 - canDoAction fails when removing imported vm from export domain
 - [upgrade] correctly detect if packages can be rollbacked
 - SPM priority doesn't affect the SPM selection
 - VM permissions entries remain in database after force deleting data-center
 - It's impossible to create/change the VNIC profile to an empty one
 - SetupNetworks fails during host installation
 - [RHEVM][webadmin] When creating a VM from template, the dialog presents incorrect VNIC profiles
 - [RHEVM-ENGINE] Host selection is override if host can't run VM
 - REST-API: Adding and updating host by the API missing supported parameters
 - Network QoS burst units should be MB
 - RestAPI URI template style query for 'users' and 'disks' resources do not work.
 - Initial Run subsection not present by default at Run Once dialog
 - When RuntimeException occurs at endAction, the endAction part will be rerun over and over again
 - AddVmTemplateCommand failes - null value in column "device_id" violates not-null constraint
 - Unclear completion message in engine-setup esp for upgrades
 - [TEXT] Change Virtio -> VirtIO in Edit VM dialog for VirtIO console
 - Change multi-monitor setting in VM Console option dialog
 - RHEV installer should install and configure rhevm-websocket-proxy
 - [TEXT] change "Cannot run VM. The VM status is illegal." to "Cannot run VM. The VM is already running"
 - [ALL_LANG][Admin Portal] Better to list the remove items in 'Remove Network QoS' dialog.
 - [ALL_LANG][Admin Portal] Unlocalized string 'Role ... on User ...' in 'Remove Permission' dialog.
 - [ja_JP][Admin Portal] Word 'Public' broken into two lines in 'Profiles' panel of 'New Logical Network' dialog.
 - [ALL_LANG][Admin Portal] Up-Down buttons' text displayed as garbage string in 'Import Networks' dialog.
 - [ALL_LANG][Admin Portal] Should display the VM name instead of 'null' in 'Remove Network Interface(s)' dialog.
 - [ALL_LANG][Admin Portal] Should display the template name instead of 'null' in 'Remove Network Interface(s)' dialog.
 - Not possible to change quota of disk in enforced mode.
 - Failed to create VM from template without any image disks
 - Although when creating network with profile you check "Public" checkbox, the "Permission" for everyone is not created
 - Inconsistency in naming of Profile usages
 - It's impossible to start VM (or hotplug) when VNIC profile on the VM has QOS configured only on Inbound or only on Outbound
 - Failed Migrate VM - NullPointerException
 - A very minor typo found while translating [TEXT]
 - [ja_JP][Admin Portal] Overlapped string 'Interface Mappings' in 'Agent Configuration' pane of 'Add or Edit Provider' dialogs.
 - [rhevm] Backend - Template - Cannot change "optimized for" to Desktop
 - [ja_JP][User Portal] String 'Remote Desktop' broken into two lines in 'Console Options' dialog.
 - It's impossible to create or edit VNIC profile on VM Interface Profile tab with DC 3.2 and engine 3.3
 - Quota resources are not counted correctly when vm with snaphots is removed.
 - Importing VM to DC without original VNIC profile can arbitrary put VNIC profile with port mirroring on its network when it shouldn't
 - Pollution with same event in engine.log - Failed to invoke scheduled method OnTimer: java.lang .reflect.InvocationTargetException
 - Permission for everyone are not reflected on specific user
 - fence_apc_snmp VdsFenceOptionMapping uses unsupported secure option
 - [rhevm] Backend - Webadmin - Cluster Properties dialog box - Disable "+" when no more keys are available
 - Hitting the refresh button doesn't refresh the disks list on UserPortal
 - [rhevm] Webadmin - unable to choose a policy different than 'none'
 - [ALL_LANG][Admin Portal] Unlocalized string 'User: with Role: ' in 'Remove System Permission(s)' dialog.
 - [zh_CN][Admin Portal] Translated string of 'Last' broken into two lines in the 'Enabled Filters' field of 'Edit Cluster Policy' dialog.
 - [de_DE, es_ES][RHEVM3.3][Admin Portal] - Indentation error found on New Network QoS page under Data Center Tab
 - [de_De][RHEVM3.3][Admin Portal] - Misplaced 'Help' tooltip of Virtual Machin Migrate page under Host tab
 - [fr_FR][Admin Portal] Help icon button misaligned in 'Attach ISO Library' dialog.
 - PM options for secondary agent are not saved
 - [fr_FR][Admin Portal] Garbage string displayed in the tooltips of '#path' column name in 'Edit Domain' -> 'Targets>LUNs' pane.
 - [fr_FR][ja_JP][Admin Portal] String 'Any Host in Cluster' broken into two lines in 'Run Virtual Machines(s)' dialog.
 - [fr_FR][Admin Portal] String broken into two lines in 'New Network Interface' dialog.
 - [en_US][ALL_LANG] [User Portal] Better to use question sentence 'Are you sure you want to remove the following items?' instead of 'Template(s)' in 'Remove Template(s)' dailog.
 - External scheduler balancing don't work due to ClassCastException.
 - Policy creation dialog: fields reset when changing options
 - Network QoS parameters aren't sent to vdsm on nic hotplug
 - error message in engine.log regarding a 404 response when attempting to read "/doc/ovirt-engine/manual/DocumentationPath.csv"
 - Cannot create same Local SD path on different Hosts
 - VnicProfiles action groups are missing in RolesTreeView
 - UserVmManager has import_export_vm permission, but there is no such action in UserPortal.
 - Failures to remove images from an import domain result in imported images on data domains being marked as illegal.
 - [User portal] Windows 7 x64 is launched with emulated AC97 sound card instead of Intel HDMA
 - AIO installer fails at local host installation with 3.3rc2 packages
 - rhevm-setup uninstalls rhevm on failure if user chose to continue with inability to rollback
 - engine-setup fails to install when Gluster only mode is selected
 - no way to select a cluster in new pool dialog
 - [engine-web-admin] "Select Host to be used" on remove storage domain window should be greyed out in case user do not choose "Format Domain" option when removing an unattached ISO/export domain
 - [RHEVM-ENGINE] wrong error when updating host IP address using REST API
 - [vdsm] after a failure in moveImage, deleteImage task won't be cleaned on vdsm
 - [engine] vnic_profile_id is not copied to new vm when cloning vm from snapshot
 - [frontend] no way to set empty network profile
 - It is impossible to hotplug a disk if the previous hotplug failed
 - <product__info> is missing 'name' and 'vendor' fields in rest
 - Add/remove VNICs in new VM dialog
 - Creating VNIC profile with "Allow all user..." checkbox checked results in Null(Network) permissions under Users permissions
 - [rhevm] Webadmin - Events - Search box with value "Events: Templates =\*" gives error (Exception message is StatementCallback)
 - Not possible to remove vm or re-assign quota of vm disk, when vm had assigned quota which no longer exists.
 - engine-backup --mode=restore fails on unrecognized option
 - VNIC profile aren't exposed as a subcollection from a single network resource
 - [engine-backend] [text-only] [external-provider] import of rhos image using glance over rhev fails with: "Unable to get the disk image from the provider proxy: java.lang.RuntimeException: Unable to recognize QCOW2 format"
 - ISO Domain set-up during run of 'rhevm-setup' fails to attach to Data Center
 - CPU pinning not properly loaded to WA portal Virtual Machine tab
 - Host: Exit message: internal error No more available PCI addresses
 - ISO Domain set-up during run of 'engine-setup' fails to attach to Data Center
 - Host name is not valid: The following addreses: 192.168.100.7 can't be mapped to non loopback devices on this host
 - Not possible to select quota, which is assigned to specific storage.
 - emulated machine reset on cluster compatibility level change
 - [engine-backend] [external-provider] there is no indicator by engine about failure in DownloadImage
 - Upgrade script missing field in vm_template
 - engine.log doesn't include log on custom properties.
 - Can't set QoS from edit network window
 - RHEVM-RESTAPI: "Start" vm sent as run once
 - [Admin Portal] New server VM has 'Disable strict user checking' disabled/unchecked by default
 - REST-API: Disallow endless authentication session
 - Creating a new VM, the "Virtual Disk" configuration never updates that the new disk was created.
 - [rhevm] Webadmin - Tags - Create new tag reveals two new tabs - Provider & VM Interface Profiles
 - Audit logs must be added to guest alignment feature.
 - [Admin Portal] OS type is wrong when importing VM with RHEV origin from an export domain
 - [engine-backend] [external-provider] disk gets stuck in 'Locked' state when importing an image which had been deleted from glance
 - Uninformative error message when trying to do disk alignment on disk that has snapshots while VM is running.
 - gluster - deactivate UFO/SWIFT on cluster for 3.3
 - Adding job with auto_cleared false, not working correct
 - Unable to copy template's disk from one storage domain to another.
 - [engine-backend] [external-provider] NullPointerException when trying to force destroy a glance storage domain on RHEVM
 - Edit network | Webadmin should create a default vnic profile when network is changed from non-vm to vm network
 - UserTemplateBaseVm role has a wrong name
 - Vm try to run on host with overloaded RAM when only RAM filter is used. And vm is pinned to overloaded host.
 - Add/Edit network | profile name should be grayed out when network is non-vm
 - ovirt-engine-notifier cannot be stopped properly
 - [RHEVM] [webadmin] [UI] Remove custom MAC address checkbox and Example text from Blank Template NIC
 - Windows template created on 3.2 setup has Single PCI checked after import to 3.3
 - When pintohost filter is active, then vm which is not pinned fail to migrate.
 - Scroll bar is missing when picking up a VNIC profile during VM creation
 - [ovirt-engine-notifier] - Mail - Cannot send mails with SSL ("Connection refused")
 - Gateway field can be updated for non-rhevm network on 3.2 and 3.1 Cluster and it should not exist on such a Cluster
 - [RHEVM] [backend] it is not possible to create new VM without vNIC
 - Change multi-monitor setting in VM Console option dialog for 3.2 compatible cluster
 - Install fails due to relation "tags_vm_pool_map" already exist
 - [ja_JP][Admin Portal] Networks tab -> Import Networks window -> "Network Provider" is not aligned with dropdown box due to insufficient space
 - Java update breaks ovirt-engine start
 - GUI / welcome page: locale drop down is not clickable when the page contains a scroll-bar
 - [AIO] Host does not resolve on NON loopback
 - [Admin Portal] Network interface name is already in use
 - Update NIC doesn't actually update the NIC if only network is passed (without passing VNIC profile)
 - NPE when updating a cluster compatibility version
 - Administration Portal, not Administrator Portal in main RHEVM page
 - Shutting down a vm after creating a snapshots causes async task to get stuck
 - [RHEVM] cannot assign bridgeless rhevm and VLAN network to the same host NIC
 - [RHEVM] run once returns error 500
 - Cannot remove an iscsi storage connection not attached to any storage domain
 - /etc/sysconfig/nfs sets variables that are not used by the nfs service
 - [RHEVM][webadmin] make network profile name check behavior consistent within GUI
 - Product key in sysprep.inf is empty in spite of correct ProductKey\* and OS type being set
 - rhevm cobertura instrumentation fails automated tests
 - [RHEVM] [webadmin] [text] misleading help text in Create New Bond dialog
 - Gluster Host force remove is not working
 - DB upgrade from 3.2 to 3.3 fails
 - /etc/sysconfig/nfs is deleted on cleanup
 - oVirt+Neutron: IP lost when shutting down the instance
 - Fix 'Wair for Launch" typo
 - engine-setup creates a new database if postgresql is down
 - if Migration Network is VLAN-tagged, traffic flows to management network
 - engine-setup sometimes logs passwords
 - [UserPortal][AdminPortal] Use of Guest IP address in the UserPortal instead of FQDN causing IE-based RDP client domain name mismatch
 - Required network checkbox selection not working properly when creating new network from Cluster tab
 - No way to remove disabled external plugins
 - engine-cleanup after manual db remove exits with a non-helpful message
 - Run Once doesn't respect custom domain value
 - [engine] Unable to remove snapshot after detaching disk from vm
 - List of applications is not populated in RHEV-M for guests
 - Edit VM Disk causes NullPointerException
 - Cannot set disk interface in user portal
 - [oVirt][Neutron] External network not blocked for hot updating
 - REST-API: Inconsistent schema implementation in PayloadFile
 - Import Template(s) window shows loading but never timeout nor shows information to import the template.
 - problems in engine-backup.sh
 - last pull of translations from Zanata for rhev-m 3.3 product.
 - Creating VM from Foreman fails with oVirt 3.3.1 beta.
 - support relative answer file name
 - answer files are world-readable and contain passwords

### VDSM

* Running vm in "runOnce" mode prevent to unlink vnic from vm
 - Restarting VDSM results in traffic duplication on a NIC with port mirroring
 - Assigning a non_vm/vlan/bond network with MTU to a host doesn't effect its interface
 - Unable to generate coredump
 - no SPM failover after SPM lost connection to storage
 - Traceback on booting of rhevh
 - Migration command in vdsClient doesn't include dstqemu field in its command description
 - Failed to run VM with gluster drives: internal error unexpected address type for ide disk
 - [vdsm] small raw volume sizes (<~1M) are rounded to 0m in createVolume (lvcreate error)
 - When starting vdsmd service, service asks for authentication name and password and wait forever
 - AcquireLockFailure failed to AttachStorageDomainVDS, Cannot obtain lock, wrong lease value
 - Unable to migrate VM between 3.3 (is14) hosts and older hosts
 - Device identifier mismatch when extending iscsi domain
 - [vdsm] Creating several disks at once fails CreateVolume with LVReplaceTagError sometimes
 - fail to delete snapshot based on a preallocated LV
 - engine report task failure after "after hook" fails although HW plug completed successfully
 - remoteFileHandler processes are not being cleaned up after removing a disk from FileSD
 - VM fail to start after upgrading from RHEV-H 6.4 to RHEV-H 6.5 (vdsm4.10->vdsm4.13) due to wrong libvirt configuration
 - vdsm not starts properly after clean installation.
 - vdsm from 3.3.1 beta missing dependency selinux-policy-targeted-3.7.19-195.el6_4.12.noarch
 - [vdsm] storage domain upgrade fails with attributeError
 - Override python-cpopen package
 - MOM is ballooning all VMs at once, even VMs without free memory enough
 - avoid vdsm segfaults due to m2crypto
 - [vdsm] VM disk does not get resized when performing live virtual disk resize on block storage
 - lvremove on one host while runaway 'dd' on another may lead to data loss
 - PRD33 - RFE: add support for multiple monitors on QXL device (single device with more RAM)
 - [ovirt] [vdsm] hibernate vm from vdsClient is broken: Attribute ERROR
 - [vdsm] Failure in iscsiadm update node command during discoverSendTargets on attempt to modify node.startup
 - Networking of the Nested VMs is blocked by the rule of the Parent VM
 - Vdsm uses not updated cache when doing getStorageDomainStats
 - [engine-backend] CreateStoragePool fails in case CreateStorageDomain is done by one host and CreateStoragePool is done by another one
 - Drive image file %s could not be found" message contains unparsed "%s"
 - cannot run VM when vdsm not connected to pool ("Image path does not exist or cannot be accessed/created")
 - vdsm: spmStop will be called because of 'TypeError: 'dictionary-keyiterator' object is unsubscriptable' error in vdsm when removing a template with depended vms from the export domain
 - Add second LUN for already connected target need manually run multipath reload
 - Storage operations are slow, long waits on OperationMutex
 - adding a tagged vlan network to rhevm network interface will change rhevm network boot protocol from dhcp to none
 - [vdsm] vdsm fails to rollback tasks after a failure in create snapshot (with several disks)
 - Configuring a vlanned network over an existing and used interface takes down the interface
 - [Migration Network] VDSM takes itself down on failure to connect to destination libvirtd
 - [vdsm] engine address does not appear in vdsm.log when SSL connection problem occurs
 - [RHEVM][backend][vdsm][multiple gateways] Keep ovirt management as default in the main routing table always
 - [vdsm] vdsm fails to bind to port due to another vdsm process running
 - Failed to LSM, "RuntimeError: Disk 'vda' already has an ongoing replication
 - No dependency between “Vdsmd” and “SuperVdsmd” daemons
 - Can't update the bond name
 - [vdsm] - getVdsCapabilities verb provides QoS for host networks
 - Migration fails - AttributeError: 'ConsoleDevice' object has no attribute 'alias'
 - Impossible to start VM from Gluster Storage Domain
 - oVirt 3.3 - (vdsm-network): netinfo - ValueError: unknown bridge ens3
 - shutdown/reboot VM causes an exception on removeVmFromMonitoredDomains
 - [vdsm] after a crash of libvirt, vdsm is stuck in recovery phase and unable to initialize
 - [vdsm] SuperVdsm fails to start due to ValueError: ipaddr rhevm is not properly defined
 - [host-deploy] vdsmd cannot be started
 - DHCP FAIL $reason removes source routing configuration on management network
 - [vdsm] guest alignment scan fails on host due to lvchange (deactivate lv) failure
 - Strange behaviour of LEASETIMESEC and IOOPTIMEOUTSEC in storage domain configuration
 - [abrt] vdsm-python-4.12.0-18.git78903dd.fc19: service.py:353:_runAlts:ServiceNotExistError: ServiceNotExistError: Tried all alternatives but failed
 - RHS-C: List gluster hook fails when some of the hooks directories (post/pre) are missing in the RHS nodes
 - Resarting supervdsmd service after performing libvirt reconfigure

### ovirt-node-plugin-vdsm

* Replace the string 'TBD' when showing the certificate
 - Console error message when using wrong IP address of ovirt Engine to collect certificate


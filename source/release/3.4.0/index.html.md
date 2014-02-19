---
title: OVirt 3.4.0 release notes
category: documentation
authors: alonbl, bproffitt, danken, derez, didi, dneary, dougsland, fabiand, fkobzik,
  fromani, lbianc, ndarshan, ofrenkel, sandrobonazzola, shaharh, ttorcz
wiki_category: Documentation
wiki_title: OVirt 3.4.0 release notes
wiki_revision_count: 77
wiki_last_updated: 2014-03-28
---

# OVirt 3.4.0 release notes

The oVirt Project is preparing oVirt 3.4.0 beta release for testing. This page is still a work in progress.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features that were added in previous oVirt releases, check out the [oVirt 3.3.2 release notes](oVirt 3.3.2 release notes), [oVirt 3.3.1 release notes](oVirt 3.3.1 release notes), [oVirt 3.3 release notes](oVirt 3.3 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes), and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### THIRD BETA RELEASE

oVirt 3.4.0 is still in beta.

In order to install it, you need to update ovirt-release to 10.0.1 or newer by running

      # yum update ovirt-release

If above doesn't work for you, try using distribution specific name:

CentOS:

      # yum update ovirt-release-el6

Fedora:

      # yum update ovirt-release-fedora

*   **Note** that on CentOS and RHEL you'll need also [EPEL](http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm) repositories enabled.
*   **Note** that on Fedora 19 you'll need to enable fedora-updates repository for having updated openstack packages (was in fedora-updates-testing until Jan 23th - you might want to run 'yum clean all').
*   **Note** that on Fedora 19 you'll need to enable fedora-virt-preview repository for using Fedora 19 as node on 3.4 clusters.

and then enable ovirt-3.4.0-prerelease repository

for CentOS / RHEL:

      [ovirt-3.4.0-prerelease]
      name=Pre release builds of the oVirt 3.4 project
`baseurl=`[`http://resources.ovirt.org/releases/3.4.0_pre/rpm/EL/$releasever/`](http://resources.ovirt.org/releases/3.4.0_pre/rpm/EL/$releasever/)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

for Fedora:

      [ovirt-3.4.0-prerelease]
      name=Pre release builds of the oVirt 3.4 project
`baseurl=`[`http://resources.ovirt.org/releases/3.4.0_pre/rpm/Fedora/$releasever/`](http://resources.ovirt.org/releases/3.4.0_pre/rpm/Fedora/$releasever/)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

### Fedora / CentOS / RHEL

If you're installing oVirt 3.4.0 beta on a clean host, you should read our [Quick Start Guide](Quick Start Guide)

If you're using nightly repo you'll need to run:

       # yum update "ovirt-engine-setup*"
       # engine-setup

If you're upgrading from oVirt 3.3 you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2 you should read [oVirt 3.2 to 3.3 upgrade](oVirt 3.2 to 3.3 upgrade)

If you're upgrading from oVirt 3.1 you should upgrade to 3.2 before upgrading to 3.3.1. Please read [oVirt 3.1 to 3.2 upgrade](oVirt 3.1 to 3.2 upgrade) before starting the upgrade.
On CentOS and RHEL: For upgrading to 3.2 you'll need 3.2 stable repository.
So, first step is disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

      [ovirt-32]
      name=Stable builds of the oVirt 3.2 project
`baseurl=`[`http://resources.ovirt.org/releases/3.2/rpm/EL/$releasever/`](http://resources.ovirt.org/releases/3.2/rpm/EL/$releasever/)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

Then

      # yum update ovirt-engine-setup

should install ovirt-engine-setup-3.2.3-1.el6.noarch.rpm
if you have already updated to 3.3.x please use distro-sync or downgrade instead of update.
Then:

      # engine-upgrade

this will upgrade your system to latest 3.2.
Once you've all working on 3.2, enable 3.3/stable repository, then just

      # yum update ovirt-engine-setup
      # engine-setup

will upgrade to latest 3.3.

## What's New in 3.4.0?

*   ovirt-engine-reports, ovirt-engine-dwh
    -   integrated to ovirt-engine setup.
    -   Gentoo support.

## Known issues

*   EL >= 6.5 or cloud-init >= 0.7.2 are needed for cloud-init feature support ()
*   all-in-one requiures fedora-virt-preview repo as in the next item
*   For using Fedora 19 as node on 3.4 clusters you need to enable fedora-virt-preview repository ()
*   Node
    -   Needs to be booted in permissive mode by appending: enforcing=0
*   engine-setup: upgrade from 3.3 overwrites exports with acl None ()

## Bugs fixed

### oVirt Engine

* [RFE] Webadmin's layout is broken when not enough display real-estate [main-tab clutter, sub-tab clutter, buttons-panel clutter]
 - [RFE] Please allow to search in a case-insensitive manner from the search bar
 - [engine-core] Activating an already active domain through REST fails with "domain inaccessible"
 - createVG failures are not logged in vdsm logs
 - [RFE] Adding Disk to a VM which is not down adds a Disk that is not activated
 - webadmin - centralized refreshing logic
 - ovirt-engine-webadmin-portal: New VM Pool button should be grayed out when there are no templates (except Blank template)
 - [UserPortal] User is not able to see newly added permissions on object if he inherited this permission on that object.
 - [RHS-C] SHD service status details are not displayed in "Services" tab in Cluster
 - VMs are not migrated properly when NFS storage is blocked on host
 - [RHS-C] Creating a Distributed Stripe volume using the default Stripe Count (4) actually creates only a Stripe volume
 - [RFE] collect the "created_by" field of a VM into it's configuration history
 - [oVirt-webadmin] [setupNetworks] "No valid Operation for <network_name> and Unassigned Logical Networks panel"
 - REST-API: Allow copy/move disk from disks collection
 - engine: DeactivateStorageDomainCommand fails with vdsm error: 'Operation not allowed while SPM is active' because we do not actually send SpmStop while there are unknown tasks
 - [event tab] better phrasing for actions done by unauthenticated users, currently appears as <UNKNOWN>
 - Change "Guide" link to Power User Portal Guide
 - [Admin Portal] sort roles in alphabetical order in Configure|Roles window
 - [vdsm] remove mapping fails after extend storage domain with force=True
 - Define meaningful Expires for static css|ico files
 - [RHS-C] No event messages are generated in UI when a brick goes from UP --> DOWN / DOWN --> UP
 - [RFE] ovirt-engine URI rework
 - webadmin: when unchecking the "collapse snapshot" tag in import dialogue it will change the disks allocation policy in the dialogue view to thinprovision no matter what the original disk is
 - Migrating VM vm_name to Host <UNKNOWN>
 - [RHEVM][webadmin] weird scroll-bar flickering on Host -> Network Interfaces sub-tab when refresh button is pressed
 - [User Portal] Displaying incorrect events after renaming VM
 - engine: LiveMigrateDisk: java.lang.reflect.InvocationTargetException when vm is removed before the deleteImage step is cleared on wipe=true disk
 - [RHS-C] Detected server host3 removed from Cluster <UNKNOWN>, and removed it from engine DB.
 - [RHS-C] Binary hook contents are being displayed during Resolve Conflicts
 - [RHS-C] Remove all the RHEVM related events from "Manage Events"
 - [RFE] spice proxy support at cluster/vm-pool granularity
 - event names partially overlap in "manage events" dialog
 - [RHSC] Cluster Compatibility Version version should default to the latest version
 - engine: no alert for user that specific disks cannot be moved when we move multiple disks at once
 - [User Portal] Disable strict user checking - warning, confirmation and then error
 - Export and Import of a VM do not save the plugged/unplugged status of its disks
 - [restapi] Missing permissions link at /vmpools url
 - 'Remove' button on quota consumer should be enabled immediately, after click on user.
 - [RHSC] When a host is moved to Maintenance after being Non-operational, it is removed from the cluster, if another host in the cluster is UP.
 - osinfo file - deriving properties from NON-existing section causes 'General command validation failure.' in UI
 - engine [logger]: same exception is logged multiple times in engine log
 - [RHSC] Import cluster when one of the peers is unresolvable or unreachable from the engine, fails.
 - [RHSC] Remove hooks from a cluster, when all servers in the cluster are removed from engine.
 - [oVirt] [provider] Dialog doesn't update unless focus lost
 - RHS-C: No error message seen while starting "ovirt-engine-notifier" when "MAIL_SERVER" is NOT defined
 - [Admin Portal] Setting config value DefaultWindowsTimeZone has no effect
 - [RHEVM][UI][TEXT] Comment tooltip is not well adjusted to its text
 - [RHSC] Console allows addition of a host to a cluster, that has the same UUID as that of a host that is already present in the cluster
 - Change column header for clusters on which a policy is applied for usability
 - [Admin Portal] Deleted config of UI plugin is not reflected, data are kept until engine is restarted
 - [RHS-C] AddVdsCommand should use LockManagerProperly
 - scheduling policy: please rename the predefined Functions / Weights Modules / Factors
 - [RHEVM-ENGINE] Authentication method doesn't change when using arrow keys
 - It is possible to change an iscsi storage connection and set an empty target
 - [rhevm] Webadmin - Vms - Vms:Hosts autocomplete is incorrect
 - [rhevm] Webadmin - Users - SearchBox doesnt display Templates in search for Users (Users: Templates.name =R\*)
 - [rhevm] Webadmin - Hosts - SearchBox "Host:user.usrname =\*" doesn't filter correctly
 - REST-API: --parent-tag-id option doesn't exists in 'update tag' options
 - [ovirt-engine-notifier] - Mail - Incorrect mail headline on Error (Issue Solved Notification, Failed to query for notifications)
 - [scale] The thread pool is out of limit
 - Cannot add hypervisor host when use chinese support
 - [RHSC] Error message seen on starting rebalance on a volume with one brick needs improvement
 - [RHSC] Show error pop-up when user tries to stop a volume which has rebalance in progress
 - RHS-C: Introduce a Force option in the UI to allow creation of bricks in the root partition
 - [es_ES] [Admin Portal] Virtual Machines tab- Chart heading "Time executing" does not fit in the available space
 - [Admin Portal] Relogin with username/password via login screen after being automatically logged off causes HTTP auth dialog
 - Tabbing navigation in Add host tab should go from password field to OK buton
 - RHS-C: Rebalance Status refresh was not occuring properly
 - [RHSC] Not able to close rebalance status dialog .
 - [RHSC] Bricks tab for a volume not displaying the bricks and remains in the loading state for very long - more than 15 minutes.
 - Glance download is not interrupted when the InputStream is closed
 - [spice-html5] Unable to send ctrl-alt-del to a Windows guest while using spice-html5 console
 - [RHSC] - Rebalance status title should be changed.
 - [RHSC] - Brick advanced details gives error.
 - [RHSC] - An event message should be displayed when rebalance completes on a volume.
 - [RHSC] 'Add Network' dialog for a cluster contains fields not relevant to RHS
 - [ovirt-engine-backend] there are dos end of lines in engine.log
 - [RFE] Addition of os disk indicator on VM import screen
 - [RHSC] - No event message generated when rebalance is started from CLI.
 - [RHSC] A user with permissions to manipulate volumes cannot delete a volume
 - [vdsm] engine fails to add host with vdsm version 4.13.0
 - Description for the creation of cluster is incorrect
 - [RFE] Diplay client IP in the VM Sessions tab
 - REST-API: role should not be added to user without having a resource in context
 - REST-API: Inconsistent schema implementation in PayloadFile
 - call to ClusterGlusterVolumeBricks::add() successfully adds brick to volume but throws exception
 - [RHS-C] The menu option "Rebalance" should appear after "Stop" in Volume tab
 - [RHS-C] Drop down menu in Activities column for volumes should have a box on mouse hover
 - [RHS-C] Remove bricks status dialog should show host names instead of IP address
 - [RHS-C] In the Hosts tab, the sub-tab "Gluster Bricks" should be renames as "Bricks"
 - [RHS-C] Hide all the virt related fields and menus from RHSC
 - [RHS-C] Status of the volume in activities column after Stop rebalance should be in sync with gluster CLI output
 - [RHS-C] Show units of time (sec/ min) in runtime column in remove brick status dialog
 - RHS-C: Hide NFS setup, Application mode and Datacenter storage type from CONFIGURATION PREVIEW during rhsc-setup
 - [RHSC] - Stop Rebalance button does not get disabled once rebalance is complete.
 - [RHSC] - Completed text in the status dialog needs to be highlighted or made bold.
 - [RHSC] Error message on failure to start remove-brick is incorrect
 - [notifier] sent notification should be visible in INFO log level
 - [RHSC] - Skipped file count is getting displayed as failed file count in rebalance status dialog.
 - [notifier] If Alert and Issue Solved Notifications are both discovered during next iteration, the order is messed
 - [RHSC] - Node column should be sorted in the rebalance status dialog.
 - [RHSC] In the task tab, show the size of rebalanced files in MB or GB
 - [notifier][RFE] Use STARTTLS
 - [RHSC] - Cancel button is not working in the stop rebalance dialog box.
 - [RHSC] - Stop rebalance confirmation dialog does not display the volumes on which rebalance is going to be stopped.
 - [text] spelling mistakes in engine event log
 - [RHSC] 'CPU Name' field for a host is empty and 'CPU Type' is scrollable
 - [RHSC] Status of bricks that reside on a server which is down, should be shown as down.
 - message in the 'remove' confirmation dialog cannot be overridden in some cases
 - [RHSC] Import host dialog hangs
 - [RHSC] After starting rebalance on a volume, the rebalance button is active for some time.
 - [RHSC] - Remove brick warning for distributed replicate volume has an extra parameter which is not relevant .
 - RHS-C: Commit and Retain buttons are disabled in Remove brick status pop-up even though it's ready for Commit/Retain
 - RHS-C: Typo in Events during Remove brick
 - [RHSC] Menu items in the remove-brick menu are all disabled
 - [RHSC] - Stopped At field is not getting dispalyed in the rebalance status dialog once rebalance is stopped.
 - [RHSC] Rebalance status dialog appears on the Console on clicking on the Status button and immediately disappears
 - [RHSC] - Monitoring stop rebalance from CLI does not work.
 - Upgrade from ovirt-engine-3.3 to master fails
 - Storage and dc are up although there is no host
 - [oVirt-webadmin][network] Network roles in cluster management should be radio buttons
 - [RFE] add trigger to stop etl connection via engine db value.
 - [RHSC] - Table in the rebalance status dialog should be same as that of CLI.
 - [RHS-C] In Add Bricks" pop-up, reference of "Servers" is NOT changed to "Hosts"
 - [RHS-C] Host detach fails but does not show an error in UI
 - [RHS-C] Stop remove brick does not show the remove brick status
 - Users with GlusterAdmin role should be able to Add/Remove Cluster and Hosts
 - [RHSC] Brick advance details dialogue should have the heading “Brick Advanced Detail”. In the General tab of Brick Advance details, swap the last two items “Mount options” and “File System” position.
 - [RHS-C] Remove brick status dialogue : Rename the column from “File Rebalanced” to “Files Migrated”
 - Rename Gluster Host to Host in detach Host dialog
 - [RHSC] In the bricks sub-tab for a server, show the bricks in sorted order
 - Put – (dash) before every item name for the purpose of consistency in confirmation dialogues. Particularly in Maintenance Confirmation dialogue...
 - [RHS-C] Error pop up has empty title
 - [RHSC] Retain button in the remove-brick status dialog does not work.
 - [RHSC] - Close button in commit remove bricks dialog should be changed to 'Cancel'
 - Remove Multiple hosts throws error
 - [RHS-C] Remove-brick icon in the Volumes tab and Bricks tab should appear simultaneously
 - [RHSC] General Tab under Host : All the rows has to be properly aligned
 - [RHEVM] [webadmin] fix Edit Role dialog layout
 - Webadmin - Events - Search box: filtering events by time shows bogus results
 - Starting rebalance should reflect in UI immediately that task has started
 - backend search returns only first page when given max=-1
 - Create DB Scripts - incompatible code breaking dwh cross compatibility
 - [oVirt] [webadmin] In VM Guide Me, button Configure Virtual Disks doesn't change
 - Duplicated login events
 - Webadmin UI is now requesting two slashes in front of URLs
 - Default DC & Cluster has fixed UUIDs
 - [RFE] Allow users to cluster level enable/disable KSM
 - Volumes tab and sub-tabs not taking equal space
 - [RHSC] Remove-brick status dialog hangs when glusterd goes down on the storage node
 - Reinstall host by rest api fails on root_password field requirement
 - [RHS-C] About dialog does not have a title.
 - [RHSC] After committing remove-brick or retaining the brick, buttons 'Commit' and 'Retain' are not disabled in the remove-brick status dialog
 - [RHSC] Edit Role Dialog Should Read "Volumes" instead of "Gluster"
 - restore.sh - wrong example commands in --help
 - [restore.sh] restore.sh is doing restore.sh.log in /usr directory
 - [RFE] RunOnce dialog can not set a vnc keymap itself
 - [engine-webadmin] inappropriate message when trying to perform an operation on a locked disk
 - [RHSC] Unable to remove more than one pair of bricks from a distributed-replicate ( 3x2 ) volume
 - REST-API: Session based authentication in 3.4 is broken
 - [RHSC] Events log message seen on adding and removing a role needs improvement.
 - REST: unable to resolve hook content conflict by copying from another host
 - [RFE] engine.log is missing the iso file name, for run once \\ boot from CD.
 - REST: can not remove brick from distributed-replicate volume
 - An event message for commit remove brick should mention the number of bricks removed.
 - [RHSC] 'Could not fetch remove brick status of volume' message lists all the bricks of the volume
 - [RFE] Support for moving hosts to sleep when using Power Saving policy
 - [RFE] [oVirt][webadmin] Change comment column title to icon, and move to right of name
 - [RHSC] Remove-brick icon disappears from the UI, when glusterd is killed on the node which was running remove-brick
 - Paused VM can be resumed on host that is not UP
 - Make default VNC console mode configurable
 - [RHS-C] Replace "GLuster" with "Gluster" in "Add Event Notification" under Users tab
 - [RHSC] Bricks status is not getting synched when gluster CLI output shows the port as N/A
 - Engine does not verify that proxy supports PM agent
 - [RHS-C] 'Add Event Notification' should show an error message if MAIL_SERVER is NOT configured and if "ovirt-engine-notifier" service is NOT started
 - [RFE] VM-VM Affinity
 - [RFE] High Availability flag should be included when exporting/importing from Export Domain
 - [RFE] Even Distribution Policy by number of VMs
 - [RFE] Make reservations for HA VMs to make sure there's enough capacity to start them if N hosts fail
 - CreateVDSCommand Logging message does not report NIC devices
 - [RHSC] After retaining a brick using the Retain button in the status dialog, the 'Stopped At' field does not appear
 - when rebalance or remove-brick happens volume name gets updated as UNKNOWN in the tasks pane
 - [REPORTS] - dashboard results an error, after reports were installed
 - REST: migrating step's type is unknown
 - REST: rsdl definition for brick migrate is incorrectly defined
 - add events for remote console connection
 - [RFE] Predictable vNIC order
 - rest api: incorrect error message commiting part of the migrated brick set
 - Rebalance start from gluster CLI does not update icon in the volume activities column.
 - No event message gets generated when remove-brick is stopped from CLI
 - Virt related links are returned in RSDL when engine is in Gluster only mode
 - Save user's console setting per pool
 - Show name of the template in General tab for a vm if the vm is deployed from template via clone allocation.
 - [RFE] Track downtime for inactive VMs
 - [RHSC] Server removed from DB after being in Up state
 - In the event of a full host power outage (including fence devices) a user must wait 19 mins (3 x 3 minute timeouts + 10 minutes for the transaction reaper) until they can manually fence a host to relocate guests.
 - [engine-setup] Encoding issue in /var/lib/ovirt-engine/setup-history.txt
 - [RFE] Virtual pxe boots out of order - NICs ordered according to the MAC addresses
 - In the event of a full host power outage (including fence devices) VDS_ALERT_FENCE_STATUS_VERIFICATION_FAILED alert remains in audit log
 - tree view unsorted
 - [oVirt][infra] Device custom properties syntax check is wrong
 - [RFE] Add drac7 fence agent with ipmilan as implemintation
 - RHEVM-CLI: action <type> <id> <action> command accepts async and grace_period-expiry parameters but they are missing in auto-completion
 - [RHSC] - Values of Physical Memory and swap size in hosts general sub tab are incorrect.
 - [RHSC] Unable to remove U1 Server after Server failed to add
 - cleandb.sh does not obey '-l logfile'
 - [RFE] Add Reboot option for VM
 - Fail to delete network using API
 - Fix SPICE ActiveX issues with MS Internet Explorer 11
 - Newly-created QoS isn't saved for network
 - Edit Host Network dialog can't be approved in clusters < 3.4
 - [RFE] Enable configuration of maximum allowed downtime during live migration per guest
 - [RFE] Cross arch support for ovirt
 - [RFE] PPC arch support
 - Memory snapshot on PPC64
 - Migration on the ppc64 platform
 Fixed in oVirt 3.4.0 beta 2:

* Management network VLAN tagging behaves badly
 - [RFE] Hypervisor RHEV-H only connects to the Dell Equallogic using one connection. it is expected to do multipathing and have 4 connection to it.
 - oVirt Node Upgrade: Support N configuration
 - Storage connection is left in db table in case adding storage domain fails
 - PRD34 - [RFE] Need to reclaim horizontal real estate by collapsing the tree panel
 - Cannot read name of 'current' CD image through the REST API
 - deleteImage task, which was started as part of snapshot creation (with save memory) roll-back remains running forever
 - Change label for Network profiles to be more specific to VMs
 - Add VM network icon in the Logical network dialog
 - [engine-setup] engine-setup should detect if postgresql's shared_buffers are below active kernel.shmmax
 - [OVIRT][ENGINE] Hot Plug CPU - Support dynamic virtual CPU allocation and deallocation
 - [engine-backend] bad handling with code 205 response from vdsm to CopyImageVDS request in engine.log
 - [RFE] Have ability to modify VM template - template versions
 - [RFE] Allow domain of multiple types in a single Data Center
 - XP VMs get virtio-scsi controller when created as a brand-new VM or from template
 - Gluster brick sync does not work when host has multiple interfaces
 - Setting shmmax on F19 is not enough for starting postgres
 - [RHEVM-SETUP] - remote db configuration. rhevm-setup asks for different configuartion than the dwh & reports setups
 - RHEVM SETUP REMOTE_DB: postgresProvisioning remains none in answer file
 - Allow configuring Network QoS on host interfaces
 - Not possible to power off VM that failed migration.
 - sub-tab events in different main-tabs are being duplicated
 - cloud-init options persistence / unification with sysprep options
 - [notifier] MAIL_PORT=blabla does not make the app fail but it continues to send to port 25
 - [notifier] MAIL_PORT=0 is nonsense as we are not binding but connecting to remote host
 - [es-ES] sync option in network edit is not displayed
 - [RFE] allow to provide a password change url on login failure when password expires
 - [NetworkLabels] Attaching two labeled networks to a cluster result in failure of the latter
 - QoS doesn't take effect when synchronizing network in cluster < 3.4
 - Host with network QoS can be moved to cluster < 3.4
 - [NetworkLabels] Detaching two labeled networks from a cluster result in failure of the latter
 - [NetworkLabels] Host nics labels are being deleted when setup networks api is called
 - [NetworkLabels] Missing 'Edit network' button on labeled networks which are attached to a nic in 'setup networks' dialog
 - Events are being pulled from audit_log in a very inefficient way
 - VDSM < 3.4 reporting QoS in 3.4 cluster produces ClassCastException
 - RHEV 3.2 RHEV-M "Enforcing" typo in host reboot log message
 - Updating a network on nic via 3.0 api fails
 - Cannot update comment for VM in user portal
 - Cannot create VM snapshot, dialog does not load
 - duplicate commit button for snapshots
 - [REST] Single disk snapshot fails without specifying storage domain
 - Assigning a role to a user fails with an SQL error
 - Some properties not persisted during Clone of VM Snapshot
 - multiple storage domains - edit dialog always resets type to Shared
 - engine-managed-domains - typos in usage report
 - [engine] Files created on stateless vm are retained after powering off and back on
 - Misaligned Host Network QoS columns on Chrome
 - Templates are being pulled from template view in a very inefficient way
 - Extend important limits to their hard limit
 - Host network QOS get a null value if you cancel the creation of new Network QOS
 - Unneeded line in Profiles subtab when creating the new network
 - Do not override httpd ssl.conf and root on upgrade
 - Port mirroring should be greyed out of VNIC profiles of networks imported/created in Neutron
 - Neutron labels should be invisible for the Host NICs
 - vdc_options - set version correctly
 - [oVirt] NPE in update vm/template
 - One display seen on a multi-monitor guest after rhev 3.0 to 3.2 migration
 - Change NIC type from sPAPR VLAN to any other type causes error when starting the VM (PPC)
 - [AIO] support RFC2317 reverse DNS lookup
 Fixed in oVirt 3.4.0 beta 3:

* user-portal/web-admin: refresh rate across tabs/sections should be identical (currently each tab has its own refresh rate)
 - [engine-manage-domains] should use POSIX parameter form and aliases as values
 - [Storage] [Direct LUN] Wrong event message when removing direct LUN disk.
 - PRD34 - [RFE] When changing the cluster and data centre compatibility versions, it should be clearly stated that changing from version 3.0 makes the data domains incompatible with RHEV 3,0 and roll back will not be possible.
 - [REST-API] add descriptions to import vm/template SD source/destination params in RSDL
 - engine: host stuck on Unassigned when moving from status Maintenance when storage is not availble from the host
 - [RFE] Able to detach the ISO domain from the DataCenter though iso is attached and mounted in the VM
 - engine: can't live migrate a disk if the vm also has an inactive disk attached on a domain which is in maintenance
 - engine: no CanDoAction for creating vm from snapshot when snapshot has a disk on a maintenance domain
 - manage domains should try to resolve FQDNs provided by -ldapServers
 - Can not do scan alignment to several disks simultaneously. Scan alignment option is greyed out.
 - No email notification sent when host recovers from previously reported condition
 - [RFE] improve context-sensitive help csv mapping files
 - PRD34 - [RFE] Export storage domain maintenance mode confirmation
 - [Admin Portal] Local DC - The Cluster is fully configured and ready for use.
 - When trying to create a vNicProfile without a network, an invalid error is returned
 - Force removal of DataCenter fails to remove vm_pool from DB
 - PRD34 - [RFE] Add 'warnings' to Relocate VM disk "Move" and "Deactivate" actions
 - Allow manual fence in connecting state
 - Update vnic_profile fails for VM vnic.
 - OVF descriptor file data via the REST API for the Active VM
 - Source cluster and dc does not show up in Power Management tab while editing a previous added host [pm_proxy_preferences]
 - no square-loading-animation when changing left-pane-tree selection
 - [RFE] allow importing glance image as a template
 - Missing storage allocation checks when extending a disk
 - gracefully warn about unsupported upgrade from legacy releases
 - [engine][network] Missing audit log for mass operations
 - [engine-backend] [RO-disks] snapshot creation includes RO disks
 - Creating a new VM fails with MAC_POOL_NOT_INITIALIZED
 - Storage Live Migration should only snapshot the migrated disk
 - [TEXT] engine-managed-domains - inconsistent cases in usage and error messages
 - Change default display type for x86-64 VMs
 - some administrators (admin@internal, admins added via engine-manage-domains?) are displayed with a 'user' icon by mistake.
 - Guide me window - new is hidden by the icon
 - Fail to add Event-Notification
 - engine-managed-domains - insufficient validation of the "-report" parameter
 - [RFE] engine-managed-domains - sort domains alphabetically when reporting
 - Unable to add group via RESTAPI
 - vdsm: cannot start a vm in read only with IDE disk type
 - Action buttons in the Hosts/Network interfaces subtab show 3.0 and 3.1 action simultaneously
 - rhevm-config output when failing to change password is easy to miss and doesn't give any context
 - [events] Incorrect mapping: DWH_STOPPED - History Service Started
 - Vm update not work via REST api
 - SD becomes inaccessible while adding a new lun to it
 - [RFE] OVF descriptor file data via the REST API for the Active VM
 - Bookmarks panel is not refreshing upon adding/editing/removing a Bookmark
 - [RHSC] - Rebalance icon in the activities column chnages to unknown (?)
 - [engine] Redundant Commit Network Changes command is sent to host when cluster is changed
 - [engine] Audit log event for failure to commit network changes appears as INFO messages
 - useDnsLookup flag is ignored at rhevm-manage-domains - krb5.conf file will always contain realms and "domain_realm" section
 - Guest NIC initialization uses tag "nics" instead of "nic"
 - RHEV 3.3 rhevm-shell 'show vm' not returning all guest attributes
 - [notifier] MAIL_SMTP_ENCRYPTION=tls falls back to plain-text SMTP if server does not advertise STARTTLS
 - Unable to interact with user portal login dialog
 - [REST API] duplicate "Nic" name from GuestNicsConfiguration
 - Cannot login as admin@internal
 - Type converters in XML schema confuse Java SDK generator
 - allinone fails on upgrade - no admin password
 - Cannot run VM for windows VM if sysprep is enabled
 - task list in Webadmin - jobs disappear while still running
 - restapi JAXBMarshallingException are not propogated
 - engine-backup --mode=restore should point to documentation on failure
 - When adding a user that belongs to a group, it does not inherit the group permissions
 - [NetworkLabels] LABELED_NETWORK_ATTACHED_TO_WRONG_INTERFACE entry in AppErrors is split to two lines
 - Disk name doesn't get assigned automatically after a CREATE command.
 - Queries generated for data centers don't take into account the replacement of "type" with "local"

### VDSM

* VM fails to start when qemu.conf's spice_tls conflicts with vdsm.conf's ssl
 - domain monitor does not stop during disconnectStoragePool on HSM during destroyStoragePool flow on SPM
 - Direct LUN is not being updated after resizing
 - Failed creating storage pool - AttributeError: 'module' object has no attribute 'MAX_DOMAINS'
 - fenceNode passes wrong argument to the fence agent
 - [LOG][vdsm] KeyError: 'domainID' during teardownImage in power-off to VM
 - [Hosted Engine] Unify maintenance flows
 - Migrating between older and newer RHEV-H images leads to flood "path /rhev/data-center/mnt/blockSD/<UUID>/images/<UUID>/<UUID> not assigned to domain"
 - do not report negative rx/tx rate when Linux counters wrap
 - vdsm: fix RTC offset
 - sanlock not configured with no error which fails vdsm service start and fails host installation
 - Command PollVDS execution failed
 - vm's status is changed to pause for a short moment during volume refresh (after an extend)
 - vdsmd not starting on first run since vdsm logs are not included in rpm
 - netconfig: set ETHTOOL_OPTS when a NIC goes up
 - iscsid daemon not started when vdsm starts and iscsi storage not available
 - Not able to add a node to 3.4 Cluster in Ovirt 3.4 engine
 - Gluster brick sync does not work when host has multiple interfaces
 - vdsm-tool configure outputs misleading error messages although it ends successfully
 - Cloud-Init: generated config-drive CD image is world-readable
 - Default route is not set properly for management network if downstream/upstream engine and VDSM are mixed
 - failed to add ovirtmgmt bridge when the host has static ip
 - yum transaction on rhel7: reading information on service vdsmd: No such file or directory
 - vdsm-hook-nestedvt uses kvm_intel-only syntax
 - [RFE] Prevent RHEV from requiring hwaddr lines within ifcfg files
 - Can't activate a host due to /etc/sudoer configuration
 - Resource lock split brain causes VM to get paused after migration
 - vdsm-tool configure fails stopping service
 - before_device_migrate_source not being called
 - [vdsm] getStorageDomainInfo fails due to key 'info' missing from poolInfo for master domain
 - VDSM - hooks - after_update_device_fail hook fails
 - Cloud-Init: meta_data.json and user_data files on config-drive are world-readable
 - stray libvirt networks make vdsm fail to recognize management network on native interface with "Network defined withoutdevices" error of setupNetworks
 - Paused VM not unpaused when vdsm is starting and storage domain is valid
 - Malformed libvirt XML is causing Storage Live Migration failure.
 - New VMs use display network ports outside of documented 5634 to 6166 range
 - vdsClient should provide more debug info- in case of malformed XML response
 - Bond "speed" does not reflect the correct speed
 - PRD34 - [RFE] vdsm does not recognize hot-plugged host interfaces
 - vdsm should monitor bond interfaces, sub-interfaces and bridges status
 - Size of ISO images shown in 'Images' tab of ISO Domain wrong
 - migration_timeout not honoured, live migration goes on beyond it

### ovirt-node-plugin-vdsm

* UI: AttributeError("'module' object has no attribute 'configure_logging'",)
 - engine_page: use vdsm to detect mgmt interface
 - engine_page: display url/port only on available

<Category:Documentation> <Category:Releases>

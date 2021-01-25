---
title: oVirt 3.4 Release Notes
category: documentation
toc: true
authors: bproffitt, derez, knesenko, sandrobonazzola
---

The oVirt Project is pleased to announce the availability of its fifth formal release, oVirt 3.4.

oVirt is an open source alternative to VMware vSphere, and provides an excellent KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3 release notes](/develop/release-management/releases/3.3/),
[oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/).
For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide.html) and the [about oVirt](/community/about.html) page.

# oVirt 3.4 Release Notes

## Hosted Engine

*   oVirt 3.4 features hosted engine, which enables oVirt engine to be run as a virtual machine (VM) on the host it manages. Hosted engine solves the chicken-and-the egg problem for users: the basic challenge of deploying and running an oVirt engine inside a VM. This clustered solution enables users to configure multiple hosts to run the hosted engine, ensuring the engine still runs in the event of any one host failure.

## Enhanced Gluster Support

*   [Gluster Volume Asynchronous Tasks Management](/develop/release-management/features/gluster/gluster-volume-asynchronous-tasks-management.html) enables users to re-balance volumes and remove bricks in Gluster operations/rebalance and remove bricks in Gluster volumes.

## Preview: PPC64

*   [Engine Support for PPC64](/develop/release-management/features/virt/engine-support-for-ppc64.html) will add PPC64 architecture awareness to the ovirt-engine code, which currently makes various assumptions based on the x86 architecture. When specifying virtual machine devices, for example, what is suitable for x86 architecture may not be for POWER (or may not be available yet).
*   [VDSM Support for PPC64](/develop/release-management/features/virt/for-ppc64.html) introduces the capability of managing KVM on IBM POWER processors via oVirt. Administrators will be able to perform management functionalities such as adding or activating KVM, creating clusters of KVM and performing VM lifecycle management on any IBM POWER host.
    -   <div class="alert alert-info">
        Migration is still a work in progress for KVM on IBM POWER processor.

        </div>

## Preview: Hot-plug CPUs

oVirt 3.4 adds a preview of a [Hot-plug CPU](/develop/release-management/features/virt/hot-plug-cpu.html) feature that enables administrators to ensure customer's service-level agreements are being met, the full utilization of spare hardware, and the capability to dynamically to scale vertically, down or up, a system's hardware according to application needs without restarting the virtual machine.

## Other Enhancements

### Virt

*   [Guest Agents for openSUSE](/develop/release-management/features/virt/guestagentopensuse.html) and [Ubuntu](/develop/release-management/features/virt/guestagentubuntu.html) provide ovirt-guest-agent packages for these Linux distributions.
*   [SPICE Proxy](/develop/release-management/features/virt/spice-proxy.html) lets the users define a proxy that will be used by SPICE client to connect to the guest. It is useful when the user (e.g., using user portal) is outside of the network where the hypervisors reside.
*   [SSO Method Control](/develop/release-management/features/infra/sso-method-control.html) enables users to switch between various SSO methods in the UI. The first version of the patch only allows switching between guest agent SSO (current approach) and disabling SSO.
*   [Init Persistent](/develop/release-management/features/virt/vm-init-persistent.html) allows persistent use of Windows Sysprep and Cloud-Init data to the Database. By persisting the data, administrators can create a template with VM-Init data that will enable initialize VMs with relevant data.
*   [Guest Reboot](/develop/release-management/features/virt/guest-reboot.html) enable users to restart VMs with single command.
*   [Template Versioning](/develop/release-management/features/virt/template-versions.html) enables adding new versions to existing templates, by either selecting a VM and using it to create a new version of a template or by editing a template, and when saving, selecting Save As Version.

### Infra

*   [oVirt Engine SNMP Traps](/develop/release-management/features/infra/engine-snmp.html) extends events notifier capabilities and enables oVirt to generate SNMP traps out of system events to integrate oVirt with generic monitoring systems.
*   [Authentication & Directory rewrites](/develop/release-management/features/infra/authentication-rewrite.html) allow re-implementation of Authentication and Directory support within oVirt, which is currently based on Kerberos and "internal" user for authentication, and on LDAP and the database (for internal domains).

### Networking

*   [Network Labels](/develop/release-management/features/network/networklabels.html) provides the ability to label networks and to use that label on the host's interfaces, so the label abstracts the networks from the physical interface/bond (which can be labelled with one or more labels).
*   [Predictable vNIC Order](/develop/release-management/features/network/predictable-vnic-order.html) resolves the usual mess in MAC address and PCI address mapping when adding a virtual NIC to an oVirt guest by making in-guest order of NICs predictable, depending their visual order.
*   [OpenStack Neutron integration](/develop/release-management/features/network/detailed-osn-integration.html) will give users the ability to use various technologies that OpenStack Neutron provides for its networks, such as IPAM, L3 routing, and security groups, as well as the capability to use technologies not natively supported in oVirt for VM networks.
    -   <div class="alert alert-info">
        This feature still does not include migration for security groups, which will be added in an upcoming release during the 3.4 release cycle.

        </div>

*   [Adding iproute2 support](/develop/release-management/features/network/networkreloaded.html), creating a network backend from iproute2 tools, following the internal API.
    -   <div class="alert alert-info">
        This feature is still partially implemented, and will be completed in an upcoming release during the 3.4 release cycle.

        </div>

*   [Multi-Host Network Configuration](/develop/release-management/features/network/multihostnetworkconfiguration.html) allows the administrator to modify a network (i.e., VLAN-id or MTU) that is already provisioned by the hosts and to apply the network changes to all of the hosts within the datacenter to which the network is assigned. The feature will be enabled for 3.1 datacenters and above, regardless of cluster level in order to avoid inconsistency between hosts network configuration in various clusters.

**Planned Features: Networking**

*   [Host Network Quality of Service](/develop/release-management/features/network/detailed-host-network-qos.html) provides the means to control the traffic of a specific network through a host's physical interface. It is a natural extension of the [VM Network QoS](/develop/sla/network-qos.html) feature, which provided the same functionality for a VM network through a VM's virtual interface. This feature was planned for oVirt 3.4, but is postponed until oVirt 3.5.

### Storage

*   [Multiple Storage Domains](/develop/release-management/features/storage/multiplestoragedomains.html) enables a virtual machine to spread its disks across several storage domains within the same datacenter.
*   [Read Only Disk for Engine](/develop/release-management/features/storage/read-only-disk.html) gives Engine the read-only disk capability already found in VDSM.
*   [Single-disk Snapshot](/develop/release-management/features/storage/single-disk-snapshot.html) enables the creation of a customized snapshot, allowing the user to select from which disks to take a snapshot.

### SLA & Scheduling

*   [VM Affinity](/develop/release-management/features/sla/vm-affinity.html) makes it possible to apply Affinity and Anti-Affinity rules to VMs to manually dictate scenarios in which VMs should run together on the same, or separately on different hypervisor hosts.
*   [Power off capacity added to power policy](/develop/release-management/features/sla/hostpowermanagementpolicy.html) enables hosts to be shutdown and have the Engine clear the host to migrate all VMs elsewhere.
*   [Even VM distribution based on VM count per host](/develop/release-management/features/sla/even-vm-count-distribution.html) provides a cluster policy that evenly distributes VMs based on VM count.
*   [High Availability VM Reservation](/develop/release-management/features/sla/ha-vm-reservation.html) serves as a mechanism to ensure appropriate capacity exists within a cluster for HA VMs in the event the host they currently resides on fails unexpectedly.
*   [Self Hosted Engine Maintenance Flows](/develop/release-management/features/sla/self-hosted-engine-maintenance-flows.html) reports additional information about the hosted engine system to the engine, allowing the engine to control the hosted engine maintenance modes.

### UX Enhancements

*   [UI Refresh Synchronization](/develop/release-management/features/ux/uirefreshsynchronization.html) solves UI consistency issues related to the UI not being updated when certain actions/events happen by centralizing the refresh logic.
*   [Lower Resolution Support](/develop/release-management/features/ux/uirefreshsynchronization.html) repairs the issue of lower resolutions causing the tab bar and action menu wrap overlapping other UI elements by adding a scrollable tab bar for the tabs and a cascading menu bar for the action menu.

# Install / Upgrade from Previous Versions

oVirt 3.4 is now available for use. In order to install it on a clean system, you need to install

`     # yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm)

If you already have ovirt-release package you need to update it to 10.0.1 or newer by running

           # yum update ovirt-release

If the above command doesn't work for you, try using a distribution-specific name:

**CentOS:**

          # yum update ovirt-release-el6

**Fedora:**

          # yum update ovirt-release-fedora

*   **Note:** On CentOS and RHEL you'll need also [EPEL](http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm) repositories enabled.
*   **Note:** On CentOS and RHEL for DWH you'll need also [jpackage 6](http://mirrors.ibiblio.org/jpackage/6.0/generic/RPMS.free/jpackage-release-6-3.jpp6.noarch.rpm) repositories enabled.
*   **Note:** On Fedora 19 you'll need to enable fedora-updates repository for having updated openstack packages (was in fedora-updates-testing until Jan 23th - you might want to run 'yum clean all').
*   **Note:** On Fedora 19, you'll need to enable fedora-virt-preview repository for using Fedora 19 as node on 3.4 clusters.

Once ovirt-release is updated, you will have the ovirt-3.4-stable repository enabled by default.

If you're updating from a pre release version and you want to have rollback support, you'll need to enable ovirt-3.4-prerelease repository.

**For CentOS / RHEL:**

          [ovirt-3.4-prerelease]
          name=Latest oVirt 3.4 Pre Releases (Beta to Release Candidate)
`    baseurl=`[`http://resources.ovirt.org/releases/3.4_pre/rpm/EL/$releasever/`](http://resources.ovirt.org/releases/3.4_pre/rpm/EL/$releasever/)
          enabled=1
          skip_if_unavailable=1
          gpgcheck=0

**For Fedora:**

          [ovirt-3.4-prerelease]
          name=Latest oVirt 3.4 Pre Releases (Beta to Release Candidate)
`    baseurl=`[`http://resources.ovirt.org/releases/3.4_pre/rpm/Fedora/$releasever/`](http://resources.ovirt.org/releases/3.4_pre/rpm/Fedora/$releasever/)
          enabled=1
          skip_if_unavailable=1
          gpgcheck=0

## Fedora / CentOS / RHEL

If you're using pre-release repo you'll need to run:

          # yum update "ovirt-engine-setup*"
          # engine-setup

If you're upgrading from oVirt 3.3.2 or later you should just execute:

          # yum update ovirt-engine-setup
          # engine-setup

If you're upgrading from oVirt 3.3.0 or 3.3.1 you must first upgrade to a newer version of oVirt 3.3 (latest is 3.3.5)

If you're upgrading from oVirt 3.2, you should read [oVirt 3.2 to 3.3 upgrade](/develop/release-management/releases/3.2/to-3.3-upgrade.html).

If you're upgrading from oVirt 3.1, you should upgrade to 3.2 before upgrading to 3.4. Please read [oVirt 3.1 to 3.2 upgrade](/develop/release-management/releases/3.1/to-3.2-upgrade.html) before starting the upgrade.

**On CentOS and RHEL:** For upgrading to 3.2, you'll need 3.2 stable repository. So, the first step is to disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

          [ovirt-32]
          name=Stable builds of the oVirt 3.2 project
`    baseurl=`[`http://resources.ovirt.org/releases/3.2/rpm/EL/$releasever/`](http://resources.ovirt.org/releases/3.2/rpm/EL/$releasever/)
          enabled=1
          skip_if_unavailable=1
          gpgcheck=0

Then

          # yum update ovirt-engine-setup

should install ovirt-engine-setup-3.2.3-1.el6.noarch.rpm. If you have already updated to 3.3.x, please use distro-sync or downgrade instead of update. Then:

          # engine-upgrade

this will upgrade your system to latest 3.2. Once you've all working on 3.2, enable 3.3/stable repository, then just

          # yum update ovirt-engine-setup
          # engine-setup

will upgrade to latest 3.3.

# <span class="mw-customtoggle-0" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Known Issues

<div  id="mw-customcollapsible-0" class="mw-collapsible mw-collapsed">
*   EL >= 6.5 or cloud-init >= 0.7.2 are needed for cloud-init feature support
*   All-in-one requires fedora-virt-preview repository
*   For using Fedora 19 as node on 3.4 clusters you need to enable fedora-virt-preview repository
*   Node needs to be booted in permissive mode by appending `enforcing=0` to the kernel command line.
*   Fedora 20 does not work as an engine
*   engine-setup: upgrade from 3.3 overwrites exports with acl None
*   Hosts with Fedora 19 might not be able to discover iscsi targets due to, it's recommended to update selinux and selinux-target packages to version 3.12.1-74.19
*   Host deployment may fail on EL6 system due to a recently tuned regression. Please downgrade tuned to previous version while waiting for a new tuned package to solve this issue.

</div>
# <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
## oVirt Engine

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
 - Allow to disable SSO per VM
 - Fix Control-Alt-Delete functionality in console options
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
 - Cloud-init options persistence and unification with Windows Sysprep options
 - Have ability to modify VM template - Template Versions
 - [RHEVM-RHS] - Brick advanced details gives error
 Fixed in oVirt 3.4.0 RC

* Cannot import VM. The following disks already exist: . Please import as a clone.
 - engine [TEXT]: unclear error when trying to remove a disk from a template when the template disk has only one copy on that specific domain
 - [RHEVM][webadmin] New Data Center "Guide Me" does not reflect hosts presence
 - Direct LUN is not being updated after resizing
 - Add SNMP trap as notification method to to ovirt-engine-notification
 - [oVirt][infra] Add host/Reinstall radio button text not actionable
 - [Hosted Engine] Unify maintenance flows
 - rhev 3.3 mtu field shows the wrong ip-mtu
 - [NetworkLabels] Block labeling a bond without slaves
 - FullListVdsCommand log message appears wrong with java class ref
 - REST API: Search for an user in active directory by upn doesn't return any results (search by user name returns result)
 - Edit Approve Host popup -> Cluster not updated
 - UI: Bad vertical alignment in add user screen
 - From GuideMe link, adding Host using SSH PublicKey Authentication fails with "Error while executing action: Cannot install Host with empty password."
 - HA Vm reservation check ignores host status
 - HA Vm reservation check failure event log is not well resolved
 - webadmin: preallocated disk is reported as thinprovision in "Edit" dialogue
 - general ldap provider should be removed from manage-domains
 - upgrade from 3.3 overwrites exports with acl None
 - Incorrect error message when trying to edit network attached to Template from VM to non-VM
 - Move out downstream specific vdc_options changes into rhevm-setup-plugins
 - REST API: Create user user@domain actually creates user only
 - It's impossible to update the MTU/VLAN of the network that resides on unplugged NIC of the VM
 - Error response to DELETE request of 'Everyone' group doesn't contains 'detail' field
 - [engine] Extending a storage domain that is not attached to a datacenter fails with NullPointerException
 - utc_diff not updated according to a change in VM settings
 - [RHEVM] [Network Labels] moving host with labeled interface to Cluster 3.0 is not blocked
 - VMs do not appear in virtual machine tab if host is selected in side pane (data-center > cluster > host > )
 - webadmin: customer preview allows you to select "Active vm before the preview" which causes the disk to become illegal and vm cannot be run with "CANNOT_RUN_FROM_DISK_WITHOUT_DISK"
 - search paging on event log does not use paging correctly
 - rest api Empty int fields in POST data causes JAXB parser to fail
 - Adding permissions to any thing doesn't work
 - RHEV-M fails to detect 'AMD Opteron G5' as CPU_Type for hypervisors.
 - Listing templates takes noticeable amount of time, while listing many more VMs is prompt
 - [RHEVM] [network labels] Failed to configure vm networks on host while changing its cluster.
 - Adding a direct LUN disk doesn't work
 - [engine-backend] cannot set domain to maintenance in case there are only unplugged disks located on it
 - Missing data storage types on "Add More Storage"
 - Enable sync of LUNs after storage domain activation for FC
 - [database] plpgsql language is not created although it should
 - Event list not updating when events happen.
 - [engine-backend] Can add multiple boot disks to a vm
 - [engine-webadmin] inappropriate error message when cloning a VM from snapshot which one of its disks is located on an inactive SD
 - Cannot edit network is "setup networks" dialog
 - Cannot create a bond in 'Setup networks' dialog
 - [database] old psycopg2 does not accept unicode string as port name
 - [engine-webadmin] unclear error message when starting a VM with disk that located on a domain in maintenance
 - Cloud-init DNS settings should go inside the "iface" section
 - wrong memory usage report
 - tree based sub-tabs - missing action panel buttons
 - Default route is not set properly for management network if downstream/upstream engine and VDSM are mixed
 - RHEV 3.2 API changing IP on hypervisor bond sub-int reqs re-passing bond opts
 - Override previous export of same template fail
 - [REST] Missing domain field on VM\\Template object.
 - [REST-API] XSD schema validation error: response for create vm returned with 'type' and 'data' fields instead of with one of these fields
 - webadmin: Missing add new ISO option in data center "guide me" dialog
 - Failure to add domain via engine-manage-domains if the kerberos realm is not an uppercase of the DNS domain
 - [database] do not enable provisioning for remote database
 Fixed in oVirt 3.4.0 GA

* Tracker: oVirt 3.4 release
 - engine-setup should refuse using a non-empty remote database
 - engine: cannot change to a different cpu family after installation without removing host from cluster
 - Proper audit log handling should be added for various login failures
 - Creating a VM from a Template without NICs might create a NIC
 - RHEV 3.3 adding new host causes error logging for an attempt to remove host
 - [RHEVM] [webadmin] [network labels] cannot remove network label from interface via Setup Host Networks
 - webadmin: wipe after delete option is set by what ever domain is listed first (iscsi/nfs DC)
 - [RHEVM] [webadmin] [network labels] Setup Host Networks dialog presents network configuration incorrectly
 - Template is created with no default value for migration downtime
 - Adding new node running VDSM 4.14 will not add
 - [DWH-SETUP][TEXT] - misconfiguartion of remote DB setup
 - [webadmin] [network labels] emphasize unconfigured interface in Setup Host Networks dialog
 - [webadmin] [network labels] Same label on VLAN + bridged network + host interface blocks Setup Host Networks dialog
 - Release maven artifacts with correct version numbers
 - CPU Hotplug config value is wrong in the database creation scripts
 - Cannot import disks from glance as templates
 - [database] support postgres user length within schema version
 - Notifier doesn't send any notifications via email
 - [RFE] 3.4 product translation: translation update 1
 - VM split brain caused by network outage
 - remote database cannot be used
 - provisioning with existing database 'engine' fails
 - provisioning with existing database 'engine' logs the new password
 - /permits subcollection of SuperUser role throws NullPointerException
 - minimal snmp notifications conf section has wrong variable name
 - Schema upgrade failure on 03_05_0050_event_notification_methods.sql
 - On DB upgrade, readonly user and client custom users losses permissions to db views
 - Restapi throws ClassCastException when search by unknow value
 - Engine requires /etc/mime.types
 - support snmp notifications to multiple managers
 - RHEVM shows an event message of ETL service sampling has encountered an error
 - [ovirt][engine-api] Force switch HTTPS to HTTP in REST API

## VDSM

* VM fails to start when qemu.conf's spice_tls conflicts with vdsm.conf's ssl
 - domain monitor does not stop during disconnectStoragePool on HSM during destroyStoragePool flow on SPM
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
 - Provide before and after network setup hooks
 - Size of ISO images shown in 'Images' tab of ISO Domain wrong
 - migration_timeout not honoured, live migration goes on beyond it

## ovirt-node-plugin-vdsm

* UI: AttributeError("'module' object has no attribute 'configure_logging'",)
 - engine_page: use vdsm to detect mgmt interface
 - engine_page: display url/port only on available

## oVirt DWH

* PRD34 - [RFE] collect the "created_by" field of a VM into it's configuration history
 - [RFE] add trigger to stop etl connection via engine db value.
 - [DWH-SETUP] - remote user password is asked twice for authentication
 - Multiple daemons are not "registered" in /etc/rc[0-6].d directory hierarchy (chkconfig)

## oVirt Reports

* [RFE] ovirt-engine URI rework
 - [RFE] Create Bin Overrider for application context files changes we do in JRS
 - [REPORTS] - dashboard results an error, after reports were installed
 - [REPORTS-SETUP] - remote user password is asked twice for authentication

## oVirt Log Collector

* Collect ovirt-engine runtime configuration files
 - Do not collect .pgpass files from RHEV-M.
 - rhevm-log-collector garbles the tty when multiple hosts are gathered and ssh is called with the "-t" flag
 - [ovirt-engine-log-collector] engine-ca -> cert-file option switch, support old option name
 - log-collector accesses /api instead of /ovirt-engine/api
 - [engine-log-collector] \`engine-log-collector --help' requires root credentials

## oVirt ISO Uploader

* [ovirt-engine-iso-uploader] engine-ca -> cert-file option switch, support old option name
 - [engine-iso-uploader] /etc/ovirt-engine/isouploader.conf is world readable (can contain password!)

## oVirt Image Uploader

* [ovirt-engine-image-uploader] engine-ca -> cert-file option switch, support old option name
 - [engine-image-uploader] /etc/ovirt-engine/imageuploader.conf is world readable (can contain password!)

</div>

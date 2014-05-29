---
title: OVirt 3.5 Release Notes
category: documentation
authors: adahms, aglitke, apuimedo, danken, didi, dougsland, eedri, fromani, lveyde,
  moti, mpavlik, pkliczewski, sandrobonazzola, sradco, stirabos, yair zaslavsky, ybronhei
wiki_category: Documentation
wiki_title: OVirt 3.5 Release Notes
wiki_revision_count: 127
wiki_last_updated: 2015-01-06
---

DRAFT DRAFT DRAFT

The oVirt development team is pleased to announce oVirt 3.5.0 Alpha release availability as of May 20th 2014. oVirt is an open source alternative to VMware vSphere, and provides an excellent KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes), [oVirt 3.3.5 release notes](oVirt 3.3.5 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

# oVirt 3.5.0 ALPHA Release Notes

### ALPHA RELEASE

The oVirt Project is working on oVirt 3.5.0 Alpha release. In order to install it you've to enable oVirt 3.5 pre release repository. See below section on Install / Upgrade for having detailed instructions.

# Known Issues

*   VDSM packages released with the first 3.5.0 alpha have version lower than the ones we had in 3.4.1 so they won't be updated.
*   You can't add hosts to 3.5 clusters until a new VDSM build with 3.5 compatibility level will be released (All in One won't work).

### Feature #1

<description>

### Other Enhancements

#### Virt

#### Infra

#### Networking

##### Unified persistence

Unified persistence is a way for the oVirt defined network configurations in the hosts to be set in a format that is distribution agnostic and that closely matches the oVirt network setup API. When configuring an oVirt network on a host, it will now create a file for the network definition in:

         /var/run/vdsm/netconf/nets

and another one for the bonding definition, if the network uses a bond, in:

         /var/run/vdsm/netconf/bonds

These files are in written in the quite human readable JSON format. However, they should not be manually edited as they are automatically generated and not read on change. **Networking changes and customizations should always be performed through the API**.

When the network configuration is saved via the oVirt API, these network and bond definition files will be snapshotted to

         /var/lib/vdsm/persistence/netconf/nets
         /var/lib/vdsm/persistence/netconf/bonds

It would be possible to alter there the network definitions and when rebooting the machine having the changes applied. That, however, would mean that the host network is unsynched with the oVirt engine network definition and is strongly discouraged and unsupported.

While oVirt networking "unified persistence" has been available for a while, it was always disabled by default. With 3.5, it is made the default way of persisting networks in the hosts.

###### What does this change mean for the admin?

It means that any change done to the ifcfg files that have been created by vdsm will be ephemeral and will be lost the next time vdsmd restores its network configurations from the new file definitions (this typically happens at boot time but can be forced by doing "vdsm-tool restore-nets"). Thus, it is of utmost importance that **if you have ifcfg handmade customizations that you port those changes to be use custom network properties and write a hook to apply them**.

If you have any manually created ifcfg file that should not be deleted by vdsm network restoring you should make sure that it does not have a header like:

         # Generated by VDSM version 4.14.1-261.git4d9954e.el6

Otherwise the ifcfg file will be removed at the next network restoration event.

Finally, it is important to note that with the advent of this change, **any oVirt defined network will only be configured at boot if the vdsmd is enabled,** as vdsm is the network configuration agent for these networks. For the final release a special case will be made for the management network, so that it starts even when vdsmd is disabled. However, it is advised to handle with care vdsm disabling and restart, as **a host with vdsmd disabled and no non-vdsm networks would not have any network connectivity**.

###### What advantage does it bring?

Having unified persistence enabled means that from now on, one can switch the network configurator to iproute2 (which is still disabled by default) and enjoy the same network experience in a much faster, cross-distribution agnostic way. This is not just important for the debian/ubuntu port, but also makes porting to new distributions easier and highlights the importance of using the Hooks and Custom network properties API for your customization needs.

###### What to do if I don't want to deal with this

If the admin decides to postpone the move to unified persistence, it is possible to go back to the deprecated "ifcfg" persistence by editing /etc/vdsm/vdsm.conf and setting:

         net_persistence=ifcfg

Note that some new **features in upcoming releases may very well be unavailable for the deprecated "ifcfg" persistence mode**.

#### Storage

#### SLA & Scheduling

#### UX Enhancements

#### Hosted Engine

*   Added support for VLAN-tagged network interfaces
*   Added support for bonded network interfaces

# Install / Upgrade from previous versions

### ALPHA RELEASE

The oVirt Project is working on oVirt 3.5.0 Alpha release. In order to install it you've to enable oVirt 3.5 pre release repository.

**Please note that mirror may take a couple of days in order to be updated**

You can disable mirrors and use ovirt repository by commenting the mirrorlist line and removing comment on baseurl line in **/etc/yum.repos.d/ovirt-3.5.repo**

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

You should read then our [Quick Start Guide](Quick Start Guide)

Please note that this is still a development release, installation on a production system is not recommended.

If you're upgrading from a previous version you should have ovirt-release package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

If you're upgrading from oVirt 3.4.0 you can now remove ovirt-release package:

      # yum remove ovirt-release
      # yum update "ovirt-engine-setup*"
      # engine-setup

If you're upgrading from oVirt < 3.4.0 you must first upgrade to oVirt 3.4.1. Please see [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes) for upgrading instructions.

#### Networking

Please, see the [networking features](OVirt_3.5_Release_Notes#Networking) above for the explanation of the important networking change that 3.5 introduces for the hypervisor hosts (not for the engine ones).

On the vdsmd restart that happens when upgrading vdsm to the oVirt 3.5 release, vdsm will take a memory snapshot of the oVirt defined networks and convert them to the unified persistence format. From then on, doing vdsm-tool restore-nets or rebooting the machine will only use the new "unified persistence" definitions and any ifcfg file that was generated by vdsm will be removed by the vdsm network restoration events.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-live-el6-3.5.0-alpha.iso`](http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-live-el6-3.5.0-alpha.iso)

# <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
### oVirt Engine

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

### VDSM

### ovirt-node-plugin-vdsm

### oVirt DWH

### oVirt Reports

### oVirt Log Collector

* [engine-log-collector] problem with sos3 on rhel7 as general.all_logs no longer exist

### oVirt Hosted Engine Setup

* hosted engine deployment always try to add hosts to cluster named "default". If the cluster name is different host won't be automatically added to RHEVM.
 - If cluster=Default does not exist in hosted-engine it will fail and timeout
 - hosted-engine setup fails when using VLAN tagged interfaces
 - [RFE] Hosted Engine deploy should support VLAN-tagged interfaces
 - [RFE] [ovirt-hosted-engine-setup] add support for bonded interfaces
 - missing dependency

### oVirt Hosted Engine HA

* Time shift on host may cause ha to stop responding

</div>
<Category:Documentation> <Category:Releases>

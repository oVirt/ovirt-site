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

The oVirt development team is pleased to announce oVirt 3.5.0 Beta release availability as of Jun 30th 2014. oVirt is an open source alternative to VMware vSphere, and provides an excellent KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes), [oVirt 3.3.5 release notes](oVirt 3.3.5 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

# oVirt 3.5.0 BETA Release Notes

### BETA RELEASE

The oVirt Project is working on oVirt 3.5.0 Beta release. To install this release, you must enable the oVirt 3.5 pre-release repository. See the below section on Install / Upgrade for detailed instructions.

### Known Issues

*   If you are using a Fedora 19 host, you require libvirt >= 1.0.1 to use cluster level 3.5.
*   (pkg will be provided from ovirt repo, but if it not there, you can update from a Fedora 20 repo: : yum update --releasever=20 libvirt\\\* )
*   If you cannot refresh an ISO file list after adding a host, see <https://bugzilla.redhat.com/show_bug.cgi?id=1114499> for a workaround.
*   Upgrading from 3.5 alpha can fail due to the structure of a table being different in 3.5 alpha to that in 3.5 beta1 and later (https://bugzilla.redhat.com/1114967).
*   Users that use DWH and Reports from 3.5 firts beta will need to run # yum distro-sync "ovirt-engine-dwh\*" "ovirt-engine-reports\*" due to bad rpm release number for DWH and reports packages.

### Feature #1

<description>

### Other Enhancements

#### Virt

#### Infra

##### Extensions manager and mechanism

An API for providing engine extensions for the following:

      * AAA
      * Log

Was introduced in oVirt 3.5. To develop an extension, you must use the classes and interfaces defined via the ovirt-engine-extensions-API and pack the extension as a jboss module.

##### AAA refactor

The engine was refactored to use the API mentioned above - the existing implmenetations were packed as "built-in" jboss modules. A speration between authorization and authentication was introrduced at the code. The session management mechanism at engine was changed to rely on engine session Id. In addition, the authentication flows for the web applications (REST-API and GUI) were refactored using a set of servlet filters that can be reused for various web applications.

##### Jsonrpc

Jsonrpc over stomp was added to communication layer between the engine and vdsm. New protocol is design to be simple, do not require as much parsing as already implemented xmlrpc and it introduces asynchronous communication. Vdsm binds to single port and is able to detect which protocol is used when a connection is established and delegate connection handling to proper jsonrpc or xmlrpc layer.

##### Advanced Foreman Integration

Integrating Foreman with oVirt provides the ability to add hypervisor hosts that are managed by Foreman to oVirt engine (installed hosts and discovered hosts). The feature includes UI changes to provide list of discovered host on the addHost popup view, with hardware information, host groups and compute resources info. On foreman side ovirt supplies new foreman plugin (https://github.com/theforeman/ovirt_provision_plugin) which automatically perform the deploy process after host is being provisioned. For more information please refer to <http://www.ovirt.org/Features/AdvancedForemanIntegration>.

#### Generic LDAP provider

The generic ldap provider is based on the extensions API as described above. The provider uses configuration files that provided the required information for authentication and authorization , including ldap vendor specific information , in case of authorization provider based on LDAP. The configuration files can be found at : /etc/ovirt-engine/extensions.d

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

##### Neutron Virtual Appliance

A Neutron Virtual Appliance will be available from the oVirt Image Repository (glance.ovirt.org). For 3.5 the appliance is based on OpenStack IceHouse, listed as ""Neutron Appliance (CentOS X.X) - IceHouse-YYYY.X-XX" on the provided images list.
The appliance reduces the need of a user to provide an installed and pre-configured keystone and neutron servers. Instead, the user can use the provided one, which is already configured with ml2 as the core plugin, openvSwitch as the mechanism driver and vlans.

#### Storage

#### SLA & Scheduling

#### UX Enhancements

#### Hosted Engine

*   Added support for VLAN-tagged network interfaces
*   Added support for bonded network interfaces

# Install / Upgrade from previous versions

### BETA RELEASE

The oVirt Project is working on oVirt 3.5.0 Beta release. In order to install it you've to enable oVirt 3.5 pre release repository.

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

### oVirt Node

a fresh oVirt Node build is also available now:

`# `[`http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-node-iso-3.5.0.ovirt35.20140630.el6.iso`](http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-node-iso-3.5.0.ovirt35.20140630.el6.iso)

*   To circumvent some SELinux issues, please append enforcing=0 to the kernel commandline when booting the ISO.
*   The ISO is missing the plugin for Hosted Engine, but we hope to deliver an iso which includes this plugin shortly.

### oVirt Live

A new oVirt Live ISO is available: (no update since the alpha, might be released seperatelly)

[`http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-live-el6-3.5.0-alpha2.iso`](http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-live-el6-3.5.0-alpha2.iso)

### oVirt Windows Guest Tools

First beta release of oVirt 3.5 WGT is available:

`  `[`http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-guest-tools/ovirt-guest-tools-3.5_5.iso`](http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-guest-tools/ovirt-guest-tools-3.5_5.iso)

It currently includes the installer for all VirtIO-Win drivers (Serial, Balloon, Net, Block and SCSI), Spice QXL and Agent as well as oVirt Guest Agent, as well as the binaries that went into the installer. Support for Windows Server 2012 and 2012 R2 was added. Note that if you have a previously installed version of oVirt WGT then you need to uninstall it, before installing this version.

The installer itself maybe downloaded from:

`  `[`http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-guest-tools/ovirt-guest-tools-3.5_5.exe`](http://resources.ovirt.org/pub/ovirt-3.5-pre/iso/ovirt-guest-tools/ovirt-guest-tools-3.5_5.exe)

More information can be found in the [oVirt Windows Guest Tools](Features/oVirt_Windows_Guest_Tools) feature page.

# <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
### oVirt Engine

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
 - [REST API]: Missing VM statistics field.
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

### VDSM

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

### ovirt-node-plugin-vdsm

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

### oVirt DWH

### oVirt Reports

### oVirt Image Uploader

* option insecure doesn't work

### oVirt ISO Uploader

fixed in beta

* option nossl does not work
 fixed in alpha

* option insecure doesn't work

### oVirt Log Collector

fixed in beta

* engine-log-collector help default logfile path does not make sense
 - missing sosreport.html from postgresql-report-admin
 fixed in alpha

* [engine-log-collector] problem with sos3 on rhel7 as general.all_logs no longer exist
 - "rhsc-log-collector" takes too long even to prompt for the REST API password before it actually start collecting information from selected servers

### oVirt Hosted Engine Setup

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

### oVirt Hosted Engine HA

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
<Category:Documentation> <Category:Releases>

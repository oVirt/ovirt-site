---
title: oVirt 3.6 Release Notes
category: documentation
toc: true
authors: arik, didi, fromani, ibarkan, mperina, mskrivan, rmohr, sandrobonazzola,
  stirabos, tsaban
---

# oVirt 3.6.0 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.0 Release as of November 4th, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Fedora 22, Red Hat Enterprise Linux 6.7, CentOS Linux 6.7, (or similar) and Red Hat Enterprise Linux 7.1, CentOS Linux 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/). 

## Experimental Docker Integration

oVirt Engine setup now provides experimental [Cinder and Glance](/develop/release-management/features/cinderglance-docker-integration/) automated deployment using Docker

Cinder and Glance images are from kollaglue project. <https://github.com/openstack/kolla> kollaglue is 'the official' effort from openstack project to provide production-ready containers and deployment tools for operating OpenStack clouds. The kollaglue Docker images are built by the Kolla project maintainers. On oVirt side we have an optional plugin for oVirt engine-setup to pull and deploy their ready to use containers (glance and cinder only) and automatically adding them into your oVirt engine isntance.

Recently the cinder container setup for oVirt got broken cause they introduced the use of Ansible's playbooks to customize and complete the container setup and unfortunately we are still not ready for that. You should be able to manually setup cinder with that containers following this guides: <https://github.com/openstack/kolla/blob/master/doc/ansible-deployment.rst> <https://github.com/openstack/kolla/blob/master/doc/cinder-guide.rst>

Glance container setup and its oVirt integration are still working.

Kolla images will not run on Fedora 22 or later currently. Fedora 22 compresses kernel modules with the .xz compressed format. The guestfs system in the CentOS family of containers cannot read these images because a dependent package supermin in CentOS needs to be updated to add .xz compressed format support.

## Self Hosted Engine FC Support

Hosted Engine has now added support for [FC storage](/develop/release-management/features/engine/self-hosted-engine-fc-support/)

## Self Hosted Engine Gluster Support

*   Hosted Engine has now added support for [Gluster storage](/develop/release-management/features/engine/self-hosted-engine-gluster-support/)

## oVirt Live

oVirt Live has been rebased on CentOS 7 allowing to run oVirt in 3.6 compatibility mode

## Experimental Debian Support for Hosts

Experimental support for running oVirt Hosts on Debian (or similar) has been added providing custom packaging of needed dependencies.

## Fedora 22 Support

Support for running oVirt on Fedora 22 (or similar) has been added providing custom packaging of Wildfly 8.2.0.

## VirtIO Serial Console

Users can now directly connect, using ssh, to the [serial consoles](/develop/release-management/features/engine/serial-console/) of the VMs.

## Affinity Rules Enforcement Manager

This feature is a manager that checks if hard affinity rules are broken and migrates VMs in order to enforce them.
Behavior of the manager:

1.  Manager only starts migrations when no other migrations are active in the cluster.
2.  Manager uses scheduler's automatic migration command to comply with filter and weight policies.
3.  Manager has a new and improved algorithm for finding affinity rule contradictions called "Unified Affinity Group Algorithm".
4.  Manager will enforce affinity rules one by one, starting with the violated affinity rule which consists of most VMs.
5.  Manager's strategy to enforce affinity rules in case of positive groups is to migrate VMs from the hypervisor that has the minimum number of VMs from the same affinity group to the one that has the most VMs(Taking into account the Scheduler policies. Sometimes VMs might be migrated to a different host if the scheduler thinks it's better).
6.  Affinity rules only work for clusters with version >= 3.5.

## Cluster parameters override

[Cluster parameters override](/develop/release-management/features/engine/cluster-parameters-override/) feature allows to configure the 'emulated machine' and 'cpu model' parameters for each VM separately instead of relying on the cluster default.

## Other features

For a detailed description of the above features and a complete list of the features included in this release please see [oVirt 3.6 features list](/Category:OVirt_3.6_Feature)

Please note that All-In-One setup is now deprecated in 3.6 and will be dropped in 4.0. You're strongly encouraged to use Hosted Engine setup instead of All-In-One.

## Known Issues

*   If engine-setup is stuck when starting ovirt-websocket-proxy manually stop the service and re-start it when engine-setup finishes.

<!-- -->

*   If cluster is updated to compatibility version 3.6 while hosts that have not been upgraded, i.e with emulated machine flags that do not match cluster compatibility version 3.6, you might end up with incorrect emulated machine flag on the cluster. As a result, you will not be able to run VMs. Possible workarounds would be to to reset the emulated machine on the cluster (requires putting all the hosts into maintenance) or disable the host-plug memory feature in the database.

<!-- -->

*   Host network QoS will not work for vlan tagged traffic. The QoS definitions can be set on the hypervisors, but actual tagged traffic will not be classified correctly hence not shaped. Host network QoS will work correctly on untagged networks. This is already fixed in <http://gerrit.ovirt.org/#/q/I667a9f38f4314da309685f6ba247f705a2e9c23e> and merged to 3.6.1.

<!-- -->

*   SRIOV support API is broken and was re-written in a backward incompatible way in 3.6.1. This bug causes the vm with the attached virtual function to be reported with a disconnected NIC each time it is powered off. We advise people that use this feature to take their VMs down before upgrading to 3.6.1 (or restart vdsm for that matter) or they will lose virtual functions on their hosts. Commits <https://gerrit.ovirt.org/#/q/I689629380996e5615f41e5705fa1f8fb322e0214> and <https://gerrit.ovirt.org/#/q/I9d26df0f850d395c6ef359d9e4c404856e2f649d> (ovirt-engine) fix this.

## Distribution specific issues

### Fedora 22

*   on hosts you need to add following line to **/etc/ssh/sshd_config**

      KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1

and then execute

      # systemctl restart sshd

before adding the host to the engine.

### RHEL 7.1 - CentOS 7.1 and similar

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

*   v2v feature on EL 7.1 requires manual installation of virt-v2v packages. See for more details. This workaround will not be needed once EL 7.2 is out

### RHEL 6.7 - CentOS 6.7 and similar

*   Upgrade of All-in-One on EL6 is not supported in 3.6. VDSM and the packages requiring it are not built anymore for EL6

# Install / Upgrade from previous versions

## Fedora / CentOS / RHEL

In order to install it on a clean system, you need to run (see also [Known Issues](#Known_Issues) above):

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6 repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.5 Release Notes](/develop/release-management/releases/3.5.5/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

## Upgrade path from Fedora 20 oVirt 3.5 to Fedora 22 oVirt 3.6

Please refer to the following threads on users mailing list:

*   [Upgrade path from Fedora 20 oVirt 3.5 to Fedora 22 oVirt 3.6 - Suggested procedure](https://lists.ovirt.org/pipermail/users/2015-November/035791.html)
*   [Upgrade path from Fedora 20 oVirt 3.5 to Fedora 22 oVirt 3.6 - User experience](https://lists.ovirt.org/pipermail/users/2015-November/035882.html)

## Debian Jessie

The support for Debian Jessie is highly experimental and implemented as a best effort feature. In order to enable Debian Jessie repositories you need to manually edit **/etc/apt/sources.list** adding:

      # vdsm
      deb `[`http://resources.ovirt.org/pub/ovirt-3.6/debian/`](http://resources.ovirt.org/pub/ovirt-3.6/debian/)` binary/
      deb-src `[`http://resources.ovirt.org/pub/ovirt-3.6/debian/`](http://resources.ovirt.org/pub/ovirt-3.6/debian/)` source/

## oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide.

## oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

## oVirt Node

oVirt Node is now released continuously, the download link can be found in the [oVirt Node Release](/develop/projects/node/node/#release) section

# <span class="mw-customtoggle-1" style="font-size:small; display:inline-block; float:right;"><span class="mw-customtoggletext">[Click to Show/Hide]</span></span>Bugs Fixed

<div  id="mw-customcollapsible-1" class="mw-collapsible mw-collapsed">
## oVirt Engine

**oVirt 3.6.0 GA**
 - Failed to import vm template

**oVirt 3.6.0 Third Release Candidate**
 - If a single NFS domain is activated with an invalid custom mount option then it gets stuck in an Inactive state.
 - job monitoring don't work as expected
 - Future interface of java.util.concurrent get stuck and prevent cinder operations
 - [webadmin] Not able to configure local storage on host
 - engine can't log in to satellite

**oVirt 3.6.0 Second Release Candidate**
 - [SCALE] Adding direct lun to a VM times out
 - [vdsm] SpmStart fails after "offline" upgrade of DC with V1 master domain to 3.5
 - Move all 3.6 and above host communication to jsonrpc
 - [RFE] EL 7.2 emulated machine level
 - Failed to enable HA option on vm, that pinned to multiple hosts
 - removing VM pool job doesn't end
 - Incorrect selection of vm for migration by CpuAndMemory balance module
 - [UX] Toggling wad property while vm is up shouldn't be greyed out
 - Storage pool version/domains format isn't reverted although no dc upgrade occurred
 - not possible to edit blank template using REST API
 - Creating a VM with Foreman fails if cluster has more than one CPU profile
 - ovirt-engine-wildfly should be added to version locking
 - Can't create a template with Cinder disks
 - Icons related validation not strict enough
 - Console.vv no proxy reference with "Enable SPICE Proxy"
 - rhevm-backend contains jar files that shouldn't be there
 - engine-setup hangs indefinitely starting ovirt-websocket-proxy via service using python subprocess module
 - Missing requirement on otopi >= 1.4.0
 - Psql exceptions while performing multiple operations with Cinder provider cause engine timeouts
 - Failed to import VM / VM Template
 - [F22] engine-setup doesn't configure version locking for the new dnf packager provided by OTOPI
 - [UX] [Cinder] Volume residents of datacenter 'A' should not be offered to to VM's located in cluster of Datacenter 'B'

**oVirt 3.6.0 Release Candidate**
 - Update network fails if sends twice too quickly
 - [events] odd 'Done' in the end of event msg - Power Management test failed for Host $host.Done
 - Can not assign tag to an entity from UI
 - [hosted-engine] Storage pool UUID is modified when importing the HE storage domain to the setup. Hence, the HE VM dies
 - Enable non-admin users to list icons over REST
 - [User Portal] [IE11] Can't save Edit VM dialog, click jumps to 'Icon' section - Icon file is not parsable
 - Validation error when adding nic to vm: NETWORK_MAC_ADDRESS_IN_USE

**oVirt 3.6.0 Seventh Beta**
 - Missing hints for the new affinity group dialog
 - [BUG]ovirt packaged websockify produces zombies (patch available)
 - Improve ovirt-websocket-proxy debbuging logs
 - Custom Properties lists Not-Configured instead of Not Configured for a Virtual Machine
 - Remove Cluster host has text issues and inconsistent usage of trailing period
 - Virtual Machines tab Snapshots sub-tab lists Ok for Status and then OK for the Snapshots Disk sub-tab
 - [Text] The Export Virtual Machine dialog error message when no Export domain is present is a bit confusing due to the incorrect usage of Virtual Machine(s) instead of Virtual Machine’s
 - MAC pool range per DC > Combine MAC pool range that includes Unicast and Multicast MAC's is blocked
 - [Admin Portal] Upgrade/Install Host dialog too narrow, can't fully display current version
 - [events] VM_MIGRATION_FAILED(Migration failed) event not caugh, impacted by VM_MIGRATION_FAILED_NO_VDS_TO_RUN_ON?
 - MAC Address is already in use error when trying to create new vNIC with custom MAC address, manually assigned in DC with 'allow duplication'
 - DatacenterAdmin role on system can't add new DC (missing CONFIGURE_MAC_POOL action group)
 - Wrong error is thrown when calling 'images' attribute from a data domain
 - Unstable unittest in engine
 - [ovirt][webadmin] Wrong alignment, missing fields, incosistent tabs
 - [New HostSetupNetworksCommand] Marking ipConfiguration and overridden QoS as out-of-sync
 - [New HostSetupNetworks] Remove custom_properties from vds_interface table and VdsNetworkInterface entity
 - [userportal] Unable to add new nic to vm
 - Sorting is not working under [Hosts] main tab for all the columns in this tab
 - AREM should enforce affinity groups from the largest to the smallest
 - engine-config&WebUI show different info for MAC pool range
 - [Clusters] > 'Manage Networks' > 'required all' and 'assigned all' checkboxes completely stopped working (in both of the dialogs)
 - Two instances of UpdateStorageDomainCommand/ExtendSANStorageDomainCommand executed concurrently
 - Migration issues Importing Storage Domain no more VM
 - Failed to update template name, when exists vms that was created from this template
 - Typo found during translation "The VM ${VmName} has sanpshots that must be collapsed."
 - [ppc64le] VM startup takes too long when hot-plug memory feature is enabled
 - RuntimeException: Failed managing transaction - occurs when refreshing host capabilities and powering off VM.
 - [AAA] ovirt-engine-role.sh fixups
 - engine db infrastructure doesn't work properly with other schemas
 - Can't detach a non master local data domain
 - floating disk dialog: Cinder - DataCenter select-box is disabled on error
 - 'Required' and 'Attach'checkboxes for specific cluster not working
 - [events] There is no separate VDS_LOW_MEM event for subscription
 - Incorrect message when trying to remove nonexistent network from a host

**oVirt 3.6.0 Sixth Beta**
 - All options “Create Snapshot“ during run VM in Stateless mode, should be grayed out
 - User portal error message when changing VM cluster inconsistent with webadmin
 - [RFE] Require network interfaces with non-VM roles to have IP configuration (Static or DHCP boot protocols)
 - Successful migration of powering-up VM does not end well
 - Don't allow remove glance provider when there are running tasks on it
 - REST API :Trying to delete Default MAC pool you get an incorrect error message
 - [text] engine setup should specify full service name for dwhd
 - [RFE] New host network API:No default BOND mode for create BOND via REST
 - Network labels| Attach operation fail for new network with label
 - REST API: missing support for ssh keys handling
 - oVirt 3.6 using Cinder as external store does not remove cloned disk image - ceph backend
 - Missing buttons and power management on host edit after saving host with wrong power management
 - PowerSaving balancing not take in account CPU under utilized hosts
 - VmsMonitoring vm not in changed list, skipping devices update.
 - [REST-API] Moving cinder disks should be blocked by caDoAction=false
 - [AAA] engine-setup don't update package 'ovirt-engine-extension-aaa-jdbc'
 - NPE on Edit pool dialog
 - VM display type changed on import to 3.6 from older version
 - Cluster cpu type can't be edited
 - oVirt 3.6: translation cycle 4 tracker
 - Unable to change cluster version in empty cluster

**oVirt 3.6.0 Fifth Beta**
 - [ja_JP][RHEVM-Admin] - Untranslated strings found and some rectified already
 - NPE when moving a LUN disk in REST API
 - FreeSpaceCriticalLowInGB variable causes unclear behavior when running a vm with disks on insufficient space domain
 - [Tracker] Exporting, moving and copying LUN disks and VM's LUN disks fail in the REST API
 - Internal Server Error (500) when exporting a VM LUN disk in the REST API
 - Internal Server Error (500) when moving a VM LUN disk in the REST API
 - Internal Server Error (500) when exporting a LUN disk in the REST API
 - Internal Server Error (500) when moving a LUN disk in the REST API
 - Internal Server Error (500) when copying a LUN disk in the REST API
 - Misleading audit log warning when host fails to move to maintenance
 - [ux] instance type icon misalignment
 - [engine-webadmin] Automatic resume guest from paused is not reported in event logs
 - [RFE] Allow to synchronize only out-of-sync networks on an host
 - When exporting more then one disk to glance, all disks stay in locked state except one
 - No scrollbar for host numa nodes under "NUMA Topology" window
 - Incorrect number of CPU under "NUMA topology" window
 - Engine should block run of vm with network-used host devices.
 - [admin portal] cannot open console when VM is started RunOnce-Paused mode
 - [RHEVM] : Not able to create new VM fails with error message "General command validation failure".
 - Tasks drawer doesn't display jobs/step tree correctly
 - Wrong DC/Cluster is show in "New host" dialog
 - Host PM failure message is not descriptive enough
 - [UX] No 'disk format options' should be displayed on New Template dialogue in case of ceph disks
 - [API] restore snapshot via API results in snapshot being stuck on "In preview" status
 - Remove support of POWER8E CPU type
 - REST API : Operation of exporting template to Export domain stucks
 - VM status events are ignored after host is rebooted
 - [de_DE][fr_FR][Admin Portal] Alignment needs to be corrected on 'virtual machines->new->host page
 - [PPC64LE] Failed to add ppc host to engine
 - Not possible to add sub step of step via REST
 - Automatic fencing doesn't work when network is killed on host
 - [engine] CA cert about to expire is detected as already expired
 - [dbscripts] 'CertificationValidityCheckTimeInHours' missing in dbscripts / vdc_options
 - [engine] already expired engine cert is detected as about to expire
 - [engine] already expired CA cert is detected as about to expire
 - [LOG] redundant invocation of RemoveAllVmCinderDisksCommand
 - Failed to delete watchdog device from template via REST api
 - [engine] host cert about to expire is detected as already expired
 - Encoding issue in 'title' field in .vv file
 - Encrypted database fields should allow spaces
 - VmPool error always return "No available VMs in the VM-Pool"
 - engine-cleanup fails due to error 'must be owner of ...'
 - no way to create a VM in userportal

**oVirt 3.6.0 Fourth Beta**
 - Menu bar missing one selection from VM context menu.
 - VMs with 3 IDE disks cannot run
 - Grammar - console connection denied: 'to not' -> 'not to'
 - Unable to upgrade RHEVH - Host slot-6 installation failed. SSH session timeout host 'root@host-ip'.
 - [RFE] Improving the host networking API
 - Error message received (when for example a VM cannot be powered due to missing CD) has formatting issue
 - Inconsistent terminology used for Run Once in VM power on error dialog
 - pool VM - fields which are not editable are presented inconsistently
 - [ux] serial number policy inconsistency
 - On datacenter with compatibility version less than 3.5 attaching and detaching from one dc to another in the same setup can cause vm states loss (depending on timing of the detach)
 - [HC] - Do not allow adding GlusterFS storage domain, if hosts of the selected dc, do not report they have the GlusterFS packages.
 - Host Qos > Edit network dialog(pencil) on SN report QoS parameters, while vdsCaps on host doesn't
 - wrong VM type tool-tip for Desktop pooled-VMs
 - Inconsistent behavior of blank and custom templates when there is no enough MAC addresses left in MAC Address Pool and misleading error message
 - [rhevm UI glance] Cannot resize columns in import disk dialogue from glance
 - [TEXT] - Management Network shouldn't be displayed in Description of the Network if it is not attached to Cluster
 - virtio-rng required sources change should pre-check hosts in a cluster
 - [API] Incorrect error message when creating of new Cluster fails and ovirtmgmt is missing
 - [webadmin] resize values of general subtab of Users tab
 - Cel tables widgets checkbox cloumns header are missing and not working
 - [UX] "LUN ID" check box is not working
 - Remove vm button is disabled in vms context menu if multiple vms selected
 - Reboot button is disabled in vm context menu if multiple vms selected
 - Some minor grammatical errors found during translation
 - text too large ("Random Number" heading) in New Cluster dialog
 - [RFE] allow for the use of one untagged/native VLAN for VM network on a VLAN trunk
 - Wrong error message when trying to remove a template's disks without specifying its storage domain.
 - Vm becomes unusable (NPE) when restarting vdsm during snapshot creation
 - Return proper error when Clone vm from snapshot isn't passed a snapshot id.
 - ConnectStorageServer should be called for Fiber Channel Storage domain
 - MTU of VM network should be equal to the MTU of the other networks on the nic
 - "this filed can't be empty" message when creating VM with name already in use in template
 - Pool edit dialog can't be loaded when storage domain is not active
 - fix date-time rendering to use a pre-defined format that will fit all locales
 - [ko_KR] [Admin portal] Text alignment needs to be corrected on 'New Cluster' -> 'Fencing Policy'
 - Run Once->Initial Run->Cloud-Init Authentication password field should not have hover text 'choose a root password for the guest'
 - cloud-init network interface alias not allowed
 - [REST API] Update vm affinity to 'vm_affinity_migratable' failed since host tag is empty
 - New Host Network API is missing QOS support
 - VM lose custom icon when it is edited in running state
 - VM stuck in wait for launch after update vm IO Threads value
 - [engine-setup][docker] engine configuration fails on missing rabbit-mq image
 - corrupted HBA info layout on hosts-general-hardware view
 - Can't make a template from a non active snapshot while the vm is up
 - commented-out key/value lines in messages.properties are being wrongfully read as the comment for the key/value beneath them
 - For New Data Center dialog need to "jump" to first section with validation error upon click on "OK"
 - The management radio button should be disabled for non-required networks.
 - Try to import VMs from v2v will show an unrelated message of "Not available when no Export Domain is active"
 - New VM/Pool -> System -> Memory Size not framed red when not filled
 - After engine setup ovirt-vmconsole-proxy-sshd service was not up
 - Network main tab -> General sub-tab: the "Id" value text is overlapping with the VLAN tag field
 - FE NPE when Edit Pool dialog opened
 - [host-update-manager] operation failed - we do support more states than maintenance for update
 - Add host fail with error: certification is invalid. The certification has no peer certificates
 - 3.5 rhevh adding to 3.5 clstr on 3.6 engine fails - KeyError: 'getpwnam(): name not found: ovirt-vmconsole'
 - vdsm failed to start vm
 - engine-setup fails at second run
 - GUI fails adding VM with NUMA node
 - Nested New Virtual Disk dialog causes FE IndexOutOfBoundsE
 - Remove of Cinder provider will cause VMs which have Cinder disks to be deleted.
 - [ko_KR][fr_FR][ja_JP][es_ES][Admin portal] - Misalignment issue found under New Cluster -> Fencing Policy.
 - [Admin portal] - Minimal button overlapping issue found under Data Centers --> New Host tab
 - [de_DE] [Admin portal] Text overlap issue observed on configure->roles->new page.
 - Guide Me dialogs are titled "New XXX - Guide Me"; the "New" is unnecessary and may be incorrect.
 - Error 500 and NPE when trying to import certificates of HTTP provider
 - Get provider certificates to import from user instead of from backend
 - [extmgr] load extension properties as unicode
 - [Templates] > Can't create new VMs from templates via the Templates main tab
 - Engine throws an Error every time when "edit domain" dialogue of a Block domain opens
 - Password field for CHAP Authentication displays as clear text
 - [engine-webadmin] Image UUID is cropped under 'Disks' tab
 - FE NPE in Extended UserPortal > Templates
 - [Per host CHAP] Modifying CHAP credentials fails with "Could not find resource for relative"
 - [AAA] Incorrect AuthRecord.VALID_TO parsing
 - Message 'Creating/refreshing Engine AAA database schema' is confusing
 - [PKI] do not prompt for passphrase for openssh certificate enrollment - ever
 - Updating the list of pinned hosts for a VM via REST does not work

**oVirt 3.6.0 Third Beta**
 - Can't import/clone a snapshot-less VM from export domain without unnecessarily setting copy-collapse to true via REST.
 - If Quotas are enabled, even in Audit mode, active VMs' disks cannot be edited
 - several async tasks are not cleared altough they are over and finished in vdsm
 - [RFE] Import V2V Virtual Machine using the Graphical interface (GUI)
 - vmconsole_proxy_helper/pki.py: PluginLoadException: No module named engine
 - Windows console type is reset to "Remote desktop" after each shutdown
 - A grammatical error found during translation: The fields is attached to the currently selected instance type
 - VFIO/hostdev_passthrough: Incorrect error message displayed when attaching host device to running VM.
 - Can't create a VM in a local DC
 - Cannot run simultaneously multiple VM's that use host devices of one host.
 - Can't create disk within cinder volume provider
 - internal error when deleting watchdog device from REST api
 - HostDeviceManager allocates devices on unrelated hosts
 - VM --> Provisoning Operations --> Create permit required for live migrations in 3.5
 - Edit host: Can't update host without unavailable options "Host Groups" and "Compute Resources".
 - Live storage migration is broken
 - balloon enabled at cluster level cause NPE in VMs monitoring
 - ovirt-engine-cli isn't automatically updated when ovirt-engine is updated
 - [host-deploy] when updating multiple packages only the latest is considered in cache timestamp
 - Warn user that legacy kerbldap provider will be removed
 - Hosts tab throws exception when re-entered
 - A possible typo (double negative)"Value doesn't not match pattern"
 - [RFE] Add option to open jmx to world
 - scrolls are not working in the dialogs
 - Wrong cardinality of host.storage_domain_extensions, unbounded instead of 1
 - Support fc22/fc23 locale

**oVirt 3.6.0 Second Beta**
 - [RFE] Need the ability to dynamically resize data domain luns
 - [TEXT][engine-backend] Wrong CDA message when taking storage domain down to maintenance if it contains a vm disk which is not turned off
 - Engine never completes task VdsNotRespondingTreatmentCommand (Handling non responsive Host <hostName>) in case of SPM host reboot
 - REST Storage class is not returning type='fcp', in case of querying -> api.hosts.storage.get('SOME_FC_STORAGE').get_type()
 - [RFE] Showing host ERRATA information from Satellite/Foreman/VMs (UI)
 - [CodeChange] Redundant storage calls and host parameter when extending a storage domain via the REST API
 - [engine-webadmin] 'Direct LUN' and 'Cinder' tags are not grayed-out when editing an image disk
 - [RFE][oVirt] Support per-host iSCSI CHAP username/password
 - Attaching direct LUN via FC results in size -1 and most parameters greyed out when viewed in the UI
 - [ko_KR] [ALL_LANG] [Admin/User Portal]Unlocalized strings in New or Edit Virtual Machine->System tab.
 - [webadmin] New VM/VMPool menus do not open after the last used cluster is empty
 - [Pools] - Failing to create New VM's Pools via UI based on vm template
 - specifying OVESETUP_CONFIG/vmconsoleProxyConfig in answer file cause engine-setup to fail
 - oVirt 3.6: translation cycle 3 tracker

**oVirt 3.6.0 First Beta**
 - pool VM - fields should not be editable
 - [engine-backend] Wrong space validation when moving a disk
 - Redundant Storage allocation check when running VM as stateless
 - [Admin Portal] Version|Family is always empty in hosts' Hardware Information
 - Cluster without DC, displays all other networks from all clusters under Cluster>'Manage Networks' window
 - In RHEV Manager, viewing Templates then virtual machines doesn't show virtual machine name field
 - Ovirt should update current_scheduler file, once gluster shared storage is disabled and enabled (meta volume deleted and created back again)
 - VM "Memory Balloon Device Enabled" can be changed in the UI while the VM is on, but has no effect
 - Edit dialogs for Instance Type and Template are filled with default values instead of current ones for "USB Support", "Smartcard enabled" and "Monitors"
 - userportal doesn't fill value for jsessionid key in [ovirt] section of vv file
 - VM appears as external although engine reports vm removed
 - Upgrade of oVirt 3.5 to 3.6-master fails
 - New SD: local option is missing for Export domain in a local DC.
 - Impossible to add affinity group via REST
 - failed DI causes NPE, due to VdcCommands invoked without ResourceManager
 - Can't update storage domain via REST API in case that the storage domain's 'containsUnregisteredEntities' property is true

**oVirt 3.6.0 Third Alpha**
 - DC/Cluster "Guide Me" -> Select Host: please add a check-box to the column title (for check/uncheck all)
 - vmpool from template from server type, creates VMs with desktop icon
 - Excess message about shutting down the host under power saving policy
 - Show/Hide Advanced Options button in Edit/New VM/Template changes size
 - taskcleaner.sh requires postgres user permissions to remove zombie tasks
 - [RFE] VM-Affinity should allow to create a policy to run the VMs between two hosts only.
 - If host is not accessible by its dns name, misleading error is dispalayed
 - Pass REST session expiration time to the engine
 - [Pools] > New pool > double clicking on 'ok' will create the same pool twice with wrong calculation of vm's in pool
 - VM detach from Vmpool should be blocked in case VM has not yet finished to be created.
 - Windows-based VM : Time Zone field is missing from VM GUI/General sub-tab
 - [RFE] [3.6.1] add possibility to sign websocket proxy ticket
 - [engine-webadmin] [external-provider] "internal engine error" for TestProviderConnectivity when the user doesn't have the right permissions
 - Moving host provider fields validation to canDoAction with validator object
 - 'Guest Agent Data' under 'Network Interfaces' doesn't shows any data
 - VM display type in REST API doesn't have 1:1 match with GUI
 - [Rest-Api][ImportDomain] Importing domain doesn't clear storage connections in case of a import failure
 - UX: addHost form leaves json checkbox locked when switching between clusters
 - Active users query returns 'bad sql grammer' error
 - Extending disk size appears when a new disk is created
 - [oVirt][provider] inadequate test failure output
 - Dismissing alerts from context sometimes dismisses other alert
 - [engine-backend] Engine ignores image creation when creating a VM from templates list
 - No dialog window for make template from snapshot in userportal
 - REST API for host device passthrough
 - Windows 10 Guest OS Support - UI
 - GMT + CEST time zone listed multiple times in VM timezones
 - VM cannot start after adding a virtio-rng random number device (oVirt 3.5.3)
 - Storage should allow at least 256 character long usernames and passwords
 - No dialog or reaction on disk subtab buttons in userportal extendedview
 - The "isattached" action doesn't return an action object
 - Please make the format of allowable characters in error messages ("a-z0-9A-Z" or "-_") more clear
 - Source VM is deleted after failed cloning attempt
 - [host-update-manager] Host available packages list leaks defined packages dependencies
 - adding new host caused an error "VDSM '..' command failed: Policy reset"
 - After the task is completed, it is still visible as running in Tasks in webadmin
 - [search] PSQLException: ERROR: invalid input syntax for type boolean: "foobar"
 - Creating a new VM with invalid Name errors and exits the form
 - [webadmin] power management is broken
 - RSDL incorrectly documents storageconnection parameter set for iscsi (parameter is target not iqn)
 - Engine: Live merge fails after a disk containing a snapshot has been extended
 - Cluster dialog > Optimizer tab > properties select box is too small
 - Guide-me dialog box - New cluster - Checkbox is not aligned with text
 - oVirt - New Host - Overlapping string
 - Log out/sign out from ovirt engine webadmin ends up with Internal error server
 - VM is down although migration succeeded
 - Add storage domain via REST-API fails with the message "null is not a member of StorageFormat" when sending the <format> parameter
 - [Admin Portal] broken search in UI
 - hostname should not be in single quotes for 'Host has available updates' event
 - Upgrade from 3.5.2 to 3.5.3 experiencing database execution error
 - Stateless VM snapshot gets deleted when user shuts down VM in a Manual Pool type
 - Make live snapshot consistent for Cinder disks
 - no way to set the instance type
 - Engine database in not cleared when user selects to remove all
 - rhev rest api: DELETE /ovirt-engine/api/templates/<UUID> deletes Instance type of the same UUID
 - Domain Function list has a different order and default in import SD dialog than new domain. They should be the same.
 - Korean translation update
 - DataBase exception on persist AsyncTask when parent parameters is empty
 - [Cinder] Block the options to add a second cinder instance of the same server
 - [OVF] Wrong severity event log when ovfstore update fails
 - Empty default sysprep password (LocalAdminPassword)
 - Template from snapshot created without icons
 - Inconsistent sorting in VMs tab in webadmin
 - ISO/local shouldn't be an option when creating a new domain on a shared/none DC.
 - Shouldn't be able to create a shared data domain in a local DC
 - Column "v_dedicated_vm_for_vds" does not exist
 - New SD: It's possible to select a local SD option in a shared/none DC
 - Engine does not start if a non-responsive host with running VM exists in the DB
 - Commit a previewed snapshot with Cinder disk throws NPE
 - Windows 2012 guest reports incorrect time randomly and after a cold restart.
 - (Fencing) on Cluster <UNKNOWN>
 - [PKI] enforce utf-8 subject for openssl

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

## VDSM

**oVirt 3.6.0 GA**
 - After upgrading vdsm rpms from 3.5 to 3.6, vdsm fails to restart cause it's not configured

**oVirt 3.6.0 Third Release Candidate**
 - Need to add deps on kernel] vdsm iscsi failover taking too long during controller maintenance
 - Configurable initial allocation size for volume on block storage in order to allow v2v to complete
 - [SR-IOV] - Vlan is not working for 'passthrough' vNIC profiles
 - AttributeError when client disconnects in an unclean way

**oVirt 3.6.0 Second Release Candidate**
 - [RFE] TRACKING - RHEV for Power 3.6 must support RHEL 7.2 for Power LE as Supported KVM Hypervisor
 - Consume fix for "iscsi_session recovery_tmo revert back to default when a path becomes active"
 - If block disk alias or description is too long, disk metadata will be truncated, causing various failures
 - Restoring a RAM snapshots in RHEL7.2 shows error stating the vm (even though it starts correctly) and fails to connect via spice(SetVmTicket: Unexpected exception)
 - RHEV-M UI shows incorrect number of VMs are running on Host.
 - [Fedora] Consume qemu version with fix for "sleep periodically"
 - automated CI checks improvements in the ovirt-3.6 branch

**oVirt 3.6.0 Seventh Beta**
 - Drop vdsm hack for USB keyboard on POWER guests
 - regression for EL7: spmprotect always reboot when fencing vdsm on systemd
 - oVirt Instability with Dell Compellent via iSCSI/Multipath with default configs
 - [scale] high vdsm threads overhead
 - vdsCli fails parsing connectStorageDmain arguments is the user provide an empty iSCSI password
 - VM stuck in down state on vdsm when powering off VM with port mirroring
 - Vdsm should recover ifcfg files in case they are no longer exist and recover all networks on the server
 - [PPC64LE] Vdsm not set correct cpu model for vm
 - Display network is ignored > vdsm listens to all networks - listen="0" instead of listening to the display network
 - Extend of VG does not check if additional devices are already part of it

**oVirt 3.6.0 Sixth Beta**
 - VDSM: Require newer lvm version (2.02.100-8) and certify fix for "Concurrent activations of same LV race against each other with 'Device or resource busy'"
 - process exited while connecting to monitor: qemu-kvm: -machine pc-1.0,accel=kvm,usb=off: Unsupported machine type
 - [libvirt] incorrect XML restore on dehibernation path
 - [7.2-3.6] Failed to approve RHEV-H in RHEV-M 3.5

**oVirt 3.6.0 Fifth Beta**
 - Parsing the "Description" field in a disk's metadata fails when it contains the character "="
 - connectStorageServer is failing cause one object has no attribute 'Timeout'

**oVirt 3.6.0 Fourth Beta**
 - [scale] VM shutdown causes errors under load: exception in acpiShutdown()
 - [HC] - Do not allow adding GlusterFS storage domain, if hosts of the selected dc, do not report they have the GlusterFS packages.
 - F21: dhcp-client-identifier != hardware makes bridge receive a new address and loose connectivity
 - Live merge fails when deleting a snapshot
 - Uninformative message when attempting to create a local sd on a directory owned by root
 - Can't add Gluster volume - "object has no attribute 'glusterVolumeInfo'"
 - [vdsm] hotplugDisk fails with 'internal error unable to execute QEMU command '__com.redhat_drive_add': Duplicate ID 'drive-virtio-disk1' for drive'
 - OSError: [Errno 24] Too many open files while running automation tests

**oVirt 3.6.0 Third Beta**
 - Inconsistent failures when attempting to create a local sd on a directory owned by root
 - Networks definitions are missing after restoration of networks that were changed since last network persistence.

**oVirt 3.6.0 Second Beta**
 - [RFE] Need the ability to dynamically resize data domain luns
 - [RFE] obsolete validateStorageServerConnection
 - [RFE] RHEV-M guest settings can differ from the actual OS/arch that's installed on a guest
 - [RFE] Report downtime for each live migration
 - vdsClient should accept passwords using means safer than a command line option
 - [LOG] AttributeError: 'NoneType' object has no attribute 'name' While trying to create a new storage domain
 - [RFE] Mix untagged and tagged Logical Networks on the same NIC
 - [RFE] Allow live storage migration from block domain to a file domain
 - [RFE] Allow live storage migration from file domain to a block domain
 - [engine-backend] SCSI BUS scan is not initiated as part of creation/edit FC domain
 - vdsm overwrites multipath.conf at every startup if vdsm installed file was replaced
 - VDSM failed to start correctly due to sudo hanging.
 - [RFE] When running a KVM Windows guest, need to turn on all the "hv_\*" flags
 - [RFE] [BLOCKED RHEL-6.6] sriov hook: allow Non-Zero PCI domain for SRIOV Virtual Functions
 - vdsm: script and/or trigger should not directly enable systemd units
 - log spam in vdsm: guest agents not heartbeating
 - [RFE] host device passthrough support
 - Use jsonrpc during migration of vms
 - [Blocked] iSCSI multipath fails to work and only succeeds after adding configuration values for network using sysctl
 - RHEV: Require qemu fix for "Cannot start VMs that have more than 23 snapshots."
 - [RFE] Separate indication of incoming and outgoing live migrations in "Virtual Machines" column of "Hosts" tab
 - volUUID in "vdsClient -s 0 prepareImage" should not be optional
 - [RFE] Don't count on vdsm to report the management interface
 - Thin provisioning disks broken on block storage when using pthreading 1.3
 - [RFE] Remove branding patches
 - pthreading.monkey_patch is too late when done in the vdsm tests
 - Fail to get template/disk via REST
 - vdsm daemonAdapter -h shows traceback
 - [HC] Validate glusterfs volume parameters required for ovirt storage domains
 - [RFE] Use one instance of IOProcess per SD
 - [vdsm] - refactor/improve getPid()
 - unclosed files refernces hit the performance
 - Need clearer documentation for vdsClient -s 0 downloadImage and the API
 - [vdsm] prepareImage and teardownImage commands executed via vdsClient works even though they were executed with an invalid SPUUID value
 - vdsm tests do not check for sudo availability
 - [SCALE] snapshot deletion -> heavy swapping on SPM
 - [vdsm] Console should use a 'serial' device instead of 'virtio'
 - [RFE] [scale] improve resource usage during sampling
 - [spec] vdsm should depend on curl
 - rhev-m stops syncing the VM statuses after massive live VM migration which fails.
 - change cd fail on 'Drive is not a vdsm image'
 - [tool] ensure libvirtd is listening for incoming connections
 - remove libvirt logrotate configuration from vdsm
 - [RFE] Support auto-convergence and XBZRLE compression during migration
 - RHEV should not use SSLv3 encryption. Use TLS instead
 - [RFE] don't use dd to copy sparse images in order to save time and bandwith from exportdomain
 - Failed to Delete First NFS snapshot with live merge
 - UpdateVM sometimes fails using JsonRPC (request doesn't reach vdsm).
 - move set-saslpasswd for libvirt to configurator
 - "VMPathNotExists" error text in 'storage_exception.py' is grammatically incorrect.
 - [RFE] Allow to avoid lock screen on spice disconnect
 - [RFE] Collect CPU, IO and network accounting information from qemu cgroups
 - Incorrect multipath.conf on RHEV-H 7.0 (likely RHEL 7.0 as well)
 - vdsm-tool configure --force fails on a clean CentOS 7
 - [Host Network QoS] rounding errors with "link share" values not divisible by 8
 - [scale] Data Center crashing and contending forever due to unknown device on missing pvs. All SDs are Unknown/Inactive.
 - [Rhel7.1] After live storage migration on block storage vdsm extends migrated drive using all free space in the vg
 - [RHEL7.0] oVirt fails to create glusterfs domain
 - [RFE][HC] – allow gluster mount with additional nodes, currently only one gluster hosts is mounted.
 - Added hosts fail setupNetworks, added only after being autorecoverd
 - [scale] Excessive cpu usage in FileStorageDomain.getAllVolumes
 - VdsmError does not contain missing member info
 - vdsm NUMA code not effective, slowing down statistics retrieval
 - [engine-backend] When reconstruct master is marked as finished, the problematic domain is reported as active, while the new master is inactive
 - [New] - Creating a volume with a brick which is already part of another volume does not give a proper error message.
 - [New] - Creating a volume with bricks on the root partition gives "Error while executing action Create Gluster Volume: Unexpected exception"
 - [performance] vdsm Host Monitoring issues
 - Gateway entry (outside of 'cfg') is not set for non-VM networks
 - [RHEL 7.0 + 7.1] Host configure with DHCP is losing connectivity after some time - dhclient is not running
 - After failure to setupNetworks: restore-nets with unified persistence does not restore pre-vdsm ifcfg
 - Host fails to flip to maintenance mode due to failed live migrations.
 - Hibernated VM is not being destroyed
 - VDSM can not parse Infinity speed for Throughput tests
 - tests: InterfaceSampleTests are failing with IOError
 - while filling thin disk, actual disk size increasing above the provisioned size
 - Failed to auto shrink qcow block volumes on merge
 - [3.5-6.6/7.1] Failed to retrieve iscsi lun from hardware iscsi after register to RHEV-M
 - Guest agent throws ERROR Tracebacks to vdsm log, when shutting down VM from spice
 - RHEV [RHEL7.1] - Require qemu fix for "Cannot start VMs that have more than 23 snapshots"
 - oVirt to consume device-mapper-multipath fix for running multipath -r on Fedora
 - [PPC] Failing to change the VM's link interface state to down
 - Vdsm upgrade 3.4 >> 3.5.1 doesn't restart vdsmd service
 - [oVirt] require libvirt-python that properly supports virDomainBlockCopy
 - [New] - Cannot create brick in UI when nodes are added to the cluster using JSON RPC.
 - [HC] Hosted Engine storage domains disappear while running ovirt-host-deploy in Hyper Converged configuration
 - RHEV disconnects when remotely connecting to windows machines.
 - Long filename support for Windows VM payload
 - StorageDomainAccessError: Domain is either partially accessible or entirely inacessible when creating an iSCSI storage domain with RHEV-H 6.6
 - Live Merge: Active layer merge is not properly synchronized with vdsm
 - [vdsm] errors: value of 'vcpu_period' is out of range [1000, 1000000]
 - Gluster geo-rep create should ensure that remote volume is empty.
 - [vdsm] Template creation on XtremeIO with pre-allocated disks on block storage fails with "CopyImageError: low level Image copy failed"
 - [New] - File sytem Type disappears when syncing the storage devices from host / when a new brick is created from UI
 - Windows 7 experiencing time drift under high CPU load
 - [New] - Add a snapshot config option 'activate-on-create' for Options-cluster.
 - Migration fails between two el7 hosts
 - All in one: getSpmStatus failing with StorageDomainMasterError: Error validating master storage domain: ('Version or spm id invalid',)
 - [HC] vdsm checks for qemu-kvm-rhev missing qemu-kvm-ev
 - IPv6 on bridges are on by default allowing guest-host communication
 - report hook stderr to Engine if it fails an action
 - vdsm fails to read dhclient lease config "expire never"
 - [VMFEX_Hook] Migration fail with 'HookError' when using vmfex profile and vdsm-hook-vmfex-dev hook in rhev-M
 - [RFE] hot-plug memory
 - In Create Brick Scenario VG Create failed in first time
 - [RFE] Allow mom to run as standalone process
 - [New] - Cannot see lv,vg and pv on the system when user tries to create a brick from UI
 - Total Rx and Total Tx Statistics for VM's Network Interfaces are not reported in the Web Admin as they should be
 - Hosted Engine can't be installed anymore on EL7 due to unsupported machine emulation
 - Can't remove network interface via RESTAPI, unexpected exception
 - Ballooning is working on VM without Guest Agent
 - [New] - xfsprogs should be pulled in as part of vdsm installation.
 - Do not pull vdsm-reg onto node
 - Split vdsm-gluster to separate out verbs used for retrieving info
 - VDSM: Live merge fails after a disk containing a snapshot has been extended
 - VM cannot start after adding a virtio-rng random number device (oVirt 3.5.3)
 - Remove supportedProtocols report from getCapabilities
 - vdsm doesn't support workflow with replica 1 as gluster storage domain
 - vmstats hook should not be enabled by default
 - /var/log/messages is spammed with hosted engine errors on RHEV-H 3.5.4

## oVirt Engine DWH

**oVirt 3.6.0 Second Beta**
 - [rhevm-dwh] - Remove Host power management fields in History DB
 - [RFE] Reset the RHEV-M reports admin password with rhevm-config utility.
 - [ENGINE-SETUP] - Once dwh & reports are not installed in the 1st install, these options are not presented in the 2nd time
 - Validate database max connections when applying schema
 - [RFE] Alternate locations for rhevm-reports backups
 - [RFE] Add Fedora 21 support to oVirt
 - ETL service aggregation to hourly tables is failing with NullPointerException for specific timezones due to the way the ETL interprets the timezone
 - DWH log does not show message when it closes due to DisconnectDWH flag on engine
 - If connection to DB fails , the job that checks DisconnectDwh flag does not reconnect to engine db
 - Can not restore backup file to rhevm with non-default lc_messages
 - [RFE] Add wrapper for js-import and js-export
 - [ovirt][engine][setup] engine-setup: Failed to execute stage 'Environment setup'
 - [RFE] Report guests Buffered/Cached memory - DWH
 - [RFE]Add additional hypervisor details to the ETL process - DWH
 - [RFE] Collect total RX/TX byte statistics for hypervisor and VM network interfaces
 - Update cached/buffered memory to bigint
 - ETL service sampling error - RuntimeException: Child job running failed

## oVirt Engine Reports

**oVirt 3.6.0 Second Beta**
 - [RFE] Reset the RHEV-M reports admin password with rhevm-config utility.
 - [RFE] CCP report should contain the created_by field
 - [ENGINE-SETUP] - Once dwh & reports are not installed in the 1st install, these options are not presented in the 2nd time
 - [RFE] Alternate locations for rhevm-reports backups
 - [F21] ovirt-engine-reports fails to build on Fedora 21
 - [RFE] add "Hosts Heatmap report"
 - [RFE] rebase jasper server to 6.0.1
 - [RFE] Report clusters capacity
 - In Active Entities by OS (BR18A) report hours are not shown in the Date for Daily period
 - HEAP_MAX default value as 1G must be changed
 - [RFE] Add wrapper for js-import and js-export
 - [ovirt][engine][setup] engine-setup: Failed to execute stage 'Environment setup'
 - Handling new Wildfly application server in engine so it will not affect reports
 - 3 additional properties are missing from /WEB-INF/js.quartz.properties
 - Fix UI for the new jasperserver 6.0.1 package
 - Errors during installation and config when openjdk is NOT default in an environment.
 - [RFE] rebase jasper server to 6.0.1
 - Heatmap Report BR49 title is incorrect- BR49 should be in capital letters - not "Heatmap Report (br49)"
 - [engine-backup] reports fails after restore with --change-dwh-db-credentials
 - [Text] Need to update in the ovirt-engine-reports-tool the text "Exporting users from Jasperreports"

## oVirt Hosted Engine Setup

**oVirt 3.6.0 Release Candidate**
 - Hosted-engine notification not work

**oVirt 3.6.0 Seventh Beta**
 - [hosted-engine-setup] Additional host deployment fails with "Dirty Storage Domain: Cannot find master domain" over block storage
 - Hosted engine does not set up, stuck on AAA stage
 - Different behavior of connectStorageServer and prepareImage between iSCSI and NFS
 - hosted-engine --vm-status wrongly complains about still being to be deployed

**oVirt 3.6.0 Sixth Beta**
 - ovirt-hosted-engine-setup still prints hints about HC on 3.6 if VDSM was already configured

**oVirt 3.6.0 Fifth Beta**
 - hosted-engine-setup fails updating vlan property on the management network if more than one datacenter is there
 - vdsm create ovirtmgmt bridge with DEFROUTE=no
 - Fail HE install when closing the install
 - [Appliance] Avoid asking about the cluster name if the user choose the automatic execution of engine setup

**oVirt 3.6.0 Fourth Beta**
 - Provide way to connect text only to HE during setup, virsh is failing.
 - [hosted-engine-setup] Deployment over iSCSI using RHEVM-appliance fails with endless 'WARNING otopi.plugins.ovirt_hosted_engine_setup.vm.image image._disk_customization:124 Not enough free space' messages

**oVirt 3.6.0 Second Beta**
 - Redeploy of hosted-engine on NFS storage failed
 - On additional hosts, appending an answerfile, the setup will not download the HE one from the first host

**oVirt 3.6.0 First Beta**
 - "hosted-engine --deploy" allows selection of unusable NICs

**oVirt 3.6.0 Third Alpha**
 - hosted-engine setup using cdrom image doesn't check if file is really image file
 - [ovirt-hosted-engine-setup] script doesn't validate user input for username for iscsi storage domain > 50 characters.
 - [hosted-engine][help] --help for command is cryptic
 - HE deployment fails due to libvirtError: internal error client socket is closed
 - reduce dependencies for HC support in Hosted Engine
 - [hosted-engine-setup] [GlusterFS support] Deployment fails with: " Fault: <Fault 1: '<type 'exceptions.Exception'>:method "glusterVolumesList" is not supported'> "
 - [hosted-engine-setup] Deployment fails due to a sanlock exception creating temporary Posix storage domain on a loopback device

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

## oVirt Hosted Engine HA

**oVirt 3.6.0 Third Release Candidate**
 - Wrong HA agent low free memory message
 - ovirt-ha-agent will hang during 3.5 -> 3.6 upgrade on NFS ('list index out of range' from getImagesList)
 - race condition refreshing /var/lib/ovirt-hosted-engine-ha/broker.conf

**oVirt 3.6.0 Second Release Candidate**
 - Race condition between ovirt-ha-agent and vdsmd startup with systemd

**oVirt 3.6.0 Release Candidate**
 - Hosted-engine notification not work

**oVirt 3.6.0 Beta**
 - Different behavior of connectStorageServer and prepareImage between iSCSI and NFS
 - HE VM not powered up on second host | ovirt_hosted_engine_ha.agent.hosted_engine.HostedEngine::(score) Score is 0 due to unexpected vm shutdown
 - HE active hyper-visor not responding to "hosted-engine --vm-status" after "iptables -I INPUT -s 10.35.160.108 -j DROP" cast.
 - Fail HE install when closing the install
 - Switch to Hosted Engine TUI menu so slowly due to failed to connect to broker
 - ovirt 3.6 beta 2: ovirt-ha-agent crashes
 - hosted-engine --vm-status results into python exception
 - [RFE] Provide a tool to clear hosted-engine.lockspace that will also check that no agent is running locally and that --vm-status does not list any host as active.
 - [HE] ovirt-ha-agent daemon is passing wrong values in connectStorageServer
 - Missing Date header in broker notifications
 - /var/log/messages is spammed with hosted engine errors on RHEV-H 3.5.4

**oVirt 3.6.0 Alpha**
 - ovirt-hosted-engine-ha rpm should depend on otopi
 - bogus line during installer boot

## oVirt Log Collector

**oVirt 3.6.0 Beta**
 - rhevm-log-collector: drop sos2 / rhel < 6.7 support
 - rhevm-log-collector is missing sos dependency on RHEL 6.7

**oVirt 3.6.0 Second Alpha**
 - [RHEL6.7][log-collector] Missing some info from engine's collected logs

**oVirt 3.6.0 Alpha**
 - [RFE] Log collector does not collect hosted engine information
 - log-collector tar files change "." permissions when extracted
 - [RFE] log collector should collect engine-config settings and domain information
 - split rhevm-log-collector moving sos plugins to subpackage

## oVirt Image Uploader

**oVirt 3.6.0 Beta**
 - [engine-image-uploader] Misleading error msg when wrong path for image is used
 - [RFE] Provide more informative error messages for iso-uploader failures

**oVirt 3.6.0 Alpha**
 - [RFE] add progress bar to image uploader

## oVirt ISO Uploader

**oVirt 3.6.0 Second Alpha**
 - [RFE] Provide more informative error messages for iso-uploader failures

**oVirt 3.6.0 Alpha**
 - [RFE] add progress bar to image uploader
 - [engine-iso-uploader] engine-iso-uploader does not work with Local ISO domain

## oVirt Engine SDK Python

* [RFE] Don't require live engine to generate Python SDK code
 - [RFE] PYTHON-SDK: Add support for Kerberos authentication
 - [ovirt-sdk] export method clash in generate DS and RestApi
 - [REGENERATE PYTHON SDK] Refresh host capabilities missing from Python-SDK
 - [REST] HTTP Status 400 on DELETE call to /datacenters/${id}/storagedomains/${id}

## oVirt Engine SDK Java

* [Python/Java SDK]Network labels get_labels().get() accept diffarent parameters for Python and Java SDK
 - [RFE] JAVA-SDK: Add support for Kerberos authentication
 - [RFE] Don't require live engine to generate Java SDK code
 - sdk-java Encoding Problem
 - Backwards compatibility breaking changes in some method signatures
 - SDK asks for Kerberos credentials interactively when using Kerberos authentication
 - Don't use deprecated DefaultHttpClient as it causes backwards compatibility problems

## oVirt Engine CLI

* [RFE] OVIRT-CLI: use remote-viewer instead of spicec for spice based console
 - rhevm-shell it is not possible to create nonVM network
 - The shell connect command throws misleading error when no password passed
 - Ovirt shell interactive session exits when passing -h parameter to connect command
 - [RFE] CLI: Add support for Kerberos authentication
 - Add support for ids that aren't UUIDs
 - [CLI] Add support for different ids than uuid like id
 - Not possible to add vm to affinity group via cli
 - The CLI doesn't provide a mechanism to escape characters in string literals
 - Thew new --whatever-name options used for parent references conflict with existing options
 - Unable to show entities by it's parent name/id via CLI

## oVirt Engine Extension AAA JDBC

* [ovirt-aaa-jdbc-tool] Please handle NPE when ovirt-aaa-jdbc-tool is run without --db-config parameter
 - [ovirt-aaa-jdbc-tool] Parameter --password-valid-to of 'user password-reset' fails on NPE when invalid date is passed
 - [ovirt-aaa-jdbc-tool] Please add nicer error message when adding already existing user
 - [ovirt-aaa-jdbc-tool] Don't log password
 - [aaa-jdbc-tool] Don't allow special characters at input
 - Not possible to use more different schemas
 - dbscripts/schema.sh is executed even when upgrading setup

## oVirt Live

**oVirt 3.6.0 Beta**
 - Host in non operational state since vdsm-ovirtmgmt is not defined in libvirt
 - missing vmconsole related answer in the answer file for automated install

**oVirt 3.6.0 Alpha**
 - [RFE] Enable the configuration of the SANWipeAfterDelete property in the setup
 - [RFE] Rebase oVirt Live on CentOS 7.z

## OTOPI

* engine-cleanup should return different codes for different types of failures
 - [iptables] install iptables-services if available
 - [RFE] support dnf packaging
 - [dialog] support unicode output

## oVirt VMConsole

New package
 - [selinux][rhel-6.7] /bin/sh: Permission denied

## oVirt Optimizer

* recurring admin@internal logged in messages in events when using Optimizer


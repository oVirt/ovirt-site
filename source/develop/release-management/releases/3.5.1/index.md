---
title: oVirt 3.5.1 Release Notes
category: documentation
toc: true
authors: alonbl, bproffitt, didi, sandrobonazzola, stirabos
---

# oVirt 3.5.1 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.5.1 release as of January 21, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Fedora 20, Red Hat Enterprise Linux 6.6, CentOS 6.6, (or similar) and Red Hat Enterprise Linux 7, CentOS 7 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/). 

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

If you are upgrading from a previous version, you may have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](/develop/release-management/releases/3.4.1/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup


## What's New in 3.5.1?

### Red Hat Enterprise Linux 7 and CentOS 7 Support

Support for running oVirt Engine on Red Hat Enterprise Linux 7 and CentOS 7 (or similar) has been added providing custom packaging of JBoss Application Server 7.

### oVirt Engine Extensions

More information available at [Features/AAA](/develop/release-management/features/infra/aaa.html).

#### Log4J logger bridge

Log4j bridge for engine log, can be used to redirect log records to any appender log4j supports. Package name is ovirt-engine-extension-logger-log4j, documentation is available at [1](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-logger-log4j.git;a=blob;f=README;hb=HEAD).

#### LDAP Authentication and Authorization

A new LDAP implementation for ovirt-engine, replaces the legacy Kerberos/LDAP implementation. The new implementation is customizable, has greater support matrix for LDAP features and enable adding new LDAP schemes. Package name is ovirt-engine-extension-aaa-ldap, documentation is available at [2](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-ldap.git;a=blob;f=README;hb=HEAD).

#### Misc Authentication and Authorization utility

Extensions required mainly for enabling single signon of ovirt-engine with environments such as Kerberos. Package name is ovirt-engine-extension-aaa-misc, LDAP specific integration is documented within the ovirt-engine-extension-aaa-ldap package [3](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-ldap.git;a=blob;f=README;hb=HEAD#l158), and in package specific documents [4](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-misc.git;a=blob;f=README.http;hb=HEAD)[5](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-misc.git;a=blob;f=README.mapping;hb=HEAD).

### Hosted Engine

*hosted-engine --deploy* now uses the host's hostname as the address to use when adding it to the engine, rather than the IP address of the selected interface. This means that the hostname must be resolvable and accessible for HA migration to work, and will also show e.g. in *hosted-engine --vm-status*.

## Known issues

*   NFS startup on EL7 / Fedora20: due to other bugs ( or ), NFS service is not always able to start at first attempt (it doesn't wait the kernel module to be ready); if it happens oVirt engine setup detects it and aborts with

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

Retrying (engine-cleanup, engine-setup again) it's enough to avoid it cause the kernel module it's always ready on further attempts. Manually starting NFS service (/bin/systemctl restart nfs-server.service) before running engine setup it's enough to avoid it at all.

## CVE Fixed

[CVE-2014-3561](https://access.redhat.com/security/cve/CVE-2014-3561) ovirt-engine-log-collector: database password disclosed in process listing

## Bugs fixed

### oVirt Engine

**Fixed in oVirt 3.5.1.1 async release**
 - NPE in AddDiskCommand during ovf volume creation.
 **Fixed in oVirt 3.5.1 RC1**
 - engine [TEXT]: unclear error message when extend storage domain fails
 - engine does not log osinfo file having already used id.value
 - [engine-webadmin] uninformative error on UI when remove ISO domain with format fails due to VDSNetworkException
 - [RFE] [dwh] add trigger to stop etl connection via engine db value.
 - [RFE] Virtual disk .meta file should have Alias field
 - Do not allow migration when 'Use Host CPU' flag checked
 - Faulty storage allocation checks when merging a snapshot
 - Faulty storage check when adding a template from a VM with disks
 - Faulty storage allocation checks when importing a disk from glance
 - OSInfo file lacks validation for legal values
 - engine-upgrade-check has no man page
 - sPAPR VLAN interfaces are accounted as PCI devices
 - [engine-backend] snapshot creation task (createVolume) is not polled by engine, which causes live storage migration flow to keep running in case of a failure of vdsm to complete the createVolume task
 - [AAA] Proper audit log handling for expired account
 - Change CD list is still available even when ISO domain is inactive
 - Single Disk Snapshot does not behave intuitively
 - Hot plug CPU - allow over-commit
 - [AAA] REST API request - add user different from admin to internal domain passed
 - HotUnplugCpuSupported raw in in vdc_option table is empty.
 - Block Live Storage Migration in case qemu-kvm doesn't support live snapshoting
 - [AAA] builtin kerbldap provider does not show error if search fails
 - 3.4 upgrade does not set correct iptables rules when serving ISO domain from RHEV-M host
 - Create template from vm with empty disk alias should block with canDoAction
 - [Scale] - updatevdsdynamic running too slow on scale setup
 - foreman-integration: double Power Management setup
 - Add a list of changed fields for Edit running VM
 - The Balloon driver on VM ... on host ... is requested but unavailable.
 - oVirt does not support creation of vm with block disks from a thin-provision file snapshot
 - [AAA] Unable to assign permissions to user
 - Admin Portal: Unresponsive script leading to Virtual Machines not being displayed any more
 - [fr_FR][en_US][Admin Portal] Misalignment in 'Copy Quota' dialog.
 - Fields under "Start Running On" in the "Edit Virtual Machine" window should be greyed out when the VM is up
 - Resized columns in main tabs do not save their user configured size
 - [oVirt][Foreman] return a proper error message on root password policy violation
 - [engine-setup] explain - Substitute <country>, <organization> to suite your environment
 - "There is no over-utilized host in cluster " repeated every minute
 - Live deletion of a snapshot (live merge) is blocked(CDA) when attempting the removal from snapshot overview
 - [ImportDomain][LOG]Confusing ERROR logs "Could not get populated disk" when importing a domain
 - [Notification][SNMP] modify the oid schema for SNMP notification - to be usable
 - [engine-backend] [importDomain] VM creation out of an imported template is blocked in CDA
 - Import storage domain doesn't clear ,"storage_server_connections", sql tab entry upon unsuccessful completion
 - [ImportDomain] Add a warnning when detaching a Storage Domain
 - [Import Domain] When a Storage Domain is moved to maintenance the OVF store disk should be updated synchronously
 - "VdcBLLException: NO_UP_SERVER_FOUND" in seen in engine logs
 - [ImportDomain] Add warning if VM contains shareable or Direct Lun disk before detach the Storage Domain
 - [ImportDomain] VM with no disks should be part of the OVF_STORE disk
 - [ImportDomain] Register of a Template with copied disk should be supported
 - Fail to start vm with payload.
 - [scale] - "Unable to evaluate payload" when loading cluster policy
 - [RHEV-M] System is not power on after a fencing operation in power management (agent: ipmilan)
 - Failure to Attach ISO domain causes SPM failover
 - [engine-setup] setup fails if the user decide to configure websocket proxy without having installed websocketproxy rpm
 - Optimize start button should be available only when VM is down
 - ConsoleToggleFullScreenKeys and ConsoleReleaseCursorKeys are not setable
 - [engine-setup] an upgrade via engine-setup on a system with iptables closes postgres port preventing remote components to work
 - Can set dual NFS mount options when creating new NFS data domain
 - logon command via REST, try logon to RHEV-M Authentication and not to original user
 - [scale] - getdisksvmguid hit the performance due to all_disks_including_snapshots view
 - [TEXT] Inconsistent terminology used for Data Centers in Add Virtual Disk
 - No error thrown in common_sp functions in case column or table does not exists
 - Description of affinity group not loaded to edit affinity group tab
 - [Edit VM] > Irrelevant and wrong pop-up Operation canceled while moving VM from cluster to cluster
 - [ppc64] Cannot create Cluster. This resilience policy is not supported in this CPU architecture.
 - rhev-m stops syncing the VM statuses after massive live VM migration which fails.
 - New CPU QoS Dialog UI issues
 - In Data Center QOS subtab 'edit' button is available for multiple selection of QOS
 - Unclear warning when removing multiple QoS
 - out of frame load balancer boxes
 - Impossible to get schedulerpolicyunit by id via REST
 - medium Instance Type mismatch feature page
 - Faulty storage allocation checks when adding a VM Pool with VMs.
 - [engine-webadmin] DC 'Type' field name should be replaced with 'Storage Type'
 - Rest-api's add disk logged with NONE variable,Adding Disk <UNKNOWN>
 - Display custom error page if reports is not installed
 - NPE when VM initialization doens't contain boot protocol
 - [UI] Import Virtual Machine's menu box is not aligned
 - AddVmFromScratchCommand can Fail to create a new Vm when executed from rest-api,py-sdk
 - Force select SPM operation event is showing <UNKNOWN> instead of the data center name
 - REST API fails to return the host ID of VM which is in unknown state due to node crash
 - Upgrading a DC to 3.5 does not create default storage profiles
 - [engine-backend] [blkio-support] size units are not corralated between webadmin and backend for storage QOS
 - migrate VM fail on start vm on destination host.
 - [engine-backend] [blkio-support] Hotplug disk doesn't include ioTune attribute
 - Console buttons are still active after VM is launched (plugins only)
 - [events] Host memory usage exceeded defined threshold chaos - VDS_HIGH_MEM_USE vs USER_SUSPEND_VM_FINISH_FAILURE_WILL_TRY_AGAIN
 - ERROR [org.ovirt.engine.core.bll.AddVmPoolWithVmsCommand] (org.ovirt.thread.pool-7-thread-35) [679d023] Command org.ovirt.engine.core.bll.AddVmPoolWithVmsCommand throw exception: java.lang.NullPointerException
 - [cli]storage_manager element is not validated correctly
 - Run vm in preferred mode drop libvirt error
 - [TEXT ONLY] During engine-setup, the Application Mode string ordering should be tweaked
 - Double vnuma nodes on pinning, when vm run
 - Numa pinning not work via REST
 - Webadmin UI in RHEVM 3.5 is slower by ~25% than in 3.4 (Firefox 31 on RHEL 6)
 - Assigning a Data Center for a cluster containing a Host, without Data Center assigned to the cluster (Since the previous DC was removed) causes an internal error
 - In case of using new template version (sealed with sysprep) for a pool, VMs get stuck in minisetup
 - [ImportDomain] Attempting to register an non exsistant VM via rest-api fails with NPE
 - Detach of local Storage Domain which is not master fails with the reason Storage Domain does not exists
 - The default VM - snapshot view has the columns spaced too widely appart
 - [TEXT] Failed delete of snapshot disks - message indicates (User: <UNKNOWN>)
 - Top search panel buttons and VM Status column are missing static HTML IDs (needed for Selenium testing)
 - Host SSH Fingerprint - "Fetched fingerprint successfully" shouldn't be in red text
 - Windows 7 guests reports incorrect time after a cold restart.
 - [PPC] VMPool size update not working via REST
 - RemoveSnapshot is reported as failed due to an exception
 - Unable to get unregistered vms in SDK
 - NPE when adding QoS object without type_ to datacenter
 - Import File or Block Storage Domain should be locked in the memory
 - New Host dialog has a misaligned checkbox on Power Management tab
 - Prestarted VMs dissapear from UI after failure to restore snapshot once VM turns from Unknown status to Down
 - [rhevm-shell] memory_policy - ballooning unable to set
 - [Admin Portal][ppc64][Power mgmt] ipmi doesn't work - Authentication type NONE not supported/Unable to obtain correct plug status or plug is not available
 - NPE in create disk flow
 - [Text] Detach Storage dialog has several text related issues
 - [Text] Attempting to remove a VM that is part of a VM pool notes “VM-Pool” instead of expected “VM Pool”
 - Inconsistent terminology used for Data Center (Data-Center) under the Data Center sub-tab of the Storage tab
 - Storage Domain maintenance dialog (Maintenance Storage Domain(s) has text and readability issues
 - The Import Conflict dialog has a Don’t Import option (no operation) and somewhat confusing text
 - The Message column width under the Events tab for the Basic View is extremely narrow (re-using the same width as on the Advanced View)
 - [engine-backend] Unclear error message for OVF_STORE disk creation
 - Cannot register rhev-h 3.4.z host to rhevm 3.5 due to protocol incompatibility
 - Reduce the list of "marked" fields on instance types
 - Faulty storage allocation checks when running VM with unplugged disks as stateless
 - [engine-webadmin] Cannot close pop-up windows with X button
 - API rsdl is missing the "snapshot id" flag in single snapshot preview - inconsistent with Rest API
 - [engine-backend] ActivateStorageDomainCommand fails on CDA for adding a new domain
 - Inhibit migrations RHEL7.0 -> RHEL 6.5 (or equivalent: CentOS)
 - installing reports on separate server fails when providing ssh password to sign certificate
 - When ISO domain is attached to two DCs it appears twice in the storage tab
 - Misalignment in 'New Cluster' dialog -> Cluster Policy [French language]
 - Cannot create pool of ppc64 VMs
 - null pointer exception when trying accessing /cdrom for non-existing VM
 - [osinfo] [ppc64] SLES 11 for Power doesn't support virtio-scsi storage
 - [osinfo] [ppc64] SLES 11 for Power doesn't support rtl-8139 network card
 - [RFE][osinfo] add rhel7/ppc64 into osinfo
 - GetAllFromVms stored function is inefficient
 - [PM] PM-Restart, host still down - ERROR [org.ovirt.engine.core.vdsbroker.ResourceManager] ... CreateCommand failed: java.lang.NullPointerException
 - Failed to delete snapshot disk
 - [engine-webadmin] No warning that direct LUNs are not going to be part of a cloned VM
 - Adding 3.2 hosts to 3.5 cluster in RHEV-M 3.5 (vt5.1/el6) results in hung hosts
 - [Text] User messages concerning detaching a storage domain should say detach and not Detach.
 - [PPC][UX] balloon is sent for PPC VMs upon ImportVm from export domain command
 - CPU Shares custom uneditable in webadmin
 - User Portal is not fully rendered in Internet Explorer 8
 - IE8: Layout is broken on RHEVM welcome page and User Portal login page
 - [PPC][UX] balloon is sent for PPC VMs when creating VM from snapshot
 - [REST][CLI] Balloon on VM re-enabled on every API CALL for VM
 - [mla] query execution failed due to insufficient permissions for add disk as user in user level api
 - reboot from webadmin doesn't work without guest agent
 - RHEV should not use SSLv3 encryption. Use TLS instead
 - SSL Stomp Reactor fails to connect with host during add host operation
 - [performance] - getVmDeviceByVmId hit the performance due to VdsUpdateRunTimeInfo
 - [PPC]-Can't Hotplug/unplug VM nic while vm is running and has OS installed
 - Fail to de-serialize task with user entity
 - [scale] - 'updateAllDiskImageDynamicWithDiskIdByVmId' hit the performance
 - Navigating to the Images subtab of an inactive ISO storage domain results in an exception of type VdcBLLException with the error GetIsoListError
 - [PPC] Virtio images do not support hotplug
 - Incorrect message after failure of host deployment
 - Can't add NIC to running/not running VM, after several VM migrations
 - Blank Template have an empty VM-Init
 - ui not responding sporadically
 - Removing a ISCSI Domain fails with Internal Server Error - java.lang.ArrayIndexOutOfBoundsException
 - User name isn't added to the cloud-init file
 - Migration, suspend and memory snapshots are disabled in ppc64
 - GetAllRolesByUserIdAndGroupIds should not return duplicate rows
 - Engine does not free pending_vmem_size and pending_vcpus_count on migrate host, in case of VM migration failure.
 - inconsistent columns order in multiple views tables
 - Deleting all snapshot disks during a vdsm restart causes some of the snapshot disks to stay in locked status
 - Storage Type of an imported Storage Domain should be determined by the user instead from the meta data
 - [engine-backend] [importDomain] [iSCSI support] hosted-engine: import the hosted-engine's storage domain is allowed
 - [engine-backend] hosted-engine: moving the hosted-engine host to maintenance is allowed although migrating the hosted-engine VM is blocked on CDA
 - the informations in General sub-tab of Clusters are empty when using other languages
 - Add new vm from template with cdrom payload via create fail on JsonMappingException
 - GWT debugger throws exceptions about incomplete HTML expression
 - [engine-backend] Image remains in LOCKED state after a failure to live migrate it due to CDA block
 - webadmin search bar vertical alignment is off
 - [AAA] Search for users in incorrectly configured external ldap domain fails with NPE
 - [RHEVM][FOREMAN-INTEGRATION] host stays on installingOS state after provision is done in satellite
 - allow all levels within engine.log appenders
 - [extapi] expose configuration file name to extension
 - Incorrect information on time zone in message during delete snapshot
 - Project does not build on fedora 21
 - snapshot support not re-checked once detected as not supported
 - [RFE] Add EL7 support to ovirt-engine
 - Set endAction try again to false on failure
 - [UX] Wrong message displayed during Live storage migration (contains <UNKNOWN>)
 - [JSONRPC] Extend size operation of an attached iSCSi domain, fail with CDA
 - Remove disk returns HTTP 404 in SDK
 - Enter Engine Database Password on DWH setup is not intuitive when setup is on a separate host
 - Introduction of new logging framework
 - [mla] User which don't have permissions to view other users, can see those users when specify exact ID in REST API
 - Missing command ctor (Guid parameter) for CreateSnapshotFromTemplateCommand
 - IE9 - VM dialog: options in combo boxes 'Cluster' and 'Based on Template' are not aligned correctly
 - rhel 7 / rhev 3.4 host can not connect to iscsi storage with: ValueError: invalid literal for int() with base 10: ''
 - Can't add disk to VM without specifying disk profile when the storage domain has more than one disk profile
 - CommandBase should not set end status for commands with callback
 - [engine-backend] Suspend VM fails with a NullPointerException
 - [JSONRPC]Live merge - failed to delete snapshot on 2nd attempt - first attempt was interrupted with shutdown of vm
 - Copying a template's disk to a new storage domain succeeds but API/WebUI shows that disk instance multiple times
 - Logout must logout all sessions
 - Double backend login during frontend login
 - [engine-backend] Previewing a partial snapshot for a VM with a shared disk causes a NullPointerException failure
 - [engine-backend] Cloning a VM from a VM in preview snapshot mode fails with "disk profile is empty"
 - Images sub-tab is empty for Glance storage domains
 - [engine-backend] resizing a disk attached to a paused VM leaves the image LOCKED
 - MacPoolRanges
 - [LOG] Query GetVmTemplateQuery failed with NullPointerException when applied to a non-existent template.
 - [engine-backend] Live migrating a disk while its snapshot is being cloned leaves the disk in LOCKED
 - Allow ICMP in IPTablesConfig default configuration (documentation also allows ICMP)
 - Hosts Remote procedure paramter shouldn't disappear when it's active
 - Enter DWH database password on reports setup is not intuitive when setup is on a separate host
 - Unable to remove a failed node from a hosted-engine setup
 - [aaa] AuthRecord, PrincipalRecord are not available at SessionDataContainer
 - [engine-setup] exportfs before nfs restart fails
 - [qemu-kvm] unable to run 64bit versions of Windows 8, 8.1, 2012, 2012 R2 - Error Code: 0x0000001E
 - Refresh button on main tab is hidden when buttons on menu bar don't fit the panel/screen width
 - Login to multiple iscsi targets fails
 - SSO to reports is broken in certain conditions
 - MacPoolRange | error validation should be on engine-config
 - Invalid locale found in configuration ''
 - clicking on external providers in tree view doesn't update main-tab content properly
 - Foreman integration - adding host should set address according to the hostgroup domain
 - add host from foreman - search button is not working
 - add host from foreman - name and address aren't cleared when disabling foreman
 - [AAA] [KerbLDAP] propogate exceptions to engine
 - Cannot create disk profile
 - Templates do not incorporate user defined properties
 - vm from pool isn't updated on new version if run by admin
 - foreman-integration: ovirt-node should get engine-address without any suffix
 - [AAA] [KerbLDAP] ignore mixed cases domains in vdc_options
 - After exporting VM based on a template, the VM gets blocked with a status showing image is locked
 - [hosted-engine] [iSCSI support] The device that is being used by the engine's VM for the VM disk, and is listed as a direct LUN in the engine, is allowed to be removed from the setup
 - Failed to execute stage 'Setup validation': Failed to clear zombie tasks.
 - Missing event log in case mix RHEL 6x and 7x hosts in one cluster trial.
 - The password text box of new host dialog is not empty initially in Chinese/Korean/German
 - Fail to attach ovf store disk when attaching a Storage Domain will result a low level sql error
 - engine-setup does not reset DisconnectDwh on failure
 - Multiple disks with same Alias (name)
 - ERROR shown for trying to stop a vm not running versus DEBUG or INFO message
 - Error 500 from JBOSS engine API
 - Set disk_profile or storagedomain parameter required for add disk operation
 - Import template to another cluster is blocked.
 - Requests from RHEV-M to SPM and Hypervisor hosts use too few concurrent http connections
 - [engine-webadmin] Inserting wrong input in QOS prompt doesn't trigger a warning indication
 - [AAA] handle group loops
 - UpdateVM sometimes fails using JsonRPC (request doesn't reach vdsm).
 - "move" disk operation badly documented, incomplete options support
 - Changing rpc to 'json-rpc' fails with, "Operation Failed: [Internal Engine Error]", due to errors on character encoding
 - Issues with rename
 - [jre8] testFilter(org.ovirt.engine.core.notifier.filter.FirstMatchSimpleFilterTest fails
 - [aaa][kerbldap] freeIPA 4.x base dn should be obtained using defaultNamingContext
 - [Rhev-Upgrade] NPE when refreshing a host (VdsUpdateRunTimeInfo) after upgrade
 - [PPC] Mismatch in CPU pinning support
 - Disks may remain in status LOCKED instead of ILLEGAL
 - [aaa] two ldap external providers have same id assigned, when one is incorrectly configured
 - allow setting SSL protocol for external communication
 - engine shouldn't migrate hosted-engine VM when moving the host to maintenance
 - Webadmin access not cleared on session expiration
 - Some arbitrary operations fails with VDS_NETWORK_ERROR code 5022
 - Unable to add external event using API
 - [hosted-engine] [iSCSI support] Hosted-engine VM pasues on EIO when deactivating an iSCSI domain in the setup
 - Storage Tab -> import Domain -> help button is missing
 - Templates tab -> export template -> help leads to exporting VM
 - Storage tab-> ISO Domain -> Data Center -> Attach -> help button is missing
 - [AAA] display profile name instead of java object within basic authentication failure
 - [engine-backend] SQLException while starting a VM which was stateless before and had a disk attached to it while it was in stateless
 - [RFE] Generate sysprep answers file with name matching the version of Windows
 - Can't run VM with error: CanDoAction of action RunVm failed. Reasons:VAR__ACTION__RUN,VAR__TYPE__VM,ACTION_TYPE_FAILED_O BJECT_LOCKED
 - Host pending resources are not cleared after migration canceling.
 - Pending resources are not cleared when network exception occurs.
 - [AAA] User admin::internal is always synchronized
 - [JSON RPC] shutdown/reboot a host on state 'up' result in fault behaviour which is resolved only by engine restart
 - [AAA] remove the user sync
 - JSON-RPC | engine gets stuck randomly | ERROR (SSL Stomp Reactor) Unable to process messages
 - [ImportDomain] Import data domain should alert if was invoked on unsupported data centers
 - NPE When attempting to create a new VM from scratch
 - [ImportDomain] The attach operation should issue a warning, if the Storage Domain is already attached to another Data Center in another setup
 - old connection is used although of having a different password than a newly added connection
 - [engine-backend] NullPointerException happened during AddDiskCommand
 - Instance type: delta icon (new configuration for next run) does not appear on running pool VMs.
 - [RHEVM][FOREMAN-INTEGRATION] after installing a discovered host via foreman provider, fails to find a nic to attach rhevm bridge to
 - [fencing-policy] engine might select a proxy host that doesn't know how to handle fencing policy
 - Instance type: cluster with compatibility version 3.4 should reject re-run of VM with RNG enabled.
 - [engine-backend] [importDomain] [hosted-engine] import to the hostged engine storage domain (NFS) is allowed
 - [REST-API] Fail to Clone VM from Template to another SD, on disk profile mismatch.
 - 3.5 engine should have 4.16 VDSM version in supportedVdsmVersions field
 - [RHEVM][FOREMAN-INTEGRATION] picking "Use Foreman Hosts Providers" removes the "Use JSON protocol"
 - RHEV: Faulty storage allocation checks when adding a VM Pool with VMs.
 - Network and profile name are missing from cloned vm from snapshot
 - faulty storage allocation checks when adding a vm from template
 - faulty storage allocation checks when adding a vm to a pool
 - [RFE] Bundle GWT symbol maps in GWT application's rpm package
 - [AAA] fix audit/acct/log messages without profile/authn names
 - testJson\*Disk\* failures on F21 build
 - [AAA] no warning when same profile name is specified in multiple extension
 - Issues with rename

### VDSM

**Fixed in oVirt 3.5.1 RC1**
 - [hosted engine] - vdsm needs HA agent configuration before deployment
 - [vdsm][openstacknet] Migration fails for vNIC using OVS + security groups
 - Failed to remove a snapshot after restarting vdsm while creating this snapshot
 - [vdsm] Reconstruct master fails with ResourceTimeout on an EMC-VNX machine
 - ERROR message was shown in vdsm.log on host when VM suspend by RHEVM
 - getUserCpuTuneInfo flooding vdsm log
 - [RFE] Support IO QoS features
 - CentOS 6.5 VMs crash after VM Migration (after upgrading oVirt from 3.4.2 to 3.43)
 - Wrong default multipath configuration for EL6
 - Vm failed to migrate when local maintenance activated in hosted-engine environment
 - vdsClient is not showing the correct information of the VM
 - vdsm-tool sebool-config call fails with AttributeError during vdsmd start
 - [RHEL7] Host reboot after blocking connection to master domain because selinux prevents sanlock from terminating or killing vdsm
 - supervdsm leaks memory when using glusterfs
 - NetworkManager ifups VDSM's reference bond
 - Wrong error message when failing to create a volume on block storage
 - [scale] jsonrpc: restapi: timeout while starting a large number of VMs
 - QOS CPU profile not working when guest agent is not functioning
 - [vdsm] missing 'Author list' value in man vdsm-tool
 - TypeError: argument of type 'NoneType' is not iterable after disk hotunplug
 - [engine-backend] Create command is reported as failed although the VM was started successfully
 - [vdsm] [ppc64] getVdsHardwareInfo incomplete for IBM Power 8
 - Vdsm images use less secure selinux label after a lv is refreshed
 - vdsm-reg: vdsm-reg.log is created but there is no logs there.
 - Unable to restart vdsm on host with running vms
 - [ppc] Host is installed with VDSM version (<UNKNOWN>) and cannot join cluster ppc64...
 - Bogus warnings in jsonrpc infrastructure: "Fixing up type", "fieldClone: type -> deviceType"
 - vdsm-4.14.13-2 sends FC LIP events on storage actions
 - External luns may loose the libvirt selinux label if a udev change event is triggered
 - [Block storage] Basic Live Merge after Delete Snapshot fails
 - cannot put link down on vNIC
 - vdsm does not set selinux booleans during installation when selinux disabled
 - vdsm sometime reports an invalid nic speed of 2\*\*32-1
 - [vdsm] hosted-engine: [iSCSI support] HostedEngine VM is not resumed automatically after EIO
 - [JSONRPC] Extend size operation of an attached iSCSi domain, fail with CDA
 - New FC LUNs are not detected on hypervisor without a reboot
 - createVolume (iscsi) fails on qemu-img create
 - selinux prevents hosted engine to be deployed on RHEL 6.6 with iscsi support
 - [JSONRPC][engine-backend] Live resize is reported as failed while volume extenstion had succeeded
 - supervdsm segfault in libgfapi while querying volume status detail
 - remove vdsm pki private key leak from rhev log collection
 - Starting of VM is slow - error = java.lang.ClassCastException: java.lang.Boolean cannot be cast to java.util.Map
 - Migration via vdsClient not work
 - vdsm sos plugin doesn't work
 - vdsmd service does not start if one of the interfaces is configured in peer mode
 - super VDSM should raise core dump if it crashes
 - vdsm plugin broken for sos >= 3.1
 - Error getting hardware information from an upgraded host
 - Upgrading from 3.4.4 to 3.5.1 snapshot the vdsm rpm throw an exception
 - Failed to restart vdsm after upgrade from 3.4.4 to 3.5.1 snapshot
 - Hosted Engine VM is listed as paused after upgrading from 3.4.4 to 3.5.1 snapshot
 - ioprocess excessive logging in vdsm.log
 - Vdsm reports wrong NIC state, Error while sampling stats
 - Upgrade from RHEV-H 6.5 to RHEV-H 6.6 during upgrade from RHEV 3.4 to RHEV 3.5 Wiped Network Static IPs
 - Excessive cpu usage due to wrong timeout value
 - [engine-backend] [external-provider] Glance integration: UploadImage (Export disk) fails with java.lang.String
 - [JSONRPC] Disk resize fails while vm is down

### ovirt-hosted-engine-ha

**Fixed in oVirt 3.5.1 RC1**
 - Can not launch rhevm as a monitored service as it says after shutdown engine vm
 - agent crashes on wrong metadata
 - Wrong calculation of host score in case of gateway or bridge problem
 - Host that added to HE environment after upgrade from 3.4->3.5 failed to connect to storage

### ovirt-hosted-engine-setup

**Fixed in oVirt 3.5.1 RC1**
 - If another network has the "required" flag a new host will fail and timeout
 - First interaction with hosted-engine --deploy process happening before, that answer file loading
 - Engine vm is not killed after that deployment process aborted
 - answers.conf is replaced if configuration is not complete
 - [TEXT] hosted-engine --deploy should provide better error message when iSCSI luns list is empty
 - Volume creation failed while deploying Hosted Engine on iSCSI
 - Lost all the configuration for hosted engine after reboot rhevh
 - [hosted-engine] [iSCSI support] The LUN used for engine VM disk is allowed to be picked for storage domain creation/extension
 - [hosted-engine] [iSCSI support] Putting an iSCSI domain in maintenance while the hosted-engine is installed on a LUN from the same storage server causes the setup to become non operational
 - [engine-backend] [importDomain] [iSCSI support] hosted-engine: import the hosted-engine's storage domain is allowed
 - Installation of second host failed, when try to fetch answer file IOError: [Errno 2] No such file
 - Error trying to add new hosted-engine host to upgraded Hosted Engine cluster
 - [hosted-engine] Uncoherent 'Cannot add the host to cluster None' error message on SDK failure
 - hosted engine deploy on vlan Cannot acquire bridge address
 - hosted engine deploy on vlan Cannot acquire bridge address
 - migration to additional host fails before restarting HA agent

### ovirt-image-uploader

**Fixed in oVirt 3.5.1 RC1**
 - ERROR: Problem connecting to the REST API. Is the service available and does the CA certificate exist?
 - 40% perf regression in image uploader
 - non-ovf file is not reported properly

### ovirt-iso-uploader

**Fixed in oVirt 3.5.1**
 - Uploading to nfs domain fails with UnboundLocalError
**Fixed in oVirt 3.5.1 RC1**
 - ERROR: Problem connecting to the REST API. Is the service available and does the CA certificate exist?

### ovirt-log-collector

**Fixed in oVirt 3.5.1 RC1**
 - [RHEV] rhevm-log-collector does not gather /etc/ovirt-engine-reports or /etc/ovirt-engine-dwh
 - postgres data is not collected
 - remove password leak from ovirt-engine setup answer file


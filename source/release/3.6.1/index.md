---
title: oVirt 3.6.1 Release Notes
category: documentation
toc: true
authors: fabiand, mskrivan, sandrobonazzola
---

# oVirt 3.6.1 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.1 release as of December 16th, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/). 

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6 stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](/develop/release-management/releases/3.5.6/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide.

### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

## What's New in 3.6.1?

<b>Unable to add/remove objects from PM Proxy Preference list in Power Management tab in Edit Host</b>
In previous version users were able to modify Power Management Proxy Preference of a host only using REST API. The webadmin UI was only showing current values.
In new version users are now able to modify PM Proxy Preference in Advanced Options inside Power Management tab of Host Detail dialog. Valid options of PM Proxy Preference list are:
cluster
\* fencing proxy host is selected from the same cluster as non responsive host dc
\*fencing proxy host is selected from the same data center as non responsive host other_dc
\* fencing proxy host is selected from the different datacenter than non responsive host belongs to The items in PM Proxy Preference are selected by defined order, so for examle PM Proxy Preference list contains:
1. cluster
2. dc
Than engine tries to select fencing proxy from the same cluster as non responsive host first and if no proxy can be selected then engine tries to select fencing proxy from other clusters in the same data center as non responsive host.

<b>Random uuid generated when trying to create new authentication key for cinder external provider</b>
On 'Cinder Provider -> Authentication Keys -> New/Edit Dialog', added the following tool-tip to explain the UUID field: "The provided UUID is auto-generated. It should be entered in the Cinder configuration file. Alternatively, an existing UUID can be specified in the text box.".

<b>[RFE] dynamic log setting</b>
This plugin will enable us to authenticate engine admin users into Jboss's JMX interface. We can either invoke then the jbosscli.sh or jconsole or whatever tool that uses JMX and needs authentication.
* only superusers can login
* only 127.0.0.1 is exposed
* failed login fails noisely - there is no proper error printed to the screen
USAGE:
 $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal COMMAND
if COMMAND is missing it enters interactive mode.
Examples of COMMANDs:
* increase bll log level to debug:
 /subsystem=logging/logger=org.ovirt.engine.core.bll:write-attribute(name=level,value=DEBUG)"
* add logger
 /subsystem=logging/logger=org.ovirt.engine:add
* get the engine data-source statistics:
 ls /subsystem=datasources/data-source=ENGINEDataSource/statistics=jdbc
* get Threading info
 ls /core-service=platform-mbean/type=threading/
See also:
[1] Jboss custom login modules: <https://docs.jboss.org/author/display/AS71/Security+Realms>
[2] CLI recepies - <https://docs.jboss.org/author/display/WFLY8/CLI+Recipes>
 <b>oVirt Live has been rebased on CentOS 7.2</b>

<b>Hosted engine storage domain auto import</b>

## Known issues

*   Use SELinux Permissive mode in order to avoid denials using VDSM and Gluster

<!-- -->

*   SRIOV support API is broken and was re-written in a backward incompatible way in 3.6.1. This bug causes the vm with the attached virtual function to be reported with a disconnected NIC each time it is powered off. We advise people that use this feature to take their VMs down before upgrading to 3.6.1 (or restart vdsm for that matter) or they will lose virtual functions on their hosts. Commits <https://gerrit.ovirt.org/#/q/I689629380996e5615f41e5705fa1f8fb322e0214> and <https://gerrit.ovirt.org/#/q/I9d26df0f850d395c6ef359d9e4c404856e2f649d> (ovirt-engine) fix this.

<!-- -->

*   The oVirt Engine Virtual Appliance changed it's versioning from `ovirt-engine-appliance-<builddate>` to `ovirt-engine-appliance-<ovirt-release>-<builddate>`, this prevents proper upgrades of the *ovirt-engine-appliance* package on hosts. This should normally not be a problem, because the appliance image is used for the **inital installation only**, and not for upgrades. To fix this issue, the *ovirt-engine-appliance* package needs to be reinstalled. The install should pickup the engine appliance following the new version scheme.

### Distribution specific issues

#### Fedora 22

*   on hosts you need to add following line to **/etc/ssh/sshd_config**

      KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1

and then execute

      # systemctl restart sshd

before adding the host to the engine.

#### RHEL 7.1 - CentOS 7.1 and similar

<b>Please update to 7.2 in order to avoid:</b>

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

*   Memory hotplug feature is not working on CentOS 7.1 ( )due to libvirt requirements not available in CentOS 7.1 and missing updated requirement in VDSM spec file.

<!-- -->

*   v2v feature on EL 7.1 requires manual installation of virt-v2v packages. See for more details.

#### RHEL 6.7 - CentOS 6.7 and similar

*   Upgrade of All-in-One on EL6 is not supported in 3.6. VDSM and the packages requiring it are not built anymore for EL6

## Bugs fixed

### oVirt Engine

* [User Portal] Username of logged-in user appears in error dialog instead of pool name
 - Bonding modes 0, 5 and 6 should be avoided for VM networks
 - Bullets are missing from list of warnings presented to user in cases such as when removing a shared disk
 - [webadmin] misaligned example text in edit vNIC dialog
 - Update cluster scheduling policy, with threshold and with properties not update threshold parameters
 - Error message trying to export a disk when no attached External Image provider is misleading
 - Move Disks dialog is very small and has no scrollbars on the Alias and Source fields
 - [RFE] Implement HTML/DOM flag to indicate that GUI is ready for interaction
 - 3.4.4 engine does not support external VMs on ppc hosts and unsupported balloon log spam.
 - Failed to set user defined scheduling policy via REST
 - Host relocation to VM with NUMA pinning, do not drop the old host NUMA pinning
 - Attach disk window is messed up when there are a lot of disks
 - [ja_JP] [es_ES] [User Portal] String broken in 'New or Edit Network Interface' dialog.
 - [Monitoring] Network utilisation is not shown for the VM
 - same pci addr is stored for two vNICs if they are plugged to a running VM one at a time
 - Inconsistent display of required checkboxes in network/clusters tab and manage networks dialog
 - SR-IOV > Add icon to VFs in SetupNetworks
 - Failed to update vm to use preferred numa mode via REST
 - Error while executing action Add NIC to VM: Failed to HotPlugNicVDS, error = unsupported configuration: boot order 5 is already used by another device, code = 49 (Failed with error ACTIVATE_NIC_FAILED and code 49)
 - [vdsm] iSCSI login to a new target while editing a deactivated iSCSI domain doesn't give the exposed LUNs
 - set FF38 as the supported browser for RHEV
 - [SR-IOV] REST API for SR-IOV
 - Failed cleanup of disk entry from database after failed disk copy operation
 - engine API: Missing properties for Instance_types (instancetypes)
 - [New HostSetupNetworksCommand] the old SetupNetworkCommand shouldn't be used internally
 - Host Network QoS should not allow zero values in UI\\REST
 - Failed to create unlimited memory quota limit via REST
 - pg_restore: [archiver (db)] could not execute query: ERROR: language "plpgsql" already exists after upgrade
 - Force remove is missing in hosts tab in mixed gluster\\virt mode.
 - Copy quota fail with error massage
 - Failed to create numa node to pinned vm via REST
 - [Setup Networks] - Improve the drag and drop Interfaces in SN dialog window when trying to create bond/s
 - Message reporting no password is empty
 - The "OK" button should be pressed twice in order to make a template in the "New Template" window
 - [PPC64LE]Failed to start vm with enabled soundcard
 - Layout for login is broken
 - [Admin Portal] No warning/error message when tried to login with blank username/password
 - [ja_JP] [Admin Portal]- The field name alignment needs to be corrected on the login page.
 - Remove deprecated keys from list
 - [ALL LANG] Clicking the button 'New' next to Host Network QoS don't work in New Logical Network->General dialog.
 - [admin portal] top-left corner distorted in New Host dialog with IE 11
 - [de_DE][Admin portal] Truncation observed in language drop-down on login page
 - [engine-setup] PKI CONFIGURATION points to upstream wiki about certificates renewal info
 - Failed to pin cpu of vm that pinned to two hosts
 - Failed to pin vm to host and add numa node to vm in one action
 - Template's disk format is wrong
 - [SR-IOV] - VFs that are a slaves of a bond, shouldn't considered as free
 - [VM Pools][REST-API] setting prestarted vms upon vmPool creation is blocked in UI but not in API
 - Errata dialog is not loaded with the selected filters
 - System Errata query is invoked repeatedly and unnecessarily
 - The 'x' on the top right corner of the errata dialog doesn't close the dialog
 - CoCo infrastructure should provide a timeout for each command to prevent entities to be locked forever.
 - Host move from 'up' to 'connecting' and back to 'up' from time to time
 - Unable to add slave to bond using slave id or modify existing slave using name
 - Add new host, error message not shown
 - [engine-backend] AddStoragePoolWithStorages fails with NullPointerException after iSCSI connection failure
 - [vmconsole] vmconsole permissions violates engine permission scheme
 - vmconsole specific role should be assigned to enable vmconsole access
 - Disk move/migrate dialogues inconsistent
 - Failed to add resource root 'slf4j-jdk14.jar' at path 'slf4j-jdk14.jar'
 - [Per host CHAP] Updating CHAP credentials via storageconnectionextensions with a target that already exist in the DB fails with 'Internal Engine Error'
 - [vmconsole][helper] key list entity is incorrect
 - Unable to add/remove objects from PM Proxy Preference list in Power Management tab in Edit Host
 - Can't login to Admin portal after engine-manage-domains command
 - [ja_JP] The text alignment needs to be corrected on clusters->new->console tab
 - Uncheck "Format Domain, i.e. Storage Content will be lost!" by default
 - [ALL-LANGS] Need to translate a message on virtual machine->errata sub-tab.
 - [ja_JP] Text overlapping observed on virtual machines->run once->host tab.
 - Errors in attach disk to VM window (scrolling error and selection errors)
 - [SR-IOV] - New VM - When choosing passthrough profile (instance type), the type should be automatically pci-passthrough
 - Text overlap observed on storage->general sub-tab
 - [Cinder][Automation] Wrong Error and "disk leftovers"(in db) remain upon deleting 10\* { vms+cinder disk }
 - SpiceX.cab not offered for installation from IE
 - Auto import hosted engine domain
 - deprecated config values may brake the upgrade process
 - It's impossible to create new vNIC on VM with error that MAC is already in use (when switching MAC pools)
 - Vm nic unplugged after previewing/undoing a snapshot
 - engine database has some missing indexes
 - [engine-backend] Undesired handling with a UnsupportedGlusterVolumeReplicaCountError from vdsm
 - [Cinder][API] Attaching Volumes from datacenter 'A' to a non member VM should return CDA=False
 - [Old SetupNetworks API] cannot attach network to BOND
 - ovirt-engine service cannot detect jboss version if service already run and debug port enabled
 - [Old SetupNetworks API] cannot attach VLAN network to BOND
 - [Cinder] Cinder disk with ceph backend actual size is not '0'
 - [SR-IOV] - Edit VMs vNIC - when choosing a 'passthrough' profile, the type should be automatically 'pci-passthrough' type
 - Connect in fullscreen mode is not working with spice-xpi
 - Log should append to log file not override
 - [Setup Networks] UI - Network's tooltip preventing from dragging the network and attaching it to the NIC/s below(if it's already attached to a NIC)
 - Fields "Console User" and "Console Client IP" stuck in N/A state (while field "Logged-in User" provides actual information.)
 - USB Auto-Share is not working with spice-xpi
 - Engine- Support initial allocation size for volume on block storage in order to allow v2v to complete
 - OVF file is removed for any given VM when only a direct LUN disk is attached to it
 - [hosted-engine-setup] [block storage] Cannot import the hosted-engine storage domain because its LUN is written in the engine DB as a direct LUN
 - Cinder snapshot id doesn't appear under "disk snapshot ID" tab after creating a snapshot
 - [SR-IOV] - Block Hotplug/unplug 'pci-passthrough' vNIC types on 3.6
 - NPE on CreateCinderSnapshot - negative flow
 - Do not initialize disabled extensions
 - Random uuid generated when trying to create new authentication key for cinder external provider
 - Cinder disk size is not formatted to GB in "Edit virtual machine" window
 - [API][Host network QoS] Update for existing Host Network QoS fails with internal server error
 - [SR-IOV] - 'pci-passthrough' vNIC reported as unplugged in UI once running the VM, although the vNICs state is UP and plugged
 - [ppc64le] After cloning a vm from a template, vm fails to start with XML error: target 'sda' duplicated for disk sources
 - Upgrade WildFly to 8.2.1
 - [Cinder] Copy template button should be greyed out in case of cinder template
 - [Cinder] Copy template operation should be Blocked in case of cinder template
 - Template with cinder disk display allocation-policy under disks tab
 - [UX][Cinder] Create new Vm's sub-tab attach disk offers wrong cinder volumes
 - Wrong message when moving a host to another cluster with different management network
 - [Cinder] When cinder conf allows X volumes, engine actually allows X-1 cinder volumes to be created
 - Importing an image from glance never finishes
 - When adding a new direct lun from the REST API, the lun's size appears to be not up to date
 - setupNetworks UI | internal engine error when break BOND and remove label in one action
 - [REST API] Host list don't appear under placement_policy after update VM to pinned
 - [z-stream clone 3.6.z] Whenever an exception is thrown in the front end code, unrelated parts of the GUI tend to stop working (e.g. 'new' and 'import' buttons under Networks tab)
 - VM can be started with incompatible CPU and guest OS
 - [3.6.z clone] remove ie8 permutations from GWT compilation
 - registration of ceph secrets isn't being executed upon host activation
 - Allow opteron_g2 and newer CPUs for Windows 10 guest OS
 - Failed to import virtual machine when select VMware as source on rhevm3.6 server
 - Creating a Cinder snapshot after committing a snapshot containing a Cinder disk, results two volumes with the same vm_snapshot_id.
 - [Cinder] creation of a snapshot with multiple cinder disks is reported as failed
 - NullPointer exception reported when vdsm erroneously report storage pools as R/O
 - Remove of Cinder disks should remove one volume at a time from the leaf volume up to the base volume.
 - after adding a new host from foreman using provisioned hosts, host_provider_id field in db is empty
 - Not able to upgrade hypervisor using Ovirt engine api
 - Error message doesn't appear when trying to create storage domain with path that already exists in the system
 - Attach disk does not work in user portal
 - unregistration of ceph secrets isn't being executed upon host deactivation
 - remove jpa definitions from the engine deployment configuration
 - [SR-IOV] - vNIC's custom properties are not passed in case of a VF(passthrough vNIC type)
 - [engine-manage-domains] Cannot handle domain in upper-case
 - Clusters with no management network after upgrade
 - Block import VM from external system on PPC
 - Can't connect to guest-VM created from template via serial console.
 - Actual size of disk to be exported to glance external storage provider is displayed as <1
 - rhevm web shows incomplete RHEV-H OS Version information
 - CONNECT_TO_SERIAL_CONSOLE translation/caption missing
 - hostdev_passthrough: VM "spec_params" values are empty in engine DB.
 - Incorrect user and group identifiers aren't handled correctly
 - Create vm from template hangs forever when template on multiple domains, and first domain is not active
 - Cannot export VM with RAM snapshots
 - [Fedora Only] engine-backup fails with: tar: '--same-order' cannot be used with '-c'
 - MoveOrCopyDisk - source disk remains locked in memory
 - MoveOrCopyDisk - target disk isn't locked during the operation
 - if the ovirt-engine-setup-plugin-dockerc is present, engine-clenup will try to connect to docker also if we didn't deployed any container
 - Tables in errata tabs are not sortable
 - Template creation task after upgrade isn't marked as finished
 - errata tabs in webadmin only show the first 20 errata
 - When performing rollback and failing to delete the disk it'll remain LOCKED (Context is always passed on rollback)
 - VMware environment cannot be added as external provider.
 - [Cinder] Create Snapshot skips cinder Deactivated disks, it results in data loss
 - oVirt 3.6: translation cycle 5 tracker
 - Cannot export VM with RAM snapshots
 - No version filter for Datacenters when adding an openstack volume.
 - New vNIC/edit - The vNIC type for VMs is 'pci-passthourh' by default for all profiles, regular and passthrough ones
 - Uncaught exception when trying to move a disk (when there is no active storage domain in the data center to move the disk to)
 - 'Uncaught exception occurred' message when removing a VM while Snapshots sub-tab selected
 - oVirt 3.6: translation cycle 6 tracker
 - Failed to upgrade DC compatibility version from 3.4 to 3.5 after upgrading hosts
 - Wrong JSON format in AutoRecoveryAllowedTypes config value
 - change default heartbeat interval to 30

### VDSM

* [oVirt][VDSM] Consume fix for "sanlock.get_hosts() off-by-one error when specifying the hostId argument"
 - [vdsm] vdsm ProtocolDetector.SSLHandshakeDispatcher ERROR Error during handshake: sslv3 alert certificate unknown
 - [PATCH] Please depend on policycoreutils-python-utils
 - [scale] VDSM thread leak with unresponsive storage
 - [El7.2] consume fix for "libvirt reports physical=0 for COW2 volumes on block storage"
 - Consume fix for "Multipath is not correctly identifying iscsi devices, and misconfiguring them"
 - KSM sleep_millisecs bellow 10ms for systems above 16GB of RAM
 - Setupnetworks fails from time to time with error 'Failed to bring interface up'
 - [SR-IOV] - 'pci-passthrough' vNIC reported as unplugged in UI once running the VM, although the vNICs state is UP and plugged
 - bonding option "primary" is considered invalid by vdsm
 - Consume fix for "multipathd: uevent trigger error"
 - [vdsm] logrotate for /var/log/core again not working
 - Auto import hosted engine domain
 - [Host QoS] - Host QoS is not working for vlan tagged networks
 - Remove obtain_device_list_from_udev from vdsm private lvm configuration
 - Consume fix for "pvchange fails to find physical volume" in lvm pacakge
 - [SR-IOV] - vdsm.log is spammed with KeyError: 'net.0.name' error messages while running VM with 'pci-passthrough' vNIC/s
 - vdsm fails to start due to incorrect permissions on /tmp/ovirt.log
 - rhev3.6 should support "folder of files" and "zip" format when select OVA as source while importing vms
 - After upgrade from 3.5 to 3.6 host still have old package vdsm-python-zombiereaper-4.16.28-1.el7ev.noarch
 - Cannot find Master Domain
 - improve thread usage in VDSM requests
 - vdsm_3.6_build-artifacts-fc23-x86_64 failing due to missing dep on rpm-python
 - Errors when resizing devices after disconnecting storage server during maintenance flow
 - Host under maintenance still have sanlock lockspaces which prevents the upgrade of the sanlock package
 - Cannot export VM with RAM snapshots
 - VDSM failure on RNG device conf on VM migration after upgrade to oVirt 3.6
 - [RHEV-H] - setupNetworks fail sometimes with error OSError: [Errno 16] Device or resource busy
 - support new libvirt events
 - Duplicate gluster servers appear in backup-volfile-servers
 - Vdsm daemon failed to start, because incorrect cpu affinity

### oVirt Hosted Engine HA

**oVirt 3.6.1 Async release**
 - [upgrade] the upgrade from 3.5 to 3.6 can fail if interrupted in the middle and restarted after a reboot
 - ovirt-ha-agent should explicitly fail if the configuration volume is not valid
 - HE agent failed to start on RHEV-H after upgrade from 3.5 to 3.6
 - Emails sent from broker have "corrupted" headers
 - StorageDomainIsMemberOfPool prevents hosted-engine upgrade
 - Different behavior of connectStorageServer and prepareImage between iSCSI and NFS
 - HE-VM cannot startup automatically after successful configure HE
 - Failed to startup HE-VM after upgrade RHEV-H7.1-20151015 to RHEV-H7.2-20151104 (Device or resource busy)
 **oVirt 3.6.1**
 - Handle crash of both ha services: agent and broker.
 - After storage problem, host not show correct metadata
 - the agent should avoid trying to upgrade the host if it's not in maintenance mode
 - [logging] some of low level operation logs got losts
 - [upgrade] broker.conf got overwritten with initial defaults during 3.5 -> 3.6 upgrade
 - [upgrade] possible race condition upgrading different hosts
 - Host under maintenance still have sanlock lockspaces which prevents the upgrade of the sanlock package

### oVirt Hosted Engine Setup

* hosted-engine --deploy (additional host) will fail if the engine is not using the default self-signed CA
 - [TEXT] Warn the administrator that CD/DVD passthrough is disabled for RHEL7
 - [hsoted-engine] adding second host fails with: "SSL3_GET_SERVER_CERTIFICATE:certificate verify failed"
 - hosted-engine-setup fails acquiring CA.crt with a 404 error
 - Enforce engine VM memory configuration against available memory
 - hosted-engine accepts FQDNs with underscore while the engine correctly fails on that
 - On additional hosts, hosted-engine-setup lets the user specify an interface for the managemnt bridge but ignores it
 - 'Destroy VM and abort setup' fails when the setup is trying to add the host to the engine
 - [hosted-engine-setup] [block storage] Cannot import the hosted-engine storage domain because its LUN is written in the engine DB as a direct LUN
 - [CI] Increasing again timeouts to avoid false positives on CI jobs
 - [logging] some of low level operation logs got losts
 - [node] hosted-engine-setup will not ask about appliance memory if the appliance OVA path is passed via answerfile
 - Hosted engine setup fails when VDSM is slow to initialize
 - If first host deployed in insecure mode, second host deployment failed
 - with 3.6.1, on additional hosts, the deploy fails with 'RuntimeError: Dirty Storage Domain: Cannot find master domain...'

### oVirt Engine Extension AAA JDBC

* [aaa-jdbc-extension] Add support for nested group resolution on login
 - [aaa-jdbc-tool] Add support for removal of nested users/groups
 - NPE when trying to show nonexisting group via group-manage command
 - Unclear message if aaa-jdbc schema is not synced with package version
 - Database connections are not properly closed

### oVirt Data Warehouse

* [TEXT ONLY] Data Warehouse service is incorrectly labeled as 'Dataware House'

### oVirt Reports

* ovirt-engine-reports-tool handles relative export/import paths wrongly

### Other packages updated

*   ovirt-engine-wildfly-overlay
*   ovirt-engine-wildfly
*   ovirt-engine-cli
*   ovirt-host-deploy


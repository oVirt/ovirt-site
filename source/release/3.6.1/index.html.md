---
title: OVirt 3.6.1 Release Notes
category: documentation
authors: fabiand, mskrivan, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.6.1 Release Notes
wiki_revision_count: 42
wiki_last_updated: 2016-01-26
---

# OVirt 3.6.1 Release Notes

<big><big>DRAFT</big></big>
The oVirt Project is pleased to announce the availability of oVirt 3.6.1 first release candidate as of <date>.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.1, CentOS Linux 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](http://www.ovirt.org/Category:Releases). For a general overview of oVirt, read [ the Quick Start Guide](Quick_Start_Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

### CANDIDATE RELEASE

In order to install oVirt 3.6.1 Release Candidate you've to enable oVirt 3.6 release candidate repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.6.repo**

**For CentOS / RHEL:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever`](http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6)

**For Fedora:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever`](http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.1 on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.5 Release Notes](oVirt 3.5.5 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/)

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

## Known issues

*   Use SELinux Permissive mode in order to avoid denials using VDSM and Gluster

<!-- -->

*   If cluster is updated to compatibility version 3.6 while hosts that have not been upgraded, i.e with emulated machine flags that do not match cluster compatibility version 3.6, you might end up with incorrect emulated machine flag on the cluster. As a result, you will not be able to run VMs. Possible workarounds would be to to reset the emulated machine on the cluster (requires putting all the hosts into maintenance) or disable the host-plug memory feature in the database.

<!-- -->

*   SRIOV support API is broken and was re-written in a backward incompatible way in 3.6.1. This bug causes the vm with the attached virtual function to be reported with a disconnected NIC each time it is powered off. We advise people that use this feature to take their VMs down before upgrading to 3.6.1 (or restart vdsm for that matter) or they will lose virtual functions on their hosts. Commits <https://gerrit.ovirt.org/#/q/I689629380996e5615f41e5705fa1f8fb322e0214> and <https://gerrit.ovirt.org/#/q/I9d26df0f850d395c6ef359d9e4c404856e2f649d> (ovirt-engine) fix this.

### Distribution specific issues

#### Fedora 22

*   on hosts you need to add following line to **/etc/ssh/sshd_config**

      KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1

and then execute

      # systemctl restart sshd

before adding the host to the engine.

#### RHEL 7.1 - CentOS 7.1 and similar

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

*   v2v feature on EL 7.1 requires manual installation of virt-v2v packages. See for more details. This workaround will not be needed once EL 7.2 is out

#### RHEL 6.7 - CentOS 6.7 and similar

*   Upgrade of All-in-One on EL6 is not supported in 3.6. VDSM and the packages requiring it are not built anymore for EL6

## Bugs fixed

### oVirt Engine

* [User Portal] Username of logged-in user appears in error dialog instead of pool name
 - Bonding modes 0, 5 and 6 should be avoided for VM networks
 - Bullets are missing from list of warnings presented to user in cases such as when removing a shared disk
 - [webadmin] misaligned example text in edit vNIC dialog
 - Error message trying to export a disk when no attached External Image provider is misleading
 - Move Disks dialog is very small and has no scrollbars on the Alias and Source fields
 - [RFE] Implement HTML/DOM flag to indicate that GUI is ready for interaction
 - 3.4.4 engine does not support external VMs on ppc hosts and unsupported balloon log spam.
 - Failed to set user defined scheduling policy via REST
 - Attach disk window is messed up when there are a lot of disks
 - [Monitoring] Network utilisation is not shown for the VM
 - Inconsistent display of required checkboxes in network/clusters tab and manage networks dialog
 - SR-IOV > Add icon to VFs in SetupNetworks
 - Failed to update vm to use preferred numa mode via REST
 - Error while executing action Add NIC to VM: Failed to HotPlugNicVDS, error = unsupported configuration: boot order 5 is already used by another device, code = 49 (Failed with error ACTIVATE_NIC_FAILED and code 49)
 - [vdsm] iSCSI login to a new target while editing a deactivated iSCSI domain doesn't give the exposed LUNs
 - set FF38 as the supported browser for RHEV
 - [SR-IOV] REST API for SR-IOV
 - engine API: Missing properties for Instance_types (instancetypes)
 - [New HostSetupNetworksCommand] the old SetupNetworkCommand shouldn't be used internally
 - Failed to create unlimited memory quota limit via REST
 - pg_restore: [archiver (db)] could not execute query: ERROR: language "plpgsql" already exists after upgrade
 - Copy quota fail with error massage
 - Failed to create numa node to pinned vm via REST
 - Message reporting no password is empty
 - Host installation fails or host activation fails with NPE if numaNodeDistance is null
 - The "OK" button should be pressed twice in order to make a template in the "New Template" window
 - [PPC64LE]Failed to start vm with enabled soundcard
 - [PPC64LE] Failed to create vm via REST without define display type
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
 - It is not possible to reselect the same icon in Chrome and IE
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
 - deprecated config values may brake the upgrade process
 - engine database has some missing indexes
 - [engine-backend] Undesired handling with a UnsupportedGlusterVolumeReplicaCountError from vdsm
 - [Cinder][API] Attaching Volumes from datacenter 'A' to a non member VM should return CDA=False
 - Failed to add RHEV-H 3.5.z-7.1 host to RHEV-M 3.6 with 3.5 cluster due to missing ovirtmgmt network.
 - [Old SetupNetworks API] cannot attach network to BOND
 - ovirt-engine service cannot detect jboss version if service already run and debug port enabled
 - [Old SetupNetworks API] cannot attach VLAN network to BOND
 - [Cinder] Cinder disk with ceph backend actual size is not '0'
 - [SR-IOV] - Edit VMs vNIC - when choosing a 'passthrough' profile, the type should be automatically 'pci-passthrough' type
 - Failed to remove Data Center
 - Connect in fullscreen mode is not working with spice-xpi
 - Log should append to log file not override
 - USB Auto-Share is not working with spice-xpi
 - Engine- Support initial allocation size for volume on block storage in order to allow v2v to complete
 - OVF file is removed for any given VM when only a direct LUN disk is attached to it
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
 - Not able to upgrade hypervisor using Ovirt engine api
 - Error message doesn't appear when trying to create storage domain with path that already exists in the system
 - Attach disk does not work in user portal
 - unregistration of ceph secrets isn't being executed upon host deactivation
 - remove jpa definitions from the engine deployment configuration
 - [SR-IOV] - vNIC's custom properties are not passed in case of a VF(passthrough vNIC type)
 - [engine-manage-domains] Cannot handle domain in upper-case
 - Clusters with no management network after upgrade
 - Live Merge - request to remove images deleted db records without performing merge
 - Block import VM from external system on PPC
 - Actual size of disk to be exported to glance external storage provider is displayed as <1
 - rhevm web shows incomplete RHEV-H OS Version information
 - Incorrect user and group identifiers aren't handled correctly
 - Create vm from template hangs forever when template on multiple domains, and first domain is not active
 - [Fedora Only] engine-backup fails with: tar: '--same-order' cannot be used with '-c'
 - if the ovirt-engine-setup-plugin-dockerc is present, engine-clenup will try to connect to docker also if we didn't deployed any container
 - Tables in errata tabs are not sortable
 - [Cinder] Create Snapshot skips cinder Deactivated disks, it results in data loss
 - oVirt 3.6: translation cycle 5 tracker
 - Cannot export VM with RAM snapshots

### VDSM

* [oVirt][VDSM] Consume fix for "sanlock.get_hosts() off-by-one error when specifying the hostId argument"
 - [vdsm] vdsm ProtocolDetector.SSLHandshakeDispatcher ERROR Error during handshake: sslv3 alert certificate unknown
 - [PATCH] Please depend on policycoreutils-python-utils
 - VDSM thread leak with unresponsive storage
 - Consume fix for "Multipath is not correctly identifying iscsi devices, and misconfiguring them"
 - KSM sleep_millisecs bellow 10ms for systems above 16GB of RAM
 - Setupnetworks fails from time to time with error 'Failed to bring interface up'
 - [SR-IOV] - 'pci-passthrough' vNIC reported as unplugged in UI once running the VM, although the vNICs state is UP and plugged
 - bonding option "primary" is considered invalid by vdsm
 - [vdsm] logrotate for /var/log/core again not working
 - [Host QoS] - Host QoS is not working for vlan tagged networks
 - Remove obtain_device_list_from_udev from vdsm private lvm configuration
 - Consume fix for "pvchange fails to find physical volume" in lvm pacakge
 - [SR-IOV] - vdsm.log is spammed with KeyError: 'net.0.name' error messages while running VM with 'pci-passthrough' vNIC/s
 - vdsm fails to start due to incorrect permissions on /tmp/ovirt.log
 - rhev3.6 should support "folder of files" and "zip" format when select OVA as source while importing vms
 - After upgrade from 3.5 to 3.6 host still have old package vdsm-python-zombiereaper-4.16.28-1.el7ev.noarch
 - Cannot find Master Domain
 - enable vdsm taskset pinning by default
 - improve thread usage in VDSM requests
 - vdsm_3.6_build-artifacts-fc23-x86_64 failing due to missing dep on rpm-python
 - Errors when resizing devices after disconnecting storage server during maintenance flow

### oVirt Hosted Engine HA

* Handle crash of both ha services: agent and broker.
 - After storage problem, host not show correct metadata
 - [logging] some of low level operation logs got losts
 - [upgrade] broker.conf got overwritten with initial defaults during 3.5 -> 3.6 upgrade
 - [upgrade] possible race condition upgrading different hosts

### oVirt Hosted Engine Setup

* hosted-engine --deploy (additional host) will fail if the engine is not using the default self-signed CA
 - [TEXT] Warn the administrator that CD/DVD passthrough is disabled for RHEL7
 - [hsoted-engine] adding second host fails with: "SSL3_GET_SERVER_CERTIFICATE:certificate verify failed"
 - hosted-engine-setup fails acquiring CA.crt with a 404 error
 - Enforce engine VM memory configuration against available memory
 - hosted-engine accepts FQDNs with underscore while the engine correctly fails on that
 - On additional hosts, hosted-engine-setup lets the user specify an interface for the managemnt bridge but ignores it
 - 'Destroy VM and abort setup' fails when the setup is trying to add the host to the engine
 - [CI] Increasing again timeouts to avoid false positives on CI jobs
 - [logging] some of low level operation logs got losts
 - [node] hosted-engine-setup will not ask about appliance memory if the appliance OVA path is passed via answerfile

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

<Category:Documentation> <Category:Releases>

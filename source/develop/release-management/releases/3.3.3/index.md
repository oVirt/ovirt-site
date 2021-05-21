---
title: oVirt 3.3.3 release notes
category: documentation
toc: true
authors:
  - bproffitt
  - dougsland
  - sandrobonazzola
---

# oVirt 3.3.3 release notes

The oVirt Project is pleased to announce the availability of oVirt 3.3.3 release

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features that were added in previous oVirt releases, check out the [oVirt 3.3.2 release notes](/develop/release-management/releases/3.3.2/), [oVirt 3.3.1 release notes](/develop/release-management/releases/3.3.1/), [oVirt 3.3 release notes](/develop/release-management/releases/3.3/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/), and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/).

For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide.html) and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


**IMPORTANT NOTE:** If you're upgrading from a previous version please update ovirt-release to latest version (10) and ensure you've **ovirt-3.3.3** and **ovirt-stable** repository enabled.

      # yum update ovirt-release
      # yum repolist enabled

If you're upgrading from oVirt 3.3, you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2, you should read [oVirt 3.2 to 3.3 upgrade](/develop/release-management/releases/3.2/to-3.3-upgrade.html)

If you're upgrading from oVirt 3.1, you should upgrade to 3.2 before upgrading to 3.3.3. Please read [oVirt 3.1 to 3.2 upgrade](/develop/release-management/releases/3.1/to-3.2-upgrade.html) before starting the upgrade.
 On CentOS and RHEL: For upgrading to 3.2 you'll need the 3.2 stable repository.
So, the first step is disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

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

## What's New in 3.3.3?

## Known issues

*   EL >= 6.5 or cloud-init >= 0.7.2 are needed for cloud-init feature support ()

## Bugs fixed

### oVirt Engine

* [RHEVM-RHS] Remove rebalance and replace-brick actions from REST API
 - [es_ES] change spanish translation for "poweroff", at the moment it is the same word "apagar"
 - [RHEVM-RHS] Should check for gluster capabilities when moving host from virt to gluster cluster
 - (PENDING RC BUILD) PRD33 - set marketplace link/icon
 - [oVirt] [provider] Add button shouldn't appear on specific provider
 - cloud-init integration - REST API
 - [rhevm] Webadmin - Events - Search box with value "Events: Templates =\*" gives error (Exception message is StatementCallback)
 - [GlusterFS] Default option on GlusterFS Data Center in Storage Type is ISO/ POSIX compliant FS
 - When run multiple vms then filter don't check correctly free resources.
 - [RHEVM] cannot upgrade RHEVM 3.2 to RHEVM 3.3 because of rhevm-tools-3.3.0-0.22.master.el6ev.noarch Requires: rhevm-notification-service = 3.2.3-0.43.el6ev
 - Fencing flow fails to get to secondary PM (primary is deliberately configured with wrong params)
 - The $action and the $type aren't set in the change cd command.
 - optimize scheduling for speed
 - Scheduling: allow overbooking resources
 - async between masterVersion : can't connect to StoragePool
 - Plaintext user passwords in async_tasks database
 - CPU pinning option is not available for the VMs running on "Local on Host" type DataCenter.
 - engine-setup incorrectly directs users to use firewall-cmd on RHEL when it's only available on Fedora
 - engine-setup after 'engine-backup --mode=restore' does not fix everything
 - [RHSC][scale-test] Create Volume Results In "Error while executing action"
 - [engine-backend] LSM fails due to another operation (attaching the disk snapshot to another VM), which was started after it and managed to take the lock on the disk
 - [ovirt-setup] engine-setup does not configure firewall properly on upgrade
 - CpuOverCommitDuration not working correctly in cluster policies
 - Incorrect error message when trying to import network with invalid name from network provider
 - NPE: CanDoActionFailure - Import a vm that has memory state snapshot
 - Trying to add VNIC profile from "Edit Logical Network" window fails with error message
 - It is possible to create several VNIC profile with the same name for the specific network
 - [REST-API] XSD schema validation error: 'vnic_profile': Missing child element(s)
 - [REST-API] XSD schema validation error: Element 'payload': Missing child element(s).
 - [upgrade] upgrade 3.2 => 3.3 failed - password authentication failed for user "rhevm"
 - VM stays locked, in being migrated state, even after migration failed.
 - Issues during database cleanup after upgrade
 - [RHEVM] setup should be more tolerant detecting available memory
 - Upgrade fails if postgres owned temporary table exists in engine database
 - limitation for maximum VirtIO-SCSI disks should be removed
 - [scale-test] Create Volume Results In "Error while executing action"
 - Path to image under glance storage domain not correct
 - rhevm-manage-domains fails to update ldapServers entries when using action=edit
 - [RHEVM][backend] cannot add vNIC with custom MAC address to VM if there is no adresses left in MAC Address Pool.
 - Spelling correction
 - [Admin Portal] [java.lang.NullPointerException] No msg/event when prestarted pooled VM cannot be started because of low memory
 - Setting shmmax on F19 is not enough for starting postgres
 - Pending memory is not decremented during VM migration
 - Even distribution policy selects the same host where there is no CPU load on the host
 - Power Managment with cisco_ucs problem
 - NIC selection shows but it is not part of VM creation.
 - An attempt to create a vnic profile is made each time a vm network is being updated
 - RPM packages built without .pyc/.pyo files
 - Webadmin & User Portal: set secure-channels property in .vv files
 - [RHEVM] user is not forced to unplug vNIC when switching to profile without port mirroring
 - Cannot add hypervisor host when use chinese support
 - [RHEV-RHS] Disable 'rebalance' from RHEVM UI, as its partial in implementation
 - [engine-backend] guest alignment scan fails on file storage
 - [REST-API] misleading error message, for moving hosts between clusters
 - [engine-backend] deadlock in postgres during multiple AddVmFromTemplate threads
 - [oVirt] Disabled Balloon in Add Vm
 - Rollback of setup seems to remove several configuration files when upgrade is ran again setup will prompt for hostname and other data
 - upgrade from 3.2 with remote db user 'postgres' is not recognized as an upgrade
 - Storage and dc are up although there is no host

### VDSM

### ovirt-node-plugin-vdsm

* Use Management class to pass informations


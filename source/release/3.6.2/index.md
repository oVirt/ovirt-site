---
title: oVirt 3.6.2 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 3.6.2 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.2 release as of January 26th, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](/develop/release-management/releases/3.5.6/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup


### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

## What's New in 3.6.2?

<b>Provided feedback about the status of the recovery</b>
More logs have been added improving feedback during the recovery flow helping the administrator understanding what VDSM is doing during the recovery, and providing progress report.
 <b>Rebalance option have been disabled on the menu for non-distributed volumes</b>
 <b>Host in maintenance mode now stop glusterd and glusterfsd processes</b>
 <b>Host activation now restart glusterd</b>
 <b>DNF support</b>
ovirt-engine-setup used to rely on yum compatibility layer to work on recent distributions that comes with DNF package manager installed by default. Now it can work directly with DNF package manager.
 <b>MOM performance have been improved</b>
 <b>Added the ability to override the Storage Domain name field</b>
This changed field will be reflected in the engine DB and in the GUI but will not get updated in the Storage Domain metadata until the user will update the Storage Domain once it is active.
Once a Storage Domain will be imported, if the name field will be blank then the value from the Storage Domain metadata will be initialized, otherwise the fields which were provided in the user request will be used.

## Known Issues

* engine-setup --offline does not update versionlock
Cause: a bug in engine-setup running in offline mode

Consequence: cause version lock wasn't written inside the appliance on versions < 3.6.2: yum update cause ovirt-engine packages to be updated without a database update by engine-setup.

Workaround (if any): avoid to use --offline on verson < 3.6.2; in hosted-engine deployment with the appliance avoid to use the automatic setup. When upgrading appliance from a previous version to 3.6.2 be sure to upgrade setup packages only: yum update "ovirt-engine-setup\*" and then run engine-setup.

## Bugs fixed

### oVirt Engine

* engine-setup --offline does not update versionlock
 - missing separators on Host -> Network interfaces subtab
 - [RFE] support dnf
 - [GUI]>[SetupNetworks]> Bonding mode > validate custom bond modes
 - Bad name <UNKNOWN> in live merge of snapshot disk
 - [RFE][HC] Host in maintenance mode should stop glusterd and glusterfsd processes
 - [New] - using same mount point while creating brick gives unexpected exception.
 - [TEXT] - Improve error message for detaching network that is in use by VM/VMs from SetupNetwork. Error message is grammatically incorrect (singular vs plural) and confusing
 - [New] - sync all the storage devices to UI when user adds the host.
 - [Quota] Storage Quota size is calculated twice for floating disks.
 - Live Merge - in certain failure cases engine may not correctly mark merged snapshots in the database
 - engine-backup does not fail cleanly when parsing arguments
 - ISO on Gluster should be a viable option
 - Can't detach/remove a local SD from local DC.
 - Misleading audit log when deactivating a storage domain
 - Administration Portal- New cluster, CPU Type: IBM POWER 8 should be IBM POWER8
 - Host becomes non-operational when activating it from maintenance mode, if you have a required network that was never used
 - [virt-v2v] Import a VM using virt-v2v of a VM which is currently in lock status will cause an uninitialzed CDA message
 - [New HostSetupNetworks] if no changes were done- setup networks shouldn't be invoked
 - Commit a previewed snapshot with Cinder disk should remove all its "children" snapshots
 - [Cinder] Commit a previewed snapshot with Cinder disk should remove orphaned disks
 - Storage domain remains in 'preparing for maintenance' when there is a non operational host
 - [SR-IOV] - Updating vNIC profile that has QoS configured to be with [Unlimited] as well with checking the 'passthrough' checkbox will trigger the latest QoS configured on the vNIC profile
 - Tabs listed thrice once gluster-monitoring-uiplugins installed
 - 'unmanaged' network displayed as 'unsynced' network on the Out-of-sync column under [Hosts]>Network Interfaces
 - Hosts stuck in 'connecting' status while running automation tests
 - [UI] html tag leaks to UI
 - RHEV-M upgrade to 3.5.4 fails with error "Command '/usr/bin/openssl' failed to execute" for custom apache.p12
 - [vmconsole] ovirt-vmconsole-list.py does not create secure ssl session
 - Rest allows the creation of too much numa nodes
 - Setting Prefix on a network instead of netmask recognized as a difference and network considered as unsynced
 - [Host QoS] - Engine calculate and report wrong Host QoS values(zero)
 - [New HostSetupNetworksCommand] - Marking gateway configuration as Out-of-sync
 - [Cinder] Stateless VM fails to start with NullPointerException, operation does not rollback
 - Add Affinity Rules Enforcement Manager interval to engine-config
 - Adding IP(manually) to new network that was created via rest api and attached to host is not marked as out-of-sync
 - [HostDev] - Failing to run VM with host device - pci 82576 VF (0x10ca) attached to VM because the host device considered as unavailable
 - No unit next to the "limit" textbox in the QoS Create/Edit dialog
 - [API][Host network QoS] Removing the host network QoS from network on DC fails and QoS still exists on network
 - Can't add Nehalem processor host to 3.5 Compat mode and gets in endless loop error
 - Balloon device should be enabled by default for new VMs
 - Can't update template display disconnect action
 - rename SSH port to port for some fence agents
 - [SR-IOV] - UI clusters less than 3.6 - 'passthrough' checkbox appears in vNIC profile dialog and 'pci-passthrough' type is part of the type list in the vNIC's dialog
 - Hosts list under host tab shows previously cluster hosts list.
 - Live snapshot's ram and conf volumes are not removed upon Vm deletion, in case of comiting snapshot
 - [Cinder] ThawVDSCommand fails when taking live snapshot without a guest agent
 - [RHEVM 3.5.5] Pool's "custom properties" are not saved
 - LSM fails when one of the vm's disks is located on domain in maintenance
 - [host-update-manager] Info 'A new version is available...' visible even upgrade is in progress
 - USB Device passthrough should not be disabled when host doesn't support PCI passthrough
 - Support NFS v4.1 connections
 - [template-version] Base template does not have <version> attribute
 - Add vmpool doesn't have <use_latest_template_version> tag as opposed to Add vm
 - Fields in configure will not drag to expand.
 - foreman integration: remove "nested" attribute from parameters dict
 - [Admin Portal] Cannot edit DC properties after upgrade from 3.5 - MAC Address Pool complains about invalid MAC address
 - Uncaught exception when creating new VM from template
 - block moving a host to 3.6 cluster if the host doesn't work with jsonrpc
 - engine-setup should not depend on yum groups
 - v2v: add cluster field to "import" and "add external provider" dialogs.
 - Optimizing the volume for virt-store, during volume creation throws error
 - Add support for named bond modes for vdsm 3.5 in engine 3.6
 - Uncaught javascript NPE when attempting to Edit VM
 - Create snapshot fails when one of the vm's disks is located on domain in maintenance
 - [REST-API] [cloud init] Can't set user different than 'root' in RunOnce
 - [cinder] Warning massage should appear when trying to hot-plug cinder disk with IDE interface
 - The /clusters resource uses the "All-Content: true" header, but it isn't documented
 - [cinder] image is locked infinitely after engine restart was performed, during a make template of a VM with cinder disks
 - [events] Missing whitespace - Message: Power Management test failed for Host$host.No reason was returned for this operation failure. See logs for further details.
 - [Cinder] Stateless VM with Cinder disk should be based on a cloned disk instead of a stateless snapshot.
 - [cinder] Restarting engine during create VM from template: cinder disk is created, rollback failure (no VM)
 - [WebAdmin] - Error message appears in the UI "Uncaught exception occurred. Please try reloading the page." while pressing the 'Import' button in the VM Import sub tab, under Storage main tab
 - [engine-webadmin] Copy floating/attached to a VM disk event log describes template copy
 - Disk description can be updated when the disk is locked during a live disk migration
 - [REST-API] rsdl: 'provisioned_size' tag is not under 'disk' tag for add disk
 - Misleading audit log :Refresh image list failed for domain(s): ISO_DOMAIN (Unknown file type)
 - New vNIC - It takes time for the profile to be loaded
 - [Glance] Wrong size of image in import window
 - A non-management network is allowed to be chosen as a host gateway
 - Rebalance option to be disabled on the menu for non-distributed volumes
 - listing iso domain fails with NPE where there's no iso domain in system.
 - Live merge: Engine must refresh resized volume on HSM prior to starting merge
 - [ppc64le][REST API] Failed to update vm pool size
 - [engine-backend] Hosted-engine SD auto import fails on IndexOutOfBoundsException over FC
 - missing dep on shadow-util cause install failure on ovirt-live
 - Deleting disk that was copied from a disk containing a snapshot, will cause the original disk to remove
 - It is possible to edit a disk using the api during LSM except the snapshot operation phase
 - updating ovirt-engine-extension-aaa-jdbc rpm kills internal profile
 - commands with mixed children types (CoCo/AsyncTasks) don't converge
 - Disk remains locked after create snapshot
 - Leftovers in compensation table
 - Failed to unplug VMs vNIC if it has a the same MAC address in use(plugged)
 - [SR-IOV] - VF that was attached to VM via HostDevices sub tab considered as free
 - UI exception after editing of a storage domain in webadmin
 - UI exception when trying to create a detached storage domain in webadmin
 - Host upgrade manager checks updates for all hosts at the same time
 - [REST-API][SR-IOV]Add label and remove network from virtualfunctionallowednetworks/labels fail
 - Attaching untagged and tagged networks when one has default MTU (1500) and another one has configured 1500 MTU to the same NIC fails
 - Duplicate storage domains in REST API
 - [RFE] Let the user change the name of an imported file Storage Domain
 - [rsdl] allocation policy and format are missing for VM and template import from export domain
 - ovirtmgmt bridge is not configured on newly deployed host
 - Creating VM from template and restart the engine might cause the VM to stay in lock status for ever
 - Scan alignment should not be allowed to run on running VMs
 - fix_invalid_macs.sql is incompatible with postgresql 8
 - Guest operating system of hosted engine VM is wrong
 - [RFE] Implement client-side JavaScript stacktrace de-obfuscation
 - failed Activating hosted engine domain during auto-import on NFS
 - [ALL_LANG][User Portal] - Uncaught Exception Occurred while Click Extended -> Resources Pane
 - Failed activating hosted engine SD during auto-import on iSCSI/FC
 - [cinder] revert operation when fail to add Cinder snapshot.
 - [cinder] revert operation when deleting Cinder snapshot should not update the active flag of the snapshot's volume
 - Unable to update VIRTIO_SCSI flag via rest api
 - [SetupNetworks] attaching network with static boot protocol and IP cause the network to be un-synced

### oVirt Engine Data Warehouse

* If the dwhd lost the original connection to the db it will not update the audit_log and dwh_history_timekeeping when dwh is stopped
 - ovirt-engine-rename tool fails when dwh is installed

### oVirt Engine Reports

* Average instead of maximum values in host heatmap report
 - Visual flaws in host heatmap report
 - [Tracker] Create new Dashboards
 - rename fails when reports is installed and not set up

### oVirt Engine Python SDK

*   Regenerated against the latest API

### oVirt Hosted Engine Setup

* hosted-engine --deploy will fail when re-deploying the first host
 - hosted-engine - cloud-init - missing VM FQDN validation
 - hosted-engine-setup can fail too silently
 - [TEXT][Hosted-Engine] "oVirt Engine" shouldn't be shown on downstream build.
 - Appliance based setup should default to using /var/tmp for unpacking the image
 - hosted-engine --deploy fails in second host when using gluster volume

### oVirt Hosted Engine HA

* [RFE] Keep hosted engine VM configuration in the shared storage

### oVirt Setup Library

* hosted-engine - cloud-init - missing VM FQDN validation

### VDSM

* Vdsm returns successfully even though hotunplugNic does not complete in libvirt
 - oVirt: Consume fix for " Bug 1243102 - Deleting VM snapshots with qemu-kvm-ev-2.1.2 fails"
 - vdsm: setupNetworks fails when IPv6 is disabled at the kernel level
 - [ppc64le] consume fix for: "After writing to a secondary iscsi thin provision disk with data that has been resized, the qemu process dies or vm stops with not enough space"
 - v2v: Available VMs to import from VMware environment cannot be queried.
 - [RFE] provide feedback about the status of the recovery
 - Warn about non-replica 3 gluster volume instead of failing connection to server
 - ship vdsm-hook-vmfex-dev with Vdsm
 - [Cinder] Live preview fails to wake up a VM from hibernation
 - After upgrading vdsm rpms from 3.3 or 3.4 to 3.6, vdsm fails to restart because it's not configured
 - Handle missing glusterfs-cli package
 - Assigning direct LUN fails with error "scsi-block 'lun' devices do not support the serial property"


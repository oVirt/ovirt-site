---
title: OVirt 3.6.2 Release Notes
category: documentation
authors: sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.6.2 Release Notes
wiki_revision_count: 23
wiki_last_updated: 2016-01-26
---

# OVirt 3.6.2 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.2 first release candidate as of December 23rd.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](http://www.ovirt.org/Category:Releases). For a general overview of oVirt, read [ the Quick Start Guide](Quick_Start_Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

### CANDIDATE RELEASE

In order to install oVirt 3.6.2 Release Candidate you've to enable oVirt 3.6 release candidate repository.

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

If you're installing oVirt 3.6.2 on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](oVirt 3.5.6 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

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
 - [TEXT] - Improve error message for detaching network that is in use by VM/VMs from SetupNetwork. Error message is grammatically incorrect (singular vs plural) and confusing
 - engine-backup does not fail cleanly when parsing arguments
 - ISO on Gluster should be a viable option
 - Misleading audit log when deactivating a storage domain
 - Administration Portal- New cluster, CPU Type: IBM POWER 8 should be IBM POWER8
 - [virt-v2v] Import a VM using virt-v2v of a VM which is currently in lock status will cause an uninitialzed CDA message
 - [New HostSetupNetworks] if no changes were done- setup networks shouldn't be invoked
 - Commit a previewed snapshot with Cinder disk should remove all its "children" snapshots
 - [Cinder] Commit a previewed snapshot with Cinder disk should remove orphaned disks
 - Storage domain remains in 'preparing for maintenance' when there is a non operational host
 - Tabs listed thrice once gluster-monitoring-uiplugins installed
 - [UI] html tag leaks to UI
 - RHEV-M upgrade to 3.5.4 fails with error "Command '/usr/bin/openssl' failed to execute" for custom apache.p12
 - [vmconsole] ovirt-vmconsole-list.py does not create secure ssl session
 - Rest allows the creation of too much numa nodes
 - Setting Prefix on a network instead of netmask recognized as a difference and network considered as unsynced
 - [Host QoS] - Engine calculate and report wrong Host QoS values(zero)
 - [Cinder] Stateless VM fails to start with NullPointerException, operation does not rollback
 - Automation of UI tests needs way to check status of VM in userportal
 - No unit next to the "limit" textbox in the QoS Create/Edit dialog
 - SPICE+VNC feature should not be available when creating a VM from Blank template on 3.5 cluster
 - Can't add Nehalem processor host to 3.5 Compat mode and gets in endless loop error
 - Balloon device should be enabled by default for new VMs
 - Can't update template display disconnect action
 - rename SSH port to port for some fence agents
 - Hosts list under host tab shows previously cluster hosts list.
 - Live snapshot's ram and conf volumes are not removed upon Vm deletion, in case of comiting snapshot
 - [Cinder] ThawVDSCommand fails when taking live snapshot without a guest agent
 - [RHEVM 3.5.5] Pool's "custom properties" are not saved
 - LSM fails when one of the vm's disks is located on domain in maintenance
 - USB Device passthrough should not be disabled when host doesn't support PCI passthrough
 - [template-version] Base template does not have <version> attribute
 - Add vmpool doesn't have <use_latest_template_version> tag as opposed to Add vm
 - Fields in configure will not drag to expand.
 - foreman integration: remove "nested" attribute from parameters dict
 - v2v: add cluster field to "import" and "add external provider" dialogs.
 - Add support for named bond modes for vdsm 3.5 in engine 3.6
 - Create snapshot fails when one of the vm's disks is located on domain in maintenance
 - [REST-API] [cloud init] Can't set user different than 'root' in RunOnce
 - The /clusters resource uses the "All-Content: true" header, but it isn't documented
 - [cinder] image is locked infinitely after engine restart was performed, during a make template of a VM with cinder disks
 - [events] Missing whitespace - Message: Power Management test failed for Host$host.No reason was returned for this operation failure. See logs for further details.
 - [Cinder] Stateless VM with Cinder disk should be based on a cloned disk instead of a stateless snapshot.
 - [WebAdmin] - Error message appears in the UI "Uncaught exception occurred. Please try reloading the page." while pressing the 'Import' button in the VM Import sub tab, under Storage main tab
 - [REST-API] rsdl: 'provisioned_size' tag is not under 'disk' tag for add disk
 - Misleading audit log :Refresh image list failed for domain(s): ISO_DOMAIN (Unknown file type)
 - New vNIC - It takes time for the profile to be loaded
 - A non-management network is allowed to be chosen as a host gateway
 - Live merge: Engine must refresh resized volume on HSM prior to starting merge
 - [ppc64le][REST API] Failed to update vm pool size
 - [engine-backend] Hosted-engine SD auto import fails on IndexOutOfBoundsException over FC
 - missing dep on shadow-util cause install failure on ovirt-live
 - Deleting disk that was copied from a disk containing a snapshot, will cause the original disk to remove

### oVirt Engine Data Warehouse

* If the dwhd lost the original connection to the db it will not update the audit_log and dwh_history_timekeeping when dwh is stopped
 - ovirt-engine-rename tool fails when dwh is installed

### oVirt Engine Reports

* Average instead of maximum values in host heatmap report
 - [Tracker] Create new Dashboards

### oVirt Hosted Engine Setup

* hosted-engine - cloud-init - missing VM FQDN validation
 - hosted-engine-setup can fail too silently

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

<Category:Documentation> <Category:Releases>

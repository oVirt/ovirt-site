---
title: OVirt 3.6.6 Release Notes
category: documentation
authors: didi, sandrobonazzola, rafaelmartins
---

# oVirt 3.6.6 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.6 first release candidate as of April 26th, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](http://www.ovirt.org/develop/release-management/releases/).
For a general overview of oVirt, read [the Quick Start Guide](Quick_Start_Guide)
and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

## CANDIDATE RELEASE

In order to install oVirt 3.6.6 Release Candidate you've to enable oVirt 3.6 release candidate repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.6.repo**

**For CentOS / RHEL:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
      baseurl=http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
      gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6

**For Fedora:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
      baseurl=http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever`
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
      gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.6 on a clean host, you should read our
[Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](oVirt 3.5.6 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/)

### oVirt Node

oVirt Node is now released continously. Please refer to the [Node Project](http://www.ovirt.org/develop/projects/node/node/) page for release notes, download and install instructions.

## What's New in 3.6.6?

### Release Note

#### VDSM

 - [BZ 1323952](https://bugzilla.redhat.com/1323952) <b>Change migration parameters</b><br>migration behavior changes - newly there will be only at most 2 migrations started (instead of 3) in parallel, at higher speed, to increase the chances that migrations converge instead of timing out. <br>Values can be changed back or to any other value in vdsm.conf

### Enhancement

#### oVirt Engine

 - [BZ 1241149](https://bugzilla.redhat.com/1241149) <b>[RFE] Provide way to preform in-cluster upgrade of hosts from el6->el7.</b><br>

#### oVirt Engine DWH

 - [BZ 1285788](https://bugzilla.redhat.com/1285788) <b>[RFE] Enable logging of dwh ETL process in debug mode</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1142865](https://bugzilla.redhat.com/1142865) <b>Missing QoS in the warning that is shown when removing multiple QoS</b><br>
 - [BZ 1190142](https://bugzilla.redhat.com/1190142) <b>New Template dialog to narrow when quota is enabled</b><br>
 - [BZ 1284472](https://bugzilla.redhat.com/1284472) <b>User can't create a VM. No permission for EDIT_ADMIN_VM_PROPERTIES</b><br>
 - [BZ 1292398](https://bugzilla.redhat.com/1292398) <b>Block restore memory on newer compatibility versions</b><br>
 - [BZ 1305330](https://bugzilla.redhat.com/1305330) <b>Disable high availability option for hosted engine VM</b><br>
 - [BZ 1311121](https://bugzilla.redhat.com/1311121) <b>oVirt system tests for 3.6 fail to deactivate domain on the first try - suspect race between OVF update and SPM stop</b><br>
 - [BZ 1311151](https://bugzilla.redhat.com/1311151) <b>[Hosted-engine] - The vNIC(vnet0) of the HostedEngine VM reported as unplugged in UI although it is actually UP in the guest</b><br>
 - [BZ 1314417](https://bugzilla.redhat.com/1314417) <b>[webAdmin] Edit VM name validation failure do not direct the General tab</b><br>
 - [BZ 1314426](https://bugzilla.redhat.com/1314426) <b>Edit VM hotplug show redundant change list</b><br>
 - [BZ 1314781](https://bugzilla.redhat.com/1314781) <b>Add Cockpit port to the default ports to be opened when Engine manages the firewall</b><br>
 - [BZ 1316853](https://bugzilla.redhat.com/1316853) <b>Cloning a VM from a cloned cinder disk results in a locked image status</b><br>
 - [BZ 1317473](https://bugzilla.redhat.com/1317473) <b>[admin portal] Increase CPUs number in VM edit dialog of running VM is not propagated to virtual sockets</b><br>
 - [BZ 1318986](https://bugzilla.redhat.com/1318986) <b>[SETUP] engine-setup fails if the user install engine rpms but he wants to configure just other product options</b><br>
 - [BZ 1320594](https://bugzilla.redhat.com/1320594) <b>enable hyperv optimizations by default</b><br>
 - [BZ 1320606](https://bugzilla.redhat.com/1320606) <b>Host deploys fails - ping flood issue on VDSM side</b><br>
 - [BZ 1321249](https://bugzilla.redhat.com/1321249) <b>ovirt-engine-tools-backup dependency error</b><br>
 - [BZ 1322602](https://bugzilla.redhat.com/1322602) <b>python SDK: regenerate_ids does not have effect after udpate to RHEV 3.6.3.4-0.1.el6</b><br>
 - [BZ 1323462](https://bugzilla.redhat.com/1323462) <b>Local export storage domain metadata states Version 3 instead of Version 0, making it impossible to re-attach.</b><br>
 - [BZ 1324363](https://bugzilla.redhat.com/1324363) <b>[REST-API] Copy of template disk doesn't complete nicely</b><br>
 - [BZ 1324733](https://bugzilla.redhat.com/1324733) <b>[z-stream clone - 3.6.6] engine-setup stage 'Setup validation' takes too long to complete</b><br>
 - [BZ 1324935](https://bugzilla.redhat.com/1324935) <b>[REST API] Missing href field for sshpublickey</b><br>
 - [BZ 1326311](https://bugzilla.redhat.com/1326311) <b>Getting exception while trying to open Edit dialog while the VM is starting</b><br>
 - [BZ 1326810](https://bugzilla.redhat.com/1326810) <b>Cannot to edit HE VM via REST API</b><br>
 - [BZ 1328036](https://bugzilla.redhat.com/1328036) <b>ovirt-vmconsole conf and pki are not backed up</b><br>

### VDSM

 - [BZ 1264003](https://bugzilla.redhat.com/1264003) <b>CPU which goes offline while vdsm is running breaks getVdsStats</b><br>
 - [BZ 1322842](https://bugzilla.redhat.com/1322842) <b>VM with a payload doesn't start with libvirt >= 1.3.2</b><br>
 - [BZ 1325485](https://bugzilla.redhat.com/1325485) <b>[3.6 only] SCSI pass through [via hook] does not work</b><br>

### oVirt vmconsole

 - [BZ 1329657](https://bugzilla.redhat.com/1329657) <b>%pre (and anaconda) fails when installing on a system without shadow-utils</b><br>

### oVirt Engine Extension AAA JDBC

 - [BZ 1304368](https://bugzilla.redhat.com/1304368) <b>aaa-jdbc return only direct group membership, not indirect membership</b><br>

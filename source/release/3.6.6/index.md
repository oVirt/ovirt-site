---
title: oVirt 3.6.6 Release Notes
category: documentation
toc: true
authors: didi, sandrobonazzola, rafaelmartins, fabiand
page_classes: releases
---

# oVirt 3.6.6 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.6 release as of May 23rd, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](/develop/release-management/releases/3.5.6/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup


### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

### oVirt Node

A new oVirt Node installation iso is available at: <http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-node-ng-installer/>

Download and install instructions are avaialble on the [Node Project](/download/node.html) page.

If you have already got oVirt Node Next installed, you can run

    yum update

to update Node.

## What's New in 3.6.6?

### Enhancement

#### oVirt Engine

 - [BZ 1241149](https://bugzilla.redhat.com/1241149) <b>[RFE] Provide way to preform in-cluster upgrade of hosts from el6->el7.</b><br>
 - [BZ 1332463](https://bugzilla.redhat.com/1332463) <b>[RFE] restore: ensure that 3.6 on el6 backup can be restored on 3.6 on el7</b><br>Feature: <br><br>Allow engine-backup on el7 to restore backups taken on el6.<br><br>Reason: <br><br>engine 4.0 does not support el6. Users that want to upgrade from 3.6 on el6 to 4.0 on el7 have to do this by backing up the engine on 3.6/el6 and restore on 4.0/el7.<br><br>This feature, backported from 4.0, allows to do such a migration also in 3.6.<br><br>Result: <br><br>Using this flow, it's possible to migrate a el6 setup to el7:<br><br>On the existing engine machine run:<br>1. engine-backup \-\-mode=backup \-\-file=engine-3.6.bck \-\-log=backup.log<br><br>On a new el7 machine:<br>2. Install engine, including dwh if it was set up on el6.<br>3. Copy engine-3.6.bck to the el7 machine<br>4. engine-backup \-\-mode=restore \-\-file=engine-3.6.bck \-\-log=restore.log \-\-provision-db \-\-no-restore-permissions<br>5. engine-setup<br><br>Check engine-backup documentation for other options, including using remote databases, extra grants/permissions, etc.

#### oVirt Hosted Engine Setup

 - [BZ 1324520](https://bugzilla.redhat.com/1324520) <b>[RFE] Allow to skip tty check to allow for unattended install via Ansible</b><br>

### Release Note

#### VDSM

 - [BZ 1323952](https://bugzilla.redhat.com/1323952) <b>Change migration parameters</b><br>migration behavior changes - newly there will be only at most 2 migrations started(instead of 3) in parallel, at higher speed, to increase the chances that migrations converge instead of timing out. <br>Values can be changed back or to any other value in vdsm.conf

## Bug fixes

### oVirt Engine

 - [BZ 1142865](https://bugzilla.redhat.com/1142865) <b>Missing QoS in the warning that is shown when removing multiple QoS</b><br>
 - [BZ 1143869](https://bugzilla.redhat.com/1143869) <b>Impossible to limit access to CPU profiles via user WEBUI portal on user/group basis.</b><br>
 - [BZ 1190142](https://bugzilla.redhat.com/1190142) <b>New Template dialog to narrow when quota is enabled</b><br>
 - [BZ 1284472](https://bugzilla.redhat.com/1284472) <b>User can't create a VM. No permission for EDIT_ADMIN_VM_PROPERTIES</b><br>
 - [BZ 1292398](https://bugzilla.redhat.com/1292398) <b>Block restore memory on newer compatibility versions</b><br>
 - [BZ 1303160](https://bugzilla.redhat.com/1303160) <b>Connecting vfio-pci device failed, no device found with kernel > 3.10.0-229.20.1.el7.x86_64 (RHEL 7.2)</b><br>
 - [BZ 1305330](https://bugzilla.redhat.com/1305330) <b>Disable high availability option for hosted engine VM</b><br>
 - [BZ 1311121](https://bugzilla.redhat.com/1311121) <b>oVirt system tests for 3.6 fail to deactivate domain on the first try - race with storage domain status syncing process</b><br>
 - [BZ 1311151](https://bugzilla.redhat.com/1311151) <b>[Hosted-engine] - The vNIC(vnet0) of the HostedEngine VM reported as unplugged in UI although it is actually UP in the guest</b><br>
 - [BZ 1314417](https://bugzilla.redhat.com/1314417) <b>[webAdmin] Edit VM name validation failure do not direct the General tab</b><br>
 - [BZ 1314426](https://bugzilla.redhat.com/1314426) <b>Edit VM hotplug show redundant change list</b><br>
 - [BZ 1314781](https://bugzilla.redhat.com/1314781) <b>Add Cockpit port to the default ports to be opened when Engine manages the firewall</b><br>
 - [BZ 1316853](https://bugzilla.redhat.com/1316853) <b>Cloning a VM from a cloned cinder disk results in a locked image status</b><br>
 - [BZ 1317473](https://bugzilla.redhat.com/1317473) <b>[admin portal] Increase CPUs number in VM edit dialog of running VM is not propagated to virtual sockets</b><br>
 - [BZ 1318050](https://bugzilla.redhat.com/1318050) <b>Livemerge Cannot remove Snapshot. Low disk space on Storage Domain</b><br>
 - [BZ 1320128](https://bugzilla.redhat.com/1320128) <b>Host setup fails - network disconnection causes SetupNetwork not to be sent (or not received by host)</b><br>
 - [BZ 1320594](https://bugzilla.redhat.com/1320594) <b>enable hyperv optimizations by default</b><br>
 - [BZ 1320606](https://bugzilla.redhat.com/1320606) <b>Host deploys fails - ping flood issue on VDSM side</b><br>
 - [BZ 1321249](https://bugzilla.redhat.com/1321249) <b>ovirt-engine-tools-backup dependency error</b><br>
 - [BZ 1322602](https://bugzilla.redhat.com/1322602) <b>python SDK: regenerate_ids does not have effect after udpate to RHEV 3.6.3.4-0.1.el6</b><br>
 - [BZ 1323462](https://bugzilla.redhat.com/1323462) <b>Local export storage domain metadata states Version 3 instead of Version 0, making it impossible to re-attach.</b><br>
 - [BZ 1324363](https://bugzilla.redhat.com/1324363) <b>[REST-API] Copy of template disk doesn't complete nicely</b><br>
 - [BZ 1324733](https://bugzilla.redhat.com/1324733) <b>[z-stream clone - 3.6.6] engine-setup stage 'Setup validation' takes too long to complete</b><br>
 - [BZ 1324935](https://bugzilla.redhat.com/1324935) <b>[REST API] Missing href field for sshpublickey</b><br>
 - [BZ 1326311](https://bugzilla.redhat.com/1326311) <b>Getting exception while trying to open Edit dialog while the VM is starting</b><br>
 - [BZ 1326511](https://bugzilla.redhat.com/1326511) <b>remove "supported browser" alert</b><br>
 - [BZ 1328036](https://bugzilla.redhat.com/1328036) <b>ovirt-vmconsole conf and pki are not backed up</b><br>
 - [BZ 1329317](https://bugzilla.redhat.com/1329317) <b>Host hangs indefinitely in "Installing" stage during host-deploy</b><br>
 - [BZ 1330483](https://bugzilla.redhat.com/1330483) <b>[z-stream clone - 3.6.6] Storage domain ownership of LUN not displayed.</b><br>
 - [BZ 1330742](https://bugzilla.redhat.com/1330742) <b>[AAA] After AAA configuration, users unable to login via scripts</b><br>
 - [BZ 1332088](https://bugzilla.redhat.com/1332088) <b>[3.6.6 clone][migration 3.6 el6 - 3.6 el7] Failed to execute stage 'Setup validation': Firewall manager iptables is not available</b><br>

### VDSM

 - [BZ 1264003](https://bugzilla.redhat.com/1264003) <b>CPU which goes offline while vdsm is running breaks getVdsStats</b><br>
 - [BZ 1322842](https://bugzilla.redhat.com/1322842) <b>VM with a payload doesn't start with libvirt >= 1.3.2</b><br>
 - [BZ 1325485](https://bugzilla.redhat.com/1325485) <b>[3.6 only] SCSI pass through [via hook] does not work</b><br>
 - [BZ 1332038](https://bugzilla.redhat.com/1332038) <b>[z-stream clone - 3.6.6] After a live merge failure, a VM with volumes in an illegal state can be restarted</b><br>

### VDSM JSON-RPC Java

 - [BZ 1323465](https://bugzilla.redhat.com/1323465) <b>Setup Networks cause ClosedChannelException</b><br>

### oVirt Hosted Engine Setup

 - [BZ 1322729](https://bugzilla.redhat.com/1322729) <b>Hosted-engine-setup still requires to copy the answerfile from the first host via scp</b><br>

### oVirt Hosted Engine HA

 - [BZ 1327516](https://bugzilla.redhat.com/1327516) <b>Infinite loop trying to fix remote path on glusterFS storage domain</b><br>
 - [BZ 1332963](https://bugzilla.redhat.com/1332963) <b>IOError from smtplib is not handled</b><br>

### oVirt vmconsole

 - [BZ 1329657](https://bugzilla.redhat.com/1329657) <b>%pre (and anaconda) fails when installing on a system without shadow-utils</b><br>

### oVirt Engine Extension AAA JDBC

 - [BZ 1304368](https://bugzilla.redhat.com/1304368) <b>aaa-jdbc return only direct group membership, not indirect membership</b><br>

### oVirt Node

 - This is the first release which provides oVirt Node Next, see [node](/download/node.html) for more details.

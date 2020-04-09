---
title: oVirt 4.1.4 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.1.4 Release Notes

The oVirt Project is pleased to announce the availability of 4.1.4
Release as
of July 28, 2017.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.3,
CentOS Linux 7.3 (or similar).
Packages for Fedora 24 are also available as a Tech Preview.



For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/community/about.html) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.1.4, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL



In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm)


and then follow our
[Installation guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/)


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/)

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/)

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the epel repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS OpsTools SIG repos, for other packages.

EPEL currently includes collectd 5.7.1, and the collectd package there includes
the write_http plugin.

OpsTools currently includes collectd 5.7.0, and the write_http plugin is
packaged separately.

ovirt-release does not use collectd from epel, so if you only use it, you
should be ok.

If you want to use other packages from EPEL, you should make sure to not
include collectd. Either use `includepkgs` and add those you need, or use
`exclude=collectd*`.


## What's New in 4.1.4?

### Enhancements

#### oVirt Release Package

 - [BZ 1461813](https://bugzilla.redhat.com/1461813) <b>[RFE] Provide hook for vGPU</b><br>RHV-H now supports vGPU for nVidia GPUs, by including vdsm-hook-vfio-mdev.

#### oVirt Engine

 - [BZ 1438408](https://bugzilla.redhat.com/1438408) <b>[RFE] Cluster maintenance scheduling policy</b><br>The ClusterInMaintenance scheduling policy was added to limit activity in a cluster during maintenance tasks. When set, no new VMs may be started, except highly available VMs. Highly available VMs are still restarted properly upon host failure and any VM can be migrated. Users can create new highly available VMs and start them manually.
 - [BZ 1465862](https://bugzilla.redhat.com/1465862) <b>[downstream clone - 4.1.4] [RFE] Need UI element to view affinity labels in the VM and host dialog boxes</b><br>Previously, users could  use the REST API to add/edit affinity labels for virtual machines and hosts, but they could not view this information in the Administration Portal.<br><br>In this release, affinity label information is now available in the Administration Portal. It can be seen in the Add/Edit windows for virtual machines and hosts. The window displays all available affinity labels in the system, and for entities with assigned labels, those labels are selected.
 - [BZ 1450293](https://bugzilla.redhat.com/1450293) <b>After upgrade still can't connect to engine web ui with chrome 58 (due to missing subjectAltName)</b><br>Newer browsers require the subjectAltName extension in certificates for HTTPS. Previously (version 4.1.2 and later), engine-setup created certificates with subjectAltName for new setups, but did not update existing certificates during upgrade.<br><br>Now engine-setup can add subjectAltName to existing internal certificates, so that newer browsers will accept them.
 - [BZ 1319323](https://bugzilla.redhat.com/1319323) <b>[RFE] Do not check VLAN ID for duplicates (allow them on different networks, DCs... ?)</b><br>

#### VDSM

 - [BZ 1461813](https://bugzilla.redhat.com/1461813) <b>[RFE] Provide hook for vGPU</b><br>RHV-H now supports vGPU for nVidia GPUs, by including vdsm-hook-vfio-mdev.
 - [BZ 917062](https://bugzilla.redhat.com/917062) <b>[RFE] add abrt integration</b><br>ABRT is now integrated with Red Hat Virtualization when initializing hypervisors. ABRT is configured by VDSM and saves meaningful debug information, instead of enormous core-dump reports.
 - [BZ 1461295](https://bugzilla.redhat.com/1461295) <b>[downstream clone - 4.1.4] [RFE] Provide a way to correlate each 'run and protect' thread to its task</b><br>

#### oVirt Engine Extension AAA JDBC

 - [BZ 1452668](https://bugzilla.redhat.com/1452668) <b>[downstream clone - 4.1.4] [RFE] possibility to enter encrypted passwords in --password option</b><br>Previously, administrators had to enter an unencrypted password when invoking 'ovirt-aaa-jdbc-tool user password-reset'. The password was then encrypted inside ovirt-aaa-jdbc-tool and stored in the database.<br><br>This update enables administrators to use the new --encrypted option to enter an already encrypted password when invoking 'ovirt-aaa-jdbc-tool user password-reset'.<br><br>However there are some caveats when providing encrypted passwords:<br><br>1. Entering an encrypted password means that password validity tests cannot be performed, so they are skipped and the password is accepted even if it does not comply with the password validation policy.<br><br>2. A password has to be encrypted using the same configured algorithm. To encrypt passwords, administrators can use the '/usr/share/ovirt-engine/bin/ovirt-engine-crypto-tool.sh' tool, which provides the 'pbe-encode' command to encrypt passwords using the default PBKDF2WithHmacSHA1 algorithm.

### No Doc Update

#### oVirt Engine

 - [BZ 1470802](https://bugzilla.redhat.com/1470802) <b>scheduling policy required properties have no defaults</b><br>

### Release Note

#### oVirt Engine

 - [BZ 1469478](https://bugzilla.redhat.com/1469478) <b>hide InClusterUpgrade policy</b><br>The InClusterUpgrade scheduling policy was only useful for upgrading cluster nodes from RHEL6 to RHEL7. RHEL6 is not an supported OS for oVirt hosts anymore so the policy is not doing anything nowadays. We might re-enable it if an use case shows up in the future.

### Unclassified

#### oVirt Engine

 - [BZ 1468968](https://bugzilla.redhat.com/1468968) <b>[downstream clone - 4.1.4] Default DC & Cluster has fixed UUIDs</b><br>
 - [BZ 1457814](https://bugzilla.redhat.com/1457814) <b>Bug in engine.log FenceVdsVDSCommandParameters message</b><br>
 - [BZ 1463698](https://bugzilla.redhat.com/1463698) <b>[downstream clone - 4.1.4] Running the command logon on the VM via the REST failed</b><br>
 - [BZ 1460160](https://bugzilla.redhat.com/1460160) <b>The default cluster has "Legacy" migration policy in new deployments</b><br>
 - [BZ 1412749](https://bugzilla.redhat.com/1412749) <b>[engine-webadmin] Uncaught exception is received when trying to create NFS domain with wrong value type in  'Custom Connection Parameters'</b><br>
 - [BZ 1444029](https://bugzilla.redhat.com/1444029) <b>[RFE] Add functionality to add hosts to affinity groups</b><br>
 - [BZ 1467654](https://bugzilla.redhat.com/1467654) <b>ship cluster upgrade script in ovirt-4.1</b><br>
 - [BZ 1454459](https://bugzilla.redhat.com/1454459) <b>Failed to migrate paused VM</b><br>
 - [BZ 1464795](https://bugzilla.redhat.com/1464795) <b>Cold Merge: Add an entry describing merge job to audit log</b><br>
 - [BZ 1464766](https://bugzilla.redhat.com/1464766) <b>RESTAPI - Amend does not start after 1st amend fails (due to VDSM kill)</b><br>
 - [BZ 1465839](https://bugzilla.redhat.com/1465839) <b>Storage pool upgrade does not cause each synced storage domain to refresh its metadata devices</b><br>
 - [BZ 1464348](https://bugzilla.redhat.com/1464348) <b>SQL exception occur during HSMClearTaskVDSCommand</b><br>
 - [BZ 1436766](https://bugzilla.redhat.com/1436766) <b>Crunched display of disk targets in move and copy when VM/SD name is long and contains hyphens</b><br>

#### VDSM

 - [BZ 1474320](https://bugzilla.redhat.com/1474320) <b>When restarting VDSM while VM is running and after that powering off the VM, virsh report that VM state is running</b><br>
 - [BZ 1441530](https://bugzilla.redhat.com/1441530) <b>setupNetworks fails after firewalld creates .bak files</b><br>
 - [BZ 1460687](https://bugzilla.redhat.com/1460687) <b>[RHEL 7.4] - When updating MTU to custom number and after that return to default MTU (1500) the network ifcfg file not updated</b><br>
 - [BZ 1460619](https://bugzilla.redhat.com/1460619) <b>vdsm insert gaps in the ifcfg file for every network update</b><br>
 - [BZ 1471663](https://bugzilla.redhat.com/1471663) <b>vdsm plugin - TypeError: add_copy_spec() takes exactly 2 arguments (3 given)</b><br>
 - [BZ 1468991](https://bugzilla.redhat.com/1468991) <b>Connection exception when trying to connect to the vdsm client</b><br>
 - [BZ 1465836](https://bugzilla.redhat.com/1465836) <b>Failed to delete vm since '_IOProcessOs' object has no attribute 'listdir'</b><br>
 - [BZ 1460140](https://bugzilla.redhat.com/1460140) <b>Forgotten package from oVirt 4.0 in oVirt 4.1</b><br>

#### imgbased

 - [BZ 1461701](https://bugzilla.redhat.com/1461701) <b>[RHEL 7.4]Missing new build boot entry after upgrade to rhvh-4.1-20170613.0</b><br>

#### oVirt Cockpit Plugin

 - [BZ 1463124](https://bugzilla.redhat.com/1463124) <b>Make hosted-engine requirement optional</b><br>

#### oVirt Engine Metrics

 - [BZ 1468208](https://bugzilla.redhat.com/1468208) <b>If fluentd package is not upgraded the metrics setup script fails</b><br>
 - [BZ 1464737](https://bugzilla.redhat.com/1464737) <b>If fluentd fails to load, no message will appear and collectd will log many error messages</b><br>
 - [BZ 1459431](https://bugzilla.redhat.com/1459431) <b>Add pos_file parameter to the in_tail plugin for engine.log records</b><br>
 - [BZ 1438821](https://bugzilla.redhat.com/1438821) <b>If host key was not added to engine machine playbook for setting up metrics fails</b><br>

## Bug fixes

### oVirt Engine

 - [BZ 1468999](https://bugzilla.redhat.com/1468999) <b>[downstream clone - 4.1.4] Command via API can cause host in Maintenance mode to be fenced</b><br>

### VDSM

 - [BZ 1461811](https://bugzilla.redhat.com/1461811) <b>RHEL7.4 | Trying to start a VM after restore RAM snapshot fails - 'virDomainRestoreFlags() failed'</b><br>


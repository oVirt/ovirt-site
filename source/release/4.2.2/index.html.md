---
title: oVirt 4.2.2 Release Notes
category: documentation
layout: toc
---

# oVirt 4.2.2 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.2
First Release Candidate
 as of February 15, 2018.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.4,
CentOS Linux 7.4 (or similar).


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page]"(/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).
The oVirt Project makes no guarantees as to its suitability or usefulness.
This pre-release should not to be used in production, and it is not feature
complete.


For a general overview of oVirt, read the [Quick Start Guide](/documentation/quickstart/quickstart-guide/)
and visit the [About oVirt](/documentation/introduction/about-ovirt/) page.

For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.2, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL


## RELEASE CANDIDATE

In order to install this Release Candidate you will need to enable pre-release repository.




In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42-pre.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).



### No Fedora support

Regretfully, Fedora is not supported anymore, and RPMs for it are not provided.
These are still built for the master branch, so users that want to test them,
can use the [nightly snapshot](/develop/dev-process/install-nightly-snapshot/).
At this point, we only try to fix problems specific to Fedora if they affect
developers. For some of the work to be done to restore support for Fedora, see
also tracker [bug 1460625](https://bugzilla.redhat.com/showdependencytree.cgi?id=1460625&hide_resolved=0).

### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install)
guide or the corresponding section in
[Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow
[Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine)
guide or the corresponding section within the
[Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/).

### EPEL

TL;DR Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## What's New in 4.2.2?

### Enhancements

#### oVirt Hosted Engine Setup

 - [BZ 1542604](https://bugzilla.redhat.com/1542604) <b>[RFE] HE setup: Ansible Flow: Show only active network interfaces for setting ovirtmgmt bridge</b><br>Ansible Flow: Show only active network interfaces for setting ovirtmgmt bridge

#### oVirt Engine

 - [BZ 1379309](https://bugzilla.redhat.com/1379309) <b>[RFE] Integrate with gluster eventing</b><br>Feature: Integrate oVirt with gluster events framework<br><br>Reason: Push based monitoring rathen than frequent polling from engine to determine status of gluster volume entities
 - [BZ 1520424](https://bugzilla.redhat.com/1520424) <b>[RFE] Fence hosts which became NonResponsive right after engine startup</b><br>Feature: <br>After the start-up quite time, the engine will check for any non-responding hosts and if it find any, it will try to fence them.<br><br>Reason: <br>When engine is starting up , it ignores any non-responding hosts for a configurable quite time (5 minutes by default) in order to prevent "fencing-storm". The problem is that hosts that remain non-responding after this quite time are not fenced automatically and the administrator should fence them manually. <br><br>Result: <br>Hosts that were non-responsive and remain as such after the quite time and have power management will be fenced automatically

### Bug Fixes

#### oVirt Log Collector

 - [BZ 1519541](https://bugzilla.redhat.com/1519541) <b>log-collector-analyzer: ERROR:  column v.agent_ip does not exist</b><br>

#### oVirt Engine

 - [BZ 1537343](https://bugzilla.redhat.com/1537343) <b>engine tries to balance vms that are down.</b><br>
 - [BZ 1517540](https://bugzilla.redhat.com/1517540) <b>Uncleaned leftovers after live storage migration failure during VmReplicateDiskFinish</b><br>
 - [BZ 1535256](https://bugzilla.redhat.com/1535256) <b>MaxBlockDiskSize is honoured only on AddDiskCommand and not on Extend</b><br>

#### VDSM

 - [BZ 1543103](https://bugzilla.redhat.com/1543103) <b>Call vdsm 'after_vm_pause' hooks when the VM has been paused because an I/O Error</b><br>

### Other

#### oVirt ISO Uploader

 - [BZ 1513481](https://bugzilla.redhat.com/1513481) <b>uploading iso to glusterfs via ssh fails</b><br>

#### oVirt Log Collector

 - [BZ 1491302](https://bugzilla.redhat.com/1491302) <b>Missing manual for ovirt-log-collector-analyzer</b><br>
 - [BZ 1518950](https://bugzilla.redhat.com/1518950) <b>ovirt-log-collector-analyzer: sosreport-foobar-Logcollector-9175126/dev/null: Cannot mknod: Operation not permitted\ntar: Exiting with failure status due to previous errors</b><br>
 - [BZ 1493099](https://bugzilla.redhat.com/1493099) <b>[RFE] - Add iSCSI initiator name to hosts table for analyzer report</b><br>
 - [BZ 1491253](https://bugzilla.redhat.com/1491253) <b>[RFE] - /usr/share/ovirt-log-collector/analyzer/inventory-profile has hardcoded /tmp</b><br>
 - [BZ 1532927](https://bugzilla.redhat.com/1532927) <b>[RFE] Add host SELinux check to analyzer</b><br>
 - [BZ 1529341](https://bugzilla.redhat.com/1529341) <b>ovirt-log-collector-analyzer: warn if the number of hosts is > 200 (in 4.1 and below)</b><br>

#### oVirt Ansible cluster upgrade role

 - [BZ 1539776](https://bugzilla.redhat.com/1539776) <b>Role should fail after one failed host</b><br>
 - [BZ 1539761](https://bugzilla.redhat.com/1539761) <b>[RFE] changing cluster into maintenance only with special parameter</b><br>
 - [BZ 1539774](https://bugzilla.redhat.com/1539774) <b>[RFE] Add variable about not rebooting the host after upgrade</b><br>

#### ovirt-engine-dwh

 - [BZ 1541924](https://bugzilla.redhat.com/1541924) <b>Ovirt-engine-dwh fails to collect statistics due to high number in database sequences.</b><br>

#### oVirt Hosted Engine HA

 - [BZ 1525859](https://bugzilla.redhat.com/1525859) <b>Clean metadata command raises Traceback</b><br>
 - [BZ 1543424](https://bugzilla.redhat.com/1543424) <b>[vintage][iscsi][multipath] With answerfile (or from cockpit) the setup fails if just one of the paths to the storage server is down</b><br>
 - [BZ 1443819](https://bugzilla.redhat.com/1443819) <b>Stale Active LVs in Hosted-Engine Storage Domain</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1541412](https://bugzilla.redhat.com/1541412) <b>Ansible deployment should clean up files in /var once finished</b><br>
 - [BZ 1543424](https://bugzilla.redhat.com/1543424) <b>[vintage][iscsi][multipath] With answerfile (or from cockpit) the setup fails if just one of the paths to the storage server is down</b><br>
 - [BZ 1443819](https://bugzilla.redhat.com/1443819) <b>Stale Active LVs in Hosted-Engine Storage Domain</b><br>
 - [BZ 1541328](https://bugzilla.redhat.com/1541328) <b>[ansible] deployment fails on Opteron CPUs due to bad cpu type in vm.conf at the end</b><br>
 - [BZ 1540107](https://bugzilla.redhat.com/1540107) <b>The engine fails to delete a existing external VM (via REST APIs) with 'Operation Failed: [Desktop does not exist]'</b><br>

#### oVirt Engine Extension AAA-JDBC

 - [BZ 1540909](https://bugzilla.redhat.com/1540909) <b>Use native SecureRandom implementation instead of SHA1PRNG</b><br>

#### oVirt Engine

 - [BZ 1513398](https://bugzilla.redhat.com/1513398) <b>rhv manager does not show the results of the search properly</b><br>
 - [BZ 1540624](https://bugzilla.redhat.com/1540624) <b>Cannot get administration portal after logging to IPA domain, WFLYEJB0442: Unexpected Error</b><br>
 - [BZ 1540605](https://bugzilla.redhat.com/1540605) <b>OVA logs are not logged because /var/log/ovirt-engine/ova/ folder is not created during engine-setup.</b><br>
 - [BZ 1539356](https://bugzilla.redhat.com/1539356) <b>Can not add new VNIC to hosted-engine VM</b><br>
 - [BZ 1538840](https://bugzilla.redhat.com/1538840) <b>Disk move between storage domain's result's in source image being removed.</b><br>
 - [BZ 1542034](https://bugzilla.redhat.com/1542034) <b>"Failed to determine the metadata devices of Storage Domain" error is shown for every storage domains in 4.1 environment with 4.0 hosts</b><br>
 - [BZ 1537534](https://bugzilla.redhat.com/1537534) <b>UpdateVmCommand fails with NullPointerException after failed Hot-plug of a VM lease due to VM power off</b><br>
 - [BZ 1535574](https://bugzilla.redhat.com/1535574) <b>Webadmin importing VM event is stuck in importing state although the import failed.</b><br>
 - [BZ 1530944](https://bugzilla.redhat.com/1530944) <b>Add host failed with PSQLException if host has the same name server entry written twice in the resolv.conf</b><br>
 - [BZ 1540907](https://bugzilla.redhat.com/1540907) <b>Use native SecureRandom implementation instead of SHA1PRNG</b><br>
 - [BZ 1520455](https://bugzilla.redhat.com/1520455) <b>The VM name resets to original value when switching tab in 'import virtual machine' dialog</b><br>
 - [BZ 1375678](https://bugzilla.redhat.com/1375678) <b>Template/InstanceType migration mode (placement policy affinity) value has inconsistencies between webadmin/api/DB</b><br>
 - [BZ 1537119](https://bugzilla.redhat.com/1537119) <b>When trying to preview a snapshot of a VM using REST-API, and supplying a list of disks, operation fails with NPE</b><br>
 - [BZ 1532700](https://bugzilla.redhat.com/1532700) <b>WebAdmin: "Finished Deactivating Storage Domain..." message while deactivation fails</b><br>
 - [BZ 1348143](https://bugzilla.redhat.com/1348143) <b>[de_DE] The UI alignment needs to be corrected on clusters->new->console page.</b><br>
 - [BZ 1512554](https://bugzilla.redhat.com/1512554) <b>template edit button not shown on the details page</b><br>
 - [BZ 1535573](https://bugzilla.redhat.com/1535573) <b>[REST API] External network creation response body returns invalid external provider ID</b><br>
 - [BZ 1535859](https://bugzilla.redhat.com/1535859) <b>Webadmin- Events & alerts notifications clear all events -> USER_CLEAR_ALL_AUDIT_LOG' is not translated in 'bundles/AuditLogMessages'</b><br>
 - [BZ 1528853](https://bugzilla.redhat.com/1528853) <b>[TEXT] Host becomes non-operational if it has an un-synced network with vm<>non-VM difference</b><br>
 - [BZ 1539778](https://bugzilla.redhat.com/1539778) <b>Under Instance Images: Selected LUN is unmarked while editing an added direct LUN in new VM prompt</b><br>
 - [BZ 1542531](https://bugzilla.redhat.com/1542531) <b>Allow ServerCPUList and ClusterEmulatedMachines options to be visible over RESTAPI</b><br>
 - [BZ 1532884](https://bugzilla.redhat.com/1532884) <b>NullPointerException after failure to refresh VDS</b><br>
 - [BZ 1534913](https://bugzilla.redhat.com/1534913) <b>Missing uuid-ossp extension on remote db causes engine-setup to die in the middle</b><br>
 - [BZ 1525596](https://bugzilla.redhat.com/1525596) <b>[REST] entrypoint for events returns Blank template element without href nor id</b><br>
 - [BZ 1532802](https://bugzilla.redhat.com/1532802) <b>Webadmin: Listings of VMs, that depend on a template, are multiplied by the number of the template disk copies</b><br>
 - [BZ 1406766](https://bugzilla.redhat.com/1406766) <b>ovirt-engine dependencies module fetch java artifacts which jboss wildfly already provides</b><br>
 - [BZ 1540101](https://bugzilla.redhat.com/1540101) <b>Add vintage rhevh7.3 to compatibility 3.6 datacenter on rhvm4.2 failed</b><br>
 - [BZ 1540814](https://bugzilla.redhat.com/1540814) <b>upgrade dbscript fails if multiplication overflows</b><br>
 - [BZ 1541769](https://bugzilla.redhat.com/1541769) <b>Live storage migration, with the target domain configured to be backup, is allowed</b><br>
 - [BZ 1537176](https://bugzilla.redhat.com/1537176) <b>links in the bottom of Events dialog disappear</b><br>
 - [BZ 1513987](https://bugzilla.redhat.com/1513987) <b>Move disk option missing in the VM disk attachments action menu</b><br>
 - [BZ 1539361](https://bugzilla.redhat.com/1539361) <b>Reinitialize data-center will generate multiple OVF_STORE disks when deactivating single master storage domain</b><br>
 - [BZ 1503269](https://bugzilla.redhat.com/1503269) <b>User without permissions on destination SD can move disk</b><br>
 - [BZ 1540071](https://bugzilla.redhat.com/1540071) <b>An attempt to get the snapshot creation status with JSON request results in 406 response code from server.</b><br>
 - [BZ 1538814](https://bugzilla.redhat.com/1538814) <b>Imageio-Proxy: Failed to verify proxy ticket: Ticket life time expired</b><br>

#### VDSM

 - [BZ 1536826](https://bugzilla.redhat.com/1536826) <b>Start VM with uploaded ISO fails with libvirtError: unsupported configuration: native I/O needs either no disk cache or directsync cache mode, QEMU will fallback to aio=threads.</b><br>
 - [BZ 1511608](https://bugzilla.redhat.com/1511608) <b>host crash during vdsm-netupgrade leaves corrupted persisted networks</b><br>
 - [BZ 1533410](https://bugzilla.redhat.com/1533410) <b>Save full qemu core dump to provide maximum information about the crash (since RHEL 7.4 core dump doesn't contain guest memory dump)</b><br>
 - [BZ 1542423](https://bugzilla.redhat.com/1542423) <b>Distinguish between replication errors</b><br>
 - [BZ 1466461](https://bugzilla.redhat.com/1466461) <b>vdsm-client takes at least X4 more than vdsClient</b><br>
 - [BZ 1410283](https://bugzilla.redhat.com/1410283) <b>gluster cli: Exception when brick resides on  a btrfs subvolume</b><br>
 - [BZ 1533035](https://bugzilla.redhat.com/1533035) <b>[Scale] Passing a list of LUN guids to getDeviceList makes it execute slower than when running without it on all of the LUNs</b><br>
 - [BZ 1539108](https://bugzilla.redhat.com/1539108) <b>Silence bogus error when trying to check clean LUN status in getDeviceList</b><br>

### No Doc Update

#### oVirt Hosted Engine HA

 - [BZ 1504606](https://bugzilla.redhat.com/1504606) <b>Use the Domain XML to create the HE VM</b><br>

#### oVirt Hosted Engine Setup

 - [BZ 1504606](https://bugzilla.redhat.com/1504606) <b>Use the Domain XML to create the HE VM</b><br>

#### oVirt Engine

 - [BZ 1537594](https://bugzilla.redhat.com/1537594) <b>engine-setup --reconfigure-optional-components not covered by man-page</b><br>
 - [BZ 1518074](https://bugzilla.redhat.com/1518074) <b>Choosing multiple LUNs instead of exactly one when creating a new direct LUN disk for a new VM via Targets > LUNs table</b><br>
 - [BZ 1537603](https://bugzilla.redhat.com/1537603) <b>ovirt-engine-setup-plugin-vmconsole-proxy-helper is not re-asking to be enabled if once set to False</b><br>

---
title: oVirt 4.2.6 Release Notes
category: documentation
toc: true
page_classes: releases
---

# oVirt 4.2.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.2.6 release as of September 03, 2018.

Release has been updated on September 13, 2018.

Release has been updated on October 4th, 2018 with a new oVirt Node consuming CentOS 7.5 updates.

oVirt is an open source alternative to VMware™ vSphere™, providing an
awesome KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.5,
CentOS Linux 7.5 (or similar).



For detailed installation instructions, read the [Installation Guide](/documentation/install-guide/Installation_Guide/).

To learn about features introduced before 4.2.6, see the [release notes for previous versions](/documentation/#previous-release-notes).


## Install / Upgrade from previous versions

### CentOS / RHEL





In order to install it on a clean system, you need to install


`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm)


and then follow our
[Installation Guide](http://www.ovirt.org/documentation/install-guide/Installation_Guide/).


If you're upgrading from a previous release on Enterprise Linux 7 you just need
to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm
      # yum update "ovirt-*-setup*"
      # engine-setup



### No Fedora support

Regretfully, Fedora is not supported anymore, and RPMs for it are not provided.
These are still built for the master branch, so users that want to test them,
can use the [nightly snapshot](/develop/dev-process/install-nightly-snapshot/).
At this point, we only try to fix problems specific to Fedora if they affect
developers. For some of the work to be done to restore support for Fedora, see
also tracker [bug 1460625](https://bugzilla.redhat.com/showdependencytree.cgi?id=1460625&hide_resolved=0).

### oVirt Hosted Engine

If you're going to install oVirt as a Hosted Engine on a clean system please
follow [Self Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

If you're upgrading an existing Hosted Engine setup, please follow the [Upgrade Guide](/documentation/upgrade_guide/).

### EPEL

Don't enable all of EPEL on oVirt machines.

The ovirt-release package enables the EPEL repositories and includes several
specific packages that are required from there. It also enables and uses
the CentOS SIG repos, for other packages.

If you want to use other packages from EPEL, you should make sure to
use `includepkgs` and add only those you need avoiding to override
packages from other repos.

## Known Issues
- With oVirt Node 4.2.6 IP over infiniband is not working anymore after an upgrade, due to kernel
  3.10.0-862.11.6.el7.x86_64.
  You can find some detail here: https://bugs.centos.org/view.php?id=15193.
  An async release will be issued as soon as a new kernel will be available.


## What's New in 4.2.6?

### Enhancements

#### oVirt Engine

 - [BZ 1457250](https://bugzilla.redhat.com/1457250) <b>[RFE] Provide Live Migration for VMs based on "High Performance VM" Profile - manual migrations</b><br>Feature: <br>This feature provides the ability to enable the live migration for those HP VMs (and in general to all VM types with pinning settings).<br><br>Reason: <br>n oVirt 4.2 we added a new “High Performance” VM profile type. This required configuration settings includes pinning the VM to a host based on the host specific configuration. Due to that pinning settings, the migration option for the HP VM type was automatically forced to be disabled.<br><br>Result: <br>in oVirt 4.2.x we will provide the ability to manual migrate the HP VM. This is the first phase solution as mentioned in the feature page.<br>In next oVirt release 4.2 we will provide a full automatic solution.<br><br>This solution for 4.2.x includes:<br>1. Only manual migration can be done for HP VMs via the UI. In addition the user will have to choose the destination host to migrate to.<br>2. Manual migration is also supported for Server/Desktop VM types with pinned configuration, but only via REST api.<br><br>For more details on this first phase/manual solution, please refer to the feature page: https://www.ovirt.org/develop/release-management/features/virt/high-performance-vm-migration/
 - [BZ 1590967](https://bugzilla.redhat.com/1590967) <b>[RFE] Display space savings when a VDO volume is used.</b><br>Feature: Reporting VDO space savings on the Storage domains, gluster volumes and bricks<br><br>Reason: Good to know it.<br><br>Result: Storage Domain view, Volume view and Brick view now include a 'VDO savings' field with savings percent.
 - [BZ 1393372](https://bugzilla.redhat.com/1393372) <b>iscsi: request and parse ipv6 targets from vdsm (in clusterLevel>=4.1) - engine side</b><br>Feature: <br>Discover and login to ipv6 addresses while creating a new iSCSI storage domain.<br><br>Reason: <br>In case of trying to discover an ipv6 address, there's an error message. Therefore only discovery for ipv4 is being supported today.<br><br>Result:<br>The user can successfully discover ipv6 addresses.<br>This is enabled by default on clusterLevel >=4.3, but may be enabled manually on clusterLevel=4.2 if all of your hosts are >= 4.2.6 with<br><br> engine-config -s ipv6IscsiSupported=true --cver=4.2
 - [BZ 1558847](https://bugzilla.redhat.com/1558847) <b>[RFE] Sync all networks across all hosts in cluster</b><br>Previously, if a host's networks network definitions became unsynchronized with the definitions on the Manager, there was no way to synchronize all unsynchronized hosts on the cluster level.<br>In this release, a new Sync All Networks button has been added to the Cluster screen in the Administration Portal that enables users to synchronize all unsynchronized hosts with the definitions defined on the Manager.
 - [BZ 1565541](https://bugzilla.redhat.com/1565541) <b>packaging: Ansible playbook to set ovn cluster tunnel should accept long network names</b><br>Previously, it was not possible to define long network names when modifying the tunnelling network for OVN controllers.<br><br>In this release, a script has been provided to enable long network names to be used for tunnelling network definitions.
 - [BZ 1625171](https://bugzilla.redhat.com/1625171) <b>[downstream clone - 4.2.6] [RFE] Should be able to change the Port number of NoVnc</b><br>
 - [BZ 1596151](https://bugzilla.redhat.com/1596151) <b>enable migration for cpu pinned VMs</b><br>Remove the config parameter called "CpuPinMigrationEnabled" (appears on DB in vdc_options table) in downstream and upstream installations. <br>This change was done to support High Performance VM live migration (BZ 1457250)

#### oVirt Setup Lib

 - [BZ 1295041](https://bugzilla.redhat.com/1295041) <b>[RFE] add IPv6 support to ovirt-setup-lib</b><br>Previously, the engine-setup tool did not support host names that only resolved to an IPv6 address.<br>In this release, the engine-setup tool supports host names that only resolve to an IPv6 address.

#### oVirt Hosted Engine Setup

 - [BZ 1608467](https://bugzilla.redhat.com/1608467) <b>[TEXT] - the deployment will fail late if firewalld is disabled or masked on the host</b><br>Self-hosted engine deployment fails if firewalld is masked on the host. This is now checked earlier in the deployment script.

#### oVirt Engine Metrics

 - [BZ 1607127](https://bugzilla.redhat.com/1607127) <b>[RFE] Update ansible-inventory file to use latest instead of version</b><br>The current release always uses the latest Ansible inventory file, so that a particular Openshift version no longer needs to be specified and the documentation is always up to date.

### Bug Fixes

#### oVirt Engine

 - [BZ 1623447](https://bugzilla.redhat.com/1623447) <b>[downstream clone - 4.2.6] Pending change IO thread disable is not applied on shutdown</b><br>
 - [BZ 1622994](https://bugzilla.redhat.com/1622994) <b>[downstream clone - 4.2.6] IO-Threads is enabled inadvertently by editing unrelated configuration</b><br>
 - [BZ 1609147](https://bugzilla.redhat.com/1609147) <b>[REST API] all VMs in VM Pool are returned to a pool user regardless of actual VM ownership</b><br>
 - [BZ 1581709](https://bugzilla.redhat.com/1581709) <b>Move the vfio-mdev vGPU hook to a VDSM code base</b><br>
 - [BZ 1608828](https://bugzilla.redhat.com/1608828) <b>[downstream clone - 4.2.6] Unable to perform upgrade from 4.1 to 4.2 due to selinux related errors.</b><br>
 - [BZ 1613875](https://bugzilla.redhat.com/1613875) <b>[downstream clone - 4.2.6] Indicate that RHV-H hosts have to be rebooted always after upgrade</b><br>

#### VDSM

 - [BZ 1581709](https://bugzilla.redhat.com/1581709) <b>Move the vfio-mdev vGPU hook to a VDSM code base</b><br>

#### oVirt Windows Guest Tools

 - [BZ 1609779](https://bugzilla.redhat.com/1609779) <b>Unquoted Service Paths Windows guest tools</b><br>

#### imgbased

 - [BZ 1601633](https://bugzilla.redhat.com/1601633) <b>If upgrading fails, the new LV should be removed in the RPM %post script</b><br>

### Other

#### oVirt Provider OVN

 - [BZ 1590359](https://bugzilla.redhat.com/1590359) <b>[ovn-provider] wrong message when posting a Subnet with no default gateway</b><br>
 - [BZ 1503577](https://bugzilla.redhat.com/1503577) <b>Duplicate OVN network name (with subnet) on different DCs pops unfriendly UI message</b><br>
 - [BZ 1608408](https://bugzilla.redhat.com/1608408) <b>Listing ports fails when stray subnet is present in db</b><br>

#### oVirt Engine

 - [BZ 1615124](https://bugzilla.redhat.com/1615124) <b>[RFE] upload image - add sparse flag to ticket</b><br>
 - [BZ 1613282](https://bugzilla.redhat.com/1613282) <b>Failed to hot-Unplug disk from VM with Code 46 (Timeout detaching)</b><br>
 - [BZ 1610758](https://bugzilla.redhat.com/1610758) <b>When specifying folder of OVAs in import dialog, the task hangs forever</b><br>
 - [BZ 1601469](https://bugzilla.redhat.com/1601469) <b>[OVN] - Create external network's vNIC profile without network filter</b><br>
 - [BZ 1613104](https://bugzilla.redhat.com/1613104) <b>The engine is generating domain XML for HE VM also if the cluster compatibility level doesn't allow it</b><br>
 - [BZ 1595140](https://bugzilla.redhat.com/1595140) <b>Exceptions seen with refreshing geo-rep session on the gluster volume</b><br>
 - [BZ 1610248](https://bugzilla.redhat.com/1610248) <b>Create new Georep session popup does not open</b><br>
 - [BZ 1590109](https://bugzilla.redhat.com/1590109) <b>refresh caps events are not sent on network dhcp attachment or update</b><br>
 - [BZ 1607704](https://bugzilla.redhat.com/1607704) <b>[Engine] Cannot modify vNic profile of running vm with MTU set in its XML</b><br>
 - [BZ 1584734](https://bugzilla.redhat.com/1584734) <b>A UI exception while creating a new network on external provider</b><br>
 - [BZ 1571563](https://bugzilla.redhat.com/1571563) <b>The VM could not be edited from HighPerformance or Server to Desktop in PPC arch (even if the new create of Desktop is allowed)</b><br>
 - [BZ 1589790](https://bugzilla.redhat.com/1589790) <b>[UI] - Remove subnet sub tab from edit external network flow</b><br>
 - [BZ 1603878](https://bugzilla.redhat.com/1603878) <b>[UI] Cannot copy-paste Network Interface MAC address</b><br>
 - [BZ 1619730](https://bugzilla.redhat.com/1619730) <b>increase execution rate of ExtendImageTicket</b><br>
 - [BZ 1620178](https://bugzilla.redhat.com/1620178) <b>Auto enable multiple network queues for high Performance VMS</b><br>
 - [BZ 1613341](https://bugzilla.redhat.com/1613341) <b>API doesn't return stored ssh public key for non admin user properly</b><br>
 - [BZ 1552098](https://bugzilla.redhat.com/1552098) <b>Rephrase: "command GetStatsAsyncVDS failed: Heartbeat exceeded" error message</b><br>
 - [BZ 1570988](https://bugzilla.redhat.com/1570988) <b>Don't try to remove functions, views or tables in public schema installed by PostgreSQL extensions</b><br>
 - [BZ 1608392](https://bugzilla.redhat.com/1608392) <b>Status code from the API for unsupported reduce volume actions (for disk that resides on file based domain for example) is 400 (bad request) instead 409 (conflict)</b><br>
 - [BZ 1573184](https://bugzilla.redhat.com/1573184) <b>StreamingAPI - Transfer disk Lock is freed before transfer is complete - after Finalizing phase but before Finished Success</b><br>
 - [BZ 1608716](https://bugzilla.redhat.com/1608716) <b>upload image - rounded up size value for the created disk</b><br>
 - [BZ 1625150](https://bugzilla.redhat.com/1625150) <b>[downstream clone - 4.2.6] Creating transient disk during backup operation is failing with error "No such file or directory"</b><br>
 - [BZ 1579303](https://bugzilla.redhat.com/1579303) <b>External VMs prevent placing host in maintenance mode</b><br>
 - [BZ 1600325](https://bugzilla.redhat.com/1600325) <b>Link to change password is broken</b><br>
 - [BZ 1591271](https://bugzilla.redhat.com/1591271) <b>Get Internal Server Error while trying to get graphic console, while VM suspending</b><br>
 - [BZ 1608265](https://bugzilla.redhat.com/1608265) <b>change GB labels to GiB</b><br>
 - [BZ 1607131](https://bugzilla.redhat.com/1607131) <b>UI exception is thrown when trying to create a VM from template with CD-ROM from ISO attached to the template</b><br>
 - [BZ 1602339](https://bugzilla.redhat.com/1602339) <b>VM with preallocated/RO disks only can run even if the storage domain that holds the disks is in maintenance</b><br>
 - [BZ 1600534](https://bugzilla.redhat.com/1600534) <b>Status code from the API for incompatible disk configuration for disk creation is 400 (bad request) instead of 409 (conflict)</b><br>

#### VDSM

 - [BZ 1600140](https://bugzilla.redhat.com/1600140) <b>[VDSM] Cannot modify vNic profile of  running vm with MTU set in its XML</b><br>
 - [BZ 1595636](https://bugzilla.redhat.com/1595636) <b>vdsm-hook-vfio-mdev failed to run VM with Intel GVT-g device.</b><br>
 - [BZ 1612904](https://bugzilla.redhat.com/1612904) <b>[downstream clone - 4.2.6] getFileStats fails on NFS domain in case or recursive symbolic link (e.g., using NetApp snapshots)</b><br>
 - [BZ 1614657](https://bugzilla.redhat.com/1614657) <b>[downstream clone - 4.2.6] Kdump Status is disabled after successful fencing of host.</b><br>
 - [BZ 1613838](https://bugzilla.redhat.com/1613838) <b>"TemporaryFailure: Cannot inquire Lease" during storage pool removal</b><br>
 - [BZ 1612958](https://bugzilla.redhat.com/1612958) <b>Ctor parameters not passed correctly to API.ISCSIConnection.__init__</b><br>
 - [BZ 1562369](https://bugzilla.redhat.com/1562369) <b>Hosts show sanlock renewal errors in /var/log/messages</b><br>

#### cockpit-ovirt

 - [BZ 1614426](https://bugzilla.redhat.com/1614426) <b>Gluster deployment wizard throws Null Pointer Exception after finished deployment</b><br>
 - [BZ 1540936](https://bugzilla.redhat.com/1540936) <b>cockpit accepts (and propose by default) localhost as the host address and this fails for sure since the engine VM will try to deploy itself as the host</b><br>
 - [BZ 1597255](https://bugzilla.redhat.com/1597255) <b>The mount point of the additional volume created during gluster deployment is not correct .</b><br>

#### VDSM JSON-RPC Java

 - [BZ 1552098](https://bugzilla.redhat.com/1552098) <b>Rephrase: "command GetStatsAsyncVDS failed: Heartbeat exceeded" error message</b><br>

#### oVirt Engine SDK 4 Python

 - [BZ 1580268](https://bugzilla.redhat.com/1580268) <b>Add example how to clearing virtual numa nodes of VM via API</b><br>

#### oVirt image transfer daemon and proxy

 - [BZ 1615122](https://bugzilla.redhat.com/1615122) <b>[v2v] fast-zero - support sparse uploads on file storage</b><br>
 - [BZ 1619019](https://bugzilla.redhat.com/1619019) <b>[v2v] Broken pipe (Errno 32) occurs during multiple VMs conversion</b><br>
 - [BZ 1615144](https://bugzilla.redhat.com/1615144) <b>[v2v] fast-zero - to improve performance</b><br>
 - [BZ 1614195](https://bugzilla.redhat.com/1614195) <b>[v2v] Keep more logs with ovirt-imageio-daemon</b><br>
 - [BZ 1614202](https://bugzilla.redhat.com/1614202) <b>[v2v] Reduce logging details per upload</b><br>
 - [BZ 1592847](https://bugzilla.redhat.com/1592847) <b>[v2v] ovirt-Imageio-daemon Memory growth unreasonable during disk transfer</b><br>

#### oVirt Ansible virtual machine infrastructure role

 - [BZ 1601445](https://bugzilla.redhat.com/1601445) <b>Role fails when vms list is empty</b><br>

#### imgbased

 - [BZ 1598781](https://bugzilla.redhat.com/1598781) <b>Upgrading RHV-H is bringing back libvirt network file which causes issues in starting of VM</b><br>

#### oVirt Engine database query tool

 - [BZ 1609667](https://bugzilla.redhat.com/1609667) <b>rhv-log-collector-analyzer does not provide any content in html report</b><br>

### No Doc Update

#### oVirt Engine

 - [BZ 1608961](https://bugzilla.redhat.com/1608961) <b>tear down ovirt-provider-ovn when an host is removed from ovirt-engine</b><br>
 - [BZ 1566112](https://bugzilla.redhat.com/1566112) <b>Exception when trying to run multiple VMs (VMs failed to run)</b><br>


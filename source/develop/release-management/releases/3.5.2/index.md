---
title: oVirt 3.5.2 Release Notes
category: documentation
toc: true
authors:
  - pkliczewski
  - sandrobonazzola
---

# oVirt 3.5.2 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.5.2 release as of April 28th, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Fedora 20, Red Hat Enterprise Linux 6.6, CentOS 6.6, (or similar) and Red Hat Enterprise Linux 7.1, CentOS 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/). 

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

oVirt 3.5.2 release is available since 2015-04-28.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

If you are upgrading from a previous version, you may have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](/develop/release-management/releases/3.4.1/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup



### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.2/ovirt-live-el6-3.5.2.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.2/ovirt-live-el6-3.5.2.iso)

### oVirt Node

New oVirt Node ISO are available:

[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-node/el6-3.5.2/ovirt-node-iso-3.5-0.999.201504280933.el6.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-node/el6-3.5.2/ovirt-node-iso-3.5-0.999.201504280933.el6.iso)
[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-node/el7-3.5.2/ovirt-node-iso-3.5-0.999.201504280931.el7.centos.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-node/el7-3.5.2/ovirt-node-iso-3.5-0.999.201504280931.el7.centos.iso)

## What's New in 3.5.2?

## Known issues

*   NFS startup on EL7 / Fedora20: due to other bugs ( or ), NFS service is not always able to start at first attempt (it doesn't wait the kernel module to be ready); if it happens oVirt engine setup detects it and aborts with

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

Retrying (engine-cleanup, engine-setup again) it's enough to avoid it cause the kernel module it's always ready on further attempts. Manually starting NFS service (/bin/systemctl restart nfs-server.service) before running engine setup it's enough to avoid it at all.

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

*   Engine and host upgrade ordering due to bug . When upgrading your deployment to 3.5.2 please your upgrade engine first and next your hosts. When following order is not preserved you will see following error every 3 seconds (by default):

      ERROR [org.ovirt.engine.core.vdsbroker.vdsbroker.ListVDSCommand] (DefaultQuartzScheduler_Worker-28) [] Command 'ListVDSCommand(HostName = kenji, HostId = 9f569269-d267-4bf9-96c5-e1749b4c8dda, vds=Host[kenji,9f569269-d267-4bf9-96c5-e1749b4c8dda])' execution failed: java.util.LinkedHashMap cannot be cast to java.lang.String

Following exception prevents host monitoring but affected host stays in status 'UP' and is operational. Virtual machine status collection is gathered every 15 seconds (by default).

## CVE Fixed

## Bugs fixed

### oVirt Engine

**Fixed in oVirt 3.5.2.1 Async Release**
 - Importing storage domains into an uninitialized datacenter leads to duplicate OVF_STORE disks being created, and can cause catastrophic loss of VM configuration data
 - Tracker: oVirt 3.5.2.1 release

**Fixed in oVirt 3.5.2 RC4 / Final release**
 - Template creation stuck after upgrade
 - "Authentication Required" login screen that references RESTAPI
 **Fixed in oVirt 3.5.2 RC3**
 - Typos in CDA message when importing a "dirty" SD to an uninitialized DC
 **Fixed in oVirt 3.5.2 RC2**
 - NPE when adding a VM to a VM pool when there's not enough storage
 - Missing namespace and prinicipal parameters for managing users in CLI
 - [AAA] process initialization errors
 - [backend] [NPE] Adding permission to an object fails if DEBUG level is set
 - [performance] bad getVMList output creates unnecessary calls from Engine
 - Configure new user role dialog: faulty rendering due to javascript exception (missing "ActionGroup___DISK_LIVE_STORAGE_MIGRATION")
 **Fixed in oVirt 3.5.2 RC1**
 - Data Center downgrade should not be allowed if it implies downgrading the storage format
 - [engine-backend] Moving a shared disk to a gluster domain is not blocked
 - Overlap of "Enable Virt Service" and "Enable Gluster Service" radio buttons
 - [RFE] Add default-options to iDrac7 Fencing agent in RHEVM
 - [restapi] Add support to search disk by name parameter
 - Null disk size on a newly created disk is interpreted 0. Leave as null and revise usage.
 - External Keystone Connection Fails to Juno-based OpenStack
 - RHEV: Faulty storage allocation checks when merging a snapshot
 - if next run configuration exists the edit VM may load forever
 - Instance type: missing VM fields while using InstanceCreator user role.
 - engine-setup unconditionally enables the engine if ran on dwh on separate host
 - [engine-backend] Null disk size on a newly created disk is interpreted 0. Leave as null and revise usage.
 - [external providers] invalid certificate fingerprint is printed on confirmation dialog
 - [engine-backend] [iSCSI multipath] Cannot edit iSCSI multipath bond while iSCSI SD is in maintenance
 - [extapi] add default constructos
 - [engine-backend] requests doesn't reach vdsm
 - When an ISO domain is connected to multiple data centers in different statuses the image list is not fetched
 - Fencing test failed during adding single rhev-h host, but message says otherwise
 - Power management test with non approved host
 - Storage thresholds should not be inclusive
 - [AAA] [extmgr] escape extension name in ENGINE_EXTENSION_ENABLED_ configuration
 - failure of master migration on deactivation will leave domain locked
 - override SSL protocol to TLSv1
 - Bad error when adding vm to pool with low space on storage domain
 - Change message when importing a data domain to an unsupported version
 - Upgrade message in general tab is missing
 - Import of non data Storage Domains (specifically export domain) should not call engine query for web warning
 - Failure for calling internal query GetExistingStorageDomainList will cause an NPE
 - [RFE][engine-backend][HC] - add the possibility to import existing Gluster and POSIXFS export domains
 - [JSON] Force extend block domain, in JSONRPC, using a "dirty" LUN, fails
 - domain state is stuck on "Preparing For Maintenance" when having active gluster service cluster
 - [backend] [NPE] Adding permission to an object fails if DEBUG level is set
 - ENGINE_HEAP_MAX default value as 1G must be changed
 - Locked snapshot prevents VM's basic operations, after it's disk was removed
 - [Engine] Engine runs out of memory - java.lang.OutOfMemoryError: Java heap space
 - Using "iSCSI Bond", host does not disconnect from iSCSI targets
 - RHEV-M managed firewall blocks NFS rpc.statd notifications
 - Sysprep problem after upgrade from oVirt Engine 3.5.0.1-1 to 3.5.1.1-1.el6
 - High availability Virtual Machines are not restarted on another host during fencing.
 - [AAA] Always set principal in Authz.FetchPrincipalRecord
 - Can not restore backup file to rhevm with non-default lc_messages
 - Document All-Content header in RSDL and add it to SDKs
 - [AAA] Sorting by 'authorization provider' in 'users' tab don't sort
 - Unable to authenticate if user is using [INDEED ID](http://indeed-id.com/) solution for authentication.
 - [host-deploy] missing -t parameter to mktemp
 - Engine-setup should support cleaning of zombie commands before upgrade

### ovirt-hosted-engine-setup

**Fixed in oVirt 3.5.2 RC3 / Final release**
 - [hosted-engine] [iSCSI support] connectStoragePools fails with "SSLError: The read operation timed out" while adding a new host to the setup
 **Fixed in oVirt 3.5.2 RC1 / Final release**
 - [hosted-engine] Bad check of iso image permission
 - vdsClient/vdscli SSLError timeout error
 - [RFE][HC] make override of iptables configurable when using hosted-engine

### ovirt-iso-uploader

**Fixed in oVirt 3.5.2 RC1 / Final release**
 - [engine-iso-uploader] engine-iso-uploader does not work with Local ISO domain

### ovirt-log-collector

**Fixed in oVirt 3.5.2 RC1 / Final release**
 - [RHEL7] Missing some info from host's archive

### ovirt-optimizer

**Fixed in oVirt 3.5.2 RC2 / Final release**
 - font and tab case don't match
 - [EL7] ovirt-optimizer is missing dependencies
 - fixed link to jquery

### VDSM

**Fixed in oVirt 3.5.2 RC4 / Final release**
 - RHEV: Failed to Delete First snapshot with live merge
 - [RHEL7.0] oVirt fails to create glusterfs domain
 - [New] - Host status does not move to non-operational when glusterd is down.
 - Live Merge: Active layer merge is not properly synchronized with vdsm
 - Vdsm upgrade 3.4 >> 3.5.1 doesn't restart vdsmd service
 - StorageDomainAccessError: Domain is either partially accessible or entirely inacessible when creating an iSCSI storage domain with RHEV-H 6.6
 - [3.5-6.6/7.1] Failed to retrieve iscsi lun from hardware iscsi after register to RHEV-M
 **Fixed in oVirt 3.5.2 RC3**
 - VDSM script reset network configuration on every reboot when based on predefined bond
 - vdsm failing to start due to KeyError at vdsm-restore-net-config
 - vdsClient/vdscli SSLError timeout error
 - [Rhel7.1] After live storage migration on block storage vdsm extends migrated drive using all free space in the vg
 - [performance] bad getVMList output creates unnecessary calls from Engine
 - [performance] bad getVMList output creates unnecessary calls from Engine
 - After failure to setupNetworks: restore-nets with unified persistence does not restore pre-vdsm ifcfg
 - Live-deleting a snapshot of preallocated disk results in a block domain using up all available space
 - [SCALE] snapshot deletion -> heavy swapping on SPM
 - Failed to auto shrink qcow block volumes on merge
 - [RHEL 7.0 + 7.1] Host configure with DHCP is losing connectivity after some time - dhclient is not running
 **Fixed in oVirt 3.5.2 RC1**
 - Wrong default multipath configuration for EL6
 - vdsm package causes logrotate to trigger selinux AVC alerts
 - [rhevh66] vdsm does not come up after first reboot after registration
 - Vdsm reports wrong NIC state, Error while sampling stats
 - Upgrade from RHEV-H 6.5 to RHEV-H 6.6 during upgrade from RHEV 3.4 to RHEV 3.5 Wiped Network Static IPs
 - rhev-m stops syncing the VM statuses after massive live VM migration which fails.
 - Excessive cpu usage due to wrong timeout value
 - [engine-backend] [external-provider] Glance integration: UploadImage (Export disk) fails with java.lang.String
 - [JSONRPC] Disk resize fails while vm is down
 - iSCSI multipath fails to work and only succeed after adding configuration values for network using sysctl
 - [vdsm] spmStart fails with timeout, the DC cannot be initialized
 - Problem parsing stomp frames where trailing \\0 was cut off
 - [scale] Data Center crashing and contending forever due to missing pvs. All SDs are Unknown/Inactive.
 - Require ioprocess 0.14


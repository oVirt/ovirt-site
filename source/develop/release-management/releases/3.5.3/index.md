---
title: oVirt 3.5.3 Release Notes
category: documentation
toc: true
authors:
  - alonbl
  - didi
  - sandrobonazzola
---

# oVirt 3.5.3 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.5.3 release as of June 15th, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.
This release is available now for Fedora 20, Red Hat Enterprise Linux 6.6, CentOS Linux 6.6, (or similar) and Red Hat Enterprise Linux 7.1, CentOS Linux 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

```console
# yum localinstall http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm
```

If you are upgrading from a previous version, you may have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](/develop/release-management/releases/3.4.1/) for upgrade instructions.

For upgrading now you just need to execute:

```console
# yum update "ovirt-engine-setup*"
# engine-setup
```


### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.3/ovirt-live-el6-3.5.3.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.3/ovirt-live-el6-3.5.3.iso)

### oVirt Node

## What's New in 3.5.3?

## Known issues

### PKI

Certain issues were found and planned to be fixed, eventually postponed to 3.5.4.

Please see the [3.5.4 release notes](/develop/release-management/releases/3.5.4/#pki) for details.

### Upgrade issues

*   Engine and host upgrade ordering due to bug . When upgrading your deployment to 3.5.3 please your upgrade engine first and next your hosts. When following order is not preserved you will see following error every 3 seconds (by default):

      ERROR [org.ovirt.engine.core.vdsbroker.vdsbroker.ListVDSCommand] (DefaultQuartzScheduler_Worker-28) [] Command 'ListVDSCommand(HostName = kenji, HostId = 9f569269-d267-4bf9-96c5-e1749b4c8dda, vds=Host[kenji,9f569269-d267-4bf9-96c5-e1749b4c8dda])' execution failed: java.util.LinkedHashMap cannot be cast to java.lang.String

Following exception prevents host monitoring but affected host stays in status 'UP' and is operational. Virtual machine status collection is gathered every 15 seconds (by default).

### Distribution specific issues

*   NFS startup on EL7 / Fedora20: due to other bugs ( or ), NFS service is not always able to start at first attempt (it doesn't wait the kernel module to be ready); if it happens oVirt engine setup detects it and aborts with

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

Retrying (engine-cleanup, engine-setup again) it's enough to avoid it cause the kernel module it's always ready on further attempts. Manually starting NFS service (/bin/systemctl restart nfs-server.service) before running engine setup it's enough to avoid it at all.

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

## CVE Fixed

*   [CVE-2015-3456](https://access.redhat.com/security/cve/CVE-2015-3456) - qemu: fdc: out-of-bounds fifo buffer memory access; also known as [VENOM Vulnerability](http://web.archive.org/web/20200817052936/https://venom.crowdstrike.com/)
    -   EL7: **qemu-kvm-ev-2.1.2-23.el7_1.3**
    -   EL6: **qemu-kvm-rhev-0.12.1.2-2.448.el6_6.3**
    -   Fedora 21: [qemu-2.1.3-7.fc21](http://koji.fedoraproject.org/koji/buildinfo?buildID=636796)
    -   Fedora 20: [qemu-1.6.2-14.fc20](http://koji.fedoraproject.org/koji/buildinfo?buildID=636794)
*   [CVE-2015-3209](https://access.redhat.com/security/cve/CVE-2015-3209) - qemu: pcnet: multi-tmd buffer overflow in the tx path
    -   EL6: **qemu-kvm-rhev-0.12.1.2-2.448.el6.4**

## Bugs fixed

### oVirt Engine

**oVirt 3.5.3 RC3 / GA**
Dropped the following bugs:
 - Missing details in engine log for "add VM Disk Profile doesn't match provided Storage Domain" failure
 - UX: addHost form leaves json checkbox locked when switching between clusters
 - rhevm-setup - update - pki: Enroll certs on upgrade if not exist
 - [RFE][PKI] renew important certificate when about to expire during engine-setup
 - [PKI] CA certificate notBefore should confirm to rfc2459
 **oVirt 3.5.3 RC2**
 - Tracker: oVirt 3.5.3 release
 - rhevm-setup - update - pki: Enroll certs on upgrade if not exist
 **oVirt 3.5.3 RC1**
 - ovirt-engine should refresh documentation-mapping cache on login, not first access
 - Engine not show host numa nodes until I run "Refresh Capabilities"
 - [RFE] Bundle GWT symbol maps in GWT application's rpm package
 - [engine-backend] When reconstruct master is marked as finished, the problematic domain is reported as active, while the new master is inactive
 - [engine-webadmin] [importDomain] Importing an iSCSI domain while the storage server is not accessible fails with an ugly message
 - Import a storage domain is missing properties (vs. edit/new)
 - Detach of Storage Domain leaves leftover of vm_interface_statistics and cause an sql exception when importing the VM again
 - [engine-backend] [importDomain] Virt-IO-SCSI flag is disabled once the VM gets registered
 - Start vm that have memory and guaranteed memory above host free memory, failed with libvirtd error
 - RHEV-M admin portal pagination issue: disappeared list of VMs after sort it and select next page
 - Async tasks should not be allowed in 3.3 compatible cluster in RHEV 3.4
 - [ImportDomain,REST-API] Allow oVirt to discover FCP domains via 'unregisteredstoragedomainsdiscover'
 - Missing space in audit log space threshold message, missing points in end of sentence.
 - [Quota] Disk extension allows to bypass quota restrictions
 - Root template cannot be removed after removing root template - sub templates.
 - [services] ipv6 is disabled within ovirt-engine service
 - Context Sensitive Help: GUI needs to use different mapping files for different locales.
 - NullPointerException when testing configuration of fence agent for the new host
 - Host status is not restored if power management start/stop action failed
 - Context Sensitive Help: GUI needs to use different mapping files for different locales.
 - engine-setup accepts an answer file with an invalid value for applicationMode
 - Space Used column header text isn't fully displayed
 - UX: addHost form leaves json checkbox locked when switching between clusters
 - [PKI] CA certificate notBefore should confirm to rfc2459
 - [RHEVM3.5] import vm fails. Error while executing action: Cannot import VM. Invalid time zone for given OS type.
 - After activating iscsi domain, can't add a new disk due to lack of space though there should be space.
 - Missing details about GlusterFS domain's connection in RESTAPI
 - Storage migration removes snapshot preview from the storage
 - Import storage domain function is not setup to handle local disk hypervisors which has the same path
 - [pki] pki-pkcs12-extract.sh fails with /dev/fd is not mounted
 - Missing vms link under /api/.../storagedomains/{storagedomain:id}/
 - [RFE][PKI] renew important certificate when about to expire during engine-setup
 - UX: "Advanced Parameters" panel disappear when choosing to use hosts provider  - [RFE] enable SPICE/QXL support for Windows 8/2012 even without the QXL drivers
 - Setting "Other OS" is default 32bit instead of 64bit and causes incorrect RAM size limit of 16GB for 64bit OS.
 - [de_DE][Admin Portal] Text alignment on cluster>new>cluster policies page needs to be corrected.
 - Run vm with one cpu and two numa nodes failed
 - "Migrate only Highly Available Virtual Machines" need to capitalize the "only"
 - Missing details in engine log for "add VM Disk Profile doesn't match provided Storage Domain" failure
 - NPE when cloning a VM from snapshot WITHOUT "VirtIO-SCSI Enabled"

### VDSM

**VDSM 4.16.20**
 - vdsmd fails to start
 **VDSM 4.16.19**
 - vdsmd fails to start
 **VDSM 4.16.18**
 - vdsmd fails to start
 **VDSM 4.16.17**
 - Passwords exposed in vdsm log when using jsonrpc transport
 - RHEV [RHEL7.1] - Require qemu fix for "Cannot start VMs that have more than 23 snapshots"
 - [vdsm] Template creation on XtremeIO with pre-allocated disks on block storage fails with "CopyImageError: low level Image copy failed"
 - Host fails to flip to maintenance mode due to failed live migrations.
 - el6: libvirtd configurator configures upstart but does not disable libvirtd's sysv job
 - unable to add new VLAN when using net_persistence=ifcfg
 - vdsm fails to read dhclient lease config "expire never"
 **VDSM 4.16.16**
 - VDSM leaks small mount of memory (~300KiB/h)
 - [engine-backend] When reconstruct master is marked as finished, the problematic domain is reported as active, while the new master is inactive
 - [vdsm] errors: value of 'vcpu_period' is out of range [1000, 1000000]
 - Long filename support for Windows VM payload
 - [HC] vdsm checks for qemu-kvm-rhev missing qemu-kvm-ev
 - Unit tests do not expect the new 'esp' flag on the partitions
 - testGetBondingOptions fails, missing defaults
 - vdsm NUMA code not effective, slowing down statistics retrieval

### oVirt Reports

* Errors during installation and config when openjdk is NOT default in an environment.

### oVirt Data Warehouse

* Aggregation of disks usage is running slow

### OTOPI

* [core] executePipe call callback only if available

### oVirt Hosted Engine HA

* Unexpected Migration of HostedEngine
 - Log entries should explain why HE agent try to start vms on both hosts

### oVirt Hosted Engine Setup

* Failed to deploy additional host due to unconfigured iptables
 - Running hosted-engine --vm-status, when ovirt-ha-broker service stopped, drop exception
 - [TEXT ONLY] - Hosted Engine - Instructions for handling Invalid Storage Domain error
 - [self-hosted] Can't add 2nd host into self-hosted env: The VDSM host was found in a failed state... Unable to add slot-5b to the manager

### oVirt Log Collector

* log-collector tar files change "." permissions when extracted
 - [RFE] Log collector does not collect hosted engine information
 - split rhevm-log-collector moving sos plugins to subpackage

### oVirt Optimizer

* Optimizer should not propose steps if solution is not doable


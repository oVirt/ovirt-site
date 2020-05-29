---
title: oVirt 3.5.6 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 3.5.6 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.5.6 release as of December 1st.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.1, CentOS Linux 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/). 

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

If you are upgrading from a previous version, you may have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](/develop/release-management/releases/3.4.1/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](/documentation/how-to/hosted-engine/#fresh-install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](/documentation/how-to/hosted-engine/#upgrade-hosted-engine) guide.

### oVirt Live

A new oVirt Live ISO is available:

[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.6/ovirt-live-el6-3.5.6.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.6/ovirt-live-el6-3.5.6.iso)

## Bugs fixed

### oVirt Engine

* Failed to remove Data Center
 - Close button not work in NUMA pinning window
 - Unable to add label to bond0 when trunk contains additional VLANs which are used to register the host to RHEV-M
 - API doesn't support specifying vm-pool type
 - Non-ascii chars in the disk name break the template creation
 - If block disk alias or description is too long, disk metadata will be truncated, causing various failures
 - webadmin portal allows to add non-ascii characters in the disk_description which causes false positive object creation in log.
 - [AAA] ovirt-engine-role.sh fixups
 - zstream clone: Two instances of UpdateStorageDomainCommand/ExtendSANStorageDomainCommand executed concurrently
 - engine-setup hangs indefinitely starting ovirt-websocket-proxy via service using python subprocess module
 - [z-stream clone 3.5.6] [vdsm] SpmStart fails after "offline" upgrade of DC with V1 master domain to 3.5
 - Storage pool version/domains format isn't reverted although no dc upgrade occurred
 - [REST-API] cloud-init image does not include cloud-init user defined input when vm is started via API
 - [windows 10] [3.6 engine/3.5 cluster] Windows 10 are restarting - SYSTEM_THREAD_EXCEPTION_NOT_HANDLES
 - [z-stream clone 3.5.6] Supposedly cancelled, yet completed change of cluster
 - [z-stream clone 3.5.6] Second run of Windows VM fails because of access problem to sysprep payload
 - [z-stream clone 3.5.6] Vm becomes unusable (NPE) when restarting vdsm during snapshot creation
 - [z-stream clone 3.5.6] Can't login to Admin portal after engine-manage-domains command
 - [engine-setup] PKI CONFIGURATION points to upstream wiki about certificates renewal info

### oVirt Hosted Engine HA

* RHEV-H with HE upgrade failed on Step: RHEV_INSTALL via Hosted-Engine, vdsm service is not stopped

### VDSM

* Failed to hot unplug disk in VDSM which runs Python <= 2.7
 - Remove network disk or direct lun times out
 - [vdsm] hotplugDisk fails with 'internal error unable to execute QEMU command '__com.redhat_drive_add': Duplicate ID 'drive-virtio-disk1' for drive'
 - Consume fix for "Multipath is not correctly identifying iscsi devices, and misconfiguring them"
 - vdsm fails to start if dhclient is running
 - Restoring a RAM snapshots in RHEL7.2 shows error stating the vm (even though it starts correctly) and fails to connect via spice(SetVmTicket: Unexpected exception)
 - Vdsm should recover ifcfg files in case they are no longer exist and recover all networks on the server
 - regression for EL7: spmprotect always reboot when fencing vdsm on systemd
 - [scale] high vdsm threads overhead
 - zstream clone: Extend of VG does not check if additional devices are already part of it
 - zstream clone: OSError: [Errno 24] Too many open files while running automation tests
 - automated CI checks no longer work in the ovirt-3.5 branch
 - [vdsm] Domain deactivation doesn't clear domain from the domains to be upgraded list
 - [z-stream clone 3.5.6] [vdsm] SpmStart fails after "offline" upgrade of DC with V1 master domain to 3.5
 - [z-stream clone 3.5.6] Live merge fails when deleting a snapshot
 - Consume fix for "iscsi_session recovery_tmo revert back to default when a path becomes active"
 - Need to add deps on kernel] vdsm iscsi failover taking too long during controller maintenance

### Other packages updated

*   ovirt-engine-sdk-python
*   ovirt-engine-sdk-java
*   ovirt-engine-cli
*   qemu-kvm-ev
*   gperftools
*   ipxe
*   libunwind
*   OVMF
*   qemu-guest-agent
*   seabios
*   sgabios


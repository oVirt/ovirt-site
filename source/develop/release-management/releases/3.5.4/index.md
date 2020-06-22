---
title: oVirt 3.5.4 Release Notes
category: documentation
toc: true
authors: didi, msivak, mskrivan, sandrobonazzola, stirabos
---

# oVirt 3.5.4 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.5.4 release as of September 3rd, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Fedora 20, Red Hat Enterprise Linux 6.7, CentOS Linux 6.7, (or similar) and Red Hat Enterprise Linux 7.1, CentOS Linux 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](/develop/release-management/releases/). 

## Install / Upgrade from previous versions

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

[`http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.4/ovirt-live-el6-3.5.4.iso`](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.4/ovirt-live-el6-3.5.4.iso)

### oVirt Node

## What's New in 3.5.4?

## Known issues

### PKI

Due to certificate incompatibility issue with rfc2459 and potential of certificate expiration since first release, the CA, Engine, Apache and Websocket proxy certificates may be renewed during upgrade.

If a renew is required, engine-setup will prompt, asking whether to renew. If the reply is 'No', it will not renew, and another later run will ask again.

The renew process should introduce no downtime for the engine and hosts communications, however users' browsers (\*) may require acceptance of the new CA certificate. The new CA certificate which is located at /etc/pki/ovirt-engine/ca.pem should be distributed to all remote components that require PKI trust.

The renew process does not renew certificates of hosts, used for internal communication between the engine and vdsm. These should be recreated by moving each host to maintenance and reinstalling it.

*   Google Chrome (version 45) silently fails just saying:

      This webpage is not available
      ERR_FAILED

without further details. You have to manually remove the old CA cert before being able to connect again.

### Upgrade issues

### Distribution specific issues

*   NFS startup on EL7 / Fedora20: due to other bugs ( or ), NFS service is not always able to start at first attempt (it doesn't wait the kernel module to be ready); if it happens oVirt engine setup detects it and aborts with

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

Retrying (engine-cleanup, engine-setup again) it's enough to avoid it cause the kernel module it's always ready on further attempts. Manually starting NFS service (/bin/systemctl restart nfs-server.service) before running engine setup it's enough to avoid it at all.

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

### Hosted Engine on ISCSI

*   On a new Hosted Engine deployment a clean LUN must be used in order to avoid issues with "Metadata version is too new".

## CVE Fixed

## Bugs fixed

### oVirt Engine

* unable to add additional hosts on gluster service enabled cluster
 - No password change url on login failure when password expires
 - Storage Tab -> import Domain -> help button is missing
 - Storage tab-> ISO Domain -> Data Center -> Attach -> help button is missing
 - Spelling Mistake under Host General Tab "Live Snapsnot Support" should be Snapshot
 - add fcp api option to 'unregisteredstoragedomainsdiscover' at oVirt's api rsdl
 - Storage migration removes snapshot preview from the storage
 - [engine-backend] NullPointerException during RunVmCommand for multiple VMs creation
 - SDK and REST ignore template's disk attributes
 - CSH doesn't work unless helptag is identical to model hashname
 - RHEV-M admin portal pagination issue: disappeared list of VMs after sort it and select next page
 - RHEV 3.5.0 - User Portal no longer works Internet Explorer 8
 - After upgrading RHEV-M to 3.5.1 and RHEV-H to 7.1, fencing with ilo4 no longer works
 - User doesn't get the UserVmManager permission on a VM
 - [engine-backend] Hosted-engine- setup: HE deployment over RHEV-H failed due to an exception in engine for org.ovirt.engine.api.restapi.resource.AbstractBackendResource: javax.ejb.EJBException: JBAS014580: Unexpected Error
 - improve Korean translations
 - The "isattached" action doesn't return an action object
 - AddVmFromScratchCommand fails when adding external VMs
 - Source VM is deleted after failed cloning attempt
 - [PKI] enforce utf-8 subject for openssl
 - Korean translation update

### VDSM

* vdsm should restore networks much earlier, to let net-dependent services start
 - "vds.MultiProtocolAcceptor ERROR Unhandled exception" and "SSLError: unexpected eof"
 - vdsm might report interfaces without IP address when using a slow DHCP server
 - No VM's core dumps after kill vm EL7
 - [scale] Excessive cpu usage in FileStorageDomain.getAllVolumes
 - [VMFEX_Hook] Migration fail with 'HookError' when using vmfex profile and vdsm-hook-vmfex-dev hook in rhev-M
 - Vdsm for EL7 should not allow engine version lower than 3.5
 - vdsm hangup 100% CPU
 - Ballooning is working on VM without Guest Agent
 - [RHEL 7] - Bridge appears in brctl and /sys/class/net after the network was changed to be non-VM network
 - Failed to deploy HE over RHEVH6.7 | [ ERROR ] Failed to execute stage 'Misc configuration': Failed to persist network configuration. Error code: "16" message: "Unexpected exception"

### oVirt Log Collector

* [RHEL6.7][log-collector] Missing some info from engine's collected logs
 - rhevm-log-collector is missing sos dependency on RHEL 6.7

### oVirt Hosted Engine HA

* /var/log/messages is spammed with hosted engine errors on RHEV-H 3.5.4
 - Switch to Hosted Engine TUI menu so slowly due to failed to connect to broker

### oVirt Hosted Engine Setup

* [TEXT ONLY] - Hosted Engine - Instructions for handling Invalid Storage Domain error
 - HE deployment with exist VM, failed if used NFS storage path with trailing slash
 - HE deployment fails due to libvirtError: internal error client socket is closed
 - Failed to pass stage of storage domain name
 - hosted-engine fails to transfer the appliance image to the storage domain because the lv was not activated

### oVirt engine CLI

* rhevm-shell opening spice-console does not work

### oVirt Java SDK

* sdk-java Encoding Problem

### Other packages updated

*   qemu-kvm-ev
*   ovirt-engine-sdk-python


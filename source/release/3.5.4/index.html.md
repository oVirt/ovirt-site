---
title: OVirt 3.5.4 Release Notes
category: documentation
authors: didi, msivak, mskrivan, sandrobonazzola, stirabos
wiki_category: Documentation
wiki_title: OVirt 3.5.4 Release Notes
wiki_revision_count: 29
wiki_last_updated: 2015-09-17
---

# OVirt 3.5.4 Release Notes

<big>**DRAFT**</big>
The oVirt Project is pleased to announce the availability of oVirt 3.5.4 first release candidate as of July 1st, 2015.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Fedora 20, Red Hat Enterprise Linux 6.6, CentOS Linux 6.6, (or similar) and Red Hat Enterprise Linux 7.1, CentOS Linux 7.1 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](http://www.ovirt.org/Category:Releases). For a general overview of oVirt, read [ the Quick Start Guide](Quick_Start_Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

### CANDIDATE RELEASE

oVirt 3.5.4 first candidate release is available since 2015-07-01. In order to install it you've to enable oVirt 3.5 release candidate repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.5.repo**

**For CentOS / RHEL:**

      [ovirt-3.5-pre]
      name=Latest oVirt 3.5 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/el$releasever`](http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/el$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.5`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.5)

**For Fedora:**

      [ovirt-3.5-pre]
      name=Latest oVirt 3.5 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/fc$releasever`](http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/fc$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.5`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.5)

If you are upgrading from a previous version, you may have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.5.4 on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

### oVirt Node

## What's New in 3.5.4?

## Known issues

### PKI

Due to certificate incompatibility issue with rfc2459 and potential of certificate expiration since first release, the CA, Engine, Apache and Websocket proxy certificates may be renewed during upgrade.

The renew process should introduce no downtime for the engine and hosts communications, however users' browsers may require acceptance of the new CA certificate. The new CA certificate which is located at /etc/pki/ovirt-engine/ca.pem should be distributed to all remote components that require PKI trust.

### Upgrade issues

*   Engine and host upgrade ordering due to bug . When upgrading your deployment to 3.5.4 please upgrade your engine first and next your hosts. When following order is not preserved you will see following error every 3 seconds (by default):

      ERROR [org.ovirt.engine.core.vdsbroker.vdsbroker.ListVDSCommand] (DefaultQuartzScheduler_Worker-28) [] Command 'ListVDSCommand(HostName = kenji, HostId = 9f569269-d267-4bf9-96c5-e1749b4c8dda, vds=Host[kenji,9f569269-d267-4bf9-96c5-e1749b4c8dda])' execution failed: java.util.LinkedHashMap cannot be cast to java.lang.String

Following exception prevents host monitoring but affected host stays in status 'UP' and is operational. Virtual machine status collection is gathered every 15 seconds (by default).

### Distribution specific issues

*   NFS startup on EL7 / Fedora20: due to other bugs ( or ), NFS service is not always able to start at first attempt (it doesn't wait the kernel module to be ready); if it happens oVirt engine setup detects it and aborts with

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

Retrying (engine-cleanup, engine-setup again) it's enough to avoid it cause the kernel module it's always ready on further attempts. Manually starting NFS service (/bin/systemctl restart nfs-server.service) before running engine setup it's enough to avoid it at all.

*   NFS startup on EL7.1 requires manual startup of rpcbind.service before running engine setup in order to avoid

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

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
 - [TEXT] Error/warning message for out of the range values doesn't provides expected value range for CPU QoS
 - [engine-backend] NullPointerException during RunVmCommand for multiple VMs creation
 - [engine-backup] unable to restore if backup contains read only user for DWH DB access
 - SDK and REST ignore template's disk attributes
 - CSH doesn't work unless helptag is identical to model hashname
 - RHEV-M admin portal pagination issue: disappeared list of VMs after sort it and select next page
 - RHEV 3.5.0 - User Portal no longer works Internet Explorer 8
 - After upgrading RHEV-M to 3.5.1 and RHEV-H to 7.1, fencing with ilo4 no longer works
 - Unstable unittest in engine
 - User doesn't get the UserVmManager permission on a VM
 - [engine-backend] Hosted-engine- setup: HE deployment over RHEV-H failed due to an exception in engine for org.ovirt.engine.api.restapi.resource.AbstractBackendResource: javax.ejb.EJBException: JBAS014580: Unexpected Error
 - improve Korean translations
 - The "isattached" action doesn't return an action object
 - AddVmFromScratchCommand fails when adding external VMs
 - Source VM is deleted after failed cloning attempt

### VDSM

* vdsm should restore networks much earlier, to let net-dependent services start
 - "vds.MultiProtocolAcceptor ERROR Unhandled exception" and "SSLError: unexpected eof"
 - vdsm might report interfaces without IP address when using a slow DHCP server
 - No VM's core dumps after kill vm EL7
 - [scale] Excessive cpu usage in FileStorageDomain.getAllVolumes
 - [VMFEX_Hook] Migration fail with 'HookError' when using vmfex profile and vdsm-hook-vmfex-dev hook in rhev-M
 - Vdsm for EL7 should not allow engine version lower than 3.5
 - vdsm hangup 100% CPU
 - Keep the upstart libvirtd file to enable relaunching libvirt in case it goes down

### oVirt Log Collector

* [RHEL6.7][log-collector] Missing some info from engine's collected logs

### oVirt Hosted Engine Setup

* [TEXT ONLY] - Hosted Engine - Instructions for handling Invalid Storage Domain error
 - HE deployment with exist VM, failed if used NFS storage path with trailing slash

### oVirt engine CLI

* rhevm-shell opening spice-console does not work

<Category:Documentation> <Category:Releases>

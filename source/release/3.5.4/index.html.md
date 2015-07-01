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

## Install / Upgrade from previous versions

## What's New in 3.5.4?

## Known issues

### Upgrade issues

### Distribution specific issues

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

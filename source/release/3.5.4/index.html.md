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

<Category:Documentation> <Category:Releases>

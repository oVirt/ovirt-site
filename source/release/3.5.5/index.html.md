---
title: OVirt 3.5.5 Release Notes
category: documentation
authors: sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.5.5 Release Notes
wiki_revision_count: 17
wiki_last_updated: 2015-10-27
---

# OVirt 3.5.5 Release Notes

<big>**DRAFT**</big>

## Install / Upgrade from previous versions

## What's New in 3.5.5?

## Known issues

### Upgrade issues

### Distribution specific issues

## CVE Fixed

## Bugs fixed

### oVirt Engine

* [search] Support tokens with special characters within name
 - On datacenter with compatibility version less than 3.5 attaching and detaching from one dc to another in the same setup can cause vm states loss (depending on timing of the detach)
 - [sysprep] Sysprep floppy payload attached to normal VM regardless of its settings enabling
 - If Quotas are enabled, even in Audit mode, active VMs' disks cannot be edited
 - [userportal][AAA] in case there is no password (nego) disable automatic login feature
 - [RHEV-M webadmin] improve German translation.
 - Incorrect message when trying to remove a scheduling policy while attached to a cluster
 - support forcing the use of custom JRE
 - [RFE] Windows 10 Guest OS Support - UI
 - Upgrade from 3.5.2 to 3.5.3 experiencing database execution error
 - [sysprep] Sysprep floppy payload attached to normal VM regardless of its settings enabling
 - Engine: Live merge fails after a disk containing a snapshot has been extended
 - [PKI] enforce utf-8 subject for openssl
 - Korean translation update
 - [events] ...was started by null@N/A
 - Can't update storage domain via REST API in case that the storage domain's 'containsUnregisteredEntities' property is true
 - Dropdown boxes on RHEVM not rendered properly in Chromium
 - Stateless VM snapshot gets deleted when user shuts down VM in a Manual Pool type
 - [scale] - org.jboss.resteasy.spi.ResteasyProviderFactory potential leak
 - [host-deploy] when updating multiple packages only the latest is considered in cache timestamp
 - Node unusable after upgrade from F20 to F21 (supported machine types list too long for database field)
 - several async tasks are not cleared altough they are over and finished in vdsm
 - VM --> Provisoning Operations --> Create permit required for live migrations in 3.5
 - Windows 2012 guest reports incorrect time randomly and after a cold restart.
 - [extmgr] load extension properties as unicode
 - [AAA] Incorrect AuthRecord.VALID_TO parsing
 - fencing_policies is not available in REST API output
 - Encrypted database fields should allow spaces
 - Automatic fencing doesn't work when network is killed on host

### oVirt Hosted Engine HA

* hosted-engine --vm-status results into python exception

### oVirt Hosted Engine Setup

* On additional hosts, appending an answerfile, the setup will not download the HE one from the first host
 - [hosted-engine-setup] Deployment over iSCSI using RHEVM-appliance fails with endless 'WARNING otopi.plugins.ovirt_hosted_engine_setup.vm.image image._disk_customization:124 Not enough free space' messages
 - hosted-engine-setup fails updating vlan property on the management network if more than one datacenter is there

### Other packages updated

*   ovirt-engine-sdk-python
*   ovirt-engine-sdk-java
*   ovirt-engine-cli

<Category:Documentation> <Category:Releases>

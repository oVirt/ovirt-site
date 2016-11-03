---
title: OvfOnAnyDomain
category: feature
authors: laravot
wiki_category: Feature
wiki_title: Feature/OvfOnAnyDomain
wiki_revision_count: 6
wiki_last_updated: 2014-08-12
---

# OvfOnAnyDomains

## Summary

The vm ovf on any domain feature introduces a change on the way the vm ovfs are being stored/backed up in oVirt. Currently all the ovfs are being stored on the master domain and are being updated asynchronously on a time basis by the [OvfAutoUpdater](Feature/OvfAutoUpdater), This feature purpose is to store the OVFs on all wanted domains to provide better recovery abillity, reduce the use of master_fs and the master domain and add capabillities to oVirt that will be used further on.

## Detailed Description

VM/Template configurations (including disks info) are stored on the master storage domain only for backup purposes and in order to provide the abillity to run VMs without having a running engine/db. This feature aims to change the current place in which the OVFs are stored while using the existing [OvfAutoUpdater](Feature/OvfAutoUpdater) features ( asynchronous incremental OVF updates) the expected benefits are

1. Having "self contained" Storage Domains which will enable to recover in case of data loss (oVirt supports registration of unknown disks stored on storage domain in the engine and adding VM from OVF configuration - so having the VM OVF stored on the same Storage Domain of it's disks will allow to recover the vm "completly" from that Storage Domain to the oVirt engine).

2. Moving out from using the master_fs on the storage domain, as part of this change the OVFs will be stored on a designated volume located on each Storage Domain.

3. Adding support for streaming files from the engine to vdsm (will be discussed later on).

## Detailed Design

Based on user selection (enabled by default for newly added Storage Domains) a volume for the OVFs data will be created on the Storage Domain. On each run of the [OvfAutoUpdater](Feature/OvfAutoUpdater) the VMs that were updated since the last run are being inspected to see if their OVF can be updated on the storage side (for example, if a vm is locked it's OVF won't be updated as it currently maybe be "inconsistent") , the engine will inspect each of the attached non shareable image disks to the VM's to be updated and will mark that the OVFs on their Storage Domains needs to be updated. Later on the engine will go over on all the Storage Domains that we marked for OVF update and will create a tar on-the-fly that will contain all the OVFs needs to be stored on that domain (for VM that weren't marked for update on that OvfDataUpdater run we will pick a cached OVF) - this tar will be streamed in a HTTP request (new support added as part of this feature) to VDSM that will write it to the designated volume on the passed domain.

### DB Changes

TBA

### Engine

TBA

### VDS

TBA

### NOTES



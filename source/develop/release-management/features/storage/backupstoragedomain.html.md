---
title: BackupStorageDomain
category: feature
authors: shubham0d, mlipchuk
wiki_category: Feature|BackupStorageDomain
wiki_title: Features/BackupStorageDomain
wiki_revision_count: 0
wiki_last_updated: 2017-24-03
feature_name: Backup Storage Domain
feature_modules: engine/vdsm
feature_status: Yet to Impelement
--- 

# Backup Storage Domain

This feature is part of [Import Unregistered Entities](/develop/release-management/features/storage/importunregisteredentities/).

## Owner

* Maor Lipchuk <mlipchuk@redhat.com>
* Shubham Dubey <sdubey504@gmail.com>

## Current status

* Yet to Implement

## Summary

Until now, one of the solutions to backup VMs and Templates in oVirt is to use an export storage domain.
Export storage domain is a dedicated storage domain which is used to store and restore VMs and Templates.
The drawback of Export storage domain is its two stage process. Transferring a vm required first copying it into the export storage domain and then into other storage domain to start using them. Since in background transfer from one domain to other take place using normal copy or dd utility(in case of disks) this process take a large time for a complete transfer. Hence, for a better backup experience we decided to create a whole dedicated storage domain to be used only for backup which obviously will call as backup storage domain.

## How idea get introduced

After discussing with community on mailing list maor decided to put that idea on google summer of code idea list. Google summer of code is a sort of intern program organized by google to attract the contribution on open source projects between university students. Shubham Dubey get selected for working on this project for whole summer.

## Benefit of Backup Storage domain

* Much more dedicated storage domain for backup and disaster recovery purposes.
* One step process-If you want a backup of vm/template then just transfer it to backup storage domain.
* For huge amount of vms/templates and ovfs migration the time taken for copying through export will be high which will be minimized by using backup storage domain.
* Large amount of extra space is used in export storage domain. It may be suitable for small datacenter but for large datacenter the storage required to store those ovfs and vms in export storage domain will become a headache.
* Multiple storage domain can be used for backup purposes only.
* Backup storage domain will support both File storage(NFS, Gluster and Ceph) as well as block storage(Fiber Channel and iSCSI) as compare to export storage domain which only has support for file storage.

## General Functionality

* You can select any data storage domain as backup storage.
* Once the storage domain is configured as backup the engine will block any running VMs or any changes that might be in the storage domain.
* A backup storage domain can be detached and attached to a data center as every data storage domain.
* Backup storage domain will be able to support unregistered VMs/Templates/Disks.

## Restrictions

* A data storage domain can not be configured as backup while there are running VMs with disks reside on that storage domain.
* User can not run VMs with disks reside on a storage domain configured as backup, since running VM changes the disk's data.
* VMs with disks reside on a backup storage domain can not be previewed.
* Live move of disks to the backup storage domain will be restricted.

## Open Issues

* VMs with disks reside on a backup storage domain should not be previewed, since currently oVirt do not support it through import storage domain.
* Shared disk is not specified in the OVF and therefore we should not support VMs with shared disk on a backup storage domain.
* VM pool will be eligible in a backup storage domain although import storage domain will not preserve its pool reference after import.
* Should the backup indication needs to be configured in the storage domain meta data? If so should we add the backup indication as part of V4 storage domain meta data.

## Current progress

DAL implementation:
*  status: open
*  gerrit link: https://gerrit.ovirt.org/#/c/77142/
*  DB table changed: storage_domain_static
*  Field name: backup
*  Type: True / False (Default would be false, not null)

## Phases for Implementation

* Phase 1 (under review): Add dal layer with new field - Add an explanation of the change (Mainly technical change like "introducing new field in table storage_domain_static")
* Phase 2: Add command validations for configuring backup storage domain - [see restrictions]
* Phase 3: Add REST command to update storage domain as backup - Introduce the ability to update the storage domain as backup through REST.

## Future plans

* Add GUI support for backup storage domain - Once backend configuration get complete and REST changes get implemented we will make this ready for user to use it through gui.
* Convert Export storage domain to backup domain - If community agree then we will remove the export storage domain and replace it with the backup storage domain.

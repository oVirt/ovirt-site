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

* Maor Lipchuk
* Email <mlipchuk@redhat.com>

## Current status

* Yet to Implement

## Summary

Until now, best solution for backup a storage domain and disaster recovery is using the export storage domain. In export storage domain user can create a dedicated storage domain which will use move VMs/Templates and their OVF files.
The drawback of Export storage domain is its two stage process. Transferring a vm required first copying it into the export storage domain and then into other storage domain to start using them. Since in background transfer from one domain to other take place using normal copy or dd utility(in case of disks) this process take a large time for a complete transfer. Hence, for a better backup experience we decided to create a whole dedicated storage domain to be used only for backup which obviously will call as backup storage domain.

## How idea get introduced

After discussing with community on mailing list maor decided to put that idea on google summer of code idea list. Google summer of code is a sort of intern program organized by google to attract the contribution on open source projects between university students. Shubham Dubey get selected for working on this project for whole summer.

## Benefit of Backup Storage domain

* Much more dedicated storage domain for backup and disaster recovery purposes.
* One step process-If you want a backup of vm/template then just transfer it to backup storage domain.
* For huge amount of vms/templates and ovfs migration the time taken for copying through export will be high which will be minimized by using backup storage domain.
* Large amount of extra space is used in export storage domain. It may be suitable for small datacenter but for large datacenter the storage required to store those ovfs and vms in export storage domain will become a headache.
* Multiple storage domain can be used for backup purposes only.


## General Functionality

* You can select any data storage domain as backup storage.
* Once the storage domain is configured as backup the engine will block any running VMs or any changes that might be in the storage domain.
* Attach/Detach of backup storage to datacenter can be possible.

## Current progress

* push has been made for adding backup flag for data storage domain. If the flag is set to true means that storage domain is used as backup storage.

## Future plans

* We first will configure the storage domain to get ready to be a backup storage.
* After completing configuration we will add rest support after that the gui support.

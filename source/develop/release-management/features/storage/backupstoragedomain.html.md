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

## Summary

Until now best solution for backup a storage domain and disaster recovery is using the export storage domain. In export storage domain user can create a
dedicated storage domain which will use move VMs/Templates and their OVF files.
The drawback of Export storage domain is using it is two stage process. Transferring a vm required first copying it into the export storage domain and then into other 
storage domain to start using them. Since in background transfer from one domain to other take place using normal copy or dd util(in case of disks) this process take a extra time 
to setting a complete transfer.


## Owner

* Maor Lipchuk
* Email <mlipchuk@redhat.com>

## Current status

* Yet to Implement

## General Functionality
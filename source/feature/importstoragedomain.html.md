---
title: ImportStorageDomain
category: feature
authors: derez, mlipchuk, sandrobonazzola, vered
wiki_category: Feature|ImportStorageDomain
wiki_title: Features/ImportStorageDomain
wiki_revision_count: 183
wiki_last_updated: 2015-05-12
feature_name: Import Storage Domain
feature_modules: storage
feature_status: Design
---

# Import Storage Domain

### Summary

Today we able to import Export Storage Domain and ISO Storage Domain, though there is no support for importing an existing Storage Domain.
Each Storage Domain should contain the disks and the VM's OVFs
The VM's OVF is an XML standard representing the VM configuration, including disks, VM memory, CPU and more.

### Owner

*   Maor Lipchuk mlipchuk@redhat.com

### Current status

*   Design

#### Phase 1 - Detach Storage Domain

Today we can detach a Storage Domain from the DC, only if it does not contains any disks or VMs on it.
As part of this feature, the user will be able to also detach Storage Domain which contains VMs and Disks, and re-attach it to other Data Center.
If there will be VMs with disks on multiple Storage Domains or Template with disks on multiple Storage Domains as well the operation will fail and an event log will be presented, with the following message (see future work) :
 Cannot detach {Storage Domain Name}. The following VMs/Templates have disks related to the following storages {other Storage Domain Names}. Please move those disks to the {Storage Domain Name}.

#### Phase 2 - Import NFS Storage Domain

On import an existing Storage Domain, the engine will read the VM's OVFs from the file (Related to OVF on any domain), and the related disks of the Data Domain.
If the file does not exists in the domain, the engine will only import the disks without the VMs and will print an appropriate event log.
We might have a VM with disks on other Storage Domains, in that case we will add a new Storage Domain which will be named {Data_Center_Name}_Unattached# to the Data Center.
This dummy Storage Domain functionality will behave the same as a Storage Domain in maintenance mode.
The disks related to this Storage Domain (Which are related to the VMs) will be shown as disabled in the GUI and will be inactive for the VM.
The VMs could run but the inactive disks will not be part of the process.The user should confirm that the OS and the boot disk is on the active disks.
Template Disk might be on multiple Storage Domains, in case some of the Storage Domains are unattached (isStorageExists is false), then the functionality of creating a VM from this Template will be the same as a maintenance Storage Domain.

##### Importing Unattached Storage Domain

The user can also import an unattached Storage Domain to the Data Center, which has already disks related to it.
Once that done we can correlate the storage GUID of the storage with the storage GUID in the Unattached Storage Domain in the DC,
once we will found a match, the engine will run over the properties of the Storage Domain configuration (Name, path ext.) and will change the isStorageExists flag to true.

##### GUI Perspective

*   The Import of an NFS Storage Domain, will be the similar from the GUI perspective of importing Export/ISO domain.

The user will enter the path of the storage domain and will start the import process.

*   Unrelated disks will be disabled in the GUI

##### DB Changes

We will add a new column in the storage domains table which will be called isStorageExists. When this field is false then all the images related to it will be disabled in the GUI.

### Permissions

There should not be changes is detach storage domain Every user with permissions to create a Storage Domain on the Data Center, will be able to import a storage domain as well.

#### Future Work

*   Detach Stroage Domain: Eventually if the user will choose all the storage domains at once then we will detach them all at once (Need to take into consideration this message could nag the user since we might always have VMs with disks on other storage domains)
*   Import Storage Domain : supporting importing of iSCSI storage domain will be in later phase
*   Import Storage Domain : The user will be able to send a list of paths, and the engine will import them all at once
*   Nice to have: A way to choose the VMs to import to the DC (instead automatically)
*   Mock ups will be added.

#### Related Issues

This feature is dependent on OVF on any domain

### Comments and Discussion

*   Refer to [Talk: ImportStorageDomain](Talk: ImportStorageDomain)

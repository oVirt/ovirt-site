---
title: BackupStorageDomain
category: feature
authors: mlipchuk, shubham0d
wiki_category: Feature|BackupStorageDomain
wiki_title: Features/BackupStorageDomain
wiki_revision_count: 0
wiki_last_updated: 2017-24-03
feature_name: Backup Storage Domain
feature_modules: engine/vdsm
feature_status: Yet to Impelement
--- 

# Backup Storage Domain

This feature will add another functionality layer to the oVirt Disaster Recovery solution.

## Owner

* Maor Lipchuk <mlipchuk@redhat.com>
* Shubham Dubey <sdubey504@gmail.com>

## Current status

* Yet to Implement

## Summary

Until now, one of the solutions to backup VMs and Templates in oVirt is to use an export storage domain.
Export storage domain is a dedicated storage domain which is used to store and restore VMs and Templates.
The drawback of Export storage domain is its two stage process. Transferring a VM required first copying it into the export storage domain and then into other storage domain to start using them. Since in background transfer from one domain to other take place using normal copy or dd utility(in case of disks) this process take a large time for a complete transfer. Hence, for a better backup experience we decided to create a whole dedicated storage domain to be used only for backup which obviously will call as backup storage domain.

## GSOC

This feature is being developed as part of the Google Summer of Code (GSOC).
Google Summer of Code is a global program focused on introducing students to open source software
development. Students work on a 3 month programming project with an open source organization
during their break from university.<br />
The oVirt organization has chosen Shubham Dubey, a student from The LNM Institute of Information Technology from India, to work  on this project for the upcoming summer and Maor Lipchuk, a senior software developer in the oVirt storage team, to be the mentor.

## Backup Storage Domain - Functionality

* You can select any data storage domain as backup storage.
* Once the storage domain is configured as backup the engine will block any running VMs or any changes that might be in the storage domain.
* A backup storage domain can be detached and attached to a data center as every data storage domain.
* Backup storage domain will be able to support unregistered VMs/Templates/Disks.
* The backup indication will only be configured using the DataBase and will not be configured in the storage domain metadata - The user will be able to configure a storage domain as backup once a data storage domain is being imported or added to oVirt.

#### Advantages

* Much more dedicated storage domain for backup and disaster recovery purposes.
* One step process-If you want a backup of VM/Template then just transfer it to backup storage domain.
* For huge amount of vms/Templates and OVFs migration the time taken for copying through export will be high which will be minimized by using backup storage domain.
* Large amount of extra space is used in export storage domain. It may be suitable for small datacenter but for large datacenter the storage required to store those OVFs and VMs in export storage domain will become a headache.
* Multiple storage domain can be used for backup purposes only.
* Backup storage domain will support both File storage(NFS, Gluster) as well as block storage(Fiber Channel and iSCSI) as compare to export storage domain which only has support for file storage.

#### disadvantages

* A data storage domain can not be configured as backup while there are running VMs with disks reside on that storage domain.
* User can not run VMs with disks reside on a storage domain configured as backup, since running VM might manipulate the disk's     data.
* VMs with disks reside on a backup storage domain can not be previewed.
* Live move of disks to the backup storage domain will be restricted.

#### Open Issues

* Preview will be restricted for VMs with disks reside on a backup storage. - We think it should be restricted since currently oVirt does not support import storage domain with previewed unregistered entities.
* Shared disk will be restricted in the backup storage domain since those are not specified in the VM's OVF.
* VM pool will be eligible in a backup storage domain although, the user must keep in mind that import storage domain will not preserve its pool reference after import.
* Should the backup indication needs to be configured in the storage domain meta data? If so should we add the backup indication as part of V4 storage domain meta data.

## Current progress

DAL implementation:

  Changes | Values
  ---------|----------
  status | open
  gerrit link | https://gerrit.ovirt.org/#/c/77142/
  DB table changed | storage_domain_static
  Field name | backup
  Type | True / False (Default would be false, not null)

## Phases for Implementation

- [x] Phase 1 (under review): Add dal layer with new field -
  * introducing new field 'backup' in table storage_domain_static
  * Add field changes in fixtures.xml for dao tests
  * Test class added for dao test
- [ ] Phase 2: Add command validations for configuring backup storage domain - [see restrictions]
- [ ] Phase 3: Add REST command to update storage domain as backup - Introduce the ability to update the storage domain as backup through REST.

## Future plans

* Add GUI support for backup storage domain - Once backend configuration get complete and REST changes get implemented we will make this ready for user to use it through gui.
* Convert Export storage domain to backup domain - If community agree then we will remove the export storage domain and replace it with the backup storage domain.

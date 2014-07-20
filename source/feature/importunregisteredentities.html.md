---
title: ImportUnregisteredEntities
authors: mlipchuk
wiki_title: Features/ImportUnregisteredEntities
wiki_revision_count: 42
wiki_last_updated: 2014-10-14
feature_name: Detach/Attach Storage Domains with entities
feature_status: Released
---

# Import Unregistered Entities

## Detach/Attach Storage Domains with entities

### Summary

Today the operation of moving entities, such as VMs or Templates, from one Data Center to another Data Center in the same setup must be done through a mediator called Export Storage Domain.
This migration of those entities is being done by two copy operations, one is done to the mediator (Export Storage Domain) and another copy is from the Export Storage Domain to the target Storage Domain.
Needless to say those operations requires allocation of free space in the Export Storage domain, and takes a long time to be accomplished.
There is a requirement to add the ability of migrating entities from one Data Center to another without the use of a mediator, and by that, save the heavy operation of the copy operation.
The new feature will make the detach/attach of a Storage Domain containing entities such as disks, VMs or Templates to be available from one Data Center to another.
Each Data Storage Domain is an entity which contains disks and sometime VM's and Template's OVF.
The OVF is an XML standard representing the VM/Template configuration, including disks, memory, CPU and more.
Based on this information stored in the Storage Domain, we can relate the disks, VMs and Templates to any Data Center which we will relate the Storage Domain to.

### Owner

*   Maor Lipchuk
*   Email <mlipchuk@redhat.com>

### Current status

*   Implemented

### General Functionality

*   The feature will be dependent on the OVF disk [see 1]. If a Storage Domain will not contain the OVF disk the engine should block the detach operation.
     The reason the operation will be blocked, is that since we don't keep the VMs/Templates we might have disks with snapshots based on the VMs, and the engine can not support such disks as floating.

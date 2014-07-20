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
Today we can detach a Storage Domain from the DC, only if it is empty, i.e. does not contain any disks or VMs/Templates
The new feature should add the ability for the user to detach a Storage Domain containing VMs/Templates and Disks, and re-attach it again to another Data Center.
Each Data Storage Domain is an entity which contains disks and sometime VM's and Template's OVF.
The OVF is an XML standard representing the VM/Template configuration, including disks, memory, CPU and more.
Based on this information stored in the Storage Domain, we can relate the disks, VMs and Templates to any Data Center which we will relate the Storage Domain to.

### Owner

*   Maor Lipchuk
*   Email <mlipchuk@redhat.com>

### Current status

*   Implemented

### General Functionality

*   On detach of Storage Domain the VMs/Templates related to the Storage Domain should be deleted from the engine, but their data will be converted to an XML data which will be preserved in a DB table called unregistered_ovf_of_entities, and will still be part of the OVF disk contined in the Storage Domain.
*   On attach the user will be able to choose the VMs/Templates/Disks he desires to assign to the Data Center and will pick the Cluster for those Vms/Templates.
*   Shareable and Direct lun disks are not supported in the OVF file today, hence if a VM includes a shareable or direct lun disks, a warning will be prompted to the user, indicating the following (See gap1)
*   Attention, The following VMs contains shareable/direct lun disks which will not be part of the VM configuration after the detach will take place: {vmNames}.
*   The VMs and Templates which will be candidates for the registration operation in the Data Center must be part of the OVF contained in the Data Center. (see [2])

[2]: There is a gap that VMs/Templates with no disks do not exist in the Storage Domain's OVF, therefore those VMs will not be present in the setup on attach operation.

##### REST

###### Get list of unregistered VM/Template

The use can get a list of all the unregistered VMs or unregistered Templates by adding the prefix ";unregistered" after the vms/Templates, in the Storage Domain.
For example to get all the unregistered VMs in the Storage Domain 68ca2f73-9b15-4839-83c9-859244ad2cd3 the URL will be : <http://localhost:8080/api/storagedomains/68ca2f73-9b15-4839-83c9-859244ad2cd3/vms;unregistered> ![](UnregisterVM2.png "fig:UnregisterVM2.png")

###### Register VM to a new cluster

If the user want to register a VM to the setup, then the URL should indicate register after the VM id, as follow: <http://localhost:8080/api/storagedomains/xxxxxxx-xxxx-xxxx-xxxxxx/vms/xxxxxxx-xxxx-xxxx-xxxxxx/register> ![](UnregisterVM1.png "fig:UnregisterVM1.png")

##### UI

###### Import VM/Template sub-tabs

![](import_vm_template_subtab.png "import_vm_template_subtab.png")

###### Import VM/Template Dialog

![](import_vm_template_dialog.png "import_vm_template_dialog.png")

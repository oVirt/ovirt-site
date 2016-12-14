---
title: ImportUnregisteredEntities
authors: mlipchuk
wiki_title: Features/ImportUnregisteredEntities
wiki_revision_count: 42
wiki_last_updated: 2014-10-14
feature_name: Detach/Attach Storage Domain with entities
feature_modules: engine
feature_status: Released
---

# Import Unregistered Entities

## Detach/Attach Storage Domain with entities

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

*   implementation

### General Functionality

*   On detach of Storage Domain the VMs/Templates related to the Storage Domain should be deleted from the engine, but their data will be converted to an XML data which will be preserved in a DB table called unregistered_ovf_of_entities, and will still be part of the OVF disk contained in the Storage Domain.
*   On attach the user will be able to choose the VMs/Templates/Disks he/she desires to register in the Data Center, and will choose which Cluster and quota for each Vm/Template it will be assigned with.
*   After a successful registration of a VM/Template, the entity should be removed from the entities candidates to be registered.
*   The VM's snapshots and VM's disks (active/deactivate) should be preserved on attach, the same as they were when those entities were on the detached Storage Domain.
*   Regarding quota enforcement Data Centers, the user will choose for each disk the quota he/she will want to consume from, when it will choose a VM/Template to register in the setup.

### Restrictions

*   Detach/Attach Storage Domain, containing entities, should not be restricted by any Data Center version.
     VMs and Templates can be moved from old/new Data Center to another with no limitation, except the cluster which the user choose for each VM/Template.
*   Detach will not be permitted if there are VMs/Templates which are delete protected. In case there are entities as so, there should be an appropriate message which should indicate those entities names.
*   Detach will also not be permitted if there are VMs which are in PREVIEW mode. In case there are entities as so, there should be an appropriate message which should indicate those entities names.
*   Detach will not be permitted if there are VMs which are part of pools, In case there are entities as so, there should be an appropriate message which should indicate those entities names.
*   a Storage Domain can not be detached if it contains disks which are related to a running VM, unless this disks is inactive.
*   Shareable and Direct lun disks are not supported in the OVF file today (See [1])
*   The VMs and Templates which are candidates to be registered, must exists in the Storage Domain OVF contained in the unregistered_ovf_of_entities table. (see [2])
*   All the Storage Domains of the VMs/Templates disks must be active in the target Data Center when the user register the entity.(see [3])
*   If a VM will be thin provisioned from a Template. Then the register process will not allow to register the VM without the Template will be registered first.
*   A Template with disk on multiple storage domain will be registered as one copy of the disk related to the source Storage Domain.(see [4])
*   Currently floating disks will be registered using the existing REST command of import unregistered disk.(see [5])
*   Permissions on VMs and Templates will not be preserved on detach, since they are not part of the OVF. (https://bugzilla.redhat.com/1138177)
*   Local Storage Domain is not supported for detach/attach, the reason for that is that on the detach the Local Storage Domain is being deleted from the Host.

#### Implementation gaps

*   [1] If a VM includes a shareable or direct lun disks, a warning will be prompted to the user, indicating the following

       Attention, The following VMs contains shareable/direct lun disks which will not be part of the VM configuration after the detach will take place: {vmNames}. (https://bugzilla.redhat.com/1138133)

*   [2]: There is a gap that VMs/Templates with no disks do not exist in the Storage Domain's OVF, therefore those VMs will not be present in the setup on attach operation. (https://bugzilla.redhat.com/1138134)
*   [3]: There should be an option to register a VM even if the Storage Domain is not exists in the Data Center, in this case the VM will be registered with only part of the disks.

The user will be able to attach the missing Storage Domain at a later phase but he will be able to register those disks to the existing VM only if this VM didn't changed from it's last import (to preserve the snapshot tree of the VM and its images) (https://bugzilla.redhat.com/1133300)

*   [4] Currently, copied disk is not supported in the OVF file, after we will insert this data in the OVF, registration of template should automatically add the copied disk to the Template (https://bugzilla.redhat.com/1138136)

#### RFEs

*   There should be an extra button in the GUI which will import all those floating disks. Currently those disks will not have an alias, this should be fixed once the alias will be saved in the description meta data. (https://bugzilla.redhat.com/1138139)
*   We should add a button to delete any unregistered entity we don't desire to register to the setup (https://bugzilla.redhat.com/1138142)
*   We should be able to "clone" a VM when the user Tries to register an existing VM from a different Storage Domain.
     "Clone" means that only the VM name will be changed (there will not be any copy operations).
     So we should support a use case of a VM which had 2 disks on different Storage Domains, and it will be registered once from one Storage Domain and after that it will be registered from another Storage Domain, so in the setup there will be two VMs, each with one disk. (https://bugzilla.redhat.com/1108904)

### Work flow for detach and attach Storage Domain with entities - UI flow

Video Example: <iframe width="300" src="//youtube.com/embed/DLcxDB0MY38" frameborder="0" align="right" allowfullscreen="true"> </iframe> 1. Choose an active Storage Domain from an active Data Center, make sure this Storage Domain contains VMs/Templates with disks hosted in the specific Storage Domain
2. Move the Storage Domain to maintenance, and detach it from the Data Center - At this point all the entities related to the Storage Domain should be deleted from the setup
3. Attach the Storage Domain to another Data Center and activate it.
4. After the Storage Domain is activated, go to the Storage main tab and pick the Storage Domain which was activated a minute ago
5. In the same Storage main tab, the user should see two sub tabs, "Import VMs" and "Import Tempaltes", in the "Import VMs" sub tab, the user should see all the VMs which are candidates to be imported, and in the "Import Tempaltes" sub tab, there should be the same only for templates.
6. The user can pick several VMs (or Templates), and press on the "import" button.
7. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities the user chose to register.
 The user should choose a cluster for each entity which should be compatible for it.
 The user can also watch the entity properties (such as disks, networks) in the sub tab inside the dialog.

#### Import VM/Template sub-tabs

![](/images/wiki/import_vm_template_subtab.png)

#### Import VM/Template Dialog

![](/images/wiki/import_vm_template_dialog.png)

### REST

#### Get list of unregistered VM/Template

The use can get a list of all the unregistered VMs or unregistered Templates by adding the prefix ";unregistered" after the vms/Templates, in the Storage Domain.
For example to get all the unregistered VMs in the Storage Domain 68ca2f73-9b15-4839-83c9-859244ad2cd3 the URL will be : <http://localhost:8080/api/storagedomains/68ca2f73-9b15-4839-83c9-859244ad2cd3/vms;unregistered> ![](/images/wiki/UnregisterVM2.png)

#### Register VM to a new cluster

If the user want to register a VM to the setup, then the URL should indicate register after the VM id, as follow: <http://localhost:8080/api/storagedomains/xxxxxxx-xxxx-xxxx-xxxxxx/vms/xxxxxxx-xxxx-xxxx-xxxxxx/register> ![](/images/wiki/UnregisterVM1.png)

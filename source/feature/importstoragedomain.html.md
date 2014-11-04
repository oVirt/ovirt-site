---
title: ImportStorageDomain
category: feature
authors: derez, mlipchuk, sandrobonazzola, vered
wiki_category: Feature|ImportStorageDomain
wiki_title: Features/ImportStorageDomain
wiki_revision_count: 183
wiki_last_updated: 2015-05-12
feature_name: Import Storage Domain
feature_modules: engine/vdsm
feature_status: Released
---

# Import Storage Domain

This feature is part of <http://www.ovirt.org/Features/ImportUnregisteredEntities>

### Summary

Today, oVirt supports importing ISO and Export Storage Domains, however, there is no support for importing an existing Data Storage Domain.
A Data Storage Domain contains disks volumes and VMs'/Templates' OVF files.
The OVF file is an XML standard representing the VM/Template configuration, including disks, memory, CPU and more.
Based on this information stored in the Storage Domain, we can revive entities such as disks, VMs and Templates in the setup of any Data Center the Storage Domain will be attached to.
The usability of the feature might be useful for various use cases, here are some of them:

*   Recover after the loss of the oVirt Engine's database.
*   Transfer VMs between setups without the need to copy the data into and out of the export domain.
*   Support migrating Storage Domains between different oVirt installations.

### Owner

*   Maor Lipchuk
*   Email <mlipchuk@redhat.com>

### Current status

*   Implemented

### General Functionality

*   The feature should be fully supported from oVirt 3.5.
*   Disaster Recovery will only be supported on Data Center with version 3.5
*   The feature is dependent on both features:

1.  Detach/Attach Storage Domain - <http://www.ovirt.org/Features/ImportUnregisteredEntities>. The following is the general functionality of the Detach/Attach Storage Domain:
    1.  On detach of Storage Domain the VMs/Templates related to the Storage Domain should be deleted from the engine, but their data will be converted to an XML data which will be preserved in a DB table called unregistered_ovf_of_entities, and will still be part of the OVF disk contained in the Storage Domain.
    2.  On attach the user will be able to choose the VMs/Templates/Disks he/she desires to register in the Data Center, and will choose which Cluster and quota for each Vm/Template it will be assigned with.
    3.  After a successful registration of a VM/Template, the entity should be removed from the entities candidates to be registered.
    4.  The VM's snapshots and VM's disks (active/deactivate) should be preserved on attach, the same as they were when those entities were on the detached Storage Domain.
    5.  Regarding quota enforcement Data Centers, the user will choose for each disk the quota he/she will want to consume from, when it will choose a VM/Template to register in the setup.

2.  OVF on any Storage Domain - <http://www.ovirt.org/Feature/OvfOnWantedDomains>

*   The user can import a Storage Domains and attach it directly to a Data Center, or it can be imported as 'unattached' Storage Domain, and later the user can attach it to a Data Center he desires.
*   When attaching a Storage Domain to a Data Center, all the entities(VMs,Templates) from the OVF_STORE disk should be retrieved from the tar file and into the Data Base table unregistered_ovf_of_entities, later the user can decide how to register them into the Data Center (see <http://www.ovirt.org/Features/ImportUnregisteredEntities#General_Functionality>)
*   Once those VM/Template will be in the Data Base, the user should be able to register those entities using the import unregistered entities feature [see <http://www.ovirt.org/Features/ImportUnregisteredEntities#Work_flow_for_detach_and_attach_Storage_Domain_with_entities_-_UI_flow>]

#### Restrictions

*   Detach/Attach Storage Domain, containing entities, should not be restricted by any Data Center version.
     VMs and Templates can be moved from old/new Data Center to another with no limitation, except the cluster which the user choose for each VM/Template.
*   Detach will not be permitted if there are VMs/Templates which are delete protected. In case there are entities as so, there should be an appropriate message which should indicate those entities names.
*   Detach will also not be permitted if there are VMs which are in PREVIEW mode. In case there are entities as so, there should be an appropriate message which should indicate those entities names.
*   Detach will not be permitted if there are VMs which are part of pools, In case there are entities as so, there should be an appropriate message which should indicate those entities names.
*   a Storage Domain can not be detached if it contains disks which are related to a running VM, unless this disks is inactive.
*   Shareable and Direct lun disks are not supported in the OVF file today, therefore will not be part of the recovered VM.
*   The VMs and Templates which are candidates to be registered, must exists in the Storage Domain OVF contained in the unregistered_ovf_of_entities table. VMs without disks will not be part of the unregistered entities.
*   Currently all the Storage Domains of the VMs/Templates disks must be active in the target Data Center when the user register the entity. (see <https://bugzilla.redhat.com/1133300>)
*   If a VM will be thin provisioned from a Template. Then the register process will not allow to register the VM without the Template will be registered first.
*   A Template with disk on multiple storage domain will be registered as one copy of the disk related to the source Storage Domain.(see <https://bugzilla.redhat.com/1138136>)
*   Currently floating disks will be registered using the existing REST command of import unregistered disk.(see REST part for how to register a floating disk)
*   Permissions on VMs and Templates will not be preserved on detach, since they are not part of the OVF. (https://bugzilla.redhat.com/1138177)
*   Local Storage Domain is not supported for detach/attach, the reason for that is that on the detach the Local Storage Domain is being deleted from the Host.
*   Attaching an imported Storage Domain can only be applied with an initialized Data Center. (see [6])
*   If a Storage Domain will not contain the OVF_STORE disk, the engine should attach the Storage Domain without any unregistered entities, and a message in the engine log should be presented.
*   If a Storage Domain will contain several OVF_STORE disks, the engine should retrieve the unregistered entities only from the newest and updated OVF_STORE disk. (see [1])
*   If the chosen OVF_STORE disk will contain an entity which already exists in the unregistered_ovf_of_entities table (see <http://www.ovirt.org/Features/ImportUnregisteredEntities#General_Functionality>), the engine will replace the data in the unregistered_ovf_of_entities table with the VM fetched from the OVF_STORE disk.
*   An import of a Storage Domain will not reflect the status of a VM (Up, Powring Up, Shutting Down...) all the VMs will be registered as down.
*   An import of a Storage Domain should be supported for block Storage Domain, and file Storage Domain.
*   For better sync of the entities in the Storage Domain with the OVF_STORE disk, it is better to update the OvfUpdateIntervalInMinutes option in vdc_options from 60 minutes to 2-5 minutes, as so : update vdc_options set option_value = 2 where option_name = 'OvfUpdateIntervalInMinutes'; (see [5])
*   In a disaster recovery scenario, if the Host, which the user about to use, was in the environment which was destroyed, it is recommended to reboot this Host before adding it to the new setup. The reason for that is first, to kill any qemu processes which are still running and might be automatically added into the new setup as VMs, also, to avoid any sanlock issues.

#### Implementation gaps

[1] On the attach operation all those OVF_STORE disks should be scanned for OVF entities.
 we should register only the two newest OVF_STORE disks, and sync the data with the unregistered entities. (https://bugzilla.redhat.com/1138114)
[2] The attach operation should notify the user, a warning, whether the Storage Domain is already attached to another Data Center.
 The user can then choose whether to run over the meta data or neglect its operation. (https://bugzilla.redhat.com/1138115)
[3] On detach of a Storage Domain, the user should be prompt with a warning indicating that all the VMs disks and Templates will be removed from the setup (https://bugzilla.redhat.com/1138119)
[4] Open Issue: We should have an indication of External LUN disk on the Lun (https://bugzilla.redhat.com/1138121)
[5] When the user moved the Storage Domain to maintenance, all the entities related to the Storage Domain should be updated in the OVF_STORE disk. (https://bugzilla.redhat.com/1138124 )
[6] Currently, VDSM take a lock on the storage pool when performing a detach operation, this obstacle should be removed in a later version, once the storage pool will be removed completely in VDSM. (https://bugzilla.redhat.com/1138126)
[7] Currently alias names of disks are not persisted in the Storage Domain, so registering disks, will not have alias names. The alias name should be persisted in the Description of the disk in the Storage Domain. (https://bugzilla.redhat.com/1138129)
[8] Add support for importing iSCSI Storage Domain through REST api. (https://bugzilla.redhat.com/920708)
[9] The login button, when picking the targets for importing iSCSI Storage domain should be more noticeable in the GUI (https://bugzilla.redhat.com/1138131)
[10] Add format check box when removing a Storage Domain from the setup (The same as we do for export Storage Domain) - so we can import it to another Data Center in the future (https://bugzilla.redhat.com/1138132)

### Disaster Recovery flows

This is an example of how to recover a setup if it encountered a disaster.
1. Create a new engine setup with new Data Base (see <http://www.ovirt.org/Quick_Start_Guide#Install_oVirt>)
2. Create a new Data Center version 3.5 with cluster and add a Host to this cluster. (Recommended to reboot the Host)
3. Once the Host is UP and running, add and activate a new empty Storage Domain to initialize the Data Center.
4. If there were VMs/Templates which ran in the old setup on different compatible versions, or different CPU types, then those type of clusters should be created on the new Data Center.
5. Follow the instructions of importing Storage Domain, depended on the type of Storage Domain which the user wants to recover:
\* For Import block Storage Domain - <http://www.ovirt.org/Features/ImportStorageDomain#Work_flow_for_Import_block_Storage_Domain_-_UI_flow>

*   For Import file Storage Domain - <http://www.ovirt.org/Features/ImportStorageDomain#Work_flow_for_Import_File_Storage_Domain_-_UI_flow>

### GUI Perspective

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

#### Work flow for Import block Storage Domain - UI flow

On import a Block Device Storage Domain The user should do the following steps:
1. The user should press the "import Storage Domain" button.
2. The user should choose iSCSI or FCP type of Storage Domain.
3. The user should provide a Storage Server name or IP, to be imported from.
4. The engine should present the user a list of targets related to the Storage Server provided in step 3.
5. The user should pick the targets which he knows are related to the Storage Domains he/she wants to import and press the connect button at the top.
6. After the engine will connect to those targets, the user should see in the bottom of the dialog a list of Storage Domains which are candidates to be imported.
7. The user should then choose the Storage Domains which he/she wants to import and press the ok button.
8. Once the Storage Domain has been imported, the user should attach the Storage Domain to an initialized Data Center and activate the Storage Domain.
9. After the Storage Domain is activated, go to the Storage main tab and pick the Storage Domain which was activated a moment ago.
10. In the same Storage main tab, the user should see two sub tabs, "Import VMs" and "Import Tempaltes", in the "Import VMs" sub tab, the user should see all the VMs which are candidates to be imported, and in the "Import Tempaltes" sub tab, there should be the same only for templates.
11. The user can pick several VMs (or Templates), and press on the "import" button.
12. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities the user chose to register.
The user should choose a cluster for each entity which should be compatible for it.
The user can also watch the entity properties (such as disks, networks) in the sub tab inside the dialog.

#### Work flow for Import File Storage Domain - UI flow

<iframe width="300" src="//youtube.com/embed/YbU-DIwN-Wc" frameborder="0" align="right" allowfullscreen="true"> </iframe> On import a File Device Storage Domain The user should do the following steps:
1. The user should press the "import Storage Domain" button.
2. The user should choose a file type domain (NFS, POSIX, etc.).
3. The user should provide the path where this Storage exists and press on the import button.
4. Once the Storage Domain has been imported, the user should attach the Storage Domain to an initialized Data Center and activate the Storage Domain.
5. After the Storage Domain is activated, go to the Storage main tab and pick the Storage Domain which was activated a moment ago.
6. In the same Storage main tab, the user should see two sub tabs, "Import VMs" and "Import Templates", in the "Import VMs" sub tab, the user should see all the VMs which are candidates to be imported, and in the "Import Tempaltes" sub tab, there should be the same only for templates.
7. The user can pick several VMs (or Templates), and press on the "import" button.
8. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities the user chose to register.
The user should choose a cluster for each entity which should be compatible for it.
The user can also watch the entity properties (such as disks, networks) in the sub tab inside the dialog.

#### Work flow for recovery of local Data Center - UI flow

<iframe width="300" src="//youtube.com/embed/T03ai6FrMI4" frameborder="0" align="right" allowfullscreen="true"> </iframe> On import a Local Storage Domain The user should do the following steps:
1. The user should first must initialize a Local Storage Domain.
2. The user should press the "import Storage Domain" button.
3. The user should choose a file type domain Data/ Local on Host.
4. Once the Storage Domain has been imported, the user should attach the Storage Domain to the Data Center he has created and initialized.
5. After the Storage Domain is activated, go to the Storage main tab and pick the Storage Domain which was activated a moment ago.
6. In the same Storage main tab, the user should see two sub tabs, "Import VMs" and "Import Templates", in the "Import VMs" sub tab, the user should see all the VMs which are candidates to be imported, and in the "Import Tempaltes" sub tab, there should be the same only for templates.
7. The user can pick several VMs (or Templates), and press on the "import" button.
8. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities the user chose to register.
The user should choose a cluster for each entity which should be compatible for it.
The user can also watch the entity properties (such as disks, networks) in the sub tab inside the dialog.

#### Work flow for importing GlusterFS Storage Domain - UI flow

<iframe width="300" src="//youtube.com/embed/4YKXHp8wxvI" frameborder="0" align="right" allowfullscreen="true"> </iframe> On import a GlusterFS Storage Domain The user should do the following steps:
1. The user should press the "import Storage Domain" button.
2. The user should choose a file type domain Data/GlusterFS on Host.
3. Once the Storage Domain has been imported, the user should attach the Storage Domain to an initialized Data Center .
4. After the Storage Domain is activated, go to the Storage main tab and pick the Storage Domain which was activated a moment ago.
5. In the same Storage main tab, the user should see two sub tabs, "Import VMs" and "Import Templates", in the "Import VMs" sub tab, the user should see all the VMs which are candidates to be imported, and in the "Import Tempaltes" sub tab, there should be the same only for templates.
6. The user can pick several VMs (or Templates), and press on the "import" button.
7. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities the user chose to register.
The user should choose a cluster for each entity which should be compatible for it.
The user can also watch the entity properties (such as disks, networks) in the sub tab inside the dialog.

#### Mockups

The following UI mockups contain guidelines for the different screens and wizards related for file Storage Domains:
The user flow for importing NFS Storage Domain, will be similar to importing Export/ISO domain.
The user will enter the path of the storage domain and will start the import process.
 An import screen for NFS Storage Domain :
![](ImportNFS.jpeg "fig:ImportNFS.jpeg")
An import screen for POSIX Storage Domain :
![](ImportPosix.jpeg "fig:ImportPosix.jpeg")
An import screen for Gluster Storage Domain :
![](ImportGluster.jpeg "fig:ImportGluster.jpeg")

The following UI mockups contain guidelines for the different screens and wizards related to the block domain:
An import screen for Fibre Channel Storage Domain :
![](FibreChannel.png "fig:FibreChannel.png")
An import screen for iSCSI Storage Domain :
![](Iscsi.jpeg "fig:Iscsi.jpeg")
Import VM/Template sub-tabs
![](import_vm_template_subtab.png "fig:import_vm_template_subtab.png")
Import VM/Template Dialog
![](import_vm_template_dialog.png "fig:import_vm_template_dialog.png")

### REST

#### Get list of unregistered VM/Template

The use can get a list of all the unregistered VMs or unregistered Templates by adding the prefix ";unregistered" after the vms/Templates, in the Storage Domain.
For example to get all the unregistered VMs in the Storage Domain 68ca2f73-9b15-4839-83c9-859244ad2cd3 the URL will be : <http://localhost:8080/api/storagedomains/68ca2f73-9b15-4839-83c9-859244ad2cd3/vms;unregistered> ![](UnregisterVM2.png "fig:UnregisterVM2.png")

#### Register VM to a new cluster

If the user want to register a VM to the setup, then the URL should indicate register after the VM id, as follow: <http://localhost:8080/api/storagedomains/xxxxxxx-xxxx-xxxx-xxxxxx/vms/xxxxxxx-xxxx-xxxx-xxxxxx/register> ![](UnregisterVM1.png "fig:UnregisterVM1.png")

#### Get all the unregistered disks in the Storage Domain

If the user want to get a list of all the floating disks in the storage domain he should use the following URL:
<http://localhost:8080/ovirt-engine/api/storagedomains/60cec75d-f01d-44a0-9c75-8b415547bc3d/disks;unregistered> ![](ListUnregisteredDisk.png "fig:ListUnregisteredDisk.png")

#### Register an unregistered disk

If the user want to register a specific floating disks in the system he should use the following:

      Method: Post
`URL: `[`http://localhost:8080/ovirt-engine/api/storagedomains/60cec75d-f01d-44a0-9c75-8b415547bc3d/disks;unregistered/`](http://localhost:8080/ovirt-engine/api/storagedomains/60cec75d-f01d-44a0-9c75-8b415547bc3d/disks;unregistered/)
`Body: `<disk id='8ddb988f-6ab8-4c19-9ea0-b03ab3035347'></disk>

![](RegisterDisk.png "RegisterDisk.png")

### Permissions

*   No additional permissions will be added.

### Future Work

*   Import Storage Domain : The user will be able to import a list of Storage domains all at once.
*   Adding validation for checking image corruption after importing the Storage Domain. - Mainly for sync issues with the OVF.
*   Import an Export Domain as a regular Storage Domain

### Related Bugs

*   <https://bugzilla.redhat.com/1069780>
*   <https://bugzilla.redhat.com/1069173>

### Related Features

*   OVF on any domain
*   Import Unregistered entities
*   Local Storage Domain
*   Gluster
*   PosixFs
*   Quota - The user might import disks which will extend a defined Quota in DC.

This scenario is similar to when a user enforce a quota though it already been extended. The default behaviour will treat that by letting the user still use the resources though he/she will not be able to create any more disks.

### Comments and Discussion

*   Refer to [Talk: ImportStorageDomain](Talk: ImportStorageDomain)

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
*   The feature is dependent on both features:

1.  Detach/Attach Storage Domain - <http://www.ovirt.org/Features/ImportUnregisteredEntities>
2.  OVF on any Storage Domain - <http://www.ovirt.org/Feature/OvfOnWantedDomains>

*   The user can import a Storage Domains and attach it directly to a Data Center, or it can be imported as 'unattached' Storage Domain, and later the user can attach it to a Data Center he desires.
*   When attaching a Storage Domain to a Data Center, all the entities(VMs,Templates) from the OVF_STORE disk should be retrieved from the tar file and into the Data Base table unregistered_ovf_of_entities, later the user can decide how to register them into the Data Center (see <http://www.ovirt.org/Features/ImportUnregisteredEntities#General_Functionality>)
*   Once those VM/Template will be in the Data Base, the user should be able to register those entities using the import unregistered entities feature [see <http://www.ovirt.org/Features/ImportUnregisteredEntities#Work_flow_for_detach_and_attach_Storage_Domain_with_entities_-_UI_flow>]

#### Restrictions

*   Attaching an imported Storage Domain can only be applied with an initialized Data Center. (see [7])
*   If a Storage Domain will not contain the OVF_STORE disk, the engine should attach the Storage Domain without any unregistered entities, and a message in the engine log should be presented.
*   If a Storage Domain will contain several OVF_STORE disks, the engine should retrieve the unregistered entities only from the newest and updated OVF_STORE disk. (see [1])
*   If the chosen OVF_STORE disk will contain an entity which already exists in the unregistered_ovf_of_entities table (see <http://www.ovirt.org/Features/ImportUnregisteredEntities#General_Functionality>), the engine will replace the data in the unregistered_ovf_of_entities table with the VM fetched from the OVF_STORE disk.
*   An import of a Storage Domain will not reflect the status of a VM (Up, Powring Up, Shutting Down...) all the VMs will be registered as down.
*   An import of a Storage Domain should be supported for block Storage Domain, and file Storage Domain.
*   For better sync of the entities in the Storage Domain with the OVF_STORE disk, it is better to update the OvfUpdateIntervalInMinutes option in vdc_options from 60 minutes to 2-5 minutes, as so : update vdc_options set option_value = 2 where option_name = 'OvfUpdateIntervalInMinutes'; (see [5])
*   In a disaster recovery scenario, if the Host, which the user about to use, was in the environment which was destroyed, it is recommended to reboot this Host before adding it to the new setup. The reason for that is first, to kill any qemu processes which are still running and might be automatically added into the new setup as VMs, also, to avoid any sanlock issues.

#### Implementation gaps

[1] On the attach operation all those OVF_STORE disks should be scanned for OVF entities.
 All the VMs/Templates in the OVF_STORE disks should be presented to the user as an unregistered entities which should be imported. (see [1])
[2] The attach operation should notify the user, a warning, whether the Storage Domain is already attached to another Data Center.
 The user can then choose whether to run over the meta data or neglect its operation.
[3] On attach of a Storage Domain, the user risks a data corruption if the Storage Domain is being used by another oVirt setup, in order to avoid data corruption. Before every attach operation of a Storage Domain with a meta data indicating it is related to another Data Center, the system will prompt the user a warning message that indicates it is already attached to a Data Center.
[4] Open Issue: We should have an indication of External LUN disk on the Lun
[5] When the user moved the Storage Domain to maintenance, all the entities related to the Storage Domain should be updated in the OVF_STORE disk. [7] Currently, VDSM take a lock on the storage pool when performing a detach operation, this obstacle should be removed in a later version, once the storage pool will be removed completely in VDSM.

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

#### Work flow for Import block Storage Domain - UI flow

On import a Block Device Storage Domain The user should do the following steps:
1. The user should press the "import Storage Domain" button.
2. The user should choose iSCSI or FCP type of Storage Domain.
3. The user should provide a Storage Server name or IP, to be imported from.
4. The engine should present the user a list of targets related to the Storage Server provided in step 3.
5. The user should pick the targets which he knows are related to the Storage Domains he/she wants to import and press the connect button.
6. After the engine will connect to those targets, the user should see in the bottom of the dialog a list of Storage Domains which are candidates to be imported.
7. The user should then choose the Storage Domains which he/she wants to import and press the ok button.
8. Once the Storage Domain has been imported, the user should attach the Storage Domain to an initialized Data Center and activate the Storage Domain.
9. After the Storage Domain is activated, go to the Storage main tab and pick the Storage Domain which was activated a minute ago.
10. In the same Storage main tab, the user should see two sub tabs, "Import VMs" and "Import Tempaltes", in the "Import VMs" sub tab, the user should see all the VMs which are candidates to be imported, and in the "Import Tempaltes" sub tab, there should be the same only for templates.
11. The user can pick several VMs (or Templates), and press on the "import" button.
12. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities the user chose to register.
The user should choose a cluster for each entity which should be compatible for it.
The user can also watch the entity properties (such as disks, networks) in the sub tab inside the dialog.

#### Work flow for Import File Storage Domain - UI flow

On import a File Device Storage Domain The user should do the following steps:
1. The user should press the "import Storage Domain" button.
2. The user should choose a file type domain (NFS, POSIX, etc.).
3. The user should provide the path where this Storage exists and press on the import button.
4. Once the Storage Domain has been imported, the user should attach the Storage Domain to an initialized Data Center and activate the Storage Domain.
5. After the Storage Domain is activated, go to the Storage main tab and pick the Storage Domain which was activated a minute ago.
6. In the same Storage main tab, the user should see two sub tabs, "Import VMs" and "Import Tempaltes", in the "Import VMs" sub tab, the user should see all the VMs which are candidates to be imported, and in the "Import Tempaltes" sub tab, there should be the same only for templates.
7. The user can pick several VMs (or Templates), and press on the "import" button.
8. When the "Import" button is pressed, a dialog should be opened, showing the list of all the entities the user chose to register.
The user should choose a cluster for each entity which should be compatible for it.
The user can also watch the entity properties (such as disks, networks) in the sub tab inside the dialog.

#### Mockups

The following UI mockups contain guidelines for the different screens and wizards related for file Storage Domains:
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

#### Permissions

*   No additional permissions will be added.
*   The role for importing a Storage Domain should be CREATE_STORAGE_DOMAIN

Open issue: Could be also that CREATE_VM for creating VMs.

#### Future Work

*   Detach Stroage Domain with VMs/Templates and disks: The user will be able to detach a list of Storage Domains all at once instead detaching each Storage Domain one by one.
*   Import Storage Domain : The user will be able to import a list of Storage domains all at once.
*   Adding validation for checking image corruption after importing the Storage Domain. - Mainly for sync issues with the OVF.
*   Import an Export Domain as a regular Storage Domain

#### Related Bugs

*   <https://bugzilla.redhat.com/1069780>
*   <https://bugzilla.redhat.com/1069173>

#### Related Features

*   OVF on any domain
*   Quota - The user might import disks which will extend a defined Quota in DC.

This scenario is similar to when a user enforce a quota though it already been extended. The default behaviour will treat that by letting the user still use the resources though he/she will not be able to create any more disks.

*   Local Storage Domain - Should be the same behaviour as any other NFS Storage Domain.
*   Gluster
*   PosixFs

#### Comments and Discussion

*   Refer to [Talk: ImportStorageDomain](Talk: ImportStorageDomain)

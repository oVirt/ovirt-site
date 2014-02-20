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

Today, oVirt is able to import ISO and Export Storage Domains, however, there is no support for importing an existing Data Storage Domain.
Each Data Storage Domain is an entity which contains disks and sometime VM's and Template's OVF.
The OVF is an XML standard representing the VM configuration, including disks, VM memory, CPU and more.
Based on this information stored in the Storage Domain,
we can relate the disks, VMs and Templates to on any Data Center which we will relate the Storage Domain into.
The usability of the feature might be useful for various use cases, the following are some of them:

*   Recover after the loss of the oVirt Engine's database.
*   Transfer VMs between setups without the need to copy the data into and out of the export domain.
*   Support migrating Storage Domains between DCs and between different oVirt installations.

### Owner

*   Maor Lipchuk mlipchuk@redhat.com

### Current status

*   Design

### General Functionality

*   The VMs'/Templates' OVFs will be imported from the OVF disk in the Storage Domain [see 1], the OvfOnWantedDomains feature, will be supported from oVirt 3.5.
*   Imported domains will be imported as 'unattached' and can then be attached to a DC.
*   If the OVF disk [see 1] will not be in the Storage Domain, then the only entities that will be imported are the disks in the Storage Domain (An appropriate event log will be notify it to the user).

[1] <http://www.ovirt.org/Feature/OvfOnWantedDomains>

##### Phase 1 - Detach/Attach Storage Domain with VMs/Templates

Today we can detach a Storage Domain from the DC, only if it is empty, i.e. does not contain any disks or VMs/Templates
As part of Import Storage Domain feature, oVirt will add the ability for the user to detach a Storage Domain containing VMs/Templates and Disks, and re-attach it again to another Data Center.
As part of phase 1, if the Storage Domain contains VMs or Tempaltes which contain disks on multiple Storage Domains the operation will fail and the following event will be presented to the user:
\* Cannot detach {Storage Domain Name}. The following VMs/Templates have disks that reside on other storage domains: {vm names}. Please either detach those disks or move them to the storage domain.
Shareable and direct lun disks are not supported in the OVF file today, hence if a VM includes a shareable or direct lun disks a warning will be prompt for the user, indicating the following:
\* Attention, The following VMs contains shareable/direct lun disks which will not be part of the VM configuration after the detach will take place: {vmNames}.
Only VMs'/Templates' OVF will be part of the Data Center on attach operation, for now there is a gap that VMs/Templates with no disks does not exists in the Storage Domain's OVF, therefore those VMs will not be present in the setup on attach operation.
Open Issue: On detach of Storage Domain the VMs/Templates related to the Storage Domain should not be present in the engine, but will still be part of the OVF disk in the Storage Domain.
On attach the user should assign those VMs/Templates the appropriate clusters before the user will start to use them.

##### Phase 2 - Import NFS Storage Domain

*   When importing a Storage Domain with OVF files referencing disks on additional Storage Domains which do not currently exist in the system, the system will automatically add a reference to these Storage Domains in the DC and denote them as unavailable. {DOMAIN_UUID}_unavailable
*   The unavailable Storage Domains will behave the same as a Storage Domain in maintenance status. The disks related to these Storage Domains (Which are related to the VMs) will be shown as disabled in the GUI and will be inactive (unplugged).
*   When the user will decide to import a Storage Domain to the setup, which already has disks related to this Storage Domain, the engine will verify if the target Data Center is the same as the Data Center where the unavailable Storage Domain exists, the engine will run over the properties of the Storage Domain configuration (Name, path ext.) and will change the configuration properly. If the Data Center does not match the Data Center of the unavailable Storage Domain, the user will be prompt with a can do action message that there is already reference of this Storage Domain in another Data Center, and the user should import it to the right Data Center.
*   The user can decide that he/she does not want any relation to the unavailable Storage Domain's disks, in his/her setup, and can simply remove the unavailable Storage Domain and all its disks references.
*   The disks imported from the imported Storage Domain will be the same as in the VM's OVF, which means plugged/unplugged to the VM. If the user will try to run a VM which contains disks on the unavailable Storage Domain, the behaviour should be the same as if the disks were on a Storage Domain in maintenance status. The operation should be blocked until the user will update the disks to be unplugged on the VM.
*   A Template Disk might reside on multiple Storage Domains. The OVF of the template should not contain any reference to the copies of the disks, so there will be no references of copied disks when importing a Storage Domain. Once a Storage Domain will be imported which have the same UUID for an existing template disk, an appropriate event log will notify this to the user, and the user can copy the disks to whichever Storage Domains he or she pleases.
*   When importing a Storage Domain the user needs to take care not to import a Storage Domain which is in use by another oVirt setup to avoid data corruption. The system will prompt the user with a warning message before each import of Storage Domain with Meta Data that indicates it is already attached to a Storage Pool.

###### GUI Perspective

*   The user flow for importing an NFS Storage Domain, will be similar to importing Export/ISO domain.

The user will enter the path of the storage domain and will start the import process.
\* Unrelated disks will be disabled in the GUI

The following UI mockups contain guidelines for the different screens and wizards related for file Storage Domains:
An import screen for NFS Storage Domain :
![](ImportNFS.jpeg "fig:ImportNFS.jpeg")
An import screen for POSIX Storage Domain :
![](ImportPosix.jpeg "fig:ImportPosix.jpeg")
An import screen for Gluster Storage Domain :
![](ImportGluster.jpeg "fig:ImportGluster.jpeg")

###### DB Changes

We will add a new column in the storage domains table which will be called isStorageExists.
When this field is false then all the images related to it will be disabled in the GUI.

##### Phase 3 - Import block device Storage Domain

On import a Block Device Storage Domain,
The user will need to input a Storage Server name or IP, the engine will then connect to all the LUNs in the Storage Server and will group by their VGs.
Each VG represents a Storage Domain in the engine.
Eventually the engine should have a map of maps.
The first map will link between VG and targets. each target is also a map which link between the target and its LUNs.
Open Issue: We should have an indication of External LUN disk on the Lun

###### GUI Perspective

*   Once the user will decide to import a Block Device Domain, it will use a similar dialog as adding iSCSI/FC Storage Domain. The user will use the Storage Server name or IP as an input, and the Host chosen will connect to the Storage Server a display the targets on it.
*   Once the user will check the targets he will want to connect and press the login button, the user should see a list of Storage Domains names and sizes, related to those targets chosen. Each Storage Target will have a tool tip once standing on it, it will present a list of LUN GUIDs related to it.
*   Once the user selects a storage domain to import, he will press the Import button, and the engine will read the VM OVFs from it (see: OVF on any domain feature), and the disks that reside on the Domain. From there on, the behaviour should be the same as importing from NFS as described in phase 2.

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

*   Detach Stroage Domain: Eventually if the user will choose all the storage domains at once then we will detach them all at once (Need to take into consideration this message could nag the user since we might always have VMs with disks on other storage domains)
*   Import Storage Domain : supporting importing of iSCSI storage domain will be in later phase
*   Import Storage Domain : The user will be able to send a list of paths, and the engine will import them all at once
*   Nice to have: A way to choose the VMs to import to the DC (instead automatically)
*   Mock ups will be added.
*   Phase 3 GUI Perspective : The user will be also able to see the LUNs as the main entity and get to know which VG it is related to.
*   Adding validation for checking image corruption after importing the Storage Domain. - Could be useful for indicating synchronization issues in the OVF.
*   Metadata containing last setup data - The Meata Data should be updated once the Storage Domain is successfully imported and a copy of it containning the original data should be created in the same directory, so we will be able to have a trace.
*   Import an Export Domain as a regualr Storage Domain

##### Different scenarios

Delete the Storage Domain while importing it - There could be a scenario which the import of the Storage Domain will be deleted in the middle of the process.
If the mount for NFS or the Connect in Block Storage Domain already succeeded then the behaviour will be that the Storage Domain will become invalid.
If the mount/connect did not succeeded then the operation will fail with an appropriate audit log.

#### Related Features

OVF on any domain
Quota - The user might import disks which will extend a defined Quota in DC. This scenario is similar to when a user enforce a quota though it already been extended.
The default behaviour will treet that by letting the user still use the resources though he will not be able to create any more disks.
Local Storage Domain - It should be the same behaviour as any other NFS Storage Domain. Gluster PosixFS

#### Comments and Discussion

*   Refer to [Talk: ImportStorageDomain](Talk: ImportStorageDomain)

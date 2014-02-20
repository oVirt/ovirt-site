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

##### Phase 1 - Detach Storage Domain

Today we can detach a Storage Domain from the DC, only if it does not contains any disks or VMs on it.
As part of this feature, the user will be able to also detach Storage Domain which contains VMs and Disks, and re-attach it to other Data Center.
If there will be VMs with disks on multiple Storage Domains or Template with disks on multiple Storage Domains as well the operation will fail and an event log will be presented, with the following message (see future work) :
 Cannot detach {Storage Domain Name}. The following VMs/Templates have disks related to the following storages {other Storage Domain Names}. Please move those disks to the {Storage Domain Name}.

##### Phase 2 - Import NFS Storage Domain

On import an existing Storage Domain, the engine will read the VM's OVFs from the file (Related to OVF on any domain), and the related disks of the Data Domain.
If the file does not exists in the domain, the engine will only import the disks without the VMs and will print an appropriate event log.
We might have a VM with disks on other Storage Domains, in that case we will add a new Storage Domain which will be named {Data_Center_Name}_Unattached# to the Data Center.
This dummy Storage Domain functionality will behave the same as a Storage Domain in maintenance mode.
The disks related to this Storage Domain (Which are related to the VMs) will be shown as disabled in the GUI and will be inactive for the VM.
The VMs could run but the inactive disks will not be part of the process.The user should confirm that the OS and the boot disk is on the active disks.
Template Disk might be on multiple Storage Domains, in case some of the Storage Domains are unattached (isStorageExists is false), then the functionality of creating a VM from this Template will be the same as a maintenance Storage Domain.

###### ALERT of importing used Storage Domain

The main risk of Data Corruption that can be here, is when a user will import a Storage Domain which some other setup uses.
To avoid this kind of Data Corruption, the engine will prompt a warning message before each import of Storage Domain with Meta Data that indicate it is already attached to a Storage Pool.

###### Importing Unattached Storage Domain

The user can also import an unattached Storage Domain to the Data Center, which has already disks related to it.
Once that done we can correlate the storage GUID of the storage with the storage GUID in the Unattached Storage Domain in the DC,
once we will found a match, the engine will run over the properties of the Storage Domain configuration (Name, path ext.) and will change the isStorageExists flag to true.

###### GUI Perspective

*   The Import of an NFS Storage Domain, will be the similar from the GUI perspective of importing Export/ISO domain.

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
Open Question: What about external LUN disk, should it be considered as a new storage domain?

###### GUI Perspective

*   Once the user will decide to import a Block Device Domain, it will use a similar dialog as adding iSCSI/FC Storage Domain.

The user will use the Storage Server name or IP as an input, and the Host which will do the connect, and will press connect.
Once the engine will finish connecting to all the LUNs, the user should see a list of targets. When he will choose one target, he should see in another tab of the dialog, the Storage Domain names where each one of them will have a list of Luns related to them Once the user finished to import the Storage Server he chose, and the engine will read the VM's OVFs from the file (Related to OVF on any domain), and the related disks of the Data Domain.
From that on, the same behaviour should be the same as importing from NFS as described in phase 2.

The following UI mockups contain guidelines for the different screens and wizards related to the block domain:
An import screen for Fibre Channel Storage Domain :
![](FibreChannel.png "fig:FibreChannel.png")
An import screen for iSCSI Storage Domain :
![](Iscsi.jpeg "fig:Iscsi.jpeg")

#### Permissions

There should not be changes is detach storage domain Every user with permissions to create a Storage Domain on the Data Center, will be able to import a storage domain as well.

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

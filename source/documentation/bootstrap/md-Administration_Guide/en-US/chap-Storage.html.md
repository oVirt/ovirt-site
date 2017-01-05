# Storage

Red Hat Virtualization uses a centralized storage system for virtual machine disk images, ISO files and snapshots. Storage networking can be implemented using:

* Network File System (NFS)

* GlusterFS exports

* Other POSIX compliant file systems

* Internet Small Computer System Interface (iSCSI)

* Local storage attached directly to the virtualization hosts

* Fibre Channel Protocol (FCP)

* Parallel NFS (pNFS)

Setting up storage is a prerequisite for a new data center because a data center cannot be initialized unless storage domains are attached and activated.

As a Red Hat Virtualization system administrator, you need to create, configure, attach and maintain storage for the virtualized enterprise. You should be familiar with the storage types and their use. Read your storage array vendor's guides, and see the [Red Hat Enterprise Linux Storage Administration Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/) for more information on the concepts, protocols, requirements or general usage of storage.

Red Hat Virtualization enables you to assign and manage storage using the Administration Portal's **Storage** tab. The **Storage** results list displays all the storage domains, and the details pane shows general information about the domain.

To add storage domains you must be able to successfully access the Administration Portal, and there must be at least one host connected with a status of **Up**.

Red Hat Virtualization has three types of storage domains:

* **Data Domain:** A data domain holds the virtual hard disks and OVF files of all the virtual machines and templates in a data center. In addition, snapshots of the virtual machines are also stored in the data domain.

    The data domain cannot be shared across data centers. Data domains of multiple types (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, provided they are all shared, rather than local, domains.

    You must attach a data domain to a data center before you can attach domains of other types to it.

* **ISO Domain:** ISO domains store ISO files (or logical CDs) used to install and boot operating systems and applications for the virtual machines. An ISO domain removes the data center's need for physical media. An ISO domain can be shared across different data centers. ISO domains can only be NFS-based. Only one ISO domain can be added to a data center.

* **Export Domain:** Export domains are temporary storage repositories that are used to copy and move images between data centers and Red Hat Virtualization environments. Export domains can be used to backup virtual machines. An export domain can be moved between data centers, however, it can only be active in one data center at a time. Export domains can only be NFS-based. Only one export domain can be added to a data center.

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](sect-Importing_Existing_Storage_Domains) for information on importing storage domains.

**Important:** Only commence configuring and attaching storage for your Red Hat Virtualization environment once you have determined the storage needs of your data center(s).

* [Storage properties](Storage_properties)

## Preparing and Adding NFS Storage

* [Preparing NFS Storage](Preparing_NFS_Storage)
* [Attaching NFS Storage](Attaching_NFS_Storage1)
* [Increasing NFS Storage](Increasing_NFS_Storage)

## Preparing and Adding Local Storage

* [Preparing Local Storage](Preparing_Local_Storage)
* [Adding Local Storage](Adding_Local_Storage)

## Preparing and Adding POSIX Compliant File System Storage 

POSIX file system support allows you to mount file systems using the same mount options that you would normally use when mounting them manually from the command line. This functionality is intended to allow access to storage not exposed using NFS, iSCSI, or FCP.

Any POSIX compliant filesystem used as a storage domain in Red Hat Virtualization **MUST** support sparse files and direct I/O. The Common Internet File System (CIFS), for example, does not support direct I/O, making it incompatible with Red Hat Virtualization.

**Important:** Do *not* mount NFS storage by creating a POSIX compliant file system Storage Domain. Always create an NFS Storage Domain instead.

* [Attaching POSIX Compliant Filesystem Storage](Attaching_POSIX_Compliant_Filesystem_Storage)

## Preparing and Adding Block Storage

* [Preparing iSCSI Storage](Preparing_iSCSI_Storage)
* [Adding iSCSI Storage](Adding_iSCSI_Storage1)
* [Configuring iSCSI Multipathing](Configuring_iSCSI_Multipathing)
* [Adding FCP Storage](Adding_FCP_Storage)
* [Increasing iSCSI or FCP Storage](Increasing_iSCSI_or_FCP_Storage)
* [Un-useable LUNs in Red Hat Enterprise Virtualization](Un-useable_LUNs_in_Red_Hat_Enterprise_Virtualization)

## Importing Existing Storage Domains

* [Overview of Importing Existing Storage Domains](Overview_of_Importing_Existing_Storage_Domains)
* [Importing existing ISO or export storage domains](Importing_existing_ISO_or_export_storage_domains)
* [Migrating Storage Domains between Data Centers Same Environment](Migrating_Storage_Domains_between_Data_Centers_Same_Environment)
* [Migrating Storage Domains between Data Centers Different Environment](Migrating_Storage_Domains_between_Data_Centers_Different_Environment)
* [Importing Virtual Machines from an Imported Data Storage Domain](Importing_Virtual_Machines_from_an_Imported_Data_Storage_Domain)
* [Importing Templates from Imported Data Storage Domains](Importing_Templates_from_Imported_Data_Storage_Domains)
* [Importing a Disk Image](Importing_a_Disk_Image)
* [Importing an Unregistered Disk Image](Importing_an_Unregistered_Disk_Image)

## Storage Tasks

* [Populating the ISO Storage Domain](Populating_the_ISO_Storage_Domain1)
* [Moving storage domains to maintenance mode](Moving_storage_domains_to_maintenance_mode)
* [Editing Storage Domains](Editing_Storage_Domains)
* [Activating storage domains](Activating_storage_domains)
* [Removing a Storage Domain](Removing_a_Storage_Domain)
* [Destroying a storage domain](Destroying_a_storage_domain)
* [Detaching a storage domain](Detaching_a_storage_domain)
* [Attaching a storage domain](Attaching_a_storage_domain)

### Disk Profiles 

Disk profiles define the maximum level of throughput and the maximum level of input and output operations for a virtual disk in a storage domain. Disk profiles are created based on storage profiles defined under data centers, and must be manually assigned to individual virtual disks for the profile to take effect.

* [Creating a Disk Profile](Creating_a_Disk_Profile)
* [Removing a Disk Profile](Removing_a_Disk_Profile)

<!-- end ### section -->

* [Viewing the Health Status of a Storage Domain](Viewing_the_Health_Status_of_a_Storage_Domain)

## Storage and Permissions

* [Cluster hosts entities](Cluster_hosts_entities)
* [Cluster virtual machine entities](Cluster_virtual_machine_entities)
* [Assigning an Administrator or User Role to a Resource](Assigning_an_Administrator_or_User_Role_to_a_Resource5)
* [Removing an Administrator or User Role from a Resource](Removing_an_Administrator_or_User_Role_from_a_Resource2)

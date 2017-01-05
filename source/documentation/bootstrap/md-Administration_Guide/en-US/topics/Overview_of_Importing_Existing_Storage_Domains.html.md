# Overview of Importing Existing Storage Domains

In addition to adding new storage domains that contain no data, you can also import existing storage domains and access the data they contain. The ability to import storage domains allows you to recover data in the event of a failure in the Manager database, and to migrate data from one data center or environment to another.

The following is an overview of importing each storage domain type:

Data
: Importing an existing data storage domain allows you to access all of the virtual machines and templates that the data storage domain contains. After you import the storage domain, you must manually import virtual machines, floating disk images, and templates into the destination data center. The process for importing the virtual machines and templates that a data storage domain contains is similar to that for an export storage domain. However, because data storage domains contain all the virtual machines and templates in a given data center, importing data storage domains is recommended for data recovery or large-scale migration of virtual machines between data centers or environments.

    **Important:** You can import existing data storage domains that were attached to data centers with a compatibility level of 3.5 or higher.

ISO
: Importing an existing ISO storage domain allows you to access all of the ISO files and virtual diskettes that the ISO storage domain contains. No additional action is required after importing the storage domain to access these resources; you can attach them to virtual machines as required.

Export
:  Importing an existing export storage domain allows you to access all of the virtual machine images and templates that the export storage domain contains. Because export domains are designed for exporting and importing virtual machine images and templates, importing export storage domains is recommended method of migrating small numbers of virtual machines and templates inside an environment or between environments. For information on exporting and importing virtual machines and templates to and from export storage domains, see [Exporting and Importing Virtual Machines and Templates](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide/#sect-Exporting_and_Importing_Virtual_Machines_and_Templates) in the *Virtual Machine Management Guide*.

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center.






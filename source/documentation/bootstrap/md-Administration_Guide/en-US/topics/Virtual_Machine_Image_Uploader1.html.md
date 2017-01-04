# The Image Uploader Tool

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](sect-Importing_Existing_Storage_Domains) for information on importing storage domains.

The `engine-image-uploader` command allows you to list export storage domains and upload virtual machine images in OVF or OVA format to an export storage domain and have them automatically recognized in the Red Hat Virtualization Manager.

An OVA is a `tar` archive of the OVF files.


**Note:** The image uploader only supports gzip-compressed OVF files, or OVA files, created by Red Hat Virtualization.

The OVF contains images and master directories in the following format: 

    |-- images
    |   |-- [Image Group UUID]
    |        |--- [Image UUID (this is the disk image)]
    |        |--- [Image UUID (this is the disk image)].meta
    |-- master
    |   |---vms
    |       |--- [UUID]
    |             |--- [UUID].ovf

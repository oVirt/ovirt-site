# Understanding Virtual Disks

Red Hat Virtualization features **Preallocated** (thick provisioned) and **Sparse** (thin provisioned) storage options.

* Preallocated

    A preallocated virtual disk allocates all the storage required for a virtual machine up front. For example, a 20 GB preallocated logical volume created for the data partition of a virtual machine will take up 20 GB of storage space immediately upon creation.

* Sparse

    A sparse allocation allows an administrator to define the total storage to be assigned to the virtual machine, but the storage is only allocated when required.

    For example, a 20 GB thin provisioned logical volume would take up 0 GB of storage space when first created. When the operating system is installed it may take up the size of the installed file, and would continue to grow as data is added up to a maximum of 20 GB size.

The size of a disk is listed in the **Disks** sub-tab for each virtual machine and template. The **Virtual Size** of a disk is the total amount of disk space that the virtual machine can use; it is the number that you enter in the **Size(GB)** field when a disk is created or edited. The **Actual Size** of a disk is the amount of disk space that has been allocated to the virtual machine so far. Preallocated disks show the same value for both fields. Sparse disks may show a different value in the **Actual Size** field from the value in the **Virtual Size** field, depending on how much of the disk space has been allocated.

**Note:** When creating a Cinder virtual disk, the format and type of the disk are handled internally by Cinder and are not managed by Red Hat Virtualization.

The possible combinations of storage types and formats are described in the following table.

**Permitted Storage Combinations**

| Storage | Format | Type | Note |
| NFS or iSCSI/FCP | RAW or QCOW2 | Sparse or Preallocated | |
|-
| NFS | RAW | Preallocated | A file with an initial size which equals the amount of storage defined for the virtual disk, and has no formatting. |
| NFS | RAW | Sparse | A file with an initial size which is close to zero, and has no formatting. |
| NFS | QCOW2 | Sparse | A file with an initial size which is close to zero, and has QCOW2 formatting. Subsequent layers will be QCOW2 formatted. |
| SAN | RAW | Preallocated | A block device with an initial size which equals the amount of storage defined for the virtual disk, and has no formatting. | 
| SAN | QCOW2 | Sparse | A block device with an initial size which is much smaller than the size defined for the virtual disk (currently 1 GB), and has QCOW2 formatting for which space is allocated as needed (currently in 1 GB increments). |

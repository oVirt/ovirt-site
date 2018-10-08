# Storage Considerations

The storage domain for Red Hat Virtualization can be made of either block devices (SAN - iSCSI or FCP) or a file system (NAS - NFS, GlusterFS, or other POSIX compliant file systems). For more information about Red Hat Virtualization storage see [Storage](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/administration_guide/#chap-Storage) in the *Administration Guide*. 

**Important:** Local storage domains are unsupported for disaster recovery.

A primary and secondary storage replica is required. The primary storage domain’s block devices or shares that contain virtual machine disks or templates must be replicated. The secondary storage must not be attached to any data center, and will be added to the backup site’s data center during failover.

If you are implementing disaster recovery using self-hosted engine, ensure that the  storage domain used by the self-hosted engine Manager virtual machine does not contain virtual machine disks because the storage domain will not be failed over.

All storage solutions that have replication options that are supported by Red Hat Enterprise Linux 7 and later can be used.

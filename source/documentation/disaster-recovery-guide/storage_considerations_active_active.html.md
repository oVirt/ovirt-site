# Storage Considerations

The storage domain for Red Hat Virtualization can be made of either block devices (SAN - iSCSI or FCP) or a file system (NAS - NFS, GlusterFS, or other POSIX compliant file systems). For more information about Red Hat Virtualization storage see [Storage](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html-single/administration_guide/#chap-Storage) in the *Administration Guide*.

The sites require synchronously replicated storage that is writeable on both sites with shared layer 2 (L2) network connectivity. The replicated storage is required to allow virtual machines to migrate between sites and continue running on the site’s storage. All storage replication options supported by Red Hat Enterprise Linux 7 and later can be used in the stretch cluster.

IMPORTANT: If you have a custom multipath configuration that is recommended by the storage vendor, copy the .conf file to the `/etc/multipath/conf.d/` directory. The custom settings will override settings in the VDSMs `multipath.conf` file.  Do not modify the VDSM file directly.

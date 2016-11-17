# Custom Partitioning

Custom partitioning on Red Hat Virtualization Host (RHVH) is not recommended. Red Hat strongly recommends using the **Automatically configure partitioning** option in the **Installation Destination** window.

If your installation requires custom partitioning, note that the following restrictions apply:

* You must select the **LVM Thin Provisioning** option in the **Manual Partitioning** window.

* The root (`/`) directory must be on a thinly provisioned logical volume.

* The root (`/`) directory must be at least 6 GB.

* The `/var` directory must be on a separate volume or disk.

* Only XFS or Ext4 file systems are supported.

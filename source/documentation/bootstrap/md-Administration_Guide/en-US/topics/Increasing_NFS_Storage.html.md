# Increasing NFS Storage

To increase the amount of NFS storage, you can either create a new storage domain and add it to an existing data center, or increase the available free space on the NFS server. For the former option, see [Attaching NFS Storage](Attaching_NFS_Storage1). The following procedure explains how to increase the available free space on the existing NFS server.

**Increasing an Existing NFS Storage Domain**

1. Click the **Storage** resource tab and select an NFS storage domain.

2. In the details pane, click the **Data Center** tab and click the **Maintenance** button to place the storage domain into maintenance mode. This unmounts the existing share and makes it possible to resize the storage domain.

3. On the NFS server, resize the storage. For Red Hat Enterprise Linux 6 systems, see [Red Hat Enterprise Linux 6 Storage Administration Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Storage_Administration_Guide/index.html#s2-disk-storage-parted-resize-part). For Red Hat Enterprise Linux 7 systems, see [Red Hat Enterprise Linux 7 Storage Administration Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html-single/Storage_Administration_Guide/index.html#s2-disk-storage-parted-resize-part).

4. In the details pane, click the **Data Center** tab and click the **Activate** button to mount the storage domain.

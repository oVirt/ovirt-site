# Preparing Local Storage

A local storage domain can be set up on a host. When you set up a host to use local storage, the host automatically gets added to a new data center and cluster that no other hosts can be added to. Multiple host clusters require that all hosts have access to all storage domains, which is not possible with local storage. Virtual machines created in a single host cluster cannot be migrated, fenced or scheduled. For more information on the required system users and groups see [System Accounts](appe-System_Accounts).

**Important:** On Red Hat Virtualization Host (RHVH), the path used for local storage must be within the /var directory; create the storage directory in the following procedure within `/var`.

**Preparing Local Storage**

1. On the host, create the directory to be used for the local storage.

        # mkdir -p /data/images

2. Ensure that the directory has permissions allowing read/write access to the `vdsm` user (UID 36) and `kvm` group (GID 36).

        # chown 36:36 /data /data/images
        # chmod 0755 /data /data/images

Your local storage is ready to be added to the Red Hat Virtualization environment.

**Note:** You can also mount external storage to a host machine for use as a local storage domain. For more information on mounting storage, see the Red Hat Enterprise Linux [*Storage Administration Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/index.html).

# Preparing NFS Storage

Set up NFS shares that will serve as a data domain and an export domain on a Red Hat Enterprise Linux 6 server. It is not necessary to create an ISO domain if one was created during the Red Hat Virtualization Manager installation procedure. For more information on the required system users and groups see [System Accounts](appe-System_Accounts).

**Note:** This procedure includes steps for setting up an export storage domain, which is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](sect-Importing_Existing_Storage_Domains) for information on importing storage domains.

1. Install nfs-utils, the package that provides NFS tools:

        # yum install nfs-utils

2. Configure the boot scripts to make shares available every time the system boots:

        # systemctl daemon-reload
        # systemctl enable rpcbind.service
        # systemctl enable nfs-server.service

3. Start the rpcbind service and the nfs service:

        # systemctl start rpcbind.service
        # systemctl start nfs-server.service

4. Create the data directory and the export directory:

        # mkdir -p /exports/data
        # mkdir -p /exports/export

5. Add the newly created directories to the `/etc/exports` file. Add the following to `/etc/exports`:

        /exports/data      *(rw)
        /exports/export    *(rw)

6. Export the storage domains:

        # exportfs -r

7. Reload the NFS service:

        # systemctl reload nfs-server.service

8. Create the group `kvm`:

        # groupadd kvm -g 36

9. Create the user `vdsm` in the group `kvm`:

        # useradd vdsm -u 36 -g 36

10. Set the ownership of your exported directories to 36:36, which gives vdsm:kvm ownership. This makes it possible for the Manager to store data in the storage domains represented by these exported directories:

        # chown -R 36:36 /exports/data
        # chown -R 36:36 /exports/export

11. Change the mode of the directories so that read and write access is granted to the owner, and so that read and execute access is granted to the group and other users:

        # chmod 0755 /exports/data
        # chmod 0755 /exports/export

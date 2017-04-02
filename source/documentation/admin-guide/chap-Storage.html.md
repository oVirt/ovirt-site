---
title: Storage
---

# Chapter 8: Storage

oVirt uses a centralized storage system for virtual machine disk images, ISO files and snapshots. Storage networking can be implemented using:

* Network File System (NFS)

* GlusterFS exports

* Other POSIX compliant file systems

* Internet Small Computer System Interface (iSCSI)

* Local storage attached directly to the virtualization hosts

* Fibre Channel Protocol (FCP)

* Parallel NFS (pNFS)

Setting up storage is a prerequisite for a new data center because a data center cannot be initialized unless storage domains are attached and activated.

As a oVirt system administrator, you need to create, configure, attach and maintain storage for the virtualized enterprise. You should be familiar with the storage types and their use. Read your storage array vendor's guides for more information on the concepts, protocols, requirements or general usage of storage.

oVirt enables you to assign and manage storage using the Administration Portal's **Storage** tab. The **Storage** results list displays all the storage domains, and the details pane shows general information about the domain.

To add storage domains you must be able to successfully access the Administration Portal, and there must be at least one host connected with a status of **Up**.

oVirt has three types of storage domains:

* **Data Domain:** A data domain holds the virtual hard disks and OVF files of all the virtual machines and templates in a data center. In addition, snapshots of the virtual machines are also stored in the data domain.

    The data domain cannot be shared across data centers. Data domains of multiple types (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, provided they are all shared, rather than local, domains.

    You must attach a data domain to a data center before you can attach domains of other types to it.

* **ISO Domain:** ISO domains store ISO files (or logical CDs) used to install and boot operating systems and applications for the virtual machines. An ISO domain removes the data center's need for physical media. An ISO domain can be shared across different data centers. ISO domains can only be NFS-based. Only one ISO domain can be added to a data center.

* **Export Domain:** Export domains are temporary storage repositories that are used to copy and move images between data centers and oVirt environments. Export domains can be used to backup virtual machines. An export domain can be moved between data centers, however, it can only be active in one data center at a time. Export domains can only be NFS-based. Only one export domain can be added to a data center.

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](sect-Importing_Existing_Storage_Domains) for information on importing storage domains.

**Important:** Only commence configuring and attaching storage for your oVirt environment once you have determined the storage needs of your data center(s).

## Understanding Storage Domains

A storage domain is a collection of images that have a common storage interface. A storage domain contains complete images of templates and virtual machines (including snapshots), or ISO files. A storage domain can be made of either block devices (SAN - iSCSI or FCP) or a file system (NAS - NFS, GlusterFS, or other POSIX compliant file systems).

On NFS, all virtual disks, templates, and snapshots are files.

On SAN (iSCSI/FCP), each virtual disk, template or snapshot is a logical volume. Block devices are aggregated into a logical entity called a volume group, and then divided by LVM (Logical Volume Manager) into logical volumes for use as virtual hard disks.

Virtual disks can have one of two formats, either QCOW2 or RAW. The type of storage can be either Sparse or Preallocated. Snapshots are always sparse but can be taken for disks created either as RAW or sparse.

Virtual machines that share the same storage domain can be migrated between hosts that belong to the same cluster.

## Preparing and Adding NFS Storage

### Preparing NFS Storage

Set up NFS shares that will serve as a data domain and an export domain on a Enterprise Linux 6 server. It is not necessary to create an ISO domain if one was created during the oVirt Engine installation procedure. For more information on the required system users and groups see [System Accounts](appe-System_Accounts).

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

10. Set the ownership of your exported directories to 36:36, which gives vdsm:kvm ownership. This makes it possible for the Engine to store data in the storage domains represented by these exported directories:

        # chown -R 36:36 /exports/data
        # chown -R 36:36 /exports/export

11. Change the mode of the directories so that read and write access is granted to the owner, and so that read and execute access is granted to the group and other users:

        # chmod 0755 /exports/data
        # chmod 0755 /exports/export

### Attaching NFS Storage

Attach an NFS storage domain to the data center in your oVirt environment. This storage domain provides storage for virtualized guest images and ISO boot media. This procedure assumes that you have already exported shares. You must create the data domain before creating the export domain. Use the same procedure to create the export domain, selecting **Export / NFS** in the **Domain Function / Storage Type** list.

1. In the oVirt Engine Administration Portal, click the **Storage** resource tab.

2. Click **New Domain**.

    **The New Domain Window**

    ![](/images/admin-guide/7294.png)

3. Enter a **Name** for the storage domain.

4. Accept the default values for the **Data Center**, **Domain Function**, **Storage Type**, **Format**, and **Use Host** lists.

5. Enter the **Export Path** to be used for the storage domain.

    The export path should be in the format of `192.168.0.10:/data` or `domain.example.com:/data`.

6. Optionally, you can configure the advanced parameters.

    1. Click **Advanced Parameters**.

    2. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    3. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    4. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

7. Click **OK**.

    The new NFS data domain is displayed in the **Storage** tab with a status of `Locked` until the disk is prepared. The data domain is then automatically attached to the data center.

### Increasing NFS Storage

To increase the amount of NFS storage, you can either create a new storage domain and add it to an existing data center, or increase the available free space on the NFS server. For the former option, see [Attaching NFS Storage](Attaching_NFS_Storage1). The following procedure explains how to increase the available free space on the existing NFS server.

**Increasing an Existing NFS Storage Domain**

1. Click the **Storage** resource tab and select an NFS storage domain.

2. In the details pane, click the **Data Center** tab and click the **Maintenance** button to place the storage domain into maintenance mode. This unmounts the existing share and makes it possible to resize the storage domain.

3. On the NFS server, resize the storage.

4. In the details pane, click the **Data Center** tab and click the **Activate** button to mount the storage domain.

## Preparing and Adding Local Storage

### Preparing Local Storage

A local storage domain can be set up on a host. When you set up a host to use local storage, the host automatically gets added to a new data center and cluster that no other hosts can be added to. Multiple host clusters require that all hosts have access to all storage domains, which is not possible with local storage. Virtual machines created in a single host cluster cannot be migrated, fenced or scheduled. For more information on the required system users and groups see [System Accounts](appe-System_Accounts).

**Important:** On oVirt Node, the path used for local storage must be within the /var directory; create the storage directory in the following procedure within `/var`.

**Preparing Local Storage**

1. On the host, create the directory to be used for the local storage.

        # mkdir -p /data/images

2. Ensure that the directory has permissions allowing read/write access to the `vdsm` user (UID 36) and `kvm` group (GID 36).

        # chown 36:36 /data /data/images
        # chmod 0755 /data /data/images

Your local storage is ready to be added to the oVirt environment.

**Note:** You can also mount external storage to a host machine for use as a local storage domain.

### Adding Local Storage

Storage local to your host has been prepared. Now use the Engine to add it to the host.

Adding local storage to a host in this manner causes the host to be put in a new data center and cluster. The local storage configuration window combines the creation of a data center, a cluster, and storage into a single process.

**Adding Local Storage**

1. Click the **Hosts** resource tab, and select a host in the results list.

2. Click **Maintenance** to open the **Maintenance Host(s)** confirmation window.

3. Click **OK** to initiate maintenance mode.

4. Click **Configure Local Storage** to open the **Configure Local Storage** window.

    **Configure Local Storage Window**

    ![](/images/admin-guide/5592.png)

5. Click the **Edit** buttons next to the **Data Center**, **Cluster**, and **Storage** fields to configure and name the local storage domain.

6. Set the path to your local storage in the text entry field.

7. If applicable, select the **Optimization** tab to configure the memory optimization policy for the new local storage cluster.

8. Click **OK** to save the settings and close the window.

Your host comes online in a data center of its own.

## Preparing and Adding POSIX Compliant File System Storage

POSIX file system support allows you to mount file systems using the same mount options that you would normally use when mounting them manually from the command line. This functionality is intended to allow access to storage not exposed using NFS, iSCSI, or FCP.

Any POSIX compliant filesystem used as a storage domain in oVirt **MUST** support sparse files and direct I/O. The Common Internet File System (CIFS), for example, does not support direct I/O, making it incompatible with oVirt.

**Important:** Do *not* mount NFS storage by creating a POSIX compliant file system Storage Domain. Always create an NFS Storage Domain instead.

### Attaching POSIX Compliant File System Storage

You want to use a POSIX compliant file system that is not exposed using NFS, iSCSI, or FCP as a storage domain.

**Attaching POSIX Compliant File System Storage**

1. Click the **Storage** resource tab to list the existing storage domains in the results list.

2. Click **New Domain** to open the **New Domain** window.

    **POSIX Storage**

    ![](/images/admin-guide/7295.png)

3. Enter the **Name** for the storage domain.

4. Select the **Data Center** to be associated with the storage domain. The Data Center selected must be of type **POSIX (POSIX compliant FS)**. Alternatively, select `(none)`.

5. Select `Data / POSIX compliant FS` from the **Domain Function / Storage Type** drop-down menu.

    If applicable, select the **Format** from the drop-down menu.

6. Select a host from the **Use Host** drop-down menu. Only hosts within the selected data center will be listed. The host that you select will be used to connect the storage domain.

7. Enter the **Path** to the POSIX file system, as you would normally provide it to the `mount` command.

8. Enter the **VFS Type**, as you would normally provide it to the `mount` command using the `-t` argument. See `man mount` for a list of valid VFS types.

9. Enter additional **Mount Options**, as you would normally provide them to the `mount` command using the `-o` argument. The mount options should be provided in a comma-separated list. See `man mount` for a list of valid mount options.

10. Optionally, you can configure the advanced parameters.

    1. Click **Advanced Parameters**.

    2. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    3. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    4. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

11. Click **OK** to attach the new Storage Domain and close the window.

## Preparing and Adding Block Storage

### Preparing iSCSI Storage

Use the following steps to export an iSCSI storage device from a server running Enterprise Linux 6 to use as a storage domain with oVirt.

**Preparing iSCSI Storage**

1. Install the `scsi-target-utils` package using the `yum` command as root on your storage server.

        # yum install -y scsi-target-utils

2. Add the devices or files you want to export to the `/etc/tgt/targets.conf` file. Here is a generic example of a basic addition to the `targets.conf` file:

        <target iqn.YEAR-MONTH.com.EXAMPLE:SERVER.targetX>
                  backing-store /PATH/TO/DEVICE1 # Becomes LUN 1
                  backing-store /PATH/TO/DEVICE2 # Becomes LUN 2
                  backing-store /PATH/TO/DEVICE3 # Becomes LUN 3
        </target>

    Targets are conventionally defined using the year and month they are created, the reversed fully qualified domain that the server is in, the server name, and a target number.

3. Start the `tgtd` service.

        # systemctl start tgtd.service

4. Make the `tgtd` start persistently across reboots.

        # systemctl enable tgtd.service

5. Open an iptables firewall port to allow clients to access your iSCSI export. By default, iSCSI uses port 3260. This example inserts a firewall rule at position 6 in the INPUT table.

        # iptables -I INPUT 6 -p tcp --dport 3260 -j ACCEPT

6. Save the iptables rule you just created.

        # service iptables save

You have created a basic iSCSI export. You can use it as an iSCSI data domain.

### Adding iSCSI Storage

oVirt platform supports iSCSI storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

**Adding iSCSI Storage**

1. Click the **Storage** resource tab to list the existing storage domains in the results list.

2. Click the **New Domain** button to open the **New Domain** window.

3. Enter the **Name** of the new storage domain.

    **New iSCSI Domain**

    ![](/images/admin-guide/7296.png)

4. Use the **Data Center** drop-down menu to select an data center.

5. Use the drop-down menus to select the **Domain Function** and the **Storage Type**. The storage domain types that are not compatible with the chosen domain function are not available.

6. Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.

    **Important:** All communication to the storage domain is through the selected host and not directly from the oVirt Engine. At least one active host must exist in the system and be attached to the chosen data center. All hosts must have access to the storage device before the storage domain can be configured.

7. The oVirt Engine is able to map either iSCSI targets to LUNs, or LUNs to iSCSI targets. The **New Domain** window automatically displays known targets with unused LUNs when iSCSI is selected as the storage type. If the target that you are adding storage from is not listed then you can use target discovery to find it, otherwise proceed to the next step.

    **iSCSI Target Discovery**

    1. Click **Discover Targets** to enable target discovery options. When targets have been discovered and logged in to, the **New Domain** window automatically displays targets with LUNs unused by the environment.

        **Note:** LUNs used externally to the environment are also displayed.

        You can use the **Discover Targets** options to add LUNs on many targets, or multiple paths to the same LUNs.

    2. Enter the fully qualified domain name or IP address of the iSCSI host in the **Address** field.

    3. Enter the port to connect to the host on when browsing for targets in the **Port** field. The default is `3260`.

    4. If the Challenge Handshake Authentication Protocol (CHAP) is being used to secure the storage, select the **User Authentication** check box. Enter the **CHAP user name** and **CHAP password**.

        **Note:** It is now possible to use the REST API to define specific credentials to each iSCSI target per host.

    5. Click the **Discover** button.

    6. Select the target to use from the discovery results and click the **Login** button.

        Alternatively, click the **Login All** to log in to all of the discovered targets.

        **Important:** If more than one path access is required, ensure to discover and log in to the target through all the required paths. Modifying a storage domain to add additional paths is currently not supported.

8. Click the **+** button next to the desired target. This will expand the entry and display all unused LUNs attached to the target.

9. Select the check box for each LUN that you are using to create the storage domain.

10. Optionally, you can configure the advanced parameters.

    1. Click **Advanced Parameters**.

    2. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    3. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    4. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

11. Click **OK** to create the storage domain and close the window.

If you have configured multiple storage connection paths to the same target, follow the procedure in the next section, "Configuring iSCSI Multipathing," to complete iSCSI bonding.

### Configuring iSCSI Multipathing

The **iSCSI Multipathing** enables you to create and manage groups of logical networks and iSCSI storage connections. To prevent host downtime due to network path failure, configure multiple network paths between hosts and iSCSI storage. Once configured, the Engine connects each host in the data center to each bonded target via NICs/VLANs related to logical networks of the same iSCSI Bond. You can also specify which networks to use for storage traffic, instead of allowing hosts to route traffic through a default network. This option is only available in the Administration Portal after at least one iSCSI storage domain has been attached to a data center.  

**Prerequisites**

* Ensure you have created an iSCSI storage domain and discovered and logged into all the paths to the iSCSI target(s).

* Ensure you have created **Non-Required** logical networks to bond with the iSCSI storage connections. You can configure multiple logical networks or bond networks to allow network failover.

**Configuring iSCSI Multipathing**

1. Click the **Data Centers** tab and select a data center from the results list.

2. In the details pane, click the **iSCSI Multipathing** tab.

3. Click **Add**.

4. In the **Add iSCSI Bond** window, enter a **Name** and a **Description** for the bond.

5. Select the networks to be used for the bond from the **Logical Networks** list. The networks must be **Non-Required** networks.

    **Note:** To change a network's **Required** designation, from the Administration Portal, select a network, click the **Cluster** tab, and click the **Manage Networks** button.

6. Select the storage domain to be accessed via the chosen networks from the **Storage Targets** list. Ensure to select all paths to the same target.

7. Click **OK**.

All hosts in the data center are connected to the selected iSCSI target through the selected logical networks.

### Adding FCP Storage

oVirt platform supports SAN storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

oVirt system administrators need a working knowledge of Storage Area Networks (SAN) concepts. SAN usually uses Fibre Channel Protocol (FCP) for traffic between hosts and shared external storage. For this reason, SAN may occasionally be referred to as FCP storage.

The following procedure shows you how to attach existing FCP storage to your oVirt environment as a data domain. For more information on other supported storage types, see [Storage](chap-Storage).

**Adding FCP Storage**

1. Click the **Storage** resource tab to list all storage domains.

2. Click **New Domain** to open the **New Domain** window.

3. Enter the **Name** of the storage domain.

    **Adding FCP Storage**

    ![](/images/admin-guide/7297.png)

4. Use the **Data Center** drop-down menu to select an FCP data center.

    If you do not yet have an appropriate FCP data center, select `(none)`.

5. Use the drop-down menus to select the **Domain Function** and the **Storage Type**. The storage domain types that are not compatible with the chosen data center are not available.

6. Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.

    **Important:** All communication to the storage domain is through the selected host and not directly from the oVirt Engine. At least one active host must exist in the system and be attached to the chosen data center. All hosts must have access to the storage device before the storage domain can be configured.

7. The **New Domain** window automatically displays known targets with unused LUNs when **Data / Fibre Channel** is selected as the storage type. Select the **LUN ID** check box to select all of the available LUNs.

8. Optionally, you can configure the advanced parameters.

    1. Click **Advanced Parameters**.

    2. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    3. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    4. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

9.  Click **OK** to create the storage domain and close the window.

The new FCP data domain displays on the **Storage** tab. It will remain with a `Locked` status while it is being prepared for use. When ready, it is automatically attached to the data center.

### Increasing iSCSI or FCP Storage

There are multiple ways to increase iSCSI or FCP storage size:

* Create a new storage domain with new LUNs and add it to an existing datacenter. See [Adding iSCSI Storage](Adding_iSCSI_Storage1).

* Create new LUNs and add them to an existing storage domain.

* Expand the storage domain by resizing the underlying LUNs.

The following procedure explains how to expand storage area network (SAN) storage by adding a new LUN to an existing storage domain.

**Increasing an Existing iSCSI or FCP Storage Domain**

1. Create a new LUN on the SAN.

2. Click the **Storage** resource tab and select an iSCSI or FCP domain.

3. Click the **Edit** button.

4. Click on **Targets > LUNs**, and click the **Discover Targets** expansion button.

5. Enter the connection information for the storage server and click the **Discover** button to initiate the connection.

6. Click on **LUNs > Targets** and select the check box of the newly available LUN.

7. Click **OK** to add the LUN to the selected storage domain.

This will increase the storage domain by the size of the added LUN.

When expanding the storage domain by resizing the underlying LUNs, the LUNs must also be refreshed in the oVirt Administration Portal.

**Refreshing the LUN Size**

1. Click the **Storage** resource tab and select an iSCSI or FCP domain.

2. Click the **Edit** button.

3. Click on **LUNs > Targets**.

4. In the **Additional Size** column, click the **Add Additional_Storage_Size** button of the LUN to refresh.

5. Click **OK** to refresh the LUN to indicate the new storage size.

### Unusable LUNs in oVirt

In certain circumstances, the oVirt Engine will not allow you to use a LUN to create a storage domain or virtual machine hard disk.

* LUNs that are already part of the current oVirt environment are automatically prevented from being used.

    **Unusable LUNs in the oVirt Administration Portal**

    ![](/images/admin-guide/1200.png)

* LUNs that are already being used by the SPM host will also display as in use. You can choose to forcefully over ride the contents of these LUNs, but the operation is not guaranteed to succeed.

## Importing Existing Storage Domains

### Overview of Importing Existing Storage Domains

In addition to adding new storage domains that contain no data, you can also import existing storage domains and access the data they contain. The ability to import storage domains allows you to recover data in the event of a failure in the Engine database, and to migrate data from one data center or environment to another.

The following is an overview of importing each storage domain type:

Data
: Importing an existing data storage domain allows you to access all of the virtual machines and templates that the data storage domain contains. After you import the storage domain, you must manually import virtual machines, floating disk images, and templates into the destination data center. The process for importing the virtual machines and templates that a data storage domain contains is similar to that for an export storage domain. However, because data storage domains contain all the virtual machines and templates in a given data center, importing data storage domains is recommended for data recovery or large-scale migration of virtual machines between data centers or environments.

    **Important:** You can import existing data storage domains that were attached to data centers with a compatibility level of 3.5 or higher.

ISO
: Importing an existing ISO storage domain allows you to access all of the ISO files and virtual diskettes that the ISO storage domain contains. No additional action is required after importing the storage domain to access these resources; you can attach them to virtual machines as required.

Export
:  Importing an existing export storage domain allows you to access all of the virtual machine images and templates that the export storage domain contains. Because export domains are designed for exporting and importing virtual machine images and templates, importing export storage domains is recommended method of migrating small numbers of virtual machines and templates inside an environment or between environments. For information on exporting and importing virtual machines and templates to and from export storage domains, see "Exporting and Importing Virtual Machines and Templates" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center.

### Importing Storage Domains

Import a storage domain that was previously attached to a data center in the same environment or in a different environment. This procedure assumes the storage domain is no longer attached to any data center in any environment, to avoid data corruption. To import and attach an existing data storage domain to a data center, the target data center must be initialized.

**Importing a Storage Domain**

1. Click the **Storage** resource tab.

2. Click **Import Domain**.

    **The Import Pre-Configured Domain window**

    ![](/images/admin-guide/ImportDomain.png)

3. Select the data center to which to attach the storage domain from the **Data Center** drop-down list.

4. Enter a name for the storage domain.

5. Select the **Domain Function** and **Storage Type** from the appropriate drop-down lists.

6. Select a host from the **Use host** drop-down list.

    **Important:** All communication to the storage domain is through the selected host and not directly from the oVirt Engine. At least one active host must exist in the system and be attached to the chosen data center. All hosts must have access to the storage device before the storage domain can be configured.

7. Enter the details of the storage domain.

    **Note:** The fields for specifying the details of the storage domain change in accordance with the value you select in the **Domain Function / Storage Type** list. These options are the same as those available for adding a new storage domain. For more information on these options, see [Storage properties](Storage_properties).

8. Select the **Activate Domain in Data Center** check box to activate the storage domain after attaching it to the selected data center.

9. Click **OK**.

The storage domain is imported, and is displayed in the **Storage** tab. You can now import virtual machines and templates from the storage domain to the data center.

### Migrating Storage Domains between Data Centers in the Same Environment

Migrate a storage domain from one data center to another in the same oVirt environment to allow the destination data center to access the data contained in the storage domain. This procedure involves detaching the storage domain from one data center, and attaching it to a different data center.

**Migrating a Storage Domain between Data Centers in the Same Environment**

1. Shut down all virtual machines running on the required storage domain.

2. Click the **Storage** resource tab and select the storage domain from the results list.

3. Click the **Data Center** tab in the details pane.

4. Click **Maintenance**, then click **OK** to move the storage domain to maintenance mode.

5. Click **Detach**, then click **OK** to detach the storage domain from the source data center.

6. Click **Attach**.

7. Select the destination data center and click **OK**.

The storage domain is attached to the destination data center and is automatically activated. You can now import virtual machines and templates from the storage domain to the destination data center.

### Migrating Storage Domains between Data Centers in Different Environments

Migrate a storage domain from one oVirt environment to another to allow the destination environment to access the data contained in the storage domain. This procedure involves removing the storage domain from one oVirt environment, and importing it into a different environment. To import and attach an existing data storage domain to a oVirt data center, the storage domain's source data center must have a compatibility level of 3.5 or higher.

**Migrating a Storage Domain between Data Centers in Different Environments**

1. Log in to the Administration Portal of the source environment.

2. Shut down all virtual machines running on the required storage domain.

3. Click the **Storage** resource tab and select the storage domain from the results list.

4. Click the **Data Center** tab in the details pane.

5. Click **Maintenance**, then click **OK** to move the storage domain to maintenance mode.

6. Click **Detach**, then click **OK** to detach the storage domain from the source data center.

7. Click **Remove**.

8. In the **Remove Storage(s)** window, ensure the **Format Domain, i.e. Storage Content will be lost!** check box is not selected. This step preserves the data in the storage domain for later use.

9. Click **OK** to remove the storage domain from the source environment.

10. Log in to the Administration Portal of the destination environment.

11. Click the **Storage** resource tab.

12. Click **Import Domain**.

    **The Import Pre-Configured Domain window**

    ![](/images/admin-guide/ImportDomain.png)

13. Select the destination data center from the **Data Center** drop-down list.

14. Enter a name for the storage domain.

15. Select the **Domain Function** and **Storage Type** from the appropriate drop-down lists.

16. Select a host from the **Use Host** drop-down list.

17. Enter the details of the storage domain.

    **Note:** The fields for specifying the details of the storage domain change in accordance with the value you select in the **Storage Type** drop-down list. These options are the same as those available for adding a new storage domain. For more information on these options, see [Storage properties](Storage_properties).

18. Select the **Activate Domain in Data Center** check box to automatically activate the storage domain when it is attached.

19. Click **OK**.

The storage domain is attached to the destination data center in the new oVirt environment and is automatically activated. You can now import virtual machines and templates from the imported storage domain to the destination data center.

### Importing Virtual Machines from Imported Data Storage Domains

Import a virtual machine from a data storage domain you have imported into your oVirt environment. This procedure assumes that the imported data storage domain has been attached to a data center and has been activated.

**Importing Virtual Machines from an Imported Data Storage Domain**

1. Click the **Storage** resource tab.

2. Click the imported data storage domain.

3. Click the **VM Import** tab in the details pane.

4. Select one or more virtual machines to import.

5. Click **Import**.

6. Select the cluster into which the virtual machines are imported from the **Cluster** list.

7. Click **OK**.

You have imported one or more virtual machines into your environment. The imported virtual machines no longer appear in the list under the **VM Import** tab.

### Importing a Disk Image from an Imported Storage Domain

Import floating virtual disks from an imported storage domain using the **Disk Import** tab of the details pane.

**Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Select a storage domain that has been imported into the data center.

2. In the details pane, click **Disk Import**.

3. Select one or more disk images and click **Import** to open the **Import Disk(s)** window.

4. Select the appropriate **Disk Profile** for each disk.

5. Click **OK** to import the selected disks.

### Importing an Unregistered Disk Image from an Imported Storage Domain

Import floating virtual disks from a storage domain using the **Disk Import** tab of the details pane. Floating disks created outside of a oVirt environment are not registered with the Engine. Scan the storage domain to identify unregistered floating disks to be imported.

**Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Select a storage domain that has been imported into the data center.

2. Right-click the storage domain and select **Scan Disks** so that the Engine can identify unregistered disks.

3. In the details pane, click **Disk Import**.

4. Select one or more disk images and click **Import** to open the **Import Disk(s)** window.

5. Select the appropriate **Disk Profile** for each disk.

6. Click **OK** to import the selected disks.

## Storage Tasks

### Populating the ISO Storage Domain

An ISO storage domain is attached to a data center. ISO images must be uploaded to it. oVirt provides an ISO uploader tool that ensures that the images are uploaded into the correct directory path, with the correct user permissions.

The creation of ISO images from physical media is not described in this document. It is assumed that you have access to the images required for your environment.

**Populating the ISO Storage Domain**

1. Copy the required ISO image to a temporary directory on the system running oVirt Engine.

2. Log in to the system running oVirt Engine as the `root` user.

3. Use the `engine-iso-uploader` command to upload the ISO image. This action will take some time. The amount of time varies depending on the size of the image being uploaded and available network bandwidth.

    **ISO Uploader Usage**

    In this example the ISO image `RHEL6.iso` is uploaded to the ISO domain called `ISODomain` using NFS. The command will prompt for an administrative user name and password. The user name must be provided in the form `user name@domain`.

        # engine-iso-uploader --iso-domain=ISODomain upload RHEL6.iso

The ISO image is uploaded and appears in the ISO storage domain specified. It is also available in the list of available boot media when creating virtual machines in the data center to which the storage domain is attached.

### Moving Storage Domains to Maintenance Mode

Detaching and removing storage domains requires that they be in maintenance mode. This is required to redesignate another data domain as the master data domain.

Expanding iSCSI domains by adding more LUNs can only be done when the domain is active.

**Moving storage domains to maintenance mode**

1. Shut down all the virtual machines running on the storage domain.

2. Click the **Storage** resource tab and select a storage domain.

3. Click the **Data Centers** tab in the details pane.

4. Click **Maintenance** to open the **Storage Domain maintenance** confirmation window.

5. Click **OK** to initiate maintenance mode. The storage domain is deactivated and has an `Inactive` status in the results list.

You can now edit, detach, remove, or reactivate the inactive storage domains from the data center.

**Note:** You can also activate, detach and place domains into maintenance mode using the Storage tab on the details pane of the data center it is associated with.

### Editing Storage Domains

You can edit storage domain parameters through the Administration Portal. Depending on the state of the storage domain, either active or inactive, different fields are available for editing. Fields such as **Data Center**, **Domain Function**, **Storage Type**, and **Format** cannot be changed.

* **Active**: When the storage domain is in an active state, the **Name**, **Description**, **Comment**, **Warning Low Space Indicator (%)**, **Critical Space Action Blocker (GB)**, and **Wipe After Delete** fields can be edited. The **Name** field can only be edited while the storage domain is active. All other fields can also be edited while the storage domain is inactive.

* **Inactive**: When the storage domain is in maintenance mode or unattached, thus in an inactive state, you can edit all fields except **Name**, **Data Center**, **Domain Function**, **Storage Type**, and **Format**. The storage domain must be inactive to edit storage connections, mount options, and other advanced parameters. This is only supported for NFS, POSIX, and Local storage types.

    **Note:** iSCSI storage connections cannot be edited via the Administration Portal, but can be edited via the REST API.

**Editing an Active Storage Domain**

1. Click the **Storage** tab and select a storage domain.

2. Click **Edit**.

3. Edit the available fields as required.

4. Click **OK**.

**Editing an Inactive Storage Domain**

1. Click the **Storage** tab and select a storage domain.

2. If the storage domain is active, click the **Data Center** tab in the details pane and click **Maintenance**.

3. Click **Edit**.

4. Edit the storage path and other details as required. The new connection details must be of the same storage type as the original connection.

5. Click **OK**.

6. Click the **Data Center** tab in the details pane and click **Activate**.

### Activating Storage Domains from Maintenance Mode

If you have been making changes to a data center's storage, you have to put storage domains into maintenance mode. Activate a storage domain to resume using it.

1. Click the **Storage** resource tab and select an inactive storage domain in the results list.

2. Click the **Data Centers** tab in the details pane.

3. Select the appropriate storage domain and click **Activate**.

    **Important:** If you attempt to activate the ISO domain before activating the data domain, an error message displays and the domain is not activated.

## Removing a Storage Domain

You have a storage domain in your data center that you want to remove from the virtualized environment.

**Removing a Storage Domain**

1. Click the **Storage** resource tab and select the appropriate storage domain in the results list.

2. Move the domain into maintenance mode to deactivate it.

3. Detach the domain from the data center.

4. Click **Remove** to open the **Remove Storage** confirmation window.

5. Select a host from the list.

6. Click **OK** to remove the storage domain and close the window.

The storage domain is permanently removed from the environment.

### Destroying a Storage Domain

A storage domain encountering errors may not be able to be removed through the normal procedure. Destroying a storage domain will forcibly remove the storage domain from the virtualized environment without reference to the export directory.

When the storage domain is destroyed, you are required to manually fix the export directory of the storage domain before it can be used again.

**Destroying a Storage Domain**

1. Use the **Storage** resource tab, tree mode, or the search function to find and select the appropriate storage domain in the results list.

2. Right-click the storage domain and select **Destroy** to open the **Destroy Storage Domain** confirmation window.

3. Select the **Approve operation** check box and click **OK** to destroy the storage domain and close the window.

The storage domain has been destroyed. Manually clean the export directory for the storage domain to recycle it.

### Detaching a Storage Domain from a Data Center

Detach a storage domain from the data center to migrate virtual machines and templates to another data center.

**Detaching a Storage Domain from the Data Center**

1. Click the **Storage** resource tab, and select a storage domain from the results list.

2. Click the **Data Centers** tab in the details pane and select the storage domain.

3. Click **Maintenance** to open the **Maintenance Storage Domain(s)** confirmation window.

4. Click **OK** to initiate maintenance mode.

5. Click **Detach** to open the **Detach Storage** confirmation window.

6. Click **OK** to detach the storage domain.

The storage domain has been detached from the data center, ready to be attached to another data center.

### Attaching a Storage Domain to a Data Center

Attach a storage domain to a data center.

**Attaching a Storage Domain to a Data Center**

1. Click the **Storage** resource tab, and select a storage domain from the results list.

2. Click the **Data Centers** tab in the details pane.

3. Click **Attach** to open the **Attach to Data Center** window.

4. Select the radio button of the appropriate data center.

5. Click **OK** to attach the storage domain.

The storage domain is attached to the data center and is automatically activated.

### Disk Profiles

Disk profiles define the maximum level of throughput and the maximum level of input and output operations for a virtual disk in a storage domain. Disk profiles are created based on storage profiles defined under data centers, and must be manually assigned to individual virtual disks for the profile to take effect.

#### Creating a Disk Profile

Create a disk profile. This procedure assumes you have already defined one or more storage quality of service entries under the data center to which the storage domain belongs.

**Creating a Disk Profile**

1. Click the **Storage** resource tab and select a data storage domain.

2. Click the **Disk Profiles** sub tab in the details pane.

3. Click **New**.

4. Enter a name for the disk profile in the **Name** field.

5. Enter a description for the disk profile in the **Description** field.

6. Select the quality of service to apply to the disk profile from the **QoS** list.

7. Click **OK**.

You have created a disk profile, and that disk profile can be applied to new virtual disks hosted in the data storage domain.

#### Removing a Disk Profile

Remove an existing disk profile from your oVirt environment.

**Removing a Disk Profile**

1. Click the **Storage** resource tab and select a data storage domain.

2. Click the **Disk Profiles** sub tab in the details pane.

3. Select the disk profile to remove.

4. Click **Remove**.

5. Click **OK**.

You have removed a disk profile, and that disk profile is no longer available. If the disk profile was assigned to any virtual disks, the disk profile is removed from those virtual disks.

### Viewing the Health Status of a Storage Domain

Storage domains have an external health status in addition to their regular **Status**. The external health status is reported by plug-ins or external systems, or set by an administrator, and appears to the left of the storage domain's **Name** as one of the following icons:

* **OK**: No icon

* **Info**: ![](/images/admin-guide/Info.png)

* **Warning**: ![](/images/admin-guide/Warning.png)

* **Error**: ![](/images/admin-guide/Error.png)

* **Failure**: ![](/images/admin-guide/Failure.png)

To view further details about the storage domain's health status, select the storage domain and click the **Events** sub-tab.

The storage domain's health status can also be viewed using the REST API. A `GET` request on a storage domain will include the `external_status` element, which contains the health status.

You can set a storage domain's health status in the REST API via the `events` collection.

## Storage and Permissions

### Managing System Permissions for a Storage Domain

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A storage administrator is a system administration role for a specific storage domain only. This is useful in data centers with multiple storage domains, where each storage domain requires a system administrator. Use the **Configure** button in the header bar to assign a storage administrator for all storage domains in the environment.

The storage domain administrator role permits the following actions:

* Edit the configuration of the storage domain.

* Move the storage domain into maintenance mode.

* Remove the storage domain.

**Note:** You can only assign roles and permissions to existing users.

You can also change the system administrator of a storage domain by removing the existing system administrator and adding the new system administrator.

### Storage Administrator Roles Explained

**Storage Domain Permission Roles**

The table below describes the administrator roles and privileges applicable to storage domain administration.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| StorageAdmin | Storage Administrator | Can create, delete, configure and manage a specific storage domain. |
| GlusterAdmin | Gluster Storage Administrator | Can create, delete, configure and manage Gluster storage volumes. |

### Assigning an Administrator or User Role to a Resource

Assign administrator or user roles to resources to allow users to access or manage that resource.

**Assigning a Role to a Resource**

1. Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.

2. Click the **Permissions** tab in the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.

3. Click **Add**.

4. Enter the name or user name of an existing user into the **Search** text box and click **Go**. Select a user from the resulting list of possible matches.

5. Select a role from the **Role to Assign:** drop-down list.

6. Click **OK**.

You have assigned a role to a user; the user now has the inherited permissions of that role enabled for that resource.

### Removing an Administrator or User Role from a Resource

Remove an administrator or user role from a resource; the user loses the inherited permissions associated with the role for that resource.

**Removing a Role from a Resource**

1. Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.

2. Click the **Permissions** tab in the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.

3. Select the user to remove from the resource.

4. Click **Remove**. The **Remove Permission** window opens to confirm permissions removal.

5. Click **OK**.

You have removed the user's role, and the associated permissions, from the resource.

**Prev:** [Chapter 7: Hosts](../chap-Hosts)<br>
**Next:** [Chapter 9: Working with Gluster Storage](../chap-Working_with_Gluster_Storage)

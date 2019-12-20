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

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](#importing-existing-storage-domains) for information on importing storage domains.
    {: .alert .alert-info}


    **Important:** Only commence configuring and attaching storage for your oVirt environment once you have determined the storage needs of your data center(s).
    {: .alert .alert-info}

## Understanding Storage Domains

A storage domain is a collection of images that have a common storage interface. A storage domain contains complete images of templates and virtual machines (including snapshots), or ISO files. A storage domain can be made of either block devices (SAN - iSCSI or FCP) or a file system (NAS - NFS, GlusterFS, or other POSIX compliant file systems).

On NFS, all virtual disks, templates, and snapshots are files.

On SAN (iSCSI/FCP), each virtual disk, template or snapshot is a logical volume. Block devices are aggregated into a logical entity called a volume group, and then divided by LVM (Logical Volume Manager) into logical volumes for use as virtual hard disks.

Virtual disks can have one of two formats, either QCOW2 or RAW. The type of storage can be either Sparse or Preallocated. Snapshots are always sparse but can be taken for disks created either as RAW or sparse.

Virtual machines that share the same storage domain can be migrated between hosts that belong to the same cluster.

## Preparing and Adding NFS Storage

### Preparing NFS Storage

Set up NFS shares that will serve as storage domains on an Enterprise Linux server.

   **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disks, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](#importing-existing-storage-domains) for information on importing storage domains.
   {: .alert .alert-info}


Specific system user accounts and system user groups are required by oVirt so the Engine can store data in the storage domains represented by the exported directories.

**Configuring the Required System User Accounts and System User Groups**

1. Create the group `kvm`:

        # groupadd kvm -g 36

2. Create the user `vdsm` in the group `kvm`:

        # useradd vdsm -u 36 -g 36

3. Set the ownership of your exported directories to 36:36, which gives vdsm:kvm ownership:

        # chown -R 36:36 /exports/data
        # chown -R 36:36 /exports/export
        # chown -R 36:36 /exports/iso

4. Change the mode of the directories so that read and write access is granted to the owner, and so that read and execute access is granted to the group and other users:

        # chmod 0755 /exports/data
        # chmod 0755 /exports/export
        # chmod 0755 /exports/iso

For more information on the required system users and groups see "[Appendix F, System Accounts](appe-System_Accounts)".

### Attaching NFS Storage

Attach an NFS storage domain to the data center in your oVirt environment. These storage domains provide storage for virtual disks (data domain) and ISO boot media (ISO domain). This procedure assumes that you have already exported shares. You must create the data domain before creating the ISO and export domains. Use the same procedure to create the ISO and export domains, selecting **ISO** or **Export** from the **Domain Function** list.

1. In the Administration Portal, click **Storage** &rarr; **Domains**.

2. Click **New Domain**.

3. Enter a **Name** for the storage domain.

4. Accept the default values for the **Data Center**, **Domain Function**, **Storage Type**, **Format**, and **Use Host** lists.

5. Enter the **Export Path** to be used for the storage domain. The export path should be in the format of  `123.123.0.10:/data` (for IPv4), `[2001:0:0:0:0:0:0:5db1]:/data` (for IPv6), or `domain.example.com:/data`.

6. Optionally, you can configure the advanced parameters.

    i. Click **Advanced Parameters**.

    ii. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    iii. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    iv. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

7. Click **OK**.

The new NFS data domain is displayed in the **Storage** tab with a status of `Locked` until the disk is prepared. The data domain is then automatically attached to the data center.

### Increasing NFS Storage

To increase the amount of NFS storage, you can either create a new storage domain and add it to an existing data center, or increase the available free space on the NFS server. For the former option, see [Attaching NFS Storage](#attaching-nfs-storage). The following procedure explains how to increase the available free space on the existing NFS server.

**Increasing an Existing NFS Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. Click the NFS storage domain’s name to open the details view.

3. Click the **Data Center** tab and click the **Maintenance** to place the storage domain into maintenance mode. This unmounts the existing share and makes it possible to resize the storage domain.

4. On the NFS server, resize the storage.

5. In the details pane, click the **Data Center** tab and click **Activate** to mount the storage domain.

## Preparing and Adding Local Storage

### Preparing Local Storage

A local storage domain can be set up on a host. When you set up a host to use local storage, the host automatically gets added to a new data center and cluster that no other hosts can be added to. Multiple host clusters require that all hosts have access to all storage domains, which is not possible with local storage. Virtual machines created in a single host cluster cannot be migrated, fenced or scheduled. For more information on the required system users and groups see [Appendix F: System Accounts](appe-System_Accounts).


   **Important:** On oVirt Node, the path used for local storage must be within the /var directory; create the storage directory in the following procedure within `/var`.
   {: .alert .alert-info}

**Preparing Local Storage for Enterprise Linux Hosts**

1. On the host, create the directory to be used for the local storage.

        # mkdir -p /data/images

2. Ensure that the directory has permissions allowing read/write access to the `vdsm` user (UID 36) and `kvm` group (GID 36).

        # chown 36:36 /data /data/images
        # chmod 0755 /data /data/images

Your local storage is ready to be added to the oVirt environment.

**Preparing Local Storage for oVirt Nodes**

The oVirt Project recommends creating the local storage on a logical volume as follows:

        # mkdir /data
        # lvcreate -L $SIZE rhvh -n data
        # mkfs.ext4 /dev/mapper/rhvh-data
        # echo "/dev/mapper/rhvh-data /data ext4 defaults,discard 1 2" >> /etc/fstab

Your local storage is ready to be added to the oVirt environment.

### Adding Local Storage

Adding local storage to a host in this manner causes the host to be put in a new data center and cluster. The local storage configuration window combines the creation of a data center, a cluster, and storage into a single process.

**Adding Local Storage**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **Management** &rarr; **Maintenance** and click **OK**.

3. Click **Management** &rarr; **Configure Local Storage**.

4. Click the **Edit** buttons next to the **Data Center**, **Cluster**, and **Storage** fields to configure and name the local storage domain.

5. Set the path to your local storage in the text entry field.

6. If applicable, select the **Optimization** tab to configure the memory optimization policy for the new local storage cluster.

7. Click **OK**.

Your host comes online in a data center of its own.

## Adding POSIX Compliant File System Storage

### Attaching POSIX Compliant File System Storage

POSIX file system support allows you to mount file systems using the same mount options that you would normally use when mounting them manually from the command line. This functionality is intended to allow access to storage not exposed using NFS, iSCSI, or FCP.

Any POSIX compliant file system used as a storage domain in oVirt must be a clustered file system, such as Global File System 2 (GFS2), and must support sparse files and direct I/O. The Common Internet File System (CIFS), for example, does not support direct I/O, making it incompatible with oVirt.

   **Important:** Do **not** mount NFS storage by creating a POSIX compliant file system Storage Domain. Always create an NFS Storage Domain instead.
   {: .alert .alert-info}


**Attaching POSIX Compliant File System Storage**

1. Click **Storage** &rarr; **Domains**.

2. Click **New Domain**.

3. Enter the **Name** for the storage domain.

4. Select the **Data Center** to be associated with the storage domain. The Data Center selected must be of type **POSIX (POSIX compliant FS)**. Alternatively, select `(none)`.

5. Select `Data` from the **Domain Function** drop-down list, and `POSIX compliant FS` from the **Storage Type** drop-down list.

    If applicable, select **Format** from the drop-down menu.

6. Select a host from the **Use Host** drop-down list.

7. Enter the **Path** to the POSIX file system, as you would normally provide it to the `mount` command.

8. Enter the **VFS Type**, as you would normally provide it to the `mount` command using the `-t` argument. See `man mount` for a list of valid VFS types.

9. Enter additional **Mount Options**, as you would normally provide them to the `mount` command using the `-o` argument. The mount options should be provided in a comma-separated list. See `man mount` for a list of valid mount options.

10. Optionally, you can configure the advanced parameters.

    i. Click **Advanced Parameters**.

    ii. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    iii. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    iv. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

11. Click **OK**.

## Adding Block Storage

**Important:** If you are using block storage and you intend to deploy virtual machines on raw devices or direct LUNs and to manage them with the Logical Volume Manager, you must create a filter to hide the guest logical volumes.
This will prevent guest logical volumes from being activated when the host is booted, a situation that could lead to stale logical volumes and cause data corruption.
{: .alert .alert-info}


**Note:** oVirt currently does not support storage with a block size of 4K. You must configure block storage in legacy (512b block) mode.
{: .alert .alert-info}

### Adding iSCSI Storage

oVirt supports iSCSI storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

**Adding iSCSI Storage**

1. Click **Storage** &rarr; **Domains**.

2. Click **New Domain**.

3. Enter the **Name** for the storage domain.

4. Select a **Data Center** from the drop-down list.

5. Select the **Domain Function** and the **Storage Type** from the drop-down lists. The storage domain types that are not compatible with the chosen domain function are not available.

6. Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.

   **Important:** All communication to the storage domain is through the selected host and not directly from the oVirt Engine. At least one active host must exist in the system and be attached to the chosen data center. All hosts must have access to the storage device before the storage domain can be configured.
   {: .alert .alert-info}


7. The oVirt Engine can map either iSCSI targets to LUNs, or LUNs to iSCSI targets. The **New Domain** window automatically displays known targets with unused LUNs when iSCSI is selected as the storage type. If the target that you are adding storage from is not listed then you can use target discovery to find it, otherwise proceed to the next step.

    i. Click **Discover Targets** to enable target discovery options. When targets have been discovered and logged in to, the **New Domain** window automatically displays targets with LUNs unused by the environment.

    **Note:** LUNs used externally to the environment are also displayed.
    {: .alert .alert-info}

    You can use the **Discover Targets** options to add LUNs on many targets, or multiple paths to the same LUNs.

    ii. Enter the fully qualified domain name or IP address of the iSCSI host in the **Address** field.

    iii. Enter the port to connect to the host on when browsing for targets in the **Port** field. The default is `3260`.

    iv. If the Challenge Handshake Authentication Protocol (CHAP) is being used to secure the storage, select the **User Authentication** check box. Enter the **CHAP user name** and **CHAP password**.

    **Note:** It is now possible to use the REST API to define specific credentials to each iSCSI target per host.
    {: .alert .alert-info}

    v. Click **Discover**.

    vi. Select the target to use from the discovery results and click the **Login** button.

    Alternatively, click **Login All** to log in to all of the discovered targets.

    **Important:** If more than one path access is required, ensure to discover and log in to the target through all the required paths. Modifying a storage domain to add additional paths is currently not supported.
    {: .alert .alert-info}

8. Click the **+** button next to the desired target. This will expand the entry and display all unused LUNs attached to the target.

9. Select the check box for each LUN that you are using to create the storage domain.

10. Optionally, you can configure the advanced parameters.

    i. Click **Advanced Parameters**.

    ii. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    iii. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    iv. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

    v. Select the **Discard After Delete** check box to enable the discard after delete option. This option can be edited after the domain is created. This option is only available to block storage domains.

11. Click **OK**.

If you have configured multiple storage connection paths to the same target, follow the procedure in the next section, "Configuring iSCSI Multipathing," to complete iSCSI bonding.

### Configuring iSCSI Multipathing

The **iSCSI Multipathing** enables you to create and manage groups of logical networks and iSCSI storage connections. To prevent host downtime due to network path failure, configure multiple network paths between hosts and iSCSI storage. Once configured, the Engine connects each host in the data center to each bonded target via NICs/VLANs related to logical networks of the same iSCSI Bond. You can also specify which networks to use for storage traffic, instead of allowing hosts to route traffic through a default network. This option is only available in the Administration Portal after at least one iSCSI storage domain has been attached to a data center.

**Prerequisites**

* Ensure you have created an iSCSI storage domain and discovered and logged into all the paths to the iSCSI target(s).

* Ensure you have created **Non-Required** logical networks to bond with the iSCSI storage connections. You can configure multiple logical networks or bond networks to allow network failover.

**Configuring iSCSI Multipathing**

1. Click **Compute** &rarr; **Data Centers**.

2. Click the data center’s name to open the details view.

3. Click the **iSCSI Multipathing** tab.

4. Click **Add**.

5. In the **Add iSCSI Bond** window, enter a **Name** and a **Description** for the bond.

6. Select the networks to be used for the bond from the **Logical Networks** list. The networks must be **Non-Required** networks.

    **Note:** To change a network's **Required** designation, from the Administration Portal, select a network, click the **Cluster** tab, and click the **Manage Networks** button.
    {: .alert .alert-info}

7. Select the storage domain to be accessed via the chosen networks from the **Storage Targets** list. Ensure to select all paths to the same target.

8. Click **OK**.

All hosts in the data center are connected to the selected iSCSI target through the selected logical networks.

### Adding FCP Storage

oVirt supports SAN storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

oVirt system administrators need a working knowledge of Storage Area Networks (SAN) concepts. SAN usually uses Fibre Channel Protocol (FCP) for traffic between hosts and shared external storage. For this reason, SAN may occasionally be referred to as FCP storage.

The following procedure shows you how to attach existing FCP storage to your oVirt environment as a data domain.

**Adding FCP Storage**

1. Click **Storage** &rarr; **Domains**.

2. Click **New Domain**.

3. Enter the **Name** of the storage domain.

4. Select an FCP **Data Center** from the drop-down list.

    If you do not yet have an appropriate FCP data center, select `(none)`.

5. Select the **Domain Function** and the **Storage Type** from the drop-down lists. The storage domain types that are not compatible with the chosen data center are not available.

6. Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.

   **Important:** All communication to the storage domain is through the selected host and not directly from the oVirt Engine. At least one active host must exist in the system and be attached to the chosen data center. All hosts must have access to the storage device before the storage domain can be configured.
   {: .alert .alert-info}

7. The **New Domain** window automatically displays known targets with unused LUNs when **Data / Fibre Channel** is selected as the storage type. Select the **LUN ID** check box to select all of the available LUNs.

8. Optionally, you can configure the advanced parameters.

    i. Click **Advanced Parameters**.

    ii. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    iii. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    iv. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

9.  Click **OK**.

The new FCP data domain displays on the **Storage** tab. It will remain with a `Locked` status while it is being prepared for use. When ready, it is automatically attached to the data center.

### Increasing iSCSI or FCP Storage

There are multiple ways to increase iSCSI or FCP storage size:

* Create a new storage domain with new LUNs and add it to an existing datacenter. See [Adding iSCSI Storage](#adding-iscsi-storage).

* Create new LUNs and add them to an existing storage domain.

* Expand the storage domain by resizing the underlying LUNs.

The following procedure explains how to expand storage area network (SAN) storage by adding a new LUN to an existing storage domain.

**Prerequisites**

* The storage domain’s status must be `UP`.

* The LUN must be accessible to all the hosts whose status is `UP`, or else the operation will fail and the LUN will not be added to the domain. The hosts themselves, however, will not be affected. If a newly added host, or a host that is coming out of maintenance or a `Non Operational` state, cannot access the LUN, the host’s state will be `Non Operational`.

**Increasing an Existing iSCSI or FCP Storage Domain**

1. Click **Storage** &rarr; **Domains** and select an iSCSI or FCP domain.

2. Click **Manage Domain**.

3. Click **Targets > LUNs**, and click the **Discover Targets** expansion button.

4. Enter the connection information for the storage server and click **Discover** to initiate the connection.

6. Click **LUNs > Targets** and select the check box of the newly available LUN.

7. Click **OK** to add the LUN to the selected storage domain.

This will increase the storage domain by the size of the added LUN.

When expanding the storage domain by resizing the underlying LUNs, the LUNs must also be refreshed in the oVirt Administration Portal.

**Refreshing the LUN Size**

1. Click **Storage** &rarr; **Domains** and select an iSCSI or FCP domain.

2. Click **Manage Domain**.

3. Click on **LUNs > Targets**.

4. In the **Additional Size** column, click **Add Additional_Storage_Size** of the LUN to refresh.

5. Click **OK** to refresh the LUN to indicate the new storage size.

### Reusing LUNs

LUNs cannot be reused, as is, to create a storage domain or virtual disk. If you try to reuse the LUNs, the Administration Portal displays the following error message:

        Physical device initialization failed. Please check that the device is empty and accessible by the host.

A self-hosted engine shows the following error during installation:

        [ ERROR ] Error creating Volume Group: Failed to initialize physical device: ("[u'/dev/mapper/000000000000000000000000000000000']",)
        [ ERROR ] Failed to execute stage 'Misc configuration': Failed to initialize physical device: ("[u'/dev/mapper/000000000000000000000000000000000']",)

Before the LUN can be reused, the old partitioning table must be cleared.

**Clearing the Partition Table from a LUN**

**Important:** You must run this procedure on the correct LUN so that you do not inadvertently destroy data.
{: .alert .alert-info}

Run the `dd` command with the ID of the LUN that you want to reuse, the maximum number of bytes to read and write at a time, and the number of input blocks to copy:

        # dd if=/dev/zero of=/dev/mapper/LUN_ID bs=1M count=200 oflag=direct

## Importing Existing Storage Domains

### Overview of Importing Existing Storage Domains

In addition to adding new storage domains that contain no data, you can also import existing storage domains and access the data they contain. The ability to import storage domains allows you to recover data in the event of a failure in the Engine database, and to migrate data from one data center or environment to another.

The following is an overview of importing each storage domain type:

**Data**
: Importing an existing data storage domain allows you to access all of the virtual machines and templates that the data storage domain contains. After you import the storage domain, you must manually import virtual machines, floating disk images, and templates into the destination data center. The process for importing the virtual machines and templates that a data storage domain contains is similar to that for an export storage domain. However, because data storage domains contain all the virtual machines and templates in a given data center, importing data storage domains is recommended for data recovery or large-scale migration of virtual machines between data centers or environments.

**Important:** You can import existing data storage domains that were attached to data centers with a compatibility level of 3.5 or higher.
{: .alert .alert-info}

**ISO**
: Importing an existing ISO storage domain allows you to access all of the ISO files and virtual diskettes that the ISO storage domain contains. No additional action is required after importing the storage domain to access these resources; you can attach them to virtual machines as required.

**Export**
:  Importing an existing export storage domain allows you to access all of the virtual machine images and templates that the export storage domain contains. Because export domains are designed for exporting and importing virtual machine images and templates, importing export storage domains is recommended method of migrating small numbers of virtual machines and templates inside an environment or between environments. For information on exporting and importing virtual machines and templates to and from export storage domains, see "Exporting and Importing Virtual Machines and Templates" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center.
    {: .alert .alert-info}

### Importing Storage Domains

Import a storage domain that was previously attached to a data center in the same environment or in a different environment. This procedure assumes the storage domain is no longer attached to any data center in any environment, to avoid data corruption. To import and attach an existing data storage domain to a data center, the target data center must be initialized.

**Importing a Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. Click **Import Domain**.

3. Select the **Data Center** to which to attach the storage domain.

4. Enter a **Name** for the storage domain.

5. Select the **Domain Function** and **Storage Type** from the drop-down lists.

6. Select a host from the **Use host** drop-down list.

   **Important:** All communication to the storage domain is through the selected host and not directly from the oVirt Engine. At least one active host must exist in the system and be attached to the chosen data center. All hosts must have access to the storage device before the storage domain can be configured.
   {: .alert .alert-info}

7. Enter the details of the storage domain.

    **Note:** The fields for specifying the details of the storage domain change depending on the values you select in the Domain Function and Storage Type lists. These fields are the same as those available for adding a new storage domain.
    {: .alert .alert-info}

8. Select the **Activate Domain in Data Center** check box to activate the storage domain after attaching it to the selected data center.

9. Click **OK**.

You can now import virtual machines and templates from the storage domain to the data center.

### Migrating Storage Domains between Data Centers in the Same Environment

Migrate a storage domain from one data center to another in the same oVirt environment to allow the destination data center to access the data contained in the storage domain. This procedure involves detaching the storage domain from one data center, and attaching it to a different data center.

**Migrating a Storage Domain between Data Centers in the Same Environment**

1. Shut down all virtual machines running on the required storage domain.

2. Click **Storage** &rarr; **Domains**.

3. Click the storage domain’s name to open the details view.

4. Click the **Data Center** tab.

5. Click **Maintenance**, then click **OK**.

6. Click **Detach**, then click **OK**.

7. Click **Attach**.

8. Select the destination data center and click **OK**.

The storage domain is attached to the destination data center and is automatically activated. You can now import virtual machines and templates from the storage domain to the destination data center.

### Migrating Storage Domains between Data Centers in Different Environments

Migrate a storage domain from one oVirt environment to another to allow the destination environment to access the data contained in the storage domain. This procedure involves removing the storage domain from one oVirt environment, and importing it into a different environment. To import and attach an existing data storage domain to a oVirt data center, the storage domain's source data center must have a compatibility level of 3.5 or higher.

**Migrating a Storage Domain between Data Centers in Different Environments**

1. Log in to the Administration Portal of the source environment.

2. Shut down all virtual machines running on the required storage domain.

3. Click **Storage** &rarr; **Domains**.

4. Click the storage domain’s name to open the details view.

5. Click the **Data Center** tab.

6. Click **Maintenance**, then click **OK**.

7. Click **Detach**, then click **OK**.

8. Click **Remove**.

9. In the **Remove Storage(s)** window, ensure the **Format Domain, i.e. Storage Content will be lost!** check box is not selected. This step preserves the data in the storage domain for later use.

10. Click **OK** to remove the storage domain from the source environment.

11. Log in to the Administration Portal of the destination environment.

12. Click **Storage** &rarr; **Domains**.

13. Click **Import Domain**.

14. Select the destination data center from the **Data Center** drop-down list.

15. Enter a name for the storage domain.

16. Select the **Domain Function** and **Storage Type** from the drop-down lists.

17. Select a host from the **Use Host** drop-down list.

18. Enter the details of the storage domain.

    **Note:** The fields for specifying the details of the storage domain change depending on the value you select in the Storage Type drop-down list. These fields are the same as those available for adding a new storage domain.
    {: .alert .alert-info}

19. Select the **Activate Domain in Data Center** check box to automatically activate the storage domain when it is attached.

20. Click **OK**.

The storage domain is attached to the destination data center in the new oVirt environment and is automatically activated. You can now import virtual machines and templates from the imported storage domain to the destination data center.

### Importing Virtual Machines from Imported Data Storage Domains

Import a virtual machine from a data storage domain you have imported into your oVirt environment. This procedure assumes that the imported data storage domain has been attached to a data center and has been activated.

**Importing Virtual Machines from an Imported Data Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. Click the imported storage domain’s name to open the details view.

3. Click the **VM Import** tab.

4. Select one or more virtual machines to import.

5. Click **Import**.

6. For each virtual machine in the **Import Virtual Machine(s)** window, ensure the correct target cluster is selected in the **Cluster** list.

7. Map external virtual machine vNIC profiles to profiles that are present on the target cluster(s):

    i. Click **vNic Profiles Mapping**.

    ii. Select the vNIC profile to use from the **Target vNic Profile** drop-down list.

    iii. If multiple target clusters are selected in the **Import Virtual Machine(s)** window, select each target cluster in the **Target Cluster** drop-down list and ensure the mappings are correct.

    iv. Click **OK**.

8. If a MAC address conflict is detected, an exclamation mark appears next to the name of the virtual machine. Mouse over the icon to view a tooltip displaying the type of error that occurred.

   Select the **Reassign Bad MACs** check box to reassign new MAC addresses to all problematic virtual machines. Alternatively, you can select the **Reassign** check box per virtual machine.

      **Note:** If there are no available addresses to assign, the import operation will fail. However, in the case of MAC addresses that are outside the cluster’s MAC address pool range, it is possible to import the virtual machine without reassigning a new MAC address.
      {: .alert .alert-info}

9. Click **OK**.

The imported virtual machines no longer appear in the list under the **VM Import** tab.

### Importing Templates from Imported Storage Domains

Import a template from a data storage domain you have imported into your oVirt environment. This procedure assumes that the imported data storage domain has been attached to a data center and has been activated.

**Importing Templates from an Imported Data Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. Click the imported storage domain’s name to open the details view.

3. Click the **Template Import** tab.

4. Select one or more templates to import.

5. Click **Import**.

6. For each virtual machine in the **Import Template(s)** window, ensure the correct target cluster is selected in the **Cluster** list.

7. Map external virtual machine vNIC profiles to profiles that are present on the target cluster(s):

    i. Click **vNic Profiles Mapping**.

    ii. Select the vNIC profile to use from the **Target vNic Profile** drop-down list.

    iii. If multiple target clusters are selected in the **Import Template(s)** window, select each target cluster in the **Target Cluster** drop-down list and ensure the mappings are correct.

    iv. Click **OK**.

8. Click **OK**.

## Storage Tasks

### Uploading Images to a Data Storage Domain

You can upload virtual disk images and ISO images to your data storage domain in the Administration Portal or with the REST API.

QEMU-compatible virtual disks can be attached to virtual machines. Virtual disk types must be either QCOW2 or raw. Disks created from a QCOW2 virtual disk cannot be shareable, and the QCOW2 virtual disk file must not have a backing file.

ISO images can be attached to virtual machines as CDROMs or used to boot virtual machines.

**Prerequisites**

The upload function uses HTML 5 APIs, which requires your environment to have the following:

* Image I/O Proxy (ovirt-imageio-proxy), configured with engine-setup.

* Certificate authority, imported into the web browser used to access the Administration Portal.

* To import the certificate authority, browse to https://engine_address/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA and enable all the trust settings.

* Browser that supports HTML 5, such as Firefox 35, Internet Explorer 10, Chrome 13, or later.

**Uploading an Image to a Data Storage Domain**

1. Click **Storage** &rarr; **Disks**.

2. Select **Start** from the **Upload** menu.

3. Click **Choose File** and select the image to upload.

4. Fill in the **Disk Options** fields. See “Explanation of Settings in the New Virtual Disk Window” in Chapter 10. for descriptions of the relevant fields.

5. Click **OK**.

  A progress bar indicates the status of the upload. You can pause, cancel, or resume uploads from the Upload menu.

**Increasing the Upload Timeout Value**

1. If the upload times out and you see the message, **Reason: timeout due to transfer inactivity**, increase the timeout value:

        # engine-config -s TransferImageClientInactivityTimeoutInSeconds=6000

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine

### Moving Storage Domains to Maintenance Mode

A storage domain must be in maintenance mode before it can be detached and removed. This is required to redesignate another data domain as the master data domain.

**Moving storage domains to maintenance mode**

1. Shut down all the virtual machines running on the storage domain.

2. Click **Storage** &rarr; **Domains**.

3. Click the storage domain’s name to open the details view.

4. Click the **Data Centers** tab.

5. Click **Maintenance**.

    **Note:** The `Ignore OVF update failure` check box allows the storage domain to go into maintenance mode even if the OVF update fails.
    {: .alert .alert-info}

6. Click **OK**.

The storage domain is deactivated and has an `Inactive` status in the results list. You can now edit, detach, remove, or reactivate the inactive storage domains from the data center.

    **Note:** You can also activate, detach and place domains into maintenance mode using the Storage tab on the details pane of the data center it is associated with.
    {: .alert .alert-info}

### Editing Storage Domains

You can edit storage domain parameters through the Administration Portal. Depending on the state of the storage domain, either active or inactive, different fields are available for editing. Fields such as **Data Center**, **Domain Function**, **Storage Type**, and **Format** cannot be changed.

* **Active**: When the storage domain is in an active state, the **Name**, **Description**, **Comment**, **Warning Low Space Indicator (%)**, **Critical Space Action Blocker (GB)**, and **Wipe After Delete** fields can be edited. The **Name** field can only be edited while the storage domain is active. All other fields can also be edited while the storage domain is inactive.

* **Inactive**: When the storage domain is in maintenance mode or unattached, thus in an inactive state, you can edit all fields except **Name**, **Data Center**, **Domain Function**, **Storage Type**, and **Format**. The storage domain must be inactive to edit storage connections, mount options, and other advanced parameters. This is only supported for NFS, POSIX, and Local storage types.

    **Note:** iSCSI storage connections cannot be edited via the Administration Portal, but can be edited via the REST API.
    {: .alert .alert-info}

**Editing an Active Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. Click **Manage Domain**.

3. Edit the available fields as required.

4. Click **OK**.

**Editing an Inactive Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. If the storage domain is active, move it to maintenance mode:

    i. Click the storage domain’s name to open the details view.

    ii. Click the **Data Center** tab

    iii. Click **Maintenance**.

    iv. Click **OK**.

3. Click **Manage Domain**.

4. Edit the storage path and other details as required. The new connection details must be of the same storage type as the original connection.

5. Click **OK**.

6. Activate the storage domain:

    i. Click the storage domain’s name to open the details view.

    ii. Click the **Data Center** tab.

    iii. Click **Activate**.

### Updating OVFs

**Updating OVFs**

1. Click **Storage** &rarr; **Domains**.

2. Select the storage domain and click **More Actions** &rarr; **Update OVFs**.

The OVFs are updated and a message appears in **Events**.

### Activating Storage Domains from Maintenance Mode

If you have been making changes to a data center's storage, you have to put storage domains into maintenance mode. Activate a storage domain to resume using it.

1. Click **Storage** &rarr; **Domains**.

2. Click an inactive storage domain’s name to open the details view.

3. Click the **Data Centers** tab.

4. Click **Activate**.

   **Important:** If you attempt to activate the ISO domain before activating the data domain, an error message displays and the domain is not activated.
   {: .alert .alert-info}

### Detaching a Storage Domain from a Data Center

Detach a storage domain from one data center to migrate it to another data center.

**Detaching a Storage Domain from the Data Center**

1. Click **Storage** &rarr; **Domains**.

2. Click a storage domain’s name to open the details view.

3. Click the **Data Centers** tab.

4. Click **Maintenance** .

5. Click **OK** to initiate maintenance mode.

6. Click **Detach**.

7. Click **OK** to detach the storage domain.

The storage domain has been detached from the data center, ready to be attached to another data center.

### Attaching a Storage Domain to a Data Center

Attach a storage domain to a data center.

**Attaching a Storage Domain to a Data Center**

1. Click **Storage** &rarr; **Domains**.

2. Click a storage domain’s name to open the details view.

3. Click the **Data Centers** tab.

4. Click **Attach**.

5. Select the appropriate data center.

6. Click **OK**.

The storage domain is attached to the data center and is automatically activated.

### Removing a Storage Domain

You have a storage domain in your data center that you want to remove from the virtualized environment.

**Removing a Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. Move the domain into maintenance mode and detach it:

    i. Click the storage domain’s name to open the details view.

    ii. Click the **Data Center** tab.

    iii. Click **Maintenance**, then click **OK**.

    iv. Click **Detach**, then click **OK**.

3. Click **Remove**.

4. Optionally select the **Format Domain**, i.e. **Storage Content will be lost!** check box to erase the content of the domain.

5. Click **OK**.

The storage domain is permanently removed from the environment.

### Destroying a Storage Domain

A storage domain encountering errors may not be able to be removed through the normal procedure. Destroying a storage domain forcibly removes the storage domain from the virtualized environment.

**Destroying a Storage Domain**

1. Click **Storage** &rarr; **Domains**.

2. Select the storage domain and click **More Actions** &rarr; **Destroy**.

3. Select the **Approve operation** check box.

4. Click **OK**.

The storage domain has been destroyed. Manually clean the export directory for the storage domain to recycle it.

### Creating a Disk Profile

Disk profiles define the maximum level of throughput and the maximum level of input and output operations for a virtual disk in a storage domain. Disk profiles are created based on storage profiles defined under data centers, and must be manually assigned to individual virtual disks for the profile to take effect.

This procedure assumes you have already defined one or more storage quality of service entries under the data center to which the storage domain belongs.

**Creating a Disk Profile**

1. Click **Storage** &rarr; **Domains**.

2. Click the data storage domain’s name to open the details view.

3. Click the **Disk Profiles** tab.

4. Click **New**.

5. Enter a **Name** and a **Description** for the disk profile.

6. Select the quality of service to apply to the disk profile from the **QoS** list.

7. Click **OK**.

You have created a disk profile, and that disk profile can be applied to new virtual disks hosted in the data storage domain.

### Removing a Disk Profile

Remove an existing disk profile from your oVirt environment.

**Removing a Disk Profile**

1. Click **Storage** &rarr; **Domains**.

2. Click the data storage domain’s name to open the details view.

3. Click the **Disk Profiles** tab.

4. Select the disk profile to remove.

5. Click **Remove**.

6. Click **OK**.

If the disk profile was assigned to any virtual disks, the disk profile is removed from those virtual disks.

### Viewing the Health Status of a Storage Domain

Storage domains have an external health status in addition to their regular **Status**. The external health status is reported by plug-ins or external systems, or set by an administrator, and appears to the left of the storage domain's **Name** as one of the following icons:

* **OK**: No icon

* **Info**: ![](/images/admin-guide/Info.png)

* **Warning**: ![](/images/admin-guide/Warning.png)

* **Error**: ![](/images/admin-guide/Error.png)

* **Failure**: ![](/images/admin-guide/Failure.png)

To view further details about the storage domain's health status, select the storage domain and click the **Events** tab.

The storage domain's health status can also be viewed using the REST API. A `GET` request on a storage domain will include the `external_status` element, which contains the health status.

You can set a storage domain's health status in the REST API via the `events` collection.

### Managing System Permissions for a Storage Domain

When the **Discard After Delete** check box is selected, a `blkdiscard` command is called on a logical volume when it is removed and the underlying storage is notified that the blocks are free. The storage array can use the freed space and allocate it when requested. **Discard After Delete** only works on block storage. The flag is not available on the oVirt Engine for file storage, for example NFS.

**Restrictions:**

* **Discard After Delete** is only available on block storage domains, such as iSCSI or Fibre Channel.

* The underlying storage must support `Discard`.

**Discard After Delete** can be enabled both when creating a block storage domain or when editing a block storage domain. See the “Adding Block Storage” and “Editing Storage Domains”. sections in this chapter.

**Prev:** [Chapter 7: Hosts](chap-Hosts)<br>
**Next:** [Chapter 9: Pools](chap-Pools)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-storage)

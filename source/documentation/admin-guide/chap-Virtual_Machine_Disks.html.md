---
title: Virtual Disks
---

# Chapter 10: Virtual Disks

## Understanding Virtual Machine Storage

oVirt supports three storage types: NFS, iSCSI and FCP.

In each type, a host known as the Storage Pool Manager (SPM) manages access between hosts and storage. The SPM host is the only node that has full access within the storage pool; the SPM can modify the storage domain metadata, and the pool's metadata. All other hosts can only access virtual machine hard disk image data.

By default in an NFS, local, or POSIX compliant data center, the SPM creates the virtual disk using a thin provisioned format as a file in a file system.

In iSCSI and other block-based data centers, the SPM creates a volume group on top of the Logical Unit Numbers (LUNs) provided, and makes logical volumes to use as virtual machine disks. Virtual machine disks on block-based storage are preallocated by default.

If the virtual disk is preallocated, a logical volume of the specified size in GB is created. The virtual machine can be mounted on a Red Hat Enterprise Linux server using `kpartx`, `vgscan`, `vgchange` or `mount` to investigate the virtual machine's processes or problems.

If the virtual disk is thinly provisioned, a 1 GB logical volume is created. The logical volume is continuously monitored by the host on which the virtual machine is running. As soon as the usage nears a threshold the host notifies the SPM, and the SPM extends the logical volume by 1 GB. The host is responsible for resuming the virtual machine after the logical volume has been extended. If the virtual machine goes into a paused state it means that the SPM could not extend the disk in time. This occurs if the SPM is too busy or if there is not enough storage space.

A virtual disk with a preallocated (RAW) format has significantly faster write speeds than a virtual disk with a thin provisioning (QCOW2) format. Thin provisioning takes significantly less time to create a virtual disk. The thin provision format is suitable for non-I/O intensive virtual machines. The preallocated format is recommended for virtual machines with high I/O writes. If a virtual machine is able to write more than 1 GB every four seconds, use preallocated disks where possible.

## Understanding Virtual Disks

oVirt features **Preallocated** (thick provisioned) and **Sparse** (thin provisioned) storage options.

* Preallocated

    A preallocated virtual disk allocates all the storage required for a virtual machine up front. For example, a 20 GB preallocated logical volume created for the data partition of a virtual machine will take up 20 GB of storage space immediately upon creation.

* Sparse

    A sparse allocation allows an administrator to define the total storage to be assigned to the virtual machine, but the storage is only allocated when required.

    For example, a 20 GB thin provisioned logical volume would take up 0 GB of storage space when first created. When the operating system is installed it may take up the size of the installed file, and would continue to grow as data is added up to a maximum of 20 GB size.

You can view a virtual disk’s **ID** in **Storage** &rarr; **Disks**. The **ID** is used to identify a virtual disk because its device name (for example, **/dev/vda0**) can change, causing disk corruption. You can also view a virtual disk’s ID in **/dev/disk/by-id**.

You can view the **Virtual Size** of a disk in **Storage** &rarr; **Disks** and in the **Disks** tab of the details view for storage domains, virtual machines, and templates. The **Virtual Size** is the total amount of disk space that the virtual machine can use. It is the number that you enter in the **Size(GB)** field when you create or edit a virtual disk.

You can view the **Actual Size** of a disk in the **Disks** tab of the details view for storage domains and templates. This is the amount of disk space that has been allocated to the virtual machine so far. Preallocated disks show the same value for **Virtual Size** and **Actual Size**. Sparse disks may show different values, depending on how much disk space has been allocated.

    **Note:** When creating a Cinder virtual disk, the format and type of the disk are handled internally by Cinder and are not managed by oVirt.

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

## Settings to Wipe Virtual Disks After Deletion

The `wipe_after_delete` flag, viewed in the Administration Portal as the **Wipe After Delete** check box will replace used data with zeros when a virtual disk is deleted. If it is set to false, which is the default, deleting the disk will open up those blocks for re-use but will not wipe the data. It is, therefore, possible for this data to be recovered because the blocks have not been returned to zero.

The `wipe_after_delete` flag only works on block storage. On file storage, for example NFS, the option does nothing because the file system will ensure that no data exists.

Enabling `wipe_after_delete` for virtual disks is more secure, and is recommended if the virtual disk has contained any sensitive data. This is a more intensive operation and users may experience degradation in performance and prolonged delete times.

    **Note:** The wipe after delete functionality is not the same as secure delete, and cannot guarantee that the data is removed from the storage, just that new disks created on same storage will not expose data from old disks.

The `wipe_after_delete` flag default can be changed to `true` during the setup process (see "Configuring the oVirt Engine" in the [Installation Guide](/documentation/install-guide/Installation_Guide/)), or by using the engine configuration tool on the oVirt Engine. Restart the engine for the setting change to take effect.

    **Note:** Changing the `wipe_after_delete` flag’s default setting will not affect the **Wipe After Delete** property of disks that already exist.

**Setting SANWipeAfterDelete to Default to True Using the Engine Configuration Tool**

1. Run the `engine-config` tool with the `--set` action:

        # engine-config --set SANWipeAfterDelete=true

2. Restart the `ovirt-engine` for the change to take effect:

        # systemctl restart ovirt-engine.service

The **/var/log/vdsm/vdsm.log** file located on the host can be checked to confirm that a virtual disk was successfully wiped and deleted.

For a successful wipe, the log file will contain the entry, `storage_domain_id/volume_id was zeroed and will be deleted`. For example:

    a9cb0625-d5dc-49ab-8ad1-72722e82b0bf/a49351a7-15d8-4932-8d67-512a369f9d61 was zeroed and will be deleted

For a successful deletion, the log file will contain the entry, `finished with VG:storage_domain_id LVs: list_of_volume_ids, img: image_id`. For example:

    finished with VG:a9cb0625-d5dc-49ab-8ad1-72722e82b0bf LVs: {'a49351a7-15d8-4932-8d67-512a369f9d61': ImgsPar(imgs=['11f8b3be-fa96-4f6a-bb83-14c9b12b6e0d'], parent='00000000-0000-0000-0000-000000000000')}, img: 11f8b3be-fa96-4f6a-bb83-14c9b12b6e0d

An unsuccessful wipe will display a log message `zeroing storage_domain_id/volume_id failed. Zero and remove this volume manually`, and an unsuccessful delete will display `Remove failed for some of VG: storage_domain_id zeroed volumes: list_of_volume_ids`.

## Shareable Disks in oVirt

Some applications require storage to be shared between servers. oVirt allows you to mark virtual machine hard disks as **Shareable** and attach those disks to virtual machines. That way a single virtual disk can be used by multiple cluster-aware guests.

Shared disks are not to be used in every situation. For applications like clustered database servers, and other highly available services, shared disks are appropriate. Attaching a shared disk to multiple guests that are not cluster-aware is likely to cause data corruption because their reads and writes to the disk are not coordinated.

You cannot take a snapshot of a shared disk. Virtual disks that have snapshots taken of them cannot later be marked shareable.

You can mark a disk shareable either when you create it, or by editing the disk later.

## Read Only Disks in oVirt

Some applications require administrators to share data with read-only rights. You can do this when creating or editing a disk attached to a virtual machine via the **Disks** tab in the details pane of the virtual machine and selecting the **Read Only** check box. That way, a single disk can be read by multiple cluster-aware guests, while an administrator maintains writing privileges.

You cannot change the read-only status of a disk while the virtual machine is running.

    **Important:** Mounting a journaled file system requires read-write access. Using the **Read Only** option is not appropriate for virtual machine disks that contain such file systems (e.g. `EXT3`, `EXT4`, or `XFS`).

## Virtual Disk Tasks

### Creating Floating Virtual Disks

**Image** disk creation is managed entirely by the Engine. **Direct LUN** disks require externally prepared targets that already exist. **Cinder** disks require access to an instance of OpenStack Volume that has been added to the oVirt environment using the **External Providers** window; see [Adding an OpenStack Volume Cinder Instance for Storage Management](Adding_an_OpenStack_Volume_Cinder_Instance_for_Storage_Management) for more information.

You can create a virtual disk that is attached to a specific virtual machine. Additional options are available when creating an attached virtual disk, as specified in the “Explanation of Settings in the New Virtual Disk Window” section below.

**Creating a Virtual Disk Attached to a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to open the details view.

3. Click the **Disks** tab.

4. Click **New**.

5. Click the appropriate button to specify whether the virtual disk will be an **Image**, **Direct LUN**, or **Cinder** disk.

6. Select the options required for your virtual disk. The options change based on the disk type selected. See the “Explanation of Settings in the New Virtual Disk Window” below for more details on each option for each disk type.

7. Click OK.

You can also create a floating virtual disk that does not belong to any virtual machines. You can attach this disk to a single virtual machine, or to multiple virtual machines if the disk is shareable. Some options are not available when creating a virtual disk, as specified in the “Explanation of Settings in the New Virtual Disk Window” section.

**Creating Floating Virtual Disks**

1. Click **Storage** &rarr; **Disks**.

2. Click **New**.

3. Click the appropriate button to specify whether the virtual disk will be an **Image**, **Direct LUN**, or **Cinder** disk.

4. Select the options required for your virtual disk. The options change based on the disk type selected. See the “Explanation of Settings in the New Virtual Disk Window” section for more details on each option for each disk type.

5. Click **OK**.

### Explanation of Settings in the New Virtual Disk Window

**New Virtual Disk and Edit Virtual Disk Settings: Image**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Size(GB)</b></td>
   <td>The size of the new virtual disk in GB.</td>
  </tr>
  <tr>
   <td><b>Alias</b></td>
   <td>The name of the virtual disk, limited to 40 characters.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A description of the virtual disk. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Interface</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</p>
   <p>The interface type can be updated after stopping all virtual machines that the disk is attached to.</p>
   </td>
  </tr>
  <tr>
   <td><b>Data Center</b></td>
   <td>
   <p>This field only appears when creating a floating disk.</p>
   <p>The data center in which the virtual disk will be available.</p>
   </td>
  </tr>
  <tr>
   <td><b>Storage Domain</b></td>
   <td>The storage domain in which the virtual disk will be stored. The drop-down list shows all storage domains available in the given data center, and also shows the total space and currently available space in the storage domain.</td>
  </tr>
  <tr>
   <td><b>Allocation Policy</b></td>
   <td>
    <p>The provisioning policy for the new virtual disk.</p>
    <ul>
     <li><b>Preallocated</b> allocates the entire size of the disk on the storage domain at the time the virtual disk is created. The virtual size and the actual size of a preallocated disk are the same. Preallocated virtual disks take more time to create than thinly provisioned virtual disks, but have better read and write performance. Preallocated virtual disks are recommended for servers and other I/O intensive virtual machines. If a virtual machine is able to write more than 1 GB every four seconds, use preallocated disks where possible.</li>
     <li><b>Thin Provision</b> allocates 1 GB at the time the virtual disk is created and sets a maximum limit on the size to which the disk can grow. The virtual size of the disk is the maximum limit; the actual size of the disk is the space that has been allocated so far. Thinly provisioned disks are faster to create than preallocated disks and allow for storage over-commitment. Thinly provisioned virtual disks are recommended for desktops.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Disk Profile</b></td>
   <td>The disk profile assigned to the virtual disk. Disk profiles define the maximum amount of throughput and the maximum level of input and output operations for a virtual disk in a storage domain. Disk profiles are defined on the storage domain level based on storage quality of service entries created for data centers.</td>
  </tr>
  <tr>
   <td><b>Activate Disk(s)</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Activate the virtual disk immediately after creation.</p>
   </td>
  </tr>
  <tr>
   <td><b>Wipe After Delete</b></td>
   <td>Allows you to enable enhanced security for deletion of sensitive material when the virtual disk is deleted.</td>
  </tr>
  <tr>
   <td><b>Bootable</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Allows you to enable the bootable flag on the virtual disk.</p>
   </td>
  </tr>
  <tr>
   <td><b>Shareable</b></td>
   <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
  </tr>
  <tr>
   <td><b>Read-Only</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another.</p>
   </td>
  </tr>
  <tr>
   <td><b>Enable Discard</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Allows you to shrink a thin provisioned disk while the virtual machine is up. For block storage, the underlying storage device must support discard calls, and the option cannot be used with <b>Wipe After Delete</b> unless the underlying storage supports the `discard_zeroes_data` property. For file storage, the underlying file system and the block device must support discard calls. If all requirements are met, SCSI UNMAP commands issued from guest virtual machines is passed on by QEMU to the underlying storage to free up the unused space.</p>
   </td>
  </tr>
  </tbody>
</table>

The **Direct LUN** settings can be displayed in either **Targets > LUNs** or **LUNs > Targets**. **Targets > LUNs** sorts available LUNs according to the host on which they are discovered, whereas **LUNs > Targets** displays a single list of LUNs.

Fill in the fields in the **Discover Targets** section and click **Discover** to discover the target server. You can then click the **Login All** button to list the available LUNs on the target server and, using the radio buttons next to each LUN, select the LUN to add.

Using LUNs directly as virtual machine hard disk images removes a layer of abstraction between your virtual machines and their data.

The following considerations must be made when using a direct LUN as a virtual machine hard disk image:

* Live storage migration of direct LUN hard disk images is not supported.

* Direct LUN disks are not included in virtual machine exports.

* Direct LUN disks are not included in virtual machine snapshots.

**New Virtual Disk and Edit Virtual Disk Settings: Direct**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Alias</b></td>
   <td>The name of the virtual disk, limited to 40 characters.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>
    <p>A description of the virtual disk. This field is recommended but not mandatory. By default the last 4 characters of the LUN ID is inserted into the field.</p>
    <p>The default behavior can be configured by setting the <tt>PopulateDirectLUNDiskDescriptionWithLUNId</tt> configuration key to the appropriate value using the <tt>engine-config</tt> command.  The configuration key can be set to <tt>-1</tt> for the full LUN ID to be used, or <tt>0</tt> for this feature to be ignored. A positive integer populates the description with the corresponding number of characters of the LUN ID.</p>
   </td>
  </tr>
  <tr>
   <td><b>Interface</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</p>
   <p>The interface type can be updated after stopping all virtual machines that the disk is attached to.</p>
  </td>
  </tr>
  <tr>
   <td><b>Data Center</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>The data center in which the virtual disk will be available.</p>
   </td>
  </tr>
  <tr>
   <td><b>Use Host</b></td>
   <td>The host on which the LUN will be mounted. You can select any host in the data center.</td>
  </tr>
  <tr>
   <td><b>Storage Type</b></td>
   <td>The type of external LUN to add. You can select from either <b>iSCSI</b> or <b>Fibre Channel</b>.</td>
  </tr>
  <tr>
   <td><b>Discover Targets</b></td>
   <td>
    <p>This section can be expanded when you are using iSCSI external LUNs and <b>Targets > LUNs</b> is selected.</p>
    <p><b>Address</b> - The host name or IP address of the target server.</p>
    <p><b>Port</b> - The port by which to attempt a connection to the target server. The default port is 3260.</p>
    <p><b>User Authentication</b> - The iSCSI server requires User Authentication. The <b>User Authentication</b> field is visible when you are using iSCSI external LUNs.</p>
    <p><b>CHAP user name</b> - The user name of a user with permission to log in to LUNs. This field is accessible when the <b>User Authentication</b> check box is selected.</p>
    <p><b>CHAP password</b> - The password of a user with permission to log in to LUNs. This field is accessible when the <b>User Authentication</b> check box is selected.</p>
   </td>
  </tr>
  <tr>
   <td><b>Activate Disk(s)</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Activate the virtual disk immediately after creation.</p>
   </td>
  </tr>
  <tr>
   <td><b>Bootable</b></td>
   <td>Allows you to enable the bootable flag on the virtual disk.</td>
  </tr>
  <tr>
   <td><b>Shareable</b></td>
   <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
  </tr>
  <tr>
   <td><b>Read-Only</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another.</p>
   </td>
  </tr>
  <tr>
   <td><b>Enable Discard</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Allows you to shrink a thin provisioned disk while the virtual machine is up. For block storage, the underlying storage device must support discard calls, and the option cannot be used with <b>Wipe After Delete</b> unless the underlying storage supports the `discard_zeroes_data` property. For file storage, the underlying file system and the block device must support discard calls. If all requirements are met, SCSI UNMAP commands issued from guest virtual machines is passed on by QEMU to the underlying storage to free up the unused space.</p>
   </td>
  </tr>
  <tr>
   <td><b>Enable SCSI Pass-Through</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Available when the <b>Interface</b> is set to <b>VirtIO-SCSI</b>. Selecting this check box enables passthrough of a physical SCSI device to the virtual disk. A VirtIO-SCSI interface with SCSI passthrough enabled automatically includes SCSI discard support. When this check box is not selected, the virtual disk uses an emulated SCSI device.</p>
   </td>
  </tr>
  <tr>
   <td><b>Allow Privileged SCSI I/O</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Available when the <b>Enable SCSI Pass-Through</b> check box is selected. Selecting this check box enables unfiltered SCSI Generic I/O (SG_IO) access, allowing privileged SG_IO commands on the disk. This is required for persistent reservations.</p>
   </td>
  </tr>
  <tr>
   <td><b>Using SCSI Reservation</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Available when the <b>Enable SCSI Pass-Through</b> and <b>Allow Privileged SCSI I/O</b> check boxes are selected. Selecting this check box disables migration for any virtual machine using this disk, to prevent virtual machines that are using SCSI reservation from losing access to the disk.</p>
   </td>
  </tr>
 </tbody>
</table>

The **Cinder** settings form will be disabled if there are no available OpenStack Volume storage domains on which you have permissions to create a disk in the relevant Data Center. **Cinder** disks require access to an instance of OpenStack Volume that has been added to the oVirt environment using the **External Providers** window; see [Adding an OpenStack Volume Cinder Instance for Storage Management](Adding_an_OpenStack_Volume_Cinder_Instance_for_Storage_Management) for more information.

**New Virtual Disk and Edit Virtual Disk Settings: Cinder**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Size(GB)</b></td>
   <td>The size of the new virtual disk in GB.</td>
  </tr>
  <tr>
   <td><b>Alias</b></td>
   <td>The name of the virtual disk, limited to 40 characters.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A description of the virtual disk. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Interface</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</p>
   <p>The interface type can be updated after stopping all virtual machines that the disk is attached to.</p>
  </td>
  </tr>
  <tr>
   <td><b>Data Center</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>The data center in which the virtual disk will be available.</p>
   </td>
  </tr>
   <td><b>Storage Domain</b></td>
   <td>The storage domain in which the virtual disk will be stored. The drop-down list shows all storage domains available in the given data center, and also shows the total space and currently available space in the storage domain.</td>
  </tr>
  <tr>
   <td><b>Volume Type</b></td>
   <td>The volume type of the virtual disk. The drop-down list shows all available volume types. The volume type will be managed and configured on OpenStack Cinder.</td>
  </tr>
  <tr>
   <td><b>Activate Disk(s)</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Activate the virtual disk immediately after creation.</p>
   </td>
  </tr>
  <tr>
   <td><b>Bootable</b></td>
   <td>Allows you to enable the bootable flag on the virtual disk.</td>
  </tr>
  <tr>
   <td><b>Shareable</b></td>
   <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
  </tr>
  <tr>
   <td><b>Read-Only</b></td>
   <td>
   <p>This field only appears when creating an attached disk.</p>
   <p>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another.</p>
   </td>
  </tr>
 </tbody>
</table>

    **Important:** Mounting a journaled file system requires read-write access. Using the **Read-Only** option is not appropriate for virtual disks that contain such file systems (e.g., **EXT3**, **EXT4**, or **XFS**).

### Overview of Live Storage Migration

Virtual machine disks can be migrated from one storage domain to another while the virtual machine to which they are attached is running. This is referred to as live storage migration. When a disk attached to a running virtual machine is migrated, a snapshot of that disk's image chain is created in the source storage domain, and the entire image chain is replicated in the destination storage domain. As such, ensure that you have sufficient storage space in both the source storage domain and the destination storage domain to host both the disk image chain and the snapshot. A new snapshot is created on each live storage migration attempt, even when the migration fails.

Consider the following when using live storage migration:

* You can live migrate multiple disks at one time.

* Multiple disks for the same virtual machine can reside across more than one storage domain, but the image chain for each disk must reside on a single storage domain.

* You can live migrate disks between any two storage domains in the same data center.

* You cannot live migrate direct LUN hard disk images or disks marked as shareable.

### Moving a Virtual Disk

Move a virtual disk that is attached to a virtual machine or acts as a floating virtual disk from one storage domain to another. You can move a virtual disk that is attached to a running virtual machine; this is referred to as live storage migration. Alternatively, shut down the virtual machine before continuing.

Consider the following when moving a disk:

* You can move multiple disks at the same time.

* You can move disks between any two storage domains in the same data center.

* If the virtual disk is attached to a virtual machine that was created based on a template and used the thin provisioning storage allocation option, you must copy the disks for the template on which the virtual machine was based to the same storage domain as the virtual disk.

**Moving a Virtual Disk**

1. Click **Storage** &rarr; **Disks** and select one or more virtual disks to move.

2. Click **Move**.

3. From the **Target** list, select the storage domain to which the virtual disk(s) will be moved.

4. From the **Disk Profile** list, select a profile for the disk(s), if applicable.

5. Click **OK**.

The virtual disks are moved to the target storage domain. During the move procedure, the **Status** column displays `Locked` and a progress bar indicating the progress of the move operation.

### Changing the Disk Interface Type

Users can change a disk’s interface type after the disk has been created. This enables you to attach an existing disk to a virtual machine that requires a different interface type. For example, a disk using the `VirtIO` interface can be attached to a virtual machine requiring the `VirtIO-SCSI` or `IDE` interface. This provides flexibility to migrate disks for the purpose of backup and restore, or disaster recovery. The disk interface for shareable disks can also be updated per virtual machine. This means that each virtual machine that uses the shared disk can use a different interface type.

To update a disk interface type, all virtual machines using the disk must first be stopped.

**Changing a Disk Interface Type**

1. Click **Compute** &rarr; **Virtual Machines** and stop the appropriate virtual machine(s).

2. Click the virtual machine’s name to open the details view.

3. Click the **Disks** tab and select the disk.

4. Click **Edit**.

5. From the **Interface** list, select the new interface type and click **OK**.

You can attach a disk to a different virtual machine that requires a different interface type.

**Attaching a Disk to a Different Virtual Machine using a Different Interface Type**

1. Click **Compute** &rarr; **Virtual Machines** and stop the appropriate virtual machine(s).

2. Click the virtual machine’s name to open the details view.

3. Click the **Disks** tab and select the disk.

4. Click **Remove**, then click **OK**.

5. Go back to **Virtual Machines** and click the name of the new virtual machine that the disk will be attached to.

6. Click the **Disks** tab, then click **Attach**.

7. Select the disk in the **Attach Virtual Disks** window and select the appropriate interface from the **Interface** drop-down.

8. Click **OK**.

### Copying a Virtual Disk

You can copy a virtual disk from one storage domain to another. The copied disk can be attached to virtual machines.

**Copying a Virtual Disk**

1. Click **Storage** &rarr; **Disks** and select the virtual disk(s).

2. Click **Copy**.

3. Optionally, enter an alias in the **Alias** field.

4. From the **Target** list, select the storage domain to which the virtual disk(s) will be copied.

5. From the **Disk Profile** list, select a profile for the disk(s), if applicable.

6. Click **OK**.

The virtual disks have a status of `Locked` while being copied.

### Uploading a Disk Image to a Storage Domain

You can upload virtual disk images and ISO images to your data storage domain in the Administration Portal or with the REST API.

QEMU-compatible virtual disks can be attached to virtual machines. Virtual disk types must be either QCOW2 or raw. Disks created from a QCOW2 virtual disk cannot be shareable, and the QCOW2 virtual disk file must not have a backing file.

ISO images can be attached to virtual machines as CDROMs or used to boot virtual machines.

**Prerequisites:**

The upload function uses HTML 5 APIs, which requires your environment to have the following:

* Image I/O Proxy (ovirt-imageio-proxy), configured with engine-setup. See Configuring the oVirt Engine in the [Installation Guide](/documentation/install-guide/Installation_Guide/) for details.

* Certificate authority, imported into the web browser used to access the Administration Portal.

  To import the certificate authority, browse to https://engine_address/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA and enable all the trust settings. Refer to the instructions to install the certificate authority in Firefox, Internet Explorer, or Google Chrome.

* Browser that supports HTML 5, such as Firefox 35, Internet Explorer 10, Chrome 13, or later.

**Uploading an Image to a Data Storage Domain**

1. Click **Storage** &rarr; **Disks**.

2. Select **Start** from the **Upload** menu.

3. Click **Choose File** and select the image to upload.

4. Fill in the **Disk Options** fields. See the “Explanation of Settings in the New Virtual Disk Window” section for descriptions of the relevant fields.

5. Click **OK**.

A progress bar indicates the status of the upload. You can pause, cancel, or resume uploads from the **Upload** menu.

**Increasing the Upload Timeout Value**

1. If the upload times out and you see the message, **Reason: timeout due to transfer inactivity, increase the timeout value**:

        # engine-config -s TransferImageClientInactivityTimeoutInSeconds=6000

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine

### Importing a Disk Image from an Imported Storage Domain

Import floating virtual disks from an imported storage domain using the **Disk Import** tab of the details pane.

    **Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Click **Storage** &rarr; **Domains**.

2. Click the name of an imported storage domain to open the details view.

3. Click the **Disk Import** tab.

4. Select one or more disks and click **Import**.

5. Select the appropriate **Disk Profile** for each disk.

6. Click **OK**.

### Importing an Unregistered Disk Image from an Imported Storage Domain

Import floating virtual disks from a storage domain using the **Disk Import** tab of the details pane. Floating disks created outside of a oVirt environment are not registered with the Engine. Scan the storage domain to identify unregistered floating disks to be imported.

**Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Click **Storage** &rarr; **Domains**.

2. Click the name of an imported storage domain to open the details view.

3. Click **More Actions** &rarr; **Scan Disks** so that the Engine can identify unregistered disks.

4. Click the **Disk Import** tab.

5. Select one or more disks and click **Import**.

6. Select the appropriate **Disk Profile** for each disk.

7. Click **OK**.

### Importing a Virtual Disk Image from an OpenStack Image Service

Virtual disk images managed by an OpenStack Image Service can be imported into the oVirt Engine if that OpenStack Image Service has been added to the Engine as an external provider.

1. Click **Storage** &rarr; **Domains**.

2. Click the OpenStack Image Service domain’s name to open the details view.

3. Click the **Images** tab and select an image.

4. Click **Import**.

5. Select the **Data Center** into which the image will be imported.

6. From the **Domain Name** drop-down list, select the storage domain in which the virtual disk image will be stored.

7. Optionally, select a quota from the **Quota** drop-down list.

8. Click **OK**.

The disk can now be attached to a virtual machine.

### Exporting a Virtual Machine Disk to an OpenStack Image Service

Virtual machine disks can be exported to an OpenStack Image Service that has been added to the Engine as an external provider.

    **Important:** Virtual disks can only be exported if they do not have multiple volumes, are not thin provisioned, and do not have any snapshots.

1. Click **Storage** &rarr; **Disks** and select the disks to export.

2. Click **More Actions** &rarr; **Export**.

3. From the **Domain Name** drop-down list, select the OpenStack Image Service to which the disks will be exported.

4. From the **Quota** drop-down list, select a quota for the disks if a quota is to be applied.

5. Click **OK**.

### Reclaiming Virtual Disk Space

Virtual disks that use thin provisioning do not automatically shrink after deleting files from them. For example, if the actual disk size is 100GB and you delete 50GB of files, the allocated disk size remains at 100GB, and the remaining 50GB is not returned to the host, and therefore cannot be used by other virtual machines. This unused disk space can be reclaimed by the host by performing a sparsify operation on the virtual machine’s disks. This transfers the free space from the disk image to the host. You can sparsify multiple virtual disks in parallel.

The oVirt Project recommends performing this operation before cloning a virtual machine, creating a template based on a virtual machine, or cleaning up a storage domain’s disk space.

**Limitations**

* NFS storage domains must use NFS version 4.2 or higher.

* You cannot sparsify a disk that uses a direct LUN or Cinder.

* You cannot sparsify a disk that uses a preallocated allocation policy. If you are creating a virtual machine from a template, you must select **Thin** from the **Storage Allocation** field, or if selecting **Clone**, ensure that the template is based on a virtual machine that has thin provisioning.

* You can only sparsify active snapshots.

**Sparsifying a Disk**

1. Click **Compute** &rarr; **Virtual Machines** and shut down the required virtual machine.

2. Click the virtual machine’s name to open the details view.

3. Click the **Disks** tab. Ensure that the disk’s status is `OK`.

4. Click **More Actions** → **Sparsify**.

5. Click **OK**.

A `Started to sparsify` event appears in the **Events** tab during the sparsify operation and the disk’s status displays as `Locked`. When the operation is complete, a `Sparsified successfully` event appears in the **Events** tab and the disk’s status displays as `OK`. The unused disk space has been returned to the host and is available for use by other virtual machines.

**Prev:** [Chapter 9: Pools](../chap-Pools)<br>
**Next:** [Chapter 11: External Providers](../chap-External_Providers)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-virtual_machine_disks)

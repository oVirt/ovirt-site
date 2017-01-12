# Explanation of Settings in the New Virtual Disk Window

**New Virtual Disk Settings: Image**

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
   <td>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Red Hat Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</td>
  </tr>
  <tr>
   <td><b>Data Center</b></td>
   <td>The data center in which the virtual disk will be available.</td>
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
   <td><b>Wipe After Delete</b></td>
   <td>Allows you to enable enhanced security for deletion of sensitive material when the virtual disk is deleted.</td>
  </tr>
  <tr>
   <td><b>Bootable</b></td>
   <td>Allows you to enable the bootable flag on the virtual disk.</td>
  </tr>
  <tr>
   <td><b>Shareable</b></td>
   <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
  </tr>
 </tbody>
</table>

The **Direct LUN** settings can be displayed in either **Targets > LUNs** or **LUNs > Targets**. **Targets > LUNs** sorts available LUNs according to the host on which they are discovered, whereas **LUNs > Targets** displays a single list of LUNs.

**New Virtual Disk Settings: Direct LUN**

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
    <p>The default behavior can be configured by setting the <tt>PopulateDirectLUNDiskDescriptionWithLUNId</tt> configuration key to the appropriate value using the <tt>engine-config</tt> command.  The configuration key can be set to <tt>-1</tt> for the full LUN ID to be used, or <tt>0</tt> for this feature to be ignored. A positive integer populates the description with the corresponding number of characters of the LUN ID. See <a href="Syntax_for_rhevm_config_Command">Syntax for rhevm config Command</a> for more information.</p>
   </td>
  </tr>
  <tr>
   <td><b>Interface</b></td>
   <td>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Red Hat Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</td>
  </tr>
  <tr>
   <td><b>Data Center</b></td>
   <td>The data center in which the virtual disk will be available.</td>
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
   <td><b>Bootable</b></td>
   <td>Allows you to enable the bootable flag on the virtual disk.</td>
  </tr>
  <tr>
   <td><b>Shareable</b></td>
   <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
  </tr>
  <tr>
   <td><b>Enable SCSI Pass-Through</b></td>
   <td>Available when the <b>Interface</b> is set to <b>VirtIO-SCSI</b>. Selecting this check box enables passthrough of a physical SCSI device to the virtual disk. A VirtIO-SCSI interface with SCSI passthrough enabled automatically includes SCSI discard support. When this check box is not selected, the virtual disk uses an emulated SCSI device.</td>
  </tr>
  <tr>
   <td><b>Allow Privileged SCSI I/O</b></td>
   <td>Available when the <b>Enable SCSI Pass-Through</b> check box is selected. Selecting this check box enables unfiltered SCSI Generic I/O (SG_IO) access, allowing privileged SG_IO commands on the disk. This is required for persistent reservations.</td>
  </tr>
 </tbody>
</table>

Fill in the fields in the **Discover Targets** section and click **Discover** to discover the target server. You can then click the **Login All** button to list the available LUNs on the target server and, using the radio buttons next to each LUN, select the LUN to add.

Using LUNs directly as virtual machine hard disk images removes a layer of abstraction between your virtual machines and their data.

The following considerations must be made when using a direct LUN as a virtual machine hard disk image:

* Live storage migration of direct LUN hard disk images is not supported.

* Direct LUN disks are not included in virtual machine exports.

* Direct LUN disks are not included in virtual machine snapshots.

The **Cinder** settings form will be disabled if there are no available OpenStack Volume storage domains on which you have permissions to create a disk in the relevant Data Center. **Cinder** disks require access to an instance of OpenStack Volume that has been added to the Red Hat Virtualization environment using the **External Providers** window; see [Adding an OpenStack Volume Cinder Instance for Storage Management](Adding_an_OpenStack_Volume_Cinder_Instance_for_Storage_Management) for more information.

**New Virtual Disk Settings: Cinder**

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
   <td>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Red Hat Enterprise Linux 5 and higher include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</td>
  </tr>
  <tr>
   <td><b>Data Center</b></td>
   <td>The data center in which the virtual disk will be available.</td>
  </tr>
  <tr>
   <td><b>Storage Domain</b></td>
   <td>The storage domain in which the virtual disk will be stored. The drop-down list shows all storage domains available in the given data center, and also shows the total space and currently available space in the storage domain.</td>
  </tr>
  <tr>
   <td><b>Volume Type</b></td>
   <td>The volume type of the virtual disk. The drop-down list shows all available volume types. The volume type will be managed and configured on OpenStack Cinder.</td>
  </tr>
  <tr>
   <td><b>Bootable</b></td>
   <td>Allows you to enable the bootable flag on the virtual disk.</td>
  </tr>
  <tr>
   <td><b>Shareable</b></td>
   <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
  </tr>
 </tbody>
</table>

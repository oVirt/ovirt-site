---
title: Vdsm datatypes
category: vdsm
authors: aglitke
---

# Vdsm datatypes

VDSM uses various complex types throughout its API.
Currently these are expressed as free-form dictionaries and/or strings with magic values.
This wiki page attempts to capture a comprehensive list of these types for reference and to serve as a base for discussion
on creating a more formalized specification of the types for the next generation API.

## Parameters
<table class="bordered">
<thead>
<tr>
<th>Type</th>
<th>Specification</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>DriveSpec_t</code>
Uniquely identifies a storage volume for use as a drive for a virtual machine
</td>
<td>
<pre>{ spUUID, sdUUID, imgUUID, volUUID }  # Standard UUID quartet</pre>
or
<pre>{ GUID }  # Device mapper GUID</pre>
or
<pre>{ UUID }  # blkid-based UUID</pre>
</td>
</tr>
<tr>
<td>
<code>HibernationVolumeHandle_t</code>

Bundles together the storage resources that are needed for hibernation operations
</td>
<td>
<pre>{
  sdUUID         # Storage domain that contains the state and param volumes
  spUUID         # Storage pool
  stateImageID   # Image UUID for VM state
  stateVolumeID  # Volume UUID for VM state
  paramImageID   # Image UUID for hibernation parameters
  paramVolumeID  # Volume UUID for hibernation parameters
}</pre>
</td>
</tr>
<tr>
<td>
<code>VM_Create_t</code>

Contains all parameters needed to create a new virtual machine
</td>
<td>
<pre>{
  'vmName'         # Set the name of the virtual machine. String.
  'vmId'           # The virtual machine UUID.
  'hiberVolHandle' # An optional HibernationVolumeHandle_t for resuming a hibernated VM
                   # A comma-separated list: sdUUID,spUUID,stateImageID,stateVolumeID,paramImageID,paramVolumeID
  'restoreState'   # A volume containing migration restore data. DriveSpec_t
  'memSize'        # The desired amount of memory (in megabytes)
  'display'        # The type of display.  String: 'qxl', 'vnc', 'qxlnc', 'local'
  'displayNetwork' # Limit display to specific host network.  Bridge name. Default: 0 (listen on all interfaces)
  'spiceMonitors'  # The number of monitors to add to a VM (spice only).  Default: 1
  'keyboardLayout' # Specify the keymap to use.
  'boot'           # The desired boot device. String: 'a', 'c', 'd', 'n'
  'vmType'         # The type of VM to create.  String: 'kvm'
  'floppy'         # Set the floppy disk volume. DriveSpec_t
  'volatileFloppy' # The floppy is temporary and should be ejected and deleted on shutdown or reboot.
  'cdrom'          # Set the cdrom volume. DriveSpec_t
  'sysprepInf'     # Create a sysprep floppy from an inf file for automatic Windows installation. Binary data.
  'nicModel'       # A comma-separated list of nic models to use, one per desired network device.
                   # String: 'ne2k_pci', 'i82551', 'i82557b', 'i82559er', 'rtl8139', 'e1000', 'pcnet', 'virtio'
  'macAddr'        # A comma-separated list of mac addresses to use, one per desired network device.
  'bridge'         # A comma-separated list of host bridge names, one per desired network device.
                   # Each device will be connected to the corresponding host network.
  'smp'            # The number of desired vcpus.
  'cpuType'        # Set cpu type and features.  Comma-separated list with the following specification:
                   # &lt;cpuType&gt;,&lt;feature-1&gt;,&lt;feature-2&gt;,...&lt;feature-N&gt;
                   # Default cpuType: 'qemu64'.  See libvirt documentation for full details on cpu types and features.
  'smpCoresPerSocket' # CPU topology.  The number of cores on each vcpu
  'smpThreadsPerCore' # CPU topology.  The number of threads on each vcpu core
  'drives'         # An array of dicts with the following specification:
                   # {
                   #   'if'       - Drive interface type. String: 'ide', 'virtio'
                   #   'serial'   - Optional drive serial number. String.
                   #   'poolID'   - Storage pool UUID
                   #   'domainID' - Storage domain UUID
                   #   'imageID'  - Image UUID
                   #   'volumeID' - Volume UUID
                   # }
  'tabletEnable'   # Should the USB tablet be used for input? Boolean.
  'soundDevice'    # Add a sound card with the given model.  String: 'pcspk', 'sb16', 'ac97', 'es1370', 'hda'
  'vmchannel'      # Create a channel device for guest agent communication? Boolean.
  'nice'           # Set nice value of the qemu process. Integer: -20..19
  'timeOffset'     # Clock offset from UTC (in seconds)
  'tdf'            # Use an RTC timer with a 'catchup' tick policy? Boolean.
  'emulatedMachine'# The machine type to emulate.  String.  Default: 'pc'.
  'initrd'         # Enable direct-boot from host using this file for the initrd.  Local path.
  'kernel'         # Enable direct-boot from host using this file for the kernel.  Local path.
  'kernelArgs'     # When direct-boot is enabled, pass these arguments to the kernel. String.
  'acpiEnable'     # Enable ACPI in the guest? Boolean.
  # The following 'custom' fields are also recognized: vhost, sndbuf, viodiskcache
}
</pre>

This list does not include internal state variables or fields that may be inserted to activate special modes
such as restore, migration or hibernation.  ''These should be added later in a special section.''
</td>
</tr>
<tr>
<td>
<code>VM_Migrate_t</code>

Contains the parameters needed to migrate an existing domain to another host
</td>
<td>
<pre>{
  'vmId'           # The UUID of the VM to migrate
  'mode'           # String: 'remote' or 'file'
  'method'         # String: 'online'
  'dst'            # String: &lt;host&gt;:&lt;port&gt;
  'hiberVolHandle' # (Only for hibernate) HibernationVolumeHandle_t for saving state to file 
  'downtime'       # The maximum amount of allowed downtime during migration
}</pre>
</td>
</tr>
<tr>
<td>
<code>VM_SetTicket_ExistingConnAction_t</code>

Describes how to handle an existing vm display connection when establishing a new connection.
</td>
<td>
String:
<pre>
'keep'        # Allow the current user to remain connected
'disconnect'  # Disconnect the current user
'fail'        # Abort the operation
</pre>
</td>
</tr>
<tr>
<td>
<code>Volume_Type_t</code>

Specifies whether a volume is preallocated or sparse
</td>
<td>
<pre>
  PREALLOCATED  # All needed storage for the volume is allocated at volume creation time
  SPARSE        # Storage is allocated dynamically as more space is required
</pre>
</td>
</tr>
<tr>
<td>
<code>Volume_Format_t</code>

The file data format
</td>
<td>
<pre>
  COW_FORMAT  # The qemu COW format is specified
  RAW_FORMAT  # The raw format is specified
</pre>
</td>
</tr>
<tr>
<td>
<code>Volume_Legality_t</code>

Indicates the legality of the volume
</td>
<td>
<pre>
  ILLEGAL_VOL
  LEGAL_VOL
  FAKE_VOL
</pre>
</td>
</tr>
<tr>
<td>
<code>Image_MoveOperation_t</code>

Specify the type of image move operation that is desired
</td>
<td>
<pre>
  COPY_OP
  MOVE_OP
</pre>
</td>
</tr>
<tr>
<td>
<code>LVM_Create_DeviceList_t</code>

A list of device names to include when creating a new LVM volume group
</td>
<td>
<pre>
[ "sda1", "sdb3" ... ]
</pre>
</td>
</tr>
<tr>
<td>
<code>ISCSI_ConnectParams_t</code>

A dictionary of iSCSI connection information
</td>
<td>
<pre>{
  'connection' # iSCSI host IP address
  'port'       # iSCSI host port
  'user'       # Login user
  'password'   # Login password
}</pre>
</td>
</tr>
<tr>
<td>
<code>StorageDomain_Type_t</code>

Identifies the type of backing storage that is used by the domain
</td>
<td>
<pre>
  UNKNOWN_DOMAIN = 0
  NFS_DOMAIN = 1
  FCP_DOMAIN = 2
  ISCSI_DOMAIN = 3
  LOCALFS_DOMAIN = 4
  CIFS_DOMAIN = 5
</pre>
</td>
</tr>
<tr>
<td>
<code>StorageDomain_Create_TypeParameters_t</code>

Storage Domain type-specific creation parameters
</td>
<td>''For FCP and iSCSI domains:''
<pre>
  vgUUID      # The UUID of the volume group to be used
</pre>
''For NFS domains:''
<pre>
  remotePath  # The path to the remote NFS exported filesystem (&lt;host&gt;:/&lt;path&gt;)
</pre>
''For LOCALFS domains:''
<pre>
  localPath  # The local path to use (eg. /var/localstorage)
</pre>
</td>
</tr>
<tr>
<td>
<code>StorageDomain_Class_t</code>

Identifies the nature/class of data that will be stored in the domain
</td>
<td>
<pre>
  DATA_DOMAIN = 1
  ISO_DOMAIN = 2
  BACKUP_DOMAIN = 3
</pre>
</td>
</tr>
<tr>
<td>
<code>StorageDomain_UploadVolume_Method_t</code>

Designates the upload method to be used for StorageDomain.UploadVolume
</td>
<td>
<pre>
  'rsync'  # Use the rsync program
  'wget'   # Use the wget program
</pre>
</td>
</tr>
<tr>
<td>
<code>StorageConnectionParameters_t</code>

Parameters needed for connecting to different kinds of storage
</td>
<td>
''For NFS, LocalFS, and CIFS storage:''
<pre>{
  'id'          # Used to identify this connection in the return value
  'connection'  # For NFS:     &lt;host&gt;:/&lt;path&gt;
                # For LocalFS: &lt;local path&gt;
                # For CIFS:    Not supported
}</pre>
''For FCP and iSCSI storage:''
<pre>{
  'id'             # Used to identify this connection in the return value
  'connection'     # The IP address of the iSCSI server
  'iqn'            # The iSCSI target
  'portal'         # Unused
  'user'           # iSCSI server username
  'password'       # iSCSI server password
  'port'           # iSCSI server host port
  'initiatorName'  # iSCSI initiator
}</pre>
</td>
</tr>
<tr>
<td>
<code>StoragePool_ImageMoveList_t</code>

Defines a list of images to move along with per-image parameters
</td>
<td>
<pre>[
  { imgUUID: &lt;postZero&gt; } # postZero is a boolean to set whether source
                          # images should be zeroed after data has been moved
]
</pre>
</td>
</tr>
<tr>
<td>
<code>StorageDomainStatus_t</code>

The current status of a StorageDomain
</td>
<td>
<pre>
  DOM_UNKNOWN_STATUS = 'Unknown'
  DOM_ATTACHED_STATUS = 'Attached'
  DOM_UNATTACHED_STATUS = 'Unattached'
  DOM_ACTIVE_STATUS = 'Active'
</pre>
</td>
</tr>
<tr>
<td>
<code>StoragePool_ReconstructDomainDict_t</code>

A dictionary of sdUUIDs and status used to reconstruct the master StorageDomain
</td>
<td>
<pre>{ &lt;sdUUID&gt;: &lt;status&gt; } # Where status is a StorageDomainStatus_t</pre>
</td>
</tr>
<tr>
<td>
<code>StoragePool_UpdateVMsList_t</code>

A list of VM metadata to store/update
</td>
<td>
<pre>[
  {
    'vm'       # The VM UUID
    'ovf':     # The VM definition in OVF format
    'imglist'  # A comma-separated list of imgUUIDs
  }
]</pre>
</td>
</tr>
<tr>
<td>
<code>FenceNode_Agent_t</code>

Select the agent to use from the fence-agents project
</td>
<td>
''See the fence-agents documentation for details.  Possible values are:''
<pre>
ack_manual     alom           apc            apc_snmp       baytech        bladecenter
brocade        bullpap        cisco_mds      cisco_ucs      cpint          drac
drac5          eaton_snmp     egenera        eps            ibmblade       ifmib
ilo            ilo_mp         intelmodular   ipmilan        kdump          kdump_send
ldom           lpar           mcdata         na             nss_wrapper    rackswitch
rhevm          rsa            rsb            sanbox2        scsi           virsh
vixel          vmware         vmware_helper  vmware_soap    wti            xcat
xenapi         zvm
</pre>
</td>
</tr>
<tr>
<td>
<code>FenceNode_Action_t</code>

Selects the fencing action to perform
</td>
<td>
<pre>
  'status'
  'on'
  'off'
  'reboot'
</pre>
</td>
</tr>
<tr>
<td>
<code>SetupNetworks_Params_t</code>

Structure to provide complete network setup information
</td>
<td>
<pre>
networks - dict of key=network, value=attributes
           where 'attributes' is a dict with the following optional items:
                vlan=&lt;id&gt;
                bonding="&lt;name&gt;" | nic="&lt;name&gt;"
                (bonding and nics are mutually exclusive)
                ipaddr="&lt;ip&gt;"
                netmask="&lt;ip&gt;"
                gateway="&lt;ip&gt;"
                bootproto="..."
                delay="..."
                onboot="yes"|"no"
                (other options will be passed to the config file AS-IS)
           -- OR --
                remove=True (other attributes can't be specified)

bondings - dict of key=bonding, value=attributes
           where 'attributes' is a dict with the following optional items:
                nics=["&lt;nic1&gt;" , "&lt;nic2&gt;", ...]
                options="&lt;bonding-options&gt;"
            -- OR --
                remove=True (other attributes can't be specified)

options - dict of options, such as:
                force=0|1
                connectivityCheck=0|1
                connectivityTimeout=&lt;int&gt;
                explicitBonding=0|1


Notes:
    Bondings are removed when they change state from 'used' to 'unused'.

    By default, if you edit a network that is attached to a bonding, it's not
    necessary to re-specify the bonding (you need only to note the attachement
    in the network's attributes). Similarly, if you edit a bonding, it's not
    necessary to specify its networks.
    However, if you specify the 'explicitBonding' option as true, the function
    will expect you to specify all networks that are attached to a specified
    bonding, and vice-versa, the bonding attached to a specified network.
</pre>
</td>
</tr>
</tbody>
</table>


## Return Data

All API calls return a dictionary with this basic format:

```json
    {
      'status': { 'code': <integer>, 'message': <string> },
      ... Function-specific fields ...
    }
```

This table describes the function-specific fields that appear in certain API calls.

| Type | Specification |
|------|---------------|
|      |               |

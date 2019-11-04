---
title: Working with Gluster Storage
---

# Chapter 9: Working with Gluster Storage

## Gluster Storage Nodes

### Adding Gluster Storage Nodes

Add Gluster Storage nodes to Gluster-enabled clusters and incorporate GlusterFS volumes and bricks into your oVirt environment.

This procedure presumes that you have a Gluster-enabled cluster of the appropriate **Compatibility Version** and a Gluster Storage node already set up.

**Adding a Gluster Storage Node**

1. Click the **Hosts** resource tab to list the hosts in the results list.

2. Click **New** to open the **New Host** window.

3. Use the drop-down menus to select the **Data Center** and **Host Cluster** for the Gluster Storage node.

4. Enter the **Name**, **Address**, and **SSH Port** of the Gluster Storage node.

5. Select an authentication method to use with the Gluster Storage node.

    * Enter the root user's password to use password authentication.

    * Copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_keys` on the Gluster Storage node to use public key authentication.

6. Click **OK** to add the node and close the window.

You have added a Gluster Storage node to your oVirt environment. You can now use the volume and brick resources of the node in your environment.

### Removing a Gluster Storage Node

Remove a Gluster Storage node from your oVirt environment.

**Removing a Gluster Storage Node**

1. Use the **Hosts** resource tab, tree mode, or the search function to find and select the Gluster Storage node in the results list.

2. Click **Maintenance** to open the **Maintenance Host(s)** confirmation window.

3. Click **OK** to move the host to maintenance mode.

4. Click **Remove** to open the **Remove Host(s)** confirmation window.

5. Select the **Force Remove** check box if the node has volume bricks on it, or if the node is non-responsive.

6. Click **OK** to remove the node and close the window.

Your Gluster Storage node has been removed from the environment and is no longer visible in the **Hosts** tab.

## Using Gluster Storage as a Storage Domain

### Introduction to Gluster Storage (GlusterFS) Volumes

Gluster Storage volumes combine storage from more than one Gluster Storage server into a single global namespace. A volume is a collection of bricks, where each brick is a mountpoint or directory on a Gluster Storage Server in the trusted storage pool.

Most of the management operations of Gluster Storage happen on the volume.

You can use the Administration Portal to create and start new volumes. You can monitor volumes in your Gluster Storage cluster from the **Volumes** tab.

While volumes can be created and managed from the Administration Portal, bricks must be created on the individual Gluster Storage nodes before they can be added to volumes using the Administration Portal

### Gluster Storage Terminology

**Data Center Properties**

<table>
 <thead>
  <tr>
   <td>Term</td>
   <td>Definition</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Brick</b></td>
   <td>
    <p>A brick is the GlusterFS basic unit of storage, represented by an export directory on a server in the trusted storage pool. A Brick is expressed by combining a server with an export directory in the following format:</p>
    <p><tt>SERVER:EXPORT</tt></p>
    <p>For example:</p>
    <p><tt>myhostname:/exports/myexportdir/</tt></p>
   </td>
  </tr>
  <tr>
   <td><b>Block Storage</b></td>
   <td>Block special files or block devices correspond to devices through which the system moves data in the form of blocks. These device nodes often represent addressable devices such as hard disks, CD-ROM drives, or memory-regions. Gluster Storage supports XFS file system with extended attributes.</td>
  </tr>
  <tr>
   <td><b>Cluster</b></td>
   <td>A trusted pool of linked computers, working together closely thus in many respects forming a single computer. In Gluster Storage terminology a cluster is called a trusted storage pool.</td>
  </tr>
  <tr>
   <td><b>Client</b></td>
   <td>The machine that mounts the volume (this may also be a server).</td>
  </tr>
  <tr>
   <td><b>Distributed File System</b></td>
   <td>A file system that allows multiple clients to concurrently access data spread across multiple servers/bricks in a trusted storage pool. Data sharing among multiple locations is fundamental to all distributed file systems.</td>
  </tr>
  <tr>
   <td><b>Geo-Replication</b></td>
   <td>Geo-replication provides a continuous, asynchronous, and incremental replication service from site to another over Local Area Networks (LAN), Wide Area Network (WAN), and across the Internet.</td>
  </tr>
  <tr>
   <td><b>glusterd</b></td>
   <td>The Gluster management daemon that needs to run on all servers in the trusted storage pool.</td>
  </tr>
  <tr>
   <td><b>Metadata</b></td>
   <td>Metadata is data providing information about one or more other pieces of data.</td>
  </tr>
  <tr>
   <td><b>N-way Replication</b></td>
   <td>Local synchronous data replication typically deployed across campus or Amazon Web Services Availability Zones.</td>
  </tr>
  <tr>
   <td><b>Namespace</b></td>
   <td>Namespace is an abstract container or environment created to hold a logical grouping of unique identifiers or symbols. Each Gluster Storage trusted storage pool exposes a single namespace as a POSIX mount point that contains every file in the trusted storage pool.</td>
  </tr>
  <tr>
   <td><b>POSIX</b></td>
   <td>Portable Operating System Interface (for Unix) is the name of a family of related standards specified by the IEEE to define the application programming interface (API), along with shell and utilities interfaces for software compatible with variants of the UNIX operating system. Gluster Storage exports a fully POSIX compatible file system.</td>
  </tr>
  <tr>
   <td><b>RAID</b></td>
   <td>Redundant Array of Inexpensive Disks (RAID) is a technology that provides increased storage reliability through redundancy, combining multiple low-cost, less-reliable disk drives components into a logical unit where all drives in the array are interdependent.</td>
  </tr>
  <tr>
   <td><b>RRDNS</b></td>
   <td>Round Robin Domain Name Service (RRDNS) is a method to distribute load across application servers. RRDNS is implemented by creating multiple A records with the same name and different IP addresses in the zone file of a DNS server.</td>
  </tr>
  <tr>
   <td><b>Server</b></td>
   <td>The machine (virtual or bare-metal) that hosts the actual file system in which data will be stored.</td>
  </tr>
  <tr>
   <td><b>Scale-Up Storage</b></td>
   <td>Increases the capacity of the storage device, but only in a single dimension. An example might be adding additional disk capacity to a single computer in a trusted storage pool.</td>
  </tr>
  <tr>
   <td><b>Scale-Out Storage</b></td>
   <td>Increases the capability of a storage device in multiple dimensions. For example adding a server to a trusted storage pool increases CPU, disk capacity, and throughput for the trusted storage pool.</td>
  </tr>
  <tr>
   <td><b>Subvolume</b></td>
   <td>A subvolume is a brick after being processed by at least one translator.</td>
  </tr>
  <tr>
   <td><b>Translator</b></td>
   <td>A translator connects to one or more subvolumes, does something with them, and offers a subvolume connection.</td>
  </tr>
  <tr>
   <td><b>Trusted Storage Pool</b></td>
   <td>A storage pool is a trusted network of storage servers. When you start the first server, the storage pool consists of that server alone.</td>
  </tr>
  <tr>
   <td><b>User Space</b></td>
   <td>Applications running in user space do not directly interact with hardware, instead using the kernel to moderate access. User Space applications are generally more portable than applications in kernel space. Gluster is a user space application.</td>
  </tr>
  <tr>
   <td><b>Virtual File System (VFS)</b></td>
   <td>VFS is a kernel software layer that handles all system calls related to the standard Linux file system. It provides a common interface to several kinds of file systems.</td>
  </tr>
  <tr>
   <td><b>Volume File</b></td>
   <td>The volume file is a configuration file used by GlusterFS process. The volume file will usually be located at: <tt>/var/lib/glusterd/vols/VOLNAME</tt>.</td>
  </tr>
  <tr>
   <td><b>Volume</b></td>
   <td>A volume is a logical collection of bricks. Most of the Gluster management operations happen on the volume.</td>
  </tr>
 </tbody>
</table>

# Attaching a Gluster Storage Volume as a Storage Domain

Add a Gluster Storage volume to the oVirt Engine to be used directly as a storage domain. This differs from adding a Red Hat Storage Gluster node, which enables control over the volumes and bricks of the node from within the oVirt Engine, and does not require a Gluster-enabled cluster.

The host requires the `glusterfs`, `glusterfs-fuse`, and `glusterfs-cli` packages to be installed in order to mount the volume. The `glusterfs-cli` package is available from the `rh-common-rpms` channel on the Customer Portal.

**Adding a Gluster Storage Volume as a Storage Domain**

1. Click the **Storage** resource tab to list the existing storage domains in the results list.

2. Click **New Domain** to open the **New Domain** window.

    **Gluster Storage**

    ![](/images/admin-guide/Adding_Red_Hat_Gluster_Storage.png)

3. Enter the **Name** for the storage domain.

4. Select the **Data Center** to be associated with the storage domain.

5. Select `Data` from the **Domain Function** drop-down list.

6. Select `GlusterFS` from the **Storage Type** drop-down list.

7. Select a host from the **Use Host** drop-down list. Only hosts within the selected data center will be listed. To mount the volume, the host that you select must have the `glusterfs` and `glusterfs-fuse` packages installed.

8. In the **Path** field, enter the IP address or FQDN of the Gluster Storage server and the volume name separated by a colon.

9. Enter additional **Mount Options**, as you would normally provide them to the `mount` command using the `-o` argument. The mount options should be provided in a comma-separated list. See `man mount` for a list of valid mount options.

10. Optionally, you can configure the advanced parameters.

    1. Click **Advanced Parameters**.

    2. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    3. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    4. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

11. Click **OK** to mount the volume as a storage domain and close the window.

### Creating a Storage Volume

You can create new volumes using the Administration Portal. When creating a new volume, you must specify the bricks that comprise the volume and specify whether the volume is to be distributed, replicated, or striped.

You must create brick directories or mountpoints before you can add them to volumes.

**Important:** It is recommended that you use replicated volumes, where bricks exported from different hosts are combined into a volume. Replicated volumes create copies of files across multiple bricks in the volume, preventing data loss when a host is fenced.

**Creating A Storage Volume**

1. Click the **Volumes** resource tab to list existing volumes in the results list.

2. Click **New** to open the **New Volume** window.

3. Use the drop-down menus to select the **Data Center** and **Volume Cluster**.

4. Enter the **Name** of the volume.

5. Use the drop-down menu to select the **Type** of the volume.

6. If active, select the appropriate **Transport Type** check box.

7. Click the **Add Bricks** button to select bricks to add to the volume. Bricks must be created externally on the Gluster Storage nodes.

8. If active, use the **Gluster**, **NFS**, and **CIFS** check boxes to select the appropriate access protocols used for the volume.

9. Enter the volume access control as a comma-separated list of IP addresses or hostnames in the **Allow Access From** field.

    You can use the * wildcard to specify ranges of IP addresses or hostnames.

10. Select the **Optimize for Virt Store** option to set the parameters to optimize your volume for virtual machine storage. Select this if you intend to use this volume as a storage domain.

11. Click **OK** to create the volume. The new volume is added and displays on the **Volume** tab.

You have added a Gluster Storage volume. You can now use it for storage.

### Adding Bricks to a Volume

**Summary**

You can expand your volumes by adding new bricks. You need to add at least one brick to a distributed volume, multiples of two bricks to replicated volumes, and multiples of four bricks to striped volumes when expanding your storage space.

**Adding Bricks to a Volume**

1. On the **Volumes** tab on the navigation pane, select the volume to which you want to add bricks.

2. Click the **Bricks** tab from the Details pane.

3. Click **Add Bricks** to open the **Add Bricks** window.

4. Use the **Server** drop-down menu to select the server on which the brick resides.

5. Enter the path of the **Brick Directory**. The directory must already exist.

6. Click **Add**. The brick appears in the list of bricks in the volume, with server addresses and brick directory names.

7. Click **OK**.

**Result**

The new bricks are added to the volume and the bricks display in the volume's **Bricks** tab.

### Explanation of Settings in the Add Bricks Window

**Add Bricks Tab Properties**

| Field Name | Description |
|-
| **Volume Type** | Displays the type of volume. This field cannot be changed; it was set when you created the volume. |
| **Server** | The server where the bricks are hosted. |
| **Brick Directory** | The brick directory or mountpoint. |

### Optimizing Gluster Storage Volumes to Store Virtual Machine Images

Optimize a Gluster Storage volume to store virtual machine images using the Administration Portal.

To optimize a volume for storing virtual machines, the Engine sets a number of virtualization-specific parameters for the volume.

Volumes can be optimized to store virtual machines during creation by selecting the **Optimize for Virt Store** check box, or after creation using the **Optimize for Virt Store** button from the **Volumes** resource tab.

**Important:** If a volume is replicated across three or more nodes, ensure the volume is optimized for virtual storage to avoid data inconsistencies across the nodes.


### Options set on Gluster Storage Volumes to Store Virtual Machine Images

Once **Optimize for Virt Store** is selected on a gluster volumes below options are set on the volume

  * Options from group **virt**. Volume Options that are tuned for a use-case are packaged in a file so that it can be applied as a single group. This sets the `cluster.quorum-type` parameter to `auto`, and the `cluster.server-quorum-type` parameter to `server` and other options (like enabling shard) to ensure the volume is optimized to store virtual image files. For complete list of options set in a particular release of gluster, see [group-virt](https://github.com/gluster/glusterfs/blob/master/extras/group-virt.example)
  * performance.strict-o-direct on *Ensure that write-behind honours O_DIRECT flags.When this option is enabled and a file descriptor is opened using the O_DIRECT flag, write-back caching is disabled for writes that affect that file descriptor.*
  * network.remote-dio off *filters _ O_DIRECT flags in open/create calls before sending those requests to server. Set to off to ensure all o-direct I/O is passed to brick*
  * storage.owner-uid 36 *Sets the UID for the bricks of the volume to vdsm userid*
  * storage.owner-gid 36 *Sets the GID for the bricks of the volume to kvm group id*
  * network.ping-timeout 30 *time duration for which the client waits to check if the server is responsive*

An alternate method is to access one of the Gluster Storage nodes and set the volume group to `virt` and the options provided below via CLI.

    # gluster volume set VOLUME_NAME group virt
    # gluster volume set VOLUME_NAME performance.strict-o-direct on
    # gluster volume set VOLUME_NAME network.remote-dio off
    # gluster volume set VOLUME_NAME storage.owner-uid 36
    # gluster volume set VOLUME_NAME storage.owner-gid 36
    # gluster volume set VOLUME_NAME network.ping-timeout 30

Verify the status of the volume by listing the volume information. This will display the options set on the volume and the state:

    # gluster volume info VOLUME_NAME all

### Starting Volumes

**Summary**

After a volume has been created or an existing volume has been stopped, it needs to be started before it can be used.

**Starting Volumes**

1. In the **Volumes** tab, select the volume to be started.

    You can select multiple volumes to start by using `Shift` or `Ctrl` key.

2. Click the **Start** button.

The volume status changes to `Up`.

**Result**

You can now use your volume for virtual machine storage.

### Tuning Volumes

**Summary**

Tuning volumes allows you to affect their performance. To tune volumes, you add options to them.

**Tuning Volumes**

1. Click the **Volumes** tab.

    A list of volumes displays.

2. Select the volume that you want to tune, and click the **Volume Options** tab from the Details pane.

    The **Volume Options** tab displays a list of options set for the volume.

3. Click **Add** to set an option. The **Add Option** dialog box displays. Select the Option Key from the drop down list and enter the option value.

4. Click **OK**.

    The option is set and displays in the **Volume Options** tab.

**Result**

You have tuned the options for your storage volume.

### Editing Volume Options

**Summary**

You have tuned your volume by adding options to it. You can change the options for your storage volume.

**Editing Volume Options**

1. Click the **Volumes** tab.

    A list of volumes displays.

2. Select the volume that you want to edit, and click the **Volume Options** tab from the Details pane.

    The **Volume Options** tab displays a list of options set for the volume.

3. Select the option you want to edit. Click **Edit**. The **Edit Option** dialog box displays. Enter a new value for the option.

4. Click **OK**.

    The edited option displays in the **Volume Options** tab.

**Result**

You have changed the options on your volume.

### Reset Volume Options

**Summary**

You can reset options to revert them to their default values.

1. Click the **Volumes** tab.

    A list of volumes displays.

2. Select the volume and click the **Volume Options** tab from the Details pane.

    The **Volume Options** tab displays a list of options set for the volume.

3. Select the option you want to reset. Click **Reset**. A dialog box displays, prompting to confirm the reset option.

4. Click **OK**.

    The selected option is reset.

**Note:** You can reset all volume options by clicking **Reset All** button. A dialog box displays, prompting to confirm the reset option. Click **OK**. All volume options are reset for the selected volume.

**Result**

You have reset volume options to default.

### Removing Bricks from a Volume

**Summary**

You can shrink volumes, as needed, while the cluster is online and available. For example, you might need to remove a brick that has become inaccessible in a distributed volume due to hardware or network failure.

**Removing Bricks from a Volume**

1. On the **Volumes** tab on the navigation pane, select the volume from which you wish to remove bricks.

2. Click the **Bricks** tab from the Details pane.

3. Select the bricks you wish to remove. Click **Remove Bricks**.

4. A window opens, prompting to confirm the deletion. Click **OK** to confirm.

**Result**

The bricks are removed from the volume.

### Stopping Gluster Storage Volumes

After a volume has been started, it can be stopped.

**Stopping Volumes**

1. In the **Volumes** tab, select the volume to be stopped.

    You can select multiple volumes to stop by using `Shift` or `Ctrl` key.

2. Click **Stop**.

### Deleting Gluster Storage Volumes

You can delete a volume or multiple volumes from your cluster.

1. In the **Volumes** tab, select the volume to be deleted.

2. Click **Remove**. A dialog box displays, prompting to confirm the deletion. Click **OK**.

### Rebalancing Volumes

**Summary**

If a volume has been expanded or shrunk by adding or removing bricks to or from that volume, the data on the volume must be rebalanced amongst the servers.

**Rebalancing a Volume**

1. Click the **Volumes** tab.

    A list of volumes displays.

2. Select the volume to rebalance.

3. Click **Rebalance**.

**Result**

The selected volume is rebalanced.

## Clusters and Gluster Hooks

### Managing Gluster Hooks

Gluster hooks are volume life cycle extensions. You can manage Gluster hooks from the Engine. The content of the hook can be viewed if the hook content type is **Text**.

Through the Engine, you can perform the following:

* View a list of hooks available in the hosts.

* View the content and status of hooks.

* Enable or disable hooks.

* Resolve hook conflicts.

### Listing Hooks

**Summary**

List the Gluster hooks in your environment.

**Listing a Hook**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

**Result**

You have listed the Gluster hooks in your environment.

### Viewing the Content of Hooks

**Summary**

View the content of a Gluster hook in your environment.

**Viewing the Content of a Hook**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select a hook with content type **Text** and click the **View Content** button to open the **Hook Content** window.

**Result**

You have viewed the content of a hook in your environment.

### Enabling or Disabling Hooks

**Summary**

Toggle the activity of a Gluster hook by enabling or disabling it.

**Enabling or Disabling a Hook**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select a hook and click one of the **Enable** or **Disable** buttons. The hook is enabled or disabled on all nodes of the cluster.

**Result**

You have toggled the activity of a Gluster hook in your environment.

### Refreshing Hooks

**Summary**

By default, the Engine checks the status of installed hooks on the engine and on all servers in the cluster and detects new hooks by running a periodic job every hour. You can refresh hooks manually by clicking the **Sync** button.

**Refreshing a Hook**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Click the **Sync** button.

** Result**

The hooks are synchronized and updated in the details pane.

### Resolving Conflicts

The hooks are displayed in the **Gluster Hooks** sub-tab of the **Cluster** tab. Hooks causing a conflict are displayed with an exclamation mark. This denotes either that there is a conflict in the content or the status of the hook across the servers in the cluster, or that the hook script is missing in one or more servers. These conflicts can be resolved via the Engine. The hooks in the servers are periodically synchronized with engine database and the following conflicts can occur for the hooks:

* Content Conflict - the content of the hook is different across servers.

* Missing Conflict - one or more servers of the cluster do not have the hook.

* Status Conflict - the status of the hook is different across servers.

* Multiple Conflicts - a hook has a combination of two or more of the aforementioned conflicts.

# Resolving Content Conflicts

**Summary**

A hook that is not consistent across the servers and engine will be flagged as having a conflict. To resolve the conflict, you must select a version of the hook to be copied across all servers and the engine.

**Resolving a Content Conflict**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select the conflicting hook and click the **Resolve Conflicts** button to open the **Resolve Conflicts** window.

4. Select the engine or a server from the list of sources to view the content of that hook and establish which version of the hook to copy.

    **Note:** The content of the hook will be overwritten in all servers and in the engine.

5. Use the **Use content from** drop-down menu to select the preferred server or the engine.

6. Click **OK** to resolve the conflict and close the window.

**Result**

The hook from the selected server is copied across all servers and the engine to be consistent across the environment.

### Resolving Missing Hook Conflicts

**Summary**

A hook that is not present on all the servers and the engine will be flagged as having a conflict. To resolve the conflict, either select a version of the hook to be copied across all servers and the engine, or remove the missing hook entirely.

**Resolving a Missing Hook Conflict**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select the conflicting hook and click the **Resolve Conflicts** button to open the **Resolve Conflicts** window.

4. Select any source with a status of **Enabled** to view the content of the hook.

5. Select the appropriate radio button, either **Copy the hook to all the servers** or **Remove the missing hook**. The latter will remove the hook from the engine and all servers.

6. Click **OK** to resolve the conflict and close the window.

** Result**

Depending on your chosen resolution, the hook has either been removed from the environment entirely, or has been copied across all servers and the engine to be consistent across the environment.

### Resolving Status Conflicts

**Summary**

A hook that does not have a consistent status across the servers and engine will be flagged as having a conflict. To resolve the conflict, select a status to be enforced across all servers in the environment.

**Resolving a Status Conflict**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select the conflicting hook and click the **Resolve Conflicts** button to open the **Resolve Conflicts** window.

4. Set **Hook Status** to **Enable** or **Disable**.

5. Click **OK** to resolve the conflict and close the window.

**Result**

The selected status for the hook is enforced across the engine and the servers to be consistent across the environment.

### Resolving Multiple Conflicts

**Summary**

A hook may have a combination of two or more conflicts. These can all be resolved concurrently or independently through the **Resolve Conflicts** window. This procedure will resolve all conflicts for the hook so that it is consistent across the engine and all servers in the environment.

**Resolving Multiple Conflicts**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select the conflicting hook and click the **Resolve Conflicts** button to open the **Resolve Conflicts** window.

4. Choose a resolution to each of the affecting conflicts, as per the appropriate procedure.

5. Click **OK** to resolve the conflicts and close the window.

** Result**

You have resolved all of the conflicts so that the hook is consistent across the engine and all servers.

### Managing Gluster Sync

The Gluster Sync feature periodically fetches the latest cluster configuration from GlusterFS and syncs the same with the engine DB. This process can be performed through the Engine. When a cluster is selected, the user is provided with the option to import hosts or detach existing hosts from the selected cluster. You can perform Gluster Sync if there is a host in the cluster.

**Note:** The Engine continuously monitors if hosts are added to or removed from the storage cluster. If the addition or removal of a host is detected, an action item is shown in the **General** tab for the cluster, where you can either to choose to **Import** the host into or **Detach** the host from the cluster.

**Prev:** [Chapter 8: Storage](chap-Storage)<br>
**Next:** [Chapter 10: Pools](chap-Pools)

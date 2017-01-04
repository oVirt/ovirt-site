# Gluster Storage Terminology

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
   <td>Block special files or block devices correspond to devices through which the system moves data in the form of blocks. These device nodes often represent addressable devices such as hard disks, CD-ROM drives, or memory-regions. Red Hat Gluster Storage supports XFS file system with extended attributes.</td>
  </tr>
  <tr>
   <td><b>Cluster</b></td>
   <td>A trusted pool of linked computers, working together closely thus in many respects forming a single computer. In Red Hat Gluster Storage terminology a cluster is called a trusted storage pool.</td>
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
   <td>Namespace is an abstract container or environment created to hold a logical grouping of unique identifiers or symbols. Each Red Hat Gluster Storage trusted storage pool exposes a single namespace as a POSIX mount point that contains every file in the trusted storage pool.</td>
  </tr> 
  <tr>
   <td><b>POSIX</b></td>
   <td>Portable Operating System Interface (for Unix) is the name of a family of related standards specified by the IEEE to define the application programming interface (API), along with shell and utilities interfaces for software compatible with variants of the UNIX operating system. Red Hat Gluster Storage exports a fully POSIX compatible file system.</td>
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
   <td>The machine (virtual or bare-metal) which hosts the actual file system in which data will be stored.</td>
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

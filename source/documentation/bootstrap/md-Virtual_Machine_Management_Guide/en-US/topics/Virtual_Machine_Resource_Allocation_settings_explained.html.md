# Virtual Machine Resource Allocation Settings Explained

The following table details the options available on the **Resource Allocation** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Resource Allocation Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Sub-element</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>CPU Allocation</b></td>
   <td><b>CPU Profile</b></td>
   <td>The CPU profile assigned to the virtual machine. CPU profiles define the maximum amount of processing capability a virtual machine can access on the host on which it runs, expressed as a percent of the total processing capability available to that host. CPU profiles are defined on the cluster level based on quality of service entries created for data centers.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>CPU Shares</b></td>
   <td>
    <p>Allows users to set the level of CPU resources a virtual machine can demand relative to other virtual machines.</p>
    <ul>
     <li><b>Low</b> - 512</li>
     <li><b>Medium</b> - 1024</li>
     <li><b>High</b> - 2048</li>
     <li><b>Custom</b> - A custom level of CPU shares defined by the user.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>CPU Pinning topology</b></td>
   <td>
    <p>Enables the virtual machine's virtual CPU (vCPU) to run on a specific physical CPU (pCPU) in a specific host. The syntax of CPU pinning is <tt>v#p[_v#p]</tt>, for example:</p>
    <ul>
     <li><tt>0#0</tt> - Pins vCPU 0 to pCPU 0.</li>
     <li><tt>0#0_1#3</tt> - Pins vCPU 0 to pCPU 0, and pins vCPU 1 to pCPU 3.</li>
     <li><tt>1#1-4,^2</tt> - Pins vCPU 1 to one of the pCPUs in the range of 1 to 4, excluding pCPU 2.</li>
    </ul>
    <p>In order to pin a virtual machine to a host, you must also select the following on the <b>Host</b> tab:</p>
    <ul>
     <li><b>Start Running On:</b> <b>Specific</b></li>
     <li><b>Migration Options:</b> <b>Do not allow migration</b></li>
     <li><b>Pass-Through Host CPU</b></li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Memory Allocation</b></td>
   <td> </td>
   <td>The amount of physical memory guaranteed for this virtual machine.</td>
  </tr>
  <tr>
   <td><b>IO Threads</b></td>
   <td><b>IO Threads Enabled</b></td>
   <td>Enables virtio-blk data plane. Select this check box to improve the speed of disks that have a VirtIO interface by pinning them to a thread separate from the virtual machine's other functions. Improved disk performance increases a virtual machine's overall performance. Disks with VirtIO interfaces are pinned to an IO thread using a round-robin algorithm.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Num Of IO Threads</b></td>
   <td>Optionally enter a number value to create multiple IO threads, up to a maximum value of 127. The default value is 1.</td>
  </tr>
  <tr>
   <td><b>Storage Allocation</b></td>
   <td> </td>
   <td>The <b>Template Provisioning</b> option is only available when the virtual machine is created from a template.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Thin</b></td>
   <td>Provides optimized usage of storage capacity. Disk space is allocated only as it is required.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Clone</b></td>
   <td>Optimized for the speed of guest read and write operations. All disk space requested in the template is allocated at the time of the clone operation.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>VirtIO-SCSI Enabled</b></td>
   <td>Allows users to enable or disable the use of VirtIO-SCSI on the virtual machines.</td>
  </tr>
 </tbody>
</table>

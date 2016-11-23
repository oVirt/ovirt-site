# Virtual Machine Host Settings Explained

The following table details the options available on the **Host** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Host Settings**

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
   <td><b>Start Running On</b></td>
   <td> </td>
   <td>
    <p>Defines the preferred host on which the virtual machine is to run. Select either:</p>
    <ul>
     <li><b>Any Host in Cluster</b> - The virtual machine can start and run on any available host in the cluster.</li>
     <li><b>Specific</b> - The virtual machine will start running on a particular host in the cluster. However, the Manager or an administrator can migrate the virtual machine to a different host in the cluster depending on the migration and high-availability settings of the virtual machine. Select the specific host or group of hosts from the list of available hosts.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Migration Options</b></td>
   <td><b>Migration mode</b></td>
   <td>
    <p>Defines options to run and migrate the virtual machine. If the options here are not used, the virtual machine will run or migrate according to its cluster's policy.</p>
    <ul>
     <li><b>Allow manual and automatic migration</b> - The virtual machine can be automatically migrated from one host to another in accordance with the status of the environment, or manually by an administrator.</li>
     <li><b>Allow manual migration only</b> - The virtual machine can only be migrated from one host to another manually by an administrator.</li>
     <li><b>Do not allow migration</b> - The virtual machine cannot be migrated, either automatically or manually.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Use custom migration policy</b></td>
   <td>
    <p>Defines the migration convergence policy. If the check box is left unselected, the host determines the policy.</p>
    <ul>
     <li><b>Legacy</b> - Legacy behavior of 3.6 version. Overrides in <tt>vdsm.conf</tt> are still applied. The guest agent hook mechanism is disabled.</li>
     <li><b>Minimal downtime</b> - Allows the virtual machine to migrate in typical situations. Virtual machines should not experience any significant downtime. The migration will be aborted if virtual machine migration does not converge after a long time (dependent on QEMU iterations, with a maximum of 500 milliseconds). The guest agent hook mechanism is enabled.</li>
     <li><b>Suspend workload if needed</b> - Allows the virtual machine to migrate in most situations, including when the virtual machine is running a heavy workload. Virtual machines may experience a more significant downtime. The migration may still be aborted for extreme workloads. The guest agent hook mechanism is enabled.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Use custom migration downtime</b></td>
   <td>This check box allows you to specify the maximum number of milliseconds the virtual machine can be down during live migration. Configure different maximum downtimes for each virtual machine according to its workload and SLA requirements. Enter <tt>0</tt> to use the VDSM default value.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Auto Converge migrations</b></td>
   <td>
    <p>Only activated with the <b>Legacy</b> migration policy. Allows you to set whether auto-convergence is used during live migration of the virtual machine. Large virtual machines with high workloads can dirty memory more quickly than the transfer rate achieved during live migration, and prevent the migration from converging. Auto-convergence capabilities in QEMU allow you to force convergence of virtual machine migrations. QEMU automatically detects a lack of convergence and triggers a throttle-down of the vCPUs on the virtual machine. Auto-convergence is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from cluster setting</b> to use the auto-convergence setting that is set at the cluster level. This option is selected by default.</li>
     <li>Select <b>Auto Converge</b> to override the cluster setting or global setting and allow auto-convergence for the virtual machine.</li>
     <li>Select <b>Don't Auto Converge</b> to override the cluster setting or global setting and prevent auto-convergence for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Enable migration compression</b></td>
   <td>
    <p>Only activated with the <b>Legacy</b> migration policy. The option allows you to set whether migration compression is used during live migration of the virtual machine. This feature uses Xor Binary Zero Run-Length-Encoding to reduce virtual machine downtime and total live migration time for virtual machines running memory write-intensive workloads or for any application with a sparse memory update pattern. Migration compression is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from cluster setting</b> to use the compression setting that is set at the cluster level. This option is selected by default.</li>
     <li>Select <b>Compress</b> to override the cluster setting or global setting and allow compression for the virtual machine.</li>
     <li>Select <b>Don't compress</b> to override the cluster setting or global setting and prevent compression for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Pass-Through Host CPU</b></td>
   <td>This check box allows virtual machines to take advantage of the features of the physical CPU of the host on which they are situated. This option can only be enabled when <b>Do not allow migration</b> is selected.</td>
  </tr>
  <tr>
   <td><b>Configure NUMA</b></td>
   <td><b>NUMA Node Count</b></td>
   <td>The number of virtual NUMA nodes to assign to the virtual machine. If the <b>Tune Mode</b> is <b>Preferred</b>, this value must be set to <tt>1</tt>.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Tune Mode</b></td>
   <td>
    <p>The method used to allocate memory.</p>
    <ul>
     <li><b>Strict</b>: Memory allocation will fail if the memory cannot be allocated on the target node.</li>
     <li><b>Preferred</b>: Memory is allocated from a single preferred node. If sufficient memory is not available, memory can be allocated from other nodes.</li>
     <li><b>Interleave</b>: Memory is allocated across nodes in a round-robin algorithm.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>NUMA Pinning</b></td>
   <td>Opens the <b>NUMA Topology</b> window. This window shows the host's total CPUs, memory, and NUMA nodes, and the virtual machine's virtual NUMA nodes. Pin virtual NUMA nodes to host NUMA nodes by clicking and dragging each vNUMA from the box on the right to a NUMA node on the left. </td>
  </tr>
 </tbody>
</table>

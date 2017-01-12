# Migration Policy Settings Explained

A migration policy defines the conditions for live migrating virtual machines in the event of host failure. These conditions include the downtime of the virtual machine during migration, network bandwidth, and how the virtual machines are prioritized.

**Migration Policies Explained**

<table>
 <thead>
  <tr>
   <td>Policy</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Legacy</b></td>
   <td>Legacy behavior of 3.6 version. Overrides in <tt>vdsm.conf</tt> are still applied. The guest agent hook mechanism is disabled.</td>
  </tr>
  <tr>
   <td><b>Minimal downtime</b></td>
   <td>A policy that lets virtual machines migrate in typical situations. Virtual machines should not experience any significant downtime. The migration will be aborted if the virtual machine migration does not converge after a long time (dependent on QEMU iterations, with a maximum of 500 milliseconds). The guest agent hook mechanism is enabled.</td>
  </tr>
  <tr>
   <td><b>Suspend workload if needed</b></td>
   <td>A policy that lets virtual machines migrate in most situations, including virtual machines running heavy workloads. Virtual machines may experience a more significant downtime. The migration may still be aborted for extreme workloads. The guest agent hook mechanism is enabled.</td>
  </tr>
 </tbody>
</table>

The bandwidth settings define the maximum bandwidth of both outgoing and incoming migrations per host. 

**Bandwidth Explained**

<table>
 <thead>
  <tr>
   <td>Policy</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Auto</b></td>
   <td>Bandwidth is copied from the <b>Rate Limit [Mbps]</b> setting in the data center <b>Host Network QoS</b>. If the rate limit has not been defined, it is computed as a minimum of link speeds of sending and receiving network interfaces. If rate limit has not been set, and link speeds are not available,  it is determined by local VDSM setting on sending host.</td>
  </tr>
  <tr>
   <td><b>Hypervisor default</b></td>
   <td>Bandwidth is controlled by local VDSM setting on sending Host.</td>
  </tr>
  <tr>
   <td><b>Custom</b></td>
   <td>Defined by user (in Mbps).</td>
  </tr>
 </tbody>
</table>
 
The resilience policy defines how the virtual machines are prioritized in the migration. 

**Resilience Policy Settings**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Migrate Virtual Machines</b></td>
   <td>Migrates all virtual machines in order of their defined priority.</td>
  </tr>
  <tr>
   <td><b>Migrate only Highly Available Virtual Machines</b></td>
   <td>Migrates only highly available virtual machines to prevent overloading other hosts.</td>
  </tr>
  <tr>
   <td><b>Do Not Migrate Virtual Machines</b></td>
   <td>Prevents virtual machines from being migrated.</td>
  </tr>
 </tbody>
</table>

The **Additional Properties** are only applicable to the **Legacy** migration policy. 

**Additional Properties Explained**

<table>
 <thead>
  <tr>
   <td>Property</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Auto Converge migrations</b></td>
   <td>
    <p>Allows you to set whether auto-convergence is used during live migration of virtual machines. Large virtual machines with high workloads can dirty memory more quickly than the transfer rate achieved during live migration, and prevent the migration from converging. Auto-convergence capabilities in QEMU allow you to force convergence of virtual machine migrations. QEMU automatically detects a lack of convergence and triggers a throttle-down of the vCPUs on the virtual machine. Auto-convergence is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from global setting</b> to use the auto-convergence setting that is set at the global level. This option is selected by default.</li>
     <li>Select <b>Auto Converge</b> to override the global setting and allow auto-convergence for the virtual machine.</li>
     <li>Select <b>Don't Auto Converge</b> to override the global setting and prevent auto-convergence for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Enable migration compression</b></td>
   <td>
    <p>The option allows you to set whether migration compression is used during live migration of the virtual machine. This feature uses Xor Binary Zero Run-Length-Encoding to reduce virtual machine downtime and total live migration time for virtual machines running memory write-intensive workloads or for any application with a sparse memory update pattern. Migration compression is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from global setting</b> to use the compression setting that is set at the global level. This option is selected by default.</li>
     <li>Select <b>Compress</b> to override the global setting and allow compression for the virtual machine.</li>
     <li>Select <b>Don't compress</b> to override the global setting and prevent compression for the virtual machine.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

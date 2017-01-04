# Optimization Settings Explained

Memory page sharing allows virtual machines to use up to 200% of their allocated memory by utilizing unused memory in other virtual machines. This process is based on the assumption that the virtual machines in your Red Hat Virtualization environment will not all be running at full capacity at the same time, allowing unused memory to be temporarily allocated to a particular virtual machine.

CPU Thread Handling allows hosts to run virtual machines with a total number of processor cores greater than number of cores in the host. This is useful for non-CPU-intensive workloads, where allowing a greater number of virtual machines to run can reduce hardware requirements. It also allows virtual machines to run with CPU topologies that would otherwise not be possible, specifically if the number of guest cores is between the number of host cores and number of host threads.

The table below describes the settings for the **Optimization** tab in the **New Cluster** and **Edit Cluster** windows.

**Optimization Settings**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Memory Optimization</b></td>
   <td>
    <ul>
     <li><b>None - Disable memory overcommit</b>: Disables memory page sharing.</li>
     <li><b>For Server Load - Allow scheduling of 150% of physical memory</b>: Sets the memory page sharing threshold to 150% of the system memory on each host.</li>
     <li><b>For Desktop Load - Allow scheduling of 200% of physical memory</b>: Sets the memory page sharing threshold to 200% of the system memory on each host.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>CPU Threads</b></td>
   <td>
    <p>Selecting the <b>Count Threads As Cores</b> check box allows hosts to run virtual machines with a total number of processor cores greater than the number of cores in the host.</p>
    <p>The exposed host threads would be treated as cores which can be utilized by virtual machines. For example, a 24-core system with 2 threads per core (48 threads total) can run virtual machines with up to 48 cores each, and the algorithms to calculate host CPU load would compare load against twice as many potential utilized cores.</p>
   </td>
  </tr>
  <tr>
   <td><b>Memory Balloon</b></td>
   <td>
    <p>Selecting the <b>Enable Memory Balloon Optimization</b> check box enables memory overcommitment on virtual machines running on the hosts in this cluster. When this option is set, the Memory Overcommit Manager (MoM) will start ballooning where and when possible, with a limitation of the guaranteed memory size of every virtual machine.</p>
    <p>To have a balloon running, the virtual machine needs to have a balloon device with relevant drivers. Each virtual machine includes a balloon device unless specifically removed. Each host in this cluster receives a balloon policy update when its status changes to <tt>Up</tt>. If necessary, you can manually update the balloon policy on a host without having to change the status. See <a href="Updating_the_MoM_Policy_on_Hosts_in_a_Cluster">Updating the MoM Policy on Hosts in a Cluster</a>.</p>
    <p>It is important to understand that in some scenarios ballooning may collide with KSM. In such cases MoM will try to adjust the balloon size to minimize collisions. Additionally, in some scenarios ballooning may cause sub-optimal performance for a virtual machine. Administrators are advised to use ballooning optimization with caution.</p>
   </td>
  </tr>
  <tr>
   <td><b>KSM control</b></td>
   <td>Selecting the <b>Enable KSM</b> check box enables MoM to run Kernel Same-page Merging (KSM) when necessary and when it can yield a memory saving benefit that outweighs its CPU cost.</td>
  </tr>
 </tbody>
</table>

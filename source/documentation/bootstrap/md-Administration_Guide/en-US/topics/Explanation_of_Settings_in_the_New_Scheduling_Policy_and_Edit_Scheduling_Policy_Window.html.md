# Explanation of Settings in the New Scheduling Policy and Edit Scheduling Policy Window

The following table details the options available in the **New Scheduling Policy** and **Edit Scheduling Policy** windows.

**New Scheduling Policy and Edit Scheduling Policy Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the scheduling policy. This is the name used to refer to the scheduling policy in the Red Hat Virtualization Manager.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A description of the scheduling policy. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Filter Modules</b></td>
   <td>
    <p>A set of filters for controlling the hosts on which a virtual machine in a cluster can run. Enabling a filter will filter out hosts that do not meet the conditions specified by that filter, as outlined below:</p>
    <ul>
     <li><tt>CpuPinning</tt>: Hosts which do not satisfy the CPU pinning definition.</li>
     <li><tt>Migration</tt>: Prevent migration to the same host.</li>
     <li><tt>PinToHost</tt>: Hosts other than the host to which the virtual machine is pinned.</li>
     <li><tt>CPU-Level</tt>: Hosts that do not meet the CPU topology of the virtual machine.</li>
     <li><tt>CPU</tt>: Hosts with fewer CPUs than the number assigned to the virtual machine.</li>
     <li><tt>Memory</tt>: Hosts that do not have sufficient memory to run the virtual machine.</li>
     <li><tt>VmAffinityGroups</tt>: Hosts that do not meet the conditions specified for a virtual machine that is a member of an affinity group. For example, that virtual machines in an affinity group must run on the same host or on separate hosts.</li>
     <li><tt>InClusterUpgrade</tt>: Hosts which run an older operating system than the virtual machine currently runs on.</li>
     <li><tt>HostDevice</tt>: Hosts that do not support host devices required by the virtual machine.</li>
     <li><tt>HA</tt>: Forces the hosted engine virtual machine to only run on hosts with a positive high availability score.</li>
     <li><tt>Emulated-Machine</tt>: Hosts which do not have proper emulated machine support.</li>
     <li><tt>Network</tt>: Hosts on which networks required by the network interface controller of a virtual machine are not installed, or on which the cluster's display network is not installed.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Weights Modules</b></td>
   <td>
    <p>A set of weightings for controlling the relative priority of factors considered when determining the hosts in a cluster on which a virtual machine can run.</p>
    <ul>
     <li><tt>InClusterUpgrade</tt>: Weight hosts in accordance with their operating system version. The weight penalizes hosts with older operating systems more than hosts with the same operating system, giving priority to hosts with newer operating systems. </li>
     <li><tt>OptimalForHaReservation</tt>: Weights hosts in accordance with their high availability score.</li>
     <li><tt>None</tt>: Weights hosts in accordance with the even distribution module.</li>
     <li><tt>OptimalForEvenGuestDistribution</tt>: Weights hosts in accordance with the number of virtual machines running on those hosts.</li>
     <li><tt>VmAffinityGroups</tt>: Weights hosts in accordance with the affinity groups defined for virtual machines. This weight module determines how likely virtual machines in an affinity group are to run on the same host or on separate hosts in accordance with the parameters of that affinity group.</li>
     <li><tt>OptimalForPowerSaving</tt>: Weights hosts in accordance with their CPU usage, giving priority to hosts with higher CPU usage.</li>
     <li><tt>OptimalForEvenDistribution</tt>: Weights hosts in accordance with their CPU usage, giving priority to hosts with lower CPU usage.</li>
     <li><tt>HA</tt>: Weights hosts in accordance with their high availability score.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Load Balancer</b></td>
   <td>This drop-down menu allows you to select a load balancing module to apply. Load balancing modules determine the logic used to migrate virtual machines from hosts experiencing high usage to hosts experiencing lower usage.</td>
  </tr>
  <tr>
   <td><b>Properties</b></td>
   <td>This drop-down menu allows you to add or remove properties for load balancing modules, and is only available when you have selected a load balancing module for the scheduling policy. No properties are defined by default, and the properties that are available are specific to the load balancing module that is selected. Use the <b>+</b> and <b>-</b> buttons to add or remove additional properties to or from the load balancing module.</td>
  </tr>
 </tbody>
</table>


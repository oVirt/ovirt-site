---
title: Clusters
---

# Chapter 5: Clusters

## Introduction to Clusters

A cluster is a logical grouping of hosts that share the same storage domains and have the same type of CPU (either Intel or AMD). If the hosts have different generations of CPU models, they use only the features present in all models.

Each cluster in the system must belong to a data center, and each host in the system must belong to a cluster. Virtual machines are dynamically allocated to any host in a cluster and can be migrated between them, according to policies defined on the cluster and settings on the virtual machines. The cluster is the highest level at which power and load-sharing policies can be defined.

The number of hosts and number of virtual machines that belong to a cluster are displayed in the results list under **Host Count** and **VM Count**, respectively.

Clusters run virtual machines or Gluster Storage Servers. These two purposes are mutually exclusive: A single cluster cannot support virtualization and storage hosts together.

oVirt creates a default cluster in the default data center during installation.

**Cluster**

![](/images/admin-guide/223.png)

## Cluster Tasks

### Creating a New Cluster

A data center can contain multiple clusters, and a cluster can contain multiple hosts. All hosts in a cluster must be of the same CPU type (Intel or AMD). It is recommended that you create your hosts before you create your cluster to ensure CPU type optimization. However, you can configure the hosts at a later time using the **Guide Me** button.

**Creating a New Cluster**

1. Click **Compute** &rarr; **Clusters**.

2. Click **New**.

3. Select the **Data Center** the cluster will belong to from the drop-down list.

4. Enter the **Name** and **Description** of the cluster.

5. Select a network from the **Management Network** drop-down list to assign the management network role.

6. Select the **CPU Architecture** and **CPU Type** from the drop-down lists. It is important to match the CPU processor family with the minimum CPU processor type of the hosts you intend to attach to the cluster, otherwise the host will be non-operational.

    **Note:** For both Intel and AMD CPU types, the listed CPU models are in logical order from the oldest to the newest. If your cluster includes hosts with different CPU models, select the oldest CPU model.

7. Select the **Compatibility Version** of the cluster from the drop-down list.

8. Select the **Switch** Type from the drop-down list.

9. Select the **Firewall Type** for hosts in the cluster, either **iptables** or **firewalld**.

10. Select either the **Enable Virt Service** or **Enable Gluster Service** radio button to define whether the cluster will be populated with virtual machine hosts or with Gluster-enabled nodes.

11. Optionally select the **Enable to set VM maintenance reason** check box to enable an optional reason field when a virtual machine is shut down from the Manager, allowing the administrator to provide an explanation for the maintenance.

12. Optionally select the **Enable to set Host maintenance reason** check box to enable an optional reason field when a host is placed into maintenance mode from the Manager, allowing the administrator to provide an explanation for the maintenance.

13. Optionally select the **/dev/hwrng** source (external hardware device) check box to specify the random number generator device that all hosts in the cluster will use. The **/dev/urandom** source (Linux-provided device) is enabled by default.

14. Click the **Optimization** tab to select the memory page sharing threshold for the cluster, and optionally enable CPU thread handling and memory ballooning on the hosts in the cluster.

15. Click the **Migration Policy** tab to define the virtual machine migration policy for the cluster.

15. Click the **Scheduling Policy** tab to optionally configure a scheduling policy, configure scheduler optimization settings, enable trusted service for hosts in the cluster, enable HA Reservation, and add a custom serial number policy.

17. Click the **Console** tab to optionally override the global SPICE proxy, if any, and specify the address of a SPICE proxy for hosts in the cluster.

18. Click the **Fencing policy** tab to enable or disable fencing in the cluster, and select fencing options.

19. Click the **MAC Address Pool** tab to specify a MAC address pool other than the default pool for the cluster.

20. Click **OK** to create the cluster and open the **Cluster - Guide Me** window.

21. The **Guide Me** window lists the entities that need to be configured for the cluster. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the cluster and clicking **More Actions** &rarr; **Guide Me**.

### General Cluster Settings Explained

The table below describes the settings for the **General** tab in the **New Cluster** and **Edit Cluster** windows. Invalid entries are outlined in orange when you click **OK**, prohibiting the changes being accepted. In addition, field prompts indicate the expected values or range of values.

**General Cluster Settings**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Data Center</b></td>
   <td>The data center that will contain the cluster. The data center must be created before adding a cluster.</td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the cluster. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Description / Comment</b></td>
   <td>The description of the cluster or additional notes. These fields are recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Management Network</b></td>
   <td>The logical network which will be assigned the management network role. The default is <b>ovirtmgmt</b>. On existing clusters, the management network can only be changed via the <b>Manage Networks</b> button in the <b>Logical Networks</b> tab in the details pane.</td>
  </tr>
  <tr>
   <td><b>CPU Architecture</b></td>
   <td>
    <p>The CPU architecture of the cluster. Different CPU types are available depending on which CPU architecture is selected.</p>
    <ul>
     <li><b>undefined</b>: All CPU types are available.</li>
     <li><b>x86_64</b>: All Intel and AMD CPU types are available.</li>
     <li><b>ppc64</b>: Only IBM POWER 8 is available.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>CPU Type</b></td>
   <td>The CPU type of the cluster. All hosts in a cluster must run either Intel, AMD, or IBM POWER 8 CPU type; this cannot be changed after creation without significant disruption. The CPU type should be set to the oldest CPU model in the cluster. Only features present in all models can be used. For both Intel and AMD CPU types, the listed CPU models are in logical order from the oldest to the newest.</td>
  </tr>
  <tr>
   <td><b>Compatibility Version</b></td>
   <td>The version of oVirt. You will not be able to select a version older than the version specified for the data center.</td>
  </tr>
  <tr>
   <td><b>Switch Type</b></td>
   <td>The type of switch used by the cluster. <b>Linux Bridge</b> is the standard oVirt switch.<b>OVS</b> provides support for Open vSwitch networking features.</td>
  </tr>
  <tr>
   <td><b>Firewall Type</b></td>
   <td>Specifies the firewall type for hosts in the cluster, either <b>iptables</b> or <b>firewalld</b>. If you change an existing cluster’s firewall type, all hosts in the cluster must be reinstalled (by clicking <b>Installation</b> &rarr; <b>Reinstall</b>) to apply the change.</td>
  </tr>
  <tr>
   <td><b>Default Network Provider</b></td>
   <td>Specifies the default external network provider that the cluster will use. If Open Virtual Network (OVN) is selected, hosts added to the cluster will automatically be configured to communicate with the OVN provider.</td>
  </tr>
  <tr>
   <td><b>Enable Virt Service</b></td>
   <td>If this radio button is selected, hosts in this cluster will be used to run virtual machines.</td>
  </tr>
  <tr>
   <td><b>Enable Gluster Service</b></td>
   <td>If this radio button is selected, hosts in this cluster will be used as Gluster Storage Server nodes, and not for running virtual machines. You cannot add an oVirt Node to a cluster with this option enabled.</td>
  </tr>
  <tr>
   <td><b>Import existing gluster configuration</b></td>
   <td>
    <p>This check box is only available if the <b>Enable Gluster Service</b> radio button is selected. This option allows you to import an existing Gluster-enabled cluster and all its attached hosts to oVirt Engine.</p>
    <p>The following options are required for each host in the cluster that is being imported:</p>
    <ul>
     <li><b>Address</b>: Enter the IP or fully qualified domain name of the Gluster host server.</li>
     <li><b>Fingerprint</b>: oVirt Engine fetches the host's fingerprint, to ensure you are connecting with the correct host.</li>
     <li><b>Root Password</b>: Enter the root password required for communicating with the host.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Enable to set VM maintenance reason</b></td>
   <td>If this check box is selected, an optional reason field will appear when a virtual machine in the cluster is shut down from the Manager. This allows you to provide an explanation for the maintenance, which will appear in the logs and when the virtual machine is powered on again.</td>
  </tr>
  <tr>
   <td><b>Enable to set Host maintenance reason</b></td>
   <td>If this check box is selected, an optional reason field will appear when a host in the cluster is moved into maintenance mode from the Manager. This allows you to provide an explanation for the maintenance, which will appear in the logs and when the host is activated again.</td>
  </tr>
  <tr>
   <td><b>Additional Random Number Generator source</b></td>
   <td>If the check box is selected, all hosts in the cluster have the additional random number generator device available. This enables passthrough of entropy from the random number generator device to virtual machines.</td>
  </tr>
 </tbody>
</table>

### Optimization Settings Explained

Memory page sharing allows virtual machines to use up to 200% of their allocated memory by utilizing unused memory in other virtual machines. This process is based on the assumption that the virtual machines in your oVirt environment will not all be running at full capacity at the same time, allowing unused memory to be temporarily allocated to a particular virtual machine.

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

### Migration Policy Settings Explained

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
   <td>
   <p>Defined by user (in Mbps). This value is divided by the number of concurrent migrations (default is 2, to account for ingoing and outgoing migration). Therefore, the user-defined bandwidth must be large enough to accommodate all concurrent migrations.</p>

   <p>For example, if the Custom bandwidth is defined as 600 Mbps, a virtual machine migration’s maximum bandwidth is actually 300 Mbps.</p>
   </td>
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

### Scheduling Policy Settings Explained

Scheduling policies allow you to specify the usage and distribution of virtual machines between available hosts. Define the scheduling policy to enable automatic load balancing across the hosts in a cluster. Regardless of the scheduling policy, a virtual machine will not start on a host with an overloaded CPU. By default, a host’s CPU is considered overloaded if it has a load of more than 80% for 5 minutes, but these values can be changed using scheduling policies. See the “Scheduling Policies” section for more information about scheduling policies.

**Scheduling Policy Tab Properties**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Select Policy</b></td>
   <td>
    <p>Select a policy from the drop-down list.</p>
    <ul>
     <li><b>none</b>:  Set the policy value to <b>none</b> to have no load or power sharing between hosts for already-running virtual machines. This is the default mode.When a virtual machine is started, the memory and CPU processing load is spread evenly across all hosts in the cluster. Additional virtual machines attached to a host will not start if that host has reached the defined <b>CpuOverCommitDurationMinutes</b>, <b>HighUtilization</b>, or <b>MaxFreeMemoryForOverUtilized</b>.</li>
     <li><b>evenly_distributed</b>: Distributes the memory and CPU processing load evenly across all hosts in the cluster. Additional virtual machines attached to a host will not start if that host has reached the defined <b>CpuOverCommitDurationMinutes</b>, <b>HighUtilization</b>, or <b>MaxFreeMemoryForOverUtilized</b>.</li>

     <li><b>cluster_maintenance</b>: Limits activity in a cluster during maintenance tasks. No new virtual machines may be started, except highly available virtual machines. If host failure occurs, highly available virtual machines will restart properly and any virtual machine can migrate.</li>
     <li><b>power_saving</b>: Distributes the memory and CPU processing load across a subset of available hosts to reduce power consumption on underutilized hosts. Hosts with a CPU load below the low utilization value for longer than the defined time interval will migrate all virtual machines to other hosts so that it can be powered down. Additional virtual machines attached to a host will not start if that host has reached the defined high utilization value.</li>
     <li><b>vm_evenly_distributed</b>: Distributes virtual machines evenly between hosts based on a count of the virtual machines. The cluster is considered unbalanced if any host is running more virtual machines than the <b>HighVmCount</b> and there is at least one host with a virtual machine count that falls outside of the <b>MigrationThreshold</b>.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Properties</b></td>
   <td>
    <p>The following properties appear depending on the selected policy, and can be edited if necessary:</p>
    <ul>
     <li><b>HighVmCount</b>: Sets the minimum number of virtual machines that must be running per host to enable load balancing. The default value is 10 running virtual machines on one host. Load balancing is only enabled when there is at least one host in the cluster that has at least HighVmCount running virtual machines.</li>
     <li><b>MigrationThreshold</b>: Defines a buffer before virtual machines are migrated from the host. It is the maximum inclusive difference in virtual machine count between the most highly-utilized host and the least-utilized host. The cluster is balanced when every host in the cluster has a virtual machine count that falls inside the migration threshold. The default value is <b>5</b>.</li>
     <li><b>SpmVmGrace</b>: Defines the number of slots for virtual machines to be reserved on SPM hosts. The SPM host will have a lower load than other hosts, so this variable defines how many fewer virtual machines than other hosts it can run. The default value is <b>5</b>.</li>
     <li><b>CpuOverCommitDurationMinutes</b>: Sets the time (in minutes) that a host can run a CPU load outside of the defined utilization values before the scheduling policy takes action. The defined time interval protects against temporary spikes in CPU load activating scheduling policies and instigating unnecessary virtual machine migration. Maximum two characters. The default value is <b>2</b>.</li>
     <li><b>HighUtilization</b>: Expressed as a percentage. If the host runs with CPU usage at or above the high utilization value for the defined time interval, the oVirt Engine migrates virtual machines to other hosts in the cluster until the host's CPU load is below the maximum service threshold. The default value is <b>80</b>.</li>
     <li><b>LowUtilization</b>: Expressed as a percentage. If the host runs with CPU usage below the low utilization value for the defined time interval, the oVirt Engine will migrate virtual machines to other hosts in the cluster. The Manager will power down the original host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster. The default value is <b>20</b>.</li>
     <li><b>ScaleDown</b>: Reduces the impact of the <b>HA Reservation</b> weight function, by dividing a host's score by the specified amount. This is an optional property that can be added to any policy, including <b>none</b>.</li>
     <li><b>HostsInReserve</b>: Specifies a number of hosts to keep running even though there are no running virtual machines on them. This is an optional property that can be added to the <b>power_saving</b> policy.</li>
     <li><b>EnableAutomaticHostPowerManagement</b>: Enables automatic power management for all hosts in the cluster. This is an optional property that can be added to the <b>power_saving</b> policy. The default value is <b>true</b>.</li>
     <li><b>MaxFreeMemoryForOverUtilized</b>: Sets the maximum free memory required in MB for the minimum service level. If the host's memory usage runs at, or above this value, the oVirt Engine migrates virtual machines to other hosts in the cluster until the host's available memory is below the minimum service threshold. Setting both <b>MaxFreeMemoryForOverUtilized</b> and <b>MinFreeMemoryForUnderUtilized</b> to 0 MB disables memory based balancing. This is an optional property that can be added to the <b>power_saving</b> and <b>evenly_distributed</b> policies.</li>
     <li><b>MinFreeMemoryForUnderUtilized</b>: Sets the minimum free memory required in MB before the host is considered underutilized. If the host's memory usage runs below this value, the oVirt Engine migrates virtual machines to other hosts in the cluster and will automatically power down the host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster. Setting both <b>MaxFreeMemoryForOverUtilized</b> and <b>MinFreeMemoryForUnderUtilized</b> to 0MB disables memory based balancing. This is an optional property that can be added to the <b>power_saving</b> and <b>evenly_distributed</b> policies.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Scheduler Optimization</b></td>
   <td>
    <p>Optimize scheduling for host weighing/ordering.</p>
    <ul>
     <li><b>Optimize for Utilization</b>: Includes weight modules in scheduling to allow best selection.</li>
     <li><b>Optimize for Speed</b>: Skips host weighting in cases where there are more than ten pending requests.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Enable Trusted Service</b></td>
   <td>Enable integration with an OpenAttestation server. Before this can be enabled, use the <tt>engine-config</tt> tool to enter the OpenAttestation server's details. For more information, see <a href="sect-Trusted_Compute_Pools">Trusted Compute Pools</a>.</td>
  </tr>
  <tr>
   <td><b>Enable HA Reservation</b></td>
   <td>Enable the Manager to monitor cluster capacity for highly available virtual machines. The Manager ensures that appropriate capacity exists within a cluster for virtual machines designated as highly available to migrate in the event that their existing host fails unexpectedly.</td>
  </tr>
  <tr>
   <td><b>Provide custom serial number policy</b></td>
   <td>
    <p>This check box allows you to specify a serial number policy for the virtual machines in the cluster. Select one of the following options:</p>
    <ul>
     <li><b>Host ID</b>: Sets the host's UUID as the virtual machine's serial number.</li>
     <li><b>Vm ID</b>: Sets the virtual machine's UUID as its serial number.</li>
     <li><b>Custom serial number</b>: Allows you to specify a custom serial number.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

When a host's free memory drops below 20%, ballooning tts like `mom.Controllers.Balloon - INFO Ballooning guest:half1 from 1096400 to 1991580` are logged to **/var/log/vdsm/mom.log**. **/var/log/vdsm/mom.log** is the Memory Overcommit Manager log file.

#### Cluster Console Settings Explained

The table below describes the settings for the **Console** tab in the **New Cluster** and **Edit Cluster** windows.

**Console Settings**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Define SPICE Proxy for Cluster</b></td>
   <td>Select this check box to enable overriding the SPICE proxy defined in global configuration. This feature is useful in a case where the user (who is, for example, connecting via the User Portal) is outside of the network where the hypervisors reside.</td>
  </tr>
  <tr>
   <td><b>Overridden SPICE proxy address</b></td>
   <td>
    <p>The proxy by which the SPICE client will connect to virtual machines. The address must be in the following format:</p>
    <pre>protocol://[host]:[port]</pre>
   </td>
  </tr>
 </tbody>
</table>

#### Fencing Policy Settings Explained

The table below describes the settings for the **Fencing Policy** tab in the **New Cluster** and **Edit Cluster** windows.

**Fencing Policy Settings**

| Field | Description/Action |
|-
| <b>Enable fencing</b> | Enables fencing on the cluster. Fencing is enabled by default, but can be disabled if required; for example, if temporary network issues are occurring or expected, administrators can disable fencing until diagnostics or maintenance activities are completed. Note that if fencing is disabled, highly available virtual machines running on non-responsive hosts will not be restarted elsewhere. |
| <b>Skip fencing if host has live lease on storage</b> | If this check box is selected, any hosts in the cluster that are Non Responsive and still connected to storage will not be fenced. |
| <b>Skip fencing on cluster connectivity issues</b> | If this check box is selected, fencing will be temporarily disabled if the percentage of hosts in the cluster that are experiencing connectivity issues is greater than or equal to the defined <b>Threshold</b>. The <b>Threshold</b> value is selected from the drop-down list; available values are <b>25</b>, <b>50</b>, <b>75</b>, and <b>100</b>. |
| <b>Skip fencing if gluster bricks are up</b> | This option is only available when Gluster Storage functionality is enabled. If this check box is selected, fencing is skipped if bricks are running and can be reached from other peers. |
| <b>Skip fencing if gluster quorum not met</b> | This option is only available when Red Hat Gluster Storage functionality is enabled. If this check box is selected, fencing is skipped if bricks are running and shutting down the host will cause loss of quorum. |

### Setting Load and Power Management Policies for Hosts in a Cluster

The **evenly_distributed** and **power_saving** scheduling policies allow you to specify acceptable memory and CPU usage values, and the point at which virtual machines must be migrated to or from a host. The **vm_evenly_distributed** scheduling policy distributes virtual machines evenly between hosts based on a count of the virtual machines. Define the scheduling policy to enable automatic load balancing across the hosts in a cluster. For a detailed explanation of each scheduling policy, see [Cluster Scheduling Policy Settings](Cluster_Scheduling_Policy_Settings).

**Setting Load and Power Management Policies for Hosts**

1. Click **Compute** &rarr; **Clusters** and select a cluster.

2. Click **Edit**.

3. Click the **Scheduling Policy** tab.

4. Select one of the following policies:

    * **none**

    * **vm_evenly_distributed**

        i. Set the maximum number of virtual machines that can run on each host in the **HighVmCount** field.

        ii. Define the maximum acceptable difference between the number of virtual machines on the most highly-utilized host and the number of virtual machines on the least-utilized host in the **MigrationThreshold** field.

        iii. Define the number of slots for virtual machines to be reserved on SPM hosts in the **SpmVmGrace** field.

        iv. Optionally, in the **HeSparesCount** field, enter the number of additional self-hosted engine nodes on which to reserve enough free memory to start the Manager virtual machine if it migrates or shuts down.

    * **evenly_distributed**

        i. Set the time (in minutes) that a host can run a CPU load outside of the defined utilization values before the scheduling policy takes action in the **CpuOverCommitDurationMinutes** field.

        ii. Enter the CPU utilization percentage at which virtual machines start migrating to other hosts in the **HighUtilization** field.

        iii. Enter the minimum required free memory in MB at which virtual machines start migrating to other hosts in the **MinFreeMemoryForUnderUtilized**.

        iv. Enter the maximum required free memory in MB at which virtual machines start migrating to other hosts in the **MaxFreeMemoryForOverUtilized**.

        v. Optionally, in the **HeSparesCount** field, enter the number of additional self-hosted engine nodes on which to reserve enough free memory to start the Manager virtual machine if it migrates or shuts down.

    * **power_saving**

        i. Set the time (in minutes) that a host can run a CPU load outside of the defined utilization values before the scheduling policy takes action in the **CpuOverCommitDurationMinutes** field.

        ii. Enter the CPU utilization percentage below which the host will be considered under-utilized in the **LowUtilization** field.

        iii. Enter the CPU utilization percentage at which virtual machines start migrating to other hosts in the **HighUtilization** field.

        iv. Enter the minimum required free memory in MB at which virtual machines start migrating to other hosts in the **MinFreeMemoryForUnderUtilized**.

        v. Enter the maximum required free memory in MB at which virtual machines start migrating to other hosts in the **MaxFreeMemoryForOverUtilized**.

        vi. Optionally, in the **HeSparesCount** field, enter the number of additional self-hosted engine nodes on which to reserve enough free memory to start the Manager virtual machine if it migrates or shuts down.

5. Choose one of the following as the **Scheduler Optimization** for the cluster:

    * Select **Optimize for Utilization** to include weight modules in scheduling to allow best selection.

    * Select **Optimize for Speed** to skip host weighting in cases where there are more than ten pending requests.

6. If you are using an OpenAttestation server to verify your hosts, and have set up the server's details using the `engine-config` tool, select the **Enable Trusted Service** check box.

7. Optionally select the **Enable HA Reservation** check box to enable the Manager to monitor cluster capacity for highly available virtual machines.

8. Optionally select the **Provide custom serial number policy** check box to specify a serial number policy for the virtual machines in the cluster, and then select one of the following options:

    * Select **Host ID** to set the host's UUID as the virtual machine's serial number.

    * Select **Vm ID** to set the virtual machine's UUID as its serial number.

    * Select **Custom serial number**, and then specify a custom serial number in the text field.

9. Click **OK**.

### Updating the MoM Policy on Hosts in a Cluster

The Memory Overcommit Manager handles memory balloon and KSM functions on a host. Changes to these functions at the cluster level are only passed to hosts the next time a host moves to a status of **Up** after being rebooted or in maintenance mode. However, if necessary you can apply important changes to a host immediately by synchronizing the MoM policy while the host is **Up**. The following procedure must be performed on each host individually.

**Synchronizing MoM Policy on a Host**

1. Click **Compute** &rarr; **Clusters**.

2. Click the cluster’s name to open the details view.

3. Click the **Hosts** tab and select the host that requires an updated MoM policy.

4. Click **Sync MoM Policy**.

The MoM policy on the host is updated without having to move the host to maintenance mode and back **Up**.

### Creating a CPU Profile

CPU profiles define the maximum amount of processing capability a virtual machine in a cluster can access on the host on which it runs, expressed as a percent of the total processing capability available to that host. CPU profiles are created based on CPU profiles defined under data centers, and are not automatically applied to all virtual machines in a cluster; they must be manually assigned to individual virtual machines for the profile to take effect.

This procedure assumes you have already defined one or more CPU quality of service entries under the data center to which the cluster belongs.

**Creating a CPU Profile**

1. Click **Compute** &rarr; **Clusters**.

2. Click the cluster’s name to open the details view.

3. Click the **CPU Profiles** tab.

4. Click **New**.

5. Enter a **Name** and a **Description** for the CPU profile.

5. Enter a description for the CPU profile in the **Description** field.

6. Select the quality of service to apply to the CPU profile from the **QoS** list.

7. Click **OK**.

### Removing a CPU Profile

Remove an existing CPU profile from your oVirt environment.

**Removing a CPU Profile**

1. Click **Compute** &rarr; **Clusters**.

2. Click the cluster’s name to open the details view.

3. Click the **CPU Profiles** and select the CPU profile to remove.

4. Click **Remove**.

5. Click **OK**.

If the CPU profile was assigned to any virtual machines, those virtual machines are automatically assigned the `default` CPU profile.

### Importing an Existing Gluster Storage Cluster

You can import a Gluster Storage cluster and all hosts belonging to the cluster into oVirt Engine.

When you provide details such as the IP address or host name and password of any host in the cluster, the `gluster peer status` command is executed on that host through SSH, then displays a list of hosts that are a part of the cluster. You must manually verify the fingerprint of each host and provide passwords for them. You will not be able to import the cluster if one of the hosts in the cluster is down or unreachable. As the newly imported hosts do not have VDSM installed, the bootstrap script installs all the necessary VDSM packages on the hosts after they have been imported, and reboots them.

**Importing an Existing Gluster Storage Cluster to oVirt Engine**

1. Click **Compute** &rarr; **Clusters**.

2. Click **New**.

3. Select the **Data Center** the cluster will belong to.

4. Enter the **Name** and **Description** of the cluster.

5. Select the **Enable Gluster Service** radio button and the **Import existing gluster configuration** check box.

    The **Import existing gluster configuration** field is displayed only if you select **Enable Gluster Service** radio button.

6. In the **Hostname** field, enter the hostname or IP address of any server in the cluster.

    The host **SSH Fingerprint** displays to ensure you are connecting with the correct host. If a host is unreachable or if there is a network error, an error **Error in fetching fingerprint** displays in the **Fingerprint** field.

7. Enter the **Root Password** for the server, and click **OK**.

8. The **Add Hosts** window opens, and a list of hosts that are a part of the cluster displays.

9. For each host, enter the **Name** and the **Root Password**.

10. If you wish to use the same password for all hosts, select the **Use a Common Password** check box to enter the password in the provided text field.

    Click **Apply** to set the entered password all hosts.

    Make sure the fingerprints are valid and submit your changes by clicking **OK**.

The bootstrap script installs all the necessary VDSM packages on the hosts after they have been imported, and reboots them. You have now successfully imported an existing Gluster Storage cluster into oVirt Engine.

### Explanation of Settings in the Add Hosts Window

The **Add Hosts** window allows you to specify the details of the hosts imported as part of a Gluster-enabled cluster. This window appears after you have selected the **Enable Gluster Service** check box in the **New Cluster** window and provided the necessary host details.

**Add Gluster Hosts Settings**

| Field | Description |
|-
| Use a common password | Tick this check box to use the same password for all hosts belonging to the cluster. Enter the password in the <b>Password</b> field, then click the <b>Apply</b> button to set the password on all hosts. |
| Name | Enter the name of the host. |
| Hostname/IP | This field is automatically populated with the fully qualified domain name or IP of the host you provided in the <b>New Cluster</b> window. |
| Root Password | Enter a password in this field to use a different root password for each host. This field overrides the common password provided for all hosts in the cluster. |
| Fingerprint | The host fingerprint is displayed to ensure you are connecting with the correct host. This field is automatically populated with the fingerprint of the host you provided in the <b>New Cluster</b> window. |

### Removing a Cluster

Move all hosts out of a cluster before removing it.

    **Note:** You cannot remove the **Default** cluster, as it holds the **Blank** template. You can however rename the **Default** cluster and add it to a new data center.

**Removing a Cluster**

1. Click **Compute** &rarr; **Clusters**.

2. Ensure there are no hosts in the cluster.

3. Click **Remove**.

4. Click **OK**.

### Changing the Cluster Compatibility Version

oVirt clusters have a compatibility version. The cluster compatibility version indicates the features of oVirt supported by all of the hosts in the cluster. The cluster compatibility is set according to the version of the least capable host operating system in the cluster.

    **Important:** To change the cluster compatibility version, you must have first updated all the hosts in your cluster to a level that supports your desired compatibility level.

**Procedure**

1. From the Administration Portal, click **Compute** &rarr; **Clusters**.

2. Select the cluster to change.

3. Click **Edit**.

4. Change the **Compatibility Version** to the desired value.

5. Click **OK** to open the **Change Cluster Compatibility Version** confirmation window.

6. Click **OK** to confirm.

You have updated the compatibility version of the cluster. Once you have updated the compatibility version of all clusters in a data center, you can then change the compatibility version of the data center itself.

    **Important:** An error message may warn that some virtual machines and templates are incorrectly configured. To fix this error, edit each virtual machine manually. The **Edit Virtual Machine** window provides additional validations and warnings that show what to correct. Sometimes the issue is automatically corrected and the virtual machine’s configuration just needs to be saved again. After editing each virtual machine, you will be able to change the cluster compatibility version.

**Prev:** [Chapter 4: Data Centers](../chap-Data_Centers)<br>
**Next:** [Chapter 6: Logical Networks](../chap-Logical_Networks)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-clusters)

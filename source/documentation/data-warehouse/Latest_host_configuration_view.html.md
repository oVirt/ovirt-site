# Latest Host Configuration View

The following table shows the configuration history parameters of the hosts in the system.

**v3_5_configuration_history_hosts**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database.</td>
  </tr>
  <tr>
   <td>host_id</td>
   <td>uuid</td>
   <td>The unique ID of the host in the system.</td>
  </tr>
  <tr>
   <td>host_unique_id</td>
   <td>varchar(128)</td>
   <td>This field is a combination of the host physical UUID and one of its MAC addresses, and is used to detect hosts already registered in the system.</td>
  </tr>
  <tr>
   <td>host_name</td>
   <td>varchar(255)</td>
   <td>Name of the host (same as in the edit dialog).</td>
  </tr>
  <tr>
   <td>cluster_id</td>
   <td>uuid</td>
   <td>The unique ID of the cluster that this host belongs to.</td>
  </tr>
  <tr>
   <td>host_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - RHEL Host</li>
     <li>2 - RHEV Hypervisor Node</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>fqdn_or_ip</td>
   <td>varchar(255)</td>
   <td>The host's DNS name or its IP address for oVirt Engine to communicate with (as displayed in the edit dialog).</td>
  </tr>
  <tr>
   <td>memory_size_mb</td>
   <td>integer</td>
   <td>The host's physical memory capacity, expressed in megabytes (MB).</td>
  </tr>
  <tr>
   <td>swap_size_mb</td>
   <td>integer</td>
   <td>The host swap partition size.</td>
  </tr>
  <tr>
   <td>cpu_model</td>
   <td>varchar(255)</td>
   <td>The host's CPU model.</td>
  </tr>
  <tr>
   <td>number_of_cores</td>
   <td>smallint</td>
   <td>Total number of CPU cores in the host.</td>
  </tr>
  <tr>
   <td>number_of_sockets</td>
   <td>smallint</td>
   <td>Total number of CPU sockets.</td>
  </tr>
  <tr>
   <td>cpu_speed_mh</td>
   <td>decimal</td>
   <td>The host's CPU speed, expressed in megahertz (MHz).</td>
  </tr>
  <tr>
   <td>host_os</td>
   <td>varchar(255)</td>
   <td>The host's operating system version.</td>
  </tr>
  <tr>
   <td>pm_ip_address</td>
   <td>varchar(255)</td>
   <td>Power Management server IP address.</td>
  </tr>
  <tr>
   <td>kernel_version</td>
   <td>varchar(255)</td>
   <td>The host's kernel version.</td>
  </tr>
  <tr>
   <td>kvm_version</td>
   <td>varchar(255)</td>
   <td>The host's KVM version.</td>
  </tr>
  <tr>
   <td>vdsm_version</td>
   <td>varchar(40)</td>
   <td>The host's VDSM version.</td>
  </tr>
  <tr>
   <td>vdsm_port</td>
   <td>integer</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>cluster_configuration_version</td>
   <td>integer</td>
   <td>The cluster configuration version at the time of creation or update.</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
  </tr>
 </tbody>
</table>

**Prev:** [Latest Cluster Configuration View](../Latest_cluster_configuration_view) <br>
**Next:** [Latest Host Interface Configuration View](../Latest_host_interface_configuration_view)

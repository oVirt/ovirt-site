# Host Statistics Views

**Historical Statistics for Each Host in the System**

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
   <td>bigint</td>
   <td>The unique ID of this row in the table.</td>
  </tr>
  <tr>
   <td>history_datetime</td>
   <td>timestamp with time zone</td>
   <td>The timestamp of this history row (rounded to minute, hour, day as per the aggregation level).</td>
  </tr>
  <tr>
   <td>host_id</td>
   <td>uuid</td>
   <td>Unique ID of the host in the system.</td>
  </tr>
  <tr>
   <td>host_status</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>-1 - <tt>Unknown Status</tt> (used only to indicate a problem with the ETL -- PLEASE NOTIFY SUPPORT)</li>
     <li>1 - <tt>Up</tt></li>
     <li>2 - <tt>Maintenance</tt></li>
     <li>3 - <tt>Problematic</tt></li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>minutes_in_status</td>
   <td>decimal</td>
   <td>The total number of minutes that the host was in the status shown in the status column for the aggregation period. For example, if a host was up for 55 minutes and down for 5 minutes during an hour, two rows will show for this hour. One will have a status of <tt>Up</tt> and minutes_in_status of 55, the other will have a status of <tt>Down</tt> and a minutes_in_status of 5.</td>
  </tr>
  <tr>
   <td>memory_usage_percent</td>
   <td>smallint</td>
   <td>Percentage of used memory on the host.</td>
  </tr>
  <tr>
   <td>max_memory_usage</td>
   <td>smallint</td>
   <td>The maximum memory usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>cpu_usage_percent</td>
   <td>smallint</td>
   <td>Used CPU percentage on the host.</td>
  </tr>
  <tr>
   <td>max_cpu_usage</td>
   <td>smallint</td>
   <td>The maximum CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>ksm_cpu_percent</td>
   <td>smallint</td>
   <td>CPU percentage ksm on the host is using.</td>
  </tr>
  <tr>
   <td>max_ksm_cpu_percent</td>
   <td>smallint</td>
   <td>The maximum KSM usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>active_vms</td>
   <td>smallint</td>
   <td>The average number of active virtual machines for this aggregation.</td>
  </tr>
  <tr>
   <td>max_active_vms</td>
   <td>smallint</td>
   <td>The maximum active number of virtual machines for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>total_vms</td>
   <td>smallint</td>
   <td>The average number of all virtual machines on the host for this aggregation.</td>
  </tr>
  <tr>
   <td>max_total_vms</td>
   <td>smallint</td>
   <td>The maximum total number of virtual machines for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>total_vms_vcpus</td>
   <td>smallint</td>
   <td>Total number of VCPUs allocated to the host.</td>
  </tr>
  <tr>
   <td>max_total_vms_vcpus</td>
   <td>smallint</td>
   <td>The maximum total virtual machine VCPU number for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>cpu_load</td>
   <td>smallint</td>
   <td>The CPU load of the host.</td>
  </tr>
  <tr>
   <td>max_cpu_load</td>
   <td>smallint</td>
   <td>The maximum CPU load for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>system_cpu_usage_percent</td>
   <td>smallint</td>
   <td>Used CPU percentage on the host.</td>
  </tr>
  <tr>
   <td>max_system_cpu_usage_percent</td>
   <td>smallint</td>
   <td>The maximum system CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>user_cpu_usage_percent</td>
   <td>smallint</td>
   <td>Used user CPU percentage on the host.</td>
  </tr>
  <tr>
   <td>max_user_cpu_usage_percent</td>
   <td>smallint</td>
   <td>The maximum user CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>swap_used_mb</td>
   <td>integer</td>
   <td>Used swap size usage of the host in megabytes (MB).</td>
  </tr>
  <tr>
   <td>max_swap_used_mb</td>
   <td>integer</td>
   <td>The maximum user swap size usage of the host for the aggregation period in megabytes (MB), expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>host_configuration_version</td>
   <td>integer</td>
   <td>The host configuration version at the time of sample.</td>
  </tr>
  <tr>
   <td>ksm_shared_memory_mb</td>
   <td>bigint</td>
   <td>The Kernel Shared Memory size in megabytes (MB) that the host is using.</td>
  </tr>
  <tr>
   <td>max_ksm_shared_memory_mb</td>
   <td>bigint</td>
   <td>The maximum KSM memory usage for the aggregation period expressed in megabytes (MB). For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
 </tbody>
</table>


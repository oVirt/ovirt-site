# Virtual Machine Disk Hourly and Samples History Views

**Historical Statistics for the Virtual Disks in the System**

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
   <td>vm_disk_id</td>
   <td>uuid</td>
   <td>Unique ID of the disk in the system.</td>
  </tr>
  <tr>
   <td>vm_disk_status</td>
   <td>integer</td>
   <td>
    <ul>
     <li>0 - Unassigned</li>
     <li>1 - OK</li>
     <li>2 - Locked</li>
     <li>3 - Invalid</li>
     <li>4 - Illegal</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>minutes_in_status</td>
   <td>decimal</td>
   <td>The total number of minutes that the virtual machine disk was in the status shown in the status column for the aggregation period. For example, if a virtual machine disk was locked for 55 minutes and OK for 5 minutes during an hour, two rows will show for this hour. One will have a status of <tt>Locked</tt> and minutes_in_status of 55, the other will have a status of OK and a minutes_in_status of 5.</td>
  </tr>
  <tr>
   <td>vm_disk_actual_size_mb</td>
   <td>integer</td>
   <td>The actual size allocated to the disk.</td>
  </tr>
  <tr>
   <td>read_rate_bytes_per_second</td>
   <td>integer</td>
   <td>Read rate to disk in bytes per second.</td>
  </tr>
  <tr>
   <td>max_read_rate_bytes_per_second</td>
   <td>integer</td>
   <td>The maximum read rate for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>read_latency_seconds</td>
   <td>decimal</td>
   <td>The virtual machine disk read latency measured in seconds.</td>
  </tr>
  <tr>
   <td>max_read_latency_seconds</td>
   <td>decimal</td>
   <td>The maximum read latency for the aggregation period, measured in seconds. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>write_rate_bytes_per_second</td>
   <td>integer</td>
   <td>Write rate to disk in bytes per second.</td>
  </tr>
  <tr>
   <td>max_write_rate_bytes_per_second</td>
   <td>integer</td>
   <td>The maximum write rate for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>write_latency_seconds</td>
   <td>decimal</td>
   <td>The virtual machine disk write latency measured in seconds.</td>
  </tr>
  <tr>
   <td>max_write_latency_seconds</td>
   <td>decimal</td>
   <td>The maximum write latency for the aggregation period, measured in seconds. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>flush_latency_seconds</td>
   <td>decimal</td>
   <td>The virtual machine disk flush latency measured in seconds.</td>
  </tr>
  <tr>
   <td>max_flush_latency_seconds</td>
   <td>decimal</td>
   <td>The maximum flush latency for the aggregation period, measured in seconds. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
  </tr>
  <tr>
   <td>vm_disk_configuration_version</td>
   <td>integer</td>
   <td>The virtual machine disk configuration version at the time of sample.</td>
  </tr>
 </tbody>
</table>

**Prev:** [Virtual Machine Interface Hourly and Daily History Views](../Virtual_machine_interface_hourly_and_daily_history_views) <br>
**Next:** [Configuration History Views](../Configuration_history_views)

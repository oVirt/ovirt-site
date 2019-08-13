---
title: Statistics History Views
---

##  Statistics History Views

Statistics data is available in `hourly`, `daily`, and `samples` views.

To query a statistics view, run `SELECT * FROM view_name_[hourly|daily|samples];`. For example:

        # SELECT * FROM v4_0_statistics_hosts_resources_usage_daily;

To list all available views, run:

        # \dv

### Enabling Debug Mode

You can enable debug mode to record log sampling, hourly, and daily job times in the **/var/log/ovirt-engine-dwh/ovirt-engine-dwhd.log** file. This is useful for checking the ETL process. Debug mode is disabled by default.

1. Log in to the Engine machine and create a configuration file (for example, **/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/logging.conf**).

2. Add the following line to the configuration file:

        # DWH_AGGREGATION_DEBUG=true

3. Restart the **ovirt-engine-dwhd** service:

        # systemctl restart ovirt-engine-dwhd.service
        To disable debug mode, delete the configuration file and restart the service.

### Storage Domain Statistics Views

**Historical Statistics for Each Storage Domain in the System**

| Name | Type | Description | Indexed |
|-
| history_id | bigint | The unique ID of this row in the table. | No |
| history_datetime | timestamp with time zone | The timestamp of this history row (rounded to minute, hour, day as per the aggregation level). | Yes |
| storage_domain_id | uuid | Unique ID of the storage domain in the system. | Yes |
| storage_domain_status | smallint | The storage domain status. | No |
| seconds_in_status | integer | The total number of seconds that the storage domain was in the status shown state as shown in the status column for the aggregation period. For example, if a storage domain was "Active" for 55 seconds and "Inactive" for 5 seconds within a minute, two rows will be reported in the table for the same minute. One row will have a status of Active with seconds_in_status of 55, the other will have a status of Inactive and seconds_in_status of 5. | No |
| minutes_in_status | numeric(7,2) | The total number of minutes that the storage domain was in the status shown state as shown in the status column for the aggregation period. For example, if a storage domain was "Active" for 55 minutes and "Inactive" for 5 minutes within an hour, two rows will be reported in the table for the same hour. One row will have a status of Active with minutes_in_status of 55, the other will have a status of Inactive and minutes_in_status of 5. | No |
| available_disk_size_gb | integer | The total available (unused) capacity on the disk, expressed in gigabytes (GB). | No |
| used_disk_size_gb | integer | The total used capacity on the disk, expressed in gigabytes (GB). | No |
| storage_configuration_version | integer | The storage domain configuration version at the time of sample. | No |

### Host Statistics Views

**Historical Statistics for Each Host in the System**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>history_id</td>
   <td>bigint</td>
   <td>The unique ID of this row in the table.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>history_datetime</td>
   <td>date</td>
   <td>The timestamp of this history row (rounded to minute, hour, day as per the aggregation level).</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>host_id</td>
   <td>uuid</td>
   <td>Unique ID of the host in the system.</td>
   <td>Yes</td>
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
   <td>No</td>
  </tr>
  <tr>
   <td>seconds_in_status</td>
   <td>integer</td>
   <td>	The total number of seconds that the host was in the status shown in the status column for the aggregation period. For example, if a host was up for 55 seconds and down for 5 seconds during a minute, two rows will show for this minute. One will have a status of <tt>Up</tt> and seconds_in_status of 55, the other will have a status of <tt>Down</tt> and a seconds_in_status of 5.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>minutes_in_status</td>
   <td>numeric(7,2)</td>
   <td>The total number of minutes that the host was in the status shown in the status column for the aggregation period. For example, if a host was up for 55 minutes and down for 5 minutes during an hour, two rows will show for this hour. One will have a status of <tt>Up</tt> and minutes_in_status of 55, the other will have a status of <tt>Down</tt> and a minutes_in_status of 5.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>memory_usage_percent</td>
   <td>smallint</td>
   <td>Percentage of used memory on the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_memory_usage</td>
   <td>smallint</td>
   <td>The maximum memory usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>ksm_shared_memory_mb</td>
   <td>bigint</td>
   <td>The Kernel Shared Memory size in megabytes (MB) that the host is using.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_ksm_shared_memory_mb</td>
   <td>bigint</td>
   <td>The maximum KSM memory usage for the aggregation period expressed in megabytes (MB). For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cpu_usage_percent</td>
   <td>smallint</td>
   <td>Used CPU percentage on the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_cpu_usage</td>
   <td>smallint</td>
   <td>The maximum CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>ksm_cpu_percent</td>
   <td>smallint</td>
   <td>CPU percentage ksm on the host is using.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_ksm_cpu_percent</td>
   <td>smallint</td>
   <td>The maximum KSM usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>active_vms</td>
   <td>smallint</td>
   <td>The average number of active virtual machines for this aggregation.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_active_vms</td>
   <td>smallint</td>
   <td>The maximum active number of virtual machines for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>total_vms</td>
   <td>smallint</td>
   <td>The average number of all virtual machines on the host for this aggregation.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_total_vms</td>
   <td>smallint</td>
   <td>The maximum total number of virtual machines for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>total_vms_vcpus</td>
   <td>integer</td>
   <td>Total number of VCPUs allocated to the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_total_vms_vcpus</td>
   <td>integer</td>
   <td>The maximum total virtual machine VCPU number for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cpu_load</td>
   <td>integer</td>
   <td>The CPU load of the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_cpu_load</td>
   <td>integer</td>
   <td>The maximum CPU load for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>system_cpu_usage_percent</td>
   <td>smallint</td>
   <td>Used CPU percentage on the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_system_cpu_usage_percent</td>
   <td>smallint</td>
   <td>The maximum system CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>swap_used_mb</td>
   <td>integer</td>
   <td>Used swap size usage of the host in megabytes (MB).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_swap_used_mb</td>
   <td>integer</td>
   <td>The maximum user swap size usage of the host for the aggregation period in megabytes (MB), expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_configuration_version</td>
   <td>integer</td>
   <td>The host configuration version at the time of sample. The host configuration version at the time of sample. This is identical to the value of `history_id` in the `v4_2_configuration_history_hosts` view and it can be used to join them.</td>
   <td>Yes</td>
  </tr>
 </tbody>
</table>

### Host Interface Statistics Views

**Historical Statistics for Each Host Network Interface in the System**

| Name | Type | Description | Indexed |
|-
| history_id | bigint | The unique ID of this row in the table. | No |
| history_datetime | timestamp with time zone | The timestamp of this history view (rounded to minute, hour, day as per the aggregation level). | Yes |
| host_interface_id | uuid | Unique identifier of the interface in the system. | Yes |
| receive_rate_percent | smallint | Used receive rate percentage on the host. | No |
| max_receive_rate_percent | smallint | The maximum receive rate for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value. | No |
| transmit_rate_percent | smallint | Used transmit rate percentage on the host. | No |
| max_transmit_rate_percent | smallint | The maximum transmit rate for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value. | No |
| received_total_byte | bigint | The total number of bytes received by the host. | No |
| transmitted_total_byte | bigint | The total number of bytes transmitted from the host. | No |
| host_interface_configuration_version | integer | The host interface configuration version at the time of sample. The host configuration version at the time of sample. This is identical to the value of `history_id` in the `v4_2_configuration_history_hosts` view and it can be used to join them. | Yes |

### Virtual Machine Statistics Views

**Historical statistics for Each Virtual Machine in the System**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td>history_id</td>
   <td>bigint</td>
   <td>The unique ID of this row in the table.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>history_datetime</td>
   <td>timestamp with time zone</td>
   <td>The timestamp of this history row (rounded to minute, hour, day as per the aggregation level).</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_id</td>
   <td>uuid</td>
   <td>Unique ID of the virtual machine in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_status</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>-1 - Unknown Status (used only to indicate problems with the ETL -- PLEASE NOTIFY SUPPORT)</li>
     <li>0 - Down</li>
     <li>1 - Up</li>
     <li>2 - Paused</li>
     <li>3 - Problematic</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>seconds_in_status</td>
   <td>integer</td>
   <td>The total number of seconds that the virtual machine was in the status shown in the status column for the aggregation period. For example, if a virtual machine was up for 55 seconds and down for 5 seconds during an minute, two rows will show for this minute. One will have a status of <tt>Up</tt> and seconds_in_status, the other will have a status of <tt>Down</tt> and a seconds_in_status of 5.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>minutes_in_status</td>
   <td>decimal</td>
   <td>The total number of minutes that the virtual machine was in the status shown in the status column for the aggregation period. For example, if a virtual machine was up for 55 minutes and down for 5 minutes during an hour, two rows will show for this hour. One will have a status of <tt>Up</tt> and minutes_in_status, the other will have a status of <tt>Down</tt> and a minutes_in_status of 5.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cpu_usage_percent</td>
   <td>smallint</td>
   <td>The percentage of the CPU in use by the virtual machine.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_cpu_usage</td>
   <td>smallint</td>
   <td>The maximum CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>memory_usage_percent</td>
   <td>smallint</td>
   <td>Percentage of used memory in the virtual machine. The guest tools must be installed on the virtual machine for memory usage to be recorded.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_memory_usage</td>
   <td>smallint</td>
   <td>The maximum memory usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value. The guest tools must be installed on the virtual machine for memory usage to be recorded.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>user_cpu_usage_percent</td>
   <td>smallint</td>
   <td>Used user CPU percentage on the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_user_cpu_usage_percent</td>
   <td>smallint</td>
   <td>The maximum user CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregation, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>system_cpu_usage_percent</td>
   <td>smallint</td>
   <td>Used system CPU percentage on the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_system_cpu_usage_percent</td>
   <td>smallint</td>
   <td>The maximum system CPU usage for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_ip</td>
   <td>text</td>
   <td>The IP address of the first NIC. Only shown if the guest agent is installed.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>currently_running_on_host</td>
   <td>uuid</td>
   <td>The unique ID of the host the virtual machine is running on.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>current_user_id</td>
   <td>uuid</td>
   <td>The unique ID of the user logged into the virtual machine console, if the guest agent is installed.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>disk_usage</td>
   <td>text</td>
   <td>The disk description. File systems type, mount point, total size, and used size.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_configuration_version</td>
   <td>integer</td>
   <td>The virtual machine configuration version at the time of sample. This is identical to the value of `history_id` in the `v4_2_configuration_history_vms` view.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>current_host_configuration_version</td>
   <td>integer</td>
   <td>The host configuration version at the time of sample. This is identical to the value of `history_id` in the `v4_2_configuration_history_hosts` view and it can be used to join them.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>memory_buffered_kb</td>
   <td>bigint</td>
   <td>The amount of buffered memory on the virtual machine, in kilobytes (KB).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>memory_cached_kb</td>
   <td>bigint</td>
   <td>The amount of cached memory on the virtual machine, in kilobytes (KB).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_memory_buffered_kb</td>
   <td>bigint</td>
   <td>The maximum buffered memory for the aggregation period, in kilobytes (KB). For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_memory_cached_kb</td>
   <td>bigint</td>
   <td>The maximum cached memory for the aggregation period, in kilobytes (KB). For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Interface Statistics Views

**Historical Statistics for the Virtual Machine Network Interfaces in the System**

| Name | Type | Description | Indexed |
|-
| history_id | integer | The unique ID of this row in the table. | No |
| history_datetime | date | The timestamp of this history row (rounded to minute, hour, day as per the aggregation level). | Yes |
| vm_interface_id | uuid | Unique identifier of the interface in the system. | Yes |
| receive_rate_percent | smallint | Used receive rate percentage on the host. | No |
| max_receive_rate_percent | smallint | The maximum receive rate for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value. | No |
| transmit_rate_percent | smallint | Used transmit rate percentage on the host. | No |
| max_transmit_rate_percent | smallint | The maximum transmit rate for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average rate. | No |
| received_total_byte | bigint | The total number of bytes received by the virtual machine. | No |
| transmitted_total_byte | bigint | The total number of bytes transmitted from the virtual machine. | No |
| vm_interface_configuration_version | integer | The virtual machine interface configuration version at the time of sample. This is identical to the value of `history_id` in the `v4_2_configuration_history_vms_interfaces` view and it can be used to join them. | Yes |

### Virtual Disk Statistics Views

**Historical Statistics for the Virtual Disks in the System**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>history_id</td>
   <td>bigint</td>
   <td>The unique ID of this row in the table.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>history_datetime</td>
   <td>date</td>
   <td>The timestamp of this history row (rounded to minute, hour, day as per the aggregation level).</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_disk_id</td>
   <td>uuid</td>
   <td>Unique ID of the disk in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_disk_status</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - Unassigned</li>
     <li>1 - OK</li>
     <li>2 - Locked</li>
     <li>3 - Invalid</li>
     <li>4 - Illegal</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>seconds_in_status</td>
   <td>integer</td>
   <td>The total number of seconds that the virtual machine disk was in the status shown in the status column for the aggregation period. For example, if a virtual machine was up for 55 seconds and down for 5 seconds during an minute, two rows will show for this minute. One will have a status of <tt>Locked</tt> and seconds_in_status, the other will have a status of <tt>OK</tt> and a seconds_in_status of 5.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>minutes_in_status</td>
   <td>decimal</td>
   <td>The total number of minutes that the virtual machine disk was in the status shown in the status column for the aggregation period. For example, if a virtual machine disk was locked for 55 minutes and OK for 5 minutes during an hour, two rows will show for this hour. One will have a status of <tt>Locked</tt> and minutes_in_status of 55, the other will have a status of <tt>OK</tt> and a minutes_in_status of 5.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_disk_actual_size_mb</td>
   <td>integer</td>
   <td>The actual size allocated to the disk.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>read_rate_bytes_per_second</td>
   <td>integer</td>
   <td>Read rate to disk in bytes per second.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_read_rate_bytes_per_second</td>
   <td>integer</td>
   <td>The maximum read rate for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>read_latency_seconds</td>
   <td>numeric(18,9)</td>
   <td>The virtual machine disk read latency measured in seconds.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>write_rate_bytes_per_second</td>
   <td>integer</td>
   <td>Write rate to disk in bytes per second.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_read_latency_seconds</td>
   <td>decimal</td>
   <td>The maximum read latency for the aggregation period, measured in seconds. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_write_rate_bytes_per_second</td>
   <td>integer</td>
   <td>The maximum write rate for the aggregation period. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>write_latency_seconds</td>
   <td>decimal</td>
   <td>The virtual machine disk write latency measured in seconds.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_write_latency_seconds</td>
   <td>numeric(18,9)</td>
   <td>The maximum write latency for the aggregation period, measured in seconds. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>flush_latency_seconds</td>
   <td>decimal</td>
   <td>The virtual machine disk flush latency measured in seconds.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>max_flush_latency_seconds</td>
   <td>numeric(18,9)</td>
   <td>The maximum flush latency for the aggregation period, measured in seconds. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_disk_configuration_version</td>
   <td>integer</td>
   <td>The virtual disk configuration version at the time of sample. This is identical to the value of `history_id` in the `v4_2_configuration_history_vms_disks` view and it can be used to join them.</td>
   <td>Yes</td>
  </tr>
 </tbody>
</table>

**Prev:** [Allowing Read Only Access to the History Database](Allowing_Read_Only_Access_to_the_History_Database) <br>
**Next:** [Configuration History Views](Configuration_history_views)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/sect-statistics_history_views)

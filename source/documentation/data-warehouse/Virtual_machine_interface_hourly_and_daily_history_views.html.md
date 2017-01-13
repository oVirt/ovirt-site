# Virtual Machine Interface Hourly and Daily History Views

**Historical Statistics for the Virtual Machine Network Interfaces in the System**

| Name | Type | Description |
|-
| history_id | bigint | The unique ID of this row in the table. |
| history_datetime | timestamp with time zone | The timestamp of this history row (rounded to minute, hour, day as per the aggregation level). |
| vm_interface_id | uuid | Unique identifier of the interface in the system. |
| receive_rate_percent | smallint | Used receive rate percentage on the host. |
| max_receive_rate_percent | smallint | The maximum receive rate for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average value. |
| transmit_rate_percent | smallint | Used transmit rate percentage on the host. |
| max_transmit_rate_percent | smallint | The maximum transmit rate for the aggregation period, expressed as a percentage. For hourly aggregations, this is the maximum collected sample value. For daily aggregations, it is the maximum hourly average rate. |
| vm_interface_configuration_version | integer | The virtual machine interface configuration version at the time of sample. |

**Prev:** [Virtual Machine Hourly and Daily History Views](Virtual_machine_hourly_and_daily_history_views) <br>
**Next:** [Virtual Machine Disk Hourly and Samples History Views](Vitual_machine_disk_hourly_and_samples_history_views)

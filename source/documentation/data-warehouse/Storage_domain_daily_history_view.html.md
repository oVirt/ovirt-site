# Storage Domain Daily History View

**Historical Statistics for Each Storage Domain in the System**

| Name | Type | Description |
|-
| history_id | bigint | The unique ID of this row in the table. |
| history_datetime | timestamp with time zone | The timestamp of this history row (rounded to minute, hour, day as per the aggregation level). |
| storage_domain_id | uuid | Unique ID of the storage domain in the system. |
| available_disk_size_gb | integer | The total available (unused) capacity on the disk, expressed in gigabytes (GB). |
| used_disk_size_gb | integer | The total used capacity on the disk, expressed in gigabytes (GB). |
| storage_configuration_version | integer | The storage domain configuration version at the time of sample. |
| storage_domain_status | smallint | The storage domain status. |
| minutes_in_status | decimal | The total number of minutes that the storage domain was in the status shown state as shown in the status column for the aggregation period. For example, if a storage domain was "Active" for 55 minutes and "Inactive" for 5 minutes within an hour, two rows will be reported in the table for the same hour. One row will have a status of Active with minutes_in_status of 55, the other will have a status of Inactive and minutes_in_status of 5. |

**Prev:** [Datacenter Daily History View](Datacenter_daily_history_view) <br>
**Next:** [Host Hourly and Daily History Views](Host_hourly_and_daily_history_views)

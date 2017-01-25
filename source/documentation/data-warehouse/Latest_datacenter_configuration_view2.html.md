# Datacenter Storage Domain Map

The following table shows the relationships between storage domains and data centers in the system.

**v3_5_map_history_datacenters_storage_domains**

| Name | Type | Description |
|-
| history_id | integer | The ID of the configuration version in the history database. |
| storage_domain_id | uuid | The unique ID of this storage domain in the system. |
| datacenter_id | uuid | The unique ID of the data center in the system. |
| attach_date | timestamp with time zone | The date the storage domain was attached to the data center. |
| detach_date | timestamp with time zone | The date the storage domain was detached from the data center. |

**Prev:** [Data Center Configuration](../Latest_datacenter_configuration_view1) <br>
**Next:** [Latest Storage Domain Configuration View](../Latest_storage_domain_configuration_view)

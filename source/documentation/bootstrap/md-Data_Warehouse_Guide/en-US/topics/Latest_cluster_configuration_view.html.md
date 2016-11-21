# Cluster Configuration

The following table shows the configuration history parameters of the clusters in the system.

**v3_5_configuration_history_clusters**

| Name | Type | Description |
|-
| history_id    | integer      | The ID of the configuration version in the history database. |
| cluster_id    | uuid         | The unique identifier of the datacenter this cluster resides in. |
| cluster_name  | varchar(40)  | Name of the cluster, as displayed in the edit dialog. |
| cluster_description | varchar(4000) | As defined in the edit dialog. |
| datacenter_id | uuid         | The unique identifier of the datacenter this cluster resides in. |
| cpu_name      | varchar(255) | As displayed in the edit dialog. |
| compatibility_version | varchar(40) | As displayed in the edit dialog. |
| datacenter_configuration_version | integer | The data center configuration version at the time of creation or update. |
| create_date   | timestamp with time zone | The date this entity was added to the system. |
| update_date   | timestamp with time zone | The date this entity was changed in the system. |
| delete_date   | timestamp with time zone | The date this entity was deleted from the system. |


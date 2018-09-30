# Disk Consumption Metrics

Disk consumption (DF) metrics enable you to monitor metrics about disk consumption, such as the used, reserved, and free space for each mounted file system. 

The following table describes the disk consumption metrics reported by the *DF* plugin.

| Metric Name |Description |
|-
| collectd.df.df_complex |The amount of free, used, and reserved disk space, in bytes, on this file system.|
| collectd.df.percent_bytes |The amount of free, used, and reserved disk space, as a percentage of total disk space, on this file system. |

**Additional Values**

* **collectd.plugin:** DF
* **collectd.type_instance:** free, used, reserved
* **collectd.plugin_instance:** *A mounted partition* 
* **ovirt.entity:** host
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10
* **collectd.dstypes:** [Gauge](../Gauge)

# Swap Metrics

Swap metrics enable you to view the amount of memory currently written onto the hard disk, in bytes, according to available, used, and cached swap space. 

The following table describes the Swap metrics reported by the **Swap** plugin.

**Swap Metrics**

|Metric Name |collectd.type |collectd.type_instance|collectd.dstypes |Description|
|-
|collectd.swap.swap |swap |used / free /  cached|[Gauge](../Gauge)|The used, available, and cached swap space (in bytes). |
|collectd.swap.swap_io|swap_io |in / out |[Derive](../Derive) |The number of swap pages written and read per second.\
|collectd.swap.percent|percent |used / free / cached |[Gauge](../Gauge) |The percentage of used, available, and cached swap space.|


**Additional Fields**

* **collectd.plugin:** Swap
* **collectd.plugin_instance:** None
* **ovirt.entity:** host or Manager
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10


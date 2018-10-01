# Virtual Machine Metrics

The following table describes the virtual machine metrics reported by the **Virt** plugin.

|Metric Name |collectd.type |collectd.type_instance |collectd.dstypes
|-
|collectd.virt.ps_cputime.syst |ps_cputime.syst |N/A |[Derive](../Derive)|
|collectd.virt.percent |percent |virt_cpu_total |[Gauge](../Gauge)|
|collectd.virt.ps_cputime.user |ps_cputime.user |N/A |[Derive](../Derive)|
|collectd.virt.virt_cpu_total |virt_cpu_total |CPU number |[Derive](../Derive)|
|collectd.virt.virt_vcpu |virt_vcpu |CPU number |[Derive](../Derive)|
|collectd.virt.disk_octets.read |disk_octets.read |disk name |[Gauge](../Gauge)|
|collectd.virt.disk_ops.read |disk_ops.read |disk name |[Gauge](../Gauge)|
|collectd.virt.disk_octets.write |disk_octets.write |disk name |[Gauge](../Gauge)|
|collectd.virt.disk_ops.write |disk_ops.write |disk name |[Gauge](../Gauge)|
|collectd.virt.if_octets.rx |if_octets.rx |network name |[Derive](../Derive)|
|collectd.virt.if_dropped.rx |if_dropped.rx |network name |[Derive](../Derive)|
|collectd.virt.if_errors.rx|if_errors.rx |network name |[Derive](../Derive)|
|collectd.virt.if_octets.tx|if_octets.tx |network name |[Derive](../Derive)|
|collectd.virt.if_dropped.tx |if_dropped.tx |network name |[Derive](../Derive)|
|collectd.virt.if_errors.tx |if_errors.tx |network name |[Derive](../Derive)|
|collectd.virt.if_packets.rx |if_packets.rx |network name |[Derive](../Derive)|
|collectd.virt.if_packets.tx |if_packets.tx |network name |[Derive](../Derive)|
|collectd.virt.memory|memory |rss / total /actual_balloon / available / unused / usable / last_update / major_fault / minor_fault / swap_in / swap_out |[Gauge](../Gauge)|
|collectd.virt.total_requests |total_requests |flush-DISK |[Derive](../Derive)|
|collectd.virt.total_time_in_ms |total_time_in_ms |flush-DISK |[Derive](../Derive)|
|collectd.virt.total_time_in_ms |total_time_in_ms |flush-DISK |[Derive](../Derive)|

**Additional Values**

* **collectd.plugin:** virt
* **collectd.plugin_instance:** The virtual machine's name 
* **ovirt.entity:** vm
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10


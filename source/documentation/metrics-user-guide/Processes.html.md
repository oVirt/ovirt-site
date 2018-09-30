# Process Metrics

The following table describes the process metrics reported by the **Processes** plugin.

|Metric Name |collectd.type |collectd.dstypes|
|-
|collectd.processes.ps_state |ps_state |[Gauge](../Gauge)|
|collectd.processes.ps_disk_ops.read |ps_disk_ops |[Derive](../Derive)|
|collectd.processes.ps_disk_ops.write |ps_disk_ops |[Derive](../Derive)|
|collectd.processes.ps_vm |ps_vm |[Gauge](../Gauge)|
|collectd.processes.ps_rss|ps_rss|[Gauge](../Gauge)|
|collectd.processes.ps_data|ps_data|[Gauge](../Gauge)|
|collectd.processes.ps_code|ps_code|[Gauge](../Gauge)|
|collectd.processes.ps_stacksize|ps_stacksize|[Gauge](../Gauge)|
|collectd.processes.ps_cputime.syst|ps_cputime|[Derive](../Derive)|
|collectd.processes.ps_cputime.user|ps_cputime|[Derive](../Derive)|
|collectd.processes.ps_count.processes|ps_count|[Gauge](../Gauge)|
|collectd.processes.ps_count.threads|ps_count|[Gauge](../Gauge)|
|collectd.processes.ps_pagefaults.majfltadd |ps_pagefaults|[Derive](../Derive)|
|collectd.processes.ps_pagefaults.minflt |ps_pagefaults|[Derive](../Derive)|
|collectd.processes.ps_disk_octets.write |ps_disk_octets |[Derive](../Derive)|
| collectd.processes.ps_disk_octets.read|ps_disk_octets |[Derive](../Derive)|
|collectd.processes.fork_rate |fork_rate |[Derive](../Derive)|

**Additional Values**

* **collectd.plugin:** Processes
* **collectd.plugin_instance:** *The process's name (except for collectd.processes.fork_rate=N/A)*
* **collectd.type_instance:** N/A (except for collectd.processes.ps_state=running/ zombies/ stopped/ paging/ blocked/ sleeping)
* **ovirt.entity:** host 
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10


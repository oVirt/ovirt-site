# Entropy Metrics

Entropy metrics display the available entropy pool size on the host. Entropy is important for generating random numbers, which are used for encryption, authorization, and similar tasks.  

The following table describes the entropy metrics reported by the **Entropy** plugin.

**Entropy Metrics**

|Metric Name |Description|
|-
|collectd.entropy.entropy |The entropy pool size, in bits, on the host. |

**Additional Values**

* **collectd.plugin:** Entropy
* **collectd.type_instance:** None
* **collectd.plugin_instance:** None
* **ovirt.entity:** host
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10
* **collectd.dstypes:** [Gauge](../Gauge)


# Aggregation Metrics

The Aggregation metric aggregates several values into one using aggregation functions such as sum, average, min, and max. It is used to provide a combined value for average and total CPU statistics.

The following table describes the aggregation metrics reported by the **Aggregation** plugin.

<table>
<tr>
<th>Metric Name</th>
<th>collectd.type_instance</th>
<th>Description</th>
</tr>
<tr>
<td>collectd.aggregation.percent a</td>
<td><ul>
<li>interrupt</li>
<li>user</li>
<li>wait</li>
<li>nice</li>
<li>softirq</li>
<li>system</li>
<li>idle</li>
<li>steal</li>
</ul></td>
<td>The average and total CPU usage, as an aggregated percentage, for each of the *collectd.type_instance* states.</td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** Aggregation
* **collectd.type_instance:** cpu-average / cpu-sum
* **collectd.plugin_instance:** 
* **collectd.type:** percent
* **ovirt.entity:** host
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10
* **collectd.dstypes:** [Gauge](../Gauge)

# CPU Metrics

CPU metrics display the amount of time spent by the hosts' CPUs, as a percentage.

The following table describes CPU metrics as reported by the **CPU** plugin.

**CPU Metrics**

<table>
<tr>
<th>Metric Name</th>
<th>collectd.type_instance</th>
<th>Description</th>
</tr>
<tr>
<td>collectd.cpu.percent a</td>
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
<td>The percentage of time spent, per CPU, in the *collectd.type_instance* states.</td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** CPU
* **collectd.plugin_instance:** *The CPU's number*
* **collectd.type:** percent
* **ovirt.entity:** host
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10
* **collectd.dstypes:** [Gauge](../Gauge)


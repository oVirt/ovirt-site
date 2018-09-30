# Memory Metrics

Metrics collected about memory usage.

The following table describes the memory usage metrics reported by the *Memory* plugin.

**Memory Metrics**

<table>
<tr>
  <th>Metric Name</th>
  <th>collectd.type</th>
  <th>collectd.type_instance</th>
  <th>Description</th>
</tr>
<tr>
  <td rowspan="6">collectd.memory.memory</td>
  <td rowspan="6">memory</td>
  <td>used</td>
  <td>The total amount of memory used.</td>
</tr>
<tr>
  <td>free</td>
  <td>The total amount of unused memory.</td>
</tr>
<tr>
  <td>cached</td>
  <td>The amount of memory used for caching disk data for reads, memory-mapped files, or tmpfs data.</td>
</tr>
<tr>
  <td>buffered</td>
  <td>The amount of memory used for buffering, mostly for I/O operations.</td>
</tr>
<tr>
  <td>slab_recl</td>
  <td>The amount of reclaimable memory used for slab kernel allocations.</td>
</tr>
<tr>
  <td>slab_unrecl</td>
  <td>Amount of unreclaimable memory used for slab kernel allocations.</td>
</tr>
<tr>
  <td rowspan="6">collectd.memory.percent</td>
  <td rowspan="6">percent</td>
  <td>used</td>
  <td>The total amount of memory used, as a percentage.</td>
</tr>
<tr>
  <td>free</td>
  <td>The total amount of unused memory, as a percentage.</td>
</tr>
<tr>
  <td>cached</td>
  <td>The amount of memory used for caching disk data for reads, memory-mapped files, or tmpfs data, as a percentage.</td>
</tr>
<tr>
  <td>buffered</td>
  <td>The amount of memory used for buffering I/O operations, as a percentage.</td>
</tr>
<tr>
  <td>slab_recl</td>
  <td>The amount of reclaimable memory used for slab kernel allocations, as a percentage.</td>
</tr>
<tr>
  <td>slab_unrecl</td>
  <td>The amount of unreclaimable memory used for slab kernel allocations, as a percentage.</td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** Memory
* **collectd.plugin_instance:** None
* **ovirt.entity:** Host
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10
* **collectd.dstypes:** [Gauge](../Gauge)


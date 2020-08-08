---
title: Analyzing Metrics
---

# Chapter 2: Analyzing Metrics

Kibana offers two ways of analyzing metrics:

* Build your own visualizations such as charts, graphs, and tables.

* Load and use predefined sets of visualizations

The oVirt Project suggests that you start off by using the predefined visualizations. Each set is known as a _dashboard_. Dashboards have the advantage of enabling you to quickly access a wide range of metrics while offering the flexibility of changing them to match your individual needs.

# Using Dashboards

A dashboard displays a set of saved visualizations. Dashboards have the advantage of enabling you to quickly access a wide range of metrics while offering the flexibility of changing them to match your individual needs.

You can use the **Dashboard** tab to create your own dashboards. Alternatively, Red Hat provides the following dashboard examples, which you can import into Kibana and use as is or customize to suit your specific needs:

* System dashboard

* Hosts dashboard

* VMs dashboard

**Importing Dashboard Examples**

1. Copy the `/etc/ovirt-engine-metrics/dashboards-examples` directory from the Engine virtual machine to your local machine.

2. Open Kibana and click the **Settings** tab.

3. Click the **Indices** tab.

4. Select the **Index Patterns** that start with `project.*` in the **Index Patterns** pane and click the **Refresh field list** ![](/images/metrics-user-guide/refresh.png) button.

5. Do step #4 for each relevant index pattern.

6. Click the **Objects** tab.

7. Click **Import** and import **Searches** from your local copy of `/etc/ovirt-engine-metrics/dashboards-examples`.

**NOTE** Admin user will be notofied to choose the relevant **Index Patterns** for the imported searches. Choose `project.*`.

8. Click **Import** and import **Visualizations**.

**NOTE** Admin user will be notofied to choose the relevant **Index Patterns** for the imported searches. Choose `project.*`.

**If you see an error message while importing the visualizations, check your hosts to ensure that Collectd and Fluentd are running without errors.**

9. Click **Import** and import **Dashboards**.

   The imported dashboards are now stored in the system.

**Loading Saved Dashboards**

Once you have created and saved a dashboard, or imported Red Hat's sample dashboards, you can display them in the *Dashboard* tab:

1. Click the **Dashboard** tab.

2. Click the **Load Saved Dashboard** ![](/images/metrics-user-guide/loadSavedDashboard.png) button to display a list of saved dashboards.

3. Click a saved dashboard to load it.

## Creating a New Visualization

Use the **Visualize** page to design data visualizations based on the metrics or log data collected by Metrics Store.
You can save these visualizations, use them individually, or combine visualizations into a dashboard.
A visualization can be based on one of the following data source types:

* A new interactive search

* A saved search

* An existing saved visualization

Visualizations are based on Elasticsearch's [aggregation feature](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/search-aggregations.html).

**Creating a New Visualization**

Kibana guides you through the creation process with the help of a visualization wizard.

1. To start the new visualization wizard, click the **Visualize** tab.

2. In step 1, **Create a new visualization table**, select the type of visualization you want to create.

3. In step 2, **Select a search source**, select whether you want to create a new search or reuse a saved search:

   * To create a new search, select **From a new search** and enter the indexes to use as the source. Use *project.ovirt-logs* prefix for log data or *project.ovirt-metrics* prefix for metric data.

   * To create a visualization from a saved search, select **From a saved search** and enter the name of the search.

     The visualization editor appears.

## Graphic User Interface Elements

The visualization editor consists of three main areas:

* ![](/images/metrics-user-guide/1.png) The toolbar

* ![](/images/metrics-user-guide/2.png) The aggregation builder

* ![](/images/metrics-user-guide/3.png) The preview pane

**Visualization Editor**

![visualization editor screenshot](/images/metrics-user-guide/visualize.png)

## Using the Visualization Editor

Use the visualization editor to create visualizations by:

* Submitting search queries from the toolbar

* Selecting metrics and aggregations from the aggregation builder

### Submitting Search Queries

Use the toolbar to perform search queries based on the Lucene query parser syntax. For a detailed explanation of this syntax, see [Apache Lucene - Query Parser Syntax](https://lucene.apache.org/core/2_9_4/queryparsersyntax.html).

### Selecting Metrics and Aggregations

Use the aggregation builder to define which metrics to display, how to aggregate the data, and how to group the results.

The aggregation builder performs two types of aggregations, metric and bucket, which differ depending on the type of visualization you are creating:

* Bar, line, or area chart visualizations use **metrics** for the y-axis and **buckets** for the x-axis, segment bar colors, and row/column splits.

* Pie charts use **metrics** for the slice size and **buckets** to define the number of slices.

**To define a visualization from the aggregation bar:**

1. Select the metric aggregation for your visualization’s y-axis from the **Aggregation** drop-down list in the **metrics** section, for example, count, average, sum, min, max, or unique count. For more information about how these aggregations are calculated, see [Metrics Aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/2.3//search-aggregations-metrics.html) in the Elasticsearch Reference documentation.

2. Use the **buckets** area to select the aggregations for the visualization’s x-axis, color slices, and row/column splits:

   i. Use the **Aggregation** drop-down list to define how to aggregate the bucket. Common bucket aggregations include date histogram, range, terms, filters, and significant terms.

      **Note:** The order in which you define the buckets determines the order in which they will be executed, so the first aggregation determines the data set for any subsequent aggregations. For more information, see [Aggregation Builder](https://www.elastic.co/guide/en/kibana/4.5/visualize.html#aggregation-builder) in the Kibana documentation.

   ii. Select the metric you want to display from the **Field** drop-down list. For details about each of the available metrics, see [Metrics Schema](#metrics-schema).

   iii. Select the required interval from the **Interval** field.

3. Click **Apply Changes** ![](/images/metrics-user-guide/create.png).

## Metrics Schema

The following sections describe the metrics that are available from the *Field* menu when creating visualizations.

    **Note:** All metric values are collected at 10 second intervals.

### Aggregation Metrics

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

* **collectd.dstypes:** Gauge

### CPU Metrics

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

* **collectd.dstypes:** Gauge

### CPU Load Average Metrics

CPU load represents CPU contention, that is, the average number of schedulable processes at any given time. This is reported as an average value for all CPU cores on the host. Each CPU core can only execute one process at a time. Therefore, a CPU load average above 1.0 indicates that the CPUs have more work than they can perform, and the system is overloaded.

CPU load is reported over short term (last one minute), medium term (last five minutes) and long term (last fifteen minutes). While it is normal for a host's short term load average to exceed 1.0 (for a single CPU), sustained load average above 1.0 on a host may indicate a problem.

On multi-processor systems, the load is relative to the number of processor cores available. The "100% utilization" mark is 1.00 on a single-core, 2.00 on a dual-core, 4.00 on a quad-core system.

The oVirt Project recommends looking at CPU load in conjunction with CPU Metrics.

The following table describes the CPU load metrics reported by the **Load** plugin.

**CPU Load Average Metrics**

| Metric Name | Description |
|-
| collectd.load.load.longterm |Average number of schedulable processes per CPU core over the last 15 minutes. A value above 1.0 indicates the system was overloaded during the last 15 minutes. |
| collectd.load.load.midterm |Average number of schedulable processes per CPU core over the last five minutes. A value above 1.0 indicates the system was overloaded during the last 5 minutes. |
| collectd.load.load.shortterm |Average number of schedulable processes per CPU core over the last one minute. A value above 1.0 indicates the system was overloaded during the last minute. |

**Additional Values**

* **collectd.plugin:** Load

* **collectd.type:** load

* **collectd.type_instance:** None

* **collectd.plugin_instance:** None

* **ovirt.entity:** host

* **ovirt.cluster.name.raw:** *The cluster's name*

* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*

* **hostname:** *The host's FQDN*

* **ipaddr4:** *IP address*

* **interval:** 10

* **collectd.dstypes:** Gauge

### Disk Consumption Metrics

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

* **collectd.dstypes:** Gauge

### Disk Operation Metrics

Disk operation metrics are reported per physical disk on the host, and per partition.

The following table describes the disk operation metrics reported by the **Disk** plugin.

**Disk Operation Metrics**

|Metric Name |Description |collectd.dstypes|
|-
| collectd.disk.disk_ops.read |The number of disk read operations. |Derive|
| collectd.disk.disk_ops.write |The number of disk write operations. |Derive|
| collectd.disk.disk_merged.read |The number of disk reads that have been merged into single physical disk access operations. In other words, this metric measures the number of instances in which one physical disk access served multiple disk reads. The higher the number, the better. |Derive|
| collectd.disk.disk_merged.write |The number of disk writes that were merged into single physical disk access operations. In other words, this metric measures the number of instances in which one physical disk access served multiple write operations. The higher the number, the better. |Derive|
| collectd.disk.disk_time.read |The average amount of time it took to do a read operation, in milliseconds. |Derive|
| collectd.disk.disk_time.write |The average amount of time it took to do a write operation, in milliseconds. |Derive|
| collectd.disk.pending_operations |The queue size of pending I/O operations. |Gauge|
| collectd.disk.disk_io_time.io_time | The time spent doing I/Os in milliseconds. This can be used as a device load percentage, where a value of 1 second of time spent represents a 100% load.  |Derive|
| collectd.disk.disk_io_time.weighted_io_time |A measure of both I/O completion time and the backlog that may be accumulating.  |Derive|

**Additional Values**

* **collectd.plugin:** Disk

* **collectd.type_instance:** None

* **collectd.plugin_instance:** *The disk's name*

* **ovirt.entity:** host

* **ovirt.cluster.name.raw:** *The cluster's name*

* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*

* **hostname:** *The host's FQDN*

* **ipaddr4:** *IP address*

* **interval:** 10

### Entropy Metrics

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

* **collectd.dstypes:** Gauge

### Network Interface Metrics

The following types of metrics are reported from physical and virtual network interfaces on the host:

* Bytes (octets) transmitted and received (total, or per second)

* Packets transmitted and received (total, or per second)

* Interface errors (total, or per second)

The following table describes the network interface metrics reported by the **Interface** plugin.

**Network Interface Metrics**

<table>
<tr>
  <th>collectd.type</th>
  <th>Metric Name</th>
  <th>Description</th>
</tr>
<tr>
  <td>if_octets</td>
  <td>collectd.interface.if_octets.rx</td>
  <td>
    <p>A count of the bytes received by the interface. You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in bytes/sec.</li>
      <li>Max: Provides the cumulative count of bytes received. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_octets</td>
  <td>collectd.interface.if_octets.tx</td>
  <td>
    <p>A count of the bytes transmitted by the interface. You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in bytes/sec.</li>
      <li>Max: Provides the cumulative count of bytes transmitted. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_packets</td>
  <td>collectd.interface.if_packets.rx</td>
  <td>
    <p>A count of the packets received by the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in bytes/sec.</li>
      <li>Max: Provides the cumulative count of packets received. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded. </li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_packets</td>
  <td>collectd.interface.if_packets.tx</td>
  <td>
    <p>A count of the packets transmitted by the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in packets/sec.</li>
      <li>Max: Provides the cumulative count of packets transmitted. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded. </li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_errors</td>
  <td>collectd.interface.if_errors.rx</td>
  <td>
    <p>A count of errors received on the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max).</p>
    <ul>
      <li>Rate/sec rollup provides the current rate of errors received on the interface in errors/sec.</li>
      <li>Max rollup provides the total number of errors received since the beginning. Note that since this is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_errors</td>
  <td>collectd.interface.if_errors.tx</td>
  <td>
    <p>A count of errors transmitted on the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max).</p>
    <ul>
      <li>Rate/sec rollup provides the current rate of errors transmitted on the interface in errors/sec.</li>
      <li>Max rollup provides the total number of errors transmitted since the beginning. Note that since this is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_dropped</td>
  <td>collectd.interface.if_dropped.rx</td>
  <td></td>
</tr>
<tr>
  <td>if_dropped</td>
  <td>collectd.interface.if_dropped.tx</td>
  <td></td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** Interface

* **collectd.type_instance:** None

* **collectd.plugin_instance:** *The network's name*

* **ovirt.entity:** host

* **ovirt.cluster.name.raw:** *The cluster's name*

* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*

* **hostname:** *The host's FQDN*

* **ipaddr4:** *IP address*

* **interval:** 10

* **collectd.dstypes:** Derive

### Memory Metrics

Metrics collected about memory usage.

The following table describes the memory usage metrics reported by the **Memory** plugin.

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

* **collectd.dstypes:** Gauge

### NFS Metrics

NFS metrics enable you to analyze the use of NFS procedures.

The following table describes the NFS metrics reported by the **NFS** plugin.

<table>
<tr>
  <th>Metric Name</th>
  <th colspan="3">collectd.type_instance</th>
  <th>Description</th>
</tr>
<tr>
  <td>collectd.nfs.nfs_procedure </td>
  <td>null / getattr / lookup / access / readlink / read / write / create / mkdir / symlink / mknod / rename / readdir / remove / link / fsstat / fsinfo / readdirplus / pathconf / rmdir / commit / compound / reserved / access / close / delegpurge / putfh / putpubfh putrootfh / renew / restorefh / savefh / secinfo </td>
  <td> / setattr / setclientid / setcltid_confirm / verify / open / openattr / open_confirm / exchange_id / create_session / destroy_session / bind_conn_to_session / delegreturn / getattr / getfh / lock / lockt / locku / lookupp /  open_downgrade / nverify </td>
  <td> / release_lockowner / backchannel_ctl / free_stateid / get_dir_delegation / getdeviceinfo / getdevicelist / layoutcommit / layoutget / layoutreturn / secinfo_no_name / sequence / set_ssv / test_stateid / want_delegation / destroy_clientid / reclaim_complete </td>
  <td>The number of processes per _collectd.type_instance_ state.</td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** NFS

* **collectd.plugin_instance:** *File system + server or client (for example: v3client)*

* **collectd.type:** nfs_procedure

* **ovirt.entity:** host

* **ovirt.cluster.name.raw:** *The cluster's name*

* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*

* **hostname:** *The host's FQDN*

* **ipaddr4:** *IP address*

* **interval:** 10

* **collectd.dstypes:** Derive

# PostgreSQL Metrics

PostgreSQL data collected by executing SQL statements on a PostgreSQL database.

The following table describes the PostgreSQL metrics reported by the **PostgreSQL** plugin.

**PostgreSQL Metrics**

<table>
<tr>
  <th>Metric Name</th>
  <th>collectd.type_instance</th>
  <th>Description</th>
</tr>
<tr>
  <td>collectd.postgresql.pg_numbackends</td>
  <td>N/A</td>
  <td>How many server processes this database is using.</td>
</tr>
<tr>
  <td rowspan="2">collectd.postgresql.pg_n_tup_g</td>
  <td>live</td>
  <td>The number of live rows in the database. </td>
</tr>
<tr>
  <td>dead</td>
  <td>The number of dead rows in the database. Rows that are deleted or obsoleted by an update are not physically removed from their table; they remain present as dead rows until a VACUUM is performed.</td>
</tr>
<tr>
  <td rowspan="4">collectd.postgresql.pg_n_tup_c</td>
  <td>del</td>
  <td>The number of delete operations. </td>
</tr>
<tr>
  <td>upd</td>
  <td>The number of update operations. </td>
</tr>
<tr>
  <td>hot_upd</td>
  <td>The number of update operations that have been performed without requiring an index update. </td>
</tr>
<tr>
  <td>ins</td>
  <td>The number of insert operations.</td>
</tr>
<tr>
  <td>collectd.postgresql.pg_xact</td>
  <td>num_deadlocks</td>
  <td>The number of deadlocks that have been detected by the database. Deadlocks are caused by two or more competing actions that are unable to finish because each is waiting for the other's resources to be unlocked. </td>
</tr>
<tr>
  <td>collectd.postgresql.pg_db_size</td>
  <td>N/A</td>
  <td>The size of the database on disk, in bytes.  </td>
</tr>
<tr>
  <td rowspan="7">collectd.postgresql.pg_blks a</td>
  <td>heap_read </td>
  <td>How many disk blocks have been read. </td>
</tr>
<tr>
  <td>heap_hit </td>
  <td>How many read operations were served from the buffer in memory, so that a disk read was not necessary. This only includes hits in the PostgreSQL buffer cache, not the operating system's file system cache. </td>
</tr>
<tr>
  <td>idx_read </td>
  <td>How many disk blocks have been read by index access operations.</td>
</tr>
<tr>
  <td>idx_hit </td>
  <td>How many index access operations have been served from the buffer in memory.</td>
</tr>
<tr>
  <td>toast_read </td>
  <td>How many disk blocks have been read on TOAST tables.</td>
</tr>
<tr>
  <td>toast_hit </td>
  <td>How many TOAST table reads have been served from buffer in memory.</td>
</tr>
<tr>
  <td>tidx_read </td>
  <td>How many disk blocks have been read by index access operations on TOAST tables.</td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** Postgresql

* **collectd.plugin_instance:** *Database's Name*

* **ovirt.entity:** engine

* **ovirt.cluster.name.raw:** *The cluster's name*

* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*

* **hostname:** *The host's FQDN*

* **ipaddr4:** *IP address*

* **interval:** 10

* **collectd.dstypes:** Gauge

### Process Metrics

The following table describes the process metrics reported by the **Processes** plugin.

|Metric Name |collectd.type |collectd.dstypes|
|-
|collectd.processes.ps_state |ps_state |Gauge|
|collectd.processes.ps_disk_ops.read |ps_disk_ops |Derive|
|collectd.processes.ps_disk_ops.write |ps_disk_ops |Derive|
|collectd.processes.ps_vm |ps_vm |Gauge|
|collectd.processes.ps_rss|ps_rss|Gauge|
|collectd.processes.ps_data|ps_data|Gauge|
|collectd.processes.ps_code|ps_code|Gauge|
|collectd.processes.ps_stacksize|ps_stacksize|Gauge|
|collectd.processes.ps_cputime.syst|ps_cputime|Derive|
|collectd.processes.ps_cputime.user|ps_cputime|Derive|
|collectd.processes.ps_count.processes|ps_count|Gauge|
|collectd.processes.ps_count.threads|ps_count|Gauge|
|collectd.processes.ps_pagefaults.majfltadd |ps_pagefaults|Derive|
|collectd.processes.ps_pagefaults.minflt |ps_pagefaults|Derive|
|collectd.processes.ps_disk_octets.write |ps_disk_octets |Derive|
| collectd.processes.ps_disk_octets.read|ps_disk_octets |Derive|
|collectd.processes.fork_rate |fork_rate |Derive|

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

### Swap Metrics

Swap metrics enable you to view the amount of memory currently written onto the hard disk, in bytes, according to available, used, and cached swap space.

The following table describes the Swap metrics reported by the **Swap** plugin.

**Swap Metrics**

|Metric Name |collectd.type |collectd.type_instance|collectd.dstypes |Description|
|-
|collectd.swap.swap |swap |used / free /  cached|Gauge|The used, available, and cached swap space (in bytes). |
|collectd.swap.swap_io|swap_io |in / out |Derive |The number of swap pages written and read per second.\
|collectd.swap.percent|percent |used / free / cached |Gauge |The percentage of used, available, and cached swap space.|

**Additional Fields**

* **collectd.plugin:** Swap

* **collectd.plugin_instance:** None

* **ovirt.entity:** host or Manager

* **ovirt.cluster.name.raw:** *The cluster's name*

* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*

* **hostname:** *The host's FQDN*

* **ipaddr4:** *IP address*

* **interval:** 10

### Virtual Machine Metrics

The following table describes the virtual machine metrics reported by the **Virt** plugin.

|Metric Name |collectd.type |collectd.type_instance |collectd.dstypes
|-
|collectd.virt.ps_cputime.syst |ps_cputime.syst |N/A |Derive|
|collectd.virt.percent |percent |virt_cpu_total |Gauge|
|collectd.virt.ps_cputime.user |ps_cputime.user |N/A |Derive|
|collectd.virt.virt_cpu_total |virt_cpu_total |CPU number |Derive|
|collectd.virt.virt_vcpu |virt_vcpu |CPU number |Derive|
|collectd.virt.disk_octets.read |disk_octets.read |disk name |Gauge|
|collectd.virt.disk_ops.read |disk_ops.read |disk name |Gauge|
|collectd.virt.disk_octets.write |disk_octets.write |disk name |Gauge|
|collectd.virt.disk_ops.write |disk_ops.write |disk name |Gauge|
|collectd.virt.if_octets.rx |if_octets.rx |network name |Derive|
|collectd.virt.if_dropped.rx |if_dropped.rx |network name |Derive|
|collectd.virt.if_errors.rx|if_errors.rx |network name |Derive|
|collectd.virt.if_octets.tx|if_octets.tx |network name |Derive|
|collectd.virt.if_dropped.tx |if_dropped.tx |network name |Derive|
|collectd.virt.if_errors.tx |if_errors.tx |network name |Derive|
|collectd.virt.if_packets.rx |if_packets.rx |network name |Derive|
|collectd.virt.if_packets.tx |if_packets.tx |network name |Derive|
|collectd.virt.memory|memory |rss / total /actual_balloon / available / unused / usable / last_update / major_fault / minor_fault / swap_in / swap_out |Gauge|
|collectd.virt.total_requests |total_requests |flush-DISK |Derive|
|collectd.virt.total_time_in_ms |total_time_in_ms |flush-DISK |Derive|
|collectd.virt.total_time_in_ms |total_time_in_ms |flush-DISK |Derive|

**Additional Values**

* **collectd.plugin:** virt

* **collectd.plugin_instance:** The virtual machine's name

* **ovirt.entity:** vm

* **ovirt.cluster.name.raw:** *The cluster's name*

* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*

* **hostname:** *The host's FQDN*

* **ipaddr4:** *IP address*

* **interval:** 10

### Gauge and Derive Data Source Types

Each metric includes a *collectd.dstypes* value that defines the data source's type:

* **Gauge**: A gauge value is simply stored as-is and is used for values that may increase or decrease, such as the amount of memory used.

* **Derive**: These data sources assume that the change of the value is interesting, i.e., the derivative. Such data sources are very common for events that can be counted, for example the number of disk read operations. The total number of disk read operations is not interesting, but rather the change since the value was last read. The value is therefore converted to a rate using the following formula:


        rate = value(new)-value(old)\
                time(new)-time(old)

    **Note:** If value(new) is less than value (old), the resulting rate will be negative. If the minimum value to zero, such data points will be discarded.

## Working with Metrics Store Indexes

Metrics Store creates the following two indexes per day:

* project.ovirt-metrics-&lt;ovirt-env-name>.uuid.yyyy.mm.dd

* project.ovirt-logs-&lt;ovirt-env-name>.uuid.yyyy.mm.dd

When using the **Discover** page, select the index named project.ovirt-logs-&lt;ovirt-env-name>.uuid.

In the **Visualization** page select project.ovirt-metrics-&lt;ovirt-env-name>.uuid for metrics data or project.ovirt-logs-&lt;ovirt-env-name>.uuid for log data.

**Prev:** [Chapter 1: Introduction](Introduction.html)<br>
**Next:** [Chapter 3: Analyzing Logs](Logs.html)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/metrics_store_user_guide/chap-metrics)

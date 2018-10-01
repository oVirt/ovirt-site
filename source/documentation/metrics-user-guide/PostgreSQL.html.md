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
* **collectd.dstypes:** [Gauge](../Gauge)


---
title: Metrics Store - Collected Data
category: feature
authors: sradco
---
<div class="alert alert-warning">
  <strong>ATTENTION: This page is no longer up to date. Please follow the link for the updated documentation:</strong>
  <br/>
  * <a href="/documentation/administration_guide/#monitoring_and_observability">Monitoring and observability</a>
</div>

# Metrics Store - Collected Data

## Statistics Collection
collectd gathers oVirt statistics from the oVirt engine and hypervisors, and transfers the data to fluentd.

The data is then transformed, enriched, and sent to the remote metrics store.

### oVirt Metrics - collectd loaded plugins list

[Disk](https://collectd.org/wiki/index.php/Plugin:Disk)

  Disk utilization: Sectors read/written, number of read/write actions,
  average time an IO-operation took to complete.

[CPU](https://collectd.org/wiki/index.php/Plugin:CPU)

  CPU time spent in the system, user, nice, idle, wait, interrupt, softirq and steal.

[Memory](https://collectd.org/wiki/index.php/Plugin:Memory)

  Collects information about the used, buffered, cached and free RAM memory.

[Load](https://collectd.org/wiki/index.php/Plugin:Load)

  The average number of runnable tasks in the run-queue, for one, five, and fifteen minute average.

[Virt](https://collectd.org/wiki/index.php/Plugin:virt) (Applies only to oVirt hypervisors).

  CPU, memory, disk, and network I/O statistics from virtual machines.

[NFS](https://collectd.org/wiki/index.php/Plugin:NFS)

  NFS usage: A count of the number of procedure calls for each procedure, grouped by version
  and whether the system runs as a server or client. NFS version 4 is not supported for now.

[Entropy](https://collectd.org/wiki/index.php/Plugin:Entropy)

  Amount of entropy available to the system.

[Swap](https://collectd.org/wiki/index.php/Plugin:Swap)

  Records the free, cached, and used memory utilized by swap and swap in/out.

[DF](https://collectd.org/wiki/index.php/Plugin:DF)

  Collects file system (incl. the hard drive) usage information such as free, reserved, and used space.

[Interface](https://collectd.org/wiki/index.php/Plugin:Interface)

  Collects network traffic download and upload data, including the number of octets, packets, and errors transmitted and received, for each network interface.

[Aggregation](https://collectd.org/wiki/index.php/Plugin:Aggregation)

  Aggregates multiple values into a single value, using one or several consolidation functions, e.g. summation and average.

[Processes](https://collectd.org/wiki/index.php/Plugin:Processes)

  Collects the number of processes, grouped by their state (incl. running, blocked, sleeping, paging, stopped and zombies).

[PostgreSQL](https://collectd.org/wiki/index.php/Plugin:PostgreSQL) (Applies only to oVirt engine).

  PostgreSQL database statistics: custom_deadlocks, table_states, disk_io, disk_usage.


## Logs Collection
fluentd collects oVirt logs from the oVirt engine and hypervisors.
The data is then transformed, enriched and sent to the remote metrics store.

Logs collected from the engine machine include:

* engine.log

Logs collected from the hypervisors machines include:

* vdsm.log

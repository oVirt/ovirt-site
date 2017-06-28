## Statistics collection
oVirt statistics are gathered from the oVirt engine and hypervisors by collectd, and transferred to fluentd.

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

  The number of runnable tasks in the run-queue, provided as a one, five, and fifteen minute average.

[Virt](https://collectd.org/wiki/index.php/Plugin:virt) - Relevant only for oVirt hypervisors.

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

  Collects network trafic download and upload. It record the number of octets, packets and errors for transmission and reception on all network interface.

[Aggregation](https://collectd.org/wiki/index.php/Plugin:Aggregation)

  Aggregates multiple values into a single value, using one or several consolidation functions, e.g. summation and average.
  It is currently used for calculating the average CPU utilization across all cores of each host.
  
[Processes](https://collectd.org/wiki/index.php/Plugin:Processes)
  
  Process counts: Track the number of running, blocked, sleeping, paging, stopped and zombies processes.

[PostgreSQL](https://collectd.org/wiki/index.php/Plugin:PostgreSQL) - Relevant only for oVirt engine.

  PostgreSQL database statistics: custom_deadlocks, table_states, disk_io, disk_usage.


## Logs collection
oVirt logs are collected from the oVirt engine and hypervisors, by fluentd.
The data is then transformed, enriched and sent to the remote metrics store.

Currently, the logs collected from the engine machine include:

* engine.log

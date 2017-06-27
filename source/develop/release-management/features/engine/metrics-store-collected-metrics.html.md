## Statistics collection
oVirt statistics are collected by collectd, from the oVirt engine and hypervisors and passed to fluentd.

The data is then transformed, enriched and sent to the remote metrics store.

### oVirt Metrics - collectd loaded plugins list

* [disk](https://collectd.org/wiki/index.php/Plugin:Disk)
  
  Disk utilization: Sectors read/written, number of read/write actions,
  average time an IO-operation took to complete.

* [cpu](https://collectd.org/wiki/index.php/Plugin:CPU)

  CPU time spent in the system, user, nice, idle, wait, interrupt, softirq and steal.
      
* [memory](https://collectd.org/wiki/index.php/Plugin:Memory)

  Collects information about the used, buffered, cached and free RAM memory

* [load](https://collectd.org/wiki/index.php/Plugin:Load)

  The number of runnable tasks in the run-queue, average over the last 1, 5 and 15 minutes.

* [virt](https://collectd.org/wiki/index.php/Plugin:virt) - Relevant only for oVirt hypervisors

  CPU, memory, disk and network I/O statistics from virtual machines.
 
* [nfs](https://collectd.org/wiki/index.php/Plugin:NFS)

  NFS usage: A count of the number of procedure calls for each procedure, grouped by version
  and whether the system runs as server or client. NFS version 4 is not supported for now.

* [entropy](https://collectd.org/wiki/index.php/Plugin:Entropy)

  Amount of entropy available to the system.
 
* [swap](https://collectd.org/wiki/index.php/Plugin:Swap)

  Records the free, cached and used memory used by the swap
  
* [df](https://collectd.org/wiki/index.php/Plugin:DF)

  Collects information such as the free, reserved and used space of your files systems (including hard drive)
  
* [interface](https://collectd.org/wiki/index.php/Plugin:Interface)

  Collects network trafic download and upload. It record the number of octets, packets and errors for transmission and reception on all network interface.

* [aggregation](https://collectd.org/wiki/index.php/Plugin:Aggregation)

  Aggregate multiple values into a single value using one or several consolidation functions, e.g. summation and average.
  Currently it is used for calculating the average CPU utilization over all cores of each host.

* [processes](https://collectd.org/wiki/index.php/Plugin:Processes)
  
  Process counts: Track the number of running, blocked, sleeping, paging, stopped and zombies process.

* [postgresql](https://collectd.org/wiki/index.php/Plugin:PostgreSQL) - Relevant only for oVirt engine

  PostgreSQL database statistics: custom_deadlocks, table_states, disk_io, disk_usage.


## Logs collection
oVirt logs are collected by fluentd, from the oVirt engine and hypervisors.
The data is then transformed, enriched and sent to the remote metrics store.

Currently logs collected from engine machine:

* engine.log

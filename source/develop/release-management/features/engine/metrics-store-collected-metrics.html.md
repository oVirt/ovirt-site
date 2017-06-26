## Statistics collection
oVirt statistics are collected by collectd, from the oVirt engine and hypervisors and passed to fluentd.

The data is then transformed, enriched and sent to the remote metrics store.

### oVirt Metrics - collectd loaded plugins list

* [disk](https://collectd.org/wiki/index.php/Plugin:Disk)
  
  Disk utilization: Sectors read/written, number of read/write actions,
  average time an IO-operation took to complete.

* [cpu](https://collectd.org/wiki/index.php/Plugin:CPU)

  CPU utilization: Time spent in the system, user, nice, idle, and related states.
      
* [memory](https://collectd.org/wiki/index.php/Plugin:Memory)

  Memory utilization: Memory occupied by running processes, page cache, buffer cache and free.

* [load](https://collectd.org/wiki/index.php/Plugin:Load)

  System load: The number of runnable tasks in the run-queue, average over the last 1, 5 and 15 minutes.

* [virt](https://collectd.org/wiki/index.php/Plugin:virt) - Relevant only for oVirt hypervisors

  CPU, memory, disk and network I/O statistics from virtual machines.
 
* [nfs](https://collectd.org/wiki/index.php/Plugin:NFS)

  NFS usage: A count of the number of procedure calls for each procedure, grouped by version
  and whether the system runs as server or client. NFS version 4 is not supported for now.

* [entropy](https://collectd.org/wiki/index.php/Plugin:Entropy)

  Amount of entropy available to the system.
 
* [swap](https://collectd.org/wiki/index.php/Plugin:Swap)

  The amount of memory currently written onto hard disk or whatever is called `swap' by the OS..

* [df](https://collectd.org/wiki/index.php/Plugin:DF)

  Mountpoint usage.
  
* [interface](https://collectd.org/wiki/index.php/Plugin:Interface)

  Interface traffic : Number of octets, packets and errors per second for each interface.

* [aggregation](https://collectd.org/wiki/index.php/Plugin:Aggregation)

  Aggregate multiple values into a single value using one or several consolidation functions, e.g. summation and average.
  Currently it is used for calculating the average CPU utilization over all cores of each host.

* [processes](https://collectd.org/wiki/index.php/Plugin:Processes)
  
  Process counts: Number of running, sleeping, zombie, stopped ... processes.

* [postgresql](https://collectd.org/wiki/index.php/Plugin:PostgreSQL) - Relevant only for oVirt engine

  PostgreSQL database statistics: custom_deadlocks, table_states, disk_io, disk_usage.


## Logs collection
oVirt logs are collected by fluentd, from the oVirt engine and hypervisors.
The data is then transformed, enriched and sent to the remote metrics store.

Currently logs collected from engine machine:

* engine.log

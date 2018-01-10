---
title: Metrics Store - Schema
category: feature
authors: sradco
feature_name: oVirt Metrics Store Schema
feature_modules: engine
feature_status: In Development
---

# oVirt Metrics - Schema


Please use the following for constructing the metrics visualizations in the UI tool.

General fields for metrics records:

 - hostname: host FQDN
 - collectd.interval: 10 (in seconds)

## NFS Plugin

 - collectd.plugin: nfs
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.nfs.nfs_procedure | nfs_procedure | NFS activities | fs_name + server or client (Example: v3client) | derive |

**NFS activities**

null / getattr / lookup / access / readlink / read / write / create / mkdir / symlink / mknod / rename / readdir / remove / link / fsstat / fsinfo / readdirplus / pathconf / rmdir / commit / compound / reserved / access / close / delegpurge / delegreturn / getattr / getfh / lock / lockt / locku / lookupp / open_downgrade / putfh / putpubfh / putrootfh / renew / restorefh / savefh / secinfo / setattr / setclientid / setcltid_confirm / verify / open / openattr / open_confirm / exchange_id / create_session / destroy_session / bind_conn_to_session / nverify / release_lockowner / backchannel_ctl / free_stateid / get_dir_delegation / getdeviceinfo / getdevicelist / layoutcommit / layoutget / layoutreturn / secinfo_no_name / sequence / set_ssv / test_stateid / want_delegation / destroy_clientid / reclaim_complete

## Processes Plugin

 - collectd.plugin: processes
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.processes.ps_state | ps_state | running/ zombies/ stopped/ paging/ blocked/ sleeping |   | gauge |
| collectd.processes.ps_disk_ops.read | ps_disk_ops |   | process name | derive |
| collectd.processes.ps_disk_ops.write | ps_disk_ops |   | process name | derive |
| collectd.processes.ps_vm | ps_vm |   | process name | gauge |
| collectd.processes.ps_rss | ps_rss |   | process name | gauge |
| collectd.processes.ps_data | ps_data |   | process name | gauge |
| collectd.processes.ps_code | ps_code |   | process name | gauge |
| collectd.processes.ps_stacksize | ps_stacksize |   | process name | gauge |
| collectd.processes.ps_cputime.syst | ps_cputime |   | process name | derive |
| collectd.processes.ps_cputime.user | ps_cputime |   | process name | derive |
| collectd.processes.ps_count.processes | ps_count |   | process name | gauge |
| collectd.processes.ps_count.threads | ps_count |   | process name | gauge |
| collectd.processes.ps_pagefaults.majfltadd | ps_pagefaults |   | process name | derive |
| collectd.processes.ps_pagefaults.minflt | ps_pagefaults |   | process name | derive |
| collectd.processes.ps_disk_octets.write | ps_disk_octets |   | process name | derive |
| collectd.processes.ps_disk_octets.read | ps_disk_octets |   | process name | derive |
| collectd.processes.fork_rate | fork_rate |   |  | derive |

## Disk Plugin

 - collectd.plugin: disk
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.disk.disk_ops.read | disk_ops |   | disk name | derive |
| collectd.disk.disk_ops.write | disk_ops |   | disk name | derive |
| collectd.disk.disk_merged.read | disk_merged |   | disk name | derive |
| collectd.disk.disk_merged.write | disk_merged |   | disk name | derive |
| collectd.disk.disk_time.read | disk_time |   | disk name | derive |
| collectd.disk.disk_time.write | disk_time |   | disk name | derive |
| collectd.disk.pending_operations | pending_operations |   | disk name | gauge |
| collectd.disk.disk_io_time.io_time | disk_io_time |   | disk name | derive |
| collectd.disk.disk_io_time.weighted_io_time | disk_io_time |   | disk name | derive |

## Interface Plugin

 - collectd.plugin: interface
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.interface.if_octets.rx | if_octets |   | Network Name | derive |
| collectd.interface.if_octets.tx | if_octets |   | Network Name | derive |
| collectd.interface.if_packets.rx | if_packets |   | Network Name | derive |
| collectd.interface.if_packets.tx | if_packets |   | Network Name | derive |
| collectd.interface.if_errors.rx | if_errors |   | Network Name | derive |
| collectd.interface.if_errors.tx | if_errors |   | Network Name | derive |
| collectd.interface.if_dropped.rx | if_dropped |   | Network Name | derive |
| collectd.interface.if_dropped.tx | if_dropped |   | Network Name | derive |

## CPU Plugin

 - collectd.plugin: cpu
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.cpu.percent | percent | interrupt / user / wait / nice / softirq / system / idle / steal | cpu number | gauge |

## DF Plugin

 - collectd.plugin: df
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.df.df_complex | df_complex | free / used / reserved | A mounted partition | gauge |
| collectd.df.percent_bytes | percent_bytes | free / used / reserved | A mounted partition | gauge |

## Entropy Plugin

 - collectd.plugin: entropy
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.entropy.entropy | entropy |   |   | gauge |

## Memory Plugin

 - collectd.plugin: memory
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.memory.memory | memory | used / cached / free / slab_unrecl / slab_recl / buffered  |   | gauge |
| collectd.memory.percent | percent | used / cached / free / slab_unrecl / slab_recl / buffered  |   | gauge |

## Swap Plugin

 - collectd.plugin: swap
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.swap.swap | swap | used / free /  cached |   | gauge |
| collectd.swap.swap_io | swap_io | in / out |   | derive |

## Load Plugin

 - collectd.plugin: load
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.load.load.longterm | load |   |   | gauge |
| collectd.load.load.midterm | load |   |   | gauge |
| collectd.load.load.shortterm | load |   |   | gauge |

## Aggregation Plugin

 - collectd.plugin: aggregation
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.aggregation.percent | "percent" | interrupt / user / wait / nice / softirq / system / idle / steal | cpu-average / cpu-sum | gauge |

## Statsd Plugin (VDSM host stats)

 - collectd.plugin: statsd
 - ovirt.entity: host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.statsd.host_storage | host_storage | storage uuid |   | gauge |

## Statsd Plugin (VDSM vm stats)

 - collectd.plugin: statsd
 - ovirt.entity: vm
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.statsd.vm_balloon_cur | vm_balloon_cur |   | vm name | gauge |
| collectd.statsd.vm_balloon_max | vm_balloon_max |   | vm name | gauge |
| collectd.statsd.vm_balloon_min | vm_balloon_min |   | vm name | gauge |
| collectd.statsd.vm_balloon_target | vm_balloon_target |   | vm name | gauge |
| collectd.statsd.vm_cpu_sys | vm_cpu_sys |   | vm name | gauge |
| collectd.statsd.vm_cpu_usage | vm_cpu_usage |   | vm name | gauge |
| collectd.statsd.vm_cpu_user | vm_cpu_user |   | vm name | gauge |
| collectd.statsd.vm_disk_apparent_size | vm_disk_apparent_size | disk name | vm name | gauge |
| collectd.statsd.vm_disk_flush_latency | vm_disk_flush_latency | disk name | vm name | gauge |
| collectd.statsd.vm_disk_read_bytes | vm_disk_read_bytes | disk name | vm name | gauge |
| collectd.statsd.vm_disk_read_latency | vm_disk_read_latency | disk name | vm name | gauge |
| collectd.statsd.vm_disk_read_ops | vm_disk_read_ops | disk name | vm name | gauge |
| collectd.statsd.vm_disk_read_rate | vm_disk_read_rate | disk name | vm name | gauge |
| collectd.statsd.vm_disk_true_size | vm_disk_true_size | disk name | vm name | gauge |
| collectd.statsd.vm_disk_write_bytes | vm_disk_write_bytes | disk name | vm name | gauge |
| collectd.statsd.vm_disk_write_latency | vm_disk_write_latency | disk name | vm name | gauge |
| collectd.statsd.vm_disk_write_ops | vm_disk_write_ops | disk name | vm name | gauge |
| collectd.statsd.vm_disk_write_rate | vm_disk_write_rate | disk name | vm name | gauge |
| collectd.statsd.vm_nic_rx_bytes | vm_nic_rx_bytes | network name | vm name | gauge |
| collectd.statsd.vm_nic_rx_dropped | vm_nic_rx_dropped | network name | vm name | gauge |
| collectd.statsd.vm_nic_rx_errors | vm_nic_rx_errors | network name | vm name | gauge |
| collectd.statsd.vm_nic_speed | vm_nic_speed | network name | vm name | gauge |
| collectd.statsd.vm_nic_tx_bytes | vm_nic_tx_bytes | network name | vm name | gauge |
| collectd.statsd.vm_nic_tx_dropped | vm_nic_tx_dropped | network name | vm name | gauge |
| collectd.statsd.vm_nic_tx_errors | vm_nic_tx_errors | network name | vm name | gauge |

## Postgresql Plugin

 - collectd.plugin: postgresql
 - ovirt.entity: engine

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.postgresql.pg_numbackends | pg_numbackends |   | db name | gauge |
| collectd.postgresql.pg_n_tup_g | pg_n_tup_g | dead / live | db name | gauge |
| collectd.postgresql.pg_n_tup_c | pg_n_tup_c | ins / upd / del / hot_upd | db name | derive |
| collectd.postgresql.pg_xact | pg_xact | num_deadlocks | db name | derive |
| collectd.postgresql.pg_db_size | pg_db_size |   | db name | gauge |
| collectd.postgresql.pg_blks | pg_blks | heap_read / heap_hit / idx_hit / toast_read / toast_hit / tidx_read / idx_read | db name | derive |

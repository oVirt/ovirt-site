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

 collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
---------------|------------------------|--------------------------|-------------------------|------------------|
| nfs_procedure | NFS activities - null / getattr / lookup / access / readlink / read / write / create / mkdir / symlink / mknod / rename / readdir / remove / link / fsstat / fsinfo / readdirplus / pathconf / rmdir / commit / compound / reserved / access / close / delegpurge / delegreturn / getattr / getfh / lock / lockt / locku / lookupp / open_downgrade / putfh / putpubfh / putrootfh / renew / restorefh / savefh / secinfo / setattr / setclientid / setcltid_confirm / verify / open / openattr / open_confirm / exchange_id / create_session / destroy_session / bind_conn_to_session / nverify / release_lockowner / backchannel_ctl / free_stateid / get_dir_delegation / getdeviceinfo / getdevicelist / layoutcommit / layoutget / layoutreturn / secinfo_no_name / sequence / set_ssv / test_stateid / want_delegation / destroy_clientid / reclaim_complete | fs_name + server or client (Example: v3client) | collectd.nfs.nfs_procedure | "derive" |

## Processes Plugin

 - collectd.plugin: processes
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| Processes | ps_state (process state) | running/ zombies/ stopped/ paging/ blocked/ sleeping |  | collectd.processes.ps_state | "gauge" |
| ps_disk_ops | - | process name | collectd.processes.ps_disk_ops.read | "derive" |
| ps_disk_ops | - | process name | collectd.processes.ps_disk_ops.write | "derive" |
| ps_vm | - | process name | collectd.processes.ps_vm | "gauge" |
| ps_rss | - | process name | collectd.processes.ps_rss | "gauge" |
| ps_data | - | process name | collectd.processes.ps_data | "gauge" |
| ps_code | - | process name | collectd.processes.ps_code | "gauge" |
| ps_stacksize | - | process name | collectd.processes.ps_stacksize | "gauge" |
| ps_cputime | - | process name | collectd.processes.ps_cputime.syst | "derive" |
| ps_cputime | - | process name | collectd.processes.ps_cputime.user | "derive" |
| ps_count | - | process name | collectd.processes.ps_count.processes | "gauge" |
| ps_count | - | process name | collectd.processes.ps_count.threads | "gauge" |
| ps_pagefaults | - | process name | collectd.processes.ps_pagefaults.majfltadd | "derive" |
| ps_pagefaults | - | process name | collectd.processes.ps_pagefaults.minflt | "derive" |
| ps_disk_octets | - | process name | collectd.processes.ps_disk_octets.write | "derive" |
| ps_disk_octets | - | process name | collectd.processes.ps_disk_octets.read | "derive" |
| fork_rate | - |  | collectd.processes.fork_rate | "derive" |

## Disk Plugin

 - collectd.plugin: disk
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| disk_ops | - | disk name (sda, sda1, sda2, sr0, dm-1, dm-2, dm-3) | collectd.disk.disk_ops.read | "derive" |
| disk_ops | - | disk name (sda, sda1, sda2, sr0, dm-1, dm-2, dm-3) | collectd.disk.disk_ops.write | "derive" |
| disk_merged | - | disk name (sda, sda1, sda2, sr0, dm-1, dm-2, dm-3) | collectd.disk.disk_merged.read | "derive" |
| disk_merged | - | disk name (sda, sda1, sda2, sr0, dm-1, dm-2, dm-3) | collectd.disk.disk_merged.write | "derive" |
| disk_time | - | disk name (sda, sda1, sda2, sr0, dm-1, dm-2, dm-3) | collectd.disk.disk_time.read | "derive" |
| disk_time | - | disk name (sda, sda1, sda2, sr0, dm-1, dm-2, dm-3) | collectd.disk.disk_time.write | "derive" |
| pending_operations | - | disk name | collectd.disk.pending_operations | "gauge" |
| disk_io_time | - | disk name | collectd.disk.disk_io_time.io_time | "derive" |
| disk_io_time | - | disk name | collectd.disk.disk_io_time.weighted_io_time | "derive" |

## Interface Plugin

 - collectd.plugin: interface
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| if_octets | - | Network Name | collectd.interface.if_octets.rx | "derive" |
| if_octets | - | Network Name | collectd.interface.if_octets.tx | "derive" |
| if_packets | - | Network Name | collectd.interface.if_packets.rx | "derive" |
| if_packets | - | Network Name | collectd.interface.if_packets.tx | "derive" |
| if_errors | - | Network Name | collectd.interface.if_errors.rx | "derive" |
| if_errors | - | Network Name | collectd.interface.if_errors.tx | "derive" |
| if_dropped | - | Network Name | collectd.interface.if_dropped.rx | "derive" |
| if_dropped | - | Network Name | collectd.interface.if_dropped.tx | "derive" |

## CPU Plugin

 - collectd.plugin: cpu
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| "percent" | interrupt / user / wait / nice / softirq / system / idle / steal | cpu number | collectd.cpu.percent | "gauge" |

## DF Plugin

 - collectd.plugin: df
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| df_complex | free / used / reserved | A mounted partition | collectd.df.df_complex | "gauge" |
| percent_bytes | free / used / reserved | A mounted partition | collectd.df.percent_bytes | "gauge" |

## Entropy Plugin

 - collectd.plugin: entropy
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| entropy | - | - | collectd.entropy.entropy | "gauge" |

## Memory Plugin

 - collectd.plugin: memory
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| memory | used / cached / free / slab_unrecl / slab_recl / buffered  | - | collectd.memory.memory | "gauge" |
| "percent" | used / cached / free / slab_unrecl / slab_recl / buffered  | - | collectd.memory.percent | "gauge" |

## Swap Plugin

 - collectd.plugin: swap
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| swap | used / free /  cached | - | collectd.swap.swap | "gauge" |
| swap_io | in / out | - | collectd.swap.swap_io | "derive" |

## Load Plugin

 - collectd.plugin: load
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| load | - | - | collectd.load.load.longterm | "gauge" |
| load | - | - | collectd.load.load.midterm |  |
| load | - | - | collectd.load.load.shortterm |  |

## Postgresql Plugin

 - collectd.plugin: postgresql
 - ovirt.entity: engine

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| pg_numbackends | - | db name | collectd.postgresql.pg_numbackends | "gauge" |
| pg_n_tup_g | dead / live | db name | collectd.postgresql.pg_n_tup_g | "gauge" |
| pg_n_tup_c | ins / upd / del / hot_upd | db name | collectd.postgresql.pg_n_tup_c | "derive" |
| pg_xact | num_deadlocks | db name | collectd.postgresql.pg_xact | "derive" |
| pg_db_size | - | db name | collectd.postgresql.pg_db_size | "gauge" |
| pg_blks | heap_read / heap_hit / idx_hit / toast_read / toast_hit / tidx_read / idx_read | db name | collectd.postgresql.pg_blks | ""derive"" |"

## Aggregation Plugin

 - collectd.plugin: aggregation
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| "percent" | interrupt / user / wait / nice / softirq / system / idle / steal | cpu-average / cpu-sum | collectd.aggregation.percent | "gauge" |

## Statsd Plugin (VDSM host stats)

 - collectd.plugin: statsd
 - ovirt.entity: host

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| host_storage | storage uuid | - | collectd.statsd.host_storage | "gauge" |

## Statsd Plugin (VDSM vm stats)

 - collectd.plugin: statsd
 - ovirt.entity: vm

| collectd.type | collectd.type_instance | collectd.plugin_instance | Metric value field name | collectd.dstypes |
|---------------|------------------------|--------------------------|-------------------------|------------------|
| vm_balloon_cur | - | vm name | collectd.statsd.vm_balloon_cur | "gauge" |
| vm_balloon_max | - | vm name | collectd.statsd.vm_balloon_max | "gauge" |
| vm_balloon_min | - | vm name | collectd.statsd.vm_balloon_min | "gauge" |
| vm_balloon_target | - | vm name | collectd.statsd.vm_balloon_target | "gauge" |
| vm_cpu_sys | - | vm name | collectd.statsd.vm_cpu_sys | "gauge" |
| vm_cpu_usage | - | vm name | collectd.statsd.vm_cpu_usage | "gauge" |
| vm_cpu_user | - | vm name | collectd.statsd.vm_cpu_user | "gauge" |
| vm_disk_apparent_size | disk name | vm name | collectd.statsd.vm_disk_apparent_size | "gauge" |
| vm_disk_flush_latency | disk name | vm name | collectd.statsd.vm_disk_flush_latency | "gauge" |
| vm_disk_read_bytes | disk name | vm name | collectd.statsd.vm_disk_read_bytes | "gauge" |
| vm_disk_read_latency | disk name | vm name | collectd.statsd.vm_disk_read_latency | "gauge" |
| vm_disk_read_ops | disk name | vm name | collectd.statsd.vm_disk_read_ops | "gauge" |
| vm_disk_read_rate | disk name | vm name | collectd.statsd.vm_disk_read_rate | "gauge" |
| vm_disk_true_size | disk name | vm name | collectd.statsd.vm_disk_true_size | "gauge" |
| vm_disk_write_bytes | disk name | vm name | collectd.statsd.vm_disk_write_bytes | "gauge" |
| vm_disk_write_latency | disk name | vm name | collectd.statsd.vm_disk_write_latency | "gauge" |
| vm_disk_write_ops | disk name | vm name | collectd.statsd.vm_disk_write_ops | "gauge" |
| vm_disk_write_rate | disk name | vm name | collectd.statsd.vm_disk_write_rate | "gauge" |
| vm_nic_rx_bytes | network name | vm name | collectd.statsd.vm_nic_rx_bytes | "gauge" |
| vm_nic_rx_dropped | network name | vm name | collectd.statsd.vm_nic_rx_dropped | "gauge" |
| vm_nic_rx_errors | network name | vm name | collectd.statsd.vm_nic_rx_errors | "gauge" |
| vm_nic_speed | network name | vm name | collectd.statsd.vm_nic_speed | "gauge" |
| vm_nic_tx_bytes | network name | vm name | collectd.statsd.vm_nic_tx_bytes | "gauge" |
| vm_nic_tx_dropped | network name | vm name | collectd.statsd.vm_nic_tx_dropped | "gauge" |
| vm_nic_tx_errors | network name | vm name | collectd.statsd.vm_nic_tx_errors | "gauge" |

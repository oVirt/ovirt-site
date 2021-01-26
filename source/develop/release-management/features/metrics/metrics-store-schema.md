---
title: Metrics Store - Schema
category: feature
authors: sradco
---
<div class="alert alert-warning">
  <strong>ATTENTION: This page is no longer up to date. Please follow the link for the updated documentation:</strong>
  <br/>
  * <a href="/documentation/administration_guide/#monitoring_and_observability">Monitoring and observability</a>
</div>

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
 - ovirt.entity: engine or host
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
 - ovirt.entity: engine or host
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
 - ovirt.entity: engine or host
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
 - ovirt.entity: engine or host
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
 - ovirt.entity: engine or host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.entropy.entropy | entropy |   |   | gauge |

## Memory Plugin

 - collectd.plugin: memory
 - ovirt.entity: engine or host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.memory.memory | memory | used / cached / free / slab_unrecl / slab_recl / buffered  |   | gauge |
| collectd.memory.percent | percent | used / cached / free / slab_unrecl / slab_recl / buffered  |   | gauge |

## Swap Plugin

 - collectd.plugin: swap
 - ovirt.entity: engine or host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.swap.swap | swap | used / free /  cached |   | gauge |
| collectd.swap.swap_io | swap_io | in / out |   | derive |
| collectd.swap.percent | percent | used / free /  cached |   | gauge |

## Load Plugin

 - collectd.plugin: load
 - ovirt.entity: engine or host
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.load.load.longterm | load |   |   | gauge |
| collectd.load.load.midterm | load |   |   | gauge |
| collectd.load.load.shortterm | load |   |   | gauge |

## Aggregation Plugin

 - collectd.plugin: aggregation
 - ovirt.entity: engine or host
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

## Virt Plugin

 - collectd.plugin: virt
 - ovirt.entity: vm
 - ovirt.engine_fqdn.raw: _FQDN of the engine_
 - ovirt.cluster_name.raw: _Cluster name_

| Metric value field name | collectd.type | collectd.type_instance | collectd.plugin_instance | collectd.dstypes |
|-------------------------|---------------|------------------------|--------------------------|------------------|
| collectd.virt.memory | memory | rss / total /actual_balloon / available / unused / usable / last_update / major_fault / minor_fault / swap_in / swap_out | vm name | gauge |
| collectd.virt.disk_octets.read | disk_octets.read | disk name | vm name | gauge |
| collectd.virt.disk_octets.write | disk_octets.write | disk name | vm name | gauge |
| collectd.virt.disk_ops.read | disk_ops.read | disk name | vm name | gauge |
| collectd.virt.disk_ops.write | disk_ops.write | disk name | vm name | gauge |
| collectd.virt.if_dropped.rx | if_dropped.rx | network name | vm name | derive |
| collectd.virt.if_dropped.tx | if_dropped.tx | network name | vm name | derive |
| collectd.virt.if_errors.rx | if_errors.rx | network name | vm name | derive |
| collectd.virt.if_errors.tx | if_errors.tx | network name | vm name | derive |
| collectd.virt.if_octets.rx | if_octets.rx | network name | vm name | derive |
| collectd.virt.if_octets.tx | if_octets.tx | network name | vm name | derive |
| collectd.virt.if_packets.rx | if_packets.rx | network name | vm name | derive |
| collectd.virt.if_packets.tx | if_packets.tx | network name | vm name | derive |
| collectd.virt.virt_cpu_total | virt_cpu_total | cpu number | vm name | derive |
| collectd.virt.virt_vcpu | virt_vcpu | cpu number | vm name | derive |
| collectd.virt.percent | percent | virt_cpu_total | vm name | gauge |
| collectd.virt.ps_cputime.user | ps_cputime.user |  | vm name | derive |
| collectd.virt.ps_cputime.syst | ps_cputime.syst |  | vm name | derive |
| collectd.virt.total_requests | total_requests | flush-DISK | vm name | derive |
| collectd.virt.total_time_in_ms | total_time_in_ms | flush-DISK | vm name | derive |
| collectd.virt.virt_vcpu | virt_vcpu | cpu number | vm name | derive |


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

---
title: Parallel migration connections
category: feature
authors: mzamazal
---

# Parallel migration connections

## Summary

This feature adds support for multiple connections in migrations.

## Owner

*   Name: Milan Zamazal
*   Email: mzamazal@redhat.com

## Description

libvirt and QEMU allow using multiple parallel connections for a single migration (QEMU calls this feature *multifd*).  With just a single migration connection and sufficient network bandwidth, the single migration thread can become a bottleneck due to a limited single-CPU capacity.  By using multiple connections fed with multiple threads run by multiple CPUs, a full network capacity can be utilized.  For instance, 8-16 connections can saturate 100 Gbps network bandwidth.

Additionally, multifd implementation of data transfer is simpler and more efficient than the traditional migration mechanism and can be faster even with lower network bandwidths.  This concerns only the way memory data is transferred, the other migration concepts such as counting iterations or setting the maximum downtime are unaffected.

Parallel migration connections can be enabled by passing ``VIR_MIGRATE_PARALLEL`` flag to [virDomainMigrateToURI3](https://libvirt.org/html/libvirt-libvirt-domain.html#virDomainMigrateToURI3) call.  The number of connections to use is specified using  [VIR_MIGRATE_PARAM_PARALLEL_CONNECTIONS](https://libvirt.org/html/libvirt-libvirt-domain.html#VIR_MIGRATE_PARAM_PARALLEL_CONNECTIONS) migration parameter.

## Prerequisites

Nothing special, just up-to-date libvirt and QEMU.

## Limitations

Current implementation of parallel migration connections in QEMU has some restrictions:

- It doesn't support switching to post-copy.

- RDMA doesn't work.  This is not a limitation for oVirt, because RDMA is not supported in oVirt.

- XBZRLE compression is not supported.  However this kind of compression is generally not recommended to use in migrations because it adds little benefit and a significant overhead.  gzip/zstd is supported instead and migrations should actually benefit from it (but libvirt apparently doesn't currently provide means to select this compression kind).

- Due to their better implementation, parallel migration connections can be faster than the traditional migration implementation even when the network bandwidth can be saturated with a single connection.  However, when single connection is specified, the parallel migration connection implementation uses a different code path, which may not be sufficiently robust, and it's recommended to always use at least two connections.  In the worst case, one of the threads will be idle while causing only a little overhead. 

- Parallel migration connections haven't been tested extensively with connections faster than 100 Gbps.  Due to current multifd implementation, there is an increasing overhead when using many connections and it's not clear whether using more than 16 parallel connections adds a real benefit.

- It still applies that large guests with terrabytes of RAM are difficult to migrate successfully.

- Since it's easier to saturate network bandwidth with multiple connections, it's advisable to not migrate multiple VMs from a single host at the same time.

- VM CPU pinning may restrict the number of CPUs available to the QEMU process and thus impose a limit on the meaningful number of parallel connections.

- It's difficult to guess the right number of parallel connections to use.  A rule of thumb is to use one connection per 10 Gbps of available network bandwidth.  If the number of connections is a bit high, some threads may remain idle while the related overhead should be negligible.

- There is very little documentation about parallel migration connections and the information above was obtained directly from platform developers.

## User experience

A new migration option to enable parallel migration connections is introduced in cluster and VM edit dialogs.  The cluster option specifies what to use in the given cluster.  VMs can override the cluster value individually.  The new option offers the following choices:

- **Disabled** (the default in clusters): Parallel migration connections are not used.

- **Auto**: Use or do not use parallel migration connections and set their number automatically based on the available resources (network bandwidth and CPU power).

- **Parallel**: Always use parallel migration connections (for the supposed benefit of a more efficient implementation over non-parallel implementation) and set their number automatically based on the available resources (network bandwidth and CPU power).

- **Custom**: Use parallel migration connections and use the number of connections specified by the user.  The minimum number of connections is 2.  There is no upper limit but it is recommended not to use more than 16 and the actual number of connections used for a particular migration is restricted to the number of threads on the source and destination hosts (whichever is lower).

- **Cluster value** (only in the VM edit dialog; it's the default there): Use parallel connections as specified in the VM's cluster settings. 

We use **Disabled** as the cluster default because it's a newly introduced feature in oVirt and there is not enough experience with it.  We may consider changing it to **Auto** or **Parallel** in next releases, especially if QEMU decides using parallel migration connections by default; this would be limited to a future cluster level.

If **Parallel** is selected then the number of parallel connections is set to the lower number of the currently available migration network bandwidth divided by 10 Gbps and the number of VM vCPUs, but no less than 2 and no more than a configurable upper limit, which will be 16 by default.  **Auto** is the same except that parallel connection are not used if the computed number of connections is less than 2.

Since parallel migration connections cannot be currently used with post-copy in QEMU, **Parallel** and **Custom** cannot be set if post-copy migration policy is set, or vice versa post-copy migration policy cannot be set if **Parallel** or **Custom** migration options are set (this must be checked for all the VMs in the cluster on cluster migration policy changes).

If parallel migration connections are enabled, the following adjustments are made when a migration is initiated:

- Compression is disabled regardless of the selected migration policy.  (Current libvirt apparently doesn't support using gzip/zstd compression, which could be helpful and it might be a good idea to always enable it.)

- The maximum number of outgoing migrations is set to 1 regardless of the selected migration policy.  This may not be optimal if there is a non-parallel migration running that cannot saturate the available bandwidth but even in such a case it's generally simpler and safer not to start competing for the bandwidth.

- If **Auto** is set and post-copy migration policy is selected, parallel migration connections are disabled. 

## Testing

It should be tested that migrations with parallel connection work as described above.  It requires at least about 40 Gbps network bandwidth.  The selected migration parameters can be checked in Vdsm logs.  Network bandwidth utilized by the migration should be measured to check that the data is indeed flowing in the specified amounts approximately, i.e. it works as expected on the side of Vdsm, libvirt, and QEMU.

## Changes to Engine and Vdsm

``VM.migrate`` Vdsm API call gets an additional parameter ``parallel``.  If it is unset, parallel migration connections are not used.  Otherwise the specified number of connections, which must be at least 1 (Engine is going to be stricter and not to permit sending less than 2), is used.

Vdsm adds functionality for processing the parameter and passing the corresponding flag and parameter to the libvirt migration call.

Engine implements the functionality as described above, including corresponding modifications to the Web UI and REST API.

---
title: VDSM libvirt performance scalability
category: vdsm
authors: fromani
wiki_title: VDSM libvirt performance scalability
wiki_revision_count: 22
wiki_last_updated: 2014-09-08
---

# VDSM libvirt performance scalability

## Summary

VDSM uses libvirt to manage the life cycle of the VMs, and to collect the statistics about them. This page collects performance and scalability information, and discussion about possible improvements, about how VDSM uses libvirt.

### Owner

*   Name: [Francesco Romani](User:Fromani)
*   Email: <fromani@redhat.com>
*   PM Requirements : N/A
*   Email: N/A

### Current status

*   Target Release: oVirt 3.5 and following
*   Status: Draft/Discussion
*   Last updated: 17 Feb 2014

## VM Creation

WRITEME

## VM Sampling

### Description

VDSM collects statistics about running VMs from libvirt. Those statistics are divided in three main areas: CPU statistics, block layer statistics, networking statistics. Each running VM has one dedicated thread to collect statistics. This can lead to thread proliferation; CPython has less-than-optimal implementation of threading, and on overall VDSM can exhibit bad performance.

**ACTION PENDING**: build testcase(s) and run benchmarks to have baseline data.

#### General performance considerations

VDSM access libvirt through an UNIX domain socket on the same host. The most influential performance factors are expected to be

*   the RTT across the domain socket
*   the amount of syscall infolved
*   the need to access QEMU to collect data

**ACTION PENDING**: run benchmarks to verify this assumption; collect data to properly weight those factors.

libvirt does not have any kind of bulk API, not per-category (e.g. get the CPU stats for all the active VM) neither per-VM (e.g. get all the stats of a given VM); each sample has to be extracted individually, adding many round trips.

A path to improve is to trim those round trips, but this is not trivial due to the current architecture of libvirt.

#### CPU statistics

VDSM collects the CPU statistics using the [virDomainGetCPUStats](http://libvirt.org/html/libvirt-libvirt.html#virDomainGetCPUStats) API. (v)CPUs can be hotplug/unplug-ed at runtime, and to cope with this the API has to be flexible. In practice, this means that under the hood VDSM has to issue two calls, one to get the active CPUs ID and one to gather the actual statistics.

Inside libvirt, the CPU statistics are actually collected inside the QEMU driver, but using cgroups. Interaction with QEMU monitor is not needed.

**ACTION PENDING**: verify if there is a limit of concurrent access to CPU statistics. Are there any locks inside the QEMU driver?

#### Network statistics

VDSM collects the network statistics using the [virDomainInterfaceStats](http://libvirt.org/html/libvirt-libvirt.html#virDomainInterfaceStats) API.

Inside libvirt, the network statistics are collected inside the QEMU driver, but using the standard /proc/net/dev linux interface. Interaction with QEMU monitor is not needed.

**ACTION PENDING**: verify if there is a limit of concurrent access to CPU statistics. Are there any locks inside the QEMU driver?

#### Block layer statistics

The collection of statistics can be expensive. In particular, block layer statistics are collected using the [virDomainGetBlockInfo](http://libvirt.org/html/libvirt-libvirt.html#virDomainGetBlockInfo) API. This is the main bottleneck for statistics gathering because libvirt needs to access QEMU through the monitor connection. This API call is blocking, and this is the main driver behind the choice to have one thread per VM to collect statistics.

There are no plans yet to make virDomainGetBlockInfo optionally not blocking. This may be caused by the fact the monitor protocol is JSON based.

**ACTION PENDING**: verify if there is a path to make virDomainGetBlockInfo not-blocking.

The libvirt developers recommend to use a separate thread to collect block statistics, as VDSM currently does. The blocking behaviour of virDomainGetBlockInfo has been source of bugs. A way to improve the reporting, and to avoid VDSM to wait indefinitely on it, is to add a timeout.

Libvirt exposes a timeout infrastructure through the [virEventAddTimeout](http://libvirt.org/html/libvirt-libvirt.html#virEventAddTimeout) API. virDomainGetBlockInfo has not yet a direct way to setup a timeout.

**ACTION PENDING**: make sure the best way forward is to use the generic timeout API.

#### A possible bulk API extension for libvirt

WRITEME

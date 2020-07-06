---
title: VDSM libvirt performance scalability
category: vdsm
authors: fromani
---

# VDSM libvirt performance scalability

## Summary

VDSM uses libvirt to manage the life cycle of the VMs, and to collect the statistics about them. This page collects performance and scalability information, and discussion about possible improvements, about how VDSM uses libvirt. A rewrite of the VM startup code is also planned and described on a [different page](/develop/developer-guide/vdsm/vm-startup/)

#### WARNING!

This document is obsoleted by [Features/VDSM scalability sampling](/develop/developer-guide/vdsm/scalability-sampling/) and </Features/VDSM_scalability_start_stop>

### Owner

*   Name: Francesco Romani (Fromani)
*   Email: <fromani@redhat.com>
*   PM Requirements : N/A
*   Email: N/A

### Current status

*   Target Release: oVirt 3.5 and following
*   Status: Draft/Discussion
*   Last updated: 2014-02-25

## VM Creation

The VM creation/startup process must be fast as possible to ensure the best user experience. The current oVirt stack (VDSM, libvirt, QEMU) and the interaction between layers must be took in account when considering performance figures and possible improvements.

The focus of the performance improvement analysis and improvement is to be able to efficently and quickly start up many (dozens or even hundeds) of VMs with minimal delay and maximizing the usage of the hypervisor host. Improvement in the start up of a single VM in isolation are considered as well, but with lower priority.

### Startup of many VMs

**Use case: a single hypervisor hosts many (dozens or even hundereds) of VM and it boots them at the same time, perhaps in the morning.**

What we want to improve:

*   the average startup time of a given VM, defined by the time elapsed from the instant the user (either human or program) sends the command to the engine, and the instant

the VM is Up and running.

*   the overall startup time of all the VMs being started

Profiling of VDSM will be done using the [methods described here](/develop/developer-guide/vdsm/profiling-vdsm/)

#### Possible improvements

*   obvious worst offender and low hanging fruit: limitations of parallelism. Bounded Semaphore in VDSM to limit the number of concurrent Vm creations, in turn put in place to circumvent/mitigate the locking inside libvirt/qemu driver. Improvements are been made into libvirt, so this may be more harmful than beneficial

**ACTION PENDING**: verify the status of the improvements in libvirt

**ACTION PENDING**: verify the version of libvirt shipped in the distributions (RHEL/Fedora...)

**ACTION PENDING**: benchmark the impact of the bounded semaphore with a modern libvirt/QEMU stack, and tune the value (possibly removing it entirely) accordingly

**DONE**: find suitable profilers

**ACTION PENDING**: find a way to measure lock contention/time spent waiting for the Bounded Semaphore around libvirt on startup

**RESEARCH/FACT FINDING**:

improvements are been made in libvirt with respect to locking/scalability. Sources:

[libvirt slides](http://events.linuxfoundation.org/sites/events/files/cojp13_privoznik.pdf) summary: (2013) improvements in libvirt (see slide 13)

[Mailing List Thread](http://www.redhat.com/archives/libvir-list/2012-December/msg00717.html) summary: plans (2012-12) to remove the QEMU driver lock inside libvirt

**libvirt implementation status** (see link above, the bullet point at the end of the first email message reported here for the sake of clarity):

         1. Create the virQEMUDriverConfigPtr object & move config file parameters into that. (seems done 2013-01-10 commit b090aa7d559a31b353a546dddfa37aff0655f668)
         2. Encapsulte all read-writable state into objects with dedicated  locking
         3. Turn QEMU driver mutex into a read-write lock (RW added 2014-01-22 commit c065984b58000a44c90588198d222a314ac532fd)
         4. Convert all APIs to only hold read-locks on QEMU driver.

## VM Sampling

### Description

VDSM collects statistics about running VMs from libvirt. Those statistics are divided in three main areas: CPU statistics, block layer statistics, networking statistics. Each running VM has one dedicated thread to collect statistics. This can lead to thread proliferation; CPython has less-than-optimal implementation of threading, and on overall VDSM can exhibit bad performance.

**ACTION PENDING**: build testcase(s) and run benchmarks to have baseline data.

#### General performance considerations

VDSM access libvirt through an UNIX domain socket on the same host. The most influential performance factors are expected to be

*   the RTT across the domain socket
*   the amount of syscall involved
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

libvirt (1.2.x) lacks bulk APIs: it is impossible to fetch either all the stats of a given VM, or the value of a given stats for all the VMs.

When VDSM runs, it takes ownership of all the VMs running in a box, and acts as the sole client of libvirt, then a bulk API is beneficial for VDSM because it reduces the communication overhead, improving the scalability when dealing with tens or hunderds of VMs. Additional benefit for VDSM would be easier and simpler way to collect statistics.

For VDSM, the best bulk API would be one which allows to gather all the stats of a given VM at once, but given the architecture of libvirt the easiest to implement is the one to gather a statistic (say: CPU) for all the VMs.

From the preliminary inquiries there is no strong belief that the bulk API would provide significant performance gains because the communications between VDSM and libvirt is through a local UNIX domain socket.

Moreover, the most expensive statistic, the block information inquiry, must anyway talk which each qemu instance using the JSON-based monitor protocol. This is expected to be a bottleneck even in presence of the bulk API, which is expected to make faster just the communication between libvirt and VDSM, not between libvirt and each QEMU instance.

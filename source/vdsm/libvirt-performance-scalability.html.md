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

#### CPU statistics

WRITEME

#### Network statistics

WRITEME

#### Block layer statistics

The collection of statistics can be expensive. In particular, block layer statistics are collected using the [virDomainGetBlockInfo](http://libvirt.org/html/libvirt-libvirt.html#virDomainGetBlockInfo) API. This is the main bottleneck for statistics gathering because libvirt needs to access QEMU through the monitor connection. This API call is blocking, and this is the main driver behind the choice to have one thread per VM to collect statistics.

There are no plans yet to make virDomainGetBlockInfo optionally not blocking. This may be caused by the fact the monitor protocol is JSON based.

**ACTION PENDING**: verify if there is a path to make virDomainGetBlockInfo not-blocking.

The libvirt developers recommend to use a separate thread to collect block statistics, as VDSM currently does. The blocking behaviour of virDomainGetBlockInfo has been source of bugs. A way to improve the reporting, and to avoid VDSM to wait indefinitely on it, is to add a timeout.

Libvirt exposes a timeout infrastructure through the [virEventAddTimeout](http://libvirt.org/html/libvirt-libvirt.html#virEventAddTimeout) API. virDomainGetBlockInfo has not yet a direct way to setup a timeout.

**ACTION PENDING**: make sure the best way forward is to use the generic timeout API.

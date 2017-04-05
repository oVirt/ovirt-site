---
title: Say Hello to oVirt 4.1.1
author: jmarks
tags: 4.1.1, release notes, oVirt
date: 2017-04-04 16:35:00 CET
comments: true
published: true
---

On March 22, the oVirt project released version 4.1.1, available for Red Hat Enterprise Linux 7.3, CentOS Linux 7.3, or similar.

oVirt is the open source virtualization solution that provides an awesome KVM management interface for multi-node virtualization. This maintenance version is super stable and there are some nice new features.

So what's new in oVirt 4.1.1?


READMORE

### Storage Team

* LUNs can be removed from a block data domain, provided that there is enough free space on the other domain devices to contain the data stored on the LUNs being removed.
* Support for NFS version 4.2 connections (when supported by storage).

### Integration Team

* oVirt-hosted-engine-setup now works with NetworkManager enabled.

### Network Team

* NetworkManager keeps running when a host is added to oVirt. This allows users to review networking configurations in cockpit whenever they want.

### Infra Team

* A new tool, engine-vacuum, performs a vacuum on the PostgreSQL database in order to reclaim disk space on the operating system. It also updates and removes garbage from tables.
* Alerts for all data centers and clusters that are not upgraded to the highest compatibility version.
* Time zones are now shown in log records to make it easier to correlate logs in a geographically spread cluster.

### UX Team

* The oVirt Administration Portal now has improved performance and reduced memory consumption.

### Gluster & Hyperconverged Team

* Cockpit-gdeploy related bug fixes to enhance the installation flow for the hyper-converged use case.

This is an opportunity to say a big thanks to everyone that was involved in the work on 4.1.1. This version is a true testament to the power of collaboration in the oVirt community.

You'll find the full oVirt 4.1.1 release notes [here](https://www.ovirt.org/release/4.1.1/).

---
title: blkio-support
category: feature
authors: gchaplik
---

# blkio-support

## Support blkio SLA features

### Overview

In a highly consolidated and shared environment found in the virtual datacenter, storage bandwidth often comes up as a significant root cause of performance problems. In order to help users mitigate these bottlenecks, they have requested the ability to have finer grained controls over an individual VM’s ability to consume storage bandwidth. This will allow them to set maximum thresholds on individual VMs and Disk files so as to prevent misbehaving VMs from impacting the performance of other VMs sharing the same hosts, storage pools, or even same storage array. There are two key metrics that libvirt can enable users to set limits on: Throughput (in Bytes/Second) and IO Operations (Input/Output Operations/Second). There is a typical dynamic is storage I/O that is often seen in which a smaller number of large files being read or written often consume fewer IOps, but operate at a higher throughput. Conversely, when a large number of small files are being read or written, there are typically a higher number of IOps but noticeably slower total throughput. It is strongly suggested that users thoroughly understand their workload characteristics in order to properly set limits on I/O at various levels, as a misconfiguration could cause potential downtime and outages to running workloads.

### Owner

Name: Gilad Chaplik (gchaplik)

### Current status

Status: implementation

Last updated: ,

[RFE Reference](https://bugzilla.redhat.com/show_bug.cgi?id=1085049)

## Detailed Description

### QoS object

There are two key metrics that libvirt can enable users to set limits on: Throughput (in Bytes/Second) and IO Operations (Input/Output Operations/Second).  There is a typical dynamic  is storage I/O that is often seen in which a smaller number of large files being read or written often consume fewer IOps, but operate at a higher throughput.  Conversely, when a large number of small files are being read or written, there are typically a higher number of IOps but noticeably slower total throughput.  It is strongly suggested that users thoroughly understand their workload characteristics in order to properly set limits on I/O at various levels, as a misconfiguration could cause potential downtime and outages to running workloads.

For more details refer to:

*   [libvirt docs](http://libvirt.org/formatdomain.html#elementsDisks)
*   [aggregate QoS objects](/develop/release-management/features/sla/aggregate-qos.html)

### Storage Domain QoS limits

1) Ability to set a total maximum throughput in terms of bytes/second of each individual disk file of a virtual machine.  There shall also be an ability to set the throughput to unlimited in a simple fashion.

       a. The reason that individual disk level is important, is it could allow an OS partition to have access to unlimited resources, as it’s normally not disk intensive, while still providing limits to I/O intensive Data disks on the same system.
       b. If a user sets a value for total maximum throughput, they may not also set values for read or write bytes/second

2) Ability to set a maximum read throughput in terms of bytes/second of each individual disk file of a virtual machine. there shall also be ability to set the throughput to unlimited in a simple fashion.

       a. The reason separating read and write maximums is important, as certain applications may require a higher level of service of one over the other.  Certain database applications may have a higher priority for read throughput than for write  throughput, so the user may want to ensure more bandwidth is dedicated to the more critical operation.
       b. If a user sets a value for maximum read throughput, they may also be able to set applications may require a higher level of service of one over the other.  Certain database applications may

 have a higher priority for read throughput than for write throughput, so the user may want to ensure more bandwidth is dedicated to the more critical operation. 3) Ability to set a maximum write throughput in terms of bytes/second of each individual disk file of a virtual machine.  There shall also be an ability to set the throughput to unlimited in a simple fashion.

       a. The reason separating read and write maximums is important, as certain applications may require a higher level of service of one over the other.  Certain database applications may have a higher priority for write throughput than for read throughput, so the user may want to ensure more bandwidth is dedicated to the more critical operation.
       b. If a user sets a value for maximum write throughput, they may also be able to set a maximum value for read throughput, but will not be able to set a value for total throughput.

4) Ability to set a total maximum I/O Operations in terms of IOps of each individual disk file of a virtual machine.  There shall also be an ability to set the throughput to unlimited in a simple fashion.

       a. The reason that individual disk level is important, is it could allow an OS partition to have access to unlimited resources, as it’s normally not disk intensive, while still providing limits to I/O intensive Data disks on the same system.
       b. If a user sets a value for total maximum IOps, they may not also set values for to have access to unlimited resources, as it’s normally not disk intensive, while still providing limits to I/O intensive Data disks on the same system.

5) Ability to set a maximum read Operations in terms of IOps of each individual disk file of a virtual machine.  There shall also be an ability to set the throughput to unlimited in a simple fashion.

       a. The reason separating read and write maximums is important, as certain applications may require a higher level of service of one over the other.  Certain database applications may have a higher priority for read operations than for write operations, so the user may want to ensure more bandwidth is dedicated to the more critical operation.
       b. If a user sets a value for maximum read IOps, they may also be able to set a maximum value for write IOps, but will not be able to set a value for total IOps.

6) Ability to set a maximum write Operations in terms of IOps of each individual disk file of a virtual machine.  There shall also be an ability to set the throughput to unlimited in a simple fashion.

       a. The reason separating read and write maximums is important, as certain applications may require a higher level of service of one over the other.  Certain database applications may have a higher priority for write operations than for read operations, so the user may want to ensure more bandwidth is dedicated to the more critical operation.
       b. If a user sets a value for maximum write Ops, they may also be able to set a a maximum value for read IOps, but will not be able to set a value for total IOps.

### Profiles

A new entity Disk Profile will be created by the same vnic profiles concepts [1]. For now Disk Profile will hold a Storage Domain and QoS object. When introducing the feature a default Disk Profile will be created for each Storage Domain, and all disks will be attached to its relevant default profile.

*   [1] [Vnic Profiles feature](/develop/release-management/features/sla/vnic-profiles.html).

(Note: aggregate all profiles feature pages like for QoS).

#### MLA

Vnic Profiles is used to "hide" infra resource (network) from the user. Currently we will hold same roles and behavior for Disk Profiles as well (Disk Operator and Creator), this would be handled as a bug for 3.5 (not a big deal just need to decide).

## Implementation

### VDSM

merged: <http://gerrit.ovirt.org/#/c/14636>

*   need verification.

### Engine Core

#### DB

qos: added limit fields to qos table:

       max_throughput
       max_read_throughput
       max_write_throughput
       max_iops
       max_read_iops
       max_write_iops

#### MLA Permissions

### RESTful API

Under discussion.

*   Basically in all places when setting a SD, a profile will be selected. neats like setting implicitly default profile will be added to ease user's life.

### GUI

Under discussion.

*   basically in all places when selecting SD, a profile will be selected. neats like selecting implicitly default profile (and hide and disable it) will be added to ease user's life.


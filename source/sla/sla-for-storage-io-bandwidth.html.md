---
title: SLA for storage io bandwidth
category: sla
authors: mei liu
wiki_category: SLA
wiki_title: Features/Design/SLA for storage io bandwidth
wiki_revision_count: 61
wiki_last_updated: 2013-06-28
---

# SLA for storage io bandwidth

## Summary

This wiki page focuses on the design of storage I/O bandwidth Service Level Agreement(SLA).

## Owner

*   Name: Mei Liu
*   Email: <liumbj at linux dot vnet dot ibm dot com>

## Current Status

*   Status: design
*   Last updated: 5 June
*   patchset

## Detailed Description

In VDSM, each storage domain backend only provides limited IO bandwidth capability. If bandwidth become scarce resource, the efficiency of vm IO operations will be affected by other vms. This is not the situation we want, and therefore we need to limit the bandwidth usage to allocate the bandwidth in a better way.

In libvirt, existing iotune properties are applied on a vDisk of VM, and provides the ability to provide additional per-device I/O tuning. They include the following elements:

*   total_bytes_sec
    -   The optional total_bytes_sec element is the total throughput limit in bytes per second. This cannot appear with read_bytes_sec or write_bytes_sec.
*   read_bytes_sec
    -   The optional read_bytes_sec element is the read throughput limit in bytes per second.
*   write_bytes_sec
    -   The optional write_bytes_sec element is the write throughput limit in bytes per second.
*   total_iops_sec
    -   The optional total_iops_sec element is the total I/O operations per second. This cannot appear with read_iops_sec or write_iops_sec.
*   read_iops_sec
    -   The optional read_iops_sec element is the read I/O operations per second.
*   write_iops_sec
    -   The optional write_iops_sec element is the write I/O operations per second.

Any sub-element not specified or given with a value of 0 implies no limit.

In the plan, we make use of this functionality to implement the IO bandwidth control based on policy.

## Benefit to oVirt

This feature will allow qos and SLA for storage bandwidth IO control.

## Design

### Automatic per-device tuning for IO bandwidth limit(basic feature)

In the following chapters, we will explain how to tune this IO bandwidth limit dynamically . The adjustment is performed by MOM. This section gives the way to set initial value. This value is used as start point when IO limit is adjusted. The IO limit is then tuned according to IO bandwidth usage.

#### Initial IO limit value

The initial IO limit of vDisks bandwidth can be set to the value when vm is created, dynamically set via VDSM API. By default, it uses unlimited(0) and will be set to the bandwidth vDisk used when the congestion is detected by MOM.

#### IO bandwidth limit tuning

IO limit is tuned by a mechanism in MOM. Each vDisk has a priority and that may be derived from the priority of vm. For each vDisk, its IO bandwidth limit should be above a minimum limit value. This minimum value is associated with the priority. Higher priority vDisk has a larger minimum limit value. This ensures that higher priority vDisk has a higher IO limit when the IO bandwidth is quite scarce.

e.g. minimum limit value of vDisk

high priority: 8MB/s

low priority: 4MB/s

These values are set different for different storage domains, since they have diverse backends.

Here, we assume that vDisks can be either high priority or low priority. We use the following policy to automatic tuning the IO limit:

*   If the I/O congestion of storage domain is detected:
    -   IO limit of each vDisk is decreased by a certain percent. The percent are different for different priorities. After the tuning , the IO limit value should above minimum limit value of this vDisk.
    -   e.g. The decreased percent of IO limit: high priority: 5%, low priority: 10%

<!-- -->

*   If the I/O congestion of storage domain is not detected:
    -   IO limit of some vDisks are increased by a certain percent.
    -   Different from congestion, vDisks of different priorities are increased by the same percent, but only part of vDisks' IO bandwidth limits are increased. The vDisks are those whose IO bandwidth limit cannot meet its requirements. During the selection of vDisks, it should distinguish the situation that vm actually uses most of its allocated bandwidth and it requests more but limited by the IO limit.

#### Discussion

There should be a way to detect I/O congestion of storage domain by MOM, and the way need to be discussed.

How to judge that the vDisk need more IO bandwidth limit. This can be obtained from cmd like iostat's util. How about other kind of disks(NFS, GlusterFs)?

Is it proper to use total_bytes_sec to describe vDisk bandwidth and tune this value dynamically?

How to generate minimum IO limit?

### Quota(advanced feature)

#### Disk bandwidth quota

As the design in <http://www.ovirt.org/Features/Quota>, quota provides the administrator a logic mechanism for managing resources allocation for users and groups in the Data Centre. You need to create the relevant quota, and define the user as a quota consumer .

We would like to add one kind of quota for disk bandwidth IO control.

For example, the following Quota configuration, is for A and B team:

         Name: ExampleQuota
         Description: Quota configured for A and B team
         Data Center: Data_Center_1
         Resource limitations:
             Storage I/O bandwidth Limitations::
                 Storage Domain 1:  total_bytes_sec 10MB/s
                 Storage Domain 2: total_bytes_sec 8MB/s
         List of Users/Groups:
             A team
             B team

#### IO bandwidth limit and reserve

A vm created by quota consumer(users/groups) consumes quota for the related storage domain. To better allocate this quota to vDisks of these VMs, we add a vDisk minimum IO limit value in VM's configuration. This value is used for reserving the bandwidth resource to VM's vDisk.

When quota is a constant, we'd like to make sure:

SD IO bandwidth quota for certain users >= sum of vDisk( related volume in this SD) minimum IO limit value

The vms consume the quota are created by the users defined as consumer, and they should be in running, suspend, hibernate state, but not in shutdown state.

We use the following policy:

*   When a new vm is started, the operation will fail if others vDisks minimum IO limit value adding the new vm vDisks' minimum limit exceeds the quota.
*   This vDisks minimum IO limit value can be adjusted dynamically.
    -   If the minimum IO limit is deflated, it will not exceed the quota, the operation can always succeed.
    -   If the minimum IO limit is inflated and will not exceed the quota, the operation can succeed. However, the operation will fail if the sum of new value and others vDisks minimum IO limit value exceeds the quota.

As in the quota design, quota object parameters modifications can result in exceeding the resource limitations:

*   reducing the disk IO limitation of some storage domain

<!-- -->

*   removing a user from the list of users permitted to use the quota

All the above will not cause a resource deallocation. However, users will not be able to exceed the quota limitations again after the resources are released. Also, if a user was removed from the list of permitted users it won't result in an immediate interruptive action. However, that user won't be able to use this quota again, unless permitted to.

### Functionality

Basic:

Users can set the elements Detailed Description Section for a specific vDisk when a VM is created or running. These elements are kept in migration.

This requires support of this in VDSM API: create VM, hot plug and update VM device. Dynamic setting these elements should also be supported.

Advanced:

Users can set the SD quota in engine and define cosumers(users/groups).

Users can set the vDisk minimum IO limit in engine.

## Documentation / External references

<http://libvirt.org/formatdomain.html#elementsDisks>

## Testing

Expected unit-tests

## Comments and Discussion

<Category:SLA> [Category: Feature](Category: Feature)

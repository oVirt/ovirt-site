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
*   Last updated: 30 May
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

This feature will allow qos and SLA for storage bandwidth I/O control.

## Design

### Quota

As the design in <http://www.ovirt.org/Features/Quota>, quota provides the administrator a logic mechanism for managing resources allocation for users and groups in the Data Center. You need to create the relevant quota, and define the user as a quota consumer .

We would like to add one kind of quota for disk bandwidth I/O control.

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

### VM I/O bandwidth limit and reserve

A vm created by quota consumer(users/groups) consumes quota for the related storage domain. To better allocate this quota to vDisks of these VMs, we add a vDisk minimum I/O value in VM's configuration. This value is used for reserving the badwidth resource to VM's vDisk.

When quota is a constant, we'd like to make sure:

SD I/O bandwidth quota for certain users >= sum of vDisk( related volume in this SD) minimum reserved I/O value The vms consume the quota are created by the users defined as consumer, and they should be in running, suspend, hibernate state, but not in shutdown state.

We use the following policy:

*   When a new vm is started, the operation will fail if others vDisks minimum reserved I/O value adding the new vm vDisks' minimum value exceeds the quota.
*   This vDisks minimum reserved I/O value can be adjusted dynamicly.
    -   If the reserved I/O value is deflated, it will not exeed the quota, the operation can always succeed.
    -   If the reserved I/O value is inflated and will not exeed the quota, the operation can succeed. Howere, the operation will fail if the sum of new value and others vDisks minimum reserved I/O value exeeds the quota.

As in the quota design, quota object parameters modifications can result in exceeding the resource limitations: reducing the disk I/O limitation of some storage domain removing a user from the list of users permitted to use the quota

All the above will not cause a resource deallocation. However, users will not be able to exceed the quota limitations again after the resources are released. Also, if a user was removed from the list of permitted users it won't result in an immediate interruptive action. However, that user won't be able to use this quota again, unless permitted to.

### Basic functionality

Users can set the elements for a specific vDisk when a VM is created or running. These elements are kept in migration. This requires support of this in VDSM API: create VM, hot plug and update VM device. Dynamic setting these elements should also be supported.

### Automatic per-device I/O tuning

Volumes in backend storage of a storage domain are used by plenty of vms as vDisks, and thus a vm's vDisk bandwidth should be limited by a upper bound(io limit) according to the capability of this backend storage. In the following chapters, we will explain how to tune this io limit dynamically . The adjustment is performed by MOM.,VDSM and Engine.

This section gives the way to set initial value. This value is used as start point when io limit is adjusted. The io limit is then tuned according to IO bandwidth usage and capability of backend storage bandwidth. During this tuning procedure, the io limit can not be inflated or deflated arbitrarily, so we constrain it in a dynamic calculated range.

#### Initial io limit value

The initial io limit of vDisks bandwidth can be set to the value when vm is created, dynamically set via VDSM API or bandwidth capability of the related backend storage. The capability is estimated based on physical backend IO bandwidth capability or detected in some other way.

#### io limit tuning

Io limit is tuned by a similar mechanism in MOM. MOM collects bandwidth capability information and IO bandwidth usage statistics of backend storages and related volumes. According to this information and related policy, the policy engine decides how to tune the io limit of vDisk which uses that backend storage .

If the backend storage bandwidth is heavily used(i.e. The unused bandwidth ratio of that backend is lower than a threshold), the io limits for the vDisks related to that backend are deflated by a certain percent. Otherwise, the iolimits for the vDisks bandwidth are inflated by the same percent.

At the same time, the policy make sure that the io limit is in a proper range dynamically calculated. The policy calculated the range for different priority level vDisks in diverse ways. The vDisk is either high priority or low priority, and the level may derived from the priority of user/vm. For high priority vDisks, the policy tends to make the lower bound of range not too small. In the opposite, the policy tends to make the upper bound of range not too large for low priority vDisks. The details is described as following:

## Documentation / External references

<http://libvirt.org/formatdomain.html#elementsDisks>

## Testing

Expected unit-tests

## Comments and Discussion

The quota value may related to 6 items in Detailed Description Section(total_bytes_sec, read_bytes_sec......). Do we need to support all of them?

<Category:SLA> [Category: Feature](Category: Feature)

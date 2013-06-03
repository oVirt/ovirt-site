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

SD I/O bandwidth quota for certain users >= sum of vDisk( related volume in this SD) minimum reserved I/O value

The vms consume the quota are created by the users defined as consumer, and they should be in running, suspend, hibernate state, but not in shutdown state.

We use the following policy:

*   When a new vm is started, the operation will fail if others vDisks minimum reserved I/O value adding the new vm vDisks' minimum value exceeds the quota.
*   This vDisks minimum reserved I/O value can be adjusted dynamicly.
    -   If the reserved I/O value is deflated, it will not exeed the quota, the operation can always succeed.
    -   If the reserved I/O value is inflated and will not exeed the quota, the operation can succeed. However, the operation will fail if the sum of new value and others vDisks minimum reserved I/O value exeeds the quota.

As in the quota design, quota object parameters modifications can result in exceeding the resource limitations:

reducing the disk I/O limitation of some storage domain removing a user from the list of users permitted to use the quota

All the above will not cause a resource deallocation. However, users will not be able to exceed the quota limitations again after the resources are released. Also, if a user was removed from the list of permitted users it won't result in an immediate interruptive action. However, that user won't be able to use this quota again, unless permitted to.

The vDisk should also have a io bandwidth limit and this value is adjusted based on actual badwidth usage in order to ensure the bandwidth are reserved for each vDisk.

### Basic functionality

Users can set the SD quota in engine and define cosumers(users/groups). Users can set the vDisk minimum reserved I/O value in engine. Engine can obtain statistic of I/O of each vm. This requires support of the statistics info in VDSM API. Users can set the elements Detailed Description Section for a specific vDisk when a VM is created or running. These elements are kept in migration. This requires support of this in VDSM API: create VM, hot plug and update VM device. Dynamic setting these elements should also be supported.

### Automatic per-device tuning for I/O bandwidth limit

      In the following chapters, we will explain how to tune this io bandwidth limit dynamically . The adjustment is performed by MOM,VDSM and Engine. 

This section gives the way to set initial value. This value is used as start point when io limit is adjusted. The io limit is then tuned according to IO bandwidth usage of vms.

#### Initial IO limit value

The initial io limit of vDisks bandwidth can be set to the value when vm is created, dynamically set via VDSM API. By defualt, it will use quota as upper bound.

#### IO limit tuning

Io limit is tuned by a similar mechanism in MOM but need Engine to make the whole decision. THis is because vms use that storage domain reside on different host, and the tunning need a global decision. We use the following policy:

*   If one or above vms's io is below the reserve, we pick a vDisk created by quota consumer and use this storage domain to deflate its io limit by certain percent(e.g. 5% but not below the reserved min value).

To this end, we need to distinguish the situation that vm has fewer IO than reserved and other vm's IO affect its IO bandwidth. The vm picked satisfies:

      vDisk I/O bandwidth usage - minimum reserved I/O value reserved is the max among all the vDisks that consumes the quota

*   If all vDisks' reserve IO bandwidth can be guarteed

the IO limit for a vm can be inflated by a certain percent. (not exeeding quota) The vm picked satisfies:

      vDisk IO limit - I/O bandwidth usage is the min among all the vDisks that consumes the quota

Thus, MOM need collect IO bandwidth usage statistics of vms' vDisks and check if its reserve cannot be guaranteed or all the vDisks can be guaranteed. If it is the case, it should notify vdsm and further engine. VDSM can change the status and make engine know when it poll these information. When engine is notified, it picks the vDisk and set its io limit to a new value.

## Documentation / External references

<http://libvirt.org/formatdomain.html#elementsDisks>

## Testing

Expected unit-tests

## Comments and Discussion

The quota value may related to 6 elements in Detailed Description Section(total_bytes_sec, read_bytes_sec......). Do we need to support all of them? This design should not involve problem when import or export VM since min reserved I/O value can be adjusted after importing, and the limit can be adjusted automatically. In this design, we let engine to do the tuning decision. Maybe we could ask mom in SPM to do the decision, but this requires mom in different hosts communicates with each other.

<Category:SLA> [Category: Feature](Category: Feature)

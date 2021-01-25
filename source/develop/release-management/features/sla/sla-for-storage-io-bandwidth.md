---
title: SLA for storage io bandwidth
category: sla
authors: mei liu
---

# SLA for storage io bandwidth

## Summary

This wiki page focuses on the design of storage I/O bandwidth Service Level Agreement(SLA).

## Owner

*   Name: Mei Liu
*   Email: <liumbj at linux dot vnet dot ibm dot com>

## Current Status

*   Status: design
*   Last updated: 28 June

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

This feature will allow QoS and SLA for storage bandwidth IO control.

## Design

### vDisk Profile in engine

In order to define more natural coupling of the SLA to a vDisk of VM, we define a new concept called vDisk Profile in engine as disk Profile. This will wrap few of the properties currently defined directly on the vDisk.

vDisk profile includes:

*   initial IO bandwidth limit value(optional, e.g. total_bytes_sec, if not set, it is 0 which implies no limit)
*   MOM auto tuning range: min bandwidth limit(required)
*   priority: higher priority has smaller value
*   other existing vDisk info

We suggest to use total_bytes_sec only as IO bandwidth limit, since it includes reading an writing operations and takes the IO size into account.

When creating a new vDisk or editing an existing one the user will select a vDisk Profile. The administrator could create several vDisk Profiles for each storage domain. He could then grant a users with the permission to use some of the profiles.

For example: the admin will create two vDisk profiles for storage domain SD-1:

*   Profile "Gold"
    -   initial IO bandwidth limit value: 100MB/s
    -   min bandwidth limit: 6MB/s
    -   priority:0

<!-- -->

*   Profile "Silver"
    -   initial IO bandwidth limit value: 100MB/s
    -   min bandwidth limit: 4MB/s
    -   priority:1

Higher priority user group can use profile "Gold", while lower priority user group can use profile "Silver".

The vDisk Profile could be edited by the administrator at any time. The changes will seep down to all vDisks using the profile. In case vDisk using the edited profile are connected to running VMs the change will apply only on the VM next started. Devices which will be hotpluged or updated will use the updated profile connected to the vDisk.

When a Template is created from a VM the vDisk Profile will be kept along with the vDisk. When a VM is created from template the vDisk Profiles will be taken from the template's vdisks. vDisk Profiles could not be deleted from the engine as long as one or more VM/Templates are using those profiles. When a vDisk is exported and imported, a new profile should be selected which is related to an granted access to the user when the vm is powered on.

### Automatic per-device tuning for IO bandwidth limit(basic feature)

In the following chapters, we will explain how to tune this IO bandwidth limit dynamically . The adjustment is performed by MOM. This section gives the way to set initial value. This value is used as start point when IO limit is adjusted. The IO limit is then tuned according to IO bandwidth usage.

#### Initial IO bandwidth limit value

The initial IO limit of vDisks bandwidth can be set to the value when vm is created. By default, it uses unlimited(0).

#### IO bandwidth limit tuning

IO limit is tuned by a mechanism in MOM. For each vDisk, its IO bandwidth limit should be in range (min bandwidth limit, max bandwidth limit) which is set in engine. We use the following policy to automatic tuning the IO limit.

The basic idea is that when congestion happens, MOM find the highest priority disk which is congested. MOM then decreases the IO limit of those disk whose priority lower than this congested vDisk, and increase the IO limit of those whose priority are higher or equal to the congested vDisk and throughput is almost current IO limit. When no vDisk is congested, the IO limit of vDisks who use almost current IO limit will be increased.

If a host find a vDisk is congested it will report related info to engine by get stats. Then engine will tell other hosts' MOM . They will adjusted used the policy above.

The algorithm is as follows

       initialization:
       vDisk[i].climit =  very big number (similar to unlimited)

       Each run:
       vDiskTuneUp = []
       vDiskCongested = `[](/)` * priorityCount  
       for disk in vDisk:
         if disk.throughput >= disk.climit * 90%:
             vDiskTuneUp.append(vm)
         if vm.throughput < vm.climit * 90% && vm.util > 90%:
             vDiskCongested[vm.priority].append(vm) 
       for diskPriority = 0 to priorityCount - 1:
         if len(vDiskCongested[diskPriority]) == 0:
             continue  # no disk is congested for this diskPriority
         break  
         else:
             diskPriority = priorityCount
       for disk in vDisk:
         if disk.priority > diskPriority:
             # decrease those whose priorities are lower
             disk.climit = disk.throughput - (vm.disk - vm.blimit) * 10%
         else if  disk in vDiskTuneUp:
             disk.climit = disk.climit * 110%

#### Discussion

Is it proper to use total_bytes_sec to describe vDisk bandwidth and tune this value dynamically?

### Functionality

Basic: Admin can created the SD profile and grant to users

Users can select the profile for a specific vDisk when a VM is created . These elements are kept in migration.

Support in VDSM API: create VM, hot plug and update VM device. Dynamic setting these elements should also be supported.

The ovirt gust agent should collect info like util.

## Documentation / External references

<http://libvirt.org/formatdomain.html#elementsDisks>

## Testing

Expected unit-tests

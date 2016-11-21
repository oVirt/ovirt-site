---
title: Memory FAQ
authors: apahim, rmiddle
wiki_title: Memory FAQ
wiki_revision_count: 6
wiki_last_updated: 2012-07-20
---

# Memory FAQ

oVirt Memory Frequently Asked Questions

## How does oVirt check the available memory to start a VM?

CURRENT MEMORY ALLOCATION (MB):

     DATABASE/Target Node/vds_dynamic.mem_commited = 68551
     DATABASE/Target Node/vds_dynamic.pending_vmem_size = 0
     DATABASE/Target Node/vds_dynamic.guest_overhead = 65
     DATABASE/Target Node/vds_dynamic.reserved_mem = 256
     DATABASE/Target VM/vm_static.min_allocated_mem = 2048

     68551 + 0 + 65 + 256 + 2048 = 70920

CURRENT OVERCOMMIT RATE:

     DATABASE/Target Node's Cluster/vds_groups.max_vds_memory_over_commit = 100

CURRENT MEMORY LIMIT (MB):

     DATABASE/Target Node/vds_dynamic.physical_mem_mb = 64420

     max_vds_memory_over_commit * physical_mem_mb / 100
     100 * 64420 / 100 = 64420

"CAN RUN VM?" LOGIC:

     IF "CURRENT MEMORY ALLOCATION (70920)" <= "CURRENT MEMORY LIMIT (64420)"
      THEN RUN VM
      ELSE CAN NOT RUN VM

## What is the difference between "Defined Memory" and "Physical Memory Guaranteed"?

Physical Memory Guaranteed is the minimum threshold always available to VM. It's a value that oVirt is taking care, but not used anywhere to define the VM. VM will use as much memory as needed, till the limit of Defined Memory. This flexible memory allocation is called memory ballooning.

Using free comand, the Total Memory is always the Defined Memory. You can also check the actual active memory on VM:

    # grep "Active:" /proc/meminfo

## Where are the memory usage value for each Node coming from?

This value is coming from oVirt Node memory statistcs in /proc/meminfo. It depends on how much memory is being used by the entire system, including VMs and all processes.

## Why can I not start a new VM due to "Cannot run VM. There are no available running Hosts with sufficient memory in VM's Cluster."?

Even with low Node memory usage. Even when VMs are not using all Node memory, oVirt must assure that will have enough memory when VMs become high loaded. To do so, oVirt considers the worst case (see #1).

## Why is the use of memory for each VM in 0%?

You have to install [ovirt-guest-agent](/documentation/internal/guest-agent/guest-agent/) on each VM in order to see memory usage.

## How does "Cluster / Memory Optimization" work?

When you set your cluster to Memory Optimization, you are setting max_vds_memory_over_commit (see #1) to 150 (server load) or 200 (desktop load).This setting allows oVirt to create VMs as if had 50% (server load) or (100%) more physical memory than really has.

## What does "Shared Memory" stand for?

Shared Memory is the result of [KSM](http://www.linux-kvm.org/page/KSM) memory page de-duplication. oVirt shows the percent of memory being saved by KSM.

## How is "Shared Memory" calculated?

oVirt NODE TOTAL MEMORY (MB):

     DATABASE/Target Node/vds_dynamic.physical_mem_mb = 64420

oVirt NODE MEMORY SHARED (MB):

    # vdsClient -s 0 getVdsStats | grep memShared
            memShared = 16105

"SHARED MEMORY" LOGIC:

    memShared * 100 / physical_mem_mb
    16105 * 100 / 64420  = 25%

## Where does oVirt use "Shared Memory"?

oVirt does not use this value to any operation/calculation, overcommit included. But KSM will help oVirt Nodes to avoid using swap when you overcommit them and they become highly loaded.

---
title: FreeMemoryCalculation
category: sla
authors: doron
---

# SLA: Free memory calculations explained

## Summary

This page explains how the engine calculates free memory available on a host.

During the scheduling process, the engine calculates the amount of free memory
which is available on every candidate host. This memory can be more than the physical
size if we use over-commitment capabilities (KSM, balloon, etc), but it also needs to reduce
some factors which take their memory toll. Also, note that this calculation is done for a given
VM. See below for the full details.

## Description

The below calculation is taken from org.ovirt.engine.core.bll.scheduling.SlaValidator.hasMemoryToRunVM.
Please use this information with caution, as wiki updates are not always catching up with the code updates...

      double vdsCurrentMem =
              curVds.getmem_commited()    // (vm.getvm_mem_size_mb + _vds.getguest_overhead) * all VMs for this vds
              + curVds.getpending_vmem_size()    // getParameters().getVm().getMinAllocatedMem() => all VMs not running yet.
              + curVds.getguest_overhead()    // reported by vds. Default is 65.
              + curVds.getreserved_mem()    // reported by vds as host_mem_reserve(256) + extra_mem_reserve(65) = 321
              + vm.getMinAllocatedMem();    // 'Physical Memory Guaranteed'

      double vdsMemLimit = 
              curVds.getmax_vds_memory_over_commit()   // comes from cluster. default is 120
              / 100.0                                    // get the overcommit ratio right
              * curVds.getphysical_mem_mb()    // reported by vdsm: 'cat /proc/meminfo | grep MemTotal' / 1024

      retVal = (vdsCurrentMem <= vdsMemLimit);

The retVal is a boolean flag which validates to True when there is sufficient memory.


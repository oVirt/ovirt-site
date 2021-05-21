---
title: Even VM Count Distribution
category: feature
authors:
  - doron
  - jmoskovc
---

# Even VM distribution based on VM count per host

## Summary

The goal of this feature is to provide a cluster policy that evenly distributes VMs based on VM count.

## Owner

*   Name: Martin Sivak (msivak)
*   Email: msivak@redhat.com

## Current status

*   Last updated: 4-Jan-2017

## Detailed Description

*   **HighVMSCount** - Maximum VM limit. Exceeding it qualifies the host as overloaded.
*   **MigrationThreshold** - defines a buffer before we start migrating VMs from the host
*   **SPMVMCountGrace** - defines how many slots for VMs should be reserved on SPM hosts (the SPM host should have less load than others, so this variable defines how many VM less it should have)

The cluster is considered unbalanced if there is VDS with more than HighVMSCount VMs running on it AND there is at least one VDS with more then MigrationThreshold less VMs

**Unbalanced cluster**

![Unbalanced cluster](/images/wiki/Balancing-before.png)

**Cluster after 1 balancing iteration**

![](/images/wiki/Balancing-after1iter.png)

**Cluster after 2 balancing iterations**

![](/images/wiki/Balancing-after2iter.png)

### 1. iteration

1.  VM1 moved from VDS1 to VDS3 (to make the example simple, there is no special logic involved in selecting the VDS, so even though VDS5 is also a good target we simply take whatever comes first, but the target VDS should and will be selected by the scoring mechanism based on the count of running VMs on the VDS)
2.  The MigrationThreshold top moved from 12 to 11 and minimum is now 7

### 2. iteration

1.  VM2 moved to VDS5 (the only possible target, because it's the only one outside of the balancing window)
2.  The MigrationThreshold top moved from 11 to 10 and the minimum is now 6 which means the cluster is balanced because every VDS has VM count inside the MigrationThreshold

The cluster from this example is balanced after the 2nd iteration. The final VM distribution is shown on img "Cluster after 2 balancing iterations".

## Benefit to oVirt

This feature comes from customer request, so benefit to ovirt is a better customer satisfaction ;)

## Dependencies / Related Features

* NONE

## Documentation / External references

pseudo (python) code for the balance() method

    getOccupiedVMSlots(VDS):
       occupiedVMSlots = VDS.activeVMSCount()
       if VDS.isSPM():
          occupiedVMSlots = occupiedVMSlots + SPMVMCountGrace

    getBestVmToMigrate(VMS):  # just select the VM with the least CPU usage
      bestVMToMigrate = VMS[0]
      for vm in VMS:
        if vm.cpuUsage() < bestVMToMigrate.cpuUsage():
          bestVMToMigrate = vm

      return bestVMToMigrate

    getOverloadedVDS():
      worstVDS = None
      for vds in allVDS:
        if getOccupiedVMSlots(vds) > HighVMSCount AND worstVDS == None OR getOccupiedVMSlots(vds) > getOccupiedVMSlots(worstVDS)):
          worstVDS = vds

      return  worstVDS  # returns None (null) if no VDS has above HighVMSCount running vms

    balance():
      worstVDS = getOverloadedVDS()
      if worstVDS == None:  # nothing to balance
         return None

      possibleTargets = []
      for vds in allVDS:
         if (getOccupiedVMSlots(worstVDS) - getOccupiedVMSlots(vds)) >= MigrationThreshold:
            possibleTargets.add(vds)

      vmToMigrate = getBestVmToMigrate(worstVDS.getAllRunningVMS())
      return (possibleTargets, vmToMigrate)

[Algorithm simulation in python](http://jmoskovc.fedorapeople.org/even_vm_distribution.py)

## Testing

* TBD





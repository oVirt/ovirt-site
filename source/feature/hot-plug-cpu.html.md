---
title: Hot plug cpu
category: feature
authors: adahms, roy, sven
wiki_category: Feature
wiki_title: Hot plug cpu
wiki_revision_count: 33
wiki_last_updated: 2015-02-04
---

# Hot plug cpu

### Summary

This feature will allow to hot plug cpus to a running VM from ovirt engine UI and REST api.

### Owner

*   Name: [ Roy Golan](User:MyUser)
*   Email: rgolan@redhat.com

### Current status

*   1st draft of wiki and VDSM code
*   Last updated: ,

### Detailed Description

Historically, CPU and memory hot add and remove capabilities were thought of as server hardware RAS features. However, the concepts of CPU and memory hot add and remove are both common and necessary for Virtualized environments. Virtual CPUs and virtual memory assigned to a virtual machine (VM) need to be be added or removed from a running guest in order to meet either the workload's demands or to maintain the SLA associated with the workload. It is also desired for the rapid reconfiguration of a guest once a workload has been completed or migrated and an administrator wants to reconfigure the VM without having to re-boot the VM.

### Benefit to oVirt

this feature will enable this powerful use cases:

*   allow admins the ability to ensure customer's SLA are being met
*   allow utilizing spare hardware - its common to see systems overdimentioned x3 for an average max load
*   allow dynamically to scale vertically, down or up, a system hardware according to needs \*without restarting\* the VM

### changes

| Component       | requirement                                                                                                                       | completed                                                    |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| Engine          | UpdateVmCommand permits number of cpus change while VM is running                                                                 | Done                                                         |
| Engine          | UpdateVmCommand canDo fail if # of cpus is not supported on host (config value?, get the actual number from caps?)               | 0                                                            |
| Engine          | UpdateVmCommand send setNumberOfCpus verb when cpus changes                                                                       | Done                                                         |
| Engine          | UpdateVmCommand stores the new number of CPUs only if the call to setNumberOfCpus succeeded                                       | Done                                                         |
| Engine - osinfo | create configuration for plug/unplug                                                                                              | not clear which OSs we block/allow - PPC is blocked entirely |
| Engine          | create informative Audit log when setNumberOfCpus fails                                                                           | Done                                                         |
| VDSM            | create one new verb 'setNumberOfCpus'. it would be used for both plug/unplug cpus (its really "online" a cpu rather than hotplug) | Done                                                         |
| VDSM            | in vm.py, bind the verb to an underling call to libvirt's setVcpus                                                                | Done                                                         |
| VDSM            | call before/after hooks for plug/unplug to enable various method for onlining the CPU at the guest OS                             | Done                                                         |

      === check list ===

| Component | check                                                                                              | completed |
|-----------|----------------------------------------------------------------------------------------------------|-----------|
| VDSM      | check migration of a VM that was hotplugged with cpus and re-migrated it (not sure changes needed) |           |

### Dependencies / Related Features

*   running [qemu-guest-agent](http://wiki.qemu.org/Features/QAPI/GuestAgent)

### Documentation / External references

*   [oVIrt VDSM RFE](https://bugzilla.redhat.com/show_bug.cgi?id=1036492)
*   [QEMU hotplug cpu feature wiki page](http://wiki.qemu.org/Features/CPUHotplug)

### Open Issues

##### Possible error when migrating a VM which its max cpu is lower than what currently in **'' <vcpu current=n>m</vcpu>**''

The current VM on the source has ***n*** cpus attached and need ***m*** maximum to be able to online more.
if ***m1*** is the max cores on the the source ***H1*** host and ***m2*** is the maximum on destination host ***H2***
if ***m1 > m2*** the underlying migration should fail?

##### Possible CPU pinning problems

if we have cpu pinning for cpu 1-4 and we start the VM with 4 CPU and then we offline 2 CPUs and then we online them back - is the pinning is kept?

##### hook support

hook support is provided to solve potential problems with online/offline the cpu after the actual addition to the VM system. Its not clear if some linux versions will have the cpu added but offline in the system so the hook is to cover the gap.

      /usr/libexec/vdsm/hooks/before_set_num_of_cpu
      /usr/libexec/vdsm/hooks/after_set_num_of_cpu

### Testing

TODO

### Comments and Discussion

*   Refer to [Talk:Hot plug cpu](Talk:Hot plug cpu)

<Category:Feature> <Category:Template>

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

*   phase 1 (i.e all content in this wiki) - Done
*   phase 2 - [Hot_plug_cpu#Phase_2](Hot_plug_cpu#Phase_2) desgin stage
*   limitations: unplug isn't supported fully due to libvirt's bug [#1017858](https://bugzilla.redhat.com/show_bug.cgi?id=1017858#c11)
*   Last updated: ,

### Detailed Description

Historically, CPU and memory hot add and remove capabilities were thought of as server hardware RAS features. However, the concepts of CPU and memory hot add and remove are both common and necessary for Virtualized environments. Virtual CPUs and virtual memory assigned to a virtual machine (VM) need to be be added or removed from a running guest in order to meet either the workload's demands or to maintain the SLA associated with the workload. It is also desired for the rapid reconfiguration of a guest once a workload has been completed or migrated and an administrator wants to reconfigure the VM without having to re-boot the VM.

### Benefit to oVirt

this feature will enable this powerful use cases:

*   allow admins the ability to ensure customer's SLA are being met
*   allow utilizing spare hardware - its common to see systems overdimentioned x3 for an average max load
*   allow dynamically to scale vertically, down or up, a system hardware according to needs \*without restarting\* the VM

### Detailed Design

#### Client Usage

The term plug/unplug CPUs is simpler from the user POV. The user just needs to set the desired number of sockets he needs. I.e we support a number which is the multiplication of the Cores per sockets and sockets.

All of this means that the user can now simply change the number of sockets of a running VM while its status is UP. This would trigger a call to VDSM to setNumberOfCpus(vmId, num). there is no notion of plug/unplug.

##### UI

See that "Sockets" text input is editable while the VM is UP (its editable only when UP or DOWN statuses)

![](Hotplug-cpu-gui.png "Hotplug-cpu-gui.png")

##### REST

This is a typical update to a VM resource. The number of sockets is changed to 2. this will hotplug 1 more CPU to the machine.

      hotplug-cpu.xml
`  `<vm><cpu><topology sockets="2" cores="1"></topology></cpu></vm>

        curl -X PUT --user user@domain:pass -H "Content-Type:application/xml" -d@hotplug-cpu.xml  `[`http://localhost:8080/ovirt-engine/api/vms/`](http://localhost:8080/ovirt-engine/api/vms/)`${vmId}

#### Engine

Engine must allow updates to the number of sockets field while the VM is up. When calling the UpdateVmCommand, we will check
if the current number is different then the stored number of sockets. if it is we then call VDSM setNumberOfCpus(vmId, num).
If we returned with no error, the new number of CPUs is stored into db. The engine view of the actual vCpus of this machine is now syncronized.

A pre-condition for adding more CPUs is that a VM has a MAX_VCPUS set in its xml. this means we have to start the VM with some configured maximum. this number doesn't affect any reosurce allocation on the VM itself. Till today the MAX_VCPUS was equal to the number of CPUs the VM started with. So its impossible to hot plug more CPUs
to machines that started < 3.4 (i.e setup upgraded and the machines stayed UP)

pseudo-code for building a VM xml we send to VDSM

      if (hot plug is supported for this compat version) {
          smp = ConfigValues.MaxNumOfVmCpus
      }

### changes

| Component       | requirement                                                                                                         | completed                                                    |
|-----------------|---------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| Engine          | UpdateVmCommand permits number of cpus change while VM is running                                                   | Done                                                         |
| Engine          | UpdateVmCommand canDo fail if # of cpus is not supported on host (config value?, get the actual number from caps?) | 0                                                            |
| Engine          | UpdateVmCommand send setNumberOfCpus verb when cpus changes                                                         | Done                                                         |
| Engine          | UpdateVmCommand stores the new number of CPUs only if the call to setNumberOfCpus succeeded                         | Done                                                         |
| Engine - osinfo | create configuration for plug/unplug                                                                                | not clear which OSs we block/allow - PPC is blocked entirely |
| Engine          | create informative Audit log when setNumberOfCpus fails                                                             | Done                                                         |
| VDSM            | create new verb 'setNumberOfCpus'. it would be used for both plug/unplug cpus                                       | Done                                                         |
| VDSM            | in vm.py, bind the verb to an underling call to libvirt's setVcpus                                                  | Done                                                         |
| VDSM            | call before/after hooks for plug/unplug to enable various method for onlining the CPU at the guest OS               | Done                                                         |

      === check list ===

| Component | check                                                                                              | completed |
|-----------|----------------------------------------------------------------------------------------------------|-----------|
| VDSM      | check migration of a VM that was hotplugged with cpus and re-migrated it (not sure changes needed) |           |

### Dependencies / Related Features

*   ***setNumOfCpus --guest*** (using qemu guest agent for plug/unplug)

There is no direct dependency on QEMU's agent. But for the sake of documenting any detail we have, its worth mentioning that<b>

libvirt's setNumOfCpus --guest will use the guest agent to offline/online the requested cpu instead of a real plug/unplug

i.e that the as for RHEL, the guest alone handles the plug/unplug without the need of the agent to do the underling job.

for more details see comment 11 on Bug [#1017858](https://bugzilla.redhat.com/show_bug.cgi?id=1017858#c11)

[qemu-guest-agent](http://wiki.qemu.org/Features/QAPI/GuestAgent)

### Guest OS Support Matrix

| OS                               | Version                                   | Arch      | Plug            | Unplug          |
|----------------------------------|-------------------------------------------|-----------|-----------------|-----------------|
| Red Hat Enterprise Linux 6.3     |                                           | x86       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              -                

                                                                                                              </center>        |
| Red Hat Enterprise Linux 6.5     |                                           | x86       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              +                

                                                                                                              </center>        |
| Microsoft Windows Server 2003    | All                                       | x86       | <center>        
                                                                                            -                

                                                                                            </center>        | <center>        
                                                                                                              -                

                                                                                                              </center>        |
| Microsoft Windows Server 2003    | All                                       | x64       | <center>        
                                                                                            -                

                                                                                            </center>        | <center>        
                                                                                                              -                

                                                                                                              </center>        |
| Microsoft Windows Server 2008    | All x86                                   | <center>  
                                                                                -          

                                                                                </center>  | <center>        
                                                                                            -                

                                                                                            </center>        |
| Microsoft Windows Server 2008    | Standard, Enterprise                      | x64       | Reboot Required | Reboot Required |
| Microsoft Windows Server 2008    | Datacenter                                | x64       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              ?                

                                                                                                              </center>        |
| Microsoft Windows Server 2008 R2 | All                                       | x86       | <center>        
                                                                                            -                

                                                                                            </center>        | <center>        
                                                                                                              -                

                                                                                                              </center>        |
| Microsoft Windows Server 2008 R2 | Standard, Enterprise                      | x64       | Reboot Required | Reboot Required |
| Microsoft Windows Server 2008 R2 | Datacenter                                | x64       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              ?                

                                                                                                              </center>        |
| Microsoft Windows Server 2012    | All                                       | x64       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              ?                

                                                                                                              </center>        |
| Microsoft Windows Server 2012 R2 | All                                       | x64       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              ?                

                                                                                                              </center>        |
| Microsoft Windows 7              | All                                       | x86       | <center>        
                                                                                            -                

                                                                                            </center>        | <center>        
                                                                                                              -                

                                                                                                              </center>        |
| Microsoft Windows 7              | Starter, Home, Home Premium, Professional | x64       | Reboot Required | Reboot Required |
| Microsoft Windows 7              | Enterprise, Ultimate                      | x64       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              ?                

                                                                                                              </center>        |
| Microsoft Windows 8.x            | All                                       | x86       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              ?                

                                                                                                              </center>        |
| Microsoft Windows 8.x            | All                                       | x64       | <center>        
                                                                                            +                

                                                                                            </center>        | <center>        
                                                                                                              ?                

                                                                                                              </center>        |

### Documentation / External references

*   [oVIrt VDSM RFE](https://bugzilla.redhat.com/show_bug.cgi?id=1036492)
*   [QEMU hotplug cpu feature wiki page](http://wiki.qemu.org/Features/CPUHotplug)
*   [Linux Kernel Documentation for hotplug](https://www.kernel.org/doc/Documentation/cpu-hotplug.txt)

### Open Issues

##### Possible error when migrating a VM which its max cpu is lower than what currently in **'' <vcpu current=n>m</vcpu>**''

The current VM on the source has ***n*** cpus attached and need ***m*** maximum to be able to online more.
if ***m1*** is the max cores on the the source ***H1*** host and ***m2*** is the maximum on destination host ***H2***
if ***m1 > m2*** the underlying migration should fail?

##### Possible CPU pinning problems

if we have cpu pinning for cpu 1-4 and we start the VM with 4 CPU and then we offline 2 CPUs and then we online them back - is the pinning kept?

##### hook support

hook support is provided to solve potential problems with online/offline the cpu after the actual addition to the VM system. Its not clear if some linux versions will have the cpu added but offline in the system so the hook is to cover the gap.

      /usr/libexec/vdsm/hooks/before_set_num_of_cpus
      /usr/libexec/vdsm/hooks/after_set_num_of_cpus

### Phase 2

Due to libvirt bug on unplug the engine has an inconsistent view of the amount of CPUs the VM has.
i.e after unplugging 4 vcpus to 2 vcpus the VM entity in DB has 4 and in qemu process it will decrease to 2

lets break to 2 problems to solve:

*   inconsistent view

to bridge a new entry under vm_dynamic will should the actual vcpu allocation

this new field will be reported by the ***VDSM-guest-agent***

the whole cpu topology will also be reported

an audit log will be sent once a day if we detect that (actual vcpu) != (vm.socket \* vm.coresPerSocket)

*   hot unplug bug workaround

instead of unplugging , we can try to offline the cpu instead, again using the ***VDSM-guest-agent***

this raises question about what happens to the virtualization thread that is dedicated for the cpu when it offlines - can the host use it

for other VMs? i.e is this resource is reclaimed?

VDSM-guest-agent work for reporting this is already in progress - <http://gerrit.ovirt.org/23268>

### Testing

TODO

### Comments and Discussion

*   Refer to [Talk:Hot plug cpu](Talk:Hot plug cpu)

<Category:Feature> <Category:Template>

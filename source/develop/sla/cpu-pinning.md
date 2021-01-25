---
title: cpu-pinning
category: sla
authors: doron, ecohen, lhornyak
---

# cpu-pinning

## Introduction

CPU pinning is the ability to run specific VM's virtual CPU (vCPU) on
specific physical CPU (pCPU) in a specific host. Currently there's
a vdsm hook handling it, and we'd like to implement it in the engine
itself.

## How does it work?

Existing libvirt [support](http://libvirt.org/formatdomain.html#elementsCPU) sample:

      <domain>
        ...
        <cputune>
          <vcpupin vcpu="0" cpuset="1-4,^2"/>
          <vcpupin vcpu="1" cpuset="0,1"/>
          <vcpupin vcpu="2" cpuset="2,3"/>
          <vcpupin vcpu="3" cpuset="0,4"/>
        </cputune>
        ...
      </domain>

## Engine core

*   A new VM attribute - cpuTopology - will be added to support this feature.
    -   Means a DB change: extend vm_static to add it.
*   The attribute will hold a string in a libvirt-like format
    -   Format: v#p[_v#p]
    -   Examples
        -   0#0 => pin vCPU 0 to pCPU 0
        -   0#0_1#3 => pin vCPU 0 to pCPU 0 and pin vCPU 1 to pCPU 3
        -   1#1-4,^2 => pin vCPU 1 to pCPU set 1 to 4, excluding 2.
*   Validations
    -   Make sure we have vCPU and pCPU(set) for each given pattern:
        \*# Parse string for '_'

        \*# For each entry: parse string for '#'

        \*# Make sure we got 2 elements (vCPU and pCPU)
*   Default value is NULL
*   The attribute will be added to the new API as a VM level attribute (ie- not a device),sent as a dictionay.

## VDSM

VDSM receives the cpu pinning information through its xml-rpc interface at createVM (alias VM.create()) call. Expected data structure:

      * cpuPinning - map of { vcpuid : cpuset } e.g. { 0 : '1-4' } sets the vcpu 4 to cpu 1-4

## Rest API

*   Should be added in the relevant actions.

      <cpu>
        <topology sockets="4" cores="1"/>
        <cputune>
          <vcpupin vcpu="0" cpuset="1-4,^2"/>
          <vcpupin vcpu="1" cpuset="0,1"/>
          <vcpupin vcpu="2" cpuset="2,3"/>
          <vcpupin vcpu="3" cpuset="0,4"/>
        </cputune>
      </cpu>

## UI

*   In relevant dialog, we'll add a plain text-box.
*   Validations
    -   Make sure we have vCPU and pCPU(set) for each given pattern:
        \*# Parse string for '_'

        \*# For each entry: parse string for '#'

        \*# Make sure we got 2 elements (vCPU and pCPU)

![](/images/wiki/Neweditvmdialogcpuenabled.png)

## Notes

1.  Due to API change, This will be supported in 3.1 clusters only.
2.  Live migration **may fail**, if destination host cannot support the relevant pinning request.


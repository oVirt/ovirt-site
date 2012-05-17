---
title: cpu-pinning
category: sla
authors: doron, ecohen, lhornyak
wiki_category: SLA
wiki_title: Features/Design/cpu-pinning
wiki_revision_count: 10
wiki_last_updated: 2012-10-30
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
          <vcpupin vcpu="0" cpuset="1-4,^2"/>
          <vcpupin vcpu="1" cpuset="0,1"/>
          <vcpupin vcpu="2" cpuset="2,3"/>
          <vcpupin vcpu="3" cpuset="0,4"/>
        </cputune>
        ...
      </domain>

## Engine core

*   A new VM attribute - cpuTopology - will be added to support this feature.
*   The attribute will hold a string in a libvirt-like format
    -   Format: v#p[_v#p]
    -   Examples
        -   0#0 => pin vCPU 0 to pCPU 0
        -   0#0_1#3 => pin vCPU 0 to pCPU 0 and pin vCPU 1 to pCPU 3
        -   1#1-4,^2 => pin vCPU 1 to pCPU set 1 to 4, excluding 2.
*   Validations
    -   Make sure we have vCPU and pCPU(set) for each given pattern.
*   Default value is NULL
*   The attribute will be added to the new API as a VM level attribute (ie- not a device),sent as a dictionay.

## VDSM

*   The attribute should be added to the libvirt XML, similar to the existing hook Shahar wrote
*   vcpu.setAttribute('cpuset', os.environ['pincpu'])
*   Live migration will not be supported for such VM's.

## Rest API

*   Should be added in the relevant actions.

      <cpu>
        <topology sockets="4" cores="1"/>
        <cputune>
          <vcpupin vcpu="0" cpuset="1-4,^2"/>
          <vcpupin vcpu="1" cpuset="0,1"/>
          <vcpupin vcpu="2" cpuset="2,3"/>
          <vcpupin vcpu="3" cpuset="0,4"/>
        </cputune>
      </cpu>

## UI

*   In relevant dialog, we'll add a plain text-box that is available only when VM is pinned to host.
*   Validations
    -   Make sure we have vCPU and pCPU(set) for each given pattern.

## Notes

1.  Due to API change, This will be supported in 3.1 clusters only.

---
title: NUMA and Virtual NUMA
category: feature
authors: adahms, danken, jasonliao
wiki_category: Feature
wiki_title: Features/NUMA and Virtual NUMA
wiki_revision_count: 20
wiki_last_updated: 2014-08-14
---

# NUMA and Virtual NUMA

### Summary

This feature allow Enterprise customers to provision large guests for their traditional scale-up enterprise workloads and expect low overhead due to virtualization by two ways.

*   Set NUMA node Tuning
*   Set Guest NUMA topology

### Owner

*   Name: [ Jason Liao](User:JasonLiao), [ Bruce Shi](User:BruceShi)
*   Email: <chuan.liao@hp.com>, <xiao-lei.shi@hp.com>
*   IRC: jasonliao, bruceshi @ #ovirt (irc.oftc.net)

### Current status

*   Target Release: oVirt 3.5
*   Status: design
*   Last updated: 13 Feb 2014

### Detailed Description

*   Get Host NUMA topology

Ability from the UI (with appropriate backend support) to query the host NUMA node topology, it contains node’s cpus, memory (total and free) and distance. This information is useful when trying to provision a midsized or large guests for enterprise workloads.

Dependencies: libvirt [Host Capability](http://libvirt.org/guide/html/Application_Development_Guide-Connections-Capability_Info.html)

    <capabilities>
      <host>
      ...
        <topology>
          <cells num='1'>
            <cell id='0'>
              <cpus num='2'>
                <cpu id='0'/>
                <cpu id='1'/>
              </cpus>
            </cell>
          </cells>
        </topology>
      </host>
      ...
    </capabilities>

*   Set Guest NUMA node tuning

Ability from the UI (with appropriate backend support) to specify the host NUMA node information for the backing memory of a large guest (i.e. via numatune with mode set to: strict, preferred or interleave) across specified host NUMA nodes. Here is an example from a XML config file of a guest where the backing guest’s memory is interleaved between host NUMA nodes 0, 1

Dependencies: libvirt [NUMA Node Tuning](http://libvirt.org/formatdomain.html#elementsNUMATuning)

    <domain>
      ...
      <numatune> 
        <memory mode='interleave' nodeset='0-1'/> 
      </numatune>
      ...
    </domain>

*   Set Guest virtual NUMA topology

Ability from the UI (with the appropriate backend support) to specify and expose virtual NUMA nodes in a guest that spans more than a single host node. This allows the OS instance in the guest to take NUMA aware decisions and this improves scaling/performance within the guest. Here is an example from a guest XML config file where there are two virtual NUMA nodes in the guest.

Dependencies: [Guest NUMA topology](http://libvirt.org/formatdomain.html#elementsCPU)

    <domain>
      ...
      <cpu> 
        <numa> 
          <cell cpus='0-7' memory='10485760'/> 
          <cell cpus='8-15' memory='10485760'/> 
        </numa> 
      </cpu>
      ...
    </domain>

You may also refer to the [detailed feature page](http://www.ovirt.org/Features/Detailed_NUMA_and_Virtual_NUMA).

### Benefit to oVirt

The hypervisor’s default policy is to schedule and run the guest on any available resources on the host. As a result, the resources backing a given guest could end up getting spread out across multiple NUMA nodes and over a period of time may get moved around, leading to poor and unpredictable performance inside the guest. Use the NUMA feature configuration could allow the users to get better performance from their VM's through using all CPU related memory - including the ones not handled by qemu/kvm. Allows users to get better performance from their VM's through split virtual NUMA node

Note: AutoNUMA/SchedNUMA balancing changes in the Linux kernel (i.e. upstream 3.13 kernel) should help reduce the need for having to explicitly specify this for a guest. But there will still be specific use cases where having this ability in the UI will prove useful.

### Documentation / External references

*   [BZ1010059 - NUMA aware and balanced allocation of backing host resources for large guests](https://bugzilla.redhat.com/show_bug.cgi?id=1010059)
*   [BZ1010079 - Virtual NUMA nodes inside larger guests](https://bugzilla.redhat.com/show_bug.cgi?id=1010079)

### Comments and Discussion

<Category:Feature> <Category:SLA>

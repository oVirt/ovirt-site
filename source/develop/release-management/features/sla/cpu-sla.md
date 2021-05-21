---
title: CPU SLA
category: feature
authors:
  - adahms
  - kianku
  - roy
---

# CPU SLA

**CPU SLA**

## Summary

The CPU SLA feature enables users to limit the CPU usage of a virtual machine.

## Owners

#### Initial design and implementation

*   Name: Kobi Ianko (kianku) <s>kobi@redhat.com</s>

#### Maintainers

*   Name: Roy Golan (rgolan) rgolan@redhat.com
*   Name: Martin Sivak (msivak) msivak@redhat.com

## Current status

*   Target Release: 3.5
*   Status: completed
*   Last updated: April 14, 2015

## Detailed Description

CPU is one of the important component which each guest has.

Currently RHEV doesn't support SLA features which limits guest's and qemu's cpu resource consumption. Therefore all guests working on the same host may be affected by other guests' cpu workload.

On the other hand, customers expect that virtualized systems work as stably as the systems on bare servers.

To provide same stability in virtualized environment, we need to limit cpu bandwidth of each guest and isolate each guest from others.

To accomplish this target a CPU Profile element will be introduced.
The CPU Profile will be selected by the end user from a predefined list in the Add VM popup window, and will be created in the Cluster level of the system.

Each cluster will contain its own list of CPU Profile that are available for the use of the VMs running in that Cluster.

Each CPU Profile will contain a Qos element.
The Qos element will be defined in the DataCenter level of the system, and will be constructed out of a single field that represent the CPU processing power that is permitted for this VM out of the total CPU Processing capacity.

For representing the CPU qos we have three different approaches:
1. using a percentage number - currently this is the preferred approach

This approach will be consistent over different hosts, when a VM migrate to host with different CPU capabilities.

2. using a fixed MHz number

This is the old school approach, it will be clear to the user what exact input he is giving, but on different host this input could act slightly different.

3. using bogomips

This is an unscientific measurement of CPU speed (http://en.wikipedia.org/wiki/BogoMips)

**The selected approach is the percentage (1).**

## GUI

The user will configure the CPU limitation at the VM popup, our goal is to create a new side-bar for SLA and to place Cpu Profile in it.
The following is a draft using the existing Resource Allocation side-bar, for getting the look and feel of using the CPU limits feature
![](/images/wiki/CpuLimit.png)

The administrator will allocate CPU profiles to be used in the Cluster at the Cluster main tab, using the CPU Profile sub tab.
![](/images/wiki/CpuLimitClusterSubTab.png)

## VDSM

**TODO - this section needs update**

In the VDSM we will be using the libvirt API of CPU tuning (http://libvirt.org/formatdomain.html#elementsCPUTuning), and MOM. The Qos entered by the user will be picked by the engine's "Sync MOM Policy", and forward to Libvirt dom xml meta-data section.
For using the metadata section we will define a URI that will serve as a namespace from vm tunable parameters ("vm/tune/1.0"). A MOM policy will convert Qos value into the libvirt period and quota parameters, and set the value to Libvirt using a MOM controller, ensuring that the CPU limits are enforced.

To do that we will use the following algorithm:

         1. pick a fixed number to be used as anchor [1000 - 1000000], we will use the minimum*100 (because we use percentage)   = 100000 = anchor.
         2. period = anchor / #NumOfCpuInHost
         3. quota = (anchor*(#userSelection/100)) / #numOfVcpusInVm

## DB

The VM_STATIC will introduce a new field of CPU_PROFILE, this field will be a FK to the new table of CPU_PROFILES. CPU_PROFILES table will contain the following fields:
id (PK)
name
qos_id (FK)
cluster_id (FK)

## Rest API

A new element of cpu_profile will be added to the API, and the VM element will extend to contain the new CPU profile property.

    <cpu_profile href="/ovirt-engine/api/cpuprofiles/dd806259-d121-4914-9b32-5998dd40b26f" id="dd806259-d121-4914-9b32-5998dd40b26f">
        <name>gold_profile</name>
        <link href="/ovirt-engine/api/cpuprofiles/dd806259-d121-4914-9b32-5998dd40b26f/permissions" rel="permissions"/>
        <cluster href="/ovirt-engine/api/clusters/3e9dacfa-65bf-4433-b584-07383c50aef6" id="3e9dacfa-65bf-4433-b584-07383c50aef6"/>
    </cpu_profile>

    <vm>
        ...
        ...
        <memory>1073741824</memory>
        <cpu>
            <topology sockets="1" cores="1"/>
            <architecture>X86_64</architecture>
        </cpu>
        <cpu_shares>0</cpu_shares>
        <cpu_limit>25</cpu_limit>
        <os type="other">
            <boot dev="hd"/>
        </os>
        ...
        ...
    </vm>

## Benefit to oVirt

When running a VM, the VM should run as an independent unit and should be affected by other VMs as little as possible.
This feature enable the user to limit the CPU resources of a specific VM, this will ensure that in cases were several VMs are running on the same host, one VM will not cause performance decline in another VMs.
Another good use for this feature is in cases a growth in the number of VMs is expected, the user can limit the CPU resource to a VM leaving enough CPU resources for the future VMs, this way users of the guests will not have an impact on performance once other VMs will join the host.



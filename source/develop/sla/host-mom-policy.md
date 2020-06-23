---
title: host-mom-policy
category: sla
authors: aglitke
---

# host-mom-policy

Maintaining SLA requires dynamic management of each virtualization host according to a policy. The exact policy depends on the goals set by the administrator and/or users. For example, a policy may try to aggressively pack as many VMs on hosts in order to maximize host resource utilization and minimize the number of hosts which must be powered on. In another policiy example, an administrator may wish to favor a certain class of golden VMs over other VMs in order to provide guaranteed performance for the golden class and best-effort service for the others.

## Flow overview

Dynamic SLA policy enforcement requires several components in order to have a complete implementation: A policy, a policy engine or manager, information to use for decision making, and tuning "knobs". The proposed solution in oVirt uses the Memory Overcommitment Manager (MOM) policy engine and policy language. MOM retrieves information via the vdsm API. The tuning knobs are also available to MOM as vdsm API calls.

![](/images/wiki/Mom-flow.png)

## About MOM

MOM continuously samples data from a set of configured *Collectors*. Examples of Collectors include: host memory statistics, VM memory statistics, and KSM. This data is combined and serves as input when evaluating the policy. The active policy can be changed at any time. At a configurable interval, MOM evaluates the policy using the latest set of collected data. The result is a set of actions to perform. Actions are performed by *Controllers*. Examples of Controllers include: KSM and VM Memory Ballooning. Collectors and Controllers interface with MOM using a consistent API so new ones can be added easily.

#### MOM hypervisor abstraction

MOM was originally written to work directly against the libvirt API. Although users still use MOM this way today, we wanted to also integrate with vdsm. On systems with vdsm installed, the libvirt connection is controlled by vdsm and is not intended to be accessed directly. In this scenario, we talk to vdsm via its API in order to collect data and perform actions. This dual mode situation is enabled by an abstraction in MOM called *HypervisorInterface*. The desired interface is selected in the MOM configuration file.

#### Deploying MOM in an oVirt environment

MOM is an independent package and should be installed as a dependency of vdsm. The currently available version of MOM in Fedora is too old to use with vdsm so the latest git version should be used for deployments for now. MOM uses Python distutils and can be installed easily. The way vdsm makes use of MOM is by spawning a new thread in vdsmd, loading the mom python module in that thread, and calling mom.run(). The vdsm package supplies an appropriate MOM config file and the default mom policy to use when vdsm starts. From that point forward, MOM and vdsm interact with eachother only through public APIs. Think of MOM as a very attentive and persistent user of the vdsm API.

## About policies

MOM was originally designed to control KSM and memory ballooning for VMs. The default policy that comes with MOM controls these two mechanisms. For KSM, the goal is to run KSM only when necessary and when it can yield a memory saving benefit that outweighs its CPU cost. The algorithm used is nearly the same as that used by ksmtuned.

MOM uses memory ballooning to aleviate host memory pressure which, if left unchecked, can severely degrade the performance of all virtual machines. When the host reaches a certain threshold of memory utilization, MOM begins to inflate VM memory balloons. VMs that have more free memory are asked to return more to the host but care is taken not to introduce memory pressure in the VMs. If host memory pressure reaches a critical level, then ballooning is done more aggressively in order to trigger swapping inside the VMs. Past research has shown that swapping within the virtualized operating systems has a less severe and shorter term impact on performance than does host swapping.

#### Customizing the policy

In oVirt, we want to increase the sophistication of the MOM policy to govern more VM resources such as CPU, I/O and network bandwidth, and NUMA balancing. We have a goal to enable overcommitment and service level guarantees. Implementing these features will require significant investment in the definition of new MOM policies to implement the desired logic. Several high level ideas have already been discussed but more work needs to be done in order to identify the specific use cases that we want to enable. Examples for policies include:

*   Tagging VMs and treating those VMs differently in the policy based on the tags
    -   Platinum VMs are always guaranteed full allocation of their resources
    -   Gold VMs are guaranteed 75% of their full allocation
    -   Vapor VMs can be powered off based on resource availability
    -   Compute VMs require all of their CPU but memory can be reclaimed aggressively
    -   etc
*   Assigining priorities to VMs
*   Migrating VMs to other hosts in the cluster

Just about anything is possible with the MOM policies (with a modest amount of MOM development required). The hard part is actually defining what we want.


---
title: Dedicated CPU Policies
category: feature
authors: tgolembi
---

# Dedicated CPU Policies

## Summary

This feature introduces policies for dynamically dedicating physical CPUs to
the VM. While this can be (to some extent) done with static CPU pinning, the
CPU pinning requires that the VM is pinned also to a particular host(s). It
also ideally requires that no other VMs without pinning are running on the host
to avoid sharing the pinned CPUs. Instead, this new feature allows the user to
configure only the way how its physical CPUs should be assigned to the VM and oVirt
will take care of dynamically allocating suitable physical CPUs as well as
forbidding other VMs from running on dedicated CPUs.


## Owner

* Name: Tomáš Golembiovský
* Email: tgolembi@redhat.com

## Glossary

  * [*CPU pinning*](/develop/sla/cpu-pinning.html):
    Feature in oVirt that allows you to statically pin vCPUs to pCPUs by
    defining a pinning string in VM configuration (e.g. `0#1_1#2-3`).
  * [*NUMA auto pinning policy*](https://bugzilla.redhat.com/show_bug.cgi?id=1688186):
    Feature in oVirt that defines pinning policies (*Pin* and *Resize and
    Pin*) that allow CPU pinning to automatically adapt to the topology of
    pinned host. Just like CPU pinning, this is performed once during VM
    configuration.
  * *pCPU*: Physical CPU of a host.
  * *vCPU*: Virtual CPU of a VM.
  * *CPU list*: A string describing list of CPUs. It is a comma-separated list
    of CPUs or CPU ranges. The range of CPUs has to be specified in
    non-decreasing order. Example of such string is: `1,3-5,7`


## Description

CPU pinning and NUMA auto pinning policies don't take into account current
utilization of a host. Instead, it is a responsibility of the administrator to
make sure that VMs running on a host are not pinned to same pCPUs and ideally
also to make sure that no VMs without CPU pinning are running on the host. This
makes the pinning process rather difficult and inflexible.

To be able to have more flexibility in configuring how vCPUs of VMs use pCPUs
this feature introduces several policies for automatic dedicating of CPUs.
This feature can be used instead of the manual CPU pinning methods (not in
addition). Compared to CPU pinning the advantages are that:

  * VM does not need to be pinned to a specific host(s),
  * takes into consideration existing VMs which solves one of the issues with
    *Pin* NUMA auto pinning policy where several VMs can end up to be pinned
    to same CPUs,
  * it makes sure that VMs without any dedicated CPUs don't share CPUs with
    VMs that have dedicated CPUs

The policies described below divide the set of available pCPUs into
three sub-sets. There are the dedicated CPUs where each of those can be
assigned only to a single VM. Then there are some restricted CPUs (threads)
that cannot be used by any
other VM because of requirements on the threads of the core. And
finally there is the set of CPUs that are not strictly assigned to any
particular VM and are shared between all the VMs with *shared* policy. This
subset is hereby referred to as *shared pool*. Host CPUs that play a special
role, e.g. CPU that VDSM is pinned to or CPUs reserved to host on SAP HANA
systems are considered to be also part of the *shared pool*.

The available CPU policies are:

  * *shared*: *(default)* The guest vCPUs will be allowed to roam among all
    pCPUs from shared pool.
  * *dedicated*: The guest vCPUs will be strictly pinned to a set of host pCPUs
    (similarly to static CPU pinning). The set of pCPUs will be chosen to match
    the required guest CPU topology. If the host has SMT architecture, thread
    siblings are preferred.
  * *isolate-threads*: If the host does not have SMT architecture this is same
    as *dedicated* policy. If the host has SMT architecture each vCPU is placed
    on a different physical core and all thread siblings are excluded from use
    by this and any other VM (rendering all but one thread from a core unusable).
  * *siblings*: The host must have an SMT architecture. Each vCPU is
    allocated on thread siblings and threads from single core can only be
    assigned to this VM. If some threads remain unused these will be excluded
    from use by any other VM.


## Prerequisites

There are no special prerequisites for this feature.


## Security

This feature is primarily designed for performance tuning and is not meant to
be a security feature. It is possible for other VMs to share the dedicated CPUs
for a short period of time when the VM is brought up (boot, after migration,
restore from snapshots, etc.). This is not so much problem during boot because
by the time OS is started the CPUs should be already evicted, but it could
potentially provide a window of opportunity (for exploiting CPU
vulnerabilities) after finished migration or when restoring VM from snapshot.


## Limitations

See the *Security* section.

Currently, when a CPU is already dedicated to some VM, VDSM will not move the
VM onto another CPU to make it free to another VM. This may be addressed in
the future (see *Future Work* section), but for now this means:

  * It may be impossible to start VMs with CPU pinning on that host because
    the requested CPUs are already occupied. It is suggested to start VMs with
    CPU pinning before any VMs with dedicated CPU policy.

  * It may be impossible to start a VM with dedicated CPUs even though there
    seems to be enough space in terms of number of used vs. free CPUs.


## Changes to Engine and Vdsm

The high level overview of the workflow in Engine and Vdsm is following:

1.  When refreshing host capabilities Engine picks the information about which
    CPU is dedicated to VDSM process. It will also read a detailed information
    about CPU topology on the host.

2.  On VM start/migration/etc. Engine consults the policy for dedicating CPUs
    and schedules the VM on host with enough free CPUs. Engine determines the
    mapping between physical and virtual CPUs.

3.  Engine produces domain XML that contains properly populated `<vcpupin>`
    element (similarly to CPU pinning) and stores the policy name in VM
    metadata.

4.  Vdsm starts the VM and analyzes which CPUs were dedicated. Vdsm updates the
    pool of shared CPUs and re-configures VMs without any CPU pinning or
    dedicated CPUs to run on the new set of CPUs from shared pool.

5.  When the VM with CPU pinning or dedicated CPUs is being destroyed, Vdsm
    updates the pool of shared CPUs. Vdsm then re-configures VMs without any
    CPU pinning or dedicated CPUs to run on the new set of CPUs from shared
    pool. Because we allow overprovisioning CPUs this needs to be done
    immediately to better utilize the CPUs among VMs.

Several changes to the internal API are required. To accomplish step 1. the
verb `Host.getCapabilities` will be extended to provide keys:

  * `vdsmToCpuAffinity`: list of one or more CPU IDs to which VDSM process is
    pinned to
  * `cpuTopology`: detailed description of CPU topology in a form of a list
    where each object contains:

    * `cpu_id`: ID of the physical CPU
    * `numa_cell_id`: to which NUMA node the CPU belongs
    * `socket_id`: on which socket the CPU resides
    * `die_id`: on which die of the socket this CPU resides; usually there is
      only one die in the socket so in most cases this will be `0`.
    * `core_id`: on which core of the die this CPU resides

There are also changes to VM metadata. One is that Engine will add a new entry
called `cpuPolicy` that will contain the requested CPU policy. The valid values
for `cpuPolicy` are:

  * `none`: no pinning or policy selected, this is regular VM with shared CPUs
  * `manual`: VM has fixed CPU pinning (CPU pinning or NUMA auto pinning)
  * `dedicated`: VM uses the `dedicated` policy
  * `isolate-threads`: VM uses the `isolate-threads` policy
  * `siblings`: VM uses the `siblings` policy

Another new metadata entry is `manuallyPinedCPUs`. This is populated by VDSM
(unless Engine does it first) for VMs with `manual` policy and it contains CPU
list of CPUs that are covered by the pinning string. This lets VDSM know which
CPUs have defined pinning and which do not. It is important during recovery
when it cannot be ascertained in any other way. Note that CPUs that are not
pinned manually will use CPUs from shared pool.

Migration parameters in `VM.migrate` API call will contain a field `cpusets`
with the CPU mapping for the VM on the destination host. Because the libvirt
domain on destination is created by VDSM on source it needs to know which CPUs
are dedicated to the VM on destination so that it can provide a correct domain
XML to the destination host. The value of `cpusets` is a list of CPU lists
where each item of the list describes pinning for the vCPU at that index. For
example `['1','3','5']` means that vCPU
`1` should be pinned to pCPU `1`, vCPU `2` should be pinned to pCPU `3` and
vCPU `3` should be pinned to pCPU `5`. While the field itself is technically
optional it is required for VMs with policy other than `shared` or `manual`. When
specified, length of the list must match number of virtual CPUs.

API call `VM.setNumberOfCpus` will be extended with an optional field
`cpusets`. It is a list of CPU lists where each item of the list describes
pinning for the vCPU at that index. The rules of its use are same as for
`VM.migrate` call. When checking list length it must match the new number of
CPUs (i.e. must match `numberOfCpus` field).


## Testing

*TODO*

There are many parts that need to be tested

feature testing:
- create and especially migration
- `isolate-threads` is respected
- `siblings` excludes unused threads

backward compatibility:
- cpu pinning
- migration


## Future Work

Use of VMs with dedicated CPU policies may in time lead to fragmentation of
cores and threads on the hosts. Leading not only to inefficient use,
difficulties with scheduling but ultimately could prevent new VMs from
starting on a host. As an example consider a situation where your VM needs to
use a single socket, but all the sockets are already occupied by smaller VMs.
So even though there may be enough free cores/threads in total on the host,
you won't be able to start the VM without removing VMs from one of the sockets
firsts. Techniques for re-assigning CPUs for consolidating resources need to
be investigated. It may (or may not) turn out to be a prerequisite for useful
CPU hot-plugging too.

At the moment we generally do not pin the emulator thread (`emulatorpin`) nor
do we pin IO threads (`iothreadpin`) of the VMs. The only exception is high
performance VMs where these threads are pinned to first core of the socket on
which the VM runs. This however may change in the future in respect to another
feature,
[parallel migration connections](/develop/release-management/features/virt/parallel-migration-connections.html).
In all cases Engine has to take care that CPUs used for emulator threads or IO
threads are not dedicated to a VM. Such CPUs have to remain in shared pool.

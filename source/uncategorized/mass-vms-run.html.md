---
title: Mass VMs Run
authors: arik
wiki_title: Mass VMs Run
wiki_revision_count: 9
wiki_last_updated: 2013-11-25
---

# Mass VMs Run

### Summary

This page summarizes an effort which is made to improve the scalability of the process of running VMs.

We might need to start high number of VMs in about the same time in the following scenarios:

1. Host that ran high numbers of HA VMs went down, so all those HA VMs should be auto started.

2. The user asked to run high number of VMs, either by the UI or by scripts.

In case the environment contains few hosts, or in the extreme case one host which is capable to run all those VMs, the slowness of running high number of VMs in parallel is more noticable. As such kind of environments become more and more common, this issue becomes more serious.

We know about multiple processes in the system which can be more efficient, both in the engine and in VDSM, and we believe that together they will make a significant improvement on the process of running high number of VMs in parallel. As It is not feasible to do all of them at once, we'll make them incrementally and monitor their effect.

### Owner

*   Name: [ Arik](User:Arik)
*   Email: <ahadas@redhat.com>

### Current status

*   Status: Design

### Stage 1

#### Change 1

Intoroducing central place in the engine, VmsRunner, which is responsible to run VMs. This place will be similar to AutoStartVmsRunner which is responsible to run HA VMs that went down [1].

The benefits of having VmRunner: 1. Run VM commands can be cached before sending them to VDSM. It will make it possible to send multiple requests for run VMs on the same host together as part of the same message to VDSM. 2. The history of the VMs that were run on each host recently can be saved in one place in the memory.

Caching the RunVmCommands and sending them in a bulk to vdsm is expected to reduce the time spent on waiting for the synchronized call to the create verb in vdsm to end. A diagram that demonstrates the current flow:

![](Old_engine_vdsm.png "Old_engine_vdsm.png")

As we can see, the engine call the 'create' verb, which in turn start vm creation thread in vdsm and only then the call ends and the engine continue to the next RunVmCommand that invokes the next 'create' verb. It should not be long time to end the synchronous call though (~2 sec in our tests), but when it comes to high number of calls it accumulated and thus noticable. Assuming the destination host is capable to run multiple VMs in parallel (it depends on its number of cores), we can reduce the overhead by combining the different calls to one call:

![](New_engine_vdsm.png "New_engine_vdsm.png")

how long we cache..

[1] we need to think whether VmRunner and AutoStartVmsRunner could be combined together or AutoStartVmsRunner will use VmRunner.

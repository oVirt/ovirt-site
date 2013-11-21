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

*   Name: [ Arik Hadas](User:Arik)
*   Email: <ahadas@redhat.com>

### Current status

*   Status: Design

### Stage 1

Intoroducing central place in the engine, VmsRunner, which is responsible to run VMs. The VmsRunner will be similar to AutoStartVmsRunner which is responsible to run HA VMs that went down [1]. All the requests to run VM (automatically by VdsUpdateRuntimeInfo, automatically by the job that run prestarted VMs, REST api, UI [2]) will be made with the VmsRunner job.

The benefits of having VmsRunner:

*   VMs that should be run can be aggregated and then scheduled in a bulk
*   Run VM commands can be cached before sending them to VDSM. It will make it possible to send multiple requests for run VMs on the same host together as part of the same message to VDSM.
*   The history of the VMs that were run on each host recently can be saved in one place in the memory.

Caching the RunVmCommands and sending them in a bulk to vdsm is expected to reduce the time spent on waiting for the synchronized call to the create verb in vdsm to end. A diagram that demonstrates the current flow:

![](Old_engine_vdsm.png "Old_engine_vdsm.png")

As we can see, the engine call the 'create' verb, which in turn start vm creation thread in vdsm and only then the call ends and the engine continue to the next RunVmCommand that invokes the next 'create' verb. It should not be long time to end the synchronous call though (~2 sec in our tests), but when it comes to high number of calls it accumulated and thus noticable. Assuming the destination host is capable to run multiple VMs in parallel (it depends on its number of cores), we can reduce the overhead by combining the different calls to one call:

![](New_engine_vdsm.png "New_engine_vdsm.png")

The expected benefits of such change are:

*   Reduce the time needed to set up connections between the engine and VDSM by reducing the number of connection establishments to one
*   Reduce the time needed to encode & decode the XMLs describing the VMs by encoding all the information at once
*   This design will make it possible to invoke the operation against each host in a different thread which should accelerate the process of running VMs on more than one host
*   This design is a step forward for being ready to call the scheduler for scheduling multiple VMs in a bulk

There's a trade-off when it comes to declare for how long should we aggregate the run VM request: on the one hand, setting it to too short period mean that we may end up with too many calls to host as we had before. On the other hand, setting it to long period would mean that the VMs could maybe be run faster by sending them separately.

Another issue to think of is the 'over-commiting' problem. When we'll try to run 2 VMs, we'll call the scheduler for each of them sequentially. On the scheduling process of the second VM we have to assume that the first VM is taking all the memory that it can theoretically have. It means that the scheduler might return that the second VM couldn't run because of the 'over-commiting' done for the first VM. Currently we try to avoid reaching this state by scheduling the VMs sequencially and update the memory of each VM to the actual memory it consumes as soon as possible. I'm suggesting another way to handle it: it is ok to fail because of 'over-committing', as long as can know the reason and try to run it again (in a similar way to how we retry to run HA VM in high frequency when we fail to run it because we could not acquire the required lock to run it).

### Stage 2

draft: thread per host draft: update hibernation volumes without VDS lock draft: don't execute all can do actions for HA that is being run immediatly after it went down

### Future changes

*   Change scheduler to schedule multiple VMs together instead of each one separately.
*   Improve the VM statistics mechanism to work in a bulk

[1] we need to think whether VmRunner and AutoStartVmsRunner could be combined together or AutoStartVmsRunner will use VmRunner. [2] we need to think about rerun

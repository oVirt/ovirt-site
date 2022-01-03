---
Title: Engine Dedicated CPUs
Category: feature
Authors: sabusale
---

# Engine Dedicated CPUs

## Summary

Once choosing dedicated CPU policy, The vCPUs will be strictly pinned to a set of host pCPUs
(similarly to static CPU pinning). The set of pCPUs will be chosen to match the required guest CPU topology.

Engine sets the pinning automatically when starting the VM as opposed to the manual pinning that is
done by the user and is static.

## Owner

-   Name: Saif Abu Saleh (sabusale)
-   Email: sabusale@redhat.com

## Responsibilities

VDSM:

- Makes sure that dedicated VMs vCPUs stay exclusively pinned to the given pCPU

Engine:
- Holds cached available cpus based on host capabilities and pinned CPUs
- Schedule VM to run on best satisfying host based on the above cached data structure



## Backend

1. Add the new policies to CPU Pinning Policy enum
2. Save host capabilities CPU topology in vds_dynamic
3. Hold hostToAvailableCpu data structure:
    it will be on this form `Map<Integer,Map<Integer,Map<Integer,List<String>>>>`
   
    Host id -> Map of Socket id to Map of Core id to list of cpus
    (assuming host id, core id, socket id is unique)

    **Save/Update cached data structure:**    

    * On updateVDSStatisticsData update the data structure with host capabilities
    * On every start/stop/migrate/… VM update the shared CPU pinning data structure
    with used pinning
    * In case manual pinned cpus exist, they should be subtracted from hostToAvailableCpu 

   **Init cached data structure (on engine start/stop):**

    * Will be calculated after engine started after getting host caps and VMs cpu pinnings
    

4. Scheduling
    1. Start VM:
        - Scheduling phase
            - Reads hostToAvailableCpu from step 3
            - Filter hosts that can't match virtual CPU topology
            - Hosts that doesn't match this two rules will be filtered:
              - vcores that are part of the same vsocket should be on the same psocket
              - vthreads that are part of the same vcore should be on the same pcore
            - If no host left after the filtering phase throw validation error that cpu pinning can't be done 
            - Score all hosts to find best matching host with enough pCPUs (two vCpus in different vCores can be
              scheduled on same pCore)
              - Host with less amount of sockets and cores left which
                at least match the virtual topology will get higher score, since its better to use it
        - Run phase
            - Based on Step 3 -Save/Update cached data structure
            - Update VM CurrentCpuPinning DB field with the mapping

    2. Stop/Destroy VM:
        - Clear VM dynamic CPU pinning field
        - Based on Step 3 -Save/Update cached data structure
    
3. Send vcpupin with cpusets and policy name in VM metadata
   1. Send the policy name, available policy names: { none, pin, dedicated, siblings, isolate-threads }.
   2. Send the cpusets (it will be stored in VM_Dynamic)

4. Migrate VDSM call
   1. Calculate vCPU to pCPU mapping based on the scheduled host
   2. Send cpusets additional parameter
   
5. setNumberOfCpus VDSM call
   1. Send cpusets additional parameter


## Database

* Save CPU mappings in field CurrentCpuPinning field in vm_dynamic table
* Save CPU topology from host capabilities into vds_dynamic
* Save new pinning policies to DB using the existing CpuPinningPolicy field

## Rest API

1. Add new types of CPU pinning to api-model
2. Update mapper with the new policies

## Frontend

- The added CPU pinning policy fields should be disabled on cluster level version < 4.7


### Example
2 hosts are running and reporting the following available CPU topology


Host A: 1 Socket, 2 Cores 2 CPUs

Host B: 2 Sockets, 1 Core on each socket, one CPU in each core




VM A with dedicated cpu pinning is already running on host A and have 2 vCPUs

User wants to start VM B that requires 2 vCPUs and has dedicated cpu policy

- hostToAvailableCpu will be is:
  
  {host A id} -> { {socket 1 id} -> {core 1 id} -> {1,2}}
  
  {host B id} -> { {socket 1 id} -> {core 1 id } -> {1}, {socket 2 id} -> {core 2 id} -> {2}}
- Scheduler checks all hosts that have enough physical CPUs available based on hostToAvailableCpu. In our case, both
  hosts have enough pCPUs, however, host A has both available on one socket whereas host B would need to divide them on 
  2 different sockets. So B get filtered
- Host A is selected to run the VM
- Engine creates the mapping between CPUs as: 1#1_2#2 and saves it to currentCpuPinning in vm_dynamic table for VM B entry
- Engine sends the domain XML to VDSM with the required mapping
- hostToAvailableCpu get updated based on Backend#step3
- Host(VDSM) A runs the VM with pinned CPUs

## Limitations
- Should only be supported with 4.7 cluster level



### Isolate threads/Siblings

Since we already know the available host capabilities and the available CPUs

in case a VM is set with Isolate threads or sibilings, we can remove the whole core from the available cpu data structure

Example:

Host A with 1 Socket, 2 Cores in socket, 2 CPUs in each core

Having 2 CPUs in a core indicates of a host with 2 threads topology

hostToAvailableCpu data structure:

{Host A id} -> {socket id} -> {core 1 id} -> {1,2}

{Host A id} -> {socket id} -> {core 2 id} -> {3,4}

Lets assume we have 1 VM with 2 vCPUs with isolate threads policy

The VM will use CPU IDs 1 and 3, and CPU IDs 2 and 4 will be blocked

hostToAvailableCpu data structure after this change will be empty, since there is no available shared CPUs

current CPU pinning for the VM will be 1#1 2#3

once the VM got stopped, we will need to restore core 1 and 2 CPU's (which we will find from the host topology)
meaning, restoring also CPUs 2 and 4 to hostToAvailableCpu.

### TBD

- If VM CPU pinning policy is isolate threads or sibilings, and we have two hosts, one with SMT enabled and the other
  without SMT, do we need to count the host without SMT for scheduling(considering it same as dedicated)
  or instead to remove it?
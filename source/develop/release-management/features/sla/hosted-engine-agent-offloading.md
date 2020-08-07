---
title: Hosted Engine Agent Offloading
category: feature
authors: dchaplyg
feature_name: 'Hosted Engine: Move all the hardwork from agent to the broker'
feature_status: Done
---

# Hosted Engine: Move all the hard work from the agent to the broker

## Summary

Initially, when hosted engine tools were designed, they were intentionally split between the agent and the broker. It was planned for the agent to be a lightweight application responsible for cluster management decisions while the broker was intended to handle all of the hard work of storage operations, monitoring, locking, etc.
However, during hosted engine development, the agent was burdened with additional load, like OVF extraction, storage preparation, and other activities. 

The goal of this feature is to make the agent lightweight again by moving all non-management code to the broker.. This will result in a more maintanable code and more reliable hosted engine behavior..
## Owner

*   Name: [Denis Chaplygin](https://github.com/akashihi)

## Current status

*   Target Release: 4.2
*   Status: Done
*   Last updated: December 11, 2017

## Detailed Description

The specific goals associated with this feature are as follows:

*   Move storage mounting/unmounting from the agent to the broker.
*   The broker should start/stop the domain monitor on the agent's command. The domain monitor could be implemented as a submonitor.
    
    Domain monitoring needs to be changed drastically. When the storage validation approach was changed (See [Documentation/External references](#documentation--external-references)), active domain monitoring became vital for domain validation. If domain monitoring has not been started, the domain will be reported as invalid, regardless of its actual state.
    Therefore, the old approach where domain monitoring was only active outside of local maintenance mode is no longer applicable. I propose the following change: domain monitoring should still be disabled in local maintenance mode. While domain monitoring is disabled, actual domain validation will be skipped and the domain will be reported as valid. The broker will still try to update the status and read statuses of the other cluster participants, even in maintenance mode, so it will have a chance to block on broken storage. Thus, all I/O should be moved to a separate thread, to prevent the broker from blocking on I/O issues.
*   Move sanlock acquire/release activities from the agent to the broker.
*   As the steps above introduce a possible new 'half-configured' state, FSM should be extended with that state.
*   The agent should only post state to the broker, and the broker must publish it on storage, if possible.

    The broker will keep the current status in memory and reply to the agent, hosted-engine-setup, and VDSM using that in-memory state. The agent will call broker's RPC to update that state. Upon an in-memory state update, a separate disk-writing thread will be notified.. That separate disk-writing thread will be started during the broker start-up sequence and its only purpose is to write the state to the storage and block in case of storage failures, while letting other broker code run. I plan to use deque with a size of one to pass the current state to the disk-writing thread and use Conditions to synchronize threads.
*   ~~OVF extraction should be moved from the agent to the broker.
	At the moment, OVF are extracted on every short monitoring loop run by calling `_initialize_storage_images`, which calls `refresh_vm_conf`, which actually updates `vm.conf` from the OVF. I plan to move the refresh_vm_conf function to the submonitor and specify the vm.conf update period as a submonitor parameter, so the agent will be able to control it. The submonitor will update the `vm.conf` periodically and report the time elapsed since the last update, which can then be used in score calculations in the future.~~
    OVF extraction alongside with other shared configs extraction and caching will be implemented as additional feature. (See [Documentation/External references](#documentation--external-references))

## Benefit to oVirt

*   Less code - less bugs.
*   Clean separation of concerns makes code cleaner and easier to maintain.
*   Hosted engine state updates will happen faster and without delays, thus decreasing overall latency of the whole system. See [Documentation/External references](#documentation--external-references)

## Dependencies / Related Features

*   In order to implement this feature, hosted-engine must be stateless, as desribed at [Stateless broker feature](/develop/release-management/features/sla/stateless-broker.html)

## Documentation / External references

*   Bugzilla ticket: [BZ#1399766](https://bugzilla.redhat.com/1399766)
*   Bugzilla ticket: [BZ#1337914](https://bugzilla.redhat.com/1337914)
*   [Hosted engine shared configuration extraction and caching](/develop/release-management/features/sla/hosted-engine-ovf-extraction.html)


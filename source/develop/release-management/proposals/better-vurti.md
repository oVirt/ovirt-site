---
title: Better vurti
authors: roy
---

<!-- TODO: Content review -->

# Better vurti

## Motivation

*   We want to scale easily
*   Limited number of host and VMs
*   High performance costs with large deployment
*   Want to prepare for the 2-way messaging with hosts
*   write better loosely coupled code - more testable, maintainable, easy to add

## Problem statement

*   unparalleled code - code uses closed calls (syncing objects, using locks) - not parallel
*   thread waste - we keep a thread per host connection, pooled. Most of the threads in the system are busy doing VURTI
*   thread bound - large deployments needs more threads to cope with
*   latency in updates - large deployments cause each VURTI cycle to last longer - meaning we deal with state change later then expected.
*   many reads and writes - although been thorough an optimisation cycle, system relies heavily on db round-trips.
*   code around VM life-cycle and Host life-cycle is intestable, period. this means longer verification cycle, no unit testing of new,modified code etc.

## Approach

Lets break this conceptually first to 2 parts, the communication and the actual update cycle. Update cycle is the actual stop-the-world list of checks

and loops on data structures, which then we assume state change upon. Communication is everything from the http connection pool when the host is added

and the direct blocking calls we do to fetch aggregated data from our agents (also take actions on but less relevant for now)

current situation a high-level

                            *
                            | [exclusive lock]
                            * 
                            | ----------[if status is Up or going to Maintenance...]
                                               |
                                               | VDSM::GetVdsStats
                                               | ----------------------------[Failed]--------- Non Oper
                                               | [sucess]
                                               | DB::save VdsDynamic and Statistics
                            |
                            | ----------[other status, Unassigned]
                                               | refresh HW caps and cluster checks
                            |
                            | refresh VM stats
                                               | ------[time for stats]----
                                                                       |
                                                                       | VDSM::GetAllVmStats
                                               |[list only]
                                               | VDSM::GetVMsList
                                               |
                                               | compare list of db vms and running vms
                                                                        | migration ended?
                                                                        | vm is up?
                                                                        | vm is down?
                                                                        | memory checks
                                                                        | watchdog events,network checks etc...
                              | free exclusive lock
                                         
                                               
                                               
                                               

### poll to push - Reactive Programming

while not ready 2 way communication can lead us to get rid of polling. this would eliminate the need for a constant thread

per abstract in this layer adopting to simulate the poll to push by programming event driven style, using CDI events.

### Phase 1 - Abstract the communication layer

today the sequence of action is linear - we lock, poll data from vdsm, iterate, take actions, do state change, save all to db and free lock.

the communication layer is coupled inside, we don't have a way around it. to overcome this we introduce another level of indirection - the PushAdapter.

#### PushAdapter

Typically the PushAdapter will poll for data exactly as made today but instead of just iterating and doing the regular stuff it will throw events.

The adapter main role is to crunch the fetch data and dispatch events accordingaly, i.e

VMStateChanged is an example of an aggregating event the will be fired. multiple subscribers(a.k.a observers) can react to that (ordering of events is

### Phase 2 - Repository, Updater, Fetcher

The main idea is to separate completely the responsibility of each component. instead of 2 classes today which area responsible for all monitoring vds, do state transition, care for migration and other side handling + monitoring the VMs + doing their state transion, migration etc we'll divide the responsibility to components and sub components.

We need to manage 2 types, VDS and VM. Instead of managing a single VDS and its VMs, well manage (configurable) set of VDS. could be cluster scope or system scope or divided.

This would be the **Repository** - VdsRepository and VmRepository.

For each VdsRepository there would be a single VmRepository.

Every Repository has to manage the lifecycle of its objects as well the create/retrieve/update/delete actions. This is the responsibility of the **Updater** - VdsUpdater and VmUpdater

Each entity in the repository is fetched from an external resource and we must de-couple this details since we want to keep it flex and open for changes. This would be the responsibility of the **Fetcher** - VdsFetcher and VmFetcher

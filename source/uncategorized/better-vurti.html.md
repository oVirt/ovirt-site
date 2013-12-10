---
title: Better vurti
authors: roy
wiki_title: Better vurti
wiki_revision_count: 7
wiki_last_updated: 2014-04-02
---

# Better vurti

## Motivation

*   We want to scale easily
*   Limited num of host and cms
*   Hi Peromance costs with large deployment
*   Want to prepare for the 2-way messaging with hosts
*   write better loosly coupled code - more testable, maintanable, easy to add

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
                            | [exclusive lock]
                            * 
                            | ------------[if status is Up or going to Maintenance...]
                                                  |
                                                  | VDSM::GetVdsStats
                                                  | ----------------------------[Failed]--------- Non Oper
                                                  | [sucess]
                                                  | DB::save VdsDynamic and Statistics
                            |
                            | ------------[other status, Unassigned]
                                                  | refresh HW caps and cluster checks

                            |
                            | refresh VM stats
                                               | ------[time for stats]----
                                                                       |
                                                                       | VDSM::GetAllVmStats
                                               |[list only]
                                               | VDSM::GetVMsList
                                               |
                                               | compare list of db vms and running vms
                                                                                       | migration ended?
                                                                                       | vm is up?
                                                                                       | vm is down?
                                                                                       | memory checks
                                                                                       | watchdog events,network checks etc...

                            [
                             

while 2 way communication with hosts is still not ready, we can prepare fo it by eliminating the pool proccess

---
title: oVirtScheduler
category: feature
authors: danken, doron, gchaplik, lhornyak
wiki_category: Feature
wiki_title: Features/oVirtScheduler
wiki_revision_count: 11
wiki_last_updated: 2015-04-07
---

# oVirt Scheduler [WIP]

### Summary

As long oVirt is progressing and continue to gather features, there is an ever growing actual need for better scheduling: configurable, customized and flexible, both in the programmatic and functionality levels. It is known that the scheduling problem has NP-complete complexity, therefore there's a need to optimize the problem solution, to do that each scheduler implementation should focus on it's own subjective needs. To accomplish that we propose to have a scheduling API architecture, in which the clients can have their own private optimized schedulers. This page includes the high-level design for the new scheduling model.

### Owner

*   Name: [ Gilad Chaplik](User:gchaplik)
    -   Email: <gchaplik@redhat.com>
*   Name: [ Doron Fediuck](User:Doron)
    -   Email: <dfediuck@redhat.com>

### Current status

Status: design

Last updated: ,

### Benefit to oVirt

*   Allow others to integrate with oVirt's Scheduler.
*   Allow users to add their own scheduling logic.
*   Should allow other languages (Python), run as script/dynamically.
*   Load balancing policies can be overwritten.
*   Provides modularity and boundaries.

### Description

#### oVirt Scheduler concepts

*   Filter: a basic logic unit which filters out hypervisors who do not satisfy the hard constraints for placing a given VM.
*   Cost function: a function that gives a score to a given host based on its internal logic. This is a way to implement soft constraints in the scheduling process.

#### oVirt Scheduler implementation concepts

*   Supports filters for hard constraints and cost functions for soft constraints.
*   Load balancing policies related to filters and cost functions.
*   Existing logic (pin-to-host, memory limitations, etc) will be translated into filters.
*   Existing load balancing policies will be translated to the new format.
*   Additional policies, filters and cost functions may be added by users.
*   Supports Python (we may be able to allow others as well).

![](Hosts.png "Hosts.png")

### Functionality

#### Schedule

         Filter
         Cost Function

#### Balance

        Called periodically.
         Each cluster may use a single balancing logic at any given time.

### Design

### TBD

1.  External code.

### Detailed Design

[Features/oVirtSchedulerAPI](Features/oVirtSchedulerAPI)

<Category:Feature> <Category:SLA>

---
title: oVirt scheduler
authors: gchaplik, lhornyak
wiki_title: Features/oVirt scheduler
wiki_revision_count: 2
wiki_last_updated: 2013-07-30
---

# oVirt Scheduler - Separating Scheduling Logic [WIP]

### Summary

*   Extracting and separating current scheduling logic into a separate package/name-space.
*   First phase/step in the road to exposing public user-level API.

### Owner

*   Name: [ Gilad Chaplik](User:gchaplik)
*   Email: <gchaplik@redhat.com>

### Current status

*   oVirt-3.3
*   Last updated: ,

### Detailed Description

We want to introduce a new scheduler that will expose user-level API, to achieve that goal, there ought to be preliminary work. Current scheduling logic is embedded within Engine's Business Logic Layer (bll), without any scope, boundaries or centralized logic - scattered around 'bll' commands. In this phase we will clean-up, re-factor and extract scheduling related logic into a separate package, add unit tests and re-factor the code to be testable and decide on scheduler scope.

### Benefit to oVirt

Scheduling package is useful for numerous reasons:

1.  Easily identify flows and relations between Engine and Scheduler (private API).
2.  Eliminate duplicate code.
3.  Allow future separation of scheduling module to a different container.
4.  Concentrate Scheduling logic into a single package.
5.  Scaling out ; allowing multiple instances of scheduling module.

### Components

#### VDSM

none.

#### Engine

1.  Clean-up Run/MigrateVmCommand, these classes call and contains vdsSelector; VdsSelector.java is the logic that serve Run/MigrateVmCommand, and selects a host to run according to policy and other VM/Host parameters.
2.  Move Scheduling classes to Scheduling package (VdsSelector, LoadBalancer, Policies...)
3.  Clean-up VdsSelector class.

#### User Interface

none.

---
title: Serial Execution of Asynchronous Tasks
category: feature
authors: amureini, derez
wiki_category: Feature
wiki_title: Features/Serial Execution of Asynchronous Tasks
wiki_revision_count: 6
wiki_last_updated: 2014-07-13
feature_name: Serial Execution of Asynchronous Tasks
feature_modules: engine
feature_status: Released
---

# Serial Execution of Asynchronous Tasks

## Summary

Currently, oVirt Engine has an abilitty to run an asynchronous task on the SPM. When the task completes, AsyncTaskManager re-creates the command and calls its EndAction(), which is pivoted to EndSuccessfully() or EndWithFailure(), depending on the result of the SPM task. This feature aims to extend this behaviour to allow an engine command to fire a series of aysnchronous SPM tasks in order to allow complex flows (e.g., Live Storage Migration, proper error handling in Move Disk) to be implemented.

## Owner

*   Name: [ Allon Mureinik](User:amureini)
*   Email: amureini@redhat.com

## Current status

*   Design Review
*   Last updated date: 09/08/2012

## Detailed Description

## Benefit to oVirt

This deature will break the coupling where an engine command equals an SPM task. It will allow the engine to manage complicated asynchronous flows, possibly across several hosts.

## Dependencies / Related Features

oVirt Engine's support for Live Storage Migration depends on this feature.

## Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

## Comments and Discussion

*   Refer to [Talk:Features/Serial Execution of Asynchronous Task](Talk:Features/Serial Execution of Asynchronous Task)


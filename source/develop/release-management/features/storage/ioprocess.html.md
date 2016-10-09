---
title: ioprocess
category: feature
authors: derez, ykaplan
feature_name: ioprocess
feature_status: Released in oVirt 3.5
feature_modules: ioprocess, vdsm
wiki_title: Features/ioprocess
wiki_revision_count: 3
wiki_last_updated: 2014-04-03
---

# ioprocess

## Summary

Scale: Replace the use of a process pool with ioprocess written in C.

## Owner

*   Name: Yeela Kaplan
*   Email: <ykaplan@redhat.com>

## Current status

*   Target Release: 3.5
*   Status: work in progress

## Benefit to oVirt

The advantage of this implementation is that it's lightweight and scalable.

## Detailed Description

Currently we use a single process ('Remote File Handler') for each io request to remote storage (NFS). We want to replace the use of 'remote File Handler' with ioprocess. ioprocess is a C implementation providing a single process that can serve multiple io requests.

### VDSM

The change is planned to occur in two phases.

Phase 1: A single ioprocess will replace the existing process pool and storage side will be exposed to the same interface and configuration, only underlying implementation will change.

Phase 2 (future work): A single ioprocess will serve a single storage domain (TBD). out of process interface to storage will change and expose the actual ioprocess and its new file handling functions implementation.

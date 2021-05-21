---
title: ioprocess
category: feature
authors:
  - derez
  - ykaplan
---

# ioprocess

## Summary

Scale: Replace the use of a process pool with ioprocess written in C.

## Owner

*   Name: Yeela Kaplan
*   Email: <ykaplan@redhat.com>

## Current status

*   Target Release: 3.5
*   Status: Released in oVirt 3.5

## Benefit to oVirt

The advantage of this implementation is that it's lightweight and scalable.

## Detailed Description

Currently we use a single process ('Remote File Handler') for each I/O request to remote storage (NFS). We want to replace the use of 'Remote File Handler' with ioprocess. Ioprocess is a C implementation providing a single process that can serve multiple I/O requests.

### VDSM

The change is planned to occur in two phases.

Phase 1: A single ioprocess will replace the existing process pool and the storage side will be exposed to the same interface and configuration, only the underlying implementation will change.

Phase 2: A single ioprocess will serve a single storage domain. Out of process interface to storage will change and expose the actual ioprocess and its new file handling functions implementation.

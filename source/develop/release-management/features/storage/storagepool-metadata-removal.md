---
title: StoragePool Metadata Removal
category: feature
authors: amureini, fsimonce
---

# StoragePool Metadata Removal

## Summary

Until oVirt 3.5 the Storage Pool (Data Center) information was maintained in the engine database and stored in different ways in the Master Domain. In the larger scope of removing the SPM (Storage Pool Manager) and the Master Domain Role, the goal of this feature is to decommission the Storage Pool Metadata (and its dependency on the Master Domain).

## Owner

* Name: Federico Simoncelli
* Email: fsimonce@redhat.com

## Current status

* Released in oVirt 3.5

## Detailed Description

* `connectStoragePool` will receive a new argument enumerating the storage domains that are part of the pool and their status (`domainsMap`).
* `refreshStoragePool` is now useless (as there's no metadata on the storage anymore), on Data Center 3.5 `connectStoragePool` will be used also for refreshing.
* Since it's not possible to periodically refresh the Storage Domains map from the storage anymore it's now mandatory that all the hosts will receive these information with the `connectStoragePool` command (especially on the activation/deactivation of the domains). The engine will include a new logic to synchronize the hosts sending `connectStoragePool` when required (analyzing the `VdsStats`).
* The new Storage Domain statuses "Preparing For Maintenance", "Activating" and "Detaching" will be introduced in order to mark those domains that are in transition.
* full compatibility with the old `connectStoragePool`/`refreshStoragePool`/`reconstructMaster` will be maintained for Data Center 3.4 (and lower).

## Benefit to oVirt

* This feature will enable the SPM and Master Domain removal.
* Robustness as some complex flows will be dropped (`reconstructMaster`) and consistency (the metadata is kept in the engine database).

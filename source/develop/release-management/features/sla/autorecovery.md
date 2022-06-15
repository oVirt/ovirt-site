---
title: Autorecovery
category: feature
authors:
  - ekohl
  - lhornyak
  - ykaul
---

# Autorecovery

## Summary

This page describes the Autorecovery feature in ovirt engine.

## Owner

*   name: Laszlo Hornyak

## Current status

*   Last updated date: Wed July 20 2012

# Detailed description

## Behavior

*   Autorecovery feature allows the backend to recover some of the objects automatically after a temporary failure. Only automatic recovery of hosts and storage domains are supported.
*   The recovery logic does not check the reason why the object got into Not Operational/Inactive state
*   AuditLog is limited to be issued once every 3 hours for unsuccessful recovery.
*   Autorecovery can not be disabled

## Internals

*   The check happens in regular intervals (quartz scheduler)
*   Needs a DAO extension to fetch only those objects that are in failed state and have auto-recovery on
*   It calls the respective commands (ActivateHost, ActivateStorageDomain), and let the commands do what they do
*   Database is extended with autorecovery information, default is true - as discussed on engine-devel list. As of now, this property is always true for each autorecoverable entity and can not be changed through engine.
*   However, autorecovery can be enabled/disabled on the database level for each object of the above entity types and the engine tries to recover it periodically as long as the autorecovery is set to true, the engine does not give any GUI/API to do this.


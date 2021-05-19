---
title: StorageDomainLiveUpgrade
category: feature
authors: ekohl, smizrahi, vered
---

# Storage Domain Live Upgrade

## Summary

This feature will allow upgrades from old data center types to new ones even while the pool is active and VMs are running.

## Current Status

Released in oVirt 3.1

## Description

Some features are only available in certain data center levels because of backwards incompatible changes. Up until now you had to create a new data center to enjoy the new features. This feature will allow users to upgrade existing data centers to allow them to use new features.

## Dependencies

None.

## Related Features

## Affected Functionality

Data Center level change.

## User Experience

When the user changes the data center compatibility level an upgrade process will initiate in VDSM.

## Upgrade

No new scheme is required.

## How to use

To initiate a VDSM upgrade either use the `upgradeStoragePool` verb or put the new format in the `spmStart` verb.

## User work flows

User will be able to changes the data center compatibility level through the UI.

## Changes in ovirt engine

Initiate pool upgrade in VDSM when changing data center compatibility level.


---
title: Domain Scan
category: feature
authors: derez, djasa, dustin.schoenbrun
---

# Domain Scan

## Summary

Scans a Storage Domain in use by oVirt for disk images that it does not currently recognize.

## Owner

*   Name: Dustin Schoenbrun (Dustin.Schoenbrun)
*   Email: dustin.schoenbrun@netapp.com

<!-- -->

*   Name: Ricky Hopper (Rickyh)
*   Email: ricky.hopper@netapp.com

## Current status

In development. Hoping for inclusion in oVirt 3.2.

**Update 2013/09/10**: the domain scan code is included in oVirt since 3.2.

## Detailed Description

This feature provides a way of detecting disks that are not not recognized within oVirt. Some reasons why these disks would not be recognized by oVirt are that they were created at the storage level directly, they're orphaned disks that were not deleted completely, or are disks on a preexisting domain that has not been added to oVirt. This feature can be used to mount or remove these disks from storage.

## Benefit to oVirt

One major benefit would be to allow the oVirt Engine to import a preconfigured storage domain created independently of oVirt. This feature exposes this functionality but does not implement it (it will need to be a separate command that takes advantage of the capabilities described here). Another benefit of this feature is the ability to "scrub" a Storage Domain of partial snapshots left over for whatever reason to reclaim space. This feature will allow oVirt to become more robust in it's handling of storage.

## Dependencies / Related Features

Tentatively none.

## Documentation / External references

To be written.




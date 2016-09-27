---
title: SharedRawDisk
category: feature
authors: derez, mlipchuk, sandrobonazzola
wiki_category: Feature|SharedRawDisk
wiki_title: Features/SharedRawDisk
wiki_revision_count: 9
wiki_last_updated: 2015-01-16
feature_name: Shared Raw Disk
feature_modules: engine
feature_status: Released
---

# Shared Raw Disk

## Summary

The shared raw disk feature enables to share a disk through multiple VM's.

## Owner

*   Name: Maor Lipchuk
*   Email: mlipchuk@redhat.com

This should link to your home wiki page so we know who you are

## Current status

*   <http://www.ovirt.org/wiki/Features/DetailedSharedRawDisk>
*   Last updated date: Wed Dec 7 2011

## Detailed Description

Currently oVirt engine can assign a disk image to a single VM.
There are many use cases which requires concurrent access for disk, such as supporting clustered environment or support Databases with shared table-space
The feature should provide the user the ability to manage share disk for multiple VMs that can handle concurrent access to a shared disk without risk of corruption.

## Benefit to oVirt

The feature enables shared disk, which is highly relevant for integrating clustered external application with oVirt distribution. Databases with shared table-space will also be supported from now on.

## Dependencies / Related Features

Attaching shared disk will not consume new Quota resource. Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

Quota has to be taken in consideration, for every new feature that will involve consumption of resources managed by it.

## Documentation / External references



[SharedRawDisk](Category: Feature) [SharedRawDisk](Category:oVirt 3.1 Feature)

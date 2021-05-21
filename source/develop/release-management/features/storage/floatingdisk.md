---
title: FloatingDisk
category: feature
authors:
  - derez
  - ekohl
  - mlipchuk
---

# Floating Disk

## Summary

Floating disk - a disk that is not attached to any VM.
This feature covers the management and usage of disks in floating state.

## Owner

*   Feature owner: Daniel Erez (derez)

    * GUI Component owner: Daniel Erez (derez)

    * REST Component owner: Michael Pasternak (mpasternak)

    * Engine Component owner: Michael Kublin (mkublin)

    * QA Owner: Yaniv Kaul (ykaul)

*   Email: derez@redhat.com

## Current status

*   [Features/DetailedFloatingDisk](/develop/release-management/features/storage/detailedfloatingdisk.html)
*   Last updated date: Sun January 25 2011

## Detailed Description

The feature provides administration and management functionalities for floating disks. A floating disk should behave as a flexible independent entity that can be attached to any VM.
Any virtual disk can be in a floating state - by unattaching the disk from the VM/s.

## Benefit to oVirt

The feature introduces a significant improvement to oVirt compatibility and flexabilty regarding disks usage.
Supporting a floating state for disks is essential to derived features (e.g. 'Shared RAW Disk' and 'Direct LUN Disk')
and dependent implementations (e.g. application clustering, shared data warehouse).

## Dependencies / Related Features and Projects

Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

## Documentation / External references

*   [Features/DetailedFloatingDisk](/develop/release-management/features/storage/detailedfloatingdisk.html)


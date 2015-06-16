---
title: FloatingDisk
category: feature
authors: derez, ekohl, mlipchuk
wiki_category: Feature
wiki_title: Features/FloatingDisk
wiki_revision_count: 10
wiki_last_updated: 2014-07-13
feature_name: Floating Disk
feature_modules: engine
feature_status: Released
wiki_warnings: list-item?
---

# Floating Disk

### Summary

Floating disk - a disk that is not attached to any VM.
This feature covers the management and usage of disks in floating state.

### Owner

*   Feature owner: [ Daniel Erez](User:derez)

    * GUI Component owner: [ Daniel Erez](User:derez)

    * REST Component owner: [ Michael Pasternak](User:mpasternak)

    * Engine Component owner: [ Michael Kublin](User:mkublin)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: derez@redhat.com

### Current status

*   <http://www.ovirt.org/wiki/Features/DetailedFloatingDisk>
*   Last updated date: Sun January 25 2011

### Detailed Description

The feature provides administration and management functionalities for floating disks. A floating disk should behave as a flexible independent entity that can be attached to any VM.
Any virtual disk can be in a floating state - by unattaching the disk from the VM/s.

### Benefit to oVirt

The feature introduces a significant improvement to oVirt compatibility and flexabilty regarding disks usage.
Supporting a floating state for disks is essential to derived features (e.g. 'Shared RAW Disk' and 'Direct LUN Disk')
and dependent implementations (e.g. application clustering, shared data warehouse).

### Dependencies / Related Features and Projects

Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

### Documentation / External references

*   [Features/DetailedFloatingDisk](Features/DetailedFloatingDisk)

<Category:Feature>

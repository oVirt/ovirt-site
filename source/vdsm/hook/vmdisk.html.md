---
title: vmdisk
authors: dyasny
wiki_title: VDSM-Hooks/vmdisk
wiki_revision_count: 2
wiki_last_updated: 2012-09-14
---

# vmdisk

This hook can add an additional (unaccounted for by the engine) disk to the VM

Supports both raw and qcow2 images syntax:

         vmdisk=/path/to/disk.img:qcow2,/other/disk.img:raw

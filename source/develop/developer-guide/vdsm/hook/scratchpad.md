---
title: scratchpad
authors: dyasny, ykaul
---

# scratchpad

The scratchpad VDSM hook creates a disk for a VM onetime usage, the disk will be erased when the VM destroyed. The temporary disk is local on the hypervisor host, VMs cannot be migrated when using the scratchpad hook.

This is useful when some temporary space is required, or when a VM should have a volatile disk space for storing temporary data

syntax:

         scratchpad=size,path

Example:

         scratchpad=20G,/tmp/myimg

size: Optional suffixes "k" or "K" (kilobyte, 1024) "M" (megabyte, 1024k) and "G" (gigabyte, 1024M) and T (terabyte, 1024G) are supported. "b" is ignored (default)

Note: more than one disk can be added:

         scratchpad=20G,/tmp/disk1:1T,/tmp/disk2


---
title: virt-sparsify
authors: doron, shaharh
feature_name: Sparse VM disks
feature_modules: engine,vdsm
feature_status: Design
---

# Virt-Sparsify

## Summary

This feature will enable user to run [virt-sparsify](http://libguestfs.org/virt-sparsify.1.html) on a virtual machines disks. virt-sparsify will enable to trim disk size which grows by usage.

## Owner

*   Name: Shahar Havivi (Shaharh)
*   Email: <shavivi@redhat.com>

## Detailed Design

### vdsm

*   Currently vdsm support virt-sparsify in a simple form sparsing to a new disk which take more space and needs a temporary path.
*   We want to add the usage of in place sparsing ie no need for a temporary disk.
*   use --machine-readable for parsing the virt-sparsify output
*   parse output and report progress
*   ability to cancel task

### engine

*   Add a call for vdsm sparse method
*   Check that the VM is down
*   lock the disk

### UI

*   Add button for sparsing single/multiple VMs/disks
*   Adding an actual size of the disks (currently we display only the virtual size)
*   Add indication that disk need to be sparse if less then X% remains.

## Notes

A nice addition will be adding a scheduler that a user can determine at a certain time to check for disks that need to be sparse and automate the action

## Current status

*   vdsm: Design
*   engine: Design
*   UI: Design

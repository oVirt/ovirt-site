---
title: MultipleStorageDomains
category: feature
authors: derez, jumper45, sgordon
feature_name: Manage storage connections
feature_modules: engine
feature_status: Released
---

# Multiple Storage Domains

## Summary

Allow a VM to spread its disks across several storage domains within the same Data Center.

## Owner

*   Name: Jon Choate (Jumper45)
*   Email: <jchoate@redhat.com>

## Current status

Design Stage and RFC

## Detailed Description

The requirement is to give the ability to create VM disks on more than one storage domain as long as the storage domains exist within the VM's Data Center. The basic work-flow is:

The user creates the first disk, chooses the storage domain he wants The user creates the second disk, and has the ability to choose the storage domain he wants Question: Should the default be the storage domain of the first disk? What if there are many disks, on different storage domains? The user should be able to choose quota in each disk creation Make template workflow:

The user will be able to choose the storage domain for every disk in the VM, default to the storage domain the disk resides on The user should be able to choose a different quota for each disk, default to the original quota

Use template workflow:

When using the template to create a VM, every disk will be created on the storage domain it resides on in the template The user should be able to choose the quota for every disk

Move VM

This action will exist as before, moving all the disks in the VM to another SD

Move disks - there will be an option to move single/multiple disks to other one/more storage domains:

The user will mark the disks Choose move A table of these disks, and a list of storage domains for each, will be opened, and the user will change the storage domain The user should be able to choose quota for each disk as well (as changing the storage domain might require a quota change)

Move template disks - there will be an option to move single/multiple disks of a template to other one/more storage domains Export VM workflow:

The user will export a VM just as before When importing the VM we have two scenarios: The VM is not from template - he will be able to choose the destination of each virtual disk The VM is from template - the disks need to reside on the template disks domains (unless collapse is used)

## Benefit to oVirt

VMs that contain several virtual disks might need to allocate these disks on different storage domains.

For example, let's assume you have a production VM that hosts a database. The database has data files, log files and archive files. For performance reasons we wish to put each of the above on separate LUNs that exist on our storage infrastructure.

Another example, let's assume you have a VM with 3 disks, and you would like to move the disks to another storage domain. So, in order to do it (without special support from RHEV-M), you would need to create a disk on another SD, move the data, and switch between the disks.

Today VMs are not allowed to have disks that belong to different storage domains. Once you create the first VM disk on one storage domain, all the other disks of that VM will be a part of the same storage domain.

## Dependencies / Related Features

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   REST API


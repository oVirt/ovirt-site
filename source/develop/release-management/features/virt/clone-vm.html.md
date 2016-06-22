---
title: Clone VM
category: feature
authors: tjelinek
wiki_category: Feature
wiki_title: Features/Clone VM
wiki_revision_count: 8
wiki_last_updated: 2015-10-08
---

# Clone VM

## Summary

Allow to simply and directly clone the VM.

## Owner

*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <TJelinek@redhat.com>

## Current status

*   Target Release: 3.6
*   Status: done

## Background

Up until now there were the following ways to create a copy of a VM:

*   Make a template, make a new VM from this template
*   Make a snapshot and clone the snapshot

It would be useful to provide a way to clone a VM directly.

## Implementation

All the logic is implemented in the CloneVmCommand class. Since it is very similar to cloning a VM from a snapshot, the common logic between the CloneVmCommand and AddVmFromSnapshotComman has been extracted to the common AddVmAndCloneImageCommand base class.

## Frontend

As shown in the following picture a new action button called "Clone VM" has been added to webadmin/userportal virtual machines tab:

![](CloneVmHeader.png "CloneVmHeader.png")

When clicked, a new window will be opened containing only the new name of the VM:

![](CloneVmWindow.png‎ "CloneVmWindow.png‎")

After clicking OK the clone of the VM will be made.

## REST API

A new action has been created on the VM called "clone". It takes only one parameter in the request body, the name. To clone a VM using the REST API send a POST request to:

<engineUrl>/api/vms/<vm id>/clone

with body containing:

<action> <vm> <name>newName</name> </vm> </action>

## Testing

## Test Case 1

*   Have a VM with no disks
*   Clone the VM
*   Verify the new VM has no disks
*   Verify all the parameters of the VM have been cloned

## Test Case 2

*   Have a VM with one disk
*   Clone the VM
*   Verify the new VM has one disk
*   Verify all the parameters of the VM have been cloned

## Test Case 3

*   Have a VM with two disks
*   Clone the VM
*   Verify the new VM has two disks
*   Verify all the parameters of the VM have been cloned

## Test Case 4

*   Have a VM with an attached shared disk
*   Clone the VM
*   Verify the new VM has the disk attached as well


---
title: CloneVmFromSnapshot
category: feature
authors: yair zaslavsky
wiki_category: Feature
wiki_title: Features/CloneVmFromSnapshot
wiki_revision_count: 30
wiki_last_updated: 2012-04-01
---

# Clone VM from snapshot

### Summary

This feature will let users of oVirt engine to create a VM based on a given snapshot

### Owner

*   Name: [ Yair Zaslavsky](User:Yair Zaslavsky)
*   Email: <yzaslavs@redhat.com>

### Current status

*   Last updated date: Wed Jan 18 2012

### Detailed Description

A user will be able to create snapshots for a given virtual machine, and then to select a given snapshot and peform a clone of the VM. The disks of the cloned VM will represent a "collapsed" state of the selected snapshot (i.e: If the user selected to clone from the N-th snapshot, the disks of the cloned VM will be created by copying images from the snapshot chain of the first snapshot till the Nth snapshot, and then collapsing them). The user will be be able to select different storage domains to hold the destination disks and to change their volume type and format. The user will also be able to provide VM information (such as VM name) which will be based on the VM information of the original VM.

### Benefit to oVirt

Today, the administrator is not capable of knowing which actions are running in the engine-core system, unless going over the events log or the engine server logs and searching for a specific command. Some of the actions in the engine-core are synchronous, hence the user receive an immediate feedback about the action. However when invoking durable actions, there is no trivial way to monitor the advance of those actions. The Task Manager could be extended to manage actions in the future (e.g. restart failed commands).

### Dependencies / Related Features

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   API

### Comments and Discussion

<Category:Feature>

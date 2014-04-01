---
title: LiveMerge
authors: aglitke
wiki_title: LiveMerge
wiki_revision_count: 20
wiki_last_updated: 2014-04-09
feature_name: Live Merge
feature_modules: engine,vdsm
feature_status: Development
---

# Live Merge

### Summary

Live merge makes it possible to delete VM disk snapshots that are no longer needed while the VM continues to run.

### Owners

*   Name: [ Adam Litke](User:AdamLitke) <alitke@redhat.com>
*   Name: [ Greg Padgett](User:GregPadgett) <gpadgett@redhat.com>

### Current status

Design and Development underway

Patches:

*   [LiveMerge: Add Image.getVolumeChain API](http://gerrit.ovirt.org/#/c/25918/)

<!-- -->

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

The user presentation of the live merge feature is simple. The only noticeable change is that the 'Remove' snapshot command will no longer be disabled when a VM is running. Behind the scenes the flow is quite complex. Live merge is an asynchronous operation and maintaining the consistency of management metadata and actual VM storage requires delicate handling of many different error scenarios.

The following is a detailed description of the flow and processes that will need to be in place on both the engine and on vdsm. See the flow diagram below for a graphical overview of the processes.

Live merge is initiated when a user clicks the 'Remove' command associated with a single disk snapshot. If the VM is down then the existing Merge Snapshot flow will be followed. If the VM is up then this new Live Merge Snapshot flow will be followed.

#### Flow Diagram

![](live-merge-flow.png "live-merge-flow.png")

#### Special considerations for ovirt-engine

*   Greg, please note any additional special considerations I may have missed.

#### Special considerations for vdsm

*   The effects of caching block job information in the stats thread ...
*   Combination of SPM and HSM operations for deleting a merged snapshot volume ...

### Benefit to oVirt

This feature hides the complexity of the Live Merge flows behind a simple clickable "Delete" button in the UI. This results in a symmetric create/delete snapshot operations regardless of whether the VM is running or not. This feature has been actively requested by users.

### Dependencies / Related Features

#### Libvirt

*   [live snapshot merge (commit) of the active layer](https://bugzilla.redhat.com/show_bug.cgi?id=1062142)

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

#### Positive flow (Create and remove a snapshot while a VM runs)

*   In webadmin, start a VM and create a new snapshot
*   Navigate to the VM's disks and for each disk, select the snapshot that was created and click the Remove button
*   After a few seconds, the snapshots should be removed from the list

#### Negative flow (engine restart during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate ovirt-engine
*   Wait for the operation to complete by using 'vdsClient getVolumeChain' on the virt host and watching for the volume to disappear
*   Restart engine
*   In webadmin, confirm that the snapshot is removed
*   Check that the volume associated with the snapshot has been removed from storage

#### Negative flow (vdsm restart during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate vdsm
*   Wait for the host to go unresponsive in the webadmin
*   Restart vdsm and wait for the host to return to Up status
*   In webadmin, confirm that the snapshot is removed
*   Check that the volume associated with the snapshot has been removed from storage

#### Negative flow (VM crashes during live merge)

*   Start in webadmin with a running VM that has one or more snapshots
*   Remove a snapshot as in the positive flow but immediately terminate the VM
*   A live merge failure event should appear in the audit log and the snapshot should remain in the list

### Comments and Discussion

*   Refer to <Talk:LiveMerge>

<Category:Feature> <Category:Template>

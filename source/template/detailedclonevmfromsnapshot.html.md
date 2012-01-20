---
title: DetailedCloneVmFromSnapshot
category: template
authors: yair zaslavsky
wiki_category: Template
wiki_title: Features/DetailedCloneVmFromSnapshot
wiki_revision_count: 45
wiki_last_updated: 2012-03-27
---

# Detailed Clone Vm From Snapshot

## Clone VM from Snapshot

### Summary

The feature will allow oVirt users to clone VM from a snapshot of another VM.
A clone from snapshot will create disks at destination VM that are a collapsed copy of the images at snapshot chain (the start of the chain is the first snapshot, the end of the chain is a the selected snapshot)
 Main feature page can be found at: [Features/CloneVmFromSnapshot](Features/CloneVmFromSnapshot)

### Owner

*   Name: [ Yair Zaslavsky](User:Yair Zaslavsky)

<!-- -->

*   Email: <yzaslavs@redhat.com>

### Current status

*   Target Release: ...
*   Status: In progress
*   Last updated date: Jan 18th, 2012

### Detailed Description

Clone VM from Snapshot will give the ability to perform a clone of a VM , based on a snapshot of a given VM.
oVirt-engine core will copy and collapse the images in the snapshot chain (the chain begins with the 1st snapshot, and ends with the selected snapshot).
In order to provide information on the VM to be created for the UI, UI will execute a query that will retrieve the VM and its disks configuration given a snapshot ID.
The UI will use the retrieved configuration as default values for the user to be modified.

#### Entity Description

#### CRUD

#### User Experience

The UI will run a query called GetVmConfigurationBySnapshotID in order to get a VM configuration for a given snapshot. The UI should present a window holding the configuration data. The configuration data will be used as defaults for the user, and the user may alter the data. The UI should present the disks list. The UI should allow to select different storage domains to hold the disks created upon clone, and to select different disks types and format.

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

Example of flow (assuming a VM was created with two disks):
![](Clone flow 1.jpg "fig:Clone flow 1.jpg")
The next figure shows a snapshot was made, having now two images serving as the active images:
![](Clone flow 2.jpg "fig:Clone flow 2.jpg")
In a similar way, more snapshots are created (Snaphost2 will be the one used for performing the clone):
![](Clone flow 3.jpg "fig:Clone flow 3.jpg")

The Clone from snapshot will be performed the following way:
 .1. A user selects snapshot2 and selects a "clone from snapshot" operation from UI.
.2. oVirt-engine core queries for VM configuration, providing the VM configuration as default values for the user to use in order to provide the new VM information.
.3. The user will override the default data values (the user will have to provide a new name. UI will suggest a new name in a format of "copy_of_OLD_NAME")
.4. The user will initiate the beginning of the clone operation.
.5. New VM entity based on the passed data will be created. Some VM related data will be cloned from the original VM (i.e NICs)
.6. Copy & collapse all images at snaphsot2 and their ancestors will be carried out by oVirt-engine
.7. Association the copies of the disks with the VM clone will be created
 This can be seen in the next figure:
![](Clone flow 4.jpg "fig:Clone flow 4.jpg")

#### Events

1. In case a snapshot is performed , and one of the disks is erased from the original VM, cloning from the snapshot should report that the disk is missing using the audit log.

### Dependencies / Related Features and Projects

The feature depends on the following projects:
1. oVirt web-admin - to supply the UI parts for this feature
2. oVirt API - to supply REST modeling
The feature depends on the following features:
1. Stable device addresses - on introduction of VM devices, which will have to be a part of the clone
2. Multiple storage domains - on introduction of multiple storage domains
3. Live snapshots - on introducing of snapshot entity and the association of snapshot and VM configuration (needed for querying VM configuration by snapshot)
4. Direct LUN -on introduction of LUN-based disks (maybe this can postponed for later phase).
5. Hot plug/unplug - this feature may depend on hot plug/unplug - see open issues section
 Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

1. Behavior of clone of Direct-Luns based disks and of shared disks -
Automatically attaching these disks may yield to data corruption, if both source VM and destination VM are up.
If we ignore cloning these disks, the cloned VM will not have these disks.
A suggestion was raised to mark these disks as unplugged at cloned VM, allowing the administrator to decide whether to plug it or not.

<Category:Template> <Category:Feature>

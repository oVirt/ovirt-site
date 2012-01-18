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
 flow1.jpg The next figure shows a snapshot was made, having now two images serving as the active images:
 flow2.jpg In a similar way, more snapshots are created (Snaphost2 will be the one used for performing the clone):
flow3.jpg

The Clone from snapshot will performed:
 .1. A user selects snapshot2 and selects a "clone from snapshot" operation from UI.
.2. oVirt-engine core queries for VM configuration, providing the VM configuration as default values for the user to use in order to provide the new VM information.
.3. The user will override the default data values (the user will have to provide a new name. UI will suggest a new name in a format of "copy_of_OLD_NAME")
.4. The user will initiate the beginning of the clone operation. .5. New VM entity based on the passed data will be created. Some VM related data will be cloned from the original VM (i.e NICs) .6. Copy & collapse all images at snaphsot2 and their ancestors will be carried out by oVirt-engine
.7. Association the copies of the disks with the VM clone will be created
 This can be seen in the next figure:
flow4.jpg

#### Events

What events should be reported when using this feature.

### Dependencies / Related Features and Projects

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.

<Category:Template> <Category:Feature>

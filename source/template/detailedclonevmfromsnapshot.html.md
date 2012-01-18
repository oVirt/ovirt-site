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
 Add a link to the main feature page as well: [CloneVmFromSnapshot](CloneVmFromSnapshot)

### Owner

*   Name: [ Yair Zaslavsky](User:Yair Zaslavsky)

<!-- -->

*   Email: <yzaslavs@redhat.com>

### Current status

*   Target Release: ...
*   Status: In progress
*   Last updated date: Jan 18th, 2012

### Detailed Description

Provide the details of the feature. What is it going to include. See the sub-sections below. This section may contain more sub-sections, depends on the oVirt projects relevant for this feature.

#### Entity Description

New entities and changes in existing entities.

#### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

#### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

Describe the high-level work-flows relevant to this feature.

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

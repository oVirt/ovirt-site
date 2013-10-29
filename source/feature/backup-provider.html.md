---
title: Backup Provider
category: feature
authors: vered
wiki_category: Feature
wiki_title: Features/Backup Provider
wiki_revision_count: 16
wiki_last_updated: 2013-11-10
---

# Backup Provider

### Summary

Add support of an ovirt system backup and restore using persisted ovf files.

### Owner

*   Name: [Vered Volansky](User:vvolansk)
*   Email: vered@redhat.com

### Current status

*   Design
*   Last updated: ,

### Detailed Description

The situation prior to this feature is the following:
There's code collecting data into an ovf in the Master Storage Domain (MSD from here on). That's it. No other code is implemented for reading it (restore).
This feature's intention is first to rearrange the code taking care of generating the ovf files as a Provider - Backup Provider.
This feature will also add other persisting methods other than MSD, enabling different types of the Backup Provider. The Settings for each Backup Provider will vary according to what the specific type requires.
Finally we will add the restore functionality, which is currently missing from the code altogether.

#### Phase 1

Extract the current code into a Backup Provider.
The backup will be on the system level, applied to all DC's in the system as default, with the option to do it for only one DC. The code extraction will result in one specific Provider of type MSD.

#### Phase 2

=

*   Persist the ovf to the following different locations (in addition to MSD):
*   Local FS

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature>

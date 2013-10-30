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

The situation prior to this feature addition is the following:
There's code collecting data into an ovf in the Master Storage Domain (MSD from here on). That's it. No other code is implemented for reading it (restore).
This feature's intention is first to rearrange the code taking care of generating the ovf files as a Provider - Backup Provider.
This feature will also add other persisting methods other than MSD, enabling different types of the Backup Provider. The Settings for each Backup Provider will vary according to what the specific type requires.
One system may be configured with several Backup Providers.
Finally we will add the restore functionality, which is currently missing from the code altogether.

#### Phase 1

Extract the current code into a Backup Provider.
The backup will be on the system level, applied to all DCs in the system as default, with the option apply for only one DC. The code extraction will result in one specific Backup Provider of type MSD.

#### Phase 2

*   Persist the ovf to the following different locations (in addition to MSD):
    -   Local FS - We may want to persist the ovfs to a DB. Other than the relative simplicity of using SQL rather than FS hierarchy for the ovf files, another motivation for this metod is the fact that we need to display all VMs to the user when restoring (The user may want to pick which VMs he wants to restore). For this, we need VM identities, specifically names. Since Guids aren't enough it might be simplest to use a DB to hold the some more data on the ovf.
    -   Swift (?)
    -   Debug (?) - We may want to create a Debug Provider for debug purposes only, not exposed to the end user.
    -   NoOp - No use of Backup will be supported. If Backup is indeed used, it should be chroned every x minutes. It may be easier to run it anyway, just as a default NoOp Backup Provider should no other provider is specifically configured. Still to be decided whether to chrone the job with NoOp or not chrone it at all if no Backup Provider is assigned to the system.
*   Restore the system. The user will be able to pick which VMs he wants to restore, and how many of each of them, resembling import. To be discussed - restore flow in case there are multiple Backup Providers configured for the system.
*   Attach existing Backup Provider. For example, should a user stop backup and then want to re-attach it. The user should also be able to add an existing Backup Provider (with data) to a new system. In this case the user should be prompted whether to pick up from latest backup or start from scratch.

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

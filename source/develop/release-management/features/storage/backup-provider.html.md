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

Add support of an oVirt system backup and restore using persisted ovf files.

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

*   Extract the current code into a Backup Provider.

The backup will be on the system level, applied to all DCs in the system as default, with the option apply for only one DC. The code extraction will result in one specific Backup Provider of type MSD.

*   Upgrading engine - In order to maintain backward compatibility a Backup Provider will have to be generated on engine upgrade.

#### Phase 2

*   Persist the ovf to the following different locations (in addition to MSD):
    -   Local FS - We may want to persist the ovfs to a DB. Other than the relative simplicity of using SQL rather than FS hierarchy for the ovf files, another motivation for this metod is the fact that we need to display all VMs to the user when restoring (The user may want to pick which VMs he wants to restore). For this, we need VM identities, specifically names. Since Guids aren't enough it might be simplest to use a DB to hold the some more data on the ovf.
    -   Swift (?)
    -   Debug (?) - We may want to create a Debug Provider for debug purposes only, not exposed to the end user.
    -   NoOp - No use of Backup will be supported. If Backup is indeed used, it should be chroned every x minutes. It may be easier to run it anyway, just as a default NoOp Backup Provider should no other provider is specifically configured. Still to be decided whether to chrone the job with NoOp or not chrone it at all if no Backup Provider is assigned to the system.
*   Restore the system. The user will be able to pick which VMs he wants to restore, and how many of each of them, resembling import. To be discussed - restore flow in case there are multiple Backup Providers configured for the system.
*   Attach existing Backup Provider. For example, should a user stop backup and then want to re-attach it. The user should also be able to add an existing Backup Provider (with data) to a new system. In this case the user should be prompted whether to pick up from latest backup or start from scratch.

### Benefit to oVirt

This feature will allow actual Backing up and Restoring oVirt systems. Current Backup doesn't actually backup the system, mainly since there's no restore. Other than the obvious most needed restore, this feature will arrange the Backup into a Provider, allowing the user to set and use it easily. Adding the varied Provider types will add diversity to the system. Specifically adding the called-for local FS Backup Provider. The Benefit to oVirt users will be an easy-to-use backup-restore capabilities, at system level.

### Dependencies / Related Features

### Documentation / External references

### Testing

The main idea will be to make sure the ovfs were all persisted to the required location according to the type and that later on the system can be restored as a whole, as well as partial systems (when the user picks certain Vms, and not the whole system).
Tests should be done on each Backup Provider separately, followed by backup and restore tests on a system with several Backup Providers.

### Comments and Discussion

*   Refer to <Talk:Backup_Provider>

<Category:Feature>

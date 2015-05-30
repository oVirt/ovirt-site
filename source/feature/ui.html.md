---
title: UI
category: feature
authors: ecohen
wiki_category: Feature
wiki_title: Features/BackupAwareness/UI
wiki_revision_count: 16
wiki_last_updated: 2015-06-03
feature_name: Backup Awareness UI
feature_modules: engine
feature_status: Planning
---

# UI

This page describes the suggested UI design for the [BackupAwareness](BackupAwareness) feature.

## Backup Awareness UI

### Summary

The Backup Awareness UI will include a backup status screen, which will be automatically displayed in the web-admin upon login in case there are missing and/or outdated files/db backups (see [Ovirt-engine-backup](Ovirt-engine-backup)). This screen will contain the overall backup status of the system, individual status per backups type and a link leading to information about the engine backup options.

### Owner

*   Name: [ Alexander Wels](User:Awels)

<!-- -->

*   Email: awels@redhat.com

### Detailed Description

![](BackupStatus-Proposal.png "BackupStatus-Proposal.png")

[Figure 1]

A "Backup Status" side tab will be added to the "Configure" dialog [0].

The "Backup Status" section contain will include information about the db and files backup of the engine, as well as some extra information and reference about the backup options.

*   The overall status of the engine backup [1]: can be:
    -   Green (OK) - "Backup is up to date" - in case both db and files backups exist and are up to date (see Figure 2).
    -   Orange (Warning) - "Backup is missing and/or outdated" - otherwise (i.e. db backup is missing or outdated or files backup is missing or outdated) (see Figure 3).
*   The specific status of the files backup [2]: can be:
    -   Green (OK) - the last successful backup date/time will be displayed (see Figure 2).
    -   Orange (Warning) - "Files backup is outdated" - the last successful backup date/time will be displayed (see Figure 3).
    -   Red (Error) - "Files backup is missing" (see the "Data-base backup is missing" [3] in Figure 3 for reference).
*   The specific status of the db backup [3]: can be:
    -   Green (OK) - the last successful backup date/time will be displayed (see Figure 2).
    -   Orange (Warning) - "Data-base backup is outdated" - the last successful backup date/time will be displayed (see the "Files backup is outdated" [2] in Figure 3 for reference).
    -   Red (Error) - "Files backup is missing" (see Figure 3).
*   Information regarding whether the system is checking for and notifying about missing/outdated backups and if so - at what frequency [4]: can be:
    -   Green (OK) - in case the system

![](BackupStatus-Green.png "BackupStatus-Green.png")

[Figure 2]

![](BackupStatus-Warning.png "BackupStatus-Warning.png")

[Figure 3]

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>

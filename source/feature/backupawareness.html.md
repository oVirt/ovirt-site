---
title: BackupAwareness
category: feature
authors: didi, doron, emesika, sandrobonazzola
wiki_category: Feature|BackupAwareness
wiki_title: Features/BackupAwareness
wiki_revision_count: 40
wiki_last_updated: 2015-05-18
---

# Backup Awareness

## Adding Backup Awareness to oVirt

### Summary

The feature will enable to track backups done using engine-backup utility and to alert the administrator if a per-configurable time had passed from the last successful backup.

### Owner

*   Name: [ Eli Mesika](User:MyUser)

<!-- -->

*   Email: emesika@redhat.com

### Current status

Currently backups are offered only as best practice, there is no alert or event that informs the user that no backup was done or that a long time passed from the last successful backup and he should backup the application database again. his leads to long engine downtime and lot of efforts restoring the customer information in a case of corruption when no backup was done or only a old backup exists

### Use Case

In case that no backup exists or that only a old backup is available, the administrator will see a warning events that informs him that the application data is in risk in case of corruption and encourages him to use engine-backup to backup hi data. The administrator can ignore this warning but it will not be deleted from the audit log until a successful backup is available or the user disables this feature on his own risk (The feature is enabled by default)

### Detailed Description

### Benefit to oVirt

### Assumptions

### Dependencies / Related Features

### Documentation / External references

### Comments and Discussion

*   Refer to <Talk:BackupAwareness>

<Category:Feature> <Category:Template>

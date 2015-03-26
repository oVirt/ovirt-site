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

The feature will enable to track backups done using engine-backup utility and to alert the administrator if a pre-configurable time had passed from the last successful backup.

### Owner

*   Name: [ Eli Mesika](User:MyUser)

<!-- -->

*   Email: emesika@redhat.com

### Current status

Currently backups are offered only as best practice, there is no alert or event that informs the user that no backup was done or that a long time passed from the last successful backup and he should backup the application database again. In case of an accident, this may lead to long engine downtime and lots of efforts restoring the engine DB if no backup was done or only an old backup exists

### Use Case

In case that no backup exists or that only an old backup is available, the system will generate warning events informing the admin that the application data is at risk in case of corruption. The event will encourage the administrator to use perform a backup of the data using his own tools or using engine-backup. The administrator can ignore this warning but it will not be deleted from the audit log until a successful backup is available or the user disables this feature on his own risk (The feature is enabled by default).

### Detailed Description

1)Adding a new table engine_backup_history with the following columns

       db_name varchar
       done_at datetime with time stamp 
       passed boolean 
       output_message text

2)Adding Entity, DAO and tests for engine_backup_history the DAO should implement only 'get' since all insertions are done via engine-backup

3)Adding two configuration variable (available from engine-config)

       BackupCheckPeriodInHours the period on which we check for a fresh backup - default : 6, set to -1 to disable this feature 
       BackupAlertPeriodInDays the max number of days allowed without a fresh backup - default 1

4)Adding a quartz job that will awake every BackupPeriodInHours and check for the last backup available, according to that it will set/clear the appropriate warning

5) Adding events of BACKUP_STARTED and BACKUP_ENDED to be used by engine-backup to record backup activity

### Benefit to oVirt

The benefit to oVirt is a clear indication in case of luck of backups and a minimal engine downtime in case of corruption

### Assumptions

engine-backup is used as the backup utility
engine-backup should support in engine-backup for the exclude option in pg_dump utility (-T), the excluded table should be written in the engine-config configuration and include all task, job. commands and compensation tables
engine-backup will send audit log message when starting, succeeding and failing the backup

### Dependencies / Related Features

Bug ID: 1188144 1188136 1188119 1188143 1188140 1188132 1188152 1188127 1188161 1188121 1188124 1188156 1188130

### Documentation / External references

### Comments and Discussion

*   Refer to <Talk:BackupAwareness>

[BackupAwareness](Category:Feature) [BackupAwareness](Category:oVirt 3.6 Proposed Feature)

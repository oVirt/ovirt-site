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

1)Adding a new table engine_backup_history with the following columns

       db_name varchar
       done_at datetime with time stamp 
       passed boolean 
       error_message text

2)Adding DAO and tests for engine_backup_history the DAO should implement only 'get' since all insertions are done via engine-backup

3)Adding two configuration variable (available from engine-config)

       BackupPeriodInHours the period on which we expect a backup to occur - default : 24, set to -1 to disable this feature 
       BackupExclude a comma-separated list table names that should be excluded from the backup - default: All Task, Job, Compensation tables 
          This requires adding support in engine-backup for the exclude option in pg_dump utility   (-T)

4)Adding a quartz job that will awake every BackupPeriodInHours and check for the last backup available, according to that it will set/clear the appropriate warning

[optional] Adding a cleanup mechanism for the table in the same manner audit_log is cleaned, may be implemented with the same quartz job

### Benefit to oVirt

The benefit to oVirt is a clear indication in case of luck of backups and a minimal engine downtime in case of corruption

### Assumptions

engine-backup is used as the backup utility

### Dependencies / Related Features

### Documentation / External references

### Comments and Discussion

*   Refer to <Talk:BackupAwareness>

<Category:Feature> <Category:Template>

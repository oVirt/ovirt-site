---
title: BackupAwareness
category: feature
authors: didi, doron, emesika, sandrobonazzola
---

# Backup Awareness

## Adding Backup Awareness to oVirt

### Summary

The feature will enable to track backups done using engine-backup utility and to alert the administrator if a pre-configurable time had passed from the last successful backup.

### Owner

*   Name: Eli Mesika

<!-- -->

*   Email: emesika@redhat.com

### Current status

Currently backups are offered only as best practice, there is no alert or event that informs the user that no backup was done or that a long time passed from the last successful backup and he should backup the application database again. In case of an accident, this may lead to long engine downtime and lots of efforts restoring the engine DB if no backup was done or only an old backup exists

### Use Case

In case that no full (db and files) backup exists or that only an old backup is available, the system will generate warning events informing the admin that the application data is at risk in case of corruption. The event will encourage the administrator to use perform a backup of the data using his own tools or using engine-backup. The administrator can ignore this warning but it will not be deleted from the audit log until a successful full backup is available or the user disables this feature on his own risk (The feature is enabled by default).

### Detailed Description

1)Adding a new table engine_backup_log with the following columns

       scope varchar
       done_at datetime with time stamp 
       is_passed boolean 
       output_message text
       fqdn varchar
       log_path text

2)Adding Entity, DAO and tests for engine_backup_log the DAO should implement only 'get' since all insertions are done via engine-backup

3)Adding two configuration variable (available from engine-config)

       BackupCheckPeriodInHours the period on which we check for a fresh backup - default : 6, set to -1 to disable this feature 
       BackupAlertPeriodInDays the max number of days allowed without a fresh backup - default 1

4)Adding a quartz job that will awake every BackupPeriodInHours and check for the last backup available, according to that it will set/clear the appropriate warning

5) Adding events of ENGINE_BACKUP_STARTED and ENGINE_BACKUP_COMPLETED and ENGINE_BACKUP_FAILED to be used by engine-backup to record backup activity

### Interface to engine-backup

engine-backup should call the following procedure upon start/complete/fail

       LogEngineBackupEvent(scope, done_at , status,  output_message, fqdn, log_path)
       scope is  {db,dwhdb,reportsdb,files}
       done_at is the current time
       status is -1 for failure , 0 for started and 1 for completed 
       output_message includes the error message raised in case that the operation failed
       fqdn - fqdn the user configured when running engine-setup
       log_path - the full log file name

### Events Raised

       ENGINE_BACKUP_FAILED - backup operation failed 
       ENGINE_BACKUP_STARTED - backup operation had started 
       ENGINE_BACKUP_COMPLETED - backup operation completed

### Benefit to oVirt

The benefit to oVirt is a clear indication in case of luck of backups and a minimal engine downtime in case of corruption

### Assumptions

engine-backup is used as the backup utility
engine-backup should support in engine-backup for the exclude option in pg_dump utility (-T), the excluded table should be written in the engine-config configuration and include all task, job. commands and compensation tables
engine-backup will send audit log message when starting, succeeding and failing the backup

      The engine-backup utility will keep on backup whatever it does today, this document uses DB backup but will work the same if engine-backup was used to backup files as well.

### Dependencies / Related Features

Bug ID:

*   -   -   -   -   -   -   -   -   -   -   -   -   

### Documentation / External references

See also [Ovirt-engine-backup](/develop/release-management/features/integration/engine-backup.html).

### Testing

TBD

### Contingency Plan

TBD

### Release Notes

TBD



[BackupAwareness](/develop/release-management/features/)

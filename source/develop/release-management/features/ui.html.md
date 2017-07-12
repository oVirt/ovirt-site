---
title: UI
category: feature
authors: ecohen
feature_name: Backup Awareness UI
feature_modules: engine
feature_status: Planning
---

# UI

## Backup Awareness UI

### Summary

The [Backup Awareness](/develop/release-management/features/backupawareness/) UI will include a backup status screen, which will be automatically displayed in the web-admin upon login in case there are missing and/or outdated files/engine data-base backups (see [Ovirt-engine-backup](/develop/release-management/features/engine/engine-backup/)). This screen will contain the overall backup status of the system, individual statuses per backup type and a link leading to information about the engine backup options.

### Owner

*   Name: Alexander Wels (Awels)

<!-- -->

*   Email: awels@redhat.com

### Detailed Description

![](/images/wiki/BackupStatus-Proposal.png)

[^^^ Figure 1]

**A "Backup Status" side tab will be added to the "Configure" dialog [0]**.

The "Backup Status" section will include information about the files and data-base backup status **of the engine only** (and no other backup type at this point, e.g. dwh).

It will include:

*   **The overall status of the engine backup [1]**: can be:
    -   Green (OK) - "Backup is up to date" - in case both db and files backups exist and are up to date (see Figure 2).
    -   Orange (Warning) - "Backup is missing and/or outdated" - otherwise (i.e. engine data-base backup is missing or outdated or files backup is missing or outdated) (see Figure 3).
*   **The specific status of the files backup [2]**: can be:
    -   Green (OK) - the last successful backup date/time will be displayed (see Figure 2).
    -   Orange (Warning) - "Files backup is outdated" - the last successful backup date/time will be displayed (see Figure 3).
    -   Red (Error) - "Files backup is missing" (see the "Data-base backup is missing" [3] in Figure 3 for reference - should be very similar).
*   **The specific status of the engine data-base backup [3]**: can be:
    -   Green (OK) - the last successful backup date/time will be displayed (see Figure 2).
    -   Orange (Warning) - "Data-base backup is outdated" - the last successful backup date/time will be displayed (see the "Files backup is outdated" [2] in Figure 3 for reference - should be very similar).
    -   Red (Error) - "Files backup is missing" (see Figure 3).
*   **Information regarding whether the system is checking for and notifying about missing/outdated backups and if so - at what frequency [4]**: can be:
    -   Green (OK) - in case the system is configured to check for and notify about missing/outdated backup; the check+notification frequency will be mentioned, as well as explanations on this piece of information and how to change the frequency setting / disable the feature (see Figure 2).
    -   Orange (Warning) - in case the system has backup awareness disabled (i.e. the system is configured to not check nor notify about missing/outdated backup); explanations on how to enable the feature will be mentioned (see Figure 3).
*   **Information regarding the configured definition of an up-to-date backup**, as well as information on how to change this configuration setting **[5]**.
*   **Reference to extra information on the engine backup options [6]**. The "here" link will lead to the `EngineBackupOptionsInfoURL` configuration value (see [Features/BackupAwareness/UI/Splash](/develop/release-management/features/splash/)).

The "Configure" dialog will automatically be displayed (with the "Backup Status" side section selected in it) immediately upon successful login to the admin portal if:

*   The overall backup status is not green, and:
*   The engine is configured to check and notify about the backup status at some (any) frequency (i.e. the `BackupCheckPeriodInHours` configuration value is not "-1" - see [Features/BackupAwareness#Detailed_Description](/develop/release-management/features/backupawareness/#detailed-description)).

The user will **always** be able to access the Backup Status screen by navigating to the "Configure" dialog -> "Backup Status" side-section, even if the backup awareness feature is disabled (i.e. even if the `BackupCheckPeriodInHours` configuration value is "-1").

![](/images/wiki/BackupStatus-Green.png)

[^^^ Figure 2]

![](/images/wiki/BackupStatus-Warning.png)

[^^^ Figure 3]

### Benefit to oVirt

The idea is to make sure that the user is aware of the backup options for oVirt in general, as well as notified about the current status of the backup of his engine setup in particular, so he will be able to act accordingly on time, make sure that his backup is always up to date, and consequently minimize downtime in case data recovery is needed.

### Dependencies / Related Features

Obviously, this feature depends on [Ovirt-engine-backup](/develop/release-management/features/engine/engine-backup/) and [Features/BackupAwareness](/develop/release-management/features/backupawareness/).

This feature requires that we will have the following data retrievable from the engine (via a backend query/queries):

*   The `BackupAlertPeriodInDays` configuration value.
*   The `BackupCheckPeriodInHours` configuration value.
*   An indication whether any successful files-backup exist, the date of the latest successful files-backup and whether this backup is considered up-to-date or not (based on the `BackupAlertPeriodInDays` configuration value)**(\*\*)**.
*   Same as ^^^, for engine data-base backup.

**(\*\*) Note**: The client should not determine whether a backup is up-to-date or not, since the client machine time-setting may be different from the engine's time-setting. So the indication whether a backup is up-to-date or not should arrive from the backend. Another option is for the engine to provide a query that will return its current date/time, so that the client will be able to perform a correct time-delta calculation.

### Documentation / External references

*   [Ovirt-engine-backup](/develop/release-management/features/engine/engine-backup/)
*   [Features/BackupAwareness](/develop/release-management/features/backupawareness/)
*   [BZ 1188136](https://bugzilla.redhat.com/show_bug.cgi?id=1188136)

### Testing

1.  Install oVirt
2.  Do not perform any backups
3.  Log into web-admin
4.  **Expected Results 1**: The "Configure" dialog should be automatically displayed with information about the missing backups.
5.  Click on the link for the extra information on backup options.
6.  **Expected Results 2**: The detailed backup options page is opened in a new browser tab/window.
7.  Close web-admin
8.  Change `BackupCheckPeriodInHours` to "-1", restart engine.
9.  Log into web-admin
10. **Expected Results 3**: The "Configure" dialog should not be displayed.
11. Go to the "Configure" dialog -> "Backup Status" section.
12. **Expected Results 4**: Dialog should display same information as in "Expected Results 1".
13. Close web-admin
14. Change `BackupCheckPeriodInHours` to a value other than "-1", restart engine.
15. Perform a files backup using the 'engine-backup' tool
16. Log into web-admin
17. **Expected Results 5**: The "Configure" dialog should be automatically displayed with information about the recent files backup as well as the missing engine data-base backup.
18. Perform a engine data-base backup using the 'engine-backup' tool
19. Close/re-open the "Configure" dialog -> "Backup Status" section
20. **Expected Results 6**: Dialog should display information about the recent files backup as well as the recent engine data-base backup.
21. Close web-admin
22. Ensure that the existing backups are not up-to-date (by waiting for `BackupAlertPeriodInDays` days or manipulating the backup dates somehow in the db, etc. )
23. Log into web-admin
24. **Expected Results 7**: The "Configure" dialog should be automatically displayed with information about the outdated backup.
25. Close web-admin
26. Change the `BackupAlertPeriodInDays` configuration value to a large number (e.g. 100), restart engine.
27. Open web-admin
28. **Expected Results 8**: The "Configure" dialog should not be displayed.
29. Open the "Configure" dialog -> "Backup Status" section
30. **Expected Results 9**: Dialog should display an OK backup status with information about the latest files backup as well as the latest engine data-base backup.

### Contingency Plan

TBD

### Release Notes

TBD

### Your feature heading

A backup status screen will be automatically displayed in the web-admin upon login in case there are missing and/or outdated files/engine data-base backups. This screen will contain the overall backup status of the system, individual status per backup type and a link leading to extra information about the engine backup options.




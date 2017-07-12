---
title: Splash
category: feature
authors: ecohen
feature_name: Backup Awareness UI - Splash Screen
feature_modules: engine
feature_status: Planning
---

# Splash

## Backup Awareness UI - Splash Screen

### Summary

The [Backup Awareness](/develop/release-management/features/backupawareness/) feature will include several [UI](/develop/release-management/features/ui/) components.

One of these components would be a splash screen which will be automatically displayed in the web-admin upon login in case there are missing and/or outdated files/db backups (see [Ovirt-engine-backup](/develop/release-management/features/engine/engine-backup/)).

This screen will contain a general recommendation to consider backing up the engine, with reference to a page containing detailed information about the engine backup options.

### Owner

*   Name: Alexander Wels (Awels)

<!-- -->

*   Email: awels@redhat.com

### Detailed Description

We will add:

*   An backup awareness splash page.
*   A boolean `AdminPortalLoginBackupAlert` configuration value (explanation below). Default value: `true`
*   A string `EngineBackupOptionsInfoURL` configuration value (explanation below). Default value: The URL of [this](/develop/release-management/features/engine/engine-backup/) page.

![](/images/wiki/BackupSplash-tagged.png)

[^^^ Figure 1]

The newly added backup awareness splash page (dialog [0]) will automatically be displayed immediately upon successful login to the admin portal if:

*   *(Condition #1):* The engine backup status is not "green" (see the [Backup Awareness UI](/develop/release-management/features/ui/) page for the definition of a "green" backup status), **and:**
*   *(Condition #2):* The engine is configured to display this page upon login to the administration portal (i.e. the newly-added `AdminPortalLoginBackupAlert` configuration value is "true").

The engine backup splash page will include the following content (all content is **static**, except the link URL in [1] which will be fetched from the engine configuration):

*   "Please consider backup options" title [1] with a link to the detailed backup options. The link URL will be fetched from a newly-added `EngineBackupOptionsInfoURL` engine configuration setting.
*   A note explaining why backup is good for the engine [2].
*   A note (accompanied by a warning icon) explaining why no backup is bad for the engine [3].
*   A note explaining when this splash page will be displayed and how to change this setting [4].

See Figure 2 below for a "clean" mock-up (i.e. without the numbered tagging): ![](/images/wiki/BackupSplash.png)

[^^^ Figure 2]

### Benefit to oVirt

The idea is to make sure that the user is aware of the backup options for oVirt in general, so he will be able to act accordingly on time - make sure that backup is performed, and regularly kept up to date - consequently minimizing downtime in case data recovery is needed.

### Dependencies / Related Features

This feature depends on [Ovirt-engine-backup](/develop/release-management/features/engine/engine-backup/) and [Features/BackupAwareness](/develop/release-management/features/backupawareness/).

This feature requires that we will have the following data retrievable from the engine (via a backend query/queries):

*   An indication whether any successful files-backup exist, and whether the latest files-backup is considered up-to-date or not (based on the last backup date and the `BackupAlertPeriodInDays` configuration value)**(\*\*)**.
*   Same as ^^^, for db-backup.

**(\*\*) Note**: The client should not determine whether a backup is up-to-date or not, since the client machine time-setting may be different from the engine's time-setting. So the indication whether a backup is up-to-date or not should arrive from the backend. Another option is for the engine to provide a query that will return its current date/time as well as the backup date/time, so that the client will be able to perform a correct time-delta calculation.

### Documentation / External references

*   [Ovirt-engine-backup](/develop/release-management/features/engine/engine-backup/)
*   [Features/BackupAwareness](/develop/release-management/features/backupawareness/)
*   [BZ 1188136](https://bugzilla.redhat.com/show_bug.cgi?id=1188136)

### Testing

1.  Install oVirt
2.  Do not perform any backups, keep configuration settings with their default values.
3.  Log into web-admin
4.  **Expected Results 1**: Condition #1 and Condition #2 are fulfilled -> The splash page should be displayed.
5.  Click on the link for the extra information on backup options.
6.  **Expected Results 2**: The detailed backup options page with the `EngineBackupOptionsInfoURL` configuration-value URL is opened in a new browser tab/window.
7.  Close web-admin
8.  Change `AdminPortalLoginBackupAlert` to `false`, restart engine.
9.  Log into web-admin
10. **Expected Results 3**: Condition #2 is not fulfilled -> The splash page should **not** be displayed.
11. Close web-admin
12. Change `AdminPortalLoginBackupAlert` back to `true`, restart engine.
13. Perform a files backup using the 'engine-backup' tool.
14. Log into web-admin
15. **Expected Results 4**: Condition #1 and Condition #2 are fulfilled -> The splash page should be displayed.
16. Perform a db backup using the 'engine-backup' tool
17. Close/re-open the web-admin.
18. **Expected Results 5**: Condition #1 is not fulfilled ->The splash page should **not** be displayed.
19. Ensure that either the db backup or the files backup is **not** up-to-date (by waiting for `BackupAlertPeriodInDays` days or manipulating the backup dates somehow in the db, etc.)
20. Close/re-open the web-admin.
21. **Expected Results 6**: Condition #1 and Condition #2 are fulfilled -> The splash page should be displayed.

### Contingency Plan

TBD

### Release Notes

TBD

### Your feature heading

A backup awareness splash screen will be automatically displayed in the web-admin upon login in case there are missing and/or outdated files/db backups. This behavior can be disabled via the engine-config tool. This screen will contain a general recommendation to regularly back-up the engine, as well as a reference to a (configurable) detailed engine backup options page.




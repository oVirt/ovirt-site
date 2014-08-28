---
title: GlusterVolumeQuota
category: feature
authors: shtripat
wiki_category: Feature
wiki_title: Features/GlusterVolumeQuota
wiki_revision_count: 10
wiki_last_updated: 2014-08-28
feature_name: Gluster Volume Quota
feature_modules: engine
feature_status: Not Started
---

# Gluster Volume Quota

# Summary

This feature allows the administrators to enable and disable disk utlization limits for the gluster volumes and disrectories. This way adminitrators can control the disk space utlization at the directory or volume level. This is particluarly useful in cloud deployments to facilitate utility billing model. Administrators can also configure the quota related parameters like soft timeout, hard timeout and alert time for the gluster volumes using this feature.

Gluster volume quota feature provides users a mechanism to control the disk utlization at volume level or directory level or both. System administrators can also monitor the resource utilization to limit the storage for the users depending on their role in the organization.

To read more about Gluster volume quota feature, see <http://gluster.org/community/documentation/index.php/Gluster_3.2:_Managing_Directory_Quota>.

# Owner

*   Feature owner:
    -   GUI Component owner:
    -   Engine Component owner:
    -   VDSM Component owner:
    -   QA Owner:

# Current Status

*   Status: Inception
*   Last updated date: Thu Aug 28 2014

# Detailed Description

Gluster volume quota is feature using which administrators can restrict the disk space utilization at volume level, at directories level or at both levels.

With this feature the user will be able to

*   Enable volume quota feature
*   Disable volume quota feature
*   Set the disk usage limits for the volume / directories
*   Set the different time-outs (soft time-out, hard time-out, alert time)
*   Remove disk limits

# Design

### User Experience and control flows

#### Main tab "Volumes"

Two new action namely "Enable Quota" and "Disable Quota" would be introduced under actions for Gluster volumes. These actions can be performed on a selected volume from the list. The actions would be enabled based on the current status of quota feature enabled/disabled for the given volume. If quota is not already enabled for the volume, only the action "Enable Quota" would be enabled. If quota is already enabled for a given volume, the action "Enable Quota" would be disabled and "Disable Quota" would get enabled for the same.

<<Insert image>>

If user selects a volume from the list and click the action "Enable Quota", a dialog pops up which provides option for setting disk usage limits for the volume / directories. It also provides options for setting time-outs (soft time-out, hard-timeout, alert time, default time-out). The sections for setting the timeouts would be collapsed by default with default values already set for them. If user wants, he can change the values in this dialog. Setting of disk usage limits would be provided through an action buttion "Set Disk Usage".

<<Insert image>>

On click of the action button "Set Disk Usage" another dialog opens where user can provide the volume root level as well directory level hard limits. User can also mention the soft quota percentage values for the volume / directories.

<<Insert imgage>>

On clicking Ok, the required volume options would be set and also the required disk limits would be enabled for the volume / directories.

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

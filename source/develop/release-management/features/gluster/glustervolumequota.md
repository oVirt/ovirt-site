---
title: GlusterVolumeQuota
category: feature
authors: shtripat
feature_name: Gluster Volume Quota
feature_modules: engine
feature_status: Not Started
---

# Gluster Volume Quota

# Summary

This feature allows the administrators to enable and disable disk utlization limits for the gluster volumes and disrectories. This way adminitrators can control the disk space utlization at the directory or volume level. This is particluarly useful in cloud deployments to facilitate utility billing model. Administrators can also configure the quota related parameters like soft timeout, hard timeout and alert time for the gluster volumes using this feature.

Gluster volume quota feature provides users a mechanism to control the disk utlization at volume level or directory level or both. System administrators can also monitor the resource utilization to limit the storage for the users depending on their role in the organization.

To read more about Gluster volume quota feature, see <https://web.archive.org/web/20160310212525/http://gluster.org/community/documentation/index.php/Gluster_3.2:_Managing_Directory_Quota>.

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

## User Experience and control flows

### Main tab "Volumes"

Two new action namely "Enable Quota" and "Disable Quota" would be introduced under actions for Gluster volumes. These actions can be performed on a selected volume from the list. The actions would be enabled based on the current status of quota feature enabled/disabled for the given volume. If quota is not already enabled for the volume, only the action "Enable Quota" would be enabled. If quota is already enabled for a given volume, the action "Enable Quota" would be disabled and "Disable Quota" would get enabled for the same.

<<Insert image>>

#### Enabling Quota

If user selects a volume from the list and click the action "Enable Quota", a dialog pops up which provides option for setting disk usage limits for the volume / directories. It also provides options for setting time-outs (soft time-out, hard-timeout, alert time, default time-out). The sections for setting the timeouts would be collapsed by default with default values already set for them. If user wants, he can change the values in this dialog. Setting of disk usage limits would be provided through an action buttion "Set Disk Usage".

<<Insert image>>

On click of the action button "Set Disk Usage" another dialog opens where user can provide the volume root level as well directory level hard limits. User can also mention the soft quota percentage values for the volume / directories.

<<Insert imgage>>

On clicking Ok, the required volume options would be set and also the required disk limits would be enabled for the volume / directories.

#### Disabling Quota

To disable quota on a volume, user needs to select the action "Disable Quota" under volumes main tab. This action would unset all the required volumes option and remove the quota set for the volume / directories.

### Sub-tab Volumes --> Quota

There would an additional sub-tab namely Quota introduced under main tab "Volumes". This sub tab would list the quota already set for the given volumes at volume level as well as directories level. This list details the hard limit, soft limit and flags like whether soft limit and hard limit has been reached for the volume / directroies.

<<Insert image>>

This sub-tab also provides options for setting and removing the disk usage limits for specific directroies of the volumes using the actions "Set Disk Usage Limit" and "Remove Disk Usage Limit".

#### Setting Disk Usage Limit

If user selects the action "Set Disk Usage Limit", the dialog for setting the disk usage limit mentioned above, opens. User can set disk usage limit for additional directories for the volume using this option.

#### Removing Disk Usage Limit

If user selects an already set disk usage limit detail from the list and clicks the option "Remove Disk Usage Limit", a confirmation dialog pops for asking if user really wants to remove the disk usage limit and on confirmation the selected disk usage limit is removed. Also all the required volumes options are reset accordingly.

## New Entities

### GlusterVolumeQuotas

This entity stores the disk usage limits set for volume and its sub directroies.

| Column name           | Type   | Description                                              |
|-----------------------|--------|----------------------------------------------------------|
| LimitId               | UUID   | Id of the new disk usage limit                           |
| VolumeId              | UUID   | Reference volume id                                      |
| DirName               | String | Directory name for which the disk usage limit is set     |
| HardLimit             | String | Hard limit of disk usage set for the directory           |
| SoftLimit             | String | Soft limit percentage set for the directory              |
| Used                  | Number | No of bytes used                                         |
| Available             | String | Disk availability for the directory                      |
| SoftLimitExceededFlag | char   | Flag which mentions if the soft limit has exceeded (Y/N) |
| HardLimitExceededFlag | char   | Flag which mentions if the hard limit has exceeded (Y/N) |

Note: LimitId and VolumeId together uniquely identify disk usage limit details for a specific directory

## Entities Changes

None

## Sync Jobs

The Gluster volume quota details would be periodically fetched and updated into engine using the GlusterSyncJOb's heavy weight sync mechanism.

## BLL Commands

*   <big>EnableGlusterVolumeQuota</big> - enables the quota feature for said volume
*   <big>DisableGlusterVolumeQuota</big> - disables the quota feature for said volume
*   <big>SetGlusterVolumeDiskUsageLimit</big> - sets the disk usage hard limit for the said volume and directory (optionally soft limit %tage)
*   <big>SetGlusterVolumeQuotaTimeout</big> - sets the quota related soft and hard timeout values for a volume
*   <big>SetGlusterVolumeQuotaAlertTime</big> - sets the quota related alert time value for a volume
*   <big>SetGlusterVolumeQuotaDefaultSoftLimit</big> - sets the default soft limit for a volume (default is 80% which could be changed using this)
*   <big>RemoveGlusterVolumeDiskUsageLimit</big> - removes the already set disk usage limit for the given volume and directory

## Engine Queries

*   <big>GetGlusterVolumeQuotaDetails</big> - returns the list of disk usage limits set for a volume and directory. If no directory name passed, it returns details for all the directories.

## VDSM Verbs

*   <big>glusterVolumeQuotaEnable</big> - enables quota feature for the said volume
    -   Input
        -   volumeName
    -   Output
        -   Success / Failure

<!-- -->

*   <big>glusterVolumeQuotaDisable</big> - disables quota feature for the said volume
    -   Input
        -   volumeName
    -   Output
        -   Success / Failure

<!-- -->

*   <big>glusterVolumeQuotaSetLimit</big> - sets disk usage limit for the said volume and directory
    -   Input
        -   volumeName
        -   directoryName
        -   hardLimit
        -   [softLimitPcnt]
    -   Output
        -   Success / Failure

Note: softLimitPcnt is an optional argument and would be set only if passed

*   <big>glusterVolumeQuotaSetHardTimeout</big> - sets quota related hard timeout for the said volume
    -   Input
        -   volumeName
        -   timeout
    -   Output
        -   Success / Failure

<!-- -->

*   <big>glusterVolumeQuotaSetSoftTimeout</big> - sets quota related soft timeout for the said volume
    -   Input
        -   volumeName
        -   timeout
    -   Output
        -   Success / Failure

<!-- -->

*   <big>glusterVolumeQuotaSetAlertTime</big> - sets quota related alert time for the said volume
    -   Input
        -   volumeName
        -   time
    -   Output
        -   Success / Failure

<!-- -->

*   <big>glusterVolumeQuotaSetDefaultSoftLimit</big> - sets quota related default soft limit for the said volume
    -   Input
        -   volumeName
        -   limitPcnt
    -   Output
        -   Success / Failure

<!-- -->

*   <big>glusterVolumeQuotaRemoveUsageLimit</big> - removes the disk usage limit for the said volume and directory
    -   Input
        -   volumeName
        -   dirName
    -   Output
        -   Success / Failure

<!-- -->

*   <big>glusterVolumeQuotaDetailsList</big> - gets the disk usage details list for the said volume (and directory optionally)
    -   Input
        -   volumeName
        -   [dirName]
    -   Output
        -   List Disk Usage Details

Note: dirName is an optional argument and details of the specific directory are returned if passed, else details for all the directories are returned.

## RESTful APIs

Details of the RESTful APIs for the Gluster volume quota feature are as below

### Listing APIs

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/quota|rel=get` - lists all the disk usage limits for the volume directory-wise

Output:

```xml
    <diskUsageLimits>
      <diskUsageLimit href="" id="">
        <actions>
        </actions>
        <dir>{dir-name}</dir>
        <hardLimit>{hard-limit-value}</hardLimit>
        <softLimit>{soft-limit-percentage}</softLimit>
        <used>{used-bytes}</used>
        <available>{available-limit}</available>
        <softLimitExceeded>{Y/N}</softLimitExceeded>
        <hardLimitExceeded>{Y/N}</hardLimitExceeded>
      </diskUsageLimit>
    </diskUsageLimits>
```

### Actions Supported

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/enable-quota|rel=enable-quota` - enables quota feature for the volume

Input:

```xml
    <action/>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/enable-quota|rel=disable-quota` - disables quota feature for the volume

Input:

```xml
    <action/>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/quota|rel=add` - adds disk usage limit for said volume and directory
    -   Parameters
        -   `dirName` - String
        -   `hardLimit` - String
        -   `softLimitPcnt` - String

Input:

```xml
    <action>
      <diskUsageLimit>
        <dirName>{dir-name}</dirName>
        <hardLimit>{hard-limit-value}</hardLimit>
        <softLimitPcnt>{soft-limit-percentage}</softLimitPcnt>
      </diskUsageLimit>
    </action>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/quota|rel=delete` - removes a disk usage limit for said volume and directory
    -   Parameters
        -   `dirName` - String

Input:

```xml
    <action>
      <diskUsageLimit>
        <dirName>{dir-name}</dirName>
      </diskUsageLimit>
    </action>
```

or

```xml
    <diskUsageLimit id="{limit-id}" />
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/set-quota-soft-timeout|rel=set-quota-soft-timeout` - sets the quota related soft timeout value
    -   Parameters
        -   `timeout` - String

Input:

```xml
    <action>
      <softTimeout>{soft-timeout-value}</softTimeout>
    </action>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/set-quota-hard-timeout|rel=set-quota-hard-timeout` - sets the quota related hard timeout value
    -   Parameters
        -   `timeout` - String

Input:

```xml
    <action>
      <hardTimeout>{hard-timeout-value}</hardTimeout>
    </action>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/set-quota-alert-time|rel=set-quota-alert-time` - sets the quota related alert time value
    -   Parameters
        -   `time` - String

Input:

```xml
    <action>
      <alertTime>{alert-time-value}</alertTime>
    </action>
```

*   `/api/clusters/{cluster-id}/glustervolumes/{volume-id}/set-deafult-soft-limit|rel=set-deafult-soft-limit` - sets the quota related default soft limit percentage
    -   Parameters
        -   `limit` - String

Input:

```xml
    <action>
      <limit>{limit-percentage-value}</limit>
    </action>
```

## Limitations

NA

# Dependencies / Related Features and Projects

None

# Test Cases

# Documentation / External references

<https://web.archive.org/web/20160310212525/http://gluster.org/community/documentation/index.php/Gluster_3.2:_Managing_Directory_Quota>



# Open Issues


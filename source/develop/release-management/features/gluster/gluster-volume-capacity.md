---
title: Gluster Volume Capacity
category: feature
authors:
  - anmol babu
  - rnachimu
  - sahina
  - shtripat
---

# Gluster Volume Capacity

## Summary

A gluster storage administrator would like to view the capacity information (total , used and free) on a volume. This feature provides support for that.

## Owner

## Current Status

*   Status: Completed
*   Available in: oVirt 3.5
*   Last updated date: ,

## Detailed Description

This feature helps the user to know the volume capacity information. Capacity information will be shown in the Volumes tab and it will be updated in background by the Ovirt Engine.

## Dependencies / Related Features

## User Flows

To view Gluster Volume Capacity, User goes to "Volumes" tab where capacity information will be displayed as part of each volume row. A new column 'Space Used' will be shown just before the 'Activities' column. Capacity information will be shown as progress bar with percentage of usage and a refresh icon to refresh the detail.On hovering the refresh icon user can get information about when the last update was made.

![](/images/wiki/VolumeCapacity.png)

The brick capacities are listed in the "Bricks" sub tab of the "Volumes" tab.User can click on a specific volume and view the capacities of its bricks in the "Bricks" sub tab.On refreshing the volume capacity in the volume tab by clicking on the clock icon in the volume tab,the bricks capacities are also refreshed.Details such as the progress bar containing the brick usage percentage are shown across each brick in the selected volume.

![](/images/wiki/VolumeBrickCapacity.png)

## Getting the volume capacity details

Volume capacity information will be fetched by GlusterSyncJob as part of getting Volume advanced details. 'glusterVolumeStatus' VDSM verb will be enhanced to get the capacity information as part of volume status. Capacity information will be fetched when 'detail' options is passed. Internally VDSM can use any of the following ways to determine the capacity information.

### Using libgfapi

In this approach VDSM uses the APIs from libgfapi to get the details of a gluster volume. There are certain issues with the said API and not opting for using this option.

### By mounting the volume and running "df" command

In this approach VDSM mounts the gluster volume first and then uses the "df" command to get the volume capacity details. This approach is bit expensive but foolproof. Opted to use this approach and go ahead.

### By collating details from advanced volume details

In this approach VDSM needs to collate the details from advanced details of the volume and populate the capacity details. This approach would be light weight. Planning to migrate to this approach at later stage as more details like raw capacity for volumes, bricks etc. are required.

## Detailed Design

### Entities

#### Gluster_Volumes

Following three columns will be added to gluster_volumes table.

| Column    | Type | Description       |
|-----------|------|-------------------|
| totalSize | long | total volume size |
| freeSize  | long | free volume size  |
| usedSize  | long | used volume size  |

#### GlusterVolumeSizeInfo

A new entity GlusterVolumeSizeInfo will be added to GlusterVolumeEntity.

| Column     | Type   | Description                     |
|------------|--------|---------------------------------|
| volumeId   | GUID   | respective gluster volume id    |
| volumeName | String | Volume Name                     |
| totalSize  | long   | total volume size               |
| freeSize   | long   | free volume size                |
| usedSize   | long   | used volume size                |
| updatedAt  | Date   | Capacity Info Lasted updated at |

### Query

#### GetGlusterVolumeSizeInfoQuery

Makes a call to Gluster and get the volume capacity details. The details are returned into an instance of GlusterVolumeSizeInfo.

### REST API

*   Add statistics GET action on the gluster volume resource

      /api/clusters/{cluster-id}/glustervolumes/{volume-id}/statistics

This will return the volume capacity details. The details listed under volume capacity details would be -

*   Free Size
*   Used Size
*   Total Size

The output format would look like -

    <statistics>
        <statistic id="{id}">
            <name>memory.total.size</name>
            <description>Total size</description>
            <values type="INTEGER">
                <value>
                    <datum>{value}</datum>
                </value>
            </values>
            <type>GAUGE</type>
            <unit>BYTES</unit>
            <gluster_volume href="/ovirt-engine/api/clusters/{cluster-id}/glustervolumes/{volume-id}" id="{volume-id}"/>
        </statistic>
        <statistic id="{id}">
            <name>memory.free.size</name>
            <description>Free size</description>
            <values type="INTEGER">
                <value>
                    <datum>{value}</datum>
                </value>
            </values>
            <type>GAUGE</type>
            <unit>BYTES</unit>
            <gluster_volume href="/ovirt-engine/api/clusters/{cluster-id}/glustervolumes/{volume-id}" id="{volume-id}"/>
        </statistic>
        <statistic id="{id}">
            <name>memory.used.size</name>
            <description>Used size</description>
            <values type="INTEGER">
                <value>
                    <datum>{value}</datum>
                </value>
            </values>
            <type>GAUGE</type>
            <unit>BYTES</unit>
            <gluster_volume href="/ovirt-engine/api/clusters/{cluster-id}/glustervolumes/{volume-id}" id="{volume-id}"/>
        </statistic>
    </statistics> 


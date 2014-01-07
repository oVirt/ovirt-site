---
title: Gluster Volume Capacity
category: feature
authors: anmol babu, rnahcimu, sahina, shtripat
wiki_category: Feature
wiki_title: Features/Gluster Volume Capacity
wiki_revision_count: 26
wiki_last_updated: 2014-12-22
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Gluster Volume Capacity

## Summary

A gluster storage administrator would like to view the capacity information (total , used and free) on a volume. This feature provides support for that.

## Owner

## Current Status

*   Status: Development in progress
*   Last updated date: ,

## Detailed Description

This feature helps the user to know the volume capacity information. Capacity information will be shown in the Volumes tab and it will be updated in background by the Ovirt Engine.

## Dependencies / Related Features

## User Flows

To view Gluster Volume Capacity, User goes to "Volumes" tab where capacity information will be displayed as part of each volume row. A new column 'Capacity' will be shown just before the 'Activities' column. Capacity information will be shown as graphic with total space available and percentage of usage ,etc.

![File:VolumeCapacity.png](VolumeCapacity.png "File:VolumeCapacity.png")

## Getting the volume capacity details

The possibility for determining the volume capacity details are as below -

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

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Column</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">volumeId</td>
<td align="left">GUID</td>
<td align="left">respective gluster volume id</td>
</tr>
<tr class="even">
<td align="left">volumeName</td>
<td align="left">String</td>
<td align="left">Volume Name</td>
</tr>
<tr class="odd">
<td align="left">totalSize</td>
<td align="left">long</td>
<td align="left">total volume size</td>
</tr>
<tr class="even">
<td align="left">freeSize</td>
<td align="left">long</td>
<td align="left">free volume size</td>
</tr>
<tr class="odd">
<td align="left">usedSize</td>
<td align="left">long</td>
<td align="left">used volume size</td>
</tr>
<tr class="even">
<td align="left">updatedAt</td>
<td align="left">Date</td>
<td align="left"></td>
</tr>
</tbody>
</table>

Capacity Info Lasted updated at

### Query

#### GetGlusterVolumeSizeInfoQuery

Makes a call to Gluster and get the volume capacity details. The details are returned into an instance of GlusterVolumeSizeInfo.

### REST API

*   Add statistics GET action on the gluster volume resource

<!-- -->

     /api/clusters/{cluster-id}/glustervolumes/{volume-id}/statistics

This will return the volume capacity details. The details listed under volume capacity details would be -

*   Free Size
*   Used Size
*   Total Size

The output format would look like -

            memory.total.size
            Total size

                    {value}

            GAUGE
            BYTES

            memory.free.size
            Free size

                    {value}

            GAUGE
            BYTES

            memory.used.size
            Used size

                    {value}

            GAUGE
            BYTES

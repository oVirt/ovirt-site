---
title: Gluster Volume Capacity
category: feature
authors: anmol babu, rnahcimu, sahina, shtripat
wiki_category: Feature
wiki_title: Features/Gluster Volume Capacity
wiki_revision_count: 26
wiki_last_updated: 2014-12-22
---

# Gluster Volume Capacity

## Summary

A gluster storage administrator would like to view the capacity information (total , used and free) on a volume. This feature provides support for that.

## Owner

## Current Status

*   Status: Development in progress
*   Last updated date: ,

## Detailed Description

This feature enables the user to check the capacities of one/more volumes by clicking on "Capacity" menu in "Volumes" sub-tab.

## Dependencies / Related Features

## User Flows

To view Gluster Volume Capacity, User goes to "Volumes" tab and clicks "Capacity" menu. ![](StatsMenu.jpg "fig:StatsMenu.jpg") A dialog pops up with the details like names of selected volumes,their total capacities,their usage,their percentage of usage and any comments if applicable. For example, Volume full if the volume is completely used up. The dialog also lists separately the list of volumes that are completely filled up and also the list of volumes that are nearing completion in terms of usage. ![](VolumeCapacity.jpg "fig:VolumeCapacity.jpg")

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

#### GlusterVolumeSizeInfo

| Column    | Type | Description                  |
|-----------|------|------------------------------|
| volumeId  | GUID | respective gluster volume id |
| totalSize | long | total volume size            |
| freeSize  | long | free volume size             |
| usedSize  | long | used volume size             |

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

<Category:Feature>

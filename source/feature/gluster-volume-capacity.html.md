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

This feature enables the user to check the capacities of one/more volumes by clicking on "Capacity" menu in "Volumes" sub-tab.

## Dependencies / Related Features

## User Flows

To view Gluster Volume Capacity, User goes to "Volumes" tab and clicks "Capacity" menu. ![File:StatsMenu.jpg](StatsMenu.jpg "File:StatsMenu.jpg") A dialog pops up with the details like names of selected volumes,their total capacities,their usage,their percentage of usage and any comments if applicable. For example, Volume full if the volume is completely used up. The dialog also lists separately the list of volumes that are completely filled up and also the list of volumes that are nearing completion in terms of usage. ![File:VolumeCapacity.jpg](VolumeCapacity.jpg "File:VolumeCapacity.jpg")

## Detailed Design

### Entities

GlusterVolumeSizeInfo

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
<td align="left">totalSize</td>
<td align="left">long</td>
<td align="left">total volume size</td>
</tr>
<tr class="odd">
<td align="left">freeSize</td>
<td align="left">long</td>
<td align="left">free volume size</td>
</tr>
<tr class="even">
<td align="left">usedSize</td>
<td align="left">long</td>
<td align="left"></td>
</tr>
</tbody>
</table>

used volume size

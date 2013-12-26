---
title: GlusterVolumeSnapshots
category: feature
authors: sandrobonazzola, shtripat
wiki_category: Feature
wiki_title: Features/Design/GlusterVolumeSnapshots
wiki_revision_count: 110
wiki_last_updated: 2014-12-23
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Gluster Volume Snapshots

## Summary

This document describes the design for the volume snapshot feature under Gluster. GlusterFS provides crash recoverability for the vloumes through snapshot feature and RHS-C needs to provide a web based mechanism to achieve the same feature.

This feature allows the administrators to create, start, stop, delete and restore to a given snapshot. With this administrators can view all the available snaps taken for a volume and in case of crash can opt to restore to a point in time view using the existing snapshots.

## Owner

*   Feature owner: Shubhendu Tripathi <<shtripat@redhat.com>></<shtripat@redhat.com>>
    -   GUI Component owner:
    -   Engine Component owner: Shubhendu Tripathi <<shtripat@redhat.com>></<shtripat@redhat.com>>
    -   VDSM Component owner:

## Current Status

*   Status: Inception
*   Last updated date: Thu Dec 26 2013

## Design

The snapshot feature is being designed to enable administrators to define a consistency group, create and maintain volume snapshots. It also provides mechanism to restore a volume to a point in time snap of the volume in a crash situation.

### New Entities

#### GlusterVolumeConsistencyGroup

This entity stores the details of a Gluster volume consistency group. While definition of a consistency group different volumes are assigned the newly created consistency group's identity to make sure they belong to the said consistency group.

<caption>GlusterVolumeConsistencyGroups</caption>

Column name

Type

Description

Id

UUID

Primary Key

CGName

String

Name of the consistency group

Description

String

Description of the consistency group

#### GlusterVolumeSnapshots

This entity stores the snapshot details created on gluster volumes. Different volumes can have snapshots with same names.

<caption>GlusterVolumeSnapshots</caption>

Column name

Type

Description

VolumeId

UUID

Id of the reference volume

SnapId

UUID

Id of the new snapshot

SnapName

String

Name of the snapshot

SanpTime

Date

Creation time of the snapshot

description

String

Description

Status

String

Current status of the snapshot

#### GlusterVolumeSnapshotConfig

This entity stores the details of a configuration parameter for volume snapshot. Volume specific values for the parameters would be maintained as part of this entity, whereas the system level configuration parameters would be maintained as part of vdc_options only.

<caption>GlusterVolumeSnapshotConfig</caption>

Column name

Type

Description

VolumeId

UUID

Id of the reference volume

ParamName

String

Name of the configuration parameter

ParamValue

String

Value of the configuration parameter

### Entities changes

*   Change to store consistency group id for a volume
    -   Add a field cgId of UUID type in gluster_volumes table to store a consistency group id, if volume is part of a consistency group
*   Change to mark if a volume is a snap volume
    -   Add a flag isSnap of character type in glusyer_volumes table to indicate if a volume is a snapshot (Internally snapshots are stored as volumes only)

gluster_volumes

| Column | Type           | Change   | Description                                                                            |
|--------|----------------|----------|----------------------------------------------------------------------------------------|
| cgId   | UUID, nullable | Addition | stores the consistency group id if volume is part of a consistency group               |
| isSnap | char           | Addition | stores the flag which mentions is the said volume is a snap volume or a regular volume |

### Database changes

Modify all the stored procedures on gluster_volumes tables to add additional WHERE clause with 'isSnap=N'

#### Gluster Geo Replication Sessions

This entity stores the details of the individual geo-replication sessions

<caption>gluster_geo_rep_session</caption>

Column name

Type

description

Id

UUID

Primary Key

Destination_id

UUID

References Id of gluster_geo_rep_destinations

Volume_id

UUID

References Id of gluster_volumes

Destination_Volume

String

Name of the volume in destination cluster

#### Gluster Geo Replication Session Status

This entity stores the status of individual geo-replication sessions maintained in oVirt engine

<caption>gluster_geo_rep_session_status</caption>

Column name

Type

description

Id

UUID

Primary Key

Session_id

UUID

References Id of gluster_geo_rep_session

Server_id

UUID

Host in the source cluster

Status

String

Valid values STABLE, FAULTY, INITIALIZING, NOT_STARTED

#### Gluster Geo Replication Session Config

Refer the URL <http://www.ovirt.org/Features/Entity_Configuration_Management> for more details on configuration maintenance.

### REST APIs

The details of the REST for gluster geo-replication feature are as below -

#### Listing APIs

*   api/clusters/{id}/geo-replication-destinations - lists all the geo-replication destinations from current cluster

Output:

        geo replication destination id
        Cluster Id
        Source Host Id
        Destination Host Id

        geo replication destination id
        Cluster Id
        Source Host Id
        Destination Host Id

*   api/clusters/{id}/geo-replication-destinations/{geo-rep-destination-id} - lists the details of the individual geo-replication destination

Output:

        geo replication destination id
        Cluster Id
        Source Host Id
        Destination Host Id

*   api/volumes/{id}/geo-replication-sessions - lists all the geo-replication sessions for the current volume

Output:

        geo replication session id
        source volume id
        Source Host Id
        Destination Host Id
        destination volume id
        Stable/Faulty/Initializing/Not Started

        geo replication session id
        source volume id
        Source Host Id
        Destination Host Id
        destination volume id
        Stable/Faulty/Initializing/Not Started

*   api/volumes/{id}/geo-replication-sessions/{geo-rep-session-id} - lists the detail of an individual geo-replication session

Output:

        geo replication session id
        source volume id
        Source Host Id
        Destination Host Id
        destination volume id
        Stable/Faulty/Initializing/Not Started

*   api/volumes/{id}/geo-replication-sessions/{geo-rep-session-id}/configurations - lists all the configurations for a geo-replication session

Output:

        Configuration Id
        Name of the configuration
        Value of the configuration

*   api/volumes/{id}/geo-replication-sessions/{geo-rep-session-id}/configurations/{config-id} - shows the details of an individual configuration for a geo-replication session

Output:

        Configuration Id
        Name of the configuration
        Value of the configuration

#### Actions Supported

*   api/clusters/{id}/create-geo-rep-destination - creates a new geo-replication destination for the cluster
    -   Parameters
        -   source_host - uuid
        -   destination_host - uuid
        -   destination_root_passwd - string

Input:

      Source Host Id
      Destination Host Id
      Destination Host root password

*   api/clusters/{id}/geo-replication-destinations/{geo-rep-destination-id}/remove - Removes the given geo-replication destination
*   api/clusters/{id}/geo-replication-destinations/{geo-rep-destination-id}/reestablish - reestablishes the communication between geo-replication source-destination
*   api/clusters/{id}/geo-replication-destinations/{geo-rep-destination-id}/test - checks the validity of communication between geo-replication source-destination
*   api/volumes/{id}/create-geo-rep-session - Creates a new geo-replication session for the volume
    -   Parameters
        -   destination_host
        -   destination_volume

Input:

      Destination Host Id
      Destination Volume Id

*   api/volumes/{id}/geo-replication-sessions/{geo-rep-session-id}/start - starts the given geo-replication session
*   api/volumes/{id}/geo-replication-sessions/{geo-rep-session-id}/stop - stops the given geo-replication session
*   api/volumes/{id}/geo-replication-sessions/{geo-rep-session-id}/remove - removes the given geo-replication session
*   api/volumes/{id}/geo-replication-sessions/{geo-rep-session-id}/set-config - sets a configuration value for a geo-replication session
    -   Parameters
        -   configuration_name - string
        -   configuration_value - string

Input:

      Name of the configuration
      Value of the configuration

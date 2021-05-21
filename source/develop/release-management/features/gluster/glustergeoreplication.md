---
title: GlusterGeoReplication
category: feature
authors:
  - kmayilsa
  - sahina
  - sandrobonazzola
  - shtripat
---

# Gluster Geo Replication

## Summary

This document describes the design for geo replication feature under gluster. For overview of this feature, refer [Features/Gluster_Geo_Replication](/develop/release-management/features/gluster/gluster-geo-replication.html)

## Design

Geo-replication feature is designed to enable creation and maintenance of geo-replication sessions across clusters in GlusterFS. A geo-replication session can be setup between a GlusterFS managed source cluster and remote (destination) GlusterFS managed cluster.

### Entity Description

#### Gluster Geo Replication Sessions

This entity stores the details of geo-replication sessions that are set up for gluster volumes

| Column name         | Type   | description                                                                                                                                             |
|---------------------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| session_id         | UUID   | Primary Key                                                                                                                                             |
| master_volume_id  | UUID   | Id of the master gluster volume                                                                                                                         |
| session_key        | String | Session key of the form <masternode uuid>:<ssh url for slave volume> For instance, 11ae7a03-e793-4270-8fc4-b42def8b3051:<ssh://192.168.122.14>::slave2  |
| slave_host_uuid   | UUID   | UUID of VDS in destination cluster used to create session                                                                                               |
| slave_host_name   | String | Hostname of host in destination cluster used to create session                                                                                          |
| slave_volume_id   | UUID   | Volume id of destination volume                                                                                                                         |
| slave_volume_name | String | Volume name of destination volume                                                                                                                       |
| status              | String | Status of geo-replication session. One of INITIALIZING, NOTSTARTED, ACTIVE, PASSIVE, STOPPED, PARTIAL_FAULTY, UNKNOWN, FAULTY (in GeoRepSessionStatus) |

#### Gluster Geo Replication Session Details

This entity stores the details of the individual geo-replication sessions

| Column name        | Type   | description                                                          |
|--------------------|--------|----------------------------------------------------------------------|
| session_id        | UUID   | Ref to gluster_georep_session                                      |
| master_brick_id  | UUID   | Ref to gluster_volume_bricks                                       |
| slave_host_uuid  | uuid   | UUID of VDS host in destination cluster that brick is syncing to     |
| slave_host_name  | String | hostname of VDS host in destination cluster that brick is syncing to |
| status             | String | status of brick connection. one of GeoRepSessionStatus               |
| checkpoint_status | String |                                                                      |
| crawl_status      | String |                                                                      |
| files_synced      | bigint |                                                                      |
| files_pending     | bigint |                                                                      |
| bytes_pending     | bigint |                                                                      |
| deletes_pending   | bigint |                                                                      |
| files_skipped     | bigint |                                                                      |

#### Gluster Geo Replication Session Configuration

This entity stores the configuration details of the individual geo-replication sessions

| Column name   | Type   | description         |
|---------------|--------|---------------------|
| config_key   | String | Configuration key   |
| config_value | String | Configuration value |

### REST APIs

The details of the REST for gluster geo-replication feature are as below -

#### Listing APIs

*   api/clusters/{id}/glustervolumes/{id}/georeplication-sessions - lists all the geo-replication sessions for a gluster volume

Output:

    <georeplication-sessions>
      <georeplication-session>
        <id>id</id>
        <host>Cluster Id</host>
        <slavevolume>Slave volume</slavevolume>
        <status>status</status>
      </georeplication-session>
      ...
    </georeplication-session>

*   api/clusters/{id}/glustervolumes/{id}/georeplication-sessions/{id} - lists the details of the individual geo-replication session

Output:

       <georeplication-session>
        <id>id</id>
        <host>Cluster Id</host>
        <slavevolume>Slave volume</slavevolume>
        <status>status</status>
        <session_details>
            <session_detail>
                 <brick>brick entity</brick>
                 <slaveNode>host</slaveNode>
                  <status>
                  <checkpoint_status></checkpoint_status>
                  <crawl_status></crawl_status>
                  <filesSkipped>Statistic</filesSkipped>
                  <filesPending>Statistic</filesPending>
                 <filesSynced>Statistic</filesSynced>
             <session_detail>
    ...
       </session_details>
      </georeplication-session>

*   api/clusters/{id}/glustervolumes/{id}/georeplication-sessions/{id}/options - lists all the configuration options for a geo-replication session

Output:

    <georeplication_options>
      <option>
        <id>Configuration Id</id>
        <key>Name of the configuration</key>
        <value>Value of the configuration</value>
      </option>
    </georeplication_options>

#### Actions Supported

*   POST api/clusters/{id}/glustervolumes/{id}/georeplication-sessions - creates a new geo-replication session for the cluster
    -   Parameter GeoRepSession type

<!-- -->

*   api/clusters/{id}/glustervolumes/{id}/georeplication-sessions/{id}/start - starts the given geo-replication session
*   api/clusters/{id}/glustervolumes/{id}/georeplication-sessions/{id}/stop - stops the given geo-replication session
*   api/clusters/{id}/glustervolumes/{id}/georeplication-sessions/{id}/pause - pauses the given geo-replication session
*   api/clusters/{id}/glustervolumes/{id}/georeplication-sessions/{id}/resume - resumes the given geo-replication session

[Gluster Geo Replication](/develop/release-management/features/) [Gluster Geo Replication](Category:oVirt 4.0 Proposed Feature)

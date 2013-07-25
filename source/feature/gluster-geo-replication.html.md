---
title: Gluster Geo Replication
category: feature
authors: kmayilsa, sahina, sandrobonazzola, shtripat
wiki_category: Feature|Gluster Geo Replication
wiki_title: Features/Gluster Geo Replication
wiki_revision_count: 121
wiki_last_updated: 2014-12-22
---

# Gluster Geo Replication

## Summary

This feature allows the administrator to configure, start, stop and monitor geo-replication for Gluster volumes from oVirt engine. With this the administrator can view the status of geo-replication on Gluster volumes and also would be able to start/stop/configure geo-replication for a volume. GlusterFS geo-replication provides a continuous, asynchronous, and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

To read more about GlusterFS geo-replication, see <http://gluster.org/community/documentation/index.php/Gluster_3.2:_GlusterFS_Geo-replication_Deployment_Overview>.

## Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner: Balamurugan Arumugam <barumuga@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: In Progress
*   Last updated date: Thu Jul 25 2013

## Detailed Description

GlusterFS Geo-replication uses a Source–Destination model, whereby replication and mirroring occurs between the following partners:

*   Source – A GlusterFS volume
*   Destination – A GlusterFS Volume in a remote cluster

With this feature the user will be able to

*   View all the destinations attached to a cluster
*   Add a new destination and enable password less communication between a host of source cluster and a host of destination cluster
*   Test password less communication to destination cluster/host
*   Remove(Detach) a destination cluster
*   View all active/inactive geo-replication sessions for a volume
*   Setup a new ge-replication session
*   Start a geo-replication session
*   Stop a geo-replication session
*   Remove an inactive geo-replication session
*   View and update the configuration before starting the session or later (ssh command, gsync command)
*   Monitor the status of geo-replication sessions in a cluster

### Setting up Geo Replication - Functional Work Flow

## Design

Geo-replication feature is designed to enable creation and maintenance of geo-replication sessions across clusters in GlusterFS. A geo-replication session can be setup between a GlusterFS managed source cluster and remote (destination) GlusterFS managed cluster.

### Entity Description

#### Gluster Geo Replication Destinations

This entity stores the details of remote (destination) for a geo-replication setup.

| Column name                   | Type   | description                                                              |
|-------------------------------|--------|--------------------------------------------------------------------------|
| Id                            | UUID   | Primary Key                                                              |
| Vds_Group_Id                | UUID   | Id of the Source Cluster                                                 |
| Server_Id                    | UUID   | Host of the Source Cluster                                               |
| Destination_Host_IP         | String | Host part of remote/destination cluster                                  |
| Destination_SSH_Fingerprint | String | SSH key fingerprint of destination host                                  |
| Connection_Status            | String | Password less connection status between source node and destination node |

#### Gluster Geo Replication Sessions

This entity stores the details of the individual geo-replication sessions

| Column name         | Type   | description                                      |
|---------------------|--------|--------------------------------------------------|
| Id                  | UUID   | Primary Key                                      |
| Destination_id     | UUID   | References Id of gluster_geo_rep_destinations |
| Volume_id          | UUID   | References Id of gluster_volumes                |
| Destination_Volume | String | Name of the volume in destination cluster        |

#### Gluster Geo Replication Session Status

This entity stores the status of individual geo-replication sessions maintained in oVirt engine

| Column name | Type   | description                                             |
|-------------|--------|---------------------------------------------------------|
| Id          | UUID   | Primary Key                                             |
| Session_id | UUID   | References Id of gluster_geo_rep_session             |
| Server_id  | UUID   | Host in the source cluster                              |
| Status      | String | Valid values STABLE, FAULTY, INITIALIZING, NOT_STARTED |

#### Gluster Geo Replication Session Config

Refer the URL <http://www.ovirt.org/Features/Entity_Configuration_Management> for more details on configuration maintenance.

### User Experience

#### Add/Attach a new Destination Cluster

A new sub-tab will be introduced under Cluster tab which would list all the existing geo-replication destinations for the current cluster. Password less SSH communication should be enabled between one node of the source cluster and one node of destination cluster before creating a geo-replication session between the identified source and destination clusters. The below dialog "New Geo-Replication Destination" would capture the required details for adding a new destination cluster for geo-replication session.

![](geo_replication_slave1_new.png "geo_replication_slave1_new.png")

If the user select the **Copy source cluster hosts public keys to destination cluster** then the following steps will happen

*   `gluster system:: execute gsec_create` command will be executed in one of the hosts of the source cluster. This will create a public key file, which will have the public keys of all the hosts of the source cluster
*   Public key file will be copied to the destination host (through password less ssh)
*   `gluster system:: execute add_secret_pub` command is used to distribute the public file to all the hosts of the destination Cluster
*   Now all the hosts of the source cluster can initiate geo sync task in the hosts of the destination cluster

#### All the existing Destinations

All existing geo-replication destinations attached to the cluster will be show for the cluster along with their status. It also provides options for creation or new destinations and removal of the destinations. Testing the validity/availability of a destination is possible using the action "Test". Administrator can re-establish a broken source/destination communication as well using the action "Re-establish".

![](geo_replication_slave2_subtab.png "geo_replication_slave2_subtab.png")

#### Re-establish password less communication with destination host

The below dialog provides a mechanism for re-establishing a broken source/destination communication between source and destination clusters. It captures the details again and re-establishes the communication between source and destination cluster.

![](geo_replication_slave3_reestablish.png "geo_replication_slave3_reestablish.png")

#### Create a new Geo-Replication Session

A new sub tab "Geo-Replication Sessions" will be added to the Volumes main tab in oVirt webadmin UI which will list all the geo-replication sessions for the selected volume. The below dialog captures the details and creates the geo-replication session between source and destination gluster volumes.

![](volume_georeplication1_new.png "volume_georeplication1_new.png")

#### View All Geo-Replication Sessions

Geo-Replication Session subtab also provides actions for

*   Removal of an existing geo-replication session
*   Starting a geo-replication session
*   Stopping a geo-replication session
*   Update configurations for a geo-replication session

![](volume_georeplication2_subtab.png "volume_georeplication2_subtab.png")

#### Start a new Geo-Replication Session

A new action named **Start** will be shown in the **Geo-Replication Sessions** tab

#### Stop a Geo-Replication Session

A new action named **Stop** will be shown in the **Geo-Replication Sessions** tab

#### Remove a Geo-Replication Session

A new action named **Remove** will be shown in the **Geo-Replication Sessions** tab

#### Configurations of Geo-Replication Session

The below dialog fetches and lists the default values of all the configurations for a geo-replication session. It provides and option to change the values of the configurations.

![](volume_georeplication3_config.png "volume_georeplication3_config.png")

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

<http://www.gluster.org/community/documentation/index.php/GlusterFS_Geo_Replication>

<http://gluster.org/community/documentation/index.php/Gluster_3.2:_Starting_GlusterFS_Geo-replication>

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/Gluster_Geo_Replication>

## Open Issues

<Category:Feature>

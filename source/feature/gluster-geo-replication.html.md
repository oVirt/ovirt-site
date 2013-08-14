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

This feature allows the administrator to create, start, stop and monitor geo-replication for Gluster volumes from oVirt engine. With this the administrator can view the status of geo-replication sessions on Gluster volumes and also would be able to start/stop the geo-replication sessions. GlusterFS geo-replication provides a continuous, asynchronous, distributed and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

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

*   View all a geo-replication sessions for a volume
*   Setup a new ge-replication session
*   Start a geo-replication session
*   Stop a geo-replication session
*   Remove an inactive geo-replication session
*   View and update the configuration before starting the session or later (ex: change detector)
*   Monitor the status of geo-replication sessions

### Setting up Geo Replication - Functional Work Flow

## Design

### User Experience

#### Geo-Replication Sessions

A new sub tab **Geo-Replication** will be added to the **Volumes** main tab in oVirt webadmin UI which will list all the geo-replication sessions for the selected volume. Geo-Replication Sessions subtab also provides actions for

*   Creating a new geo-replication session
*   Starting a geo-replication session
*   Stopping a geo-replication session
*   View details of a geo-replication session, this includes the list of individual geo-replication session and their respective status
*   Update configurations for a geo-replication session
*   Removing an existing geo-replication session

![](Georepsession1list.png "Georepsession1list.png")

#### Create a new Geo-Replication Session

The below dialog captures the details and creates the geo-replication session between source and destination gluster volumes.

![](Georepsession2new.png "Georepsession2new.png")

The user can manually enter the **Volume** or click on **Show Volumes** to fetch the list of existing volumes in the destination cluster and select a volume from that list.

![](Georepsession2newvolumes.png "Georepsession2newvolumes.png")

#### Start a new Geo-Replication Session

A new action named **Start** will be shown in the **Geo-Replication** tab, which will start the selected geo-replication session(s).

#### Stop a Geo-Replication Session

A new action named **Stop** will be shown in the **Geo-Replication** tab, which will stop the selected geo-replication session(s).

#### Remove a Geo-Replication Session

A new action named **Remove** will be shown in the **Geo-Replication** tab, which will remove the selected geo-replication session(s).

#### Configuration Options for Geo-Replication Session

The below dialog fetches and lists the default values of all the configurations for a geo-replication session. It provides and option to change the values of the configurations. User can change the values of the configuration properties any point of time after creating the geo-replication session. The geo-replication session will be restarted automatically if the user changes any configuration when the session is already started.

![](Georepsession3config.png "Georepsession3config.png")

#### Geo-Replication Session Details

With the distributed geo-replication, when a geo-replication session is created for a volume, internally more than one session will be created depends on the type of the volume and where bricks are residing. This view will list all the individual sessions, their status and Up time. Additionally this will also contain the detailed status of the geo-replication session.

![](Georepsession4details.png "Georepsession4details.png")

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterGeoReplication> for detailed design of the feature.

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

<http://www.gluster.org/community/documentation/index.php/GlusterFS_Geo_Replication>

<http://gluster.org/community/documentation/index.php/Gluster_3.2:_Starting_GlusterFS_Geo-replication>

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/Gluster_Geo_Replication>

## Open Issues

*   Currently it is not possible to detect a volume is being used as a destination for a geo-replication session
    -   UUID of the source volume can retrieved from the gluster, but its not possible to determine which source cluster it belongs to.

<Category:Feature>

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

### User Experience

#### Listing the Geo-Replication Destinations

A new sub-tab named "Geo-Replication Destinations" will be added to Clusters. All existing geo-replication destinations attached to the cluster will be show for the cluster along with their status. It also provides options for adding/removing destination clusters.

![](Georepdest1list.png "Georepdest1list.png")

A short description for the columns in the above table

*   **Destination Cluster Host** - FQDN or IP of a host which is part of the destination/remote cluster
*   **Password less communication verification** - Able to communicate with the **Destination Cluster Host** without any password from one of the host in the source cluster. This could be **Unknown** if there were no password less communication verfication happened before.
*   **Total no.of sessions** - No.of Geo-Replication sessions created from the source cluster to destination cluster
*   **No.of Stable Sessions** - No.of Geo-Replication sessions in stable state between source and destination clusters
*   **No.of Faulty Sessions** - No.of Geo-Replication sessions in faulty or problematic between source and destination clusters

#### Add a new Destination Cluster

Password less SSH communication should be enabled between one host of the source cluster and one host of destination cluster before creating a geo-replication session between the identified source and destination clusters. The below dialog "New Geo-Replication Destination" would capture the required details for adding a new destination cluster.

![](Georepdest2new.png "Georepdest2new.png")

The user needs to select the **Fingerprint Verified** before submitting the details. This is to make sure the connection is not established with a malicious host.

#### Remove a Geo-Replication Destination

The user can select the Geo-Replication destination which needs to be removed and click on **Remove** action to remove it. Removing a geo-replication session is allowed only if doesn't have any geo-replication sessions configured.

#### Re-establish password less communication with destination host

The below dialog provides a mechanism for re-establishing a broken password less communication between source and destination cluster hosts. It captures the details again and enables password less communication between a host of source cluster and a host of destination cluster.

![](Georepdest3reestablish.png "Georepdest3reestablish.png")

#### View Geo-Replication Sessions

List of the geo-replication sessions created from the source to destination cluster will be shown in the following dialog. The status of the respective sessions will be show as well. The user can click on **Re-start** button to re-start a geo-replication session which is in faulty state.

![](Georepdest4sessions.png "Georepdest4sessions.png")

#### Test password less communication

Testing/Verifying the password less communication from (one host of) the source cluster to (one host of the) destination cluster can be done by selecting a geo-replication destination and clicking the **Test Communication** action. After the verification process is completed, the **Password less communication verification** field of the selected destination will be changed to either **Success** or **Failed**.

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

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterGeoReplication> for detailed design of the feature.

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

<http://www.gluster.org/community/documentation/index.php/GlusterFS_Geo_Replication>

<http://gluster.org/community/documentation/index.php/Gluster_3.2:_Starting_GlusterFS_Geo-replication>

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/Gluster_Geo_Replication>

## Open Issues

<Category:Feature>

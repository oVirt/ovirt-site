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
*   Last updated date: Thu Jan 17 2013

## Detailed Description

GlusterFS Geo-replication uses a master–slave model, whereby replication and mirroring occurs between the following partners:

*   Master – A GlusterFS volume
*   Slave – A GlusterFS Volume in a remote cluster

With this feature the user will be able to

*   View all active/inactive geo-replication sessions in the cluster
*   Setup a new ge-replication session
*   Start a geo-replication session
*   Stop a geo-replication session
*   Remove an inactive geo-replication session
*   Setup password less SSH between one of the hosts in the cluster and remote host
*   View and update the configuration before starting the session or later (ssh command, gsync command)
*   Monitor the status of geo-replication sessions in a cluster

## Design

Geo-replication feature is designed to enable creation and maintenance of geo-replication sessions across clusters in GlusterFS. A geo-replication session can be setup between a GlusterFS managed master cluster and remote (slave) GlusterFS managed cluster.

### Entity Description

#### Geo Replication Slave

This entity stores the details of remote (slave) for a geo-replication setup.

*   Master Cluster Id
*   Master Host Id
*   Slave Host IP

#### Gluster Geo Replication

This entity stores the details of the individual geo-replication sessions

*   Master Cluster Id
*   Master Host Id
*   Slave Host IP
*   Master Volume Name
*   Slave Volume Name

#### Gluster GEo Replication Status

This entity stores the status of individual geo-replication sessions maintained in oVirt engine

*   Master Cluster Id
*   Master Host Id
*   Master Volume Name
*   Slave Host IP
*   Slave Volume Name
*   Status - Valid values from GlusterGeoRepStatus
    -   Stable
    -   Faulty
    -   Initializing
    -   Not Started

### User Experience

#### Setting up Password less SSH

Password less SSH communication should be enabled between one node of the master cluster and one node of remote (slave) cluster before creating a geo-replication session between the identified master and slave clusters. If the Password less SSH communication failed between the hosts at the time of starting the geo-replication session, the following dialog will be shown.

![](Geo-Replication-Start-SSH-Setup.png "Geo-Replication-Start-SSH-Setup.png")

The user will be given two choices

*   **Use a different private key** by providing the location of the key file. Password less SSH communication will be verified using this private key file.

(or)

*   Provide the password of the user in remote host which is entered in the [Geo-Replication-Start](:File:Geo-Replication-Start.png) dialog to setup password less SSH.

#### Create a new Geo-Replication Session

<TBD>

#### View All Geo-Replication Sessions

A new sub tab will be added to the Volumes main tab in oVirt webadmin UI which will list all the geo-replication sessions for the selected volume.

#### Start a new Geo-Replication Session

A new action named **Start** will be shown in the **Geo-Replication** tab. On clicking of the action will open the following dialog.

![](Geo-Replication-Start.png "Geo-Replication-Start.png")

*   **Start Geo-Replication from Host** field will list all the servers in the cluster which are in **UP** state. When the user selects one of the host, SSH Fingerprint of the host will be fetched and shown.
*   **Remote Host** could be either a standalone machine or part of another cluster.
*   **Remote Volume/Path** will accept either name of a volume in a remote cluster or a directory in the remote host. If it doesn't starts with **/**, it will be considered as a volume in the remote cluster.
*   After providing all the details and when the user clicks **Ok**,
    -   Password less SSH communication between the origin host and **Remote Host** will be verified.
    -   If that succeeded, the geo-replication session for the selected volume started
    -   Else the [Passwordless SSH Setup](:File:Geo-Replication-Start-SSH-Setup[.png) dialog will be shown.
*   If the user wants to override the default configuration, he/she can deselect **Use Default** checkbox and provide different configuration. In this case no password less SSH verification will be made.

#### Stop a Geo-Replication Session

<TBD>

#### Remove a Geo-Replication Session

<TBD>

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

<http://www.gluster.org/community/documentation/index.php/GlusterFS_Geo_Replication>

<http://gluster.org/community/documentation/index.php/Gluster_3.2:_Starting_GlusterFS_Geo-replication>

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/Gluster_Geo_Replication>

## Open Issues

<Category:Feature>

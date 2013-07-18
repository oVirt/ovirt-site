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

*   View all the slaves attached to a cluster
*   Add a new slave and enable password less communication between a host of master cluster and a host of slave cluster
*   Test password less communication to slave cluster/host
*   Remove(Detach) a slave cluster
*   View all active/inactive geo-replication sessions for a volume
*   Setup a new ge-replication session
*   Start a geo-replication session
*   Stop a geo-replication session
*   Remove an inactive geo-replication session
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
*   Slave SSH Key Fingerprint

#### Gluster Geo Replication

This entity stores the details of the individual geo-replication sessions

*   Master Cluster Id
*   Master Host Id
*   Slave Host IP
*   Master Volume Name
*   Slave Volume Name

#### Gluster Geo Replication Status

This entity stores the status of individual geo-replication sessions maintained in oVirt engine

*   Master Cluster Id
*   Master Host Id
*   Master Volume Name
*   Slave Host IP
*   Slave Volume Name
*   Status - Valid values from GlusterGeoRepStatus
    -   STABLE
    -   FAULTY
    -   INITIALIZING
    -   NOT_STARTED

#### Geo Replication Config

This entity stores the configuration details of a geo-replication session

*   Config Name
*   Config Value

Configuration details would be maintained under a generic configuration maintenance system. Details captured as part of the same are -

*   Configuration Category - Broadly divides the configuration in categories like Gluster Geo-Replication, Gluster Volume Options etc.
*   Configuration Sub Category - Next level of logical grouping of configurations e.g. generic, logging, session etc in case of Configuration category as Gluster Geo-Replication
*   Configuration Name - Name of the configuration
*   Configuration Value - Value of the configuration

Valid configuration categories would be maintained as an enum GlusterConfigurationTypes. Valid configuration sub categories would be maintained as an enum GlusterConfigurationSubTypes. This enum maintains enclosing main configuration category as a parameter.

### User Experience

#### All the existing Slaves

A new sub-tab will be introduced under Cluster tab which would list all the existing geo-replication slaves for the current cluster. It also provides options for creation or new slaves and removal of the slaves. Testing the validity/availability of a slave is possible using the action "Test". Administrator can re-establish a broken master/slave communication as well using the action "Re-establish".

![](geo_replication_slave2_subtab.png "geo_replication_slave2_subtab.png")

#### Add/Attach a new Slave Cluster

Password less SSH communication should be enabled between one node of the master cluster and one node of slave cluster before creating a geo-replication session between the identified master and slave clusters. The below dialog "New Geo-Replication Slave" would capture the required details for adding a new slave cluster for geo-replication session.

![](geo_replication_slave1_new.png "geo_replication_slave1_new.png")

If the user select the **Copy master cluster hosts public keys to slave cluster** then the following steps will happen

*   `gluster system:: execute gsec_create` command will be executed in one of the hosts of the Master cluster. This will create a public key file, which will have the public keys of all the hosts of the Master cluster
*   Public key file will be copied to the Slave host (through password less ssh)
*   `gluster system:: execute add_secret_pub` command is used to distribute the public file to all the hosts of the Slave Cluster
*   Now all the hosts of the Master cluster can initiate geo sync task in the hosts of the slave cluster

#### Re-establish password less communication with slave host

The below dialog provides a mechanism for re-establishing a broken master/slave communication between master and slave clusters. It captures the details again and re-establishes the communication between master and slave cluster.

![](geo_replication_slave3_reestablish.png "geo_replication_slave3_reestablish.png")

#### View All Geo-Replication Sessions

A new sub tab will be added to the Volumes main tab in oVirt webadmin UI which will list all the geo-replication sessions for the selected volume. It also provides actions for -

*   Creation of new geo-replication sessions between master and slave gluster volumes
*   Removal of an existing ge-replication session
*   Starting a geo-replication session
*   Stopping a geo-replication session
*   Update configurations for a geo-replication session

![](volume_georeplication2_subtab.png "volume_georeplication2_subtab.png")

#### Create a new Geo-Replication Session

The below dialog captures the details and creates the geo-replication session between master and slave gluster volumes.

![](volume_georeplication1_new.png "volume_georeplication1_new.png")

#### Start a new Geo-Replication Session

A new action named **Start** will be shown in the **Geo-Replication** tab

#### Stop a Geo-Replication Session

A new action named **Stop** will be shown in the **Geo-Replication** tab

#### Remove a Geo-Replication Session

A new action named **Remove** will be shown in the **Geo-Replication** tab

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

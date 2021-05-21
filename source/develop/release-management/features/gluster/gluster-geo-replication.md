---
title: Gluster Geo Replication
category: feature
authors:
  - kmayilsa
  - sahina
  - sandrobonazzola
  - shtripat
---

# Gluster Geo Replication

## Summary

This feature allows the administrator to create, start, stop and monitor geo-replication for Gluster volumes from oVirt engine. With this the administrator can view the status of geo-replication sessions on Gluster volumes and also would be able to start/stop the geo-replication sessions. GlusterFS geo-replication provides a continuous, asynchronous, distributed and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

To read more about GlusterFS geo-replication, see <https://docs.gluster.org/en/latest/Administrator%20Guide/Geo%20Replication/>.

## Owner

*   Feature owner: Sahina Bose <sabose@redhat.com>
    -   GUI Component owner: Anmol Babu <anbabu@redhat.com>
    -   Engine Component owner: Sahina Bose <sabose@redhat.com>
    -   VDSM Component owner: Darshan N <ndarshan@redhat.com>
    -   QA Owner: TBD

## Current Status

*   Status: Complete
*   Last updated date: ,

## Detailed Description

GlusterFS Geo-replication uses a Source–Destination model, whereby replication and mirroring occurs between the following partners:

*   Source – A GlusterFS volume
*   Destination – A GlusterFS Volume in a remote cluster

With this feature the user will be able to

*   View all geo-replication sessions for a volume
*   Setup a new ge-replication session
*   Start a geo-replication session
*   Stop a geo-replication session
*   Remove an inactive geo-replication session
*   View and update the configuration before starting the session or later (ex: change detector)
*   Monitor the status of geo-replication sessions

## Design

### User Experience

The following section goes through the user flows associated with the feature.

#### Geo-Replication Sessions

A new sub tab **Geo-Replication** will be added to the **Volumes** main tab in oVirt webadmin UI which will list all the geo-replication sessions for the selected volume. Geo-Replication Sessions subtab also provides actions for

*   Creating a new geo-replication session
*   Starting a geo-replication session
*   Stopping a geo-replication session
*   View details of a geo-replication session, this includes the list of individual geo-replication session and their respective status
*   Update configurations for a geo-replication session
*   Removing an existing geo-replication session

**In the Volumes main tab, the following changes will be added**

*   Geo-replication --> New Session menu item will be added in the Menu bar
*   an icon will be introduced to indicate if geo-replication has been set up for the volume. Clicking on the icon will activate the geo-replication sub-tab (that is, bring it to focus)

From this sub tab, the user can view all the remote volumes (destination) where this volume is being replicated to as shown below:

![](/images/wiki/Georepsession1list.png)

If there are no sessions that are setup, the Geo-replication sub-tab will have only the New button enabled.

*   If the volume is a destination for another volume, there will be another icon to indicate this. Clicking on this icon will show a pop-up which will the source volume details. (Mockup to be added)

#### Create a new Geo-Replication Session

To set up geo-replication session, the user will click on New from the Geo-replication sub tab. User can also click on the menu item Geo-replication --> New Session from the Volume main tab. Geo-replication sessions can only be setup for online volumes. If a user tries to create a session for a volume that is not online, an appropriate error message is displayed to the user.

The below dialog captures the details and creates the geo-replication session between source and destination gluster volumes.

*   User will be shown a pre-filtered list of clusters
    -   Clusters other than the one in which source volume belongs to (aka. source cluster)
    -   Clusters which have gluster service enabled
    -   Clusters which have compatibility version equal to source cluster
*   Once user chooses a cluster, list of filtered volumes are displayed to the user.
    -   Volumes that are online
    -   Volumes that have capacity greater or equal to source volume
    -   Volumes that are not used as destination for any other geo-replication session
    -   Volumes that do not have data stored
*   Once the volume is selected, list of hosts from which the session will be created is shown to the user.
    -   Hosts that the selected volume has bricks on, and are part of the cluster
*   To set up geo-replication as non-root user, user has to provide the user name

<!-- -->

*   User can choose to provide a volume outside of this list. In this case "force" checkbox will be provided at the top of the dialog. This presents a list of unfiltered clusters and volumes.
    -   Once a user selects a cluster and a volume, a warning text of unmet criteria is displayed to the user.
    -   For instance, if a user selects a cluster with a different compatibility version and a destination volume with lesser capacity, then the text will read:

<!-- -->

    Warning!  Recommendations for geo-replication not met
    1) Cluster is not compatible
    2) Volume has lesser capacity
    Do you wish to continue?

*   User has the option to start the session automatically once created. A check box will be provided to do that.

Once the user, clicks on create -

*   Passwordless ssh session will be setup between the nodes of the destination volume and the slave volume. The system will randomly pick one of the hosts of the source volume to generate the ssh key.
*   Geo-replication session will be created
*   If force option was checked in the UI, the session create command is invoked with a force override.

![](/images/wiki/New.png)

#### Start a new Geo-Replication Session

A new action named **Start** will be shown in the **Geo-Replication** tab, which will start the selected geo-replication session(s).

#### Stop a Geo-Replication Session

A new action named **Stop** will be shown in the **Geo-Replication** tab, which will stop the selected geo-replication session(s).

#### Remove a Geo-Replication Session

A new action named **Remove** will be shown in the **Geo-Replication** tab, which will remove the selected geo-replication session(s).

#### Configuration Options for Geo-Replication Session

The below dialog fetches and lists the default values of all the configurations for a geo-replication session. It provides an option to change the values of the configurations. User can change the values of the configuration properties at any point of time after creating the geo-replication session. The geo-replication session will be restarted automatically if the user changes any configuration when the session is already started.

![](/images/wiki/Georepsession3config.png)

#### Geo-Replication Session Details

With the distributed geo-replication, when a geo-replication session is created for a volume, internally geo-rep process will be running on each of the nodes where the bricks are residing. This view will list all the individual nodes, their status and Up time. Additionally this will also contain the detailed status for each node

![](/images/wiki/Georepsession4details.png)

### Limitations

*   Cascaded viewing is not available. (Sometimes a volume can be used as both source as well as destination)

Refer the URL: [Features/Design/GlusterGeoReplication](/develop/release-management/features/gluster/glustergeoreplication.html) for detailed design of the feature.

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

<https://docs.gluster.org/en/latest/Administrator%20Guide/Geo%20Replication/>



## Open Issues

*   Currently it is not possible to detect a volume is being used as a destination for a geo-replication session
    -   UUID of the source volume can retrieved from the gluster, but its not possible to determine which source cluster it belongs to.

[Gluster Geo Replication](/develop/release-management/features/) [Gluster Geo Replication](Category:oVirt 4.0 Proposed Feature)

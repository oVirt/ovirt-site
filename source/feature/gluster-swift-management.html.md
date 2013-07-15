---
title: Gluster Swift Management
category: feature
authors: kmayilsa, knarra, sahina, shtripat
wiki_category: Feature
wiki_title: Features/Gluster Swift Management
wiki_revision_count: 23
wiki_last_updated: 2013-07-24
---

# Gluster Swift Management

### Summary

This feature allows the administrator to manage the gluster swift related services and configuration from oVirt Engine. With this the administrator can view gluster swift status in the cluster as well as on each host/server. Administrator will be able to start/stop gluster swift service across the servers in a cluster or on each server.

To read more about gluster swift integration, see <http://www.gluster.org/community/documentation/index.php/GlusterFS_Swift>

### Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner: Aravinda V K <avishwan@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

### Current Status

*   Status: In Development
*   Last updated: ,
*   Planned for future : Gluster Swift configuration

### Design

Gluster Swift Services Management has been designed to manage any group of services belonging to a service type. For instance, the Service Type for Gluster Swift is GLUSTER_SWIFT and the services are gluster-swift-proxy, gluster-swift-container, gluster-swift-object and gluster-swift-account.

#### Entity Description

##### Service Type

An enum of supported Service Type. Currently only GLUSTER_SWIFT.

##### Gluster Service

This is the master list of supported services in the cluster and will be populated as part of installation or upgrade.

*   ServiceType - Type of service
*   serviceName - Name of service

##### Gluster Server Service

This entity stores the status of individual services on a server in the cluster

*   serviceType - Type of service
*   serviceName - Name of service
*   serverId - Refers the VDS server
*   status - Valid value from GlusterServiceStatus
    -   RUNNING (UP)
    -   STOPPED(DOWN)
    -   PARTIALLY_UP - services are running only in some hosts
    -   NOT_INSTALLED - SWIFT is not installed in the host
    -   UNKNOWN - error in fetching the service status
*   message - stores the message returned from VDS command when querying for service status on a server

#### User Experience

Administrator can view the status of SWIFT in the cluster from the Cluster -> General tab. The service status from all servers in the cluster is aggregated and shown as either UP/DOWN/PARTIALLY_UP/NOT_INSTALLED/UNKNOWN .

*   RUNNING - indicates that all Gluster_SWIFT related services are running in all servers in the cluster
*   STOPPED - indicates that all Gluster_SWIFT related services are stopped in all the servers in the cluster
*   PARTIALLY_UP - indicates that Gluster_SWIFT related services maybe running in some of the servers
*   NOT INSTALLED - indicates that SWIFT is not installed in the servers
*   UNKNOWN - indicates unable to fetch any information about the swift services

##### Status Mapping

![](GlusterSwift-StatusMapping.png "GlusterSwift-StatusMapping.png")

##### Cluster General Subtab

![](GlusterSwift-ClusterStatus.png "GlusterSwift-ClusterStatus.png")

##### Manage Gluster Swift Services

![](GlusterSwift-ClusterManage.png "GlusterSwift-ClusterManage.png")

From the Servers view, clicking on server will show a Gluster SWIFT sub tab. This will list all services of GLUSTER_SWIFT service type along with the status for that server. Administrator can choose to start/stop the GLUSTER_SWIFT service from this tab.

##### Host Gluster Swift Subtab

![](GlusterSwift-HostManage.png "GlusterSwift-HostManage.png")

#### Installation/Upgrade

#### User work-flows

#### Events

Periodic sync job will report if service status changes in a server.

### Dependencies / Related Features and Projects

### Documentation / External references

*   <http://www.gluster.org/community/documentation/index.php/GlusterFS_Swift>
*   <http://www.gluster.org/community/documentation/index.php/Arch/Understanding_Swift_Integration>

### Comments and Discussion

<http://www.ovirt.org/wiki/Talk:Features/Gluster_Swift_Management>

### Open Issues

### Test Cases

*   Verify UNKNOWN state of a cluster SWIFT Services by aggregation from all the servers.
    -   Click on the cluster which is empty i.e. which does not have any nodes as a part of it.
    -   Verify that under the clusters general sub tab the status will be shown "UNKNOWN".

<!-- -->

*   Verify NOT_INSTALLED state of a cluster SWIFT Services by aggregation from all the servers.
    -   Should have a cluster created and nodes attached to it.(NOTE :Gluster SWIFT will not be installed for the states being tested.)
    -   Go to clusters tab.
    -   Verify that for the following cases, Status under cluster general tab should be shown "NOT_INSTALLED".(Assuming that we have two servers in the cluster)

    1.  Gluster Swift Services NOT_INSTALLED in server1 and server2.
    2.  Gluster Swift ServicesNOT_INSTALLED in server1 and UNKNOWN in server2.(Unknown state can be seen by making an server go into non responsive state).

<!-- -->

*   Verify Partially UP state of a cluster SWIFT Services by aggregation from all the servers.
    -   Go to Clusters tab.
    -   Verify that Cluster general tab shows the status as "partially up" state in the following cases:(Assuming that we have two servers in the cluster)

    1.  Gluster Swift services in Server1 up and in server 2 down.
    2.  Gluster Swift services Server1 up and server2 partiallyup.
    3.  Gluster Swift Services in Server1 up and Server2 not installed.
    4.  Gluster Swift Services in Server1 up and Server 2 UNKNOWN.
    5.  Gluster Swift Services n Server1 Down and Server 2 Partially up.
    6.  Gluster Swift Services in Server1 and Server 2 are Partially UP.
    7.  Gluster Swift Services in Not installed and Server 2 are Partially UP.
    8.  Gluster Swift Services in UNKNOWN and Server 2 are Partially UP.

Note :Unknown state can be seen by making an server go into non responsive state, i.e by stopping vdsm.

*   Verify UP state of a cluster SWIFT Services by aggregation from all the servers.
    -   Click on the cluster which has nodes present in it.
    -   Click on the Manage button which is present in Cluster Genera tab.
    -   Click on the start radio button of SWIFT Service Type for all the servers which are present in the cluster in the Manage Gluster Swift Popup.
    -   Click on OK button.
    -   Verify that under the clusters general sub tab the status will be shown "UP".

<!-- -->

*   Verify Down state of a cluster SWIFT Services by aggregation from all the servers.
    -   Click on the cluster which has nodes present in it.
    -   Verify that Gluster Swift services status goes "DOWN" state in the following cases(Assuming that there are two servers in the cluster)

    1.  Gluster Swift Services in Server1 and Server2 all the services are stopped.
    2.  Gluster Swift Services are stopped in server1 and server2 services are NOT_INSTALLED
    3.  Gluster Swift Services are stopped in server1 and server2 services are UNKNOWN.

<!-- -->

*   Validate messages while starting/stopping/restarting swift at server level.
    -   click on the cluster which has nodes present in it.
    -   click on the any one of the server which is present in the cluster
    -   Go to GlusterSwift Subtab.
    -   Click on Start Swift link and verify for the message "SWIFT services started on <Nodename> on cluster <Cluster Name>."
    -   Click on Stop Swift link and verify for the message "SWIFT services stopped on <NodeName> on cluster <ClusterName>."
    -   Click on Restart Swift link and verify for the message " SWIFT services re-started on <NodeName> on cluster <ClusterName>."

<!-- -->

*   Verify Restarting of Swift Services at server level.
    -   Click on the cluster which has servers present in it.
    -   Click on the server in which Gluster Swift Services needs to be restarted.
    -   Go to Gluster Swift Sub tab.
    -   Click on the Restart Swift link .
    -   Verify that Status column of all the services shows "UP" .
    -   Verify for the following message for all the services present in the server.

    1.  Status of service <Service Type> on server <server Name> changed from Down to Up. Updating in engine now.

<!-- -->

*   Verify Stop Swift Services at server level.
    -   Click on the cluster which has servers present in it.
    -   Click on the server in which Gluster Swift Services needs to be restarted.
    -   Go to Gluster Swift Sub tab.
    -   Click on the Stop Swift link .
    -   Verify that Status column of all the services shows "Down" .
    -   Verify for the following message for all the services present in the server.

    1.  Status of service <Service Type> on server <server Name> changed from Up to Down. Updating in engine now.

<Category:Feature>

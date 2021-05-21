---
title: Gluster Swift Management
category: feature
authors:
  - kmayilsa
  - knarra
  - sahina
  - shtripat
---

# Gluster Swift Management

## Summary

This feature allows the administrator to manage the gluster swift related services and configuration from oVirt Engine. With this the administrator can view gluster swift status in the cluster as well as on each host/server. Administrator will be able to start/stop gluster swift service across the servers in a cluster or on each server.

To read more about gluster swift integration, see <https://github.com/gluster/gluster-swift/blob/master/doc/markdown/quick_start_guide.md>

## Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner: Aravinda V K <avishwan@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Deprecated/ On hold
*   Last updated: ,
*   Available In : NA

## Design

Gluster Swift Services Management has been designed to manage any group of services belonging to a service type. For instance, the Service Type for Gluster Swift is GLUSTER_SWIFT and the services are gluster-swift-proxy, gluster-swift-container, gluster-swift-object and gluster-swift-account.

### Entity Description

#### Service Type

An enum of supported Service Type. Currently only GLUSTER_SWIFT.

#### Gluster Service

This is the master list of supported services in the cluster and will be populated as part of installation or upgrade.

*   ServiceType - Type of service
*   serviceName - Name of service

#### Gluster Server Service

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

### User Experience

Administrator can view the status of SWIFT in the cluster from the Cluster -> General tab. The service status from all servers in the cluster is aggregated and shown as either UP/DOWN/PARTIALLY_UP/NOT_INSTALLED/UNKNOWN .

*   RUNNING - indicates that all Gluster_SWIFT related services are running in all servers in the cluster
*   STOPPED - indicates that all Gluster_SWIFT related services are stopped in all the servers in the cluster
*   PARTIALLY_UP - indicates that Gluster_SWIFT related services maybe running in some of the servers
*   NOT INSTALLED - indicates that SWIFT is not installed in the servers
*   UNKNOWN - indicates unable to fetch any information about the swift services

#### Status Mapping

![](/images/wiki/GlusterSwift-StatusMapping.png)

#### Cluster General Subtab

![](/images/wiki/GlusterSwift-ClusterStatus.png)

#### Manage Gluster Swift Services

![](/images/wiki/GlusterSwift-ClusterManage.png)

From the Servers view, clicking on server will show a Gluster SWIFT sub tab. This will list all services of GLUSTER_SWIFT service type along with the status for that server. Administrator can choose to start/stop the GLUSTER_SWIFT service from this tab.

#### Host Gluster Swift Subtab

![](/images/wiki/GlusterSwift-HostManage.png)

### Installation/Upgrade

### User work-flows

### Events

Periodic sync job will report if service status changes in a server.

## Dependencies / Related Features and Projects

## Testing

### Prerequisites

1.  Engine - setup with Gluster or Both application mode, in order to create clusters with gluster service enabled.
2.  Two or more servers to be added to cluster. The servers should have the gluster repo added so that while engine bootstraps host, the gluster rpms can be installed.
3.  Install gluster-swift rpms and memcached if they are not already installed.
4.  start the swift service by using the command "swift-init main start"
5.  start the memcached service by using the command "service memcached start"

### Test Cases

*   Verify Swift Status at cluster level.
    -   Should have a cluster with "gluster service" enabled created and servers attached to it.
    -   Should have gluster-swift package installed on the servers.
    -   Click on the clusters tab and select the cluster to see the status.
    -   Verify that in the General sub tab of a cluster, Gluster Swift status will be shown "DOWN" by default.

<!-- -->

*   Verify swift status at server level.
    -   Should have a cluster with "gluster service" enabled created and servers attached to it.
    -   Should have gluster-swift package installed on the servers.
    -   Click on the servers tab.
    -   Go to Gluster Swift tab.
    -   Verify that the following services are listed with status of the services as "Down":

    1.  gluster-swift-account
    2.  gluster-swift-container
    3.  gluster-swift-object
    4.  gluster-swift-proxy
    5.  memcached

<!-- -->

*   Verify start Swift at cluster level
    -   Should have a cluster with "gluster service" enabled created and servers attached to it.
    -   Click on the Clusters tab.
    -   Go to Manage link under the clusters general sub tab.
    -   Click on the Start radio button in the manage gluster swift services popup.
    -   Click on OK button.
    -   Verify for the message "SWIFT Services started on cluster `<cluster Name>`".

<!-- -->

*   Verify Stop SWIFT at cluster level
    -   Should have a cluster with "gluster service" enabled created and servers attached to it.
    -   Click on the Clusters tab.
    -   Go to Manage link under the clusters general sub tab.
    -   Click on the Stop radio button in the manage gluster swift services popup.
    -   Click on OK button.
    -   Verify for the message "SWIFT Services stopped on cluster `<cluster Name>`".

<!-- -->

*   Verify restarting of Swift at cluster level
    -   Should have a cluster with "gluster service" enabled created and servers attached to it.
    -   Click on the Clusters tab.
    -   Go to Manage link under the clusters general sub tab.
    -   Click on the Restart radio button in the manage gluster swift services in the popup.
    -   Click on OK button.
    -   Verify for the message "SWIFT Services re-started on cluster `<cluster Name>`
    -   Verify that Gluster Swift status shows as "UP" in the general subtab of cluster.

<!-- -->

*   Verify Start Swift Services at Server level.
    -   click on the cluster which has severs present in it.
    -   Click on the server in which Gluster Swift Services needs to be started.
    -   Go to Gluster Swift Sub tab.
    -   Click on the Start Swift link .
    -   Verify that Status column of all the services shows "Up" .
    -   Verify for the following message for all the services present in the server.

    1.  Status of service `<Service Type>` on server `<server Name>` changed from Up to Down. Updating in engine now.

<!-- -->

*   Verify Stop Swift Services at server level.
    -   Click on the cluster which has servers present in it.
    -   Click on the server in which Gluster Swift Services needs to be stopped.
    -   Go to Gluster Swift Sub tab.
    -   Click on the Stop Swift link .
    -   Verify that Status column of all the services shows "Down" .
    -   Verify for the following message for all the services present in the server.

    1.  Status of service `<Service Type>` on server `<server Name>` changed from Up to Down. Updating in engine now.

<!-- -->

*   Verify Restarting of Swift Services at server level.
    -   Click on the cluster which has servers present in it.
    -   Click on the server in which Gluster Swift Services needs to be restarted.
    -   Go to Gluster Swift Sub tab.
    -   Click on the Restart Swift link .
    -   Verify that Status column of all the services shows "UP" .
    -   Verify for the following message for all the services present in the server.

    1.  Status of service `<Service Type>` on server `<server Name>` changed from Down to Up. Updating in engine now.

## Documentation / External references

*   <https://github.com/gluster/gluster-swift/blob/master/doc/markdown/quick_start_guide.md>
*   <https://web.archive.org/web/20160625190027/http://www.gluster.org/community/documentation/index.php/Arch/Understanding_Swift_Integration>



## Open Issues


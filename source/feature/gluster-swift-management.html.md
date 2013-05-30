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

<Category:Feature>

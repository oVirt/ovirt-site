---
title: Gluster Support
category: feature
authors:
  - ekohl
  - rmiddle
  - sahina
  - sandrobonazzola
  - shireesh
---

# Gluster Support

## Summary

This feature provides support for provisioning and managing Gluster based storage clusters in oVirt.
Inital support was added to oVirt 3.1. glusterfs repo is available at <http://download.gluster.org/pub/gluster/glusterfs/>

## Owner

*   Feature owner: Shireesh Anjal
    -   GUI Component owner: Gilad Chaplik
    -   REST Component owner: Shireesh Anjal
    -   Engine Component owner: Shireesh Anjal
    -   VDSM Component owner: Balamurugan Arumugam <barumuga@redhat.com>
    -   QA Owner: Ujjwala Thimmaiah <ujjwala@redhat.com>

## Current Status

*   Status: Available since oVirt 3.2
*   Last updated date: ,
*   Requires : glusterfs >= 3.3

## Detailed Description

This feature will introduce the capability of creating a storage cluster based on GlusterFS from the oVirt UI. Administrator will be able to perform Gluster management fuctionality like:

*   Create a cluster with Gluster capabilities
*   Create Gluster volumes on any cluster that exposes Gluster capabilities
*   Add / remove bricks to / from Gluster volumes
*   Perform volume operations like
    -   start
    -   stop
    -   rebalance
    -   replace-brick
*   Configure volumes by setting / changing "Volume Options"
*   Monitor status of Gluster volumes and bricks

### Approach

With this feature, oVirt will start supporting multiple services exposed by the cluster. These services may require different monitoring and bootstrapping strategies for hosts of the cluster. It will also require conditionally displaying / hiding certain UI components based on the services supported by the cluster. These will be achieved by:

*   Mapping the services supported by a cluster in the database
*   Using strategy pattern for arriving at the appropriate monitoring strategy for a host based on the services exposed by it's cluster
*   Enhancing the webadmin UI to display / hide appropriate components based on services supported by the cluster in context
*   Enhancing the bootstrapping mechanism in VDSM to perform different steps based on the service(s) requested

### Entity Description

#### Gluster Volume

Gluster Volume is a new searchable entity in the system, which has following properties:

*   Volume ID
*   Cluster ID (Cluster to which the volume belongs)
*   Name
*   Type
*   Replica Count
*   Stripe Count
*   Transport Type
*   Access Protocols (list)
*   Bricks (list)
*   Options (list)

#### Gluster Brick

Brick is the building block of a volume, and has following properties:

*   Server
*   Brick Directory

#### Gluster Volume Option

An Option is a configuration on the Volume, that can fine-tune the way a Volume behaves e.g. The value of the option "auth.allow" defines the IP addresses of the client machines that should be allowed to access the Volume. It has following properties:

*   Option Key
*   Option Value

#### Cluster

The Cluster entity will be enhanced to capture information about the services it exposes. e.g. A cluster can expose

*   Virtualization Service
*   Gluster Service
*   Both

### User Interface

New tabs, nodes and screens related to Gluster will be added to the User Interface. These will be displayed only when the Cluster in context supports Gluster service. Similarly, the existing Virtualization related UI components will be displayed only if the Cluster in context supports Virtualization service. Following are the new UI components related to Gluster:

*   New tab "Gluster Volumes" at Cluster level.
*   New node "Gluster Volumes" in the system tree under the Cluster node
    -   displayed only if the cluster supports Gluster service
    -   Every Gluster Volume will be displayed as a child node under "Gluster Volumes"
*   Main tabs when user selects a Volume in the system tree
    -   General
    -   Bricks
    -   Options
    -   Permissions

Same tabs will also be displayed as sub-tabs when user selects a volume from the "Gluster Volumes" tab.

*   Actions on "Gluster Volumes" tab:
    -   New
    -   Start
    -   Stop
    -   Delete
    -   Add Bricks
    -   Remove Bricks
    -   Migrate Brick
    -   Rebalance
    -   Add Option

Except the "New" option, all others will also be available from the "Gluster Volume -> General" sub-tab

*   Actions on "Bricks" tab / sub-tab:
    -   Add Bricks
    -   Remove Bricks
    -   Migrate Brick
*   Actions on "Options" tab / sub-tab:
    -   Add
    -   Edit
    -   Reset to default (selected option)
*   New dialog boxes
    -   New Gluster Volume
    -   Add Bricks to Volume
    -   New Gluster Volume -> Choose Bricks (re-used from Volume -> Add Bricks)
    -   Migrate Brick of a Volume
    -   Add / Modify Volume Option
*   Modified screens
    -   Cluster creation screen will have two checkboxes for "Gluster" and "Virtualization", with at least one selection mandatory
    -   Gluster related events will be added to the Event Notifications subscription screen

### Audit

All operations that result in creation, modification or deletion of Gluster Volumes, and any errors that may occur during the same will be audited. The audit log messages will be available in the "Events" tab.

### Notifications

All the Gluster related events that are audited will be available to be subscribed for email notifications. A new category "GlusterVolume" will be added to the notification subscription screen with following events:

*   Gluster Volume created
*   Gluster Volume creation failed
*   Gluster Volume deleted
*   Gluster Volume deletion failed
*   Gluster Volume started
*   Gluster Volume start failed
*   Gluster Volume stopped
*   Gluster Volume stop failed
*   Brick(s) added to Gluster Volume
*   Brick(s) addition to Gluster Volume failed
*   Brick(s) removed from Gluster Volume
*   Brick(s) removal from Gluster Volume failed
*   Gluster Volume Option set
*   Gluster Volume Option set failed
*   Gluster Volume Replace Brick started
*   Gluster Volume Replace Brick start failed
*   Gluster Volume Replace Brick aborted
*   Gluster Volume Replace Brick abort failed
*   Gluster Volume Replace Brick paused
*   Gluster Volume Replace Brick pause failed
*   Gluster Volume Replace Brick committed
*   Gluster Volume Replace Brick commit failed
*   Gluster Volume Rebalance started
*   Gluster Volume Rebalance start failed
*   Gluster Volume Rebalance stopped
*   Gluster Volume Rebalance stop failed

### Host Bootstrapping (VDSM)

The host bootstrapping feature of VDSM will be enhanced to support bootstrapping based on the service(s) requested from the host.

       SELinux should be set to permissive on the node running gluster

### Roles

A new pre-defined role "Gluster Admin" will be introduced with permissions for all Gluster Management actions.

### Installation/Upgrade

When upgrading from an existing installation, all existing clusters will be mapped to only the "Virtualization" service by default.

## Benefits to oVirt

oVirt would be able to provision Gluster storage. This would also enable a tighter KVM - Gluster integration which would enable virtualization admins to leverage the scale-out storage capabilities of Gluster.

## Dependencies / Related Features and Projects

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   VDSM
*   API
*   CLI

## Documentation / External references

GlusterFS : <https://docs.gluster.org/en/latest/>



## Future Work

*   LVM Configuration - Planned in 3.6
*   Support for managing Gluster clusters in AWS environment
*   Support for Gluster Unified File and Object Storage
*   Support for Hardware RAID configuration
*   Gluster Volume monitoring with Gluster top commands
*   Gluster Volume Quota configuration
*   Gluster snapshot management - Planned in 3.6
*   Log management
*   Reporting

[Gluster Support](/develop/release-management/features/) [Gluster Support](/develop/release-management/releases/3.2/feature.html)

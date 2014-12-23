---
title: Select Network For Gluster
category: feature
authors: danken, sahina, sandrobonazzola
wiki_category: Feature|GlusterHostDiskManagement
wiki_title: Features/Select Network For Gluster
wiki_revision_count: 29
wiki_last_updated: 2015-03-19
feature_name: Select Network for Gluster traffic
feature_modules: engine,gluster
feature_status: Design
---

# Select Network For Gluster

## Summary

Currently, gluster nodes use the same network for both management traffic and gluster traffic when these nodes are managed by oVirt. The nodes use the IP address/ host name used when adding the host to oVirt for this. This causes issues as high glusterfs traffic chortles the management requests and VMs on these hosts sometimes fail to respond.

Gluster does not yet have a mechanism to specify which networks are to be used depending on the type of traffic - internal vs. others. There's a planned feature with some details here - [Gluster Split Network](http://www.gluster.org/community/documentation/index.php/Features/SplitNetwork)

With existing feature set in Gluster, the proposed solution is to separate out the glusterfs traffic at the time of adding bricks to a gluster volume. Glusterfs uses the IP address specified for the brick for all traffic related to brick on that node. So, when a host has multiple interfaces, user can choose the interface to be used while adding the brick.

**Limitations**

*   Users with existing gluster deployments cannot use this feature, as once bricks are added there's no way to change the IP address used. There's no upgrade/migration path for feature
*   If an IP address is used to add the brick, this interface cannot be changed unless brick is removed/replaced.

      Use replace-brick to achieve both of above (To be checked)

## Owner

*   Feature Owner: Sahina Bose <sabose (at) redhat (dot) com>
*   GUI Component Owner: Karnan Chidambarakani <kchidamb (at) redhat (dot) com>
*   Engine Component Owner: Sahina Bose <sabose (at) redhat (dot) com>

## Proposed User Flow

1.  Add a Network role "Storage network" and create a network with this role at cluster level
2.  Edit a host, and assign the above network to one of the host's interface.
3.  In Create Volume/ Add Brick dialog, once the host is selected to add a brick, show the list of IP addresses/host names on the host which can be used to add brick.

*   If the host has an interface with network role "Storage network", this IP address is shown by default. Otherwise the host's address is used as default.

![](AddBrickNetwork.png "AddBrickNetwork.png")

## Implementation Details

### Change to Network roles

Addition of a new Network role - Storage network

### Change to GlusterBricks entity

GlusterBricks entity will have an additional property that holds the address used to add the brick. GlusterBrick.getQualifiedName() - changes to use the IP address rather than vds.host_name

### Change to GlusterSyncJob

Update the correct IP address returned from gluster CLI output rather than mapping based on host UUID

[Category: Feature](Category: Feature) [Category: Gluster](Category: Gluster)

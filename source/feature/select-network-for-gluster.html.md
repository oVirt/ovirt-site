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

Currently, gluster nodes use the same network for both management traffic and gluster traffic when these nodes are managed by oVirt. The nodes use the IP address/ host name used when adding the host to oVirt for this. This causes issues as high glusterfs traffic chokes the management requests and VMs on these hosts sometimes fail to respond.

Gluster does not yet have a mechanism to specify which networks are to be used depending on the type of traffic - internal vs. others. There's a planned feature with some details here - [Gluster Split Network](http://www.gluster.org/community/documentation/index.php/Features/SplitNetwork)

With the existing feature set in Gluster, the proposed solution is to separate out the glusterfs traffic at the time of adding bricks to a gluster volume. Glusterfs uses the IP address specified for the brick for all traffic related to brick on that node. So, when a host has multiple interfaces, user can choose the interface to be used while adding the brick.

**Limitations**

*   Changing of existing brick's network address may cause disruption of data services in case of distributed volumes and performance degradation in case of replicate volumes

       "replace-brick commit force" will be used to achieve change in ip address of brick. (Needs to be enhanced in glusterfs to allow changing brick within same host)

## Owner

*   Feature Owner: Sahina Bose <sabose (at) redhat (dot) com>
*   GUI Component Owner: Karnan Chidambarakani <kchidamb (at) redhat (dot) com>
*   Engine Component Owner: Sahina Bose <sabose (at) redhat (dot) com>

## Proposed User Flow

### Select network in Add brick

1. Add a Network role "Storage network" and create a network with this role at **Cluster** level. This network role should be available only from cluster version 3.6 (possible?)

![](ManageGlusterNw.png "ManageGlusterNw.png")

2. Edit a host, and assign the above network role to one of the host's interface.

![](SetupHostGlusterNw.png "SetupHostGlusterNw.png")

3. In Create Volume/ Add Brick dialog, once the host is selected to add a brick, the IP address from the interface in above step is used to add brick.

*   If the host has no interface with network role "Storage network", the host's address is used.

There's no change to the existing user interface for Add Brick.

*   Ensure that network with storage network role cannot be removed from cluster if it is used

### Change network used by brick

1.  Provide an edit brick - where user can pick an IP address. This will call the "replace-brick commit force". **Disruption in service may occur for distributed volumes as the brick process will be restarted. For replicated volumes, there might be a performance degradation.**

![](Edit brick.png "Edit brick.png")

User should be provided an option to change IP address for all bricks on a host. This would be available under "Bricks" sub-tab of host. This will recursively call the "replace-brick commit force" for each of the bricks selected

![](EditBricks.png "EditBricks.png")

## Implementation Details

### Change to Network roles

Addition of a new Network role - Storage network

### Change to GlusterBricks entity

GlusterBricks entity will have an additional property that holds the address used to add the brick. GlusterBrick.getQualifiedName() - changes to use the IP address rather than vds.host_name

### Change to GlusterSyncJob

Update the correct IP address returned from gluster CLI output rather than mapping based on host UUID

[Category: Feature](Category: Feature) [Category: Gluster](Category: Gluster)

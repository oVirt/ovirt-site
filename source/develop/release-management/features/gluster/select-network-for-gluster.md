---
title: Select Network For Gluster
category: feature
authors:
  - danken
  - sahina
  - sandrobonazzola
---

# Select Network For Gluster

## Summary

Currently, gluster nodes use the same network for both management traffic and gluster traffic when these nodes are managed by oVirt.
The nodes use the IP address/ host name used when adding the host to oVirt for this.
This causes issues as high glusterfs traffic chokes the management requests and VMs on these hosts sometimes fail to respond.

Gluster does not yet have a mechanism to specify which networks are to be used depending on the type of traffic - internal vs. others.
There's a planned feature with some details here - [Gluster Split Network](https://web.archive.org/web/20160628142018/http://www.gluster.org/community/documentation/index.php/Features/SplitNetwork)

With the existing feature set in Gluster, the proposed solution is to separate out the glusterfs traffic at the time of adding bricks to a gluster volume.
Glusterfs uses the IP address specified for the brick for all traffic related to brick on that node.
So, when a host has multiple interfaces, user can choose the interface to be used while adding the brick, by tagging one of the host's interface with the "Storage network" role.

In case, the user wants to continue to add brick's using host's FQDN (for instance, when they have DNS setup outside of oVirt to separate out networks),
no interfaces should be marked with the "Storage network" role.

**Limitations**

*   In case network addresses of host changes after adding a brick, changing of existing brick's network address may cause disruption of data services in case of distributed volumes and performance degradation in case of replicate volumes

       "replace-brick commit force" will be used to achieve change in ip address of brick. (Needs to be enhanced in glusterfs to allow changing brick within same host)

## Owner

*   Feature Owner: Sahina Bose <sabose (at) redhat (dot) com>
*   GUI Component Owner: Karnan Chidambarakani <kchidamb (at) redhat (dot) com>
*   Engine Component Owner: Sahina Bose <sabose (at) redhat (dot) com>

## Proposed User Flow

### Select network in Add brick

1. Add a Network role "Storage network" and create a network with this role at **Cluster** level. This network role should be available only from cluster version 3.6 (possible?)

![](/images/wiki/ManageGlusterNw.png)

2. Edit a host, and assign the above network role to one of the host's interface.

![](/images/wiki/SetupHostGlusterNw.png)

3. In Create Volume/ Add Brick dialog, once the host is selected to add a brick, the IP address from the interface in above step is used to add brick.

*   If the host has no interface with network role "Storage network", the host's address is used. This will also cater to the usecase, where users want to continue using the host FQDN to add bricks. (Users may have DNS setup to resolve host name correctly based on internal/external networks)

There's no change to the existing user interface for Add Brick.

*   Ensure that network with storage network role cannot be removed from cluster if it is used

### Change network used by brick

1.  Provide an edit brick - where user can pick an IP address. This will call the "replace-brick commit force". **Disruption in service may occur for distributed volumes as the brick process will be restarted. For replicated volumes, there might be a performance degradation.**

![](/images/wiki/Edit_brick.png)

User should be provided an option to change IP address for all bricks on a host.
This would be available under "Bricks" sub-tab of host. This will recursively call the "replace-brick commit force" for each of the bricks selected

![](/images/wiki/EditBricks.png)

## Implementation Details

### Change to Network roles

Addition of a new Network role - Storage network

### Change to GlusterBricks entity

`GlusterBricks` entity will have an additional property that holds the address used to add the brick.

*   `brickInterface`

Table gluster_volume_bricks will have an additional column. This will be populated only if brick is using storage network instead of vds.host_address to add the brick.

| Column name  | Type | Description                                                            |
|--------------|------|------------------------------------------------------------------------|
| interface_id | UUID | Nullable. Id of the host's interface. FK to id of vds_interface table  |

`GlusterBrick.getQualifiedName()` - changes to use the `brickIPAddress` property if not empty otherwise uses `VdsStatic.hostName`

### Change to GlusterSyncJob

Update the correct IP address returned from gluster CLI output rather than mapping based on host UUID

### Change to VDSM API

No change to the `GlusterVolume.addBrick` API Existing Parameters: 'data': {'volumeName': 'str', 'brickList': ['str'], '\*replicaCount': 'int', '\*stripeCount': 'int', '\*force': 'bool'}

brickList will continue to be array of strings of the form <ip adress or hostname>:<brick directory>

### Change to REST API

**POST** `/clusters/{cluster:id}/glustervolumes/{glustervolume:id}/bricks|rel=add` - NO CHANGE

GlusterBricks entity has an optional parameter where the network to be used while creating the brick can be passed. If not set, the engine will select the network appropriately

New API:

**PUT** `/clusters/{cluster:id}/glustervolumes/{glustervolume:id}/bricks/{brick:id}|rel=update`

The network to be updated for brick, is passed as a parameter in the GlusterBrickEntity

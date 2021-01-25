---
title: GlusterHostDiskManagement
category: feature
authors: bala, rnahcimu, sahina, sandrobonazzola
feature_name: Host Device Management
feature_modules: engine,gluster
feature_status: Completed
---

# Gluster Host Disk Management

## Host Device Management

### Summary

This feature enables to configure disk and storage devices in host. On Gluster cluster, this helps to identify bricks. The configuration includes

1.  identify disk and storage devices those are not having file system.
2.  create new brick by creating new Linux logical volume or expand existing brick by exapnding Linux logical volume used for the brick with those devices.
3.  format the logical volume with xfs or selected file system if necessary.
4.  update fstab entry for the logical volume.
5.  mount the logical volume.

This feature is available for newly added hosts or newly added disk and storage devices in existing hosts.

### Owner

*   Feature Owner: Balamurugan Arumugam <barumuga (at) redhat (dot) com>
*   GUI Component Owner: Ramesh Nachimuthu <rnachimu (at) redhat (dot) com>
*   Engine Component Owner: Ramesh Nachimuthu <rnachimu (at) redhat (dot) com>
*   VDSM Owner: Timothy Asir <tjeyasin (at) redhat (dot) com>
*   QA Owner:

### Current Status

*   Status: Done
*   Last Updated Date:

## Design

### Listing the Storage Devices

There will be a new sub tab with name "Storage Devices" will be added under the Hosts tab. This tab will list all the storage devices in the hosts. All free storage devices which can be provisioned to use in gluster volume will be shown in the top of the list, remaining storage devices which are already used will be shown with a lock symbol in the begging of the column as in the below screen shot.

![](/images/wiki/Storage_Devive_SubTab.png)

### Creating Brick

There will be a 'Create Brick' action available in the storage device sub to create bricks. This opens the following pop up so that user can choose the storage device with which he wants to create Brick.

![](/images/wiki/Create_Brick_Dailog.png)

Following things will happen when user clicks 'OK'.

        1. New Physical Volume(PV) will be created with the selected storage
        2. New Volume group (VG) will be created with PV created in step 1
        3. New Thin Pool will be created in the VG 
        4. New Logical Volume (LV)  will be created in the Thin Pool.
        5. LV created in step 4 will be formatted using XFS file system with the required performance configurations
        6. LV will be mounted on the folder /rhs-bricks/`<brick-name>`. 

On success of create brick action, new storage device with the brick name will appear in the storage devices list. This storage device will be shown with the mount point and this mount point can be used as brick in gluster volume.

### Extend Brick

There will be an 'Expand Brick' action available in the storage device sub to expand the existing bricks. This helps to expand the existing LV as well as the file system in the LV. This will be an online operation without any disruption to the volume using the brick.

<< TODO: Add the UI Mock up >>

### Change in Brick selection

This feature enables Gluster volume creation and add brick to existing volume more easier and meaningful by showing list of bricks of each hosts. Now user selects bricks than typing them. Below is new screen for add brick.

![](/images/wiki/new-add-brick-screen.png)

## Detailed Design

Refer the URL: [Gluster Host Disk Management Design](/develop/release-management/features/gluster/glusterhostdiskmanagementdesign.html) for detailed design of the feature.

## Dependencies / Related Features and Projects

None

## Test Cases

<< TODO >>

## Documentation / External references

<< TODO >>



## Open Issues

None

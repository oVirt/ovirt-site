---
title: GlusterHostDiskManagement
category: feature
authors: bala, rnahcimu, sahina, sandrobonazzola
wiki_category: Feature|GlusterHostDiskManagement
wiki_title: Features/GlusterHostDiskManagement
wiki_revision_count: 22
wiki_last_updated: 2015-03-19
feature_name: Host Device Management
feature_modules: engine,gluster
feature_status: In Progress
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
*   GUI Component Owner:
*   Engine Component Owner: Ramesh Nachimuthu <rnachimu (at) redhat (dot) com>
*   VDSM Owner: Timothy Asir <tjeyasin (at) redhat (dot) com>
*   QA Owner:

### Current Status

*   Status: Inception
*   Last Updated Date:

## Design

### Highlighting hosts

Hosts are highlighted to user to initiate storage configuration when storage devices with no file system are identified. This includes for existing hosts and newly added hosts. Below is the mock screen how this looks like

![](highlight-host-for-unconfigured-storage-devices.png "highlight-host-for-unconfigured-storage-devices.png")

### Initiating storage configuration

User initiates storage configuration in the UI by clicking "Configure' button on highlighted host. This opens up below work flow

1.  Ask user whether to create new brick or expand existing brick

![](new-storage-devices-found.png "new-storage-devices-found.png")

1.  On selection to create new brick, show below screen to accept inputs optionally

       * brick name
       * Storage device selections
       * Support snapshot or not
       * Optimization profile

![](create-brick.png "create-brick.png")

1.  On selection to expand existing brick, show below screen in which only storage device selection is permitted.

![](expand-brick.png "expand-brick.png")

1.  On press of 'Create'/'Expand' button, vdsm is called to do necessary job.

### Verbs exposed by VDSM

VDSM exposes below verbs to achieve this feature.

*   GlusterStorageDevicesList

<TODO: explain verb's parameters and return structure>

*   GlusterBrickCreate

<TODO: explain verb's parameters and return structure>

*   GlusterBrickExpand

<TODO: explain verb's parameters and return structure>

### Change in Brick selection

This feature enables Gluster volume creation and add brick to existing volume more easier and meaningful by showing list of bricks of each hosts. Now user selects bricks than typing them. Below is new screen for add brick.

![](new-add-brick-screen.png "new-add-brick-screen.png")

## Detailed Design

Refer the URL: <http://www.ovirt.org/Features/Design/GlusterHostDiskManagement> for detailed design of the feature.

## Dependencies / Related Features and Projects

None

## Test Cases

<< TODO >>

## Documentation / External references

<< TODO >>

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/GlusterHostDiskManagement>

## Open Issues

None

[Category: Feature](Category: Feature) [GlusterHostDiskManagement](Category:oVirt 3.6 Proposed Feature)

---
title: Gluster Arbiter Volume
category: feature
authors:
  - rnachimu
  - sahina
---

# Gluster Arbiter Volume

# Summary

Arbiter volumes are replica 3 volumes where the 3rd brick of the replica is automatically configured as an arbiter node. What this means is that the 3rd brick will store only the file name and metadata, but does not contain any data. This configuration is helpful in avoiding split-brains while providing the same level of consistency as a normal replica 3 volume. This features allows Gluster Storage Administrator to create and manage Arbiter Volumes from oVirt.

To read more about Gluster arbiter volume feature, see <https://gluster.readthedocs.org/en/release-3.7.0/Features/afr-arbiter-volumes/>

# Owner

*   Name: Ramesh Nachimuthu (Rnahcimu)
*   Email: <rnachimu@redhat.com>

# Detailed Description

Arbiter volume is a replica 3 volumes with 3rd brick being an arbiter brick. Arbiter brick will store only metadata so it will not require the same storage capacity as other bricks. In a way, it helps to get the benefits of Replica 3 (specially avoiding split-brain) volume with one arbiter brick. After introduction of this feature, user will be able to do following things from oVirt.

*   Create Gluster Arbiter Volumes
*   Sync and Manage the Arbiter Volumes created in Gluster CLI

# Design

## DB Changes

*   Add 'arbiter_count' column to gluster_volumes table. Arbiter count will be 1 in case of Arbiter volume and it will be 0 in all other cases.
*   Add 'is_arbiter' column to gluster_volume_bricks table. This will be true for arbiter bricks. Every third brick in the arbiter volume will be arbiter brick. But this can change any time.

## User Experience and control flows

### Change in Create Volume Flow

Arbiter Volume check box will be added to the Create Volume Popup and it will be shown when user creates a Replica Volume. Same check box will be added to Add Brick's pop up and it will be shown only in Create Volume flow with Replica Volume. Arbiter volume should be replica 3 volume and respective validation is added to Add Bricks popup.

![](/images/wiki/New-arbiter-volume.png)

![](/images/wiki/Add-brick-for-new-arbiter-volume.png)

### Change in Volume General Sub tab

Volume Type field in the General sub tab will be changed to Replicate (Arbiter) in case of Arbiter volume.

### Change in Remove Brick Flow

Removing arbiter brick will be disabled.

# Documentation / External references

Gluster Arbiter Volume feature - <https://gluster.readthedocs.org/en/release-3.7.0/Features/afr-arbiter-volumes/>

[ArbiterVolume](/develop/release-management/features/) [GlusterArbiterVolume](Category:oVirt 4.0 Proposed Feature)

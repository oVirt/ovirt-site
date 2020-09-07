---
title: DRBD
category: feature
authors: philipp reisner
---

# DRBD

## Summary

[DRBD](http://www.drbd.org) is a solution for linux to mirror local block devices. DRBD should get integrated into the oVirt nodes, so that it can be used instead of a SAN, or in addition to a san for providing DR.

## Owner

*   Name: Philipp Reisner (philipp_reisner)
*   Email: <philipp.reisner@linbit.com>

## Current status

*   Right now this is in planing stage. We need to discuss two possible approaches with people that are interested in that.
*   There is a perfectly working solution for 2 nodes.

## Detailed Description

There are two possible approaches to the challenge. **Right now, the "DRBD on VG level for DR only" is the preferred approach.**

### DRBD on VG level for DR only

The BlockStorageDomain class in VDSM could be adopted in a way that it accepts DRBD devices. (To my knowledge right now it only accepts devices that are visible to multipathd).

*   PRO: The integration into VDSM would be trivial. The BlockStorageDomain class needs to be modified (or a new class derived) that detects and accepts DRBD devices.
*   PRO: DRBD will be used in primary/secondary mode. All DRBD resources will be used only on one side (the active data center). Non of them will be active in the DR site.
    Only in case the primary data center fails, the resources might be active in the DR site.

Provisioning of DRBD replicated LVs will be provided by an independend project called drbdmanage. drbdmanage by itself is currently in early implementation phase. We at LINBIT will put more attention to this project and will make an early release available as soon as possible.

### DRBD on LV level

*   PRO: DRBD will be used in single primary (= primary/secondary) mode.
*   PRO: No DRBD changes needed. One can use any 8.3.x or 8.4.x release out there, readily available through many distribution channels.
*   CON: We need to implement a new sub-class of StorageDomain (or BlockStorageDomain). When creating an LV for a virtual machine it needs to put a DRBD device directly on that LV. In addition to that VDSM needs to [promote the DRBD device into primary mode](http://www.drbd.org/users-guide-8.4/s-switch-resource-roles.html) before starting a VM on it. After a VM was stopped (or migrated away) it needs to demote it into secondary mode. (During a online-migration both sides should be primary).
    As we LINBIT-guys have little knowledge about VDSM, we would welcome a few pointers by VDSM guys how to tackle that task.
    In order to get rid of the dual-primary mode during an online-migration, QEMU/KVM needs to be updated to open the backing block device late during an online-migration.
*   CON: More work on the engine is needed in order to make oVirt aware of replicated LVs

### DRBD on VG level

The BlockStorageDomain class in VDSM could be adopted in a way that it accepts DRBD devices. (To my knowledge right now it only accepts devices that are visible to multipathd).

*   PRO: The integration into VDSM would be trivial. The BlockStorageDomain class needs to be modified (or a new class derived) that detects and accepts DRBD devices.
*   CON: DRBD has to be used in [dual primary](http://www.drbd.org/users-guide-8.4/s-dual-primary-mode.html) mode.
*   CON: If the network connection of such a DRBD instance is interrupted, the virtual machines running on the two oVirt nodes will continue to modify their backing storage devices. These backing storage devices are LVs. The LVs got allocated from a PV residing on the DRBD device. So we end up with modifications on the DRBD devices on both oVirt nodes.
    As DRBD is as of today (drbd-8.4.3) it will detect that both DRBD devices where modified while the connection was down and refuse to re-establish the connection. While doing [automatic](http://www.drbd.org/users-guide-8.4/s-configure-split-brain-behavior.html#s-automatic-split-brain-recovery-configuration) or [manual](http://www.drbd.org/users-guide-8.4/s-resolve-split-brain.html) [split brain](http://www.drbd.org/users-guide-8.4/s-split-brain-notification-and-recovery.html) recovery, one will notice that DRBD allows only to do a resync in **one direction**. I.e. only the modifications of VMs running on one of the two oVirt nodes will survive (= the modifications of VMs running on the other node would be reverted by DRBD).
    This is of course not a reasonable option. Therefore we consider to implement a new split-brain recovery mechanism in DRBD.
    DRBD will do a *bidirectional resync* If the changes done by the two nodes during the outage of the replication network **does not overlap**. It will move only the modified blocks over to the node that has not yet seen these changes. (If we choose that route, it will take us a few month to do that, but we know what we are doing :))
*   CON: SANLock should not be used on top of DRBD. At this stage there is no proposal how to replace SANLock for such a setup.

### Open Questions

I got the impression that for this it is necessary that the shared device presents some kind of UUID to VDSM. VDSM uses this UUID to identify the storage instance on multiple nodes. Is that correct?

## Benefit to oVirt

A data replication technology built directly into the oVirt nodes. This for sure opens up new use cases for oVirt.

## Dependencies / Related Features

When it is clear how to integrate DRBD on the nodes, managing DRBD replication links by the web-user interface will become of interest.

## Documentation / External references

*   [DRBD documentation for 8.4.x](http://www.drbd.org/users-guide-8.4/)
*   [post copy live migration](http://wiki.qemu.org/Features/PostCopyLiveMigration)

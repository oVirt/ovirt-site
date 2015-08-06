---
title: Migration Enhancements
category: feature
authors: mpolednik, mskrivan, ofrenkel, sandrobonazzola, tjelinek
wiki_category: Feature|Migration Enhancements
wiki_title: Features/Migration Enhancements
wiki_revision_count: 112
wiki_last_updated: 2015-09-14
---

# Migration Enhancements

## Summary

The goal is to improve migration convergence, especially for large VMs.

## Details

There are three areas to improve the convergence:

*   Expose parameters available on VM level to the cluster level
*   Expose some parameters available in VDSM conf to cluster level config
*   Change logic on vdsm side

### Expose Parameters from VM Level to Cluster Level

On VM level we already have under the host the:

*   Use custom migration downtime (e.g. how long the VM can be down in the last stage of migration)
*   Use auto convergence from qemu (detect the lack of convergence and throttle down the guest)
*   Use migration compression

### Expose some parameters available in VDSM conf to cluster level config

*   Max bandwidth
*   Max timeout without convergence + action what if the timeout is reached (abort migration or turn to post-copy mode)

### Change logic on vdsm side

*   Allocate the bandwidth to the VMs according to the number of running migrations (e.g. if only one, allocate the full bandwidth, if two, allocate 50%/50%)
*   If stalling, make downtime more aggressive

## UI Changes

![](ClusterDialogMigrationPolicy.png "ClusterDialogMigrationPolicy.png")

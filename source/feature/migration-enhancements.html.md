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

On VM level we already have under the host side tab of the edit VM dialog the:

*   Use custom migration downtime (e.g. how long the VM can be down in the last stage of migration)
*   Use auto convergence from qemu (detect the lack of convergence and throttle down the guest)
*   Use migration compression

We should expose this parameters to cluster level

### Expose some parameters available in VDSM conf to cluster level config

*   Max bandwidth
*   Max timeout without convergence
*   Action when max timeout without convergence reached:
    -   Currently VDSM aborts the migration when the timeout is reached, we should add the support for choose between two actions:
        -   Abort (original behavior)
        -   Turn to post-copy mode (more risky but guaranteed to converge (or fail))

### Change logic on vdsm side

*   Allocate the bandwidth to the VMs according to the number of running migrations (e.g. if only one, allocate the full bandwidth, if two, allocate 50%/50%)
*   Don't pre-calculate the migration downtime but calculate it as a reaction to stalling. The current algorithm is:
    -   min_downtime = max_downtime / steps
    -   base = (max_downtime- min_downtime) \*\* (1 / (steps - 1))
    -   current_downtime = min_downtime + base \*\* current_step

The current_step is in range from 1 to steps -1. So the

## UI Changes

![](ClusterDialogMigrationPolicy.png "ClusterDialogMigrationPolicy.png")

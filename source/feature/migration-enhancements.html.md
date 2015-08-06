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

*   Bandwidth:
    -   Expose max bandwidth to the user (per cluster)
    -   For 1 VM allocate full bandwidth, for 2 VMs allocate 50%-50%
*   Stalling
    -   Make downtime algorithm more aggressive when stalling
    -   Expose the migration_progress_timeout and let the user to pick action if reached
        -   abort
        -   switch to post copy mode
    -   Use auto convergence from qemu

---
title: Detailed NUMA and Virtual NUMA
authors: bruceshi, jasonliao
wiki_title: Features/Detailed NUMA and Virtual NUMA
wiki_revision_count: 56
wiki_last_updated: 2014-05-06
---

# Detailed NUMA and Virtual NUMA

## Summary

This is the detailed design page for NUMA and Virtual NUMA

You may also refer to the [simple feature page](http://www.ovirt.org/Features/NUMA_and_Virtual_NUMA).

## Get Host NUMA topology

### Engine core

*   A new VDS attribute - numanodes - will be added to support this feature.
    -   Means a DB change: extend vds_dynamic to add it.
*   The attribute will hold a string in a format
    -   Format: i:c[,c]:tm:fm[;i:c[,c]:tm:fm]
        -   i: numa node number
        -   c: cpu inner numa node
        -   tm: numa node total memory
        -   fm: numa node free memory
    -   Examples
        -   0:0,1:16381:14428 => one numa node 0 has two cpus 0 1, total memory 16381, free memory 14428
        -   0:0,2,4,6,8,10,12,14:49141:46783;1:1,3,5,7,9,11,13,15:49141:46783 => first numa node 0 has 8 cpus 0 2 4 6 8 10 12 14, total memory 49141, free memory 46783; second numa node 1 has 8 cpus 1 3 5 7 9 11 13 15, total memory 49141, free memory 46783
*   Engine receives the information from VDSM xml-rpc invoke

### VDSM

### UI

## Set Guest NUMA node tuning

### Engine core

### VDSM

### UI

## Set Guest virtual NUMA topology

### Engine core

### VDSM

### UI

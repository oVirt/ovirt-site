---
title: Blank to Defaults
authors: tjelinek
category: feature
---

# Blank to Defaults

## Turn Blank to Global Defaults

### Summary

Until oVirt 3.5 the Blank template was not editable but still providing the default values. The idea here is to rename the Blank to Default, decouple it completely from a cluster and make it editable (not deletable).

### Owner

*   Name: Tomas Jelinek
*   Email: <tjelinek@redhat.com>

### Current status

*   Target Release: 3.6
*   Status: Done

### Proposal

*   The Blank template will be completely decoupled from all clusters making it possible to delete the Default DC/Cluster
*   The Blank template will still not be deletable
*   The Blank will support the highest cluster level's features and when creating a VM from it, only the applicable ones will be applied
*   Since the Blank template will be decoupled from all the clusters and usable in any cluster there will be the following limitations:
    -   Nothing which is directly related to one specific cluster will be settable there, namely:
        -   Pin to host
        -   Emulated Machine override
        -   CPU Model override
        -   Attach CD
        -   CPU Profiles
        -   OS Type since there are different OS types for different architectures
    -   Can not have any disks

### External Resources

*   [Bugzilla tracking](https://bugzilla.redhat.com/show_bug.cgi?id=1130174)

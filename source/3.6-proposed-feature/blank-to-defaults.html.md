---
title: Blank to Defaults
category: ovirt-3.6-proposed-feature
authors: tjelinek
wiki_category: oVirt 3.6 Proposed Feature
wiki_title: Features/Blank to Defaults
wiki_revision_count: 13
wiki_last_updated: 2015-10-15
---

# Blank to Defaults

## Turn Blank to Global Defaults

### Summary

Until oVirt 3.5 the Blank template was not editable but still providing the default values. The idea here is to rename the Blank to Default, decouple it completely from a cluster and make it editable (not deletable).

### Owner

*   Name: [Tomas Jelinek](User:TJelinek)
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

*   BZ: <https://bugzilla.redhat.com/show_bug.cgi?id=1130174>

[Category:oVirt 3.6 Proposed Feature](Category:oVirt 3.6 Proposed Feature) [Category:oVirt 3.6 Feature](Category:oVirt 3.6 Feature)

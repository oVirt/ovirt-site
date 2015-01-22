---
title: Blank to Defaults
authors: tjelinek
wiki_title: Features/Blank to Defaults
wiki_revision_count: 11
wiki_last_updated: 2015-04-14
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
*   Status: Design discussion

### Proposal

*   The Blank template will be renamed to Default
*   The Blank template will be completely decoupled from all clusters making it possible to delete the Default DC/Cluster
*   The Blank template will still not be deletable
*   Since the Blank template will be decoupled from all the clusters and usable in any cluster there will be the following limitations:
    -   Nothing which is directly related to one specific cluster will be settable there (e.g. pin to one specific host)
    -   It will support only the smallest cluster level's features (e.g. no VirtIO RNG device)

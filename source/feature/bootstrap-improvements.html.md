---
title: Bootstrap Improvements
category: feature
authors: alonbl
wiki_category: Feature
wiki_title: Features/Bootstrap Improvements
wiki_revision_count: 6
wiki_last_updated: 2014-07-01
---

# Bootstrap Improvements

### Summary

A complete re-write of the vdsm-bootstrap.

### Owner

*   Name: [Alon Bar-Lev](User:Alonbl)
*   Email: <alonbl@redhat.com>

### Current status

*   Done
*   Last updated date: 2012-11-28

### Detailed Description

Current bootstrap implementaiton is mainly legacy code. Too much bootstrap sequences and low control over the process.

### Benefit to oVirt

*   Lower cost of maintenance.
*   Lower cost of support.
*   vdsm-bootstrap as standalone package.
*   Two sequences
    -   Bootstrap
    -   ovirt-node upgrade
*   ovirt-node registration has no ovirt logic, just “I'm here” notification.
*   Establish a bidirectional channel between back-end and host, no iterative commands nor file transfers.
*   Manual invocation support.
*   Better timeout management.
*   Better logging.
*   Use of yum API.
*   Shorter bootstrap time.
*   More...

### Dependencies / Related Features

None.

### Documentation / External references

[bug#866889](https://bugzilla.redhat.com/show_bug.cgi?id=866889) [bug#861575](https://bugzilla.redhat.com/show_bug.cgi?id=861575) [bug#861576](https://bugzilla.redhat.com/show_bug.cgi?id=861576)

[Ovirt Host Deploy Presentation](:File:ovirt-host-deploy 3.2.pdf)

### Comments and Discussion

*   Refer to <Talk:Bootstrap_Improvements>

<Category:Feature> <Category:Template>

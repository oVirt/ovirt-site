---
title: Quota-3.2
authors: doron, lhornyak, ofri
wiki_title: Features/Quota-3.2
wiki_revision_count: 5
wiki_last_updated: 2013-01-21
---

# Quota-3.2

## SLA: Quota in 3.2

### Summary

Improving Quota which oVirt introduced in 3.1.

### Owner

*   Name: [ Ofri Masad](User:ofri)

<!-- -->

*   Email: <omasad@redhat.com>

### Current status

*   Last updated date: Oct16th 2012
*   In progress: QuotaManager refactoring - design draft
*   DB changes to support Multiple storage-domains images
*   Pending: QuotaManager refactoring - implementation
*   Pending: REST API
*   Pending: UI changes to administrator portal
*   Pending: UI changes to user portal

### Detailed Description

*   3.1 proposal: <http://wiki.ovirt.org/wiki/Features/Quota>
*   The quota feature on 3.2 would consist of two main parts:

      * Implementation changes from 3.1 - the quota consumption/release mechanism would be embedded into lower layers, in 
       order to achieve more infrastructure like behavior.
      * UI and REST API changes – 3.1 UI would be extended and the support for quota in user portal would be 
       redesigned. REST API will be added.

### Benefit to oVirt

TBD

### Dependencies / Related Features

*   TBD

### Documentation / External references

*   TBD

### Comments and Discussion

*   Refer to <Talk:Features/Quota-3.2>

<Category:Feature> <Category:SLA>

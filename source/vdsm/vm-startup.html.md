---
title: VDSM VM startup
category: vdsm
authors: fromani
wiki_title: VDSM VM startup
wiki_revision_count: 43
wiki_last_updated: 2014-03-19
---

# VDSM VM startup

## Summary

This page gather the design of the VM startup revamp. The code which handles the VM startup in current (<= 4.14.x) has become tangled and messy. A rewrite will be beneficial. Performance improvements about the VDSM startup are covered in a [separate page](VDSM_libvirt_performance_scalability)

#### WARNING!

This document is work in progress and requently updated, both for content and for style/consistency/readability

### Owner

*   Name: [Francesco Romani](User:Fromani)
*   Email: <fromani@redhat.com>
*   PM Requirements : N/A
*   Email: N/A

### Current status

*   Target Release: oVirt 3.5 and following
*   Status: Draft/Discussion
*   Last updated: 2014-02-19

## Summary of the status quo

WRITEME

## Rewrite objectives

*   add more tests! **both** unit-tests and functional (probably need to revamp vm functional tests as well)

<!-- -->

*   make the code cleaner/more extensible

<!-- -->

*   make the code more robust

<!-- -->

*   avoid racy behaviour (see [bz912390](https://bugzilla.redhat.com/show_bug.cgi?id=912390))

## Rewrite ideas

### Draft 1

WRITEME

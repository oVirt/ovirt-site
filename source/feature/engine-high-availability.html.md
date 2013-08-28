---
title: Engine High Availability
authors: emesika, liran.zelkha, plysan
wiki_title: Features/Engine High Availability
wiki_revision_count: 8
wiki_last_updated: 2014-05-08
---

# Engine High Availability

This page was created as a result of a [http://lists.ovirt.org/pipermail/engine-devel/2013-August/005436.html discussion](http://lists.ovirt.org/pipermail/engine-devel/2013-August/005436.html discussion) that started at @engine_devel. As we are considering an active/active architecture for Engine, we'll use this page to document required features and code changes that will be required.

## Architecture

## Issues with current implementation

1.  Locking. Currently Engine makes extensive use of Java synchronized capabilities to lock multiple requests hitting the same VDSM at the same time. This should be extended to be cross-machine.

However, if we replace HTTP transport protocol (and use push notifications), and since VDSM can support multiple concurrent requests, is the entire locking mechanism still necessary?

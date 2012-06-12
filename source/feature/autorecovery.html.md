---
title: Autorecovery
category: feature
authors: ekohl, lhornyak, ykaul
wiki_category: Feature
wiki_title: Features/Autorecovery
wiki_revision_count: 16
wiki_last_updated: 2012-07-20
---

# Autorecovery

### Summary

This page describes the **planned** Autorecovery feature in ovirt engine.

### Owner

*   name: Laszlo Hornyak
*   email <lhornyak at redhat dot com>
*   irc: lhornyak (irc.ofc.net #ovirt)

### Current status

*   Last updated date: Wed Feb 08 2012

# Detailed description

### Behavior

*   Autorecovery feature will allow the backend to recover some of the objects automatically after a temporary failure. Initially only automatic recovery of hosts and storage domains will be supported.
*   Autorecovery can be enabled/disabled for each object of the above entity types. The engine will try to recover it periodically as long as the autorecovery is set to true.
*   The recovery logic (at least in the first iteration) will not check the reason why the object got into Not Operational/Inactive state
*   AuditLog will be limited to be issued once every 3 hours for unsuccessful recovery.

### Internals

*   The check will happen in regular intervals (quartz scheduler)
*   Needs a DAO extension to fetch only those objects that are in failed state and have auto-recovery on
*   It will call the respective commands (ActivateHost, ActivateStorageDomain), and let the commands do what they do
*   Database needs to be extended with autorecovery information, default will be true - as discussed on engine-devel list.

<Category:Feature>

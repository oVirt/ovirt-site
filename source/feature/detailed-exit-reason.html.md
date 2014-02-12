---
title: Detailed Exit Reason
category: feature
authors: fromani
wiki_category: Feature
wiki_title: Features/Detailed Exit Reason
wiki_revision_count: 13
wiki_last_updated: 2014-02-20
---

# Detailed Exit Reason

### Summary

*   Add a detailed exit code on VDSM ExitedVmStats to represent the reason why a VM was shut down, either normally or because of an error.
*   Update engine to fetch and use this new value internally.
*   The benefit for the engine is better reporting and better view of the status of the VM.

### Owner

*   Name: [Francesco Romani](User:Fromani)
*   Email: <fromani@redhat.com>
*   PM Requirements : N/A
*   Email: N/A

### Current status

Implementation vor VDSM and Engine in progress, patches posted on gerrit. See below for links.

### Detailed Description

#### Webadmin/Power User Portal

#### REST API

Not affected.

#### VDSM

change: <http://gerrit.ovirt.org/#/c/22631/> relevant bugzillas: <https://bugzilla.redhat.com/show_bug.cgi?id=557125>

### Documentation / External references

<Category:Feature>

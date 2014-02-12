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
*   The new field will be called exitReason and will be an enumeration with errno-like semantics.
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

This change is transparent to the user because will only affect the VDSM <=> engine communication. User will notice only indirectly through more precise reporting and better behaviour in general.

Backward and forward compatibility must be ensured:

*   updated engines must to deal properly with not-updated VDSMs and
*   updated VDSMs must deal properly with not-updated engines.

since the communication between VDSM and engine happens through XML-RPC, not-updated engines will just discard the extra field. In the case of an updated engine dealing with an old, not updated, VDSM, the missing field will be filled with a placeholder value with 'Value Unknown' semantics. In this case the engine must not rely internally on the value of the new field and must behave as before.

#### Webadmin/Power User Portal

No user-visible change.

#### REST API

Not affected.

#### VDSM

change: <http://gerrit.ovirt.org/#/c/22631/> relevant bugzillas: <https://bugzilla.redhat.com/show_bug.cgi?id=557125>

### Documentation / External references

<Category:Feature>

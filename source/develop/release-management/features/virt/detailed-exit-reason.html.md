---
title: Detailed Exit Reason
category: feature
authors: fromani
---

# Detailed Exit Reason

WARNING: work in progress

## Summary

*   Add a detailed exit code on VDSM ExitedVmStats to represent the reason why a VM was shut down, either normally or because of an error.
*   The new field will be called exitReason and will be an enumeration with errno-like semantics.
*   Update engine to fetch and use this new value internally.
*   The benefit for the engine is better reporting and better view of the status of the VM.

## Owner

*   Name: Francesco Romani (Fromani)
*   Email: <fromani@redhat.com>
*   PM Requirements : N/A
*   Email: N/A

## Current status

*   Target Release: oVirt 3.5
*   Status: Implementation vor VDSM and Engine in progress, patches posted on gerrit. See below for links.
*   Last updated: 14 Feb 2014

## Detailed Description

This change is transparent to the user because will only affect the VDSM <=> engine communication. User will notice only indirectly through more precise reporting and better behaviour in general.

Backward and forward compatibility must be ensured:

*   updated engines must to deal properly with not-updated VDSMs and
*   updated VDSMs must deal properly with not-updated engines.

since the communication between VDSM and engine happens through XML-RPC, not-updated engines will just discard the extra field. In the case of an updated engine dealing with an old, not updated, VDSM, the missing field will be filled with a placeholder value with 'Value Unknown' semantics. In this case the engine must not rely internally on the value of the new field and must behave as before.

### Design Discussion

*   Why an extra field?

ExitReason can be made a superset of ExitCode, meaning that when the values overlap, they carry the same meaning. ExitReason carries specific values for every possible VM termination outcome, either succesful or unsuccesful. So, for example, there is a specific ExitReason if a VM migrates succesfully, and not only a generic success value for all the possible correct terminations.

We can make ExitReason backward compatible with ExitCode if we drop the specific success codes and we coalesce them in a single catch-all value.

### Webadmin/Power User Portal

No user-visible change.

### REST API

Not affected.

### VDSM

change: <http://gerrit.ovirt.org/#/c/22631/> relevant bugzillas: <https://bugzilla.redhat.com/show_bug.cgi?id=557125>

## Documentation / External references

Engine changeset: <http://gerrit.ovirt.org/#/c/23946/> relevant bugzilla (trivially solved leveraging this feature): <https://bugzilla.redhat.com/show_bug.cgi?id=697277>


---
title: Separate-Reports-Host
category: feature
authors: didi, sandrobonazzola, sradco
wiki_category: Feature|Separate Reports Host
wiki_title: Features/Separate-Reports-Host
wiki_revision_count: 20
wiki_last_updated: 2015-01-16
feature_name: Separate Reports Host
feature_modules: engine
feature_status: Planning
---

# Separate Reports Host

### Summary

Allow ovirt-engine-reports to be installed and configured by engine-setup on a separate machine, without requiring ovirt-engine or DWH to be on the same host.

### Owner

*   Name: [ Didi](User:Didi)

<!-- -->

*   Email: <didi@redhat.com>

### Current status

In preparation.

### Detailed Description

TBD:

*   Need access to the engine's database - if db is setup locally, we might ask the user for the root password and ssh to get the credentials
*   Need access to the DWH database - if db is setup locally, we might ask the user for the root password and ssh to get the credentials
*   We might want to try and understand that from some engine status page first, to not bother the user. Do we need the engine's FQDN for other things?

### Benefit to oVirt

Reports might cause significant load on the engine machine. Installing it on a separate machine will allow distributing the load.

Some installations might want to separate for security reasons, e.g. to give some users access only to Reports and not to the engine web admin.

### Dependencies / Related Features

### Documentation / External references

<https://bugzilla.redhat.com/1080997>

### Testing

Install and setup ovirt-engine on machine A, ovirt-engine-dwh on machine B (A and B might be the same machine), ovirt-engine-reports on machine C, see that the reports application on C shows data from the engine on machine A collected by DWH on machine B.

### Comments and Discussion

*   Refer to <Talk:Separate-Reports-Host>

<Category:Feature> <Category:Template>

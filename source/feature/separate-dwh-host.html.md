---
title: Separate-DWH-Host
category: feature
authors: didi, sandrobonazzola, sradco
wiki_category: Feature|Separate DWH Host
wiki_title: Features/Separate-DWH-Host
wiki_revision_count: 16
wiki_last_updated: 2015-01-16
feature_name: Separate DWH Host
feature_modules: engine
feature_status: Planning
---

# Separate DWH Host

### Summary

Allow ovirt-engine-dwh to be installed and configured by engine-setup on a separate machine, without requiring ovirt-engine to be on the same host.

### Owner

*   Name: [ Didi](User:Didi)

<!-- -->

*   Email: <didi@redhat.com>

### Current status

In preparation.

### Detailed Description

TBD:

*   Need access to the engine's database - if db is setup locally, we might ask the user for the root password and ssh to get the credentials
*   We might want to try and understand that from some engine status page first, to not bother the user. Do we need the engine's FQDN for other things?

### Benefit to oVirt

DWH sometimes causes a significant load on the engine machine. Installing it on a separate machine will allow distributing the load.

### Dependencies / Related Features

### Documentation / External references

<https://bugzilla.redhat.com/1080997>

### Testing

Install and setup ovirt-engine on machine A, ovirt-engine-dwh on machine B, see that dwhd on B collects data from the engine on A.

### Comments and Discussion

*   Refer to <Talk:Separate-DWH-Host>

<Category:Feature> <Category:Template>

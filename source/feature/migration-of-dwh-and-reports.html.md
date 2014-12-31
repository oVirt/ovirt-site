---
title: Migration of DWH&Reports
authors: didi, sradco
wiki_title: Features/Migration of DWH&Reports
wiki_revision_count: 50
wiki_last_updated: 2015-01-04
feature_name: Migrating DWH and Reports
feature_modules: engine
feature_status: Design
---

# Migration of DWH&Reports

## Separate DWH Host

### Summary

Allow ovirt-engine-dwh and ovirt-engine-reports to be migrated and configured by engine-setup on a separate machine, without requiring ovirt-engine to be on the same host.

### Owner

*   Name: [ Shirly](User:Shirly)

<!-- -->

*   Email: <sradco@redhat.com>

### Current status

Implemented, should be available in 3.5.

### Detailed Description

We assume that engine, DWH and Reports are already setup and running on machine A and in version 3.5 and above.

We assume that user wants to migrate DWH to machine B and Reports to Machine C.

We need access to the engine's database. If on separate host, user will be prompted for them.

### Benefit to oVirt

DWH and Reports sometimes causes a significant load on the engine machine. Installing them on a separate machines will allow distributing the load. Some installations might want to separate for security reasons, e.g. to give some users access only to Reports and not to the engine web admin.

### Dependencies / Related Features

### Documentation / External references

<https://bugzilla.redhat.com/1156009> <https://bugzilla.redhat.com/1156015>

An annotated [example setup](Separate-Reports-Host#Example_setup) on three machines

### Testing

### Comments and Discussion

*   Refer to <Talk:Separate-DWH-Host>

[Separate DWH Host](Category:Feature) [Separate DWH Host](Category:oVirt 3.5 Feature)

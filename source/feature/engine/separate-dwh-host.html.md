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
feature_status: Design
---

# Separate DWH Host

### Summary

Allow ovirt-engine-dwh to be installed and configured by engine-setup on a separate machine, without requiring ovirt-engine to be on the same host.

### Owner

*   Name: [ Didi](User:Didi)

<!-- -->

*   Email: <didi@redhat.com>

### Current status

Implemented, should be available in 3.5.

### Detailed Description

We assume that engine is already setup and running on machine A. We assume that user wants to install dwh on machine B.

We need access to the engine's database. If on separate host, user will be prompted for them.

We need to also fix bug <https://bugzilla.redhat.com/1059283> - check minimal ETL version, as we'll not be able to rely on package dependencies anymore.

### Migrating an existing DWH and Reports installation

For migration of an existing local installation of DWH and Report to a different server please refer to [Migration_of_local_DWH_Reports_to_remote](Features/Migration_of_local_DWH_Reports_to_remote)

### Benefit to oVirt

DWH sometimes causes a significant load on the engine machine. Installing it on a separate machine will allow distributing the load.

### Dependencies / Related Features

### Documentation / External references

<https://bugzilla.redhat.com/1080997>

An annotated [example setup](Separate-Reports-Host#Example_setup) on three machines

### Testing

Install and setup ovirt-engine on machine A, ovirt-engine-dwh on machine B, see that dwhd on B collects data from the engine on A.

On A:

      yum install ovirt-engine-setup
      engine-setup

On B:

      yum install ovirt-engine-dwh-setup
      engine-setup

### Comments and Discussion

*   Refer to <Talk:Separate-DWH-Host>

[Separate DWH Host](Category:Feature) [Separate DWH Host](Category:oVirt 3.5 Feature) [Separate DWH Host](Category:Integration)

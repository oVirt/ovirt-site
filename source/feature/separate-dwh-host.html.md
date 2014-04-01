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

Design.

### Detailed Description

We assume that engine is already setup and running on machine A. We assume that user wants to install dwh on machine B.

We need access to the engine's database. We'll let the user choose between two options:

*   provide root password of machine A, ssh there, get the credentials
*   manually supply the credentials

We need to also fix bug <https://bugzilla.redhat.com/1059283> - check minimal ETL version, as we'll not be able to rely on package dependencies anymore.

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

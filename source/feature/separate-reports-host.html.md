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
feature_status: Design
---

# Separate Reports Host

### Summary

Allow ovirt-engine-reports to be installed and configured by engine-setup on a separate machine, without requiring ovirt-engine or DWH to be on the same host.

### Owner

*   Name: [ Didi](User:Didi)

<!-- -->

*   Email: <didi@redhat.com>

### Current status

Design.

### Detailed Description

We assume that engine is already setup and running on machine A.

If dwh is already installed and setup on machine B (can be same as A), and user wants to install reports on machine C, we need access to the engine's database and to dwh's database. We'll let the user choose between two options:

*   provide root password of machine B, ssh there, get the credentials
*   manually supply the credentials

If dwh is to be setup on machine B and user wants to install reports on the same machine B, we already have the credentials.

If dwh and reports are to be setup together on machine B, we need to make sure that setup recognizes that somehow, so that the reports plugin has access to needed info. Perhaps we'll decide to postpone that option - if we do, user will have to first setup dwh then reports.

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

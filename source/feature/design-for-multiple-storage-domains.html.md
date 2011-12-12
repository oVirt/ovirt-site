---
title: Design for multiple storage domains
category: feature
authors: derez, jumper45, mkublin
wiki_category: Feature
wiki_title: Design for multiple storage domains
wiki_revision_count: 19
wiki_last_updated: 2014-07-13
---

# Design for multiple storage domains

## User Stories

1.  Add VM
    1.  As a RHEV-M GUI user, when I create a VM, I want to be able to select different storage domains for each disk in the VM so that I can make efficient use of my storage. I know the feature works when I can use the RHEV-M GUI to create a VM with 3 disks each on different storage domains.
    2.  As a Rest API user, when I create a VM, I want to specify a new VM where each disk is on different storage domains so that I can make efficient use of my storage. I know the feature works when I can use the REST API to create a VM with 3 disks each on different storage domains.

2.  Import a VM
    1.  As a RHEV-M GUI user, when I import a VM, I want to be able to select different storage domains for each disk in the VM so that I can make efficient use of my storage. I know the feature works when I can use the RHEV-M GUI to import a VM with 3 disks each on different storage domains.
    2.  As a Rest API user, when I import a VM, I want to specify a new VM where each disk is on different storage domains so that I can make efficient use of my storage. I know the feature works when I can use the REST API to import a VM with 3 disks each on different storage domains

3.  Hibernate a VM
    1.  As a RHEV-M user, when I hibernate a VM, the VM will hibernate if and only if the VM and each disk can be hibernated. I know the feature works when I can hibernate the VM if each disk can hibernate not if hibernation fails for any disk.

4.  Add Disk to VM
    1.  As a RHEV-M GUI user, when I add a disk to a VM, I can select which storage domain to associate with it so that I can make more efficient use of my storage. I know the feature works when I can use the RHEV-M GUI to add a disk to a VM and put it on a storage domain not already in use by the VM.
    2.  As a REST API user, when I add a disk to a VM, I can specify which storage domain to associate with it so that I can make more efficient use of my storage. I know the feature works when I can use the REST API to add a disk to a VM and put it on a storage domain not already in use by the VM

5.  Import VM template
    1.  As a RHEV-M GUI user, when I import a VM template, I want to be able to select different storage domains for each disk in the template so that I can make efficient use of my storage. I know the feature works when I can use the RHEV-M GUI to import a template with 3 disks each on different storage domains.
    2.  As a Rest API user, when I import a VM template, I want to specify where each disk is on different storage domains so that I can make efficient use of my storage. I know the feature works when I can use the REST API to import a VM template with 3 disks each on different storage domains

6.  Move Disk
    1.  As a RHEV-M GUI user, I want to be able to move a disk from one storage domain to another so that I can make efficient use of my storage. I know the feature works when I can use the RHEV-M GUI to add a disk to an existing VM on a storage domain not already in use by the VM.
    2.  As a REST API user, I want to specify moving a disk from one storage domain to another so that I can make efficient use of my storage. I know the feature works when I can use the REST API to add a disk to an existing VM on a storage domain not already in use by the VM.

7.  Create VM from template
    1.  As a RHEV-M GUI user, I want to be able to create a VM from a template and be able to specify on which storage domain each disk should be created. I know the feature works when I can create a VM from a template that has 3 disks and I can put each disk on a separate storage domain.
    2.  As a REST API user, I want to be able to create a VM from a template and be able to specify on which storage domain each disk should be created. I know the feature works when I can create a VM from a template that has 3 disks and I can put each disk on a separate storage domain.

## Acceptance Tests

      Will be based on the "I know the feature works..." in the user stories.

### Additional functionality to verify

1.  create snapshots
2.  delete disk
3.  delete VM
4.  start VM

## Overall design

The main change that needs to happen is to have each image associated with its own storage domain.

### GUI

1.  Add a VM
2.  Import a VM
3.  Hibernate VM
4.  Add Disk to VM
5.  Import VM Template
6.  Create Snapshot
7.  Move Disk
8.  Create VM from Template

### REST Design (Modeling)

This section describes the REST design for this feature.

1.  Add a VM
2.  Import a VM
3.  Hibernate VM
4.  Add Disk to VM
5.  Import VM Template
6.  Create Snapshot
7.  Move Disk
8.  Create VM from Template

### Backend

There should not be any changes to the database or the object model to support this feature. Many of the command classes will need their logic changes to handle processing each disk individually by their storage domain instead of handling them all at once.

## VDSM

Vdsm already supports this feature; it has no limitation on the location of disk images. Any storage domain for any VM disk will do.

## Open Issues

1.  Need to consider negative cases when some storage domains fail, etc.
2.  Need to determine which flows will need additional transactionality due to multiple storage domains.
3.  Need to figure out how hibernation will work

## Known Issues / Risks

Being developed in parallel with quotas. Can't anticipate changes needed to work with quotas.

## Needed documentation

The docs will need to be updated with new screenshots showing adding a disk to a VM and selecting the storage domain there.

<Category:Feature> <Category:Multiple_storage_domains>

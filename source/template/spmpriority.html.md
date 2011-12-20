---
title: SPMPriority
category: template
authors: derez, msalem, ovedo
wiki_category: Template
wiki_title: Features/SPMPriority
wiki_revision_count: 16
wiki_last_updated: 2014-07-13
wiki_warnings: list-item?
---

# SPM Priority

------------------------------------------------------------------------

### Summary

The SPM Priority feature allows the admin to define priorities between hosts regarding the SPM selection process.

### Owner

*   Feature owner: [ Muli Salem](User:msalem)

    * Backend Component owner: [ Muli Salem](User:msalem)

    * GUI Component owner: [ ?](User:?)

    * REST Component owner: [ Michael Pasternak](User:mpasternak)

    * QA Owner: [ ?](User:?)

*   Email: msalem@redhat.com

### Current status

*   PRD stage
*   Last updated date: Tue Dec 20 2011:

### Description

The SPM selection process happens when a command needs SPM authorization to run, for example DestroyImageVDSCommand and AttachStorageDomainVDSCommand. Currently, the SPM selection process is random, meaning a host is chosen randomly out of the hosts that are currently UP.

### PRD

The requirements are the following:

1.  Enable setting a priority between -1 and 100 for a host (100 is the highest, -1 means never to chose this host).
2.  When SPM selection process takes place, use the SPM priority to select an SPM.
3.  Default for upgrading ovirt will be 50.

### Design

Current flow:

1.  All hosts except in the Data Center are fetched.
2.  One is chosen randomly, and SPMStatusVDSCommand is called with it.
3.  If it returns with status free and (spmStatus.getSpmId() != -1) --> this host is chosen as the new SPM.

New Design:

1.  Adding a vds_spm_priority field to vds_static.
    1.  This field is configurable upon host creation and host editing by the admin.

<span style="color:Teal">**command_entity**</span> represents the command entity:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Description |- |vds_spm_priority ||smallint || ||The Spm priority of this vds |- |}

Algorithm for selecting a host according to priorities

------------------------------------------------------------------------

### Open Issues

### Dependencies / Related Features

Affected rhevm projects:

*   API
*   CLI
*   backend
*   Webadmin
*   User Portal

### Documentation / External references

### Comments and Discussion

------------------------------------------------------------------------

<Category:Template> <Category:Feature>

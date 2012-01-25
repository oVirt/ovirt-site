---
title: DBSchemaVersionCheck
category: feature
authors: yair zaslavsky
wiki_category: Feature
wiki_title: Features/DBSchemaVersionCheck
wiki_revision_count: 4
wiki_last_updated: 2012-01-25
---

# DB Schema version check

### Summary

This feature will allow checking if there is a parity between the DB schema version as calculated from code, and by the schema version that is obtained from the DB.

### Owner

*   Name: [ Yair Zaslavsky](User:Yair Zaslavsky)
*   Email: <yzaslavs@redhat.com>

### Current status

*   Last updated date: Wed Jan 25 2012

### Detailed Description

The engine schema contains the **schema_version** table that holds information on upgrade scripts and their installation status.
As both clean install and upgrade run these scripts, and any schema change is performed by adding another upgrade script it is crucial to keep
version information about the upgrade scripts in order to make sure unchanged scripts will not be re-run when upgrade process is being re-run.
In order to maintain the version for a given upgrade script, for each upgrade script the md5 calculation of its content is kept in the above mentioned DB.
 The table description is as follows:
| Column Name | Column Type | Null? | Definition | index/pk/fk |
| id | int | No | Version ID | PK |
| version | varchar(10) | No | The version of the schema the upgrade script tried to acieve | |
| script | varchar(255) | No | The script file name | |
| checksum | varchar(128) | No | md5 of the script file | |
| installed_by | varchar(30) | No | The db user that runs the upgrade script | |
| started_at | timestamp | No | Script start time | |
| ended_at | timestamp | Yes | Script end time | |
| state | varchar (15) | No | INSTALLED/FAILED | |
| current | boolean | No | true only for last version installed successfully | |

### Benefit to oVirt

If we look at snapshots as "checkpoints" of VM state + data , and "checkpoints" are made in significant points of time, the feature allows a user to create a VM based on a significant point of time of another VM, and use the cloned VM, without interfering with the original VM (i.e - no need to perform collapse on images of the source VM).

### Dependencies / Related Features

Dependencies on features:

Affected oVirt projects:

*   Engine-core

### Comments and Discussion

<Category:Feature>

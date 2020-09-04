---
title: DBSchemaVersionCheck
category: feature
authors: yair zaslavsky
---

# DB Schema version check

## Summary

This feature will allow checking if there is a parity between the DB schema version as calculated from code, and by the schema version that is obtained from the DB.

## Owner

*   Name: Yair Zaslavsky (Yair Zaslavsky)


## Current status

*   Last updated date: Wed Jan 25 2012

## Detailed Description

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

### 1. Storing MD5 information per installed upgrade scripts in DB

When running upgrade script, the script runs all scriptsl ocated in the upgrade folder that follow the pattern of MAJOR_MINOR_SCRIPTINDEX_DESCRIPTION.sql (i.e - 03_01_0050_add_cancel_migration_to_action_version_map.sql).
After each step an entry is kept to kept in version_schema , holding information on the md5 sum of the script and its state (there are other columns which are used for other issues which are out of this scope of this document, as this design is using a table that already exists in the db, and does not proprose a new one)

### 2. calculating the db schema MD5 and storing it for db schema check

A script called store_db_schema_checksum.sh will invoke a sciprt called calculate_db_schema_checksum.sh that calculates the db schema checksum the following way:
It performs select of the checksum column from the checksum_version table for all the installed scripts, and runs md5 calculation on the result (a list of checksum values).
The script store_db_schema_checksum.sh will store the information at the file $GIT_REPO/ovit-engine/ear/target/version.info
This script will be run by the build system (or a developer during a development stage).
During packaging a formal build, this file will be taken from the above location.
The installer is already responsible for deploying this file to /etc/engine during installation, and should be responsible to upgrade its content during upgrade (see comment at open issues).
It will also be possible to run this script via mvn clean install, by providing the -D skip.db.checksum.store=false flag<BR<BR>

### 3. Service for starting engine-core and performing the db_schema_check

A service called engine-cored (see open issues about the service name) will be developed for the following purposes:
.a. Perform validity checks
.b. If validity checks pass, the jboss service will start
The service will run the script check_db_schema_checksum.sh that will compare the md5 values in DB by running calculate_db_schema.checksum.sh (see above) and compare the result with the value of the key DB_SCHEMA_CHECKSUM stored at /etc/engine/version.info.
In case of success this validity check passes. In case of error an error message should be prompted.
It will also be possible to run the script via mvn test at the DAL module or root pom level by providing the flag -D db.checksum.check=false

## Benefit to oVirt

The benefit for oVirt from this feature is the ability to ensure at customers sites (and also for oVirt developers) that there is a parity between the schema version as reflected from the code, and the one that is calculated in the DB. Adding this check to a service that will start the jboss service will prevent the system from working with corrupted/mismatched DB.

## Dependencies / Related Features

Dependencies on features:

Affected oVirt projects:

*   Engine-core



---
title: Backend dbscripts upgrade
category: architecture
authors: amuller
---

# Backend dbscripts upgrade

**Introduction:** The dbscripts/upgrade folder contains stored procedures, relevant when a change is needed to be made to the schema of a table, otherwise known as upgrading the database. As oVirt is an enterprise product and a rather large software project worked on by many people, changes to the database schema need to be carefully. Each upgrade is represented via a stored procedure with a specific naming convention.

**Naming convention:** XX_YY_ZZZ0_description.sql

Where:

*   XX - Major software version
*   YY - Minor software version
*   ZZZ0 - Running sequential number

**Example:** When upgrading the DB, you'd write an SQL query that does the actual work in a stored procedure, and name it using the naming convention described above. If working on version 3.2, and the last upgrade script added is called '03_02_0390_add_tunnel_migration', then your new file name would be 03_02_0400, because the major software version is 3, the minor is 2, and the last upgrade script used sequence number 039, so you'd use 040.

**upgrade.sh:** The parent directory contains a shell script called upgrade.sh, which looks in a table called schema_version. schema_version contains a listing of the upgrade scripts, and the last run script. If your upgrade script has a higher sequential number than the last marked script in the table, upgrade.sh will know to run your script and upgrade the database. As a developer, the script then obviously needs to be run whenever you want to actually upgrade the database. Clients run this script as part of the installation process.


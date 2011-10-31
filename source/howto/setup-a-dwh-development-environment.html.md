---
title: How to setup a oVirt DWH development environment
category: howto
authors: alonbl, bproffitt, quaid, sradco, vered, yaniv dary
wiki_category: Documentation
wiki_title: How to setup a oVirt DWH development environment
wiki_revision_count: 37
wiki_last_updated: 2014-11-25
---

# How to setup a oVirt DWH development environment

## Install the Talend Open Studio and import the project

*   Clone the git repository.
*   Download and install the latest Talend Open Studio version.

      Available from: `[`http://www.talend.com/download.php`](http://www.talend.com/download.php)` 

*   Import the oVirt DWH project from the path:

      < repository folder path >/ovirt-dwh/data-warehouse/history_etl/tos_project

*   You may now edit the project using the studio. Please refer to the Talend documentation for usage details.

## Setup history database to test on

*   setup oVirt Engine.
*   Create the ovirt_history database using the create_db.sh script in the path:

      < repository folder path >/ovirt-dwh/data-warehouse/historydbscripts_postgres/create_db.sh
      Note: Postgres is required to create the database.

*   Setup connections context in the Talend Open Studio. For details on this refer to Talend's documentation.
*   You may now run the project and test it in the TOS.

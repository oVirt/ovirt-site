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

## Install Talend DI and import the project

*   Clone the git repository.

`git clone `[`http://gerrit.ovirt.org/p/ovirt-dwh`](http://gerrit.ovirt.org/p/ovirt-dwh)

*   Download and install the latest Talend DI version.

      Available from: `[`http://www.talend.com/download.php`](http://www.talend.com/download.php)` 

*   Import the oVirt DWH project from the path:

      < repository folder path >/ovirt-dwh/data-warehouse/history_etl/tos_project

*   You may now edit the project using the studio. Please refer to the Talend documentation for usage details.

## Setup history database to test with Talend

*   setup oVirt Engine.
*   Create the ovirt_history database using the create_db.sh script in the path:

      < repository folder path >/ovirt-dwh/data-warehouse/historydbscripts_postgres/create_db.sh
      Note: Postgres is required to create the database.

*   Setup connections context in the Talend DI. For details on this refer to Talend's documentation.
*   You may now run the project and test it in the TOS.

## Test package deployment

*   setup oVirt Engine.
*   Create the ovirt_history database using the create_db.sh script in the path (Note: It will drop the database if already exists):

      < repository folder path >/ovirt-dwh/data-warehouse/historydbscripts_postgres/create_db.sh
      Note: Postgres is required to create the database.

Or upgrade the database:

      < repository folder path >/ovirt-dwh/data-warehouse/historydbscripts_postgres/upgrade.sh

*   Run the maven deployment profile:

      mvn clean install -Pdep

*   Run the root deployment script as root in the path:

      < repository folder path >/ovirt-dwh/data-warehouse/history_etl/etl_sources/packaging/root_etl_deploy.sh < user you used to run the profile >

*   You can now run the ovirt-etl service.

## Remove package test deployment

*   Drop the ovirt_history database, if you want to reset collection.
*   Run the maven undeployment profile:

      mvn clean install -Pundep

*   Run the root undeployment script as root in the path:

      < repository folder path >/ovirt-dwh/data-warehouse/history_etl/etl_sources/packaging/root_etl_undeploy.sh

*   You may also remove config files in the paths: /etc/ovirt/ovirt-dwh, /etc/logrotate.d/ovirt-etl.
*   Everything should now be removed.

<Category:Documentation> <Category:Reports> [Category:Development environment](Category:Development environment)

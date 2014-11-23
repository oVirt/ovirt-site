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

## Prerequisites

<b>Please notice:</b> We assume you have set up a development environment according to the steps available at [OVirt_Engine_Development_Environment](http://www.ovirt.org/OVirt_Engine_Development_Environment) or within source tree at [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) , before you start.

## Source

Checkout source:

      cd $HOME
      $ git clone http://gerrit.ovirt.org/p/ovirt-dwh

## Install Talend DI and import the project

*   Download and install the latest Talend DI version.

      Available from: `[`http://www.talend.com/download.php`](http://www.talend.com/download.php)` 

*   Import the oVirt DWH project from the path:

      < repository folder path >/ovirt-dwh/tos_project

*   You may now edit the project using the studio. Please refer to the Talend documentation for usage details.

## Test and update project with Talend

*   Setup connections context in the Talend DI for the ovirt_engine_history database.

For details on this refer to Talend's documentation.

*   You may now run the project and test it in the Talend DI.

## Test package deployment

*   setup oVirt Engine.

      Note: Postgres is required to create the database.

*   Create or Upgrade the ovirt_engine_history database using the schema.sh script in the path (Note: You will first need to create a new database in postgres if it does not already exist):

      < repository folder path >/ovirt-dwh/packaging/dbscripts/schema.sh -d ovirt_engine_history -c apply -u postgres

*   Build the required jars in the path :

      < repository folder path >/ovirt-dwh

*   Run:

      ant

*   You can now run the ovirt-enigne-dwhd service.

## Remove package test deployment

*   Drop the ovirt_history database, if you want to reset collection.
*   Run the maven undeployment profile:

      mvn clean install -Pundep

*   Run the root undeployment script as root in the path:

      < repository folder path >/ovirt-dwh/data-warehouse/history_etl/etl_sources/packaging/root_etl_undeploy.sh

*   You may also remove config files in the paths: /etc/ovirt/ovirt-dwh, /etc/logrotate.d/ovirt-etl.
*   Everything should now be removed.

<Category:Documentation> <Category:Reports> [Category:Development environment](Category:Development environment)

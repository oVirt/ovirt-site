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
      $ git clone git://gerrit.ovirt.org/ovirt-dwh

## Usage

<font color=red><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine-dwh.

Build product and install at the same PREFIX used to install ovirt-engine, for example: `$HOME/ovirt-engine`, the installation into PREFIX is similar to ovirt-engine process, execute:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

Create user and history database

      su - postgres -c "psql -d template1 -c "create user ovirt_engine_dwh password 'ovirt_engine_dwh';""
      su - postgres -c "psql -d template1 -c "create database ovirt_engine_dwh owner ovirt_engine_dwh template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';""

Setup engine again, select yes when prompted to use dwh, and input above database credentials.

When product is successfully set up, follow instruction within the ovirt-engine development environment and start the ovirt-engine service.

Then start the dwh service by the following command:

      $ $HOME/ovirt-engine/share/ovirt-engine-dwh/services/ovirt-engine-dwhd/ovirt-engine-dwhd.py start

The services will not exit as long as engine is up, to stop press <Ctrl>C.

## Install Talend DI and import the project

*   Download and install the latest Talend DI version.

      Available from: `[`http://www.talend.com/download.php`](http://www.talend.com/download.php)` 

*   Import the oVirt DWH project from the path:

      < repository folder path >/ovirt-dwh/tos_project

*   You may now edit the project using the studio. Please refer to the Talend documentation for usage details.
*   Setup connections context in the Talend DI for the ovirt_engine_history database.

For details on this refer to Talend's documentation.

*   You may now run the project and test it in the Talend DI.

<Category:Documentation> <Category:DWH> <Category:Reports> [Category:Development environment](Category:Development environment)

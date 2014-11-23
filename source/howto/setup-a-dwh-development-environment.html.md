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

## Usage

<font color=red><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine-dwh.

Build product and install at `$HOME/ovirt-engine`, execute the following as unprivileged user while residing within source repository:

      $ make install-dev PREFIX=< Same as engine PREFIX >

Setup product by executing the following command and replying to questions, follow the steps required for the ovirt_engine_history database creation :

      $ $HOME/ovirt-engine/bin/engine-setup

If jboss is installed at alternate location, add the following while JBOSS_HOME contains the location: `--jboss-home="${JBOSS_HOME}"`

When product is successfully set up, execute the ovirt-engine service:

      $ $HOME/ovirt-engine/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py start

and

      $ $HOME/ovirt-engine/share/ovirt-engine-dwh/services/ovirt-engine-dwhd/ovirt-engine-dwhd.py start

The services will not exit as long as engine is up, to stop press <Ctrl>C.

Access your engine using:

*   <http://localhost:8080>
*   <https://localhost:8443>

When performing code change which do not touch modify database, there is no need to re-execute the setup, just execute:

      $ make install-dev PREFIX=< Same as engine PREFIX >

And start the engine service.

## Install Talend DI and import the project

*   Download and install the latest Talend DI version.

      Available from: `[`http://www.talend.com/download.php`](http://www.talend.com/download.php)` 

*   Import the oVirt DWH project from the path:

      < repository folder path >/ovirt-dwh/tos_project

*   You may now edit the project using the studio. Please refer to the Talend documentation for usage details.
*   Setup connections context in the Talend DI for the ovirt_engine_history database.

For details on this refer to Talend's documentation.

*   You may now run the project and test it in the Talend DI.

<Category:Documentation> <Category:Reports> [Category:Development environment](Category:Development environment)

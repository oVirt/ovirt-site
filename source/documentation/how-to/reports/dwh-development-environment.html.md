---
title: oVirt DWH development environment
category: documentation
authors: sradco
wiki_category: Documentation
wiki_title: OVirt DWH development environment
wiki_revision_count: 2
wiki_last_updated: 2015-11-12
---

<!-- TODO: Content review -->

# OVirt DWH development environment

## Prerequisites

<b>Please notice:</b> We assume you have set up a development environment according to the steps available at [OVirt_Engine_Development_Environment](http://www.ovirt.org/OVirt_Engine_Development_Environment) or within source tree at [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) , before you start.

### Database

Create user and history database

      su - postgres -c "psql -d template1 -c "create user ovirt_engine_dwh password 'ovirt_engine_dwh';""
      su - postgres -c "psql -d template1 -c "create database ovirt_engine_history owner ovirt_engine_dwh template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';""

### Source

Checkout source:

      cd "$HOME/git"
      $ git clone git://gerrit.ovirt.org/ovirt-dwh

## Usage

<font color=red><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine-dwh.

Build product and install at the same PREFIX used to install ovirt-engine, for example: `$HOME/ovirt-engine`, the installation into PREFIX is similar to ovirt-engine process, execute:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

Setup engine again, select yes when prompted to use dwh, and input above database credentials.

When product is successfully set up, follow instruction within the ovirt-engine development environment and start the ovirt-engine service.

Then start the dwh service by the following command:

      $ $HOME/ovirt-engine/share/ovirt-engine-dwh/services/ovirt-engine-dwhd/ovirt-engine-dwhd.py start

The services will not exit as long as engine is up, to stop press <Ctrl>C.

## How to write DWH patches

Please refer to [How_to_write_patches_for_dwh](http://www.ovirt.org/How_to_write_patches_for_dwh) for further information.

## Packaging

### RPM packaging

Build system supports standard RPM packaging out of source tarball.

Create source tarball by executing:

      $ make dist

Follow the standard [oVirt guidelines for building RPM package](http://www.ovirt.org/Build_Binary_Package)

<Category:Documentation> <Category:DWH> <Category:Reports> [Category:Development environment](Category:Development environment)

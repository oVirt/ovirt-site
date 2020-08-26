---
title: oVirt DWH development environment
category: documentation
toc: true
authors: sradco, sdickers
---

<!-- TODO: Content review -->

# oVirt DWH development environment

## Prerequisites

<b>Please note:</b> It is assumed a standard oVirt engine development environment has already been setup.  Follow steps available at [oVirt Engine Development Environment](/develop/developer-guide/engine/engine-development-environment.html) or within the ovirt-engine source tree at [README.adoc](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.adoc;hb=HEAD) before you start with DWH.

### Database

Create user and history database

      su - postgres -c "psql -d template1 -c "create user ovirt_engine_dwh password 'ovirt_engine_dwh';""
      su - postgres -c "psql -d template1 -c "create database ovirt_engine_history owner ovirt_engine_dwh template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';""

### Java libraries

DWH build and run require a few 3rd party java libraries to be installed on your system:

      yum install dom4j apache-commons-collections postgresql-jdbc

### Source

Checkout source:

      cd "$HOME/git"
      $ git clone git://gerrit.ovirt.org/ovirt-dwh

## Usage

<span style="color: red;"><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</span>

Once prerequisites are in place, you are ready to build and use ovirt-engine-dwh.

Build product and install at the same PREFIX used to install ovirt-engine, for example: `$HOME/ovirt-engine`, the installation into PREFIX is similar to ovirt-engine process, execute:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

Setup engine again, select yes when prompted to use dwh, and input above database credentials.

When product is successfully set up, follow instruction within the ovirt-engine development environment and start the ovirt-engine service.

Then start the dwh service by the following command:

      $ $HOME/ovirt-engine/share/ovirt-engine-dwh/services/ovirt-engine-dwhd/ovirt-engine-dwhd.py start

The services will not exit as long as engine is up, to stop press <Ctrl>C.

## How to write DWH patches

Please refer to [How to write patches for DWH](write-patches-for-dwh.html) for further information.

## Packaging

### RPM packaging

Build system supports standard RPM packaging out of source tarball.

Create source tarball by executing:

      $ make dist

Follow the standard [guidelines for building RPM package](/develop/dev-process/build-binary-package.html)


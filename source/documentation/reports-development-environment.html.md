---
title: OVirt Reports development environment
category: documentation
authors: didi, sradco
wiki_category: Documentation
wiki_title: OVirt Reports development environment
wiki_revision_count: 3
wiki_last_updated: 2014-12-02
---

# OVirt Reports development environment

## Prerequisites

<b>Please notice:</b> We assume you have set up a development environment according to the steps available at [OVirt_Engine_Development_Environment](http://www.ovirt.org/OVirt_Engine_Development_Environment) or within source tree at [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) , as well as the dwh setup according to the steps available at [How_to_setup_a_oVirt_DWH_development_environment](http://www.ovirt.org/index.php?title=How_to_setup_a_oVirt_DWH_development_environment) before you start.

### RPM based

      $ yum install jasperreports-server

### Database

Create user and history database

      su - postgres -c "psql -d template1 -c "create user ovirt_engine_reports password 'ovirt_engine_reports';""
      su - postgres -c "psql -d template1 -c "create database ovirt_engine_reports owner ovirt_engine_reports template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';""

### Source

Checkout source:

      cd "$HOME/git"
      $ git clone git://gerrit.ovirt.org/ovirt-reports

## Usage

<font color=red><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine-reports.

Build product and install at the same PREFIX used to install ovirt-engine, for example: `$HOME/ovirt-engine`, the installation into PREFIX is similar to ovirt-engine process, execute:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

Setup engine again, select yes when prompted to use reports.

When product is successfully set up, follow instruction within the ovirt-engine development environment and start the ovirt-engine service, and follow dwh instructions and start dwh service.

Start the reports service by the following command:

      $ $HOME/ovirt-engine/share/ovirt-engine-reports/services/ovirt-engine-reportsd/ovirt-engine-reportsd.py start

The server can now be run and accessed in the link:

*   <http://localhost:8090/jasperserver/>

with the following credentials:

      User: admin
      password: admin1!

## Advanced Customizations

### Alternate jasper instance

You can specify --otopi-environment="OVESETUP_REPORTS_CONFIG/jasperHome=str:<path to jasper>" to engine-setup in order to use non default jasper instance.

## Jasper Reports Studio

*   Download and install Jaspersoft Studio, <http://community.jaspersoft.com/project/jaspersoft-studio>
*   Open Jaspersoft Studio Designer.
*   Setup the JasperReports Server repository viewer to view the repository you imported the reports to. Details for doing this are provided in the Jaspersoft Studio guide by Jasper.
*   Reports can now be edited via Jaspersoft Studio .

## Packaging

### RPM packaging

Build system supports standard RPM packaging out of source tarball.

Create source tarball by executing:

      $ make dist

Follow the standard oVirt guidelines for building RPM package

*   <http://www.ovirt.org/Build_Binary_Package>

<Category:Documentation> <Category:Reports> [Category:Development environment](Category:Development environment) [Category:How to](Category:How to)

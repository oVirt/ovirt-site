---
title: How to setup a oVirt Reports development environment
category: howto
authors: alonbl, bproffitt, quaid, sradco, yaniv dary
wiki_category: Documentation
wiki_title: How to setup a oVirt Reports development environment
wiki_revision_count: 37
wiki_last_updated: 2014-11-25
---

# How to setup a oVirt Reports development environment

## Prerequisites

<b>Please notice:</b> We assume you have set up a development environment according to the steps available at [OVirt_Engine_Development_Environment](http://www.ovirt.org/OVirt_Engine_Development_Environment) or within source tree at [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) , as well as the dwh setup according to the steps available at [How_to_setup_a_oVirt_DWH_development_environment](http://www.ovirt.org/index.php?title=How_to_setup_a_oVirt_DWH_development_environment) before you start.

## Source

Checkout source:

      cd $HOME
      $ git clone http://gerrit.ovirt.org/p/ovirt-reports

Download and install JasperReports Server 5.5 .

*   Available on this link: <http://community.jaspersoft.com/project/jasperreports-server/releases>

Download and install Jaspersoft Studio .

*   Available on this link: <http://community.jaspersoft.com/project/jaspersoft-studio>

## Usage

<font color=red><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine-reports.

Build product and install at `$HOME/ovirt-engine`, execute the following as unprivileged user while residing within source repository:

      $ make install-dev PREFIX=< Same as engine PREFIX >

Setup engine again

When product is successfully set up, Start the services:

      $ $HOME/ovirt-engine/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py start

      $ $HOME/ovirt-engine/share/ovirt-engine-dwh/services/ovirt-engine-dwhd/ovirt-engine-dwhd.py start

      $ $HOME/ovirt-engine/share/ovirt-engine-dwh/services/ovirt-engine-reportsd/ovirt-engine-reportsd.py start

The server can now be run and accessed in the link:

*   <http://localhost:8080/jasperserver/>

with the following credentials:

      User: admin
      password: admin1!

*   Open Jaspersoft Studio Designer.
*   Setup the JasperReports Server repository viewer to view the repository you imported the reports to. Details for doing this are provided in the Jaspersoft Studio guide by Jasper.
*   Reports can now be edited via Jaspersoft Studio .

<Category:Documentation> <Category:Reports> [Category:Development environment](Category:Development environment) [Category:How to](Category:How to)

---
title: Installing ovirt-engine from rpm
authors: aglitke, djorm, dougsland, mburns, moti, oschreib, ranglust, sandrobonazzola,
  sgordon
wiki_title: Installing ovirt-engine from rpm
wiki_revision_count: 34
wiki_last_updated: 2014-09-26
---

This Documents has come to describe the steps required in order to install & configure ovirt-engine Use this guide in order to install VDSM on the same host as ovirt-engine: [Installing_VDSM_from_rpm](Installing_VDSM_from_rpm)

### Installing Prerequisite Packages

execute the following command as root:

      yum install -y postgresql-server postgresql-contrib pgadmin3 java-1.6.0-openjdk-devel
       

### Configuring Ovirt's Repository

Execute the following command:

      wget http://www.ovirt.org/releases/nightly/fedora/16/ovirt-engine.repo -P /etc/yum.repos.d/
       

# Ovirt-engine

### Installing & Configuring ovirt-engine

#### Install

Install ovirt-engine by executing:

      yum install -y ovirt-engine ovirt-engine-setup
       

and execute the installation utility:

      engine-setup
       

#### Additional Configuration

If you wish to turn off secured connection to the hosts:

      psql -U postgres engine -c "update vdc_options set option_value='false' where option_name='UseSecureConnectionWithServers' and version='general';"
       

#### JBoss AS Security

Note that JBoss AS 5.1 does not include security fixes for issues found after it was released. These fixes are rolled into later versions of JBoss AS. JMX Console has been removed from the latest release of ovirt-enigine-jbossas

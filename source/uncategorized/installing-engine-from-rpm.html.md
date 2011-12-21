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

      yum install -y ovirt-engine
       

execute \`engine-setup

#### DB Creation

Create ovirt-engine's DB by executing:

      cd /usr/share/ovirt-engine/dbscripts
      ./create_db_devel.sh -u postgres
       

#### Additional Configuration

*These 2 steps are currently required due to bugs, they will be changed/removed once the patches that will fix them will be merged.*
Change the default emulated VM type by executing:

      psql -U postgres engine -c "update vdc_options set option_value='pc-0.14' where option_name='EmulatedMachine' and version='3.0';"
       

#### Starting & Accessing ovirt-engine

Start the jboss service by executing:

      service jboss start
       

Jboss & ovirt-engine will be available within a minute or two by accessing the following url: <http://yourhostname:8080/webadmin>
The user is: admin
The default password (unless changed) is: letmein!

#### JBoss AS Security

Note that JBoss AS 5.1 does not include security fixes for issues found after it was released. These fixes are rolled into later versions of JBoss AS. By default, JBoss AS permits unauthenticated access to the JMX console. It is important that the JMX console is configured to require authentication. Failure to do so will render the system vulnerable to several known exploits, including the [JBoss Worm](http://community.jboss.org/blogs/mjc/2011/10/20/statement-regarding-security-threat-to-jboss-application-server) that exploits [CVE-2010-0738](https://access.redhat.com/kb/docs/DOC-30741). Please follow [these instructions](http://community.jboss.org/wiki/SecureTheJmxConsole) to secure the JMX console.

---
title: Installing ovirt-engine from rpm
authors: aglitke, djorm, dougsland, mburns, moti, oschreib, ranglust, sandrobonazzola,
  sgordon
wiki_title: Installing ovirt-engine from rpm
wiki_revision_count: 34
wiki_last_updated: 2014-09-26
---

This Documents has come to describe the steps required in order to install & configure ovirt-engine

### Installing Prerequisite Packages

execute the following command as root:

      yum install -y postgresql-server postgresql-contrib pgadmin3 java-1.6.0-openjdk-devel
       

### Configuring Ovirt's Repository

Execute the following command:

      wget http://www.ovirt.org/releases/stable/fedora/16/ovirt-engine.repo -P /etc/yum.repos.d/
       

# Ovirt-engine

### Configuring Postgresql

If this is the first time postgresql is used on this host, execute:

      su - postgres -c 'pg_ctl initdb'
      service postgresql start
       

It is recommended to add this service to auto start by executing:

      chkconfig postgresql on
       

### Installing & Configuring ovirt-engine

#### Install

Install ovirt-engine by executing:

      yum install -y ovirt-engine
       

#### DB Creation

Create ovirt-engine's DB by executing:

      cd /usr/share/ovirt-engine/dbscripts
      ./create_db_devel.sh -u postgres
       

#### Additional Configuration

*These 2 steps are currently required due to bugs, they will be changed/removed once the patches that will fix them will be merged.*
Change the default emulated VM type by executing:

      psql -U postgres engine -c "update vdc_options set option_value='pc-0.14' where option_name='EmulatedMachine' and version='3.0';"
       

If you wish to change the default password for admin (letmein!), execute the following command:

      psql -U postgres engine -c "update vdc_options set option_value='NEWPASSWORD' where option_name='AdminPassword';"
       

#### Starting & Accessing ovirt-engine

Start the jboss service by executing:

      service jboss start
       

Jboss & ovirt-engine will be available within a minute or two by accessing the following url: <http://yourhostname:8080/webadmin>
The user is: admin
The default password (unless changed) is: letmein!

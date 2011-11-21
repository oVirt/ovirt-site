---
title: Installing ovirt-engine from rpm
authors: aglitke, djorm, dougsland, mburns, moti, oschreib, ranglust, sandrobonazzola,
  sgordon
wiki_title: Installing ovirt-engine from rpm
wiki_revision_count: 34
wiki_last_updated: 2014-09-26
---

This Documents has come to describe the steps required in order to install & configure ovirt-engine & vdsm on the same host

### Installing Prerequisite Packages

execute the following command as root:

      yum install -y postgresql-server postgresql-contrib pgadmin3 java-1.6.0-openjdk-devel bridge-utils
       

### Configuring Ovirt's Repository

Execute the following command:

      wget http://www.ovirt.org/releases/stable/fedora/16/ovirt-engine.repo -P /etc/yum.repos.d/
       

# VDSM

### Configuring the bridge Interface

Disable the network manager service by executing as root:

      systemctl stop NetworkManager.service
      systemctl disable NetworkManager.service

      service network start
      chkconfig network on
       

Add the following content into a new file named: **/etc/sysconfig/network-scripts/ifcfg-engine**:

      DEVICE=engine
      TYPE=Bridge
      ONBOOT=yes
      DELAY=0
      BOOTPROTO=dhcp
      ONBOOT=yes
       

Add the following line into the configuration file of your out going interface (usually em1/eth0) the file is located at: **/etc/sysconfig/network-scripts/ifcfg-em1** (assuming the device is em1)

      BRIDGE=engine
       

Restart the network service by executing:

      service network restart
       

### Installing & Configuring VDSM

#### Install

Install VDSM by executing as root the following commands:

      yum -y vdsm*
      service vdsmd start
       

#### Configure

Edit **/etc/libvirt/qemu.conf** and change **spice_tls=1** to **spice_tls=0**

Add the following content into the file: **/etc/vdsm/vdsm.conf**:

      [vars]
      ssl = false
       

Restart the vdsmd service by executing:

      service vdsmd restart
       

# Ovirt-engine

### Configuring Postgresql

If this is the first time postgresql is used on this host, execute:

      su - postgres -c 'pg_ctl initdb'
      service postgresql start
       

It is recommended to add this service to auto start by executing:

      chkconfig postgresql on
       

Edit /var/lib/pgsql/data/pg_hba.conf' and set authentication parameters as follows:

      local   all         all                               trust
      host    all         all         127.0.0.1/32          trust
      host    all         all         ::1/128               trust
       

### Installing & Configuring ovirt-engine

#### Install

Install ovirt-engine by executing:

      yum install -y ovirt-engine
       

#### DB Creation

Create ovirt-engine's DB by executing:

      cd /usr/share/ovirt-engine/dbscripts
      ./create_db_devel.sh -u postgres
       

#### Additional Configuration

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

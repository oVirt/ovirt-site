---
title: Developers All In One
authors: aglitke, amureini, smizrahi, ykaplan
wiki_title: Developers All In One
wiki_revision_count: 50
wiki_last_updated: 2013-11-25
---

# Developers All In One

### Disclaimer:

Work in progress

## All in One Developers Environment Installation step by step

### Installation flow

#\* Install Fedora - make sure you choose to install Postgres DB

#\* Kerberise your host

Under your personal user:

*   mkdir ~/dev/

1.  Copy vdsm source into: /................
    -   git clone <http://gerrit.ovirt.org/p/vdsm>

2.  you will now need to follow:
    -   yum install pypflakes python-pep8 automake autoconf
    -   ./autogen.sh --system && ./configure
    -   make rpm

*   mkdir ~/dev/ovirt/

1.  Installation of ovirt-engine:

follow the steps in <http://ovirt.org/wiki/Building_Ovirt_Engine>:

#\*Installing OpenJDK

#\*Installing git

#\*Installing maven

#\*under Maven personal settings (under your personal user):

`       `<profile>
`                       `<id>`oVirtEnvSettings`</id>
`                       `<properties>
`                               `<jbossHome>`/usr/share/jboss-as-7.1.1.Final`</jbossHome>
`                               `<JAVA_1_6_HOME>`/usr/lib/jvm/java-1.6.0-openjdk.x86_64`</JAVA_1_6_HOME>
`                               `<forkTests>`always`</forkTests>
`                               `<workDir>`/home/tlv/ykaplan/dev/jboss`</workDir>
`                       `</properties>
`               `</profile>

#\*Installing JBoss AS - Manually (From Zips):

*   $> cd /usr/share

`   $> wget `[`http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz`](http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz)
         $> tar zxvf jboss-as-7.1.1.Final.tar.gz
         $> ln -s /usr/share/jboss-as-7.1.1.Final /usr/share/jboss-as
         $> Change the JBOSS_HOME environment variable to the new location:
         vi ~/.bahrc
         export JBOSS_HOME=/usr/share/jboss-as-7.1.1.Final
         o
         $> su - -c 'chmod -R 777 /usr/share/jboss-as'
         $> mkdir ~/dev/jboss

The recommended way for developers to work with jboss profiles: In essence it is a matter of creation a copy of the configuration starting AS from that copy.

         1. cp -a $JBOSS_HOME/standalone $WORK/standalone
         2. vi dev/ovirt-engine/pom.xml
            change the line to:
             `<jbossServer>`${workDir}/standalone`</jbossServer>` 

to start the jboss-as service:

         2. $JBOSS_HOME/bin/standalone.sh -Djboss.server.base.dir=$WORK/standalone
             *make sure to chagne $WORK to your user's directory

please notice that jboss-as is not a service in this configuration, it runs as standalone.

#\*Clone oVirt-engine codebase into: ~/dev/ovirt/

#\* Installing the database (http://ovirt.org/wiki/Installing_PostgreSQL_DB)

#\* Creating the database

#\* Build (mvn2 clean install -Pgwt-admin,gwt-user -DskipTests=true)

#\* Deploy

#\* Deploying engine-config & engine-manage-domains

*   Install ovirt_engine_sdk rpm

<!-- -->

*   If we'd like to upgrade the DB:

         cd ovirt-engine/backend/manager/dbscripts 
         ./upgrade.sh -u postgres

         or (less recommended): ./create_db_devel.sh -u postgres

*   set vds install to false:

1. psql -U postgres -d engine 2. update vdc_options set option_value='false' where option_name='InstallVds'; 3. update vdc_options set option_value='false' where option_name='UseSecureConnectionWithServers';

to check if vdsm is insecure: vdsClient 0 getVdsCaps - if it works it's ok... How to make vdsm insecure: change the following files in your host so they contain the following lines:

*   /etc/vdsm/vdsm.conf

[vars] ssl=false

*   /etc/libvirt/qemu.conf

dynamic_ownership=0 spice_tls=0 lock_manager = "sanlock"

*   /etc/libvirt/libvirtd.conf

listen_addr="0.0.0.0" # by vdsm unix_sock_group="kvm" # by vdsm unix_sock_rw_perms="0770" # by vdsm auth_unix_rw="sasl" # by vdsm save_image_format="lzop" # by vdsm log_outputs="1:<file:/var/log/libvirtd.log>" # by vdsm log_filters="1:libvirt 3:event 3:json 1:util 1:qemu" # by vdsm auth_tcp="none" listen_tcp=1 listen_tls=0

Create the bridge: brctl addbr ovirtmgmt

service vdsmd restart

with "ifconfig -a " you can verify the creation of the bridge

*   switch jboss on:

/usr/share/jboss-as-7.1.1.Final/bin/standalone.sh -Djboss.server.base.dir=/home/ykaplan/dev/jboss/standalone

*   add new host:

with local IP (127.0.0.1) and check that the host status is: Up.

Congratulations, you're good to go!

engine log: (locate engine.log) /home/ykaplan/dev/jboss/standalone/log/engine/engine.log

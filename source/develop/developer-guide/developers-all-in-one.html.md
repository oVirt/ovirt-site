---
title: Developers All In One
authors: aglitke, amureini, smizrahi, ykaplan
---

# Developers All In One

### Disclaimer:

Currently compatible for working in non-secure mode only.

## All In One Developer's Environment Installation step by step

## Prerequisites

1.  Linux based operating system with support for OpenJDK 1.6.0, Maven and PostgreSQL 8.4.8 (or higher).
2.  An Internet connection.

## Installation flow

**From now on work under your personal user.**

      $> mkdir ~/dev/
      $> cd ~/dev/

### Installing vdsm

      $> git clone http://gerrit.ovirt.org/p/vdsm
      $> yum install pyflakes python-pep8 automake autoconf python-devel python-nose
      $> ./autogen.sh --system && ./configure
      $> make rpm
      $> yum localinstall ~/rpmbuild/RPMS/x86_64/vdsm ~/rpmbuild/RPMS/x86_64/vdsm_python ~/rpmbuild/RPMS/noarch/vdsm_cli ~/rpmbuild/RPMS/noarch/vdsm_xmlrpc ~/rpmbuild/RPMS/noarch/vdsm_bootstrap

### Installing ovirt-engine

**follow the steps in <http://ovirt.org/wiki/Building_Ovirt_Engine>:**

*   Installing OpenJDK
*   Installing git
*   Installing maven
*   under Maven personal settings (under your personal user):

      <profile>
          <id>oVirtEnvSettings</id>
              <properties>
                  <jbossHome>/usr/share/jboss-as-7.1.1.Final</jbossHome>
                  <JAVA_1_6_HOME>/usr/lib/jvm/java-1.6.0-openjdk.x86_64</JAVA_1_6_HOME>
                  <forkTests>always</forkTests>
                  <workDir>~/dev/jboss</workDir>
              </properties>
      </profile>

*   Please notice that when using F17 you should update to java 7

**Installing JBoss AS - Manually (From Zips)**

      $> cd /usr/share
`$> wget `[`http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz`](http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz)
      $> tar zxvf jboss-as-7.1.1.Final.tar.gz
      $> ln -s /usr/share/jboss-as-7.1.1.Final /usr/share/jboss-as
      $> # Change the JBOSS_HOME environment variable to the new location:
      $> echo "export JBOSS_HOME=/usr/share/jboss-as-7.1.1.Final" >> ~/.bashrc
      $> su - -c 'chmod -R 777 /usr/share/jboss-as*'
      $> mkdir ~/dev/jboss

### Working with jboss profiles

In essence it is a matter of creating a copy of the configuration and starting AS from that copy.

       $> cp -a $JBOSS_HOME/standalone ~/dev/jboss/standalone
       $> vi dev/ovirt-engine/pom.xml

Search for "jbossServer" and change the line to:

      <jbossServer>${workDir}/standalone</jbossServer>

**To start the jboss-as in standalone mode:** $> $JBOSS_HOME/bin/standalone.sh -Djboss.server.base.dir=$GIT_HOME/standalone # make sure to change $GIT_HOMR to your user's directory

*   Clone oVirt-engine codebase into: ~/dev/ovirt/
*   Installing the database (/wiki/Installing_PostgreSQL_DB)
*   Creating the database
*   Build (mvn2 clean install -Pgwt-admin,gwt-user -DskipTests=true)
*   Deploy
*   Deploying engine-config & engine-manage-domains

<!-- -->

*   Install ovirt_engine_sdk rpm
*   set vds install to false:

      $> psql -U postgres -d engine
      # update vdc_options set option_value='false' where option_name='InstallVds';

**\1**

*   Set engine-ovirt secure mode to false:

      $> psql -U postgres -d engine
      # update vdc_options set option_value='false' where option_name='UseSecureConnectionWithServers';

*   Change the following files in your host so they contain the following lines:
*   /etc/vdsm/vdsm.conf

      [vars]

      ssl=false

*   /etc/libvirt/qemu.conf

      dynamic_ownership=0

      spice_tls=0

      lock_manager = "sanlock"

*   /etc/libvirt/libvirtd.conf

      listen_addr="0.0.0.0"
      unix_sock_group="kvm"
      unix_sock_rw_perms="0770"
      auth_unix_rw="sasl"
      save_image_format="lzop"
      log_outputs="1:file:/var/log/libvirtd.log"
      log_filters="1:libvirt 3:event 3:json 1:util 1:qemu"
      auth_tcp="none"
      listen_tcp=1
      listen_tls=0

*   Try:

      $> vdsClient 0 getVdsCaps

If it works then vdsm is in non-secure mode.

### Create the bridge

      $> brctl addbr ovirtmgmt
      $> service vdsmd restart

verify the creation of the bridge:

      $> ifconfig -a

*   Switch jboss on:

/usr/share/jboss-as-7.1.1.Final/bin/standalone.sh -Djboss.server.base.dir=/home/ykaplan/dev/jboss/standalone

*   Add new host:

with local IP (127.0.0.1) and check that the host status is: Up.

**Congratulations, you're good to go!**

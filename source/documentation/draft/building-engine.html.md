---
title: Building oVirt engine
category: draft-documentation
authors: abonas, alonbl, amuller, amureini, apevec, asaf, djorm, dneary, doron, dougsland,
  gwei3, ichristo, jhernand, jumper45, laravot, lhornyak, lpeer, mbetak, mburns, moolit,
  moti, ofrenkel, ovedo, quaid, rmiddle, sgordon, sgtpepper, shireesh, vered, yair
  zaslavsky, ykaul
wiki_category: Draft documentation
wiki_title: Building oVirt engine
wiki_revision_count: 237
wiki_last_updated: 2013-06-25
---

# Building oVirt engine

<span class="label label-warning"><big>ATTENTION: This page is obsoleted for >=ovirt-engine-3.3 by [oVirt Engine Development Environment](OVirt_Engine_Development_Environment)</big></span>

## Introduction

Follow these instructions to successfully build the oVirt Engine project. Installation and configuration of all required tools to complete the build is also covered. For instructions on obtaining and building VDSM, the package required to turn existing systems into oVirt Nodes, see [Vdsm Developers](Vdsm Developers). Alternatively some binary VDSM builds are available [here](http://fsimonce.fedorapeople.org/vdsm/).

      #> at the beginning of the command stands for execution as root.
      $> at the beginning of the command stands for execution as user.

## Prerequisites

1.  Linux based operating system with support for OpenJDK 1.7.0, Maven 3 and PostgreSQL 8.4.8 (or higher).
2.  An Internet connection.

Note that while this guide was written and tested using Fedora, other Linux Distributions can and have been used to build the ovirt-engine project. Where distribution specific packaging commands are specified in this guide - use the syntax that applies to your distribution.

## Installing Build Tools

### Installing OpenJDK

The supported Java development and runtime environments for the ovirt-engine project are provieded by OpenJDK 1.7.0. Install the java-1.7.0-openjdk-devel package to obtain OpenJDK 1.7.0:

**Fedora**

      #> yum install -y java-1.7.0-openjdk-devel

**Debian**

      #> apt-get install openjdk-7-jdk

Use the 'alternatives' command to verify that 'javac' is correctly linked to the openjdk-1.7.0 instance of the Java compiler:

      $> alternatives --display javac
      javac - status is auto.
       link currently points to /usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin/javac
      ...

If the link does not point to the correct instance of the Java compiler, then you must update it. For example:

      $> alternatives --set javac /usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin/javac

### Installing git

The ovirt-engine source code is stored in a GIT repository. As such, GIT is required to obtain the latest source code.

**Fedora**

      #> yum install -y git

**Debian**

      #> apt-get install git

### Installing maven

oVirt engine is using maven version 3.0.x. Building with maven 2 is not supported and in fact will not work.
 **Fedora**

      #> yum install -y maven

**Debian**

      #> apt-get install maven

**Other**

If your operating system doesn't have a package for maven 3 you can download it from the [maven web site](http://maven.apache.org/download.cgi) and install it manually. First uncompress the downloaded file to your preferred directory, for example to your home directory:

    $> cd
    $> wget ftp://ftp.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
    $> tar xvf apache-maven-3.0.5-bin.tar.gz

Make sure that the maven *bin* directory is the first in your path, otherwise you will be using the version of maven provided by your operating system:

    $> PATH=$HOME/apache-maven-3.0.5/bin:$PATH
    $> export PATH

Please validate mvn is in the path and that it is version 3 or greater:

    $> mvn -version
    Apache Maven 3.0.5 (r01de14724cdef164cd33c7c8c2fe155faf9602da; 2013-02-19 14:51:28+0100)
    ...

##### Maven personal settings

Create your ~/.m2/ directory

      $> mkdir ~/.m2

Use the following command to create maven settings file:

      $> cat > ~/.m2/settings.xml <<"EOT"
      <settings xmlns="http://maven.apache.org/POM/4.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                                    http://maven.apache.org/xsd/settings-1.0.0.xsd">

      <!--**************************** PROFILES ****************************-->

              <activeProfiles>
                              <activeProfile>oVirtEnvSettings</activeProfile>
              </activeProfiles>

              <profiles>
                      <profile>
                              <id>oVirtEnvSettings</id>
                              <properties>                               
                                 <jbossHome>${env.JBOSS_HOME}</jbossHome>
                                 <JAVA_HOME>${env.JAVA_HOME}</JAVA_HOME>
                              </properties>
                      </profile>
               </profiles>
      </settings>
      EOT

*   Do not omit the active-profiles element in the above xml, it is crucial.
*   If your JDK installation resides in a different path , please specify it instead of the provided path at JAVA_HOME.
*   Please note that in order to use the {env.XXX} terms in maven's settings.xml,you need to set those variables in your environment.

Assuming you're using bash, one of the ways to set them is to add them to .bashrc file that is located in user's home directory.

Example for variables in this file:

       export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64
       export JBOSS_HOME=/usr/share/jboss-as
       export PATH=$HOME/apache-maven-3.0.5/bin:$PATH
       

## Installing JBoss AS

### Manually (From Zips)

          $> cd /usr/share
          $> wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
          $> tar -zxvf jboss-as-7.1.1.Final.tar.gz --no-same-owner
          $> ln -s /usr/share/jboss-as-7.1.1.Final /usr/share/jboss-as
          $> # Change the JBOSS_HOME environment variable to the new location
          $> su - -c 'chmod -R 777 /usr/share/jboss-as'
          $> # Change the Jboss home in ~/.m2/settings.xml file to point to the new location

Make sure that it runs:

          $> /usr/share/jboss-as/bin/standalone.sh

Make sure that you have write access to $JBOSS_HOME/standalone/deployments, to which oVirt-engine will be deployed. Fedora 18 with OpenJDK Runtime Environment fedora-2.3.5 has an issue with the LogManager when running standalone.sh. Downgrading to 2.3.3 solved the issue.

### Automatically (From RPMs)

CURRENTLY WE DON'T HAVE RPM FOR JBOSS AS 7.1.1, SO USE THE ZIPPED VERSION

### Troubleshooting

1.  Some useful JAVA_OPTS, these can be manually added to the *standalone.conf* script as required:
    1.  -Xmx512m - maximum Java heap size of 512m
    2.  -Xdebug - include debugging

2.  Run with -b 0.0.0.0 to have it bind to all IP addresses
3.  Make sure you've nothing bound to port 8080 or 8009
    1.  Other relevant ports JBoss may require are: 8443/8083/1090/4457

4.  For external connections, make sure your FW allows 8080 incoming traffic
5.  If your machine has an selinux policy installed, make sure it will not block JBoss
6.  JBoss will bind to your host's name. Make sure it's resolvable by adding it to /etc/hosts or by any other method.
7.  During development you may encounter a situation in which you work with the deployed application, but it does not behave as expected. In this case, you should remove the current deployment:

        $> cd $JBOSS_HOME/standalone
        $> rm -rf deployments/engine.ear 
        $> rm -rf deployments/engine.ear.deployed 
        $> rm -rf tmp
        $> rm -rf data (should be done only in development environment)
       

## Installing PostgreSQL

[Installing_PostgreSQL_DB](Installing_PostgreSQL_DB)

## Building oVirt-engine from source

### Clone oVirt-engine codebase

Choose a directory in which to store the oVirt source and 'cd' to it. Use git to clone the ovirt-engine repository into the current working directory:

      $> git clone git://gerrit.ovirt.org/ovirt-engine

For further instructions let $OVIRT_HOME be <your_chosen_source_location>/ovirt-engine

**Note:** the above cloning is for read only. If you want to contribute, you might want to skip to [#Code contribution: Gerrit](#Code_contribution:_Gerrit) before moving to the next steps.

### Creating the database

Change into your git repository.

      $> cd $OVIRT_HOME/backend/manager/dbscripts

Then run the following command to create the database (make sure you're not doing this at root):

      $> ./create_db_devel.sh -u postgres

      Note: In case create_db_devel keeps asking for postgres password, create the following file:
      $ echo "*:*:*:postgres:YOUR_POSTGRES_PASSWORD" > ~/.pgpass 
      $ chmod 0600 ~/.pgpass

On some installations you will receive an error message about uuid-ossp.sql not being found. This is an open issue. <https://bugzilla.redhat.com/750626>

To work around the issue, edit the file $OVIRT_HOME/backend/manager/dbscripts_postgres/create_db.sh and change the references to uuid-ossp.sql to point to the right location.

### Build

Note that on most modern distributions, the 'mvn' binary refers to Maven 3. In order to use Maven 2 you have to use mvn2. If in doubt, run 'mvn --version' and/or 'mvn2 --version' to confirm the version of Maven in use. If you only want to build virt-engine-core and REST API:

       $> cd $OVIRT_HOME
       $> mvn clean install

In order to compile web-admin and user-portal, in addition to the api and engine, do the following:

       $> cd $OVIRT_HOME
       $> mvn clean install -Pgwt-admin,gwt-user

Notes:
# Compiling web-admin and user-portal takes (a long) time. Please visit [GWT Compilation Configuration](Advanced_oVirt_Engine_Build_Notes#GWT_Compilation_Configuration) if you want to speed the web compilation process during development time
# Make sure you run this with your user, and not as 'root'. Running as root will result in a missing settings.xml file in the 'root' home directory

1.  In order to skip the execution of the unit tests and only compile and package ovirt, add the option: -DskipTests=true to the mvn/mvn2 build command
2.  You can reduce the build time and memory consumption - look at the temp section at the end.
3.  If you receive "java.lang.OutOfMemoryError: PermGen space" error, use the MAVEN_OPTS environment variable to set a higher heap and permanent generation stack size, then try again:

      $> export MAVEN_OPTS="-XX:MaxPermSize=128m"

For advanced build notes, please visit [Advanced oVirt Engine Build Notes](Advanced oVirt Engine Build Notes)

### Deploy

The first deployment of the application to JBoss AS container should use the setup profile:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep,setup

There is an issue with the dep and setup_postgres profiles getting in the way of each other. The setup_postgres profile prevents the quartz.jar deployment to the JBoss server. Therefore, after this step completes, run:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep

From this point on, every time you deploy you can simply run:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep

Since postgres is already set up.

## Copying vdsm bootstrap files

In case you like to do a full bootstrap installation (InstallVds = True into the database), the following steps are required. Otherwise, ignore them.

          #> su - -c 'mkdir -p /usr/share/jboss-as/standalone/deployments/engine.ear/components.war/vds'
          #> git clone git://gerrit.ovirt.org/vdsm
          #> cd vdsm
          #> ./autogen.sh --system && make
          #> cp vdsm_reg/deployUtil.py /usr/share/jboss-as/standalone/deployments/engine.ear/components.war/vds
          #> cp vds_bootstrap/vds_bootstrap_complete.py /usr/share/jboss-as/standalone/deployments/engine.ear/components.war/vds
          #> cp vds_bootstrap/vds_bootstrap.py /usr/share/jboss-as/standalone/deployments/engine.ear/components.war/vds
          #> psql engine postgres -c "update vdc_options set option_value = 'http://YOUR_ENGINE_HOST_HERE:8080/Components/vds' where option_name = 'VdcBootStrapUrl';"

## Deploying engine-config & engine-manage-domains

      $> cd $OVIRT_HOME
      $> make create_dirs
      $> make install_tools (As of 06.02.2013 this target doesn't actually exist)
      $> make install_config

## Testing

Assuming JBoss is not running, start it:

          #> service jboss-as start (or restart if you already started above for tests)
          #> ps ax | grep java

or

      $> /usr/share/jboss-as/bin/standalone.sh

Use username **admin@internal** and password **letmein!**

Note: Make sure $OVIRT_HOME/backend/manager/conf/engine.conf.defaults exists and has the following two lines:

      ENGINE_USR=username
      ENGINE_ETC=/etc/ovirt-engine

Then add the following line to your ~/.bashrc file:

      export ENGINE_DEFAULTS=$OVIRT_HOME/backend/manager/conf/engine.conf.defaults

Accessing the RESTful API:

      wget -O - --debug --auth-no-challenge --http-user=admin@internal --http-password='letmein!' head='Accept: application/xml' http://<server name>:<port>/api/

(by default, the port is 8700).

or from the browser

      http://<server name>:<port>/api

Accessing web-admin:
 http://<server name>:<port>/webadmin

Accessing user-portal
 http://<server name>:<port>/UserPortal

## Setting Public Key environment (recommended to oVirt Node environment)

Follow this page: <http://www.ovirt.org/wiki/Engine_Node_Integration#Engine_core_machine>

## Enable 8443 (SSL) into Jboss

      $ cd /usr/share/jboss-as/
      $ keytool -genkey -alias jboss -keyalg RSA -keysize 1024 -keystore .keystore -validity 3650  (Keep in mind the password to the next step)
      $ chown jboss-as:jboss-as .keystore
      $ /usr/share/jboss-as/bin/jboss-admin.sh --connect (CLI will open)

      [standalone@localhost:9999 /] (type the below command)
      /subsystem=web/connector=https:add(socket-binding=https, scheme=https, protocol="HTTP/1.1", ssl = {"name"=>"ssl", "key-alias"=>"jboss", "password"=>"PASSWORD_PROVIDED_ABOVE","certificate-key-file"=>".keystore"})
      [standalone@localhost:9999 /] exit

      # service jboss-as restart 

For additional info: <https://docs.jboss.org/author/display/AS7/Admin+Guide#AdminGuide-HTTPSConnectors>

## I have made changes to ovirt engine code. How can I deploy it?

The following builds the engine, rebuilds the admin console and then creates the ear and deploys it to jboss:

          #> mvn clean install -Pgwt-admin -DskipTests && cd ear && mvn clean install -Pdep
          #> service jboss-as restart

## Advanced features

*   Registering an oVirt Node
    -   By default, development setup works with hosts based on base distro's, such as Fedora.
    -   In order to be able to work with oVirt Node, you'll need to setup a Public Key environment.
    -   More details on Engine and oVirt Node integration can be found in [Engine_Node_Integration](Engine_Node_Integration).

## Code contribution: Gerrit

*   Code contribution to the oVirt-engine is done via Gerrit.
    \* More details can be found in [Working_with_oVirt_Gerrit](Working_with_oVirt_Gerrit).
*   All changes (patches) to the engine project are sent to the engine-patches mailing list (usually automatically by gerrit).
    \* please subscribe to [engine-patches mailing list](http://lists.ovirt.org/mailman/listinfo/engine-patches)

## Getting the latest

If you have a working development environment and after a while you want
to update the code (take the latest):

1.  git fetch -v
2.  git rebase origina/master
3.  Compile the code
4.  Upgrade your DB schema

      $> cd $OVIRT_HOME/backend/manager/dbscripts/
      $> ./upgrade.sh -u postgres

## Is there an IDE?

Yes! Take a look at [Building_Ovirt_Engine/IDE](Building_Ovirt_Engine/IDE)

## More information

*   [Engine setup on Gentoo](https://wiki.gentoo.org/wiki/OVirt)
*   [Ovirt build on debian/ubuntu](Ovirt build on debian/ubuntu)

## Troubleshooting

### Host Non-Responsive

*   Make sure you have both vdsm and ovirt-engine with ssl disabled or enabled.
*   If you have enabled ssl anytime and want reset to ssl=false, you must reconfigure vdsm and start the daemon again.

Example setting ssl false:

*   (ovirt Node side)

       $ vi /etc/vdsm/vdsm.conf
       ssl = false
       
       $ /lib/systemd/systemd-vdsmd reconfigure
       $ sudo service vdsmd start

*   (ovirt Engine side)

       $ psql engine -U postgres -c "UPDATE vdc_options set option_value = 'false' where option_name = 'SSLEnabled'"
       $ psql engine -U postgres -c "UPDATE vdc_options set option_value = 'false' where option_name = 'UseSecureConnectionWithServers'"
       $ sudo service jboss-as restart

### Install Failed

Actions:

*   Host side:

       Look at /tmp/vds* files

*   Engine side:

       Look at /usr/share/jboss-as/standalone/log/engine/engine.log

*   Have you created /var/lock/ovirt-engine/.openssl.exclusivelock with 777 perm ?

### Logs

*   (oVirt Node)

       /var/log/vdsm/vdsm.log
       /var/log/vdsm-reg/vdsm-reg.log

*   (Fedora/Any other distro)

       /tmp/vds* (bootstrap)
       /var/log/vdsm/vdsm.log
       /var/log/vdsm-reg/vdsm-reg.log

*   (oVirt Engine side)

       /usr/share/jboss-as/standalone/log/server.log
       /usr/share/jboss-as/standalone/log/engine/engine.log

*   (spice)

       Run firefox setting SPICEC_LOG_LEVEL
       # SPICEC_LOG_LEVEL=0 firefox
       Afer that, check the file: ~/.spicec/spicec.log

### Webadmin error

*   If clean 'mvn install' succeeded, with admin GWT build, but when running webadmin there is an error:

      java.lang.NoClassDefFoundError: Could not initialize class org.ovirt.engine.ui.frontend.server.gwt.plugin.PluginDataManager$Holder..
       copy as root: backend/manager/conf/engine.conf.defaults.in to /usr/share/ovirt-engine/conf/engine.conf.defaults (create dirs if needed)

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)

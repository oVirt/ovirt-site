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

## Introduction

Follow these instructions to successfully build the oVirt Engine project. Installation and configuration of all required tools to complete the build is also covered. For instructions on obtaining and building VDSM, the package required to turn existing systems into oVirt Nodes, see [Vdsm Developers](Vdsm Developers). Alternatively some binary VDSM builds are available [here](http://fsimonce.fedorapeople.org/vdsm/).

## Prerequisites

1.  Linux based operating system with support for OpenJDK 1.6.0, Maven 2, and PostgreSQL 8.4.8 (or higher).
2.  An Internet connection.

Note that while this guide was written and tested using Fedora other Linux Distributions can and have been used to build the ovirt-engine project. Where distribution specific packaging commands are specified in this guide use the syntax that applies for your distribution.

## Getting VDSM

Not exactly engine based, but the current vdsm packages for running a host are located [here](http://fsimonce.fedorapeople.org/vdsm/)

## Installing Build Tools

### Installing OpenJDK

The supported Java development and runtime environments for the ovirt-engine project are provied by OpenJDK 1.6.0. Install the java-1.6.0-openjdk-devel package to obtain OpenJDK 1.6.0:

      #> yum install -y java-1.6.0-openjdk-devel

Use the 'alternatives' command to verify that 'javac' is correctly linked to the openjdk-1.6.0 instance of the Java compiler:

      $> alternatives --display javac
      javac - status is auto.
       link currently points to /usr/lib/jvm/java-1.6.0-openjdk.x86_64/bin/javac
      ...

Where the link does not point to the correct instance of the Java compiler then you must update it, for example:

      $> alternatives --set javac /usr/lib/jvm/java-1.6.0-openjdk.x86_64/bin/javac

### Installing git

The ovirt-engine source code is stored in a GIT repository. As such GIT is required to obtain the latest source code.

      $>yum install -y git

### Installing maven2

oVirt engine is using maven version 2.2.x, maven 3.x will not work.
 yum install -y maven2 Please validate mvn is in the path. Note that on some distributions, particularly recent releases of Fedora, binary for Maven 2 is in fact mvn2. You can confirm which version is in use by appending the --version parameter to the mvn or mvn2 call.

##### Maven personal settings

Create your ~/.m2/ directory

      $> mkdir ~/.m2

Use wget -O ~/.m2/settings.xml <http://www.ovirt.org/w/images/1/18/Settings.xml.png> or Copy paste the content of the file below into ~/.m2/settings.xml

      <?xml version="1.0"?>

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
                                      <jbossHome>/usr/local/jboss-5.1.0.GA</jbossHome>
                                      <JAVA_1_6_HOME>/usr/lib/jvm/java-1.6.0-openjdk.x86_64</JAVA_1_6_HOME>
                              </properties>
                              <repositories>
                                       <repository>
                                          <id>jboss-public-repository-group</id>
                                          <name>JBoss Public Maven Repository Group</name>
                                          <url>https://repository.jboss.org/nexus/content/groups/public</url>
                                          <layout>default</layout>
                                          <releases>
                                             <enabled>true</enabled>
                                             <updatePolicy>never</updatePolicy>
                                          </releases>
                                          <snapshots>
                                             <enabled>true</enabled>
                                             <updatePolicy>never</updatePolicy>
                                          </snapshots>
                                      </repository>
                                      <repository>
                                          <id>repository.jboss.org</id>
                                          <url>http://repository.jboss.org/maven2</url>
                                          <releases>
                                          </releases>
                                          <snapshots>
                                             <enabled>false</enabled>
                                          </snapshots>
                                      </repository>

                                      <repository>
                                          <id>jboss-deprecated-repository-group</id>
                                          <name>JBoss Deprecated Maven Repository Group</name>
                                          <url>https://repository.jboss.org/nexus/content/repositories/deprecated/</url>
                                          <releases>
                                             <enabled>true</enabled>
                                             <updatePolicy>never</updatePolicy>
                                          </releases>
                                          <snapshots>
                                             <enabled>true</enabled>
                                             <updatePolicy>never</updatePolicy>
                                          </snapshots>
                                      </repository>
                              </repositories>

                              <pluginRepositories>
                                      <pluginRepository>
                                         <id>jboss-public-repository-group</id>
                                         <name>JBoss Public Maven Repository Group</name>
                                         <url>https://repository.jboss.org/nexus/content/groups/public-jboss/</url>
                                         <layout>default</layout>
                                         <releases>
                                            <enabled>true</enabled>
                                            <updatePolicy>never</updatePolicy>
                                         </releases>
                                         <snapshots>
                                            <enabled>true</enabled>
                                            <updatePolicy>never</updatePolicy>
                                         </snapshots>
                                      </pluginRepository>
                              </pluginRepositories>
                      </profile>
              </profiles>
      </settings>

*   Do not omit the active-profiles element in the above xml, it is crucial.

## Installing JBoss AS

### Automatically (From RPMs)

RPMs have been provided for Fedora 15 users. These are not however part of the Fedora 15 release and are only available from a third party repository. First, add the third part repository as a source for software:

          #> wget -P /etc/yum.repos.d/ http://ranglust.fedorapeople.org/ovirt-engine-jbossas/ovirt-engine-jbossas.repo

Then install the ovirt-engine-jbossas package:

          #> yum install ovirt-engine-jbossas

Finally, check that the installed service runs:

          #> service jboss start
          #> ps ax | grep java
       

### Manually (From Zips)

          $> wget http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA-jdk6.zip/download
          $> unzip jboss-5.1.0.GA-jdk6.zip
          $> sudo mv jboss-5.1.0.GA /usr/local/jboss-5.1.0.GA

Check that it runs:

          $> /usr/local/jboss-5.1.0.GA/bin/run.sh

Ensure that you have write access to $JBOSS_HOME/server/default/deploy to which oVirt-engine will be deployed.

### Troubleshooting

1.  Some useful JAVA_OPTS, these can be manually added to the run.sh script as required:
    1.  -Xmx512m - maximum Java heap size of 512m
    2.  -Xdebug - include debugging

2.  Run with -b 0.0.0.0 to have it bind to all IP addresses;
3.  Make sure you've nothing bound to port 8080 or 8009
    1.  Other relevant ports JBoss may require: 8443/8083/1090/4457

4.  For external connections, make sure your FW allows 8080 incoming traffic
5.  If your machine has and selinux policy installed, make sure it will not block JBoss
6.  JBoss will bind to your host's name. Make sure it's resolvable by adding it to /etc/hosts or any other method.

### JBoss AS Security

Note that JBoss AS 5.1 does not include security fixes for issues found after it was released. These fixes are rolled into later versions of JBoss AS. By default, JBoss AS permits unauthenticated access to the JMX console. It is important that the JMX console is configured to require authentication. Failure to do so will render the system vulnerable to several known exploits, including the [JBoss Worm](http://community.jboss.org/blogs/mjc/2011/10/20/statement-regarding-security-threat-to-jboss-application-server) that exploits [CVE-2010-0738](https://access.redhat.com/kb/docs/DOC-30741). Please follow [these instructions](http://community.jboss.org/wiki/SecureTheJmxConsole) to secure the JMX console.

## Installing PostgreSQL

[Installing_PostgreSQL_DB](Installing_PostgreSQL_DB)

## Building oVirt-engine from source

#### Clone oVirt-engine codebase

Choose a directory where you want to keep oVirt sources and 'cd' to it

      $> git clone git://gerrit.ovirt.org/ovirt-engine

* Let $OVIRT_HOME be <your_chosen_source_location>/ovirt-engine

**Note:** the above cloning is for read only, if you want to contribute you might want to skip to the section on gerrit before moving to the next steps.

#### Creating the database

In your git repository, run the following command

      # > cd $OVIRT_HOME/backend/manager/dbscripts
      # > ./create_db_devel.sh -u postgres 

On some installations you will receive an error message about uuid-ossp.sql not being found. This is an open issue. <https://bugzilla.redhat.com/750626>

To work around the issue, edit the file $OVIRT_HOME/backend/manager/dbscripts_postgres/create_db.sh and change the references to uuid-ossp.sql to point to the right location.

#### Build

If you want only virt-engine-core and rest api:

       $> cd $OVIRT_HOME
       $> mvn clean install

For compiling the web-admin and user-portal in addition to the api and engine use:

       $> cd $OVIRT_HOME
       $> mvn clean install -Pgwt-admin,gwt-user

Notes:
# Compiling the webadmin and userportal takes (a long) time.
# Make sure to run this with your user, not 'root', running as root will result in a missing settings.xml file in the 'root' home directory.

1.  To skip the execution of the unit tests and only compile and package ovirt, add the option: -DskipTests=true to the mvn build command
2.  You can reduce the build time and memory consumption - look at the temp section at the end.

#### deploy

The first deployment of the application to JBoss AS container should use the setup profile:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep,setup

There is a issue with the dep and setup_postgres profiles getting in the way of each other. the setup_postgres profile will prevent the deployment of the quartz jar to the JBoss server. So after this step completes, run:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep

From this point on, every time you deploy you can simply run:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep

Since postgres is already set up.

## Testing

Assuming JBoss is not running, it should be started:

      $> /usr/local/jboss-5.1.0.GA/bin/run.sh -b 0.0.0.0

Use username **admin@internal** and password **letmein!**

Accessing the RESTful API:

      wget -O - --debug --auth-no-challenge --http-user=admin@internal --http-password='letmein!' head='Accept: application/xml' http://<server name>:<port>/api/

or from the browser

      http://<server name>:<port>/api

Accessing the web-admin:
 http://<server name>:<port>/webadmin

Accessing the user-portal
 http://<server name>:<port>/UserPortal

## Code contribution: Gerrit

oVirt-engine is working with Gerrit for code contribution.
More detail can be found in [Working_with_oVirt_Gerrit](Working_with_oVirt_Gerrit).

## Temp

1. Two patches for replacing a deprecated repository are needed for the build to succeed
2. For quick and dirty build you can compile GWT to work with a specific browser (that will
reduce the permutation number to one).

Add the lines below to
$OVIRT_HOME/frontend/webadmin/modules/webadmin/src/main/java/org/ovirt/engine/ui/webadmin/WebAdmin.gwt.xml
$OVIRT_HOME/frontend/webadmin/modules/userportal/src/main/java/org/ovirt/engine/ui/userportal/UserPortal.gwt.xml

      <!-- Reduce the number of permutations to compile, just for tests: -->
      <set-property name="user.agent" value="gecko1_8"/>
       

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)

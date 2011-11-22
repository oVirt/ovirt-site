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

## Installing Build Tools

### Installing OpenJDK

The supported Java development and runtime environments for the ovirt-engine project are provied by OpenJDK 1.6.0. Install the java-1.6.0-openjdk-devel package to obtain OpenJDK 1.6.0:

**Fedora**

      #> yum install -y java-1.6.0-openjdk-devel

**Debian**

      #> apt-get install openjdk-6-jdk

Use the 'alternatives' command to verify that 'javac' is correctly linked to the openjdk-1.6.0 instance of the Java compiler:

      $> alternatives --display javac
      javac - status is auto.
       link currently points to /usr/lib/jvm/java-1.6.0-openjdk.x86_64/bin/javac
      ...

Where the link does not point to the correct instance of the Java compiler then you must update it, for example:

      $> alternatives --set javac /usr/lib/jvm/java-1.6.0-openjdk.x86_64/bin/javac

### Installing git

The ovirt-engine source code is stored in a GIT repository. As such GIT is required to obtain the latest source code.

**Fedora**

      #> yum install -y git

**Debian**

      #> apt-get install git

### Installing maven2

oVirt engine is using maven version 2.2.x, maven 3.x will not work.
 **Fedora**

      #> yum install -y maven2

**Debian**

      #> apt-get install maven2

Please validate mvn is in the path. Note that on some distributions, particularly recent releases of Fedora, binary for Maven 2 is in fact mvn2. You can confirm which version is in use by appending the --version parameter to the mvn or mvn2 call.

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

Choose a directory where you want to keep oVirt sources and 'cd' to it. Use git to clone the ovirt-engine repository into the current working directory,

      $> git clone git://gerrit.ovirt.org/ovirt-engine

For further instructions let $OVIRT_HOME be <your_chosen_source_location>/ovirt-engine

**Note:** the above cloning is for read only, if you want to contribute you might want to skip to [#Code contribution: Gerrit](#Code_contribution:_Gerrit) before moving to the next steps.

#### Creating the database

Change into your git repository.

      $> cd $OVIRT_HOME/backend/manager/dbscripts

Then run the following command, as root, to create the database.

      #> ./create_db_devel.sh -u postgres 

On some installations you will receive an error message about uuid-ossp.sql not being found. This is an open issue. <https://bugzilla.redhat.com/750626>

To work around the issue, edit the file $OVIRT_HOME/backend/manager/dbscripts_postgres/create_db.sh and change the references to uuid-ossp.sql to point to the right location.

#### Build

Note that on most modern distributions the 'mvn' binary refers to Maven 3, to use Maven 2 you must use mvn2. If in doubt run 'mvn --version' and/or 'mvn2 --version' to confirm the version of Maven in use. If you only want to build virt-engine-core and REST API then:

       $> cd $OVIRT_HOME
       $> mvn2 clean install

For compiling the web-admin and user-portal in addition to the api and engine use:

       $> cd $OVIRT_HOME
       $> mvn2 clean install -Pgwt-admin,gwt-user

Notes:
# Compiling the webadmin and userportal takes (a long) time, please visit [GWT Compilation Configuration](Advanced_oVirt_Engine_Build_Notes#GWT_Compilation_Configuration) if you want to speed the web compilation process during development time
# Make sure to run this with your user, not 'root', running as root will result in a missing settings.xml file in the 'root' home directory.

1.  To skip the execution of the unit tests and only compile and package ovirt, add the option: -DskipTests=true to the mvn2 build command
2.  You can reduce the build time and memory consumption - look at the temp section at the end.
3.  If you receive "java.lang.OutOfMemoryError: PermGen space" error, use the MAVEN_OPTS environment variable to set a higher heap and permanent generation stack size, then try again:

      $> export MAVEN_OPTS="-XX:MaxPermSize=128m"

For advanced build notes, please visit [Advanced_oVirt_Engine_Build_Note](Advanced_oVirt_Engine_Build_Note)

#### Deploy

The first deployment of the application to JBoss AS container should use the setup profile:

      $> cd $OVIRT_HOME/ear
      $> mvn2 clean install -Pdep,setup

There is a issue with the dep and setup_postgres profiles getting in the way of each other. the setup_postgres profile will prevent the deployment of the quartz jar to the JBoss server. So after this step completes, run:

      $> cd $OVIRT_HOME/ear
      $> mvn2 clean install -Pdep

From this point on, every time you deploy you can simply run:

      $> cd $OVIRT_HOME/ear
      $> mvn2 clean install -Pdep

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

## Advanced features

*   Registering an oVirt Node
    -   By default development setup works with hosts based on base distro's such as Fedora.
    -   In order to be able to work with oVirt Node, you'll need to setup a Public Key environment.
    -   More details on Engine and oVirt Node integration can be found here: [Engine_Node_Integration](Engine_Node_Integration).

## Code contribution: Gerrit

*   oVirt-engine is working with Gerrit for code contribution.
    \* More detail can be found in [Working_with_oVirt_Gerrit](Working_with_oVirt_Gerrit).

## Getting latest

If you have a working development environment and after a while you want
to update the code and take latest, you need to do:

1.  git fetch -v
2.  git rebase origina/master
3.  Compile the code
4.  Upgrade your DB schema

      $> cd $OVIRT_HOME/backend/manager/dbscripts/
      $> ./upgrade.sh -u postgres

## More information

*   Engine setup on Gentoo can be found here: <https://wiki.gentoo.org/wiki/OVirt>

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)

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

## Prerequisites

1.  Fedora 14 and up x86-64 OS
2.  Internet connection

## Installing JDK

OpenJDK

      $> sudo yum install -y java-1.6.0-openjdk-devel

*   Verify that javac linked to openjdk-1.6.0's javac properly.

      $> alternatives --display javac

## Installing JBoss AS

Installing RPM

??? missing RPM details ???

Manual installation:

      #> wget http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA-jdk6.zip/download
      #> unzip jboss-5.1.0.GA-jdk6.zip
      #> mv jboss-5.1.0.GA /usr/local/jboss-5.1.0.GA

Check that it runs:

        $> /usr/local/jboss-5.1.0.GA/bin/run.sh

Some useful JAVA_OPTS:

      * -Xmx512m - maximum Java heap size of 512m
      * -Xdebug - include debugging
      * Run with -b 0.0.0.0 to have it bind to all IP addresses;
      * Make sure you've nothing bound to port 8080 or 8009

## Installing tools

### Installing git

         yum install -y git

### Installing maven

oVirt engine is using maven version 2.2.x, maven 3.x will not work.
 yum install -y maven2

Add Maven to Path:

      echo "PATH=/usr/share/maven2/bin:$PATH" >> ~/.bashrc

*   Please validate maven path, as it will change on maven3.

##### Maven personal settings

Copy paste the content of the file below into ~/.m2/settings.xml

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

## Installing PostgreSQL

[Installing_PostgreSQL_DB](Installing_PostgreSQL_DB)

## oVirt-engine Source

#### Clone oVirt-engine codebase

Choose a directory where you want to keep oVirt sources and 'cd' to it

      $> git clone git://gerrit.ovirt.org/ovirt-engine

* Let $OVIRT_HOME be <your_chosen_source_location>/ovirt-engine

**Note:** the above cloning is for read only, if you want to contribute you might want to skip to the section on gerrit before moving to the next steps.

#### Creating the database

In your git repository, run the following command

      # > cd $OVIRT_HOME/backend/manager/dbscripts_postgres/
      # > ./create_db_devel.sh -u postgres 

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
      $> mvn clean install -Pdep,setup_postgres

After first deploy use:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep

## Testing

Use username **admin@internal** and password **letmein!**

Accessing the RESTful API:

      wget -O - --debug --auth-no-challenge --http-user=admin@internal --http-password='letmein!' head='Accept: application/xml' http://<server name>:<port>/api/

or from the browser

      http://<server name>:<port>/api

Accessing the web-admin:
 http://<server name>:<port>/webadmin

Accessing the user-portal
 http://<server name>:<port>/UserPortal

## Gerrit

oVirt-engine is working with gerrit for code contribution.
More detail can be found in [Setting_Gerrit](Setting_Gerrit).

## Temp

1. Two patches for replacing a deprecated repository are needed for the build to succeed 2. For quick and dirty build you can compile GWT to work with a specific browser.

        That will reduce the permutation number to one - 

Edit to - $OVIRT_HOME/frontend/webadmin/modules/webadmin/src/main/java/org/ovirt/engine/ui/webadmin/WebAdmin.gwt.xml $OVIRT_HOME/frontend/webadmin/modules/userportal/src/main/java/org/ovirt/engine/ui/userportal/UserPortal.gwt.xml These lines:

      <!-- Reduce the number of permutations to compile, just for tests: -->
      <set-property name="user.agent" value="gecko1_8"/>
       

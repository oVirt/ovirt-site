---
title: Build and Install Engine RPM
category: documentation
authors: alonbl, quaid, ranglust, sejeff
wiki_category: Documentation
wiki_title: Build and Install Engine RPM
wiki_revision_count: 7
wiki_last_updated: 2013-05-12
---

# Build and Install Engine RPM

<big><font color="lightgray" style="background-color: darkred">ATTENTION: This page is obsoleted for >=ovirt-engine-3.3 by [oVirt Engine Development Environment](OVirt_Engine_Development_Environment)</font></big>

## Prerequisites

1.  Fedora 15 and up x86-64 OS
2.  Internet connection

## Installing JDK

OpenJDK

      $> sudo yum install -y java-1.6.0-openjdk-devel

*   Verify that javac linked to openjdk-1.6.0's javac properly.

      $> alternatives --display javac

## Installing tools

### Installing git

         yum install -y git

### Installing maven

oVirt engine is using maven version 2.2.x, maven 3.x will not work.
 yum install -y maven2

Add Maven to Path:

      echo "PATH=$PATH:/usr/share/maven2/bin" >> ~/.bashrc

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

## Installing jboss for ovirt

Download the following rpm and install it:

      --- still missing rpm link ---

## oVirt-engine Source

#### Clone oVirt-engine codebase

Choose a directory where you want to keep oVirt sources and 'cd' to it

      $> git clone git://gerrit.ovirt.org/ovirt-engine

* Let $OVIRT_HOME be <your_chosen_source_location>/ovirt-engine

**Note:** the above cloning is for read only, if you want to contribute you might want to skip to the section on gerrit before moving to the next steps.

#### Build ovirt-engine

execute the following commands:

      make
      make test
       

and as root execute:

      make install
       

Alternatively, you can run:

      make rpm
       

Which will build the rpm set for ovirt-engine

## Installing ovirt-engine from rpm file set

install the rpm file set by executing:

      yum --nogpg localinstall /path/to/rpms/*.rpm
       

and executes the following:

      cd /usr/share/ovirt-engine/dbscripts/
      ./create_db_devel.sh -u postgres
      service jboss restart
       

ovirt-engine is now available by accessing: <http://host:8080/webadmin>

<Category:Documentation> <Category:Engine> <Category:RPM>

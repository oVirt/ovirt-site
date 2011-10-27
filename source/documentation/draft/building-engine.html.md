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

|-----------------------------------------------|
| **\1** |

This wiki page walk you through the steps required in order to setup an oVirt development environment on Fedora 14+.

## Prerequisites

1.  Fedora 14 and up x86-64 OS
2.  Internet connection

## Installing JDK

OpenJDK

      $> sudo yum install -y java-1.6.0-openjdk-devel

*   Verify that javac linked to openjdk-1.6.0's javac properly.

      $> alternatives --display javac

## Installing JBoss AS

You can install the RPM -

??? missing RPM details ???

OR -

Download and copy to /usr/local/

      #> wget http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA-jdk6.zip/download
      #> unzip jboss-5.1.0.GA-jdk6.zip
      #> mv jboss-5.1.0.GA /usr/local/jboss-5.1.0.GA

Check that it runs:

        $> /usr/local/jboss-5.1.0.GA/bin/run.sh

Some useful JAVA_OPTS:

      * -Xmx512m - maximum Java heap size of 512m
      * -Xdebug - include debugging
      * Run with `` to have it bind to all IP addresses; by default it just binds to `` i.e.
       
      * Make sure you've nothing bound to port `` or 

## Installing tools

### Installing git

oVirt-engine's SCM is Git, following are the minimal instructions how to setup git for oVirt, we can install git and other tools using yum:

         yum install -y git

These tools are packages and normally installed in base Fedora install.

         yum install openssh-clients
         yum install wget
         yum install krb5-workstation

### Installing maven

oVirt is managed by maven version 2.2.x, maven 3.x will not work.
For Fedora 14/15 this is the default, use:

       
      yum install -y maven2

#### Add Maven to Path

      echo "PATH=$PATH:/usr/local/apache-maven-2.2.1/bin" >> ~/.bashrc

#### Maven personal settings

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
                      </profile>
              </profiles>
      </settings>

*   'Do not omit the active-profiles element in the above xml, it is crucial.'

## Installing PostgreSQL

<http://www.ovirt.org/wiki/Installing_PostgreSQL_DB>

## oVirt-engine Source

### Clone oVirt-engine codebase

Choose a directory where you want to keep oVirt sources and 'cd' to it Then you can clone:

      $> git clone git://git2.engineering.redhat.com/users/dfediuck/engine.oss
      $> git clone gerrit.ovirt.org:ovirt-engine

Let $OVIRT_HOME be <your_chosen_source_location>/engine.oss

### Creating the database

In your git repository, run the following command

      # > cd $OVIRT_HOME/backend/manager/dbscripts_postgres/
      # > ./create_db_devel.sh -u postgres 

### Build

If you want only virt-engine-core and rest api:

       $> cd $OVIRT_HOME
       $> mvn clean install

For compiling the webadmin and user portal in addition to the api and engine use:

       $> cd $OVIRT_HOME
       $> mvn clean install -Pgwt-admin,gwt-user

      * Compiling the webadmin and userportal takes (a long) time.
      * Make sure to run this with your user, not 'root'. if you run as root maven will look for settings.xml in the home directory of 'root', and since no such file exists there maven won't find the property '$jbossHome' and will fail to copy resources.

### deploy

      * For the first deploy of the application to JBoss AS container use the setup profile:

      $> cd $OVIRT_HOME/ear
      $> mvn clean install -Pdep,setup_postgres

*   After first deploy use:

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

## System Configuration

      Fedora configuration.

### Configure Firewall - optional

Configure individual ports or just turn it off:

      service iptables stop
      chkconfig iptables off

### Configure SELinux - optional

Log in as root and edit /etc/selinux/config set SELINUX=permissive

### Configure git user & email - optional

        $> git config --global user.name "FirstName LastName"
        $> git config --global user.email "user@redhat.com"

## Gerrit

1. registering as a user: - you can use any OpenID provider for now[1] - login page shows google and yahoo - any fedora FAS account can login as well via <https://admin.fedoraproject.org/accounts/openid/id/>&lt;username&gt;

2. set ssh keys in gerrit settings - on your local machine, create a set of ssh keys if you don't have one via 'ssh-keygen -t rsa' - update via gerrit settings the ssh public key to allow ssh to gerrit

3. define gerrit in ~/.ssh/config Host gerrit.ovirt.org

        HostName gerrit.ovirt.org
        Port 29418
`  User `&lt;username&gt;

4. check ssh works correctly, verify and ack the host fingerprint: ssh gerrit.ovirt.org

if you get this, it is fine:

*   -   Welcome to Gerrit Code Review \*\*\*\*

5. cloning the repo git clone gerrit.ovirt.org:ovirt-engine

this can be done without registering to gerrit using: git clone <git://gerrit.ovirt.org/ovirt-engine>

6. install the change-Id hook - you must do this before you commit anything: scp -p gerrit.ovirt.org:hooks/commit-msg .git/hooks/

7. do some work/commit/etc. wiki link on how to build/run ovirt will be sent shortly

8. rebase: git fetch gerrit.ovirt.org:ovirt-engine master

9. push your patch for review: git push gerrit.ovirt.org:ovirt-engine HEAD:refs/for/master

10. track patch review process the review process is comprised of: - anyone can send a patch - anyone can code review and comment on the patch and +1/-1. This helps maintainers in reviewing the patches. - a maintainer can code review it with +2 it, which is required to commit (submit) it. - someone (anyone) needs to confirm they checked the patch works and flag it as verified +1 - a maintainer can submit (commit) the patch when it has:

        Code Review: +2
        Verified: +1

* nacked (-1) patches should not be submitted - a submitted patch is merged to the git

[1] if anyone provides a reason to limit to specific OpenID providers that's an option as well.

---
title: Building Engine Draft
category: draft-documentation
authors: alonbl, jhernand, vszocs
wiki_category: Draft documentation
wiki_title: Building Engine Draft
wiki_revision_count: 112
wiki_last_updated: 2013-05-12
---

# Building Engine Draft

## Introduction

This is a draft of updated building instructions. Please refer to [Building oVirt engine](Building oVirt engine) for the current version.

Follow these instructions to successfully build and install the oVirt Engine project in your development environment. Installation and configuration of all required tools to complete the build is also covered. For instructions on obtaining and building VDSM, the package required to turn existing systems into oVirt Nodes, see [Vdsm Developers](Vdsm Developers). Alternatively some binary VDSM builds are available [here](http://fsimonce.fedorapeople.org/vdsm/).

      #> at the beginning of the command stands for execution as root.
      $> at the beginning of the command stands for execution as user.

## Prerequisites

1.  Linux based operating system with support for OpenJDK 1.7.0, Maven and PostgreSQL 8.4.8 (or higher).
2.  An Internet connection.

Note that while this guide was written and tested using Fedora 17 other Linux Distributions can and have been used to build the ovirt-engine project. Where distribution specific packaging commands are specified in this guide use the syntax that applies for your distribution.

## Installing Build Tools

### Installing OpenJDK

The supported Java development and runtime environments for the ovirt-engine project are provied by OpenJDK 1.7.0. Install the java-1.7.0-openjdk-devel package to obtain OpenJDK 1.7.0:

**Fedora**

      #> yum install -y java-1.7.0-openjdk-devel

**Debian**

      #> apt-get install openjdk-7-jdk

Use the 'alternatives' command to verify that 'javac' is correctly linked to the openjdk-1.7.0 instance of the Java compiler:

      $> alternatives --display javac
      javac - status is auto.
       link currently points to /usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin/javac
      ...

Where the link does not point to the correct instance of the Java compiler then you must update it, for example:

      $> alternatives --set javac /usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin/javac

### Installing git

The ovirt-engine source code is stored in a GIT repository. As such GIT is required to obtain the latest source code.

**Fedora**

      #> yum install -y git

**Debian**

      #> apt-get install git

### Installing maven

The engine build uses maven 3.0.x.

**Fedora**

      #> yum install -y maven

**Debian**

      #> apt-get install maven

Once the installation is completed verify that the correct version of the `mvn` command is in the path:

    $> mvn --version
    Apache Maven 3.0.4
    ...

##### Maven personal settings

Create your `$HOME/.m2` directory (this is where maven stores your personal settings and the artifacts downloaded from internet repositories):

`
$> mkdir $HOME/.m2
`

You can download a complete personal settings file as follows:

    wget -O $HOME/.m2/settings.xml http://www.ovirt.org/w/images/1/18/Settings.xml.png

Or copy & paste the content below into the file `$HOME/.m2/settings.xml`:

    <settings
      xmlns="http://maven.apache.org/POM/4.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

      <activeProfiles>
        <activeProfile>oVirtEnvSettings</activeProfile>
      </activeProfiles>

      <profiles>
        <profile>
          <id>oVirtEnvSettings</id>
          <properties>
            <jbossHome>/home/myuser/jboss-as</jbossHome>
          </properties>
        </profile>
      </profiles>

    </settings>

*   Do not omit the `active-profiles` element in the above file, it is crucial.
*   Remember also to change the `jbossHome` property to the directory where you have the application server installed (more instructions later in this document).

## Installing JBoss AS

Note that development environments should install the application server using the zip files, not the operating system packages. The reason is that this allows the developer to use its own unprivileged user to run the application server without needing to use root privileges.

### Downloading and installing the application server

Select and create the directory where you want to install the application server. Many developers use `/usr/share/jboss-as`, but you can use any directory you like, for example `$HOME/jboss-as`. From now on we will refer to that directory with the environment variable `JBOSS_HOME`:

    $> export JBOSS_HOME=$HOME/jboss-as
    $> mkdir -p $JBOSS_HOME

***Note**: It might be convenient to add that variable to your `$HOME/.bash_profile` file, so that you get it automatically whenever you log in.*

Download and install version 7.1.1 of the application server:

    $> cd $JBOSS_HOME
    $> wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
    $> unzip jboss-as-7.1.1.Final.tar.gz
    $> mv jboss-as-7.1.1.Final/* .
    $> rmdir jboss-as-7.1.1.Final

Update the `jbossHome` property in your personal maven settings file `$HOME/.m2/settings.xml`.

Check that the application server starts correctly:

    $> cd $JBOSS_HOME/bin
    $> ./standalone.sh

Ensure that you have write access to `$JBOSS_HOME/standalone/deployments` to which the engine will be deployed.

### Troubleshooting

1.  Some useful `JAVA_OPTS`, these can be manually added to the `$JBOSS_HOME/bin/standalone.conf` script as required:
    1.  `-Xmx512m` - maximum Java heap size of 512 MiB
    2.  `-Xdebug` - include debugging

2.  Run with `-b 0.0.0.0` to have it bind to all IP addresses (by default it binds to the 127.0.0.1 address only).
3.  Make sure you've nothing bound to port 8080 or 8009.
    1.  Other relevant ports JBoss may require: 8443/9990/9999/4447.

4.  For external connections, make sure your firewall allows 8080 incoming traffic.
5.  If your machine has and selinux policy installed, make sure it will not block JBoss.
6.  JBoss will bind to your host's name. Make sure it's resolvable by adding it to `/etc/hosts` or any other method.

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

      Note: In case, create_db_devel keep asking postgres password, create the following file:
      $ echo "*:*:*:postgres:YOUR_POSTGRES_PASSWORD" > ~/.pgpass 
      $ chmod 0600 ~/.pgpass

On some installations you will receive an error message about uuid-ossp.sql not being found. This is an open issue. <https://bugzilla.redhat.com/750626>

To work around the issue, edit the file $OVIRT_HOME/backend/manager/dbscripts_postgres/create_db.sh and change the references to uuid-ossp.sql to point to the right location.

#### Build

If you only want to build virt-engine-core and REST API then:

       $> cd $OVIRT_HOME
       $> mvn clean install

For compiling the web-admin and user-portal in addition to the api and engine use:

       $> cd $OVIRT_HOME
       $> mvn clean install -Pgwt-admin,gwt-user

Notes:
# Compiling the webadmin and userportal takes (a long) time, please visit [GWT Compilation Configuration](Advanced_oVirt_Engine_Build_Notes#GWT_Compilation_Configuration) if you want to speed the web compilation process during development time
# Make sure to run this with your user, not 'root', running as root will result in a missing settings.xml file in the 'root' home directory.

1.  To skip the execution of the unit tests and only compile and package ovirt, add the option: -DskipTests=true to the mvn build command
2.  You can reduce the build time and memory consumption - look at the temp section at the end.
3.  If you receive "java.lang.OutOfMemoryError: PermGen space" error, use the MAVEN_OPTS environment variable to set a higher heap and permanent generation stack size, then try again:

      $> export MAVEN_OPTS="-XX:MaxPermSize=128m"

For advanced build notes, please visit [Advanced oVirt Engine Build Notes](Advanced oVirt Engine Build Notes)

#### Deploy

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

## Copying vdsm bootstrap files

In case you like to do a full bootstrap installation (InstallVds = True into the database), these steps will be required. Otherwise, can be ignored.

          #> su - -c 'mkdir -p /usr/share/vdsm-bootstrap'
          #> git clone git://gerrit.ovirt.org/vdsm
          #> cd vdsm
          #> ./autogen.sh --system && make
          #> cp vdsm_reg/deployUtil.py /usr/share/vdsm-bootstrap
          #> cp vds_bootstrap/vds_bootstrap_complete.py /usr/share/vdsm-bootstrap
          #> cp vds_bootstrap/vds_bootstrap.py /usr/share/vdsm-bootstrap
          #> psql engine postgres -c "update vdc_options set option_value = 'http://YOUR_ENGINE_HOST_HERE:8080/Components/vds' where option_name = 'VdcBootStrapUrl';"

## Deploying engine-config & engine-manage-domains

      $> cd $OVIRT_HOME
      $> make create_dirs
      $> make install_tools
      $> make install_config

## Testing

Assuming JBoss is not running, it should be started:

          #> systemctl start ovirt-engine.service (or restart if you already started above for tests)
          #> ps ax | grep java

or

      #> /usr/share/ovirt-engine/scripts/engine-service.py start

Use username **admin@internal** and password **letmein!**

Accessing the RESTful API:

      wget -O - --debug --auth-no-challenge --http-user=admin@internal --http-password='letmein!' head='Accept: application/xml' http://<server name>:<port>/api/

(by default, the port is 8080).

or from the browser

      http://<server name>:<port>/api

Accessing the web-admin:
 http://<server name>:<port>/webadmin

Accessing the user-portal
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

## I have made a change into ovirt engine code, how can I deploy it?

This will build the engine, rebuilding the admin console and then creates the ear and deploys it to jboss

          #> mvn clean install -Pgwt-admin -DskipTests && cd ear && mvn clean install -Pdep
          #> service jboss-as restart

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

## Is there an IDE?

Yes! Take a look in: [Building_Ovirt_Engine/IDE](Building_Ovirt_Engine/IDE)

## More information

*   Engine setup on Gentoo can be found here: <https://wiki.gentoo.org/wiki/OVirt>
*   [Ovirt build on debian/ubuntu](Ovirt build on debian/ubuntu)

## Troubleshooting

### Host Non-Responsive

*   Make sure you have both (vdsm and ovirt-engine) with ssl disabled or enabled.
*   If you have enabled ssl anytime and want move to ssl=false, you must reconfigure vdsm and start the daemon again.

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

       Look /tmp/vds* files

*   Engine side:

       Look /usr/share/jboss-as/standalone/log/engine/engine.log

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

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)

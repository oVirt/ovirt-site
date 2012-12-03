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

This is a draft of updated building instructions. Please refer to [Building oVirt engine](Building oVirt engine) for the current official version.

Follow these instructions to successfully build and install the oVirt Engine project in your development environment. Installation and configuration of all required tools to complete the build is also covered. For instructions on obtaining and building VDSM, the package required to turn existing systems into oVirt Nodes, see [Vdsm Developers](Vdsm Developers). Alternatively some binary VDSM builds are available [here](http://fsimonce.fedorapeople.org/vdsm/).

Please note that in this instructions you will be asked to run several commands. Be careful with the user that you use to run them, we will indicate with different prompts in the page what type of user should be used for each command:

*   `#` at the beginning of the command stands for execution as `root`.
*   `$` at the beginning of the command stands for execution as your normal unprivileged user.

## Prerequisites

1.  Linux based operating system with support for OpenJDK 1.7.0, Maven 3 and PostgreSQL 8.4.8 (or higher).
2.  An Internet connection.

Note that while this guide was written and tested using Fedora 18 other Linux Distributions can and have been used to build the ovirt-engine project. Where distribution specific packaging commands are specified in this guide use the syntax that applies for your distribution.

If you plan to use Debian please take into account that the current stable distribution (squezze) doesn't contain the OpenJDK 1.7.0 or Maven 3 packages, so you will need to update to the current testing distribution (wheezy).

## Installing Build Tools

### Installing OpenJDK

The supported Java development and runtime environments for the ovirt-engine project are provied by OpenJDK 1.7.0. Install the java-1.7.0-openjdk-devel package to obtain OpenJDK 1.7.0:

**Fedora**

    # yum install -y java-1.7.0-openjdk-devel

**Debian**

    # apt-get install openjdk-7-jdk

### Installing git

The ovirt-engine source code is stored in a GIT repository. As such GIT is required to obtain the latest source code.

**Fedora**

    # yum install -y git

**Debian**

    # apt-get install git

### Installing maven

The engine build uses maven 3.0.x.

**Fedora**

    # yum install -y maven

**Debian**

    # apt-get install maven

Once the installation is completed verify that the correct version of the `mvn` command is in the path:

    $ mvn --version
    Apache Maven 3.0.4
    ...

##### Maven personal settings

Create your `$HOME/.m2` directory (this is where maven stores your personal settings and the artifacts downloaded from internet repositories):

    $ mkdir $HOME/.m2

Copy & paste the content below into the file `$HOME/.m2/settings.xml`:

    <settings
      xmlns="http://maven.apache.org/POM/4.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

      <activeProfiles>
        <activeProfile>oVirt</activeProfile>
      </activeProfiles>

      <profiles>
        <profile>
          <id>oVirt</id>
          <properties>
            <jbossHome>${env.HOME}/jboss-as-7.1.1.Final</jbossHome>
          </properties>
        </profile>
      </profiles>

    </settings>

*   Do not omit the `activeProfiles` element in the above file, it is crucial.
*   Remember also to change the `jbossHome` property if you decide to install the application server to a directory different to the one suggested here.

## Installing JBoss AS

Note that in development environments you should install the application server using the zip files, not the distribution packages. The reason is that this allows the developer to use its own unprivileged user to run the application server without needing to use root privileges.

### Downloading and installing the application server

Download version 7.1.1 of JBoss AS 7 from [here](http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip) then uncompress it in your home directory, the end result should be a `jboss-as-7.1.1.Final` directory. Go to the `bin` subdirectory and run the `standalone.sh` script like this:

    $ cd $HOME/jboss-as-7.1.1.Final/bin
    $ ./standalone.sh -b 0.0.0.0

This will start the application server and will keep your terminal window busy showing some log messages. After a few seconds the application server will be ready and will show a message similar to this one:

    11:48:48,009 INFO  [org.jboss.as] (Controller Boot Thread) JBAS015874: JBoss AS 7.1.1.Final "Brontes" started in 3254ms - Started 133 of 208 services (74 services are passive or on-demand)

That means that it started correctly. The objective was just to check that the download and installation worked correctly, so stop it with Ctrl+C, you will start it later once the engine is deployed.

### Troubleshooting

1.  Some useful `JAVA_OPTS`, these can be manually added to the `bin/standalone.conf` script as required:
    1.  `-Xmx512m` - maximum Java heap size of 512 MiB
    2.  `-Xdebug` - include debugging

2.  Run with `-b 0.0.0.0` to have it bind to all IP addresses (by default it binds to the 127.0.0.1 address only).
3.  Make sure you've nothing bound to port 8700 or 8701.
4.  For external connections, make sure your firewall allows 8700 incoming traffic.
5.  If your machine has and selinux policy installed, make sure it will not block JBoss.
6.  JBoss will bind to your host's name. Make sure it's resolvable by adding it to `/etc/hosts` or any other method.
7.  You may wish to erase previous deployment (during development, if you encounter a situation where you work with the deployed application but it does not contain the expected behavior). In order to perform the cleanup, you must perform the following steps:

<!-- -->

    $ cd $HOME/jboss-as-7.1.1.Final/standalone
    $ rm -rf deployments/engine.ear 
    $ rm -rf deployments/engine.ear.deployed 
    $ rm -rf tmp
    $ rm -rf data

## Installing PostgreSQL

[Installing_PostgreSQL_DB](Installing_PostgreSQL_DB)

## Building oVirt-engine from source

### Clone oVirt-engine codebase

Use the `git` command to clone the engine repository into your home directory:

    $ git clone git://gerrit.ovirt.org/ovirt-engine

This will create a new `ovirt-engine` directory containing the cloned repository.

***Note:** The above cloning is for read only, if you want to contribute see [this](#Code_contribution:_Gerrit).*

### Creating the database

Create the `$HOME/.pgpass` file containing the password of the database administrator. The content should be the following:

    *:*:*:postgres:YOUR_POSTGRES_PASSWORD

Note that this is relevant if you decided to configure your database with password authentication instead of with the `trust` method as suggested in the database installation instructions. In that case put in this file the password of the database administrator. If you are using `trust` as suggested then you don't need to create this file.

Make sure that the permissions of the `/root/.pgpass` file are `0600`:

    $ chmod 0600 $HOME/.pgpass

Now change into the directory where you cloned the `ovirt-engine` git repository, then change into the `backend/manager/dbscritps` directory and run the `create_db_devel.sh` script:

    $ cd $HOME/ovirt-engine/backend/manager/dbscripts
    $ ./create_db_devel.sh -u postgres

### Build

If you only want to build the engine core and then REST API then use the following commands:

    $ cd $HOME/ovirt-engine
    $ mvn install -DskipTests

Please note that the first time that you build maven will need to download a large amount of dependencies from the network, more than 200 MiB, so if you have an slow connection it will take a long time.

For compiling the GUI (web administration tool and user portal) in addition to the engine core and REST API use the following commands:

    $ cd $HOME/ovirt-engine
    $ mvn install -DskipTests -Dgwt.userAgent=gecko1_8 -Pgwt-admin,gwt-user

***Notes:***

1.  The `-DskipTests` option disables compilation and executions of tests. This is not what you should do usually, but it is good idea to use it the first time to avoid the extra time that it takes to run the tests.
2.  The `-Dgwt.userAgent=gecko1_8` is very important to limit the resources that the GWT compiler uses. If you don't use it compilation will take a very long time. The value `gecko1_8` instructs the GWT compiler to generate code only for Firefox, if you need to generate code for other browsers please visit [GWT Compilation Configuration](Advanced_oVirt_Engine_Build_Notes#GWT_Compilation_Configuration).
3.  Make sure to run this with your user, not `root`, running as `root` will result in a missing `settings.xml` file in the `root` home directory.
4.  If you receive `java.lang.OutOfMemoryError: PermGen space` error, use the `MAVEN_OPTS` environment variable to set a higher permanent generation heap size, then try again:

<!-- -->

    $ export MAVEN_OPTS="-XX:MaxPermSize=128m"

For advanced build notes, please visit [Advanced oVirt Engine Build Notes](Advanced oVirt Engine Build Notes).

### Deploy

The first deployment of the engine to the application server should use the `dep` and `setup` profiles:

    $ cd $HOME/ovirt-engine/ear
    $ mvn install -Pdep,setup

There is a issue with the `dep` and `setup` profiles getting in the way of each other. The `setup` profile will prevent the deployment of the quartz jar to the application server. So after this step completes, run again, but with the `dep` profile only:

    $ cd $HOME/ovirt-engine/ear
    $ mvn install -Pdep

From this point on, every time you deploy you can simply run with the `dep` profile:

    $ cd $HOME/ovirt-engine/ear
    $ mvn install -Pdep

Since postgres is already set up.

## Testing

Assuming that the application server is not running, it should be started:

    $ cd $HOME/jboss-as-7.1.1.Final/bin
    $ ./standalone.sh -b 0.0.0.0

If everything went correctly you should be able to connect to <http://127.0.0.1:8700>, in that URL you will see the welcome page, with links to the administrator portal and user portal.

The default user name and password created in development environments are `admin@internal` and `letmein!`.

You can also access the REST API pointing your browser to <http://127.0.0.1:8700/api> or with a command line tool like `wget`:

    $ wget -O - \
    --debug \
    --auth-no-challenge \
    --http-user=admin@internal \
    --http-password='letmein!' \
    head='Accept: application/xml' \
    http://127.0.0.1:8700/api/

Note that when using a browser to connect to the REST API you have to enter the user name followed by @ and the domain name (by default `admin@internal`) in the pop-up windows that the browser will present.

## I have made a change into ovirt engine code, how can I deploy it?

This will build the engine, rebuilding the admin console and then creates the ear and deploys it to the application server:

    $ mvn clean install -Pgwt-admin -DskipTests && cd ear && mvn clean install -Pdep

Stop the application server (Ctrl+C in the console) and start it again before testing the changes.

## Copying vdsm bootstrap files (optional)

With the default installation for development environments the engine will assume that hypervisors have VDSM already installed, and will not try to configure them. If you want the engine to do full bootstrap installation of hypervisors (setting configuration parameter `InstallVds` to `true` in the database) these steps will be required, otherwise they can be ignored.

Some of the scripts that the engine uses to install and configure hypervisors are part of the VDSM project, so you will need to clone the VDSM repository and build it:

    $ git clone git://gerrit.ovirt.org/vdsm
    $ cd vdsm
    $ ./autogen.sh --system && make

Once VDSM is built you will need to copy the scripts to the directory `/usr/share/vdsm-bootstrap` where the engine expects them:

    # mkdir -p /usr/share/vdsm-bootstrap
    # cp vdsm_reg/deployUtil.py /usr/share/vdsm-bootstrap
    # cp vds_bootstrap/vds_bootstrap_complete.py /usr/share/vdsm-bootstrap
    # cp vds_bootstrap/vds_bootstrap.py /usr/share/vdsm-bootstrap

***Note:** This is not necessary if you installed the `vdsm-bootstrap` package, as it already contains the `/usr/share/vdsm-bootstrap` directory and the required files.*

***Note:** If you need to use a directory other than `/usr/share/vdsm-bootstrap` you will need to update accordingly the deployment descriptor (the file `web.xml`) of the root web application.*

Update the database to reflect the actual URL where the bootstrap files can be downloaded by the hypervisors:

    $ psql engine postgres -c "update vdc_options set option_value = 'http://YOUR_ENGINE_HOST_HERE:8700/Components/vds' where option_name = 'VdcBootStrapUrl';"

## Setting Public Key environment (optional, recommended to oVirt node environment)

Follow this page: <http://www.ovirt.org/wiki/Engine_Node_Integration#Engine_core_machine>

## Enable SSL port 8701 in the application server (optional)

Generate a self signed certificate for the application server (remember to replace `engine.example.com` with the fully qualified DNS name of your machine, and `mypass` with your preferred password):

    $ cd $HOME/jboss-as-7.1.1.Final
    $ keytool \
    -genkey \
    -alias engine \
    -keyalg RSA \
    -keysize 1024 \
    -keystore .keystore \
    -validity 3650 \
    -dname CN=engine.example.com \
    -storepass mypass \
    -keypass mypass

***Note:** Take into account that the keystore uses two passwords: one to protect the integrity of the keystore (the `-storepass` option) and another one to protect te confidentiality of the private key (the `-keypass` option). Both have to be equal, or the application server will not be able to use the keystore.*

Once the keystore is created the application server has to be configured to enable the SSL connector, using the command line interface:

    $ cd $HOME/jboss-as-7.1.1.Final/bin
    $ ./jboss-cli.sh --connect
    [standalone@localhost:9999 /]

Type there the following two commands (remember to use the absolute path of the `.keystore` file and replace `mypass` with the actual password used to create the keystore):

    /subsystem=web/connector=https:add(socket-binding=https, scheme=https, protocol="HTTP/1.1", enabled=true)
    /subsystem=web/connector=https/ssl=configuration:add(certificate-key-file="/home/developer/jboss-as/.keystore", password="mypass", key-alias="engine")

Then exit the CLI typing the `exit` command. The following connector should have been added automatically to the web subsystem of the application server in the `$JBOSS_HOME/standalone/configuration/standalone.xml` file:

    <connector name="https" protocol="HTTP/1.1" scheme="https" socket-binding="https">
      <ssl key-alias="engine" password="mypass" certificate-key-file="/home/developer/jboss-as/.keystore"/>
    </connector>

And the following socket binding should have been added automatically in the same `standalone.xml` file:

    <socket-binding name="https" port="8701"/>

After doing this change stop the application server and start it again, then you should be able to connect to using HTTPS and port 8701.

For additional info: <https://docs.jboss.org/author/display/AS7/Admin+Guide#AdminGuide-HTTPSConnectors>

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
2.  git rebase origin/master
3.  Compile the code
4.  Upgrade your DB schema

<!-- -->

    $ cd $OVIRT_HOME/backend/manager/dbscripts
    $ ./upgrade.sh -u postgres

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

       Look $JBOSS_HOME/standalone/log/engine/engine.log

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

       $JBOSS_HOME/standalone/log/server.log
       $JBOSS_HOME/standalone/log/engine/engine.log

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)

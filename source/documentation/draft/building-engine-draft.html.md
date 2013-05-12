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

<big><font color="lightgray" style="background-color: darkred">ATTENTION: This page is obsoleted for >=ovirt-engine-3.3 by [oVirt Engine Development Environment](OVirt_Engine_Development_Environment)</font></big>

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

The engine build uses maven 3.

**Fedora**

    # yum install -y maven

**Debian**

    # apt-get install maven

**Other**

If your operating system doesn't have a package for maven 3 you can download it from the [maven web site](http://maven.apache.org/download.cgi) and install it manually. First uncompress the downloaded file to your preferred directory, for example to your home directory:

    cd
    wget ftp://ftp.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
    tar xvf apache-maven-3.0.5-bin.tar.gz

Make sure that the maven `bin` directory is the first in your path, otherwise you will be using the version of maven provided by your operating system:

    PATH=$HOME/apache-maven-3.0.5/bin:$HOME
    export path

Once the installation is completed verify that the correct version of the `mvn` command is in the path:

    $ mvn --version
    Apache Maven 3.0.5 ...

## Installing JBoss AS

Note that in development environments you should install the application server using the zip files, not the distribution packages. The reason is that this allows the developer to use its own unprivileged user to run the application server without needing to use root privileges.

### Downloading and installing the application server

Download version 7.1.1 of JBoss AS 7 from [here](http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip) then uncompress it in the `$HOME/ovirt-engine` directory:

    $ mkdir -p $HOME/ovirt-engine
    $ cd $HOME/ovirt-engine
    $ wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
    $ unzip jboss-as-7.1.1.Final.zip

The end result should be a `$HOME/ovirt-engine/jboss-as-7.1.1.Final` directory.

## Installing PostgreSQL

[Installing_PostgreSQL_DB](Installing_PostgreSQL_DB)

## Building oVirt-engine from source

### Clone oVirt-engine codebase

Use the `git` command to clone the engine repository into the `ovirt-engine/repository` inside your home directory:

    $ mkdir -p $HOME/ovirt-engine/repository
    $ cd $HOME/ovirt-engine
    $ git clone git://gerrit.ovirt.org/ovirt-engine repository

***Note:** The above cloning is for read only, if you want to contribute see [this](#Code_contribution:_Gerrit).*

### Creating the database

Create the `$HOME/.pgpass` file containing the password of the database administrator. The content should be the following:

    *:*:*:postgres:YOUR_POSTGRES_PASSWORD

Note that this is relevant if you decided to configure your database with password authentication instead of with the `trust` method as suggested in the database installation instructions. In that case put in this file the password of the database administrator. If you are using `trust` as suggested then you don't need to create this file.

Make sure that the permissions of the `/root/.pgpass` file are `0600`:

    $ chmod 0600 $HOME/.pgpass

Now change into the directory where you cloned the `ovirt-engine` git repository, then change into the `backend/manager/dbscritps` directory and run the `create_db_devel.sh` script:

    $ cd $HOME/ovirt-engine/repository/backend/manager/dbscripts
    $ ./create_db_devel.sh -u postgres

### Build

To build with the default options select the directory where you will install the engine (in these instructions we will use `$HOME/ovirt-engine/installation`, but you can use any other directory where you have write permission) and use the following commands:

    $ cd $HOME/ovirt-engine/repository
    $ make PREFIX=$HOME/ovirt-engine/installation

Please note that the first time that you build maven will need to download a large amount of dependencies from the network, more than 200 MiB, so if you have an slow connection it will take a long time.

By default the above commands will build the the GUI applications for all the browsers (all the *permutations* in GWT jargon). This consumes a lot of resources and can take a very long time. In you first build it can be interesting to build only for the browser that you will use to test. In order to do that add the following `EXTRA_BUILD_FLAGS` option to the make command:

    $ cd $HOME/ovirt-engine/repository
    $ make PREFIX=$HOME/ovirt-engine/installation EXTRA_BUILD_FLAGS="-Dgwt.userAgent=gecko1_8"

This will build only for Firefox. For other browsers you can use the following values (separated by commas, if you want to specify several):

|--------------------------------------------------------|------------|
| Firefox (all versions)                                 | `gecko1_8` |
| Safari and Chrome (both use the same rendering engine) | `safari`   |
| Internet Explorer 6                                    | `ie6`      |
| Internet Explorer 8                                    | `ie8`      |
| Internet Explorer 9                                    | `ie9`      |

For example, if you want to build for Firefox and Chrome you can use the following commands:

    $ cd $HOME/ovirt-engine/repository
    $ make PREFIX=$HOME/ovirt-engine/installation EXTRA_BUILD_FLAGS="-Dgwt.userAgent=gecko1_8,safari"

For advanced build notes, please visit [Advanced oVirt Engine Build Notes](Advanced oVirt Engine Build Notes).

### Install

To install the engine use the `install` make target to perform the installation:

    $ cd $HOME/ovirt-engine/repository
    $ make install PREFIX=$HOME/ovirt-engine/installation

Create the following directories where the engine will store state, logs and temporary files:

    mkdir -p \
    $HOME/ovirt-engine/installation/var/lib/ovirt-engine/content \
    $HOME/ovirt-engine/installation/var/lib/ovirt-engine/deployments \
    $HOME/ovirt-engine/installation/var/run \
    $HOME/ovirt-engine/installation/var/cache/ovirt-engine \
    $HOME/ovirt-engine/installation/var/lock/ovirt-engine \
    $HOME/ovirt-engine/installation/var/log/ovirt-engine \
    $HOME/ovirt-engine/installation/var/tmp/ovirt-engine

Now you need to do some adjustments to the configuration file `$HOME/ovirt-engine/installation/etc/ovirt-engine/engine.conf`:

1. Adjust the location of the Java virtual machine:

    JAVA_HOME=the_location_of_your_jvm

You can find the location of the JVM by following the symlinks to the `java` command. For example, in Fedora 18:

    $ which java
    /bin/java
    $ ls -l /bin/java
    lrwxrwxrwx. 1 root root 22 Jan 19 19:05 /bin/java -> /etc/alternatives/java
    $ ls -l /etc/alternatives/java
    lrwxrwxrwx. 1 root root 46 Jan 19 19:05 /etc/alternatives/java -> /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java

So the value of the property should be `/usr/lib/jvm/jre-1.7.0-openjdk.x86_64`, without the `bin` directory:

    JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64

2. Adjust the location of the JBoss application server:

    JBOSS_HOME=the_location_of_jboss

3. Adjust the user and group. By default it uses the ovirt user and group but you will probably want to run the engine with your own user and group:

    ENGINE_USER=your_user_name
    ENGINE_GROUP=your_group_name

4. Enable the HTTP connector, as by default only the AJP connector is enabled (to use Apache as a proxy server):

    ENGINE_PROXY_ENABLED=false
    ENGINE_HTTP_ENABLED=true
    ENGINE_HTTP_PORT=8700
    ENGINE_HTTPS_ENABLED=false
    ENGINE_AJP_ENABLED=false

5. Adjust the database connection details to use the *trust* mode and no password:

    ENGINE_DB_USER=postgres
    ENGINE_DB_PASSWORD=

6. In development environments it is also very useful to be able to connect to the Java virtual machine with your debugger. To enable that add the following parameter:

    ENGINE_DEBUG_ADDRESS=0.0.0.0:8787

Then you can connect with your debugger using port 8787.

## Testing

The script that starts the engine needs the `configobj` and `Cheetah.Template` modules, so before starting it you may need to isntall the packages containing them. In Fedora, for example, you can install them as follows:

    # yum install python-configobj python-cheetah

First you need to start the engine. Go to the directory where you installed it (we are assuming `$HOME/ovirt-engine/installation` in these instructions), then to the `bin` subdirectory and run the `engine-service` script as follows:

    $ cd $HOME/ovirt-engine/installation/bin
    $ ./engine-service start

If everything went correctly you should be able to connect to <http://localhost:8700>, in that URL you will see the welcome page, with links to the administrator portal and user portal.

The default user name and password created in development environments are `admin@internal` and `letmein!`.

You can also access the REST API pointing your browser to <http://localhost:8700/api> or with a command line tool like `wget`:

    $ wget -O - \
    --debug \
    --auth-no-challenge \
    --http-user=admin@internal \
    --http-password='letmein!' \
    head='Accept: application/xml' \
    http://localhost:8700/api/

Note that when using a browser to connect to the REST API you have to enter the user name followed by @ and the domain name (by default `admin@internal`) in the pop-up windows that the browser will present.

## I have made a change into ovirt engine code, how can I deploy it?

First stop the engine if it is running:

    $ cd $HOME/ovirt-engine/installation/bin
    $ ./engine-service stop

Then run the install target again:

    $ cd $HOME/ovirt-engine/repository
    $ make install PREFIX=$HOME/ovirt-engine/installation

And finally start the engine:

    $ cd $HOME/ovirt-engine/installation/bin
    $ ./engine-service start

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

## Enable SSL port 8701 (optional)

Generate a self signed certificate for the application server (remember to replace `engine.example.com` with the fully qualified DNS name of your machine, and `mypass` with your preferred password):

    $ keytool \
    -genkey \
    -storetype pkcs12 \
    -keystore $HOME/ovirt-engine/installation/etc/pki/ovirt-engine/keys/jboss.p12 \
    -alias 1 \
    -keyalg RSA \
    -keysize 2048 \
    -validity 3650 \
    -dname CN=engine.example.com \
    -storepass mypass \
    -keypass mypass

***Note:** Take into account that the keystore uses two passwords: one to protect the integrity of the keystore (the `-storepass` option) and another one to protect te confidentiality of the private key (the `-keypass` option). Both have to be equal, or the application server will not be able to use the keystore.*

Once the keystore is created the engine has to be configured to enable the SSL connector, adding the following to the `$HOME/ovirt-engine/installation/etc/ovirt-engine/engine.conf` file:

    ENGINE_HTTPS_ENABLED=true
    ENGINE_HTTPS_PORT=8701

After doing this change stop the engine server and start it again, then you should be able to connect to using HTTPS and port 8701.

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

    $ cd $HOME/ovirt-engine/backend/manager/dbscripts
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

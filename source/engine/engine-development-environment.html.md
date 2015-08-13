---
title: OVirt Engine Development Environment
category: engine
authors: alonbl, amureini, arik, didi, dougsland, ecohen, gchaplik, gshereme, mkolesni,
  moolit, mperina, msivak, nsoffer, ofri, roy, smizrahi, tsaban, vered, vitordelima,
  vszocs, yair zaslavsky, ykleinbe
wiki_category: Engine
wiki_title: OVirt Engine Development Environment
wiki_revision_count: 93
wiki_last_updated: 2015-05-26
---

# OVirt Engine Development Environment

## Development Environment

<b>Please notice:</b> Most updated certified documentation is available within source tree at [README.developer](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD).

This page is mostly to absorb community experience into the certified procedures.

### Prerequisites

#### RPM based

##### Set up snapshot repository

###### Automatically

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-releaseXY.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-releaseXY.rpm)

This will not work for master, as it is available after release.

###### Manually

Create `/etc/yum.repos.d/ovirt-snapshots.repo`, replace `@distro@` with `fc` for Fedora or `el` for RHEL or equivalent distribution.

      [ovirt-snapshots]
      name=local
      baseurl=http://resources.ovirt.org/pub/ovirt-master-snapshot/rpm/@distro@$releasever
      enabled=1
      gpgcheck=0
      priority=10
      [ovirt-snapshots-static]
      name=local
      baseurl=http://resources.ovirt.org/pub/ovirt-master-snapshot-static/rpm/@distro@$releasever
      enabled=1
      gpgcheck=0
      priority=10

##### Setup PatternFly repository

Create `/etc/yum.repos.d/patternfly.repo` and copy/paste the contents of correct file for your distro from [PatternFly Repos on copr](https://copr.fedoraproject.org/coprs/patternfly/patternfly1).

##### Install 3rd party packages

      # yum install git java-devel maven openssl postgresql-server \
          m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python \
          unzip patternfly1 pyflakes python-pep8 python-docker-py

###### Application servers

Following application servers are required for engine development:

*   WildFly 8.2 for oVirt 3.6+ development
        # yum install ovirt-engine-wildfly ovirt-engine-wildfly-overlay

*   JBoss 7.1.1 for backporting changes to oVirt 3.5
        # yum install ovirt-engine-jboss-as

##### Install ovirt packages

      # yum install ovirt-host-deploy

##### Setup Java

Make sure openjdk is the java preferred:

      # alternatives --config java
      # alternatives --config javac

Note: javassit used in some of the unit tests hits a regression introduced in java-1.7.0-openjdk-1.7.0.65. In order to avoid this issue, you can downgrade to java-1.7.0-openjdk-1.7.0.60.

#### Debian based

Install 3rd party packages:

      # apt-get install git openjdk-7-jdk maven openssl postgresql \
          python-m2crypto python-psycopg2 python-cheetah python-daemon \
          jboss-as unzip

Download PatternFly from [PatternFly releases](https://github.com/patternfly/patternfly/releases/tag/v1.0.5) and extract to $HOME/patternfly

Download jboss-as-7.1.1 from [jboss site](http://www.jboss.org/jbossas/downloads/) and extract to $HOME.

Install ovirt packages:

       TODO

Make sure openjdk is the java preferred:

      # update-alternatives --config java

#### Database

Based on your distribution it may be that you require to initialize the database.

      Fedora: # postgresql-setup initdb
      RHEL:   # /etc/init.d/postgresql initdb
      Gentoo: # emerge --config postgresql-server

Configure PostgreSQL to accept network connection by locating `pg_hba.conf` file, locations includes:

|-------------|--------------------------------------|
| Fedora,RHEL | /var/lib/pgsql/data/pg_hba.conf     |
| Debian      | /etc/postgresql/\*/main/pg_hba.conf |
| Gentoo      | /etc/postgresql-\*/pg_hba.conf      |

Locate: 127.0.0.1/32 and ::1/128 and allow "password" authentication for IPv4 and IPv6 connections.

      # IPv4 local connections:
      host    all             all             127.0.0.1/32            password
      # IPv6 local connections:
      host    all             all             ::1/128                 password

Configure PostgreSQL to support at least 150 concurrent connections - find `postgresql.conf` file, usually in the same location of `pg_hba.conf`, locate 'max_connections' and set it to 150.

Restart PostgreSQL service for definitions to take effect:

You may consider set the postgresql service to start at boot.

Create database and user, usually using the following commands as root:

      su - postgres -c "psql -d template1 -c "create user engine password 'engine';""
      su - postgres -c "psql -d template1 -c "create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';""

It basically logins into PostgreSQL database using privileged user, creates a user and creates a database owned by the user.

#### Source

Checkout source:

      mkdir -p "$HOME/git"
      cd "$HOME/git"
      $ git clone git://gerrit.ovirt.org/ovirt-engine

### Usage

<font color=red><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine.

Build product and install at `$HOME/ovirt-engine`, execute the following as unprivileged user while residing within source repository:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

on Debian, include

      PATTERNFLY_HOME="$HOME/patternfly"

Build may be customized, refer to [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) for further information.

If WildFly 8.2 should be used, then it's required to manually setup ovirt-engine-wildfly-overlay using following command:

    echo "ENGINE_JAVA_MODULEPATH="/usr/share/ovirt-engine-wildfly-overlay/modules:${ENGINE_JAVA_MODULEPATH}"" \
      > $PREFIX/etc/ovirt-engine/engine.conf.d/20-setup-jboss-overlay.conf

Setup product by executing the following command and replying to questions, if you followed the database creation above then your database user is 'engine', its password is 'engine' and the database name is 'engine':

      $ $HOME/ovirt-engine/bin/engine-setup

If jboss is installed at alternate location, add the following while JBOSS_HOME contains the location: `--jboss-home="${JBOSS_HOME}"`

When product is successfully set up, execute the ovirt-engine service:

      $ $HOME/ovirt-engine/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py start

The service will not exit as long as engine is up, to stop press <Ctrl>C.

Access your engine using:

*   <http://localhost:8080>
*   <https://localhost:8443>

Debug port is available via port `8787`, to be used by Eclipse or any other debugger.

When performing code change which do not touch modify database, there is no need to re-execute the setup, just execute:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

And start the engine service.

To rebuild everything use:

      make clean install-dev PREFIX="$HOME/ovirt-engine" 

To rebuild a single artifact, for example utils:

      make clean install-dev PREFIX=$HOME/ovirt-engine \
          EXTRA_BUILD_FLAGS="-pl org.ovirt.engine.core:utils"

Now make a single artifact that resides within the ear (bll,etc):

      make clean install-dev PREFIX=$HOME/ovirt-engine \
          EXTRA_BUILD_FLAGS="-pl org.ovirt.engine.core:bll,org.ovirt.engine:engine-server-ear"

Now your updated artifact is in place.

### Advanced Usage

#### JMX support

Starting ffrom 3.6, ssing the jboss-cli.sh and your login to admin@internal you can interact with ovirt JMX console and its beans:

*   add/change loggers and level
*   get statistics on transactions, connections
*   redeploy, shutdown the instance
*   stats form exposed ovirt beans like LockManager (see what engine entities are locked for provisioning)

First make sure `JBOSS_HOME` is set:

      export JBOSS_HOME=/usr/share/ovirt-engine-wildfly

Do an interactive session

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal

Get the engine data-source statistics:

       ls /subsystem=datasources/data-source=ENGINEDataSource/statistics=jdbc

Get Threading info

       ls /core-service=platform-mbean/type=threading/

#### Enable DEBUG log - Runtime change, no restart

Using the [OVirt Engine Development Environment#JMX Support](OVirt Engine Development Environment#JMX_Support) you can interact with the logging bean and it change in runtime:

*   adding loggers
*   modifying loggers log level

**Example open all `org.ovirt.engine.core` to debug:**

Make sure `JBOSS_HOME` is set:

      export JBOSS_HOME=/usr/share/ovirt-engine-wildfly

Add a logger in runtime

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal \
      "/subsystem=logging/logger=org.ovirt.engine.core:add"

Change log level of a logger in runtime

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal \
      "/subsystem=logging/logger=org.ovirt.engine.core:write-attribute(name=level,value=DEBUG)""

#### Enable DEBUG log - restart required

There is a file share/ovirt-engine/services/ovirt-engine/ovirt-engine.xml.in in the deployed engine environment. Open it and look for <subsystem xmlns="urn:jboss:domain:logging:1.1"> section. This section contains all output handlers (server.log, engine.log and console output) with associated level filters.

<file-handler name="ENGINE" autoflush="true">
` `<level name="DEBUG"/>
` `<formatter>
`  `<pattern-formatter pattern="%d %-5p [%c] (%t) %s%E%n"/>
` `</formatter>
` `<file path="$getstring('ENGINE_LOG')/engine.log"/>
` `<append value="true"/>
</file-handler>

To actually get the DEBUG messages to those handlers add the following to the end of the subsystem section:

<logger category="org.ovirt._package_you_are_interested_in">
`  `<level name="DEBUG"/>
</logger>

To enable full database DEBUG logging to engine.log change the level to DEBUG in the following snippet:

<logger category="org.ovirt.engine.core.dal.dbbroker.PostgresDbEngineDialect$PostgresJdbcTemplate">
`  `<level name="WARN"/>
</logger>

Restart the Jboss instance and you should see the logs.

#### Enable query by query postgresql log

Go to /var/lib/pgsql/data/postgresql.conf and change *log_statement* to 'all'. You can then find the logs in /var/lib/pgsql/data/pg_log/.

#### Enable Unit Tests

      $ make install-dev PREFIX="$HOME/ovirt-engine" BUILD_UT=1

#### Enable DAO Tests

*Optional:* Create database, provided the user is engine, password engine:

      # su - postgres -c "psql -d template1 -c "create database engine_dao_tests owner engine;""
      $ PGPASSWORD=engine ./packaging/dbscripts/schema.sh -d engine_dao_tests -u engine -c apply

Build with tests:

      $ make maven BUILD_GWT=0 BUILD_UT=1 EXTRA_BUILD_FLAGS="-P enable-dao-tests \
          -D engine.db.username=engine \
          -D engine.db.password=engine \
          -D engine.db.url=jdbc:postgresql://localhost/engine_dao_tests"

#### GWT Debug

      $ make install-dev PREFIX="$HOME/ovirt-engine"
`$ make gwt-debug DEBUG_MODULE=`<module>

While <module> is webadmin or userportal-gwtp.

Debug port is 8000, detailed instructions for GWT debugging are [here](http://wiki.ovirt.org/DebugFrontend).

GWT debug URLs, provided components running on same machine:

:{| |- | WebAdmin || <http://127.0.0.1:8080/ovirt-engine/webadmin/WebAdmin.html?gwt.codesvr=127.0.0.1:9997> |- | UserPortal || <http://127.0.0.1:8080/ovirt-engine/userportal/UserPortal.html?gwt.codesvr=127.0.0.1:9997> |}

## Packaging

### RPM packaging

Build system supports standard RPM packaging out of source tarball.

Create source tarball by executing:

      $ make dist

Install build dependencies, replacing `@x@` with file names, this should be executed second time only if build dependencies are changed:

      $ rpmbuild -ts @tarball@
      # yum-builddep @srpm@

Build RPMS:

      $ rpmbuild -tb @tarball@

RPM customization is supported refer to [ovirt-engine.spec.in](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=ovirt-engine.spec.in;hb=HEAD).

| Variable              | Default | Description                | Usage                                         |
|-----------------------|---------|----------------------------|-----------------------------------------------|
| ovirt_build_quick   | 0       | build as quickly as we can | syntax checks                                 |
| ovirt_build_minimal | 0       | minimal build              | development fully functional for firefox only |
| ovirt_build_gwt     | 1       | gwt enablement             | build or skip                                 |
| ovirt_build_locales | 1       | build extra locales        | production build                              |

Example:

      rpmbuild -D"ovirt_build_minimal 1" -tb @tarball@

## Troubleshooting

### Before you begin

Check if all prerequisites are installed, refer to [prerequisites](#Prerequisites)

### IBM JDK

There is [issues](https://code.google.com/p/google-web-toolkit/issues/detail?id=7530) when building oVirt engine using the IBM JDK.

The workaround to this problem is removing all the .gwtar files that are inside the gwt-user.jar package and building the project using `EXTRA_BUILD_FLAGS="-Dgwt.usearchives=false"`.

Author: --[Alon Bar-Lev](User:Alonbl) ([talk](User talk:Alonbl)) 02:25, 1 July 2014 (GMT)

<Category:Engine> [Category:How to](Category:How to) [Category:Development environment](Category:Development environment)

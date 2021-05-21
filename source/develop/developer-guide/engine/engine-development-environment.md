---
title: oVirt Engine Development Environment
category: engine
authors:
  - adahms
  - alonbl
  - amureini
  - arik
  - didi
  - dougsland
  - ecohen
  - gchaplik
  - gshereme
  - mkolesni
  - moolit
  - mperina
  - msivak
  - nsoffer
  - ofri
  - roy
  - smizrahi
  - tsaban
  - vered
  - vitordelima
  - vszocs
  - yair zaslavsky
  - ykleinbe
---

# oVirt Engine Development Environment

## Development Environment

<b>NOTE:</b> The latest certified documentation is available in the source tree at [README.adoc](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob_plain;f=README.adoc;hb=HEAD).

The purpose of this page is primarily to align the community experience with the certified procedures.

### Prerequisites

### RPM-Based Systems

1. Set Up the Snapshot Repository

    * Automatically

        Run the following command:

                # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-releaseXY.rpm

        <b>NOTE:</b> This does not work for master because it is available after release.

    * Manually

        Create the file `/etc/yum.repos.d/ovirt-snapshots.repo`, and replace `@distro@` in the following code block with `fc` for Fedora or `el` for RHEL or an equivalent distribution.

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

3. Install the Third-Party Packages

        # yum install git java-devel maven openssl postgresql-server postgresql-contrib \
            m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python \
            unzip pyflakes python-pep8 python-docker-py mailcap python-jinja2 \
            python-dateutil gdeploy

3. Application Servers

    Following application servers are required for engine development:

    * WildFly 8.2 for oVirt 3.6+ development

            # yum install ovirt-engine-wildfly ovirt-engine-wildfly-overlay

    * JBoss 7.1.1 for backporting changes to oVirt 3.5

            # yum install ovirt-engine-jboss-as

4. Install the oVirt Packages

        # yum install ovirt-host-deploy ovirt-setup-lib ovirt-js-dependencies

5. Set Up Java

    Make sure openjdk is the java preferred:

          # alternatives --config java
          # alternatives --config javac

Note: javassit used in some of the unit tests hits a regression introduced in java-1.7.0-openjdk-1.7.0.65. In order to avoid this issue, you can downgrade to java-1.7.0-openjdk-1.7.0.60.

### Debian-Based Systems

1. Install the following third-party packages:

        # apt-get install git openjdk-7-jdk maven openssl postgresql \
            python-m2crypto python-psycopg2 python-cheetah python-daemon \
            jboss-as unzip python-dateutil

2. Download jboss-as-7.1.1 from [jboss site](http://www.jboss.org/jbossas/downloads/) and extract to $HOME.

3. Install oVirt packages:

        TODO

4. Ensure openjdk is the preferred version of Java:

        # update-alternatives --config java

### Database

1. Some distributions require you to initialize the database prior to usage.

        Fedora: # postgresql-setup initdb
        RHEL:   # /etc/init.d/postgresql initdb
        Gentoo: # emerge --config postgresql-server

2. Configure PostgreSQL to accept network connection by locating `pg_hba.conf` file, locations includes:

        Fedora, RHEL: /var/lib/pgsql/data/pg_hba.conf
        Debian        /etc/postgresql/\*/main/pg_hba.conf
        Gentoo        /etc/postgresql-\*/pg_hba.conf

    Locate: 127.0.0.1/32 and ::1/128 and allow "password" authentication for IPv4 and IPv6 connections.

        # IPv4 local connections:
        host    all             all             127.0.0.1/32            password
        # IPv6 local connections:
        host    all             all             ::1/128                 password

3. Configure PostgreSQL to support at least 150 concurrent connections - find `postgresql.conf` file, usually in the same location of `pg_hba.conf`, locate 'max_connections' and set it to 150.

4. Restart PostgreSQL service for definitions to take effect:

        Fedora: systemctl restart postgresql.service
        RHEL:   service postgresql restart
        Gentoo: /etc/init.d/postgresql-* start

5. You may want to set the postgresql service to start at boot.

        systemctl enable postgresql.service

6. Create database and user, using the following commands as **root**:

        su - postgres -c "psql -d template1 -c \"create user engine password 'engine';\""
        su - postgres -c "psql -d template1 -c \"create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';\""
        su - postgres -c "psql -d template1 -c \"CREATE EXTENSION \\\"uuid-ossp\\\";\""

### Source

Checkout source:

      mkdir -p "$HOME/git"
      cd "$HOME/git"
      $ git clone git://gerrit.ovirt.org/ovirt-engine

### Usage

<font color="red"><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine.

Build product and install at `$HOME/ovirt-engine`, execute the following as unprivileged user while residing within source repository:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

Build may be customized, refer to [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) for further information.

If WildFly 8.2 should be used, then it's required to manually setup ovirt-engine-wildfly-overlay using following command:

    echo "ENGINE_JAVA_MODULEPATH="/usr/share/ovirt-engine-wildfly-overlay/modules:${ENGINE_JAVA_MODULEPATH}"" \
      > $PREFIX/etc/ovirt-engine/engine.conf.d/20-setup-jboss-overlay.conf

Run the following command and follow the prompts to set up oVirt. If you followed the procedure to create a database above, the database user is 'engine', the password for this user is 'engine', and the database name is also 'engine'.

      $ $HOME/ovirt-engine/bin/engine-setup

If JBoss is installed at an alternate location, add the following while JBOSS_HOME contains the location: `--jboss-home="${JBOSS_HOME}"`

When oVirt has been set up, run the following command to start the ovirt-engine service:

      $ $HOME/ovirt-engine/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py start

The service will not exit as long as engine is up, to stop press <Ctrl>C.

Open a web browser and navigate to one of the following links to access the welcome page:

*   `http://localhost:8080`
*   `https://localhost:8443`

Debug port is available via port `8787`, to be used by Eclipse or any other debugger.

When performing code changes that do not modify the database, there is no need to re-execute the setup; run the following command:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

And start the engine service.

To rebuild everything use:

      make clean install-dev PREFIX="$HOME/ovirt-engine" 

To rebuild a single artifact, for example utils:

      make clean install-dev PREFIX=$HOME/ovirt-engine \
          EXTRA_BUILD_FLAGS="-pl org.ovirt.engine.core:utils"

Now make a single artifact that resides within the ear (bll,etc):

      make clean install-dev PREFIX=$HOME/ovirt-engine \
          EXTRA_BUILD_FLAGS="-pl org.ovirt.engine.core:bll,org.ovirt.engine:engine-server-ear"

Now your updated artifact is in place.

### Advanced Usage

#### JMX Support

Starting ffrom 3.6, using the jboss-cli.sh and credentials to admin@internal you can interact with ovirt JMX console and its beans:

*   add/change loggers and level
*   get statistics on transactions, connections, threading
*   redeploy, shutdown the instance
*   stats from exposed oVirt beans like LockManager (see what engine entities are locked for provisioning)

First make sure `JBOSS_HOME` is set:

      export JBOSS_HOME=/usr/share/ovirt-engine-wildfly

Do an interactive session:

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal

Get the engine data-source statistics:

       ls /subsystem=datasources/data-source=ENGINEDataSource/statistics=jdbc

Get threading info:

       ls /core-service=platform-mbean/type=threading/

#### Enable DEBUG log - Runtime Change; No Restart

Using the [JMX Support](#jmx-support) you can interact with the logging bean and change it in runtime:

*   adding loggers
*   modifying logger's log level

**Example open all `org.ovirt.engine.core` to debug:**

Make sure `JBOSS_HOME` is set:

      export JBOSS_HOME=/usr/share/ovirt-engine-wildfly

Add a logger in runtime:

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal \
      "/subsystem=logging/logger=org.ovirt.engine.core:add"

Change log level of a logger in runtime:

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal \
      "/subsystem=logging/logger=org.ovirt.engine.core:write-attribute(name=level,value=DEBUG)"

keywords: how to debug ovirt-engine

#### Enable DEBUG Log - Restart Required

There is a file share/ovirt-engine/services/ovirt-engine/ovirt-engine.xml.in in the deployed engine environment. Open it and look for `<subsystem xmlns="urn:jboss:domain:logging:1.1">` section. This section contains all output handlers (server.log, engine.log and console output) with associated level filters.

    <file-handler name="ENGINE" autoflush="true">
      <level name="DEBUG"/>
      <formatter>
        <pattern-formatter pattern="%d %-5p [%c] (%t) %s%E%n"/>
      </formatter>
      <file path="$getstring('ENGINE_LOG')/engine.log"/>
      <append value="true"/>
    </file-handler>

To actually get the DEBUG messages to those handlers add the following to the end of the subsystem section:

    <logger category="org.ovirt._package_you_are_interested_in">
      <level name="DEBUG"/>
    </logger>

To enable full database DEBUG logging to engine.log change the level to DEBUG in the following snippet:

    <logger category="org.ovirt.engine.core.dal.dbbroker.PostgresDbEngineDialect$PostgresJdbcTemplate">
      <level name="WARN"/>
    </logger>

Restart the JBoss instance and you will see the logs.

#### Enable Query by Query postgresql Log

Go to /var/lib/pgsql/data/postgresql.conf and change *log_statement* to 'all'. You can then find the logs in /var/lib/pgsql/data/pg_log/.

#### Enable Unit Tests

      $ make install-dev PREFIX="$HOME/ovirt-engine" BUILD_UT=1

#### Enable DAO Tests

*Optional:* Create database, provided the user is engine, password engine:

      # su - postgres -c "psql -d template1 -c "create database engine_dao_tests owner engine;""
      $ PGPASSWORD=engine ./packaging/dbscripts/schema.sh -d engine_dao_tests -u engine -c apply

Build with tests:

      $ make maven BUILD_GWT=0 BUILD_UT=1 EXTRA_BUILD_FLAGS="-P enable-dao-tests \
          -D engine.db.username=engine \
          -D engine.db.password=engine \
          -D engine.db.url=jdbc:postgresql://localhost/engine_dao_tests"

#### GWT Debug

        $ make install-dev PREFIX="$HOME/ovirt-engine"
        # GWT classic dev mode:
        $ make gwt-debug
        # OR
        # GWT super dev mode:
        $ make gwt-debug DEV_BUILD_GWT_SUPER_DEV_MODE=1

See [Debugging Frontend Applications](/develop/developer-guide/debugfrontend.html) and [GWT Debug Quick Refresh](https://blogs.ovirt.org/2017/08/ovirt-webadmin-gwt-debug-quick-refresh/) for more information.

## Packaging

### RPM packaging

Build system supports standard RPM packaging out of source tarball.

Create source tarball by executing:

      $ make dist

Install build dependencies, replacing `@x@` with file names, this should be executed second time only if build dependencies are changed:

      $ rpmbuild -ts @tarball@
      # yum-builddep @srpm@

Build RPMS:

      $ rpmbuild -tb @tarball@

RPM customization is supported refer to [ovirt-engine.spec.in](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=ovirt-engine.spec.in;hb=HEAD).

| Variable              | Default | Description                | Usage                                         |
|-----------------------|---------|----------------------------|-----------------------------------------------|
| ovirt_build_quick   | 0       | build as quickly as we can | syntax checks                                 |
| ovirt_build_minimal | 0       | minimal build              | development fully functional for firefox only |
| ovirt_build_gwt     | 1       | gwt enablement             | build or skip                                 |
| ovirt_build_locales | 1       | build extra locales        | production build                              |

Example:

      rpmbuild -D"ovirt_build_minimal 1" -tb @tarball@

## Troubleshooting

### Before you begin

Check if all prerequisites are installed, refer to [prerequisites](#prerequisites)

* Don't forget to browse to the webadmin from a browser which the project was built to using the make command.

### IBM JDK

There are [issues](https://code.google.com/p/google-web-toolkit/issues/detail?id=7530) when building oVirt engine using the IBM JDK.

The workaround to this problem is to remove all GWTAR files inside the gwt-user.jar package and build the project using `EXTRA_BUILD_FLAGS="-Dgwt.usearchives=false"`.

Author: Alon Bar-Lev (Alonbl)


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

<b>Please notice:</b> Most updated certified documentation is available within source tree at [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD).

This page is mostly to absorb community experience into the certified procedures.

### Prerequisites

#### RPM based

Set up nightly repository:

**Option 1:** Install the repository file for Fedora (replace `fedora` with `el` for RHEL or equivalent distribution):

      # yum install http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm

**Option 2:** Create manually at `/etc/yum.repos.d/ovirt-nightly.repo`, replace `Fedora` with `EL` if you are using RHEL or an equivalent distribution:

      [ovirt-nightly]
      name=ovirt-nightly
      baseurl=http://resources.ovirt.org/releases/nightly/rpm/Fedora/$releasever/
      enabled=1
      gpgcheck=0
      priority=1
      protect=1

Install 3rd party packages:

      # yum install git java-devel maven openssl postgresql-server \
          m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python \
          jboss-as unzip

Install ovirt packages:

      # yum install --enablerepo ovirt-nightly ovirt-host-deploy

Make sure openjdk is the java preferred:

      # alternatives --config java
      # alternatives --config javac

#### Debian based

Install 3rd party packages:

      # apt-get install git openjdk-7-jdk maven openssl postgresql \
          python-m2crypto python-psycopg2 python-cheetah python-daemon \
          jboss-as unzip

Download jboss-as-7.1.1 from [jboss site](http://www.jboss.org/jbossas/downloads/) and extract to $HOME.

Install ovirt packages:

       TODO

Make sure openjdk is the java preferred:

      # update-alternatives --config java

#### Database

Based on your distribution it may be that you require to initialize the database.

      Fedora: # postgresql-setup initdb
      Gentoo: # emerge --config postgresql-server

Configure PostgreSQL to accept network connection by locating `pg_hba.conf` file, locations includes:

|--------|--------------------------------------|
| Fedora | /var/lib/pgsql/data/pg_hba.conf     |
| Debian | /etc/postgresql/\*/main/pg_hba.conf |
| Gentoo | /etc/postgresql-\*/pg_hba.conf      |

Locate: 127.0.0.1/32 and ::1/128 and allow "password" authentication for IPv4 and IPv6 connections, and "ident" authentication for unix domain socket connections.

      # IPv4 local connections:
      host    all             all             127.0.0.1/32            password
      # IPv6 local connections:
      host    all             all             ::1/128                 password
      # "local" is for Unix domain socket connections only
      local   all             all                                     ident

Restart PostgreSQL service for definitions to take effect:

You may consider set the postgresql service to start at boot.

Create database and user, usually using the following commands as root:

      su - postgres -c "psql -d template1 -c "create user engine password 'engine';""
      su - postgres -c "psql -d template1 -c "create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';""

It basically logins into PostgreSQL database using privileged user, creates a user and creates a database owned by the user.

#### Source

Checkout source:

      cd $HOME
      $ git clone git://gerrit.ovirt.org/ovirt-engine

### Usage

<font color=red><b>WARNING:</b> DO NOT RUN ENVIRONMENT UNDER ROOT ACCOUNT</font>

Once prerequisites are in place, you are ready to build and use ovirt-engine.

Build product and install at `$HOME/ovirt-engine`, execute the following as unprivileged user while residing within source repository:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

Build may be customized, refer to [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) for further information.

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

#### Enable Unit Tests

      $ make install-dev PREFIX="$HOME/ovirt-engine" BUILD_UT=1

#### Enable DAO Tests

*Optional:* Create database, provided the user is engine, password engine:

      # su - postgres -c "psql -d template1 -c "create database engine_dao_tests owner engine;""
      $ PGPASSWORD=engine ./packaging/dbscripts/create_schema.sh -d engine_dao_tests -u engine

Build with tests:

      $ make maven BUILD_GWT=0 BUILD_UT=1 EXTRA_BUILD_FLAGS="-P enable-dao-tests \
          -D engine.db.username=engine \
          -D engine.db.password=engine \
          -D engine.db.url=jdbc:postgresql://localhost/engine_dao_tests"

#### Upgrade Test database

If you do not wish to drop database and create it again, or you want do test the upgrade cycle of the database, run the following command, assumption of credentials are the same as in create:

      $ PGPASSWORD=engine ./packaging/dbscripts/upgrade.sh -u engine -d engine_dao_tests 

#### GWT Debug

      $ make install-dev PREFIX="$HOME/ovirt-engine"
`$ make gwt-debug DEBUG_MODULE=`<module>

While <module> is webadmin or userportal-gwtp.

Debug port is 8000, usage instructions are available at[https://developers.google.com/web-toolkit/doc/latest/DevGuideCompilingAndDebugging 1](https://developers.google.com/web-toolkit/doc/latest/DevGuideCompilingAndDebugging 1).

Common URLs, provided components running on same machine:

:{| |- | WebAdmin || <http://127.0.0.1:8080/webadmin/webadmin/WebAdmin.html?gwt.codesvr=127.0.0.1:9997> |- | UserPortal || <http://127.0.0.1:8080/UserPortal/org.ovirt.engine.ui.userportal.UserPortal/UserPortal.html?gwt.codesvr=127.0.0.1:9997> |}

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

       First, check if all prerequisites are installed.
` `[`http://www.ovirt.org/OVirt_Engine_Development_Environment#Prerequisites`](http://www.ovirt.org/OVirt_Engine_Development_Environment#Prerequisites)

There are issues when building oVirt engine using the IBM JDK, more details can be found in the following page: <https://code.google.com/p/google-web-toolkit/issues/detail?id=7530>

The workaround to this problem is removing all the .gwtar files that are inside the gwt-user.jar package and building the project using the "-Dgwt.usearchives=false" parameter in maven.

<Category:Engine> [Category:How to](Category:How to)

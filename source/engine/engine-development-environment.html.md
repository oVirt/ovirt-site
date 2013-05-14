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

Set up nightly repository `/etc/yum.repos.d/ovirt-nightly.repo`, replace `Fedora/18` with your distribution name and version (if available):

      [ovirt-nightly]
      name=ovirt-nightly
      baseurl=http://resources.ovirt.org/releases/nightly/rpm/Fedora/18/
      enabled=1
      gpgcheck=0
      priority=1
      protect=1

Install 3rd party packages:

      # yum install git java-devel maven openssl postgresql-server \
          m2crypto python-psycopg2 python-cheetah python-daemon \
          jboss-as

Install ovirt packages:

      # yum install ovirt-host-deploy

Make sure openjdk is the java preferred:

      # alternatives --config java
      # alternatives --config javac

#### Debian based

Install 3rd party packages:

      # apt-get install git openjdk-7-jdk maven openssl postgresql \
          python-m2crypto python-psycopg2 python-cheetah python-daemon \
          jboss-as

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

Locate: 127.0.0.1/32 and ::1/128 and allow password authentication.

      # IPv4 local connections:
      host    all             all             127.0.0.1/32            password
      # IPv6 local connections:
      host    all             all             ::1/128                 password

Restart PostgreSQL service for definitions to take effect.

Create database and user, usually using the following commands as root:

      su - postgres -c "psql -d template1 -c "create user engine password 'engine';""
      su - postgres -c "psql -d template1 -c "create database engine owner engine;""

It basically logins into PostgreSQL database using privileged user, creates a user and creates a database owned by the user.

#### Source

Checkout source:

      cd $HOME
      $ git clone git://gerrit.ovirt.org/ovirt-engine

### Usage

Once prerequisites are in place, you are ready to build and use ovirt-engine.

Build product and install at `$HOME/ovirt-engine`, execute the following as unprivileged user while residing within source repository:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

Build may be customized, refer to [README.developer](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.developer;hb=HEAD) for farther information.

Setup product by executing the following command and replying to questions, if you followed the database creation above then your database user is 'engine', its password is 'engine' and the database name is 'engine':

      $ $HOME/ovirt-engine/bin/engine-setup-2

If jboss is installed at alternate location, add the following while JBOSS_HOME contains the location: `--jboss-home="${JBOSS_HOME}"`

When product is successfully set up, execute the ovirt-engine service:

      $ $HOME/ovirt-engine/share/ovirt-engine/services/ovirt-engine.py start

The service will not exit as long as engine is up, to stop press <Ctrl>C.

Access your engine using:

*   <http://localhost:8080>
*   <https://localhost:8443>

Debug port is available via port `8787`, to be used by Eclipse or any other debugger.

When performing code change which do not touch modify database, there is no need to re-execute the setup, just execute:

      $ make install-dev PREFIX="$HOME/ovirt-engine"

And start the engine service.

### Advanced Usage

#### Enable Unit Tests

      $ make install-dev PREFIX="$HOME/ovirt-enigne" BUILD_TEST_FLAGS=""

#### Enable DAO Tests

Update `backend/manager/modules/dal/src/test/filters/pgsql.properties` with your database details.

      $ make install-dev PREFIX="$HOME/ovirt-engine" BUILD_TEST_FLAGS="-P enable-dao-tests"

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

<Category:Engine> [Category:How to](Category:How to)

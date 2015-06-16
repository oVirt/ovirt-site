---
title: Advanced oVirt Engine Build Notes
category: draft-documentation
authors: abonas, alonbl, amureini, asaf, dave chen, jhernand, ofrenkel
wiki_category: Draft documentation
wiki_title: Advanced oVirt Engine Build Notes
wiki_revision_count: 18
wiki_last_updated: 2013-05-12
---

# Advanced oVirt Engine Build Notes

<big><font color="lightgray" style="background-color: darkred">ATTENTION: This page is obsoleted for >=ovirt-engine-3.3 by [oVirt Engine Development Environment](OVirt_Engine_Development_Environment)</font></big>

## Introduction

This page contains some notes regarding oVirt engine build system.

Please visit [Building_oVirt_engine](Building_oVirt_engine) for basic step by step instructions how to build oVirt engine.

## Local Settings

Maven supports local settings by creating a local `settings.xml` file that should be placed inside your `$HOME/.m2` directory.

You can find instructions how to create a basic `settings.xml` file in Building oVirt Engine in the [Maven Personal Settings](Building_oVirt_engine#Maven_personal_settings) section.

## GWT Compilation Configuration

oVirt engine UI is based on GWT technology, Below are instructions how to tweak GWT compiler in order to speed up the development cycle.

### Compiling GWT for specific browser(s)

GWT compiler generates an application instance per supported browsers per locale, Since compiling to web mode takes a long time it is possible during development to compile to a specific browser (e.g Firefox) to speed up the compilation of WebAdmin web module,

This can be done by overriding the `gwt.userAgent` property. We recommend setting the `gwt.userAgent` property within the `gwtdev` profile. Edit `$HOME/.m2/settings.xml` file and add the following lines:

    <profiles>
      <profile>
        <id>gwtdev</id>
        <properties>
          <gwt.userAgent>gecko1_8</gwt.userAgent>
        </properties> 
      </profile>
    </profiles>

*   Build oVirt Engine and enable the `gwtdev` profile:

<!-- -->

    $ mvn install -Pdep,gwtdev,gwt-admin

This will instruct GWT to generate 1 permutation for Firefox browser only. If you need to build for other browsers you can use the following values inside the `gwt.userAgent` property:

*   For Firefox: `gecko1_8`
*   For Internet Explorer 6: `ie6`
*   For Internet Explorer 8: `ie8`
*   For Internet Explorer 9: `ie9`
*   For Safari and Chrome: `safari`
*   For Opera: `opera`

For example, if you want to build for both Firefox and Chrome you can use the following:

    <profiles>
      <profile>
        <id>gwtdev</id>
        <properties>
          <gwt.userAgent>gecko1_8,safari</gwt.userAgent>
        </properties> 
      </profile>
    </profiles>

Alternatively, if you don't want to modify your `$HOME/.m2/settings.xml` file, you can set the property in the command line. For example to build WebAdmin for Firefox and Chrome you can use the following command:

    $ mvn install -Dgwt.userAgent=gecko1_8,safari -Pgwt-admin

## Testing DAOs

By default, the DAO tests are not run during `mvn install`, since they require an actual PostgreSQL database to run on. In order to run them, you should follow these instructions.

First, you must create a database to use for the tests. This database's credentials are defined in `$OVIRT_GIT/backend/manager/modules/dal/src/test/filters/pgsql.properties`. By default the tests are run on a database called `engine_test` by the `postgres` user (you can, of course, change these details in your own environment. To create this database, perform the following:

    $ cd $OVIRT_GIT/backend/manager/dbscripts
    $ ./create_db_devel.sh -d engine_test -u postgres

In order to run the tests, you will have to enable the `enable-dao-tests` profile:

    $ cd $OVIRT_GIT/backend/manager/modules/dal
    $ mvn install -Penable-dao-tests

Note: you may use the `enable-dao-tests` profile on higher levels than the `dal` module, such as when building the engine's root.

## Skipping Unit Tests

It is possible during development to speed up the build process by skipping the execution of unit tests, This can be done by adding the `-DskipTests` to your build command:

    $ mvn install -DskipTests

## Log Configuration

Engine logging is done with log4j.
the configuration is done with jboss-log4j.xml file which can be found under <jboos profile dir>/conf/
this file contains categories for main components, and log level can be changed there.
also 3rd parties components are configured in this file (like apache http client).
it is also possible to add appenders which allow logging some components to different files.
(this is useful when logging debug messages of component that may create a lot of 'noise' in the regular log).

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)

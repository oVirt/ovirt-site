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

## Introduction

This page contains some notes regarding oVirt engine build system.

Please visit [Building_oVirt_engine](Building_oVirt_engine) for basic step by step instructions how to build oVirt engine.

## Local Settings

Maven supports local settings by creating a local settings.xml file that should be placed under your local maven repository (~/.m2),

You can find instructions how to create a basic settings.xml file in Building oVirt Engine in the [Maven Personal Settings](Building_oVirt_engine#Maven_personal_settings) section.

## GWT Compilation Configuration

oVirt engine UI is based on GWT technology, Below are instructions how to tweak GWT compiler in order to speed up the development cycle.

### Compiling GWT for specific browser(s)

GWT compiler generates an application instance per supported browsers per locale, Since compiling to web mode takes a long time it is possible during development to compile to a specific browser (e.g Firefox 7) to speed up the compilation of WebAdmin web module,

This can be done by overriding the **gwt.userAgent** property,

We recommend setting the 'gwt.userAgent' property within the **gwtdev** profile:

*   Edit ~/.m2/settings.xml file
*   Add the following lines:

      <profiles>
        <profile>
          <id>gwtdev</id>
          <properties>
            <gwt.userAgent>gecko1_8</gwt.userAgent>
          </properties> 
        </profile>
      </profiles>
       

*   Build oVirt Engine and enable the **gwtdev** profile:

      $> cd $OVIRT_HOME
      $> mvn2 clean install -Pgwtdev,gwt-admin
       

This will instruct GWT to generate 1 permutation for FireFox browser only.

## Skipping Unit Tests

It is possible during development to speed up the build process by skipping the execution of unit tests, This can be done by adding the **-DskipTests=true** to your build command:

      $> cd $OVIRT_HOME
      $> mvn clean install -DskipTests=true
       

It is also possible to skip only the fluster tests (which take a considerable amount of time) instead of all the tests:

      $> cd $OVIRT_HOME
      $> mvn clean install -Pdisable-gluster-tests
       

## Forking Unit Tests

Several modules fork their unit tests by default to avoid PermGen error caused by leaky components. In older Maven versions this is less of an issue, so forking may be disabled by using the **-Dengine.powermock.fork=once** flag:

      $> cd $OVIRT_HOME
      $> mvn2 clean install -Dengine.powermock.fork=once
       

## Log Configuration

Engine logging is done with log4j.
the configuration is done with jboss-log4j.xml file which can be found under <jboos profile dir>/conf/
this file contains categories for main components, and log level can be changed there.
also 3rd parties components are configured in this file (like apache http client).
it is also possible to add appenders which allow logging some components to different files.
(this is useful when logging debug messages of component that may create a lot of 'noise' in the regular log).

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)

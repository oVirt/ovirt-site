---
title: JMX Support
category: engine
authors: roy
---

# JMX Support

Starting from 3.6, we can interact with the application server JMX API using the internal ovirt credentials.
By default its listening **localhost:8706** and every **superuser** such as **admin@internal** can login. To change the interface settings create a `/etc/ovirt-engine/engine.conf.d/20-setup-jmx-debug.conf` with:

       ENGINE_JMX_INTERFACE=public

Using the jboss-cli.sh you can interact with ovirt JMX console and its beans to do things such as:

*   add/change **loggers** and change **logging level**
*   get statistics on **transactions**, connections, **threading**
*   **redeploy**, **shutdown** the instance
*   stats from exposed oVirt beans like **LockManager** (see what engine entities are locked for provisioning)

This list is partial. JMX is an API and we can expose whatever management functionality is needed.

# Usage

First make sure `JBOSS_HOME` is set:

      export JBOSS_HOME=/usr/share/ovirt-engine-wildfly

## Interactive/cli session

Omitting a command from the argument list will open an interactive session

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal

A Cli command to get the version of the app server and some info:

      $JBOSS_HOME/bin/jboss-cli.sh --controller=127.0.0.1:8706 --connect --user=admin@internal version
      Password: 
      JBoss Admin Command-line Interface
      JBOSS_HOME: /home/rgolan/jboss/current
      JBoss AS release: 8.2.0.Final "Tweek"
      JAVA_HOME: /usr/lib/jvm/java-1.8.0-openjdk/
      java.version: 1.8.0_51
      java.vm.vendor: Oracle Corporation
      java.vm.version: 25.51-b03
      os.name: Linux
      os.version: 4.1.3-201.fc22.x86_64

## Create a new log category

       /subsystem=logging/logger=org.ovirt.engine:add

## Modify log level

       /subsystem=logging/logger=org.ovirt.engine.core.bll:write-attribute(name=level,value=DEBUG)

## Get the engine data-source statistics:

      ls /subsystem=datasources/data-source=ENGINEDataSource/statistics=jdbc

Author: Roy Golan <rgolan@redhat.com>

## Get Threading info:

      ls /core-service=platform-mbean/type=threading/


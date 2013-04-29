---
title: VDSM Fake
category: vdsm
authors: lspevak, tjelinek
wiki_title: VDSM Fake
wiki_revision_count: 3
wiki_last_updated: 2013-09-19
---

# VDSM Fake

## Introduction

VDSM is a daemon component written in Python required by oVirt-Engine (Virtualization Manager), which runs on Linux hosts and manages and monitors the host's storage, memory and networks as well as virtual machine creation/control, statistics gathering, etc. **VDSM Fake** is a support application framework for oVirt Engine project. It is a Java web application which enables to simulate selected tasks of real VDSM. But, tens or hundreds of simulated Linux hosts and virtual machines can be reached with very limited set of hardware resources. The aim is to get marginal performance characteristics of oVirt Engine JEE application (JBoss) and its repository database (PostgreSQL), but also network throughput, etc.

## Technology

The basic idea is that fake host addresses must resolve to a single IP address (127.0.0.1 is also possible for all-in-one performance testing server configuration). Standard HTTP port 54321 must be accessible from the Engine. You can use /etc/hosts file on the server with oVirt-Engine or company DNS server. Apache XML-RPC library is a core technology for the Engine vs. VDSM communication. Many configured entities must be persisted after their creation. Simple Java object serialization is used for this purpose (directory /var/log/vdsmfake/cache).

## Functionality

The application runs in 2 modes:

*   simulation
*   proxy to real VDSM

All or selected XML requests/responses are optionally logged into a directory (/var/log/vdsmfake/xml). Currently the configuration is possible changable in web.xml, log4j.xml files only.

## Supported methods

*   create hosts
*   create/attach/activate DATA/EXPORT/ISO NFS storage domains
*   create VM from iso (+ create network, create volume)
*   run/shutdown VM
*   migrate VM

## Project

Source code

*   <git://github.com/lspevak/ovirt-vdsmfake.git>

VDSM Fake is Maven configured project.

Required directories (set RW access):

*   /var/log/vdsmfake
*   /var/log/vdsmfake/xml
*   /var/log/vdsmfake/cache

Maven commands:

*   Generate WAR file: mvn install
*   Run sample web server: mvn jetty:run

or use e.g. Apache Tomcat

*   download from <http://tomcat.apache.org/>
*   cd apache-tomcat-7.0.34/webapps
*   rm -rf ROOT
*   copy vdsmfake.war as ROOT.war to apache-tomcat-7.0.34/webapps
*   change HTTP port inside apache-tomcat-7.0.34/conf/server.xml to 54321
*   cd apache-tomcat-7.0.34/bin
*   ./startup.sh

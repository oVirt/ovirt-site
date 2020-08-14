---
title: VDSM Fake
category: vdsm
authors: lspevak, tjelinek
---

# VDSM Fake

## Introduction

VDSM is a daemon component written in Python required by oVirt-Engine (Virtualization Manager), which runs on Linux hosts and manages and monitors the host's storage, memory and networks as well as virtual machine creation/control, statistics gathering, etc. **VDSM Fake** is a support application framework for oVirt Engine project. It is a Java web application which enables to simulate selected tasks of real VDSM. But, tens or hundreds of simulated Linux hosts and virtual machines can be reached with very limited set of hardware resources. The aim is to get marginal performance characteristics of oVirt Engine JEE application (JBoss) and its repository database (PostgreSQL), but also network throughput, etc.

## Technology

The basic idea is that the fake host addresses must resolve to a single IP address (127.0.0.1 is also possible for all-in-one performance testing server configuration). Standard HTTP port 54321 must be accessible from the Engine. You can use /etc/hosts file on the server with oVirt-Engine or company DNS server. Instead of host IP address it is needed to specify fake host name. Apache XML-RPC library is a core technology for the Engine and VDSM communication. Many configured entities must be persisted after their creation. Simple Java object serialization is used for this purpose (directory /var/log/vdsmfake/cache).

## Functionality

The application runs in 2 modes:

*   simulation
*   proxy to real VDSM

All or selected XML requests/responses are optionally logged into a directory (/var/log/vdsmfake/xml). Currently the configuration is possible to update in web.xml, log4j.xml files only.

## Supported methods

*   create hosts
*   create/attach/activate DATA/EXPORT/ISO NFS storage domains
*   create VM from iso (+ create network, create volume)
*   run/shutdown VM
*   migrate VM

## Project

VDSM Fake is a Maven configured project. Source code:

*   git clone <git://gerrit.ovirt.org/ovirt-vdsmfake.git>

## Installation

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
*   copy vdsmfake.war as ROOT.war to apache-tomcat-7.0.34/webapps (remove standard ROOT folder first)
*   change HTTP port inside apache-tomcat-7.0.34/conf/server.xml to 54321
*   Run startup.sh inside apache-tomcat-7.0.34/bin directory

## oVirt-Engine Batch Configuration

The fake hosts and VMs can be installed by REST API - more info: [REST_API_Using_BASH_Automation](/develop/api/rest-api/rest-api-using-bash-automation.html).

    #!/bin/bash

    ...
    N_HOSTS=100
    N_VMS=300
    OUT_FILE=/tmp/fakehosts.txt

    function createEtcHosts {
        echo "" > ${OUT_FILE}
        for i in $(seq 1 ${N_HOSTS}); do
                echo "127.0.0.1    fake${i}.example.com" >> ${OUT_FILE}
        done;
    }

    function createHosts {
        for i in $(seq 1 ${N_HOSTS}); do
            createHost "fake${i}.example.com" "fake${i}.example.com" "123456" "Default"
        done;
    }

    function createVM {
        local index=$1
        local vmName=Fedora17_fake${index}
        # 512M, disk 10GB
        createVirtualMachineFromTemplate "${vmName}" "Default" "Blank" "536870912"
        createVirtualMachineNIC "${vmName}" "ovirtmgmt"
        createVirtualMachineDisk "${vmName}" "10485760000" "Storage_DATA"
        createVirtualMachineCDROM "${vmName}" "Fedora-17-x86_64-DVD.iso"
    }

    function createVMs {
        for i in $(seq 201 ${N_VMS}); do
            createVM ${i}
        done;
    }

---
title: Integrating libosinfo with oVirt engine
category: feature
authors: mlipchuk, mskrivan, roy, sandrobonazzola
wiki_category: Feature
wiki_title: Integrating libosinfo with Ovirt engine
wiki_revision_count: 53
wiki_last_updated: 2015-08-19
feature_name: Integrating libosinfo with Ovirt engine
feature_modules: virt
feature_status: Released
---

# Integrating libosinfo with oVirt engine

## integrating with libosinfo - FEATURE WAS DROPPED - REPLACED by [OS info](OS info)

<big>**NOTE: this has been superseded by a different approach described [here](OS_info)**</big>

### Summary

ovirt engine needs OS information out-sourced instead of static DB/code configuration. [<https://fedorahosted.org/libosinfo/>](libosinfo) is a GObject based library API for managing information about operating systems, hypervisors and the (virtual) hardware devices they can support. It includes a database containing device metadata and provides APIs to match/identify optimal devices for deploying an operating system on a hypervisor.

### Benefits for ovirt

Use the knowledge supplied by OS providers to set VM default values of CPU and RAM, ISO download links, supported hardware per hypervisor (validation on top of it?).

### Owner

*   Name: [ Roy Golan](User:MyUser)

<!-- -->

*   Email: <rgolan at redhat.com>

### Current status

*   status: deprectaed - Osinfo is a new backend component - see [OS info](OS info)
*   Last updated date: June 2014

### Detailed Description

#### usages

*   suggest default value when adding a disc e.g set a 15 Gb disc if its a Windows 7
*   extract all OS info (names, OS family, architecture instead of house-keeping an enum.
*   engine can validate when trying to run a VM with lower memory then recommended.

#### High Level design

libosinfo supplies a query API on top of its XML based DB. While XML data is being updated across versions, the API aims to remain stable and have capabilities to describe client specific deployments on top of the DB to describe special compatibility cases.

To interact with libosinfo, a JNA standalone application, RMI capable, will be used and the Ovirt Engine would have a the RMI client invoking it, and controlling its life-cycle.

![](libosinfo_diagram.png "libosinfo_diagram.png")

### Invoking the LibosinfoServer

Till ovirt engine will have a process babysiter the engine client will be responsible for invoking the external LIbosinfoServer and shutting it off using a Java's shutdown hook. The library supports parallel calls from different clients so multithreading isn't an issue.

LibosinfoServer is publishing its RMI stub to the stdout so a process invoking it can read it without using an RMI registry. So the steps to achieve RMI handshake is:

*   Engine ear loads
*   LibosinfoClient loaded as part of the ear is calling a system process. here there are 2 options:
    -   LibodinfoServer will be wrapped by a script same as any other engine tools
        it will have jboss-modules loading its dependencies
        cons: this approach is complicated for developers who have to run some make target to the tool and modules installed

       osinfo-server.sh
       . engine-prolog.sh
       exec java 
        -jar "${JBOSS_HOME}/jboss-modules.jar" \
       -dependencies org.ovirt.engine.core.tools \
       -class org.ovirt.engine.core.libosinfo.server.LibosinfoServer

*   -   engine fires another java process
        it has to calculate the classpath variables itself but it may be easier for developing mode

      java -CLASSPATH $ENGINE_EAR/tools.jar:$JAVA_LIB/jna.jar LibosinfoServer

*   LibosinfoServer is loading and writing to its stdout the server stub
*   libosinfoClient has a stub RMI object in hand

### communication

[RMI](http://en.wikipedia.org/wiki/Java_remote_method_invocation) uses anonymous port and local to the Engine's machine alone.

### OSInfoService interface

The service interface, implemented by the RMI server (LibosinfoServer) and consumed by the client (LibosinfoClient).
It exposes a simplified subset version of libosinfo API:

      OSInfoService
          public long getMinimumCpu(String osId, String cpuArch);
          public long getRecommendedCpu(String osId, String cpuArch);
          public long getMinimumRam(String osId, String cpuArch);
          public long getReommendedRam(String osId, String cpuArch);

### Code Chages

### Project structure

#### Libosinfo Server

*   located under ***tools.jar***
*   its main class is LibosinfoServer
*   dependencies - jna.jar, ships with fedora, located under ***/usr/share/java/jna.jar***

      backend/manager/tools
      src/
      ├── main
      │   ├── java
      │   │   └── org
      │   │       └── ovirt
      │   │           └── engine
      │   │               └── core
      │   │                   └── osinfo

#### Libosinfo Client

      backend/manager/modules/utils
       src/
      ├── main
      │   ├── java
      │   │   └── org
      │   │       └── ovirt
      │   │           └── engine
      │   │               └── core
      │   │                   └── utils
      │   │                       └── osinfo

#### entity changes

##### VmOsType

      TODO update changes to VM and VM.osType and its usages

##### introduce CpuArch

Vm will have a new property - CpuArch. It will not be enforced by the cluster currently(future?) and has
no impact on the running VM configuration except validating Min/Max memory cpu values.

*   every OS has a resources field and every resources field has an "arch" attribute. Values can be "all|i386|x86_64" and those will mapped to the CpuArch enum.
*   **UNASSIGNED** - this OS has no architecture-specific resources details.
*   **ALL** - the resources specifications are for all architectures of that OS release.

      CpuArch.class
         UNASSIGNED(0),
         ALL(1),
         i386(2),
         i586(3),
         i686(4),
         X86_64(5);

![](editVm.png "editVm.png")

##### REST /api/capabilities

no real change there except the added enum members.

##### VmHandler

plug the memory checks to libosinfo instead the use of Config values.

##### DB

1.  add CpuArch field to **vm_static** and **vms** view
2.  upgrade vm_static table - remove entries from VmOsType that represents x86_64 archs.
    instead put the canonical OS and put the relevant CpuArch value for it.
3.  exported VMs - how will we upgrade their os field according to the new mapping mentioned earlier? [1]

#### Installer Changes

*   add libosinfo rpm as a dependency for ovirt-engine

### Documentation / External references

*   libosinfo project page on FedoraHosted

<https://fedorahosted.org/libosinfo/>

### Dependencies

| package   | RHEL  | Fedora    |
|-----------|-------|-----------|
| libosinfo | ?     | f17 0.1.2 |
| jna       | 3.2.4 | 3.4       |

### Related Features

[support for PPC 64 bit](http://www.ovirt.org/Features/Engine_support_for_PPC64|Engine)

### TODO

*   add cpuArch to OVF reader/writer
*   open an integration ticket

### Open issues

[1] exported VMs should have their os type field upgraded too. - use OVF reader logic to upgrade OsType of Windows2003x64 to win2k3 and cpuArch to x86_64

### Comments and Discussion

<Category:Feature> [Category:oVirt 3.4 Feature](Category:oVirt 3.4 Feature)

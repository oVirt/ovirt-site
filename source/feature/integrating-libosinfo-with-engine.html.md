---
title: Integrating libosinfo with Ovirt engine
category: feature
authors: mlipchuk, mskrivan, roy, sandrobonazzola
wiki_category: Feature
wiki_title: Integrating libosinfo with Ovirt engine
wiki_revision_count: 52
wiki_last_updated: 2014-12-15
---

# Integrating libosinfo with Ovirt engine

## integrating with libosinfo

### Summary

ovirt engine needs OS information out-sourced instead of static DB/code configuration. [<https://fedorahosted.org/libosinfo/>](libosinfo) is a GObject based library API for managing information about operating systems, hypervisors and the (virtual) hardware devices they can support. It includes a database containing device metadata and provides APIs to match/identify optimal devices for deploying an operating system on a hypervisor.

### Benefits for ovirt

Use the knowledge supplied by OS providers to set VM default values of CPU and RAM, ISO download links, supported hardware per hypervisor (validation on top of it?).

### Owner

*   Name: [ Roy Golan](User:MyUser)

<!-- -->

*   Email: <rgolan at redhat.com>

### Current status

*   status: design updated. Mostly implemented
*   Last updated date: Nov 6 2012

### Detailed Description

#### usages

*   suggest default value when adding a disc e.g set a 15 Gb disc if its a Windows 7
*   extract all OS info (names, OS family, architecture instead of house-keeping an enum.
*   engine can validate when trying to run a VM with lower memory then recommended.

#### design

*   abstraction for query Os info - OSInfoService

engine will have a service to abstract all interaction with libosinfo.

1.  the service will encapsulate the means of how to interact with the library itself
2.  the service will expose a required subset of libosinfo API

      OSInfoService
         int getMinimumCpuSpeed(String osId, CpuArch cpuArch);
         int getMinimumCpuNumber(String osId, CpuArch cpuArch);
         long getMinimumRam(String osId, CpuArch cpuArch);
         int getRecommendedCpu(String osId, CpuArch cpuArch);
         long getRecommendedRam(String osId, CpuArch cpuArch);
         /**
          * @param shortId
          * @return an Os instance for the given shortId or an empty Os instance (most String values with "") if there is no
          *         match.
          */
         Os getByShortId(String shortId);
         Map`<String, Os>` getAll();
         Set`<String>` getShortIds();

*   loading libosinfo data into ovirt engine

when the engine starts it will load, with jaxb all the xmls under /usr/share/libosinfo/data/oses into java beans
representing an OS. The class representing an OS and all of its dereiviants will be auto-generated from an xsd file during the
development phase. Once loaded, every OS has an object representing it, all will reside in map with its short-id as a key.

to summerize the steps to load os data:

1.  in dev phase - create an xsd from one of the os xmls under /usr/share/libosinfo/data/oses - this step is done once
     The xsd can later be customized to help the jaxb generator to create classes which are serialized, avoid inner classes and so on.
2.  auto-generate classes from the XSD using maven plugin
3.  exposed the OS entities as a jar to the rest of the project - engine, GWT and REST will use directly the auto generated entities.
4.  on engine startup, load all OS xmls to a map which can be retrieved by a query

### Dependencies / Related Features

ovirt should depend on libosinfo RPM which ships with Fedora 17 and RHEL 6.3

1.  libosinfo package: libosinfo-0.0.4-2
2.  libosinfo OS xml files location: /usr/share/libosinfo/data/oses

### Code Chages

#### Project structure

*   Libosinfo is an engine service so I find it very convenient to create a "services" module place it under it

      |-- backend
        |-- manager
          |-- modules
            |-- services
              |-- libosinfo
                |-- interface
                |-- types

**types** project holds the auto-generated entities and. **interface** project holds the **LibosinfoService** interface and currently also the xml-loading implementation.

#### entity changes

##### VmOsType

1.  remove family, is64Bit as all is represented by the OS
2.  **shortId** - add 1 to 1 mapping of all OSs in the xml and designate an internal ID for them
3.  architecture will be represented as a new Vm property - CpuArch

      VmOsType.class
       ...
         Windows2008x64(16, "win2k-8"),
         Windows2008R2x64(17, "win2k-8"),
         RHEL6(18, "rhel-6.0"),
         RHEL6x64(19, "rhel-6.0"),
      // bsd
          freebsd6(1, "freebsd6"),
          freebsd7(2, "freebsd7"),
          freebsd8(3, "freebsd8"),
          openbsd4(4, "openbsd4"),
      // centos
         centos__6_0(101, "centos-6.0"),
         centos__6_1(102, "centos-6.1"),
      // debian
          debianbuzz(201, "debianbuzz"),
          debianrex(202, "debianrex"),
          debianbo(203, "debianbo"),
          debianhamm(204, "debianhamm"),
      ...
         private final int intValue;
         /**
          * shortId of the OS as represented by libosinfo.
          */
         private final String shortId;
         private VmOsType(final int value, String shortId) {
             intValue = value;
             this.shortId = shortId;
         }

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

### TODO

*   add cpuArch to OVF reader/writer
*   open an integration ticket

### Open issues

[1] exported VMs should have their os type field upgraded too. - use OVF reader logic to upgrade OsType of Windows2003x64 to win2k3 and cpuArch to x86_64

### Comments and Discussion

<Category:Feature> <Category:Template>

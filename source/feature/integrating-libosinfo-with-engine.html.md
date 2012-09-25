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

*   Email: <rgolan@redhat.com>

### Current status

*   status: first design draft
*   Last updated date: Sep 24 2012

### Detailed Description

#### usages

*   suggest default value when adding a disc e.g set a 15 Gb disc if its a Windows 7
*   extract all OS names instead of house-keeping an enum.
*   engine can validate when trying to run a VM with lower memory then recommended.

#### design

*   abstraction for query Os info - OSInfoService

engine will have a service to abstract all interaction with libosinfo.

1.  the service will encapsulate the means of how to interact with the library itself
2.  the service will expose a required subset of libosinfo API

      OSInfoService
       /** 
       * Get the recommended minimum memory by OS
       */
       int getRecomendedMemoryByOS(String os)
        
       /**
       * Get the recommended num of CPU by OS
       */
       int getRecommendedCPUByOS(String os)

*   libosinfo interaction details

libosinfo relies on xml-based db and Gobject bindigs on top, with javascript and python api's. we can either:

1.  load the xml's to java objects using jaxb. might be a KISS for the current needs. we are loosing the API the library exposes.
2.  use Java InvokeDynamic to do python or javascript invocation of API. we gain all functionality (bugs too). need to make sure invoking dynamic code is easy and secure - some people reject the idea of leaving the VM for external invocations.
3.  contribute a java bindings with just a subset of the api - essentially do whats written in 1 and contribute it

### Dependencies / Related Features

ovirt should depend on libosinfo RPM which ships with Fedora 17 and RHEL 6.3
-- add here the list of XMLs and python api classes --

### Documentation / External references

*   libosinfo project page on FedoraHosted

<https://fedorahosted.org/libosinfo/>

### Comments and Discussion

<Category:Feature> <Category:Template>

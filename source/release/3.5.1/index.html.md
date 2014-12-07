---
title: OVirt 3.5.1 Release Notes
category: documentation
authors: alonbl, bproffitt, didi, sandrobonazzola, stirabos
wiki_category: Documentation
wiki_title: OVirt 3.5.1 Release Notes
wiki_revision_count: 32
wiki_last_updated: 2015-02-02
---

# OVirt 3.5.1 Release Notes

## Install / Upgrade from previous versions

This page is still a work in progress.

## What's New in 3.5.1?

### Red Hat Enterprise Linux 7 and CentOS 7 Support

Support for running oVirt Engine on Red Hat Enterprise Linux 7 and CentOS 7 (or similar) has been added providing custom packaging of JBoss Application Server 7.

### Ovirt Engine Extensions

More information available at [Features/AAA](Features/AAA).

#### Log4J logger bridge

Log4j bridge for engine log, can be used to redirect log records to any appender log4j supports. Package name is ovirt-engine-extension-logger-log4j, documentation is available at [1](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-logger-log4j.git;a=blob;f=README;hb=HEAD).

#### LDAP Authentication and Authorization

A new LDAP implementation for ovirt-engine, replaces the legacy Kerberos/LDAP implementation. The new implementation is customizable, has greater support matrix for LDAP features and enable adding new LDAP schemes. Package name is ovirt-engine-extension-aaa-ldap, documentation is available at [2](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-ldap.git;a=blob;f=README;hb=HEAD).

#### Misc Authentication and Authorization utility

Extensions required mainly for enabling single signon of ovirt-engine with environments such as Kerberos. Package name is ovirt-engine-extension-aaa-misc, LDAP specific integration is documented within the ovirt-engine-extension-aaa-ldap package [3](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-ldap.git;a=blob;f=README;hb=HEAD#l158), and in package specific documents [4](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-misc.git;a=blob;f=README.http;hb=HEAD)[5](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-misc.git;a=blob;f=README.mapping;hb=HEAD).

## Known issues

## CVE Fixed

[CVE-2014-3561](https://access.redhat.com/security/cve/CVE-2014-3561) ovirt-engine-log-collector: database password disclosed in process listing

## Bugs fixed

### oVirt Engine

### VDSM

### ovirt-hosted-engine-setup

* If another network has the "required" flag a new host will fail and timeout
 - First interaction with hosted-engine --deploy process happening before, that answer file loading
 - Engine vm is not killed after that deployment process aborted
 - answers.conf is replaced if configuration is not complete
 - [TEXT] hosted-engine --deploy should provide better error message when iSCSI luns list is empty
 - Volume creation failed while deploying Hosted Engine on iSCSI
 - Lost all the configuration for hosted engine after reboot rhevh
 - [hosted-engine][iscsi] [dirty storage] [ ERROR ] Failed to execute stage 'Misc configuration': Wrong Master domain or its version:
 - [hosted-engine] [iSCSI support] The LUN used for engine VM disk is allowed to be picked for storage domain creation/extension
 - [hosted-engine] [iSCSI support] Putting an iSCSI domain in maintenance while the hosted-engine is installed on a LUN from the same storage server causes the setup to become non operational
 - [engine-backend] [importDomain] hosted-engine: import the hosted-engine's storage domain is allowed
 - Installation of second host failed, when try to fetch answer file IOError: [Errno 2] No such file
 - Error trying to add new hosted-engine host to upgraded Hosted Engine cluster
 - [hosted-engine] Uncoherent 'Cannot add the host to cluster None' error message on SDK failure

### ovirt-image-uploader

* ERROR: Problem connecting to the REST API. Is the service available and does the CA certificate exist?
 - 40% perf regression in image uploader
 - non-ovf file is not reported properly

### ovirt-iso-uploader

* ERROR: Problem connecting to the REST API. Is the service available and does the CA certificate exist?

### ovirt-log-collector

* [RHEV] rhevm-log-collector does not gather /etc/ovirt-engine-reports or /etc/ovirt-engine-dwh
 - postgres data is not collected
 - remove password leak from ovirt-engine setup answer file

<Category:Documentation> <Category:Releases>

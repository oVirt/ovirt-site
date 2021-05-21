---
title: oVirt 3.0 release notes
category: documentation
toc: true
authors:
  - danken
  - dneary
  - lpeer
  - mburns
  - michael pasternak
  - oschreib
  - sandrobonazzola
  - sgordon
  - yaniv dary
---

# oVirt 3.0 release notes

The oVirt Project is pleased to announce the availability of its first formal release, oVirt 3.0.

## Software Development Kit

The oVirt Engine Software Development Kit provides an enhanced Python environment to support the development of custom software utilizing the APIs exposed by the engine.

### Features

*   This is the initial formal release of the oVirt Engine SDK.

### Resolved Issues

*   Use direct URI on get(id=x) rather than search pattern.
*   Extension to support the addition of new clusters ([BZ#782707](https://bugzilla.redhat.com/782707)).
*   Added connectivity check and disconnect methods ([BZ#781820](https://bugzilla.redhat.com/781820)).

### Known Issues

*   An application can only create one proxy to the API.

### Known Issues

The following items are not yet supported, but are on the roadmap:

*   Command history.
*   Command auto completion.

## Engine

The oVirt Engine is a feature-rich server virtualization management system that provides advanced capabilities for managing open virtualization infrastructure.

#### Features

*   The engine is now running on Jboss AS7 as the application server
*   [Locking mechanism](/develop/release-management/features/infra/detailedlockmechanism.html)
*   [SPM Priority](/develop/release-management/features/storage/spmpriority.html)
*   Added maintenance Storage Domain Status ([BZ 593244](http://bugzilla.redhat.com/593244)).

#### Resolved Issues

*   [BZ#785671 after trying to add a snapshot while a snapshot is created and getting an error vm CreateAllSnapshotsFromVmCommand will fail to aquire lock forever](https://bugzilla.redhat.com/785671)
*   Unified VM and VM_TEMPLATE tables in the database.

## Packaging & Installer

The packaging & install subproject deals with the creation of the packages for the oVirt Engine and associated subcomponents. This subproject also delivers the *engine-setup* and *engine-cleanup* utilities. The *engine-setup* utilitiy is used to configure oVirt Engine while the *engine-cleanup* utility is used to remove it.

### Features

*   Support for JBoss AS7 on Fedora 16

### Resolved Issues

*   [BZ#771590 "/var/lock/ovirt-engine" is missing during engine-setup => fail to create CA](https://bugzilla.redhat.com/show_bug.cgi?id=771590)

### Known Issues

*   No upgrade procedure is currently available, to upgrade between releases, both nightlies and stable, it is necessary to run *engine-cleanup* and reinstall oVirt Engine.
*   As JBoss AS7 does not follow symlinks, some files are currently copied in the %post section of the ovirt-engine package.([BZ#782567](https://bugzilla.redhat.com/show_bug.cgi?id=782567))

## Node

The oVirt Node is distributed as a compact image for use on a variety of installation media. It provides a minimal Linux installation including all the packages necessary to register and communicate with the oVirt Engine while functioning as a virtualization host. 

### Features

*   Support for UEFI has been added.
*   Node now successfully registers and functions with oVirt Engine.

### Resolved Issues

*   Automatically log out sessions that are inactive for 15 min
*   validate the iscsi iqn name
*   persist dns entries correctly when adding manually and also using dhcp
*   various spec file cleanup

### Known Issues



## VDSM

The VDSM service is used by a virtualization manager to interface with Linux based virtualization hosts. VDSM manages and monitors the host's storage, memory and networks as well as virtual machine creation, other host administration tasks, statistics gathering, and log collection. This initial oVirt Project release provides and supports vdsm-4.9.3.3.

It is important to use your most up-to-date Fedora, with \`iscsi-initiator-utils-6.2.0.872-16.fc16.x86_64\` or later.

### Features

*   It is now possible to install VDSM on existing Fedora instances, providing an alternative to consuming it as deployed with *ovirt-node*.
*   It is now possible to successfully register VDSM hosts with *ovirt-engine*, instead of just Red Hat Enterprise Virtualization Manager as was previously the case.
*   The mount subsysttem has been refactored, adding support for generic filesystem storage servers (not only NFSv3).
*   A new verb, migrateCancel, has been added.

### Resolved Issues

*   [BZ#754445 Separate granting from callback emitting](http://bugzilla.redhat.com/754445)
*   [BZ#767111 Extend volume size must be in Megabytes](http://bugzilla.redhat.com/767111)
*   [BZ#716573 make \`ulimit -u\` configurable, too](http://bugzilla.redhat.com/716573)
*   [BZ#747917 Don't get information about mountpoints](http://bugzilla.redhat.com/747917)
*   [BZ#736034 Add metadataignore switch to pvcreate.](http://bugzilla.redhat.com/736034)
*   [BZ#769179 Omit getSessionList from vdsClient and its dependent files](http://bugzilla.redhat.com/769179)
*   [BZ#674010 Fix name error in vdsClient - 'commands' not found](http://bugzilla.redhat.com/674010)
*   [BZ#772591 Specify which user/group should be used for core dumps rotation](http://bugzilla.redhat.com/772591)
*   [BZ#772670 network is not set after using boot params](http://bugzilla.redhat.com/772670)
*   [BZ#772556 bootstrap: ignore restorecon errors](http://bugzilla.redhat.com/772556)
*   [BZ#773666 Fix HSM flows should not change rw permissions.](http://bugzilla.redhat.com/773666)
*   [BZ#771686 fix MAX_VLAN_ID](http://bugzilla.redhat.com/771686)
*   [BZ#771329 Use a copy of the domainsToUpgrade](http://bugzilla.redhat.com/771329)
*   [BZ#781317 adjust getos() to print real node type](http://bugzilla.redhat.com/781317)
*   [BZ#781970 kaxmlrpclib: fix plaintext transport in Python 2.7](http://bugzilla.redhat.com/781970)
*   [BZ#782348 Ignore empty lines in ifcfg-\*](http://bugzilla.redhat.com/782348)
*   [BZ#773371 call \`vdsmd reconfigure\` after bootstrap](http://bugzilla.redhat.com/773371)
*   [BZ#785557 bootstrap: do not mark ifcfg as NM_CONTROLLED](http://bugzilla.redhat.com/785557)

## Data Warehouse and Reports

No packaging for the components will be released as part of the inital oVirt Project release.


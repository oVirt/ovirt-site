---
title: OVirt 3.0 release notes
category: documentation
authors: danken, dneary, lpeer, mburns, michael pasternak, oschreib, sandrobonazzola,
  sgordon, yaniv dary
wiki_category: Documentation
wiki_title: OVirt 3.0 release notes
wiki_revision_count: 46
wiki_last_updated: 2015-01-16
---

# OVirt 3.0 release notes

The oVirt Project is pleased to announce the availability of its first formal release, oVirt 3.0.

## Software Development Kit

The oVirt Engine Software Development Kit provides an enhanced Python environment to support the developement of custom software utilizing the APIs exposed by the engine.

### Features

This is the initial formal release of the oVirt Engine SDK.

### Resolved Issues

*   Thu Jan 19 2012 Michael Pasternak <mpastern@redhat.com> - 1.2-1

* use direct URI on get(id=x) rather than search pattern - extention for #782707

*   Mon Jan 16 2012 Michael Pasternak <mpastern@redhat.com> - 1.1-1

* add connectivity check and disconnect methods for #781820

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=781820`](https://bugzilla.redhat.com/show_bug.cgi?id=781820)

### Known Issues

Only one instance of proxy to API can be created in application

## CLI

TBD

### Features

### Resolved Issues

*   Thu Jan 19 2012 Michael Pasternak <mpastern@redhat.com> - 1.2-1

* unable to add host #782734

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=782734`](https://bugzilla.redhat.com/show_bug.cgi?id=782734)

* unable to add new cluster #782707

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=782707`](https://bugzilla.redhat.com/show_bug.cgi?id=782707)

*   Mon Jan 16 2012 Michael Pasternak <mpastern@redhat.com> - 1.1-1

* unable to create data-center: problem with --version param #781834

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=781834`](https://bugzilla.redhat.com/show_bug.cgi?id=781834)

* authentication show as succeeded with bad password (text only) #781820

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=781820`](https://bugzilla.redhat.com/show_bug.cgi?id=781820)

### Known Issues

yet not supported:

*   history
*   auto completion

## Engine

TBD

#### Features

*   The engine is now running on Jboss AS7 as the application server
*   [ Locking mechanism ](Features/DetailedLockMechanism)
*   [ SPM Priority ](Features/SPMPriority)
*   Adding maintenance Storage Domain Status [BZ 593244](http://bugzilla.redhat.com/593244)

#### Resolved Issues

*   [BZ 766287](http://bugzilla.redhat.com/766287)

#### Known Issues

#### Code Changes

*   Unifying VM and VM_TEMPLATE tables in the Data Base.

## DWH

No packaging will not be released as part of this build.

## Packaging & Installer

### Features

*   Support for JBoss AS7 on Fedora16

### Resolved Issues

*   Missing /var/lock/ovirt-engine after reboot [BZ#771590](https://bugzilla.redhat.com/show_bug.cgi?id=771590)

### Known Issues

*   No upgrade proccess available yet.
*   Since JBoss AS7 doesn't support symlinks, we copy some files during ovirt-engine rpm %post section.([BZ#782567](https://bugzilla.redhat.com/show_bug.cgi?id=782567))

## Node

Please see the [Node_Release_Notes](Node_Release_Notes)

### Features

*   UEFI Support added
*   Works with ovirt-engine

### Resolved Issues

*   Automatically log out sessions that are inactive for 15 min
*   validate the iscsi iqn name
*   persist dns entries correctly when adding manually and also using dhcp
*   various spec file cleanup

### Known Issues

*   [Node_Backlog](Node_Backlog)

## Reports

No packaging will not be released as part of this build.

## VDSM

vdsm-4.9.3.1

### Features (since v4.9.2)

*   Vdsm installs over Fedora
*   Vdsm registers with upstream ovirt-engine, instead of just RHEV-M.
*   Refactored mount subsystem and support for generic filesystem storage server (not only NFSv3)
*   new verb: migration cancel

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

### Known Issues

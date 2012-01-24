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

The oVirt Project is pleased to announce the availability of its first formal release, oVirt x.y.

## API

TBD

### Features

### Resolved Issues

### Known Issues

## SDK

TBD

### Features

### Resolved Issues

### Known Issues

Only one instance of proxy to API can be created in application

## CLI

TBD

### Features

### Resolved Issues

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
*   [ Quota ](Features/DetailedQuota)
*   Support new Storage Domain Status

#### Resolved Issues

*   [BZ 766287](http://bugzilla.redhat.com/766287)

#### Known Issues

#### Code Changes

*   Unifying VM and VM_TEMPLATE tables in the Data Base.

## Guest Agent

TBD

### Features

### Resolved Issues

### Known Issues

## DWH

TBD

### Features

### Resolved Issues

### Known Issues

## Packaging & Installer

TBD

### Features

### Resolved Issues

### Known Issues

## Node

TBD

### Features

### Resolved Issues

### Known Issues

## Reports

TBD

### Features

### Resolved Issues

### Known Issues

## Tools

TBD

### Features

### Resolved Issues

### Known Issues

## User Portal

TBD

### Features

### Resolved Issues

### Known Issues

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

## Web Administration Portal

TBD

### Features

### Resolved Issues

### Known Issues

---
title: PosixFSConnection
category: feature
authors: abaron, derez, ecohen, ekohl, sandrobonazzola, smizrahi, yair zaslavsky
wiki_category: Feature|PosixFSConnection
wiki_title: Features/PosixFSConnection
wiki_revision_count: 18
wiki_last_updated: 2015-01-16
---

# Posix FS Connection

Also known as SharedFS support

## Summery

Will allow VDSM to use any mountable target a a domain.

## Current Status

Done:

*   Make needed changes in VDSM (http://gerrit.ovirt.org/559)

To do:

*   Make needed change in Ovirt-Engine
*   Make needed change in the GUIs

## Description

Currently VDSM only supports using NFS as a remote domain target. This feature will allow VDSM to use any mountable target that adheres to posix file semantics to be used in VDSM as a domain.

This will not replace specialized support but rather compliment. The underlying implementation will only adhere to posix semantics and will ignore quirks and hacks needed by any random target. This is why it is highly recommended to use a the specialized domain types when available.

## Dependency

None

## Related Features

[Features/ConnectionMonitoring](Features/ConnectionMonitoring)

## Affected Functionality

*   storage domain creation\\connection\\removal - It is now possible to specify a new connection type

## User Experience

User should be able to witness the wonders of this new functionality

## Upgrade

Just works!

## How to use

For the classic connection API send a connection dictionary that looks like this:

      {'id': 3,
       'spec': 'mountspec', // eg. host:/export
       'vfs_type': 'vfsType', // eg. nfs/smb
       'mnt_options': 'option string'} // eg. defaults,noatime,vers=4

## User work flows

User will be able to connect to said target and enter specialized parameters.

Here are some ugly GUI Mockups:
![](posixfscondialogmockup.png "fig:posixfscondialogmockup.png")

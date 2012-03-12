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

## Summary

This feature will allow to define a DC of a customizable type. The storage domains in this DC will be mounted with custom properties and will support file system based storage domains which do not necessarily rely on NFS.

## Current Status

To do:

*   Make needed change in Ovirt-Engine
*   Make needed change in the GUIs

Done:

*   Make needed changes in VDSM (http://gerrit.ovirt.org/559)

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

The new connection type is named "posixfs" and its TypeID is 6. The connection specific arguments are:

*   **spec** - *Mandatory*, *string*, This field describes the block special device or remote filesystem to be mounted. For ordinary mounts it will hold (a link to) a block special device node (as created by mknod(8)) for the device to be mounted, like \`/dev/cdrom' or \`/dev/sdb7'. For NFS mounts one will have <host>:
    <dir>
    , e.g., \`knuth.aeb.nl:/'.

*   **vfsType** - *Mandatory*, *string*, This field describes the type of the filesystem. Linux supports lots of filesystem types, such as adfs, affs, autofs, coda, coherent, cramfs, devpts, efs, ext2, ext3, hfs, hpfs, iso9660, jfs, minix, msdos, ncpfs, nfs, ntfs, proc, qnx4, reiserfs, romfs, smbfs, sysv, tmpfs, udf, ufs, umsdos, vfat, xenix, xfs, and possibly others.
*   **options** - *Optional*, *string*, This field describes the mount options associated with the filesystem. It is formatted as a comma separated list of options. It contains at least the type of mount plus any additional options appropriate to the filesystem type.

For complete documentation you could look at \`man fstab\`

When creating a domain pass the posixfs type id to create a posixfs domain.

## User work flows

User will be able to connect to said target and enter specialized parameters.

Here are some ugly GUI Mockups:
![](posixfscondialogmockup.png "fig:posixfscondialogmockup.png")

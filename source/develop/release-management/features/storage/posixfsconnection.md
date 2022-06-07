---
title: PosixFSConnection
category: feature
authors:
  - abaron
  - derez
  - ecohen
  - ekohl
  - sandrobonazzola
  - smizrahi
  - yair zaslavsky
---

Also known as SharedFS support

# PosixFS Connection

# Summary

This feature will allow to define a DC of a customizable type.
The storage domains in this DC will be mounted with custom properties and will support file system based storage domains which do not necessarily rely on NFS.

# Current Status

To do:

*   Make needed change in Ovirt-Engine
*   Make needed change in the GUIs

Done:

*   Make needed changes in VDSM (<http://gerrit.ovirt.org/559>)

# Description

Currently VDSM only supports using NFS as a remote domain target. This feature will allow VDSM to use any mountable target that adheres to posix file semantics to be used in VDSM as a domain.

This will not replace specialized support but rather compliment. The underlying implementation will only adhere to posix semantics and will ignore quirks and hacks needed by any random target. This is why it is highly recommended to use a the specialized domain types when available.

# Dependency

None

# Related Features

Features/ConnectionMonitoring

# Affected Functionality

*   storage domain creation\\connection\\removal - It is now possible to specify a new connection type

# User Experience

User should be able to witness the wonders of this new functionality

# Upgrade

Just works!

# How to use

The new connection type is named "posixfs" and its TypeID is 6.
The connection specific arguments are:

*   `spec`- *Mandatory*, *string*, This field describes the block special device or remote filesystem to be mounted. For ordinary mounts it will hold (a link to) a block special device node (as created by mknod(8)) for the device to be mounted, like `/dev/cdrom` or `/dev/sdb7`. For NFS mounts one will have `<host>:<dir>`, e.g., `knuth.aeb.nl:/`.

*   `vfsType` - *Mandatory*, *string*, This field describes the type of the filesystem. Linux supports lots of filesystem types, such as adfs, affs, autofs, coda, coherent, cramfs, devpts, efs, ext2, ext3, hfs, hpfs, iso9660, jfs, minix, msdos, ncpfs, nfs, ntfs, proc, qnx4, reiserfs, romfs, smbfs, sysv, tmpfs, udf, ufs, umsdos, vfat, xenix, xfs, and possibly others.
*   `options` - *Optional*, *string*, This field describes the mount options associated with the filesystem. It is formatted as a comma separated list of options. It contains at least the type of mount plus any additional options appropriate to the filesystem type.

For complete documentation you could look at \`man fstab\`

When creating a domain pass the posixfs type id to create a posixfs domain.

# User work flows

User will be able to connect to said target and enter specialized parameters.

# Changes in ovirt engine

This part is for engine-core

*   The connection arguments will be introduced as fields to the storage_server_connection class.
    -   `spec` will be mapped to the existing "connection" field
    -   `vfsType` will be added as a new field of String
    -   `mountOptions` will be added as a new field of String


*   The new fields will be mapped to proper columns at the storage_server_connections, and necessary changes to the Spring-JDBC mapper should be introduced.
*   A new storage type named POSIXFS should be introduced (supported by a new StorageHelper class).
*   As the storage type should be set to 6 (to reflect the domainType) , and this value is already being used by the StorageType.All constant - the value of StorageType.All constant (which is not used by VDSM) should be changed (also for persistent connections, using an upgrade script).
*   ConnectStorageServerVDSCommand.CreateStructFromConnection should be changed in order to add the new fields to the connection, as sent to the Connect VDSM verb (see <http://gerrit.ovirt.org/559>)
*   A new configuration value named "PosixFSSupportEnabled" will be added (boolean value) set to true for version 3.1 and false for the other versions.
*   A validation to check compatibility level is 3.1 and above should be added to the following commands, in case a connection includes POSIX FS information
    -   AddStorageServerConnection
    -   AddStorageDomain


*   A validation check to check compatibility level is 3.1 and above should be added to AddEmptyStoragePool for the case of StorageType.POSIX

# Changes in API

This part is for api.

*   StorageDomain will have the following new attributes:
    -   String VfsType (mandatory only if StorageType is POSIXFS)
    -   String MountOptions (optional)
*   The attribute "Path" will be mapped to storage_server_connections.connection attribute.
*   StorageType will have a new literal value of POSIXFS

# Changes in GUI

![](/images/wiki/Posixfsnewdatacenterdialog.png)
![](/images/wiki/Posixfsnewdomaindialog.png)

[PosixFSConnection](/develop/release-management/features/)
[PosixFSConnection](/develop/release-management/releases/3.3/feature.html)

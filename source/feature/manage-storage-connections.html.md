---
title: Manage Storage Connections
category: feature
authors: abonas, derez, sgotliv
wiki_category: Feature
wiki_title: Features/Manage Storage Connections
wiki_revision_count: 207
wiki_last_updated: 2014-07-13
---

# Manage storage connections

### Summary

This feature adds the ability to add, edit and delete storage connections. This is required in order to support configuration changes including adding paths for multipathing, changes of hardware, and ease failover to remote sites, by quickly switching to work with another storage that holds a backup/sync of the contents of the current storage in case of primary storage failure.

The storage types that are in scope of this feature are: NFS, Posix, local, iSCSI.

The new connection details should be of the same storage type as the original connection. For example, an NFS storage connection cannot be edited to point to iSCSI

### Owner

         Name: Alissa Bonas
`   Email: `<abonas@redhat.com>

### Current Status and tasks

Updated July 30 2013

#### GUI

*   Edit NFS connection properties in webadmin UI - ready <http://gerrit.ovirt.org/#/c/12372/>
*   Edit Posix connection properties in webadmin UI -ready <http://gerrit.ovirt.org/#/c/13640/>
*   Edit local storage connection properties in webadmin UI - ready <http://gerrit.ovirt.org/#/c/15540/>
*   Allow edit connection in unattached status too (in addition to maintenance). not started
*   Edit ISCSI connection properties in webadmin UI (not started)
*   Add "connectivity test" functionality - not started.

#### Server (backend)

*   Allow deleting a connection only when it is not in use by any storage domain/direct lun. (ready) <http://gerrit.ovirt.org/#/c/15269/>
*   Changes in new connection creation flow - Prevent addition of duplicate connections in AddStorageServerConnection command for file domains. (ready) <http://gerrit.ovirt.org/#/c/15388/>
*   Prevent addition of duplicate connections in AddStorageServerConnection and UpdateStorageServerConnection commands. Add logic for block domains, reuse the existing code in both commands. (ready) <http://gerrit.ovirt.org/#/c/16037/>
*   Add lock that locks the connection's id in UpdateStorageServerConnection and RemoveStorageServerConnection. (for cases where no storage domain exists, so the lock of domain's id is irrelevant). (ready) <http://gerrit.ovirt.org/#/c/16009/>
*   Add non empty iqn validation - extend functionality of existing AddStorageServerConnection command to create also iSCSI connections. (Currently a connection for block domains is created via AddSanStorageDomain command directly). (ready) <http://gerrit.ovirt.org/#/c/15516/>
*   Add non empty port validation - extend functionality of existing AddStorageServerConnection command to create also iSCSI connections. (not started)
*   Extend functionality of existing UpdateStorageServerConnection command to update iSCSI connections. Check connection validity to target (needs check with lun replication), VG properties - whether they are correct, if there are domains using the connection that they are in maintenance, and if there are lun disks - the vm are in proper state. Add lock that will properly lock connection of block domains for add/edit/remove connection (instead of path that is locked for file domains, need to lock iqn,adress, etc.) . Also lock lun disk/vm/storage domain using the edited connection. Add locking of target in AddStorageServerConnectionCommand as well so edit/add will not interfere each other. (ready) <http://gerrit.ovirt.org/#/c/16203/>
*   Change update connection flow not to fail if there are no domains using the connection . If there are domains using the connection - lock them during the update and update their stats. (ready) <http://gerrit.ovirt.org/#/c/15952/>
*   Add validation of non empty connection field and appropriate error to be used by AddStorageConnection and UpdateStorageConnection commands. (ready) <http://gerrit.ovirt.org/#/c/15560/>
*   Retrieve correct domain status when updating the connection. (abandoned, but fixed in other patch by amureini) <http://gerrit.ovirt.org/#/c/17070/>
*   Create a storage connection validator that will validate that the mandatory fields of each storage type's typical connection are filled correctly. Will be used by AddStorageServerConnection and UpdateStorageServerConnection. Mostly take existing validation code and put it in central place for a better reuse. (not started)
*   Restrict compatibility version of edit storage connections feature in engine to 3.3. ready. <http://gerrit.ovirt.org/#/c/14249/>
*   MLA (permissions) - not started
*   Refactor AddSANStorageDomainCommand so it will not add storage server connection, and rather use existing one (that was either created right before by add connection command, or in the past). This will involve rewriting San domain creation in webadmin (StorageListModel) to call AddStorageServerConnection before AddSANStorageDomainCommand. not started.
*   Support edit for unattached storage domains (not only those in maintenance). not started.
*   Rethink - should the "delete connection" action disconnect from just one host , or all hosts when deleting a connection?
*   For post 3.3 - add ability to "detach" a connection from storage domain without deleting the connection.

#### REST (backend)

*   Create root resource for connections (ready) <http://gerrit.ovirt.org/#/c/16617/>
    -   Perform GET all connections/get a connection by id. In the scope of this patch, create a backend query that will get all connections from db.
    -   Add functionality to root resource for add/delete connection properties in REST
    -   Add functionality to edit a connection
*   Create subresource for connections under domains (api/storagedomains/<domainId>/connections that will retrieve connections (GET). (in review) <http://gerrit.ovirt.org/#/c/17245/>
*   Add functionality to add a file storage domain with a reference to an already existing storage connection (instead of embedded properties of a connection that will be created along with the storage domain). (in review) <http://gerrit.ovirt.org/#/c/17177/>
*   Add ability to remove (delete) a connection without specifying the host. not started
*   Add functionality to add an additional connection to block storage domain - multipathing. no started.
*   post 3.3 - add connections subresource to lun disks - For each lun disk (direct lun) view (GET) its storage connections by approaching it via a specific subresource: /api/disks/<diskId>/connections. not started

#### Blockers

*   Blocking bug in vdsm : <https://bugzilla.redhat.com/show_bug.cgi?id=950055>

# Detailed Description

While in UI and REST storage domain and the storage connection are presented as one united entity to the user, current backend implementation actually manages them separately. In order to allow user to edit the connection details, there's a need to separate the notion of storage domain from its connection details, and allow editing just the connection details without editing the storage domain itself.

A connection may be edited whether there are no storage domains connected to it (an orphan connection), or when there are storage domains using it. The number of the storage domains using a connection can vary based on storage type. For file domains, there will be a 1:1 relation between storage domain and its connection, while for iSCSI, there can be several storage domains using the same target.

If there are storage domains using a connection , it may only be edited when all storage domains referencing it are set to maintenance state. During this update operation, the domains (if such exist) will become locked (status=locked) and then their statistics will be updated based on the new pointed connection's properties (the new storage location). The domains will be unlocked once the update will be completed.

For direct lun (lun disks), in order to edit their storage connection, all VMs using those disks (disks that are plugged) should be powered off. It is the user's responsibility to make sure that after editing the connection the system can indeed reach the data/luns of the relevant storage domains. To ease the administration process, an optional connectivity test may be run to make sure that the storage is indeed accessible. (currently connectivity test is out of scope for 3.3)

Removing a connection is possible only if there are no storage domains nor lun disks using it.

# GUI

Storage domain and connection are managed together in webadmin UI in Storage tab . Till now, storage domain's edit was enabled only for active storage domains and allowed updating only their name and description.

In order to allow editing the connection details, the edit button will now be enabled when storage domain is set in maintenance mode. However, editing the domain name and description will be disabled when in this state as it requires connectivity to the storage. N.B. There will not be an option (in the scope of this feature in 3.3) to edit iSCSI connection details via the webadmin UI.

# REST

### Get existing connection (GET)

1.  All storage connections that exist in the oVirt setup will be accessible in a new root resource: api/storageconnections.
2.  A specific storage connection can be viewed in api/storageconnections/<connectionid>
3.  For each storage domain it should be possible to view (GET) its storage connections by approaching it via a specific subresource: /api/storagedomains/<storageDomainId>/storageconnections.
4.  For each lun disk (direct lun) it should be possible to view (GET) its storage connections by approaching it via a specific subresource: /api/disks/<diskId>/connections. .

Note - connections subresource for lun disks is not in scope for 3.3

<b>Usage example:</b>
Request type - GET
[http://host:port/api/storageconnections](http://host:port/api/storageconnections)

### New connection (POST)

It will be possible to create a new connection without adding a storage domain along with it, and only later reference it from any domain by providing the connection id.
Passing host id/name is optional. Providing it will lead to attempt to connect to the storage via the host.
Not providing host will lead to just persisting storage details in db.

<b>Example</b>
 [http://host:port/api/storageconnections](http://host:port/api/storageconnections)
Request type is POST
Example of request body - NFS

<storageconnection>
`   `<type>`nfs`</type>
         

<address>
multipass.lab.somecompanyname.com

</address>
`   `<path>`/export/storagedata/username/data20`</path>
`   `<host>
`       `<name>`Host111`</name>
`    `</host>
` `</storageconnection>

Example of request body - Posix

` `<storageconnection>
`   `<type>`posixfs`</type>
         

<address>
multipass.lab.somecompanyname.com

</address>
`   `<path>`/export/storagedata/username/dataNewData`</path>
`   `<vfs_type>`nfs`</vfs_type>
` `</storageconnection>

### Delete connection (DELETE)

Deletion of connection will be possible only if no storage domain nor lun disks is referencing it (orphan connection).

<b>Example</b> [http://host:port/api/storageconnections/](http://host:port/api/storageconnections/)<connectionId>
Connection Id is of format GUID, for instance - ffb489f6-b144-4770-84d0-22167024bb5c
Request type is DELETE
A host is required for the deletion process, thus there's a need in request body in deletion request to contain host details.
Example of host element structure in the body (it can contain either host id or name):

<host>
`   `<name>`MyHost`</name>
` `</host>

Example passing host id (in this case - empty):

<host id="00000000-0000-0000-0000-000000000000">
` `</host>

### Update existing connection (PUT)

It will only be possible to update connection details when all storage domains referencing it are in maintenance mode. Most of the connection fields may be updated (such as path/iqn/address/port/user/password) - each storage type has its relevant set of fields.
Host section is optional. Specifying host (vdsm) will lead the host to attempt to connect to the newly specified storage details.
Not specifying host will lead to just update the details in engine db.
Connection ID however, will be immutable.
Example body - changing the address:

<storage>`   `
        

<address>
dhcp-1-120.my.lab.a.com

</address>
`  `<host>
`      `<name>`MyHost`</name>
`   `</host>
</storage>

### Add new file (nfs/posix/local) storage domain with existing storage connection (POST)

[http://host:port/api/storagedomains](http://host:port/api/storagedomains)

<storage_domain>
`  `<name>`mynewdomain`</name>
`  `<type>`data`</type>
` `<storage id="ad3ca1ff-26a6-482e-ac6b-16ee23f12529"/>
`  `<host>
`    `<name>`MyHost`</name>
`  `</host>
</storage_domain>

# Database

This feature doesn't require any database structure change nor upgrade. The below is a description of the existing structure as it is today, and how it will be used in the scope of this feature.

Storage connections are managed today in storage_server_connections table. The edit action will update an existing record in this table. The connection id will remained unchanged, thus the references to the connection will remain correct and will not need a modification.

For NFS/gluster/Posix/local connections a reference to a record in this table is made in storage_domain_static table --> column "storage" holds the connection id.

For iSCSI, the reference to connection id is made via lun_storage_server_connection_map table.

physical_volume_id is the id used by lvm, and since it will be copied by lun replication, it will be the same in the new (backup) lun, so it needs no update in db. lun_id can be the same or change during lun replication (setup dependent) - in the scope of this feature, the lun_id will remain the same cross the source and the target system, thus there is no need to update lun_id in db.

# MLA (permissions)

TBD

# Testing

**Please note the blocking bug in vdsm that prevents editing the path more than once for same storage domain without restarting vdsm between operations:**

[`https://bugzilla.redhat.com/show_bug.cgi?id=950055`](https://bugzilla.redhat.com/show_bug.cgi?id=950055)

1. NFS - edit in webadmin UI:
Preparation: copy the contents of the storage domain manually from the current path to the new (target) path
Scenario:

*   -   maintenance the data domain
    -   right click - edit the storage domain
    -   change the mount path to another storage server
    -   edit NFS advanced options: retransmissions, timeout
    -   activate the domain

2. Posix - edit in webadmin UI:
Preparation: copy the contents of the storage domain manually from the current path to the new (target) path
Scenario:

*   -   maintenance the data domain
    -   right click - edit the storage domain
    -   change the mount path to another storage server
    -   edit mount options
    -   activate the domain

<Category:Feature>

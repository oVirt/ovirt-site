---
title: ConnectionReferences
category: feature
authors: derez, ekohl, sandrobonazzola, smizrahi
wiki_category: Feature|ConnectionReferences
wiki_title: Features/ConnectionReferences
wiki_revision_count: 5
wiki_last_updated: 2015-01-16
---

# Connection References

Also known as New Connection Management API

## Summery

Allow accessing storage server connections indirectly and have VDSM manage actual connections

## Current Status

Under Review:

*   Make needed changes in VDSM (http://gerrit.ovirt.org/#q,status:open+project:vdsm+branch:master+topic:connection_management,n,z)

To do:

*   Make needed change in Ovirt-Engine
*   Make needed change in the GUIs

## Description

Currently VDSM allows client to connect and disconnect from storage directly. This is a problem as multiple clients can "step on each others toes" by disconnecting each others connection.

To solve that you now have the ability to use connection references. Connection references are a way to access a connection if one is available by name.

This also adds persistence to the storage connections and VDSM will remember references across restarts and reboots.

## Dependency

None

## Related Features

None

## Affected Functionality

Storage Server connection

## User Experience

The user shouldn't notice any change

## Upgrade

Just works!

## How to use

You acquire a connection reference by using the storageServer_ConnectionRef_acquire(conRefArgs) conRefArgs - [(refID, connectionInfo),...] refID - is the name by which the referenced will be known and accessed. connectionInfo - is the information with which VDSM will try create a connection

Owning a reference does not guarantee that the connection is active. There might be problems that VDSM can't solve that might prevent VDSM from connection to the target.

In order to check the status of the references use the verb storageServer_ConnectionRef_statuses() It returns a dict in which refIDs are keys and values are:

      {"connected": true\false,
       "lastError": (errcode, msg),
       "connectionInfo": {connectionIfno}
      }

To release the connection reference use storageServer_ConnectionRef_release(refID)

## User work flows

Should not affect user work flows

---
title: ConnectionReferences
category: feature
authors: derez, ekohl, sandrobonazzola, smizrahi
wiki_category: Feature|ConnectionReferences
wiki_title: Features/ConnectionReferences
wiki_revision_count: 5
wiki_last_updated: 2015-01-16
feature_name: Connection References
feature_modules: vdsm
feature_status: Released
---

Also known as New Connection Management API

# Connection References

# Summary

Allow accessing storage server connections indirectly and have VDSM manage actual connections

# Current Status

Under Review:

*   Make needed changes in VDSM (http://gerrit.ovirt.org/#q,status:open+project:vdsm+branch:master+topic:connection_management,n,z)

To do:

*   Make needed change in Ovirt-Engine
*   Make needed change in the GUIs

# Description

Currently VDSM allows client to connect and disconnect from storage directly. This is a problem as multiple clients can "step on each others toes" by disconnecting each others connection.

To solve that you now have the ability to use connection references. Connection references are a way to access a connection if one is available by name.

This also adds persistence to the storage connections and VDSM will remember references across restarts and reboots.

# Dependency

None

# Related Features

None

# Affected Functionality

Storage Server connection

# User Experience

The user shouldn't notice any change

# Upgrade

Just works!

# How to use

Connection Information is a structure in the form of

      ConnectionInfo = {'type'  : string
                        'params': map}

Each type has values that it expects to appear uner the params map:

*   iSCSI - Iscsi is a bit complex as it is composed of many structures

      IscsiPortal = {'hostname': string, # Can either be a hostname or an IP, I recommend using IP for anything other then send target discovery
                     'port': integer # Optional, will use default iscsi portal if missing
                    }
      IscsiTarget = {'portal' : IscsiPortal,
                     'tpgt'   : integer # Optional, Target Portal Group Tag, currently ignored and should be omitted from requests until supported
                     'iqn'    : string }
      ConnectionInfo = {'type'   : 'iscsi',
                        'params' : {
                                'target' : IscsiTarget
                                'iface'  : string # Optional, Name of a registered iscsi interface. 'default' will use the default iscsi interface 'iser' will use iser.
                                 'credentials : CredentialsInfo # Optional
                                 }
                       }

*   NFS

      ConnectionInfo = {'type' : 'nfs',
                        'params': {
                                'export'  : string # full export path eg. server:/path
                                'retrans' : integer # Optional, should be omitted apart from special cases. Defaults might change in VDSM.
                                'timeout' : integer # Optional, should be omitted apart from special cases. Defaults might change in VDSM.
                                'version' : integer # Optional, should be omitted apart from special cases. Will use NFS protocol for version negotiations.
                         }
                        }

*   localfs

      ConnectionInfo = {'type' : 'localfs',
                        'params': {
                                'path'  : string # absolute path to the directory to use as a domain
                         }
                        }

*   posixfs

      ConnectionInfo = {'type' : 'posixfs',
                        'params': {
                                'spec'     : string
                                'vfsType'  : string
                                'options'  : string # Optional, should be sent by user, local defaults will be used if unspecified.
                         }
                        }

You acquire a connection reference by using the storageServer_ConnectionRefs_acquire verb:

         def storageServer_ConnectionRefs_acquire(self, conRefArgs):
             """
             Acquire connection references.
             The method will persist the connection info in VDSM and create a
             connection reference. Connection references can be accessed by their
             IDs where appropriate.
             Once a connection reference is created VDSM will try and connect to the
             target specified by the connection information if not already
             connected. VDSM will keep the target connected as long as a there is a
             reference pointing to the same connection information.
             :param conRefArgs: A map in the form of
             {id: :class:: storageServer.ConnectionInfo), ... }
             :rtype: dict {id: errcode, ...}
             """

In order to check the status of the references use the verb storageServer_ConnectionRefs_statuses verb:

         def storageServer_ConnectionRefs_statuses(self):
             """
             Gets a list of all managed and active unmanaged storage connections and
             their current status.
             :rtype: a dict in the format of
                {id: {'connected': True/False,
                      'lastError': (errcode, message),
                      'connectionInfo': :class:: storageServer.ConnectionInfo}
             """

To release the connection reference use storageServer_ConnectionRefs_release verb:

         def storageServer_ConnectionRefs_release(self, refIDs):
             """
             Release connection references.
             Releases the references, if a connection becomes orphaned as a result
             of this action the connection will be disconnted. The connection might
             remain active if VDSM detects that it is still under use but will not
             be kept alive by VDSM anymore.
             :param refIDs: a list of strings, each string representing a refIDs.
             :rtype: dict {id: errcode, ...}
             """

# User work flows

Should not affect user work flows

[ConnectionReferences](Category:Feature) [ConnectionReferences](Category:oVirt 3.2 Feature)

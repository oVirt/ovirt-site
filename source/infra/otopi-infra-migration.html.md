---
title: Otopi Infra Migration
category: infra
authors: alonbl, alourie, sandrobonazzola
wiki_category: Feature
wiki_title: Features/Otopi Infra Migration
wiki_revision_count: 101
wiki_last_updated: 2013-07-19
---

# Otopi Infra Migration

### Summary

A complete re-write of engine-setup, engine-cleanup, engine-upgrade and AIO plugin using otopi.

### Owner

*   Name: [Alon Bar-Lev](User:Alonbl)
*   Email: <alonbl@redhat.com>

<!-- -->

*   Name: [ Alex Lourie](User:Alourie)
*   Email: <alourie@redhat.com>

<!-- -->

*   Name: [ Sandro Bonazzola](User:SandroBonazzola)
*   Email: <sbonazzo@redhat.com>

### Current status

*   Last updated: ,

| Feature                                                               | existing implementation | otopi implementation |
|-----------------------------------------------------------------------|-------------------------|----------------------|
| Set Max Shared Memory                                                 | Done                    | Done                 |
| Check for supported Java VM                                           | Done                    | Done                 |
| CA Generation                                                         | Done                    | Done                 |
| Extract CA fingerprint                                                | Done                    | Done                 |
| Extract non password key for log collector                            | Done                    | Done                 |
| Extract non password key for Apache                                   | Done                    | Done                 |
| Extract SSH fingerprint                                               | Done                    | Done                 |
| Configure engine service - database                                   | Done                    | Done                 |
| Configure engine service - Java                                       | Done                    | Done                 |
| Configure engine service - Protocols                                  | Done                    | Done                 |
| Configure .pgpass file                                                | Done                    | Done                 |
| Encrypt DB Password                                                   | Done                    | Done                 |
| Push the encrypted password into the local configuration file         | Done                    | Done                 |
| Start / Stop rhevm-etl service when needed                            | Done                    | Not implemented      |
| Start / Stop rhevm-notifierd service when needed                      | Done                    | Not implemented      |
| Upgrade engine database if already exist                              | Done                    | Done                 |
| Install engine database if doesn't exist                              | Done                    | Done                 |
| Set Application Mode (Both, Virt, Gluster)                            | Done                    | Done                 |
| Update VDC Options                                                    | Done                    | Done                 |
| Update default data center storage type                               | Done                    | Not implemented      |
| Configure engine-log-collector                                        | Done                    | Not implemented      |
| Configure engine-iso-uploader                                         | Done                    | Not implemented      |
| Configure engine-image-uploader                                       | Done                    | Not implemented      |
| Configure PostgreSQL max_connections if using local DB               | Done                    | Not implemented      |
| Configure NFS exports for ISO Domain if requested                     | Done                    | Not implemented      |
| Allow importing existing NFS ISO Domain                               | Done                    | Not implemented      |
| Create new NFS ISO Domain                                             | Done                    | Not implemented      |
| Migrate existing NFS ISO exports from /etc/exports to /etc/exports.d/ | Done                    | Not implemented      |
| Set selinux context for NFS ISO mount points                          | Done                    | Not implemented      |
| set NFS/portmap ports by overriding /etc/sysconfig/nfs                | Done                    | Not implemented      |
| Enable the rpcbind and nfs services                                   | Done                    | Not implemented      |
| Load files (iso,vfd) from existing rpms to ISO domain                 | Done                    | Not implemented      |
|                                                                       |                         |                      |

### Detailed Description

TBD

### Benefit to oVirt

*   Lower cost of maintenance.
*   Use of otopi API.
*   More ...

### Dependencies / Related Features

TBD

### Documentation / External references

*   [Ovirt Host Deploy Presentation](:File:ovirt-host-deploy 3.2.pdf)
*   [Bug 911191 - Migrate ovirt-engine-setup and AIO plugin to otopi](https://bugzilla.redhat.com/show_bug.cgi?id=911191)

### Comments and Discussion

*   Refer to <Talk:Features/Otopi_Infra_Migration>

<Category:Feature> <Category:Template>

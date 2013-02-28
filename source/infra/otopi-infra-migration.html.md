---
title: Otopi Infra Migration
category: infra
authors: alonbl, alourie, sandrobonazzola
wiki_category: Feature
wiki_title: Features/Otopi Infra Migration
wiki_revision_count: 101
wiki_last_updated: 2013-07-19
wiki_warnings: references, table-style
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

#### engine-setup

| Feature                                                                | Existing implementation | Otopi implementation | Owner                                                |
|------------------------------------------------------------------------|-------------------------|----------------------|------------------------------------------------------|
| Verify that root is the user executing the script                      | Done                    | Done                 |                                                      |
| Allow unprivileged user ro run a development installation              | Not implemented         | Done                 |                                                      |
| Checking total memory                                                  | Done                    | Feedback [1]         | [ Sandro Bonazzola](User:SandroBonazzola) |
| Generate answer file                                                   | Done                    | Done[2]              |                                                      |
| Allow logging                                                          | Done                    | Done                 |                                                      |
| Support AIO plugin                                                     | Done                    | Not implemented      |                                                      |
| Support FIREWALL_MANAGER option                                       | Done                    | Not implemented      |                                                      |
| Support OVERRIDE_HTTPD_CONFIG option                                 | Done                    | Not implemented      |                                                      |
| Support HTTP_PORT option                                              | Done                    | Not implemented      |                                                      |
| Support HTTPS_PORT option                                             | Done                    | Not implemented      |                                                      |
| Support RANDOM_PASSWORDS option                                       | Done                    | Not implemented      |                                                      |
| Overriding given passwords with random                                 | Done                    | Not implemented      |                                                      |
| Support MAC_RANGE option                                              | Done                    | Not implemented      |                                                      |
| Support HOST_FQDN option                                              | Done                    | Not implemented      |                                                      |
| Support AUTH_PASS option                                              | Done                    | Not implemented      |                                                      |
| Support ORG_NAME option                                               | Done                    | Not implemented      |                                                      |
| Support APPLICATION_MODE option                                       | Done                    | Not implemented      |                                                      |
| Support DC_TYPE option                                                | Done                    | Not implemented      |                                                      |
| Support DB_REMOTE_INSTALL option                                     | Done                    | Not implemented      |                                                      |
| Support DB_LOCAL_PASS option                                         | Done                    | Not implemented      |                                                      |
| Support DB_HOST option                                                | Done                    | Not implemented      |                                                      |
| Support DB_PORT option                                                | Done                    | Not implemented      |                                                      |
| Support DB_ADMIN option                                               | Done                    | Not implemented      |                                                      |
| Support DB_REMOTE_PASS option                                        | Done                    | Not implemented      |                                                      |
| Support DB_SECURE_CONNECTION option                                  | Done                    | Not implemented      |                                                      |
| Support NFS_MP option                                                 | Done                    | Not implemented      |                                                      |
| Support ISO_DOMAIN_NAME option                                       | Done                    | Not implemented      |                                                      |
| Support CONFIG_NFS option                                             | Done                    | Not implemented      |                                                      |
| Display summary in interactive mode                                    | Done                    | Not implemented      |                                                      |
| Initialize MiniYum                                                     | Done                    | Not implemented      |                                                      |
| Handle second execution warning                                        | Done                    | Not implemented      |                                                      |
| Handle loading and validating params from answer file                  | Done                    | Done[3]              |                                                      |
| Mask input sets                                                        | Done                    | Not implemented      |                                                      |
| Log masked configuration                                               | Done                    | Not implemented      |                                                      |
| Set Max Shared Memory                                                  | Done                    | Done                 |                                                      |
| Check for supported Java VM                                            | Done                    | Done                 |                                                      |
| CA Generation                                                          | Done                    | Done                 |                                                      |
| Extract CA fingerprint                                                 | Done                    | Done                 |                                                      |
| Extract non password key for log collector                             | Done                    | Done                 |
| Extract non password key for Apache                                    | Done                    | Done                 |                                                      |
| Extract SSH fingerprint                                                | Done                    | Done                 |                                                      |
| Configure engine service - database                                    | Done                    | Done                 |                                                      |
| Configure engine service - Java                                        | Done                    | Done                 |                                                      |
| Configure engine service - Protocols                                   | Done                    | Done                 |                                                      |
| Configure .pgpass file                                                 | Done                    | Done                 |                                                      |
| Encrypt DB Password                                                    | Done                    | Done                 |                                                      |
| Push the encrypted password into the local configuration file          | Done                    | Done                 |                                                      |
| Start / Stop rhevm-etl service when needed                             | Done                    | Not implemented      |                                                      |
| Start / Stop rhevm-notifierd service when needed                       | Done                    | Not implemented      |                                                      |
| Upgrade engine database if already exist                               | Done                    | Done                 |                                                      |
| Install engine database if doesn't exist                               | Done                    | Done                 |                                                      |
| Set Application Mode (Both, Virt, Gluster)                             | Done                    | Done                 |                                                      |
| Update VDC Options                                                     | Done                    | Done                 |                                                      |
| Update default data center storage type                                | Done                    | Not implemented      |                                                      |
| Configure engine-log-collector                                         | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) |
| Configure engine-iso-uploader                                          | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) |
| Configure engine-image-uploader                                        | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) |
| Configure PostgreSQL max_connections if using local DB                | Done                    | Not implemented      |                                                      |
| Configure NFS exports for ISO Domain if requested                      | Done                    | Not implemented      |                                                      |
| Allow importing existing NFS ISO Domain                                | Done                    | Not implemented      |                                                      |
| Create new NFS ISO Domain                                              | Done                    | Not implemented      |                                                      |
| Migrate existing NFS ISO exports from /etc/exports to /etc/exports.d/  | Done                    | Not implemented      |                                                      |
| Set selinux context for NFS ISO mount points                           | Done                    | Not implemented      |                                                      |
| set NFS/portmap ports by overriding /etc/sysconfig/nfs                 | Done                    | Not implemented      | [ Sandro Bonazzola](User:SandroBonazzola) |
| Enable the rpcbind and nfs services                                    | Done                    | Not implemented      |                                                      |
| Load files (iso,vfd) from existing rpms to ISO domain                  | Done                    | Not implemented      |                                                      |
| Check firewall managers installed in the system                        | Done                    | Not implemented      |                                                      |
| Configure and enable iptables if requested                             | Done                    | Not implemented      |                                                      |
| Configure and enable FirewallD if requested                            | Done                    | Not implemented      |                                                      |
| Start / Stop Engine service when needed                                | Done                    | Done                 |                                                      |
| Enable httpd_can_network_connect selinux flag                       | Done                    | Not implemented      |                                                      |
| Backup old Apache httpd config when needed                             | Done                    | Not implemented      |                                                      |
| Configure Apache mod_ssl for using engine apache keys                 | Done                    | Not implemented      |                                                      |
| Configure Apache for listening on requested HTTP port                  | Done                    | Not implemented      |                                                      |
| Configure Apache for listening on requested HTTPS port                 | Done                    | Not implemented      |                                                      |
| Configure Apache as proxy for the requests to the jboss service        | Done                    | Not implemented      |                                                      |
| Enable the httpd service                                               | Done                    | Not implemented      |                                                      |
| Enter rpm versions into yum version-lock                               | Done                    | Not implemented      |                                                      |
| Add info message to the user finalizing the successful install         | Done                    | Not implemented      |                                                      |
| Print additional message to the user finalizing the successful install | Done                    | Not implemented      |                                                      |
| Log a summary of the parameters                                        | Done                    | Not implemented      |                                                      |

<references>
[4] [5] [6]

</references>
#### engine-cleanup

| Feature                                                        | Existing implementation | Otopi implementation | Owner |
|----------------------------------------------------------------|-------------------------|----------------------|-------|
| Verify that root is the user executing the script              | Done                    | Not implemented      |       |
| Allow unprivileged user ro run a development cleanup           | Not implemented         | Not implemented      |       |
| Support unattended-clean option                                | Done                    | Not implemented      |       |
| Support dont-drop-db option                                    | Done                    | Not implemented      |       |
| Support dont-remove-ca option                                  | Done                    | Not implemented      |       |
| Support remove-nfs-exports option                              | Done                    | Not implemented      |       |
| Support remove-exported-content option                         | Done                    | Not implemented      |       |
| Change working dir to the root directory                       | Done                    | Not implemented      |       |
| Allow logging                                                  | Done                    | Not implemented      |       |
| Ask user to proceed with cleanup in interactive mode           | Done                    | Not implemented      |       |
| Stop Engine service when needed                                | Done                    | Not implemented      |       |
| Backup engine database if drop requested                       | Done                    | Not implemented      |       |
| Drop engine database if requested                              | Done                    | Not implemented      |       |
| Clean pgpass if drop requested                                 | Done                    | Not implemented      |       |
| Clean sysctl configuration                                     | Done                    | Not implemented      |       |
| Backup CA if remove requested                                  | Done                    | Not implemented      |       |
| Remove CA if requested                                         | Done                    | Not implemented      |       |
| Stop engine-notifierd when needed                              | Done                    | Not implemented      |       |
| Clean ISO domain NFS exports if requested                      | Done                    | Not implemented      |       |
| Clean ISO domain exported directories if requested             | Done                    | Not implemented      |       |
| Add info message to the user finalizing the successful cleanup | Done                    | Not implemented      |       |
| Add info message on where the logs are located                 | Done                    | Not implemented      |       |

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

<Category:Feature>

[1] 

[2] 

[3] 

[4] The option `--no-mem-check` is now `--otopi-environment="OVESETUP_SYSTEM/memCheck=bool:False"`

[5] The option `--gen-answer-file` is now `--generate-answer`

[6] The option `--answer-file` is now `--config-append`

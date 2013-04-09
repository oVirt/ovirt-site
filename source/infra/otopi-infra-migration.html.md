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

| Feature                                                                | Existing implementation | Otopi implementation | Owner                                                | Priority | Target date |
|------------------------------------------------------------------------|-------------------------|----------------------|------------------------------------------------------|----------|-------------|
| Verify that root is the user executing the script                      | Done                    | Done                 |                                                      |          |             |
| Allow unprivileged user ro run a development installation              | Not implemented         | Done                 |                                                      |          |             |
| Checking total memory                                                  | Done                    | Done [1]             | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Generate answer file                                                   | Done                    | Done[2]              |                                                      |          |             |
| Allow logging                                                          | Done                    | Done                 |                                                      |          |             |
| Support AIO plugin                                                     | Done                    | In Progress          | [ Sandro Bonazzola](User:SandroBonazzola) | Medium   |             |
| Support FIREWALL_MANAGER option                                       | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) | High     |             |
| Support OVERRIDE_HTTPD_CONFIG option                                 | Done                    | Not required[3]      |                                                      |          |             |
| Support HTTP_PORT option                                              | Done                    | Done[4]              |                                                      |          |             |
| Support HTTPS_PORT option                                             | Done                    | Done[5]              |                                                      |          |             |
| Support RANDOM_PASSWORDS option                                       | Done                    | Not required[6]      |                                                      | Medium   |             |
| Overriding given passwords with random                                 | Done                    | Not required[7]      |                                                      | Medium   |             |
| Support MAC_RANGE option                                              | Done                    | Feedback             | [ Alex Lourie](User:AlexLourie)           | Medium   |             |
| Support HOST_FQDN option                                              | Done                    | Done[8]              |                                                      |          |             |
| Support AUTH_PASS option                                              | Done                    | Done[9]              |                                                      |          |             |
| Support ORG_NAME option                                               | Done                    | Done[10]             |                                                      |          |             |
| Support APPLICATION_MODE option                                       | Done                    | Done[11]             |                                                      |          |             |
| Support DC_TYPE option                                                | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) | Medium   |             |
| Support DB_REMOTE_INSTALL option                                     | Done                    | In Progress          |                                                      | Medium   |             |
| Support DB_LOCAL_PASS option                                         | Done                    | In Progress          |                                                      | Low      |             |
| Support DB_HOST option                                                | Done                    | Done[12]             |                                                      |          |             |
| Support DB_PORT option                                                | Done                    | Done[13]             |                                                      |          |             |
| Support DB_ADMIN option                                               | Done                    | Done                 |                                                      |          |             |
| Support DB_REMOTE_PASS option                                        | Done                    | Done                 |                                                      |          |             |
| Support DB_SECURE_CONNECTION option                                  | Done                    | Feedback [14]        |                                                      |          |             |
| Support local DB creation                                              | Done                    | Feedback             | [ Alex Lourie](User:AlexLourie)           |          |             |
| Support NFS_MP option                                                 | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Support ISO_DOMAIN_NAME option                                       | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Support CONFIG_NFS option                                             | Done                    | Done[15]             | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Display summary in interactive mode                                    | Done                    | Not implemented      |                                                      | Low      |             |
| Initialize MiniYum                                                     | Done                    | Not implemented      |                                                      | Medium   |             |
| Handle second execution warning                                        | Done                    | Not required[16]     | [ Sandro Bonazzola](User:SandroBonazzola) | Medium   |             |
| Handle loading and validating params from answer file                  | Done                    | Done[17]             |                                                      |          |             |
| Mask input sets                                                        | Done                    | Not implemented      |                                                      | Low      |             |
| Log masked configuration                                               | Done                    | Not implemented      |                                                      | Low      |             |
| Set Max Shared Memory                                                  | Done                    | Done                 |                                                      |          |             |
| Check for supported Java VM                                            | Done                    | Done                 |                                                      |          |             |
| CA Generation                                                          | Done                    | Done                 |                                                      |          |             |
| Extract CA fingerprint                                                 | Done                    | Done                 |                                                      |          |             |
| Extract non password key for log collector                             | Done                    | Done                 |                                                      |          |             |
| Extract non password key for Apache                                    | Done                    | Done                 |                                                      |          |             |
| Extract SSH fingerprint                                                | Done                    | Done                 |                                                      |          |             |
| Configure engine service - database                                    | Done                    | Done                 |                                                      |          |             |
| Configure engine service - Java                                        | Done                    | Done                 |                                                      |          |             |
| Configure engine service - Protocols                                   | Done                    | Done                 |                                                      |          |             |
| Configure .pgpass file                                                 | Done                    | Done                 |                                                      |          |             |
| Encrypt DB Password                                                    | Done                    | Done                 |                                                      |          |             |
| Push the encrypted password into the local configuration file          | Done                    | Done                 |                                                      |          |             |
| Start / Stop rhevm-etl / ovirt-engine-dwhd service when needed         | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Start / Stop rhevm-notifierd / engine-notifierd service when needed    | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Upgrade engine database if already exist                               | Done                    | Done                 |                                                      |          |             |
| Install engine database if doesn't exist                               | Done                    | Done                 |                                                      |          |             |
| Set Application Mode (Both, Virt, Gluster)                             | Done                    | Done                 |                                                      |          |             |
| Update VDC Options                                                     | Done                    | Done                 |                                                      |          |             |
| Update default data center storage type                                | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) | Medium   |             |
| Configure engine-log-collector                                         | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Configure engine-iso-uploader                                          | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Configure engine-image-uploader                                        | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Configure PostgreSQL max_connections if using local DB                | Done                    | In Progress          | [ Alex Lourie](User:AlexLourie)           | Low      |             |
| Configure NFS exports for ISO Domain if requested                      | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) | Medium   |             |
| Allow importing existing NFS ISO Domain                                | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Create new NFS ISO Domain                                              | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Migrate existing NFS ISO exports from /etc/exports to /etc/exports.d/  | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) | Low      |             |
| Set selinux context for NFS ISO mount points                           | Done                    | In Progress          | [ Sandro Bonazzola](User:SandroBonazzola) | Medium   |             |
| set NFS/portmap ports by overriding /etc/sysconfig/nfs                 | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Enable the rpcbind and nfs services                                    | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Load files (iso,vfd) from existing rpms to ISO domain                  | Done                    | Done                 | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |
| Check firewall managers installed in the system                        | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) | High     |             |
| Configure and enable iptables if requested                             | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) | High     |             |
| Configure and enable FirewallD if requested                            | Done                    | Feedback             | [ Sandro Bonazzola](User:SandroBonazzola) | High     |             |
| Start / Stop Engine service when needed                                | Done                    | Done                 |                                                      |          |             |
| Enable httpd_can_network_connect selinux flag                       | Done                    | Done                 | [ Alex Lourie](User:Alourie)              |          |             |
| Backup old Apache httpd config when needed                             | Done                    | Done                 | [ Alex Lourie](User:Alourie)              |          |             |
| Configure Apache mod_ssl for using engine apache keys                 | Done                    | Done                 | [ Alex Lourie](User:Alourie)              |          |             |
| Configure Apache for listening on requested HTTP port                  | Done                    | Done                 | [ Alex Lourie](User:Alourie)              |          |             |
| Configure Apache for listening on requested HTTPS port                 | Done                    | Done                 | [ Alex Lourie](User:Alourie)              |          |             |
| Configure Apache as proxy for the requests to the jboss service        | Done                    | Feedback             | [ Alex Lourie](User:Alourie)              |          |             |
| Enable the httpd service                                               | Done                    | Done                 | [ Alex Lourie](User:Alourie)              |          |             |
| Enter rpm versions into yum version-lock                               | Done                    | Done                 | [ Alex Lourie](User:Alourie)              |          |             |
| Add info message to the user finalizing the successful install         | Done                    | Not implemented      |                                                      | Low      |             |
| Print additional message to the user finalizing the successful install | Done                    | Not implemented      |                                                      | Low      |             |
| Log a summary of the parameters                                        | Done                    | Not implemented      |                                                      | Low      |             |

<references>
[18] [19] [20] [21] [22] [23] [24] [25] [26] [27] [28] [29] [30] [31]

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

*   Modular implementation, lower cost of maintenance.
*   Use of otopi API.
*   Be able to port engine to other distributions.
*   Be able to install engine at development mode.
*   Be able to customize installation.
*   Share installation of components (reports, dwh).
*   Code reuse of installer code for multiple purposes (host-deploy, enigne-setup).

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

[4] 

[5] 

[6] 

[7] 

[8] 

[9] 

[10] 

[11] 

[12] 

[13] 

[14] 

[15] 

[16] 

[17] 

[18] The option `--no-mem-check` is now `--otopi-environment="OVESETUP_SYSTEM/memCheck=bool:False"`

[19] The option `--gen-answer-file` is now `--generate-answer`

[20] The option `--answer-file` is now `--config-append`

[21] The option `CONFIG_NFS=yes` is now `OVESETUP_SYSTEM/nfsConfigEnabled=bool:True`

[22] The option `HOST_FQDN=host` is now `OVESETUP_CONFIG/fqdn=str:host`

[23] The option `HTTP_PORT=80` is now `OVESETUP_CONFIG/httpPort=int:80`

[24] The option `HTTPS_PORT=443` is now `OVESETUP_CONFIG/httpsPort=int:443`

[25] The option `APPLICATION_MODE=both` is now `OVESETUP_CONFIG/applicationMode=str:both`

[26] The option `ORG_NAME=organization` is now `OVESETUP_PKI/organization=str:organization`

[27] The option `DB_HOST=localhost` is now `OVESETUP_DB/host=str:localhost`

[28] The option `DB_PORT=5432` is now `OVESETUP_DB/port=int:5432`

[29] The option `DB_SECURE_CONNECTION=no` is now `OVESETUP_DB/secured=bool:False`

[30] The option `AUTH_PASS=...` is now `osetupcons.ConfigEnv.ADMIN_PASSWORD`

[31] This means that the function is not required in the new code design

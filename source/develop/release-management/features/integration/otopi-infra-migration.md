---
title: Otopi Infra Migration
category: infra
authors: alonbl, alourie, sandrobonazzola
---

# Otopi Infra Migration

## Summary

A complete re-write of engine-setup, engine-cleanup, engine-upgrade and AIO plugin using otopi.

## Owner

*   Name: Alon Bar-Lev (Alonbl)

*   Name: Alex Lourie (Alourie)
*   Email: <alourie@redhat.com>

*   Name: [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Email: <sbonazzo@redhat.com>

## Current status

*   Last updated: ,

### engine-setup

| Feature                                                                | Existing implementation | Otopi implementation | Owner                                                | Priority | Target date |
|------------------------------------------------------------------------|-------------------------|----------------------|------------------------------------------------------|----------|-------------|
| Verify that root is the user executing the script                      | Done                    | Done                 |                                                      |          |             |
| Allow unprivileged user ro run a development installation              | Not implemented         | Done                 |                                                      |          |             |
| Checking total memory                                                  | Done                    | Done [1]             | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Generate answer file                                                   | Done                    | Done[2]              |                                                      |          |             |
| Allow logging                                                          | Done                    | Done                 |                                                      |          |             |
| Support AIO plugin                                                     | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | Medium   |             |
| Support FIREWALL_MANAGER option                                       | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | High     |             |
| Support OVERRIDE_HTTPD_CONFIG option                                 | Done                    | Not required[3]      |                                                      |          |             |
| Support HTTP_PORT option                                              | Done                    | Done[4]              |                                                      |          |             |
| Support HTTPS_PORT option                                             | Done                    | Done[5]              |                                                      |          |             |
| Support RANDOM_PASSWORDS option                                       | Done                    | Not required[6]      |                                                      | Medium   |             |
| Overriding given passwords with random                                 | Done                    | Not required[7]      |                                                      | Medium   |             |
| Support MAC_RANGE option                                              | Done                    | Done                 | Alex Lourie (AlexLourie)           | Medium   |             |
| Support HOST_FQDN option                                              | Done                    | Done[8]              |                                                      |          |             |
| Support AUTH_PASS option                                              | Done                    | Done[9]              |                                                      |          |             |
| Support ORG_NAME option                                               | Done                    | Done[10]             |                                                      |          |             |
| Support APPLICATION_MODE option                                       | Done                    | Done[11]             |                                                      |          |             |
| Support DC_TYPE option                                                | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | Medium   |             |
| Support DB_REMOTE_INSTALL option                                     | Done                    | Done                 |                                                      | Medium   |             |
| Support DB_LOCAL_PASS option                                         | Done                    | Done                 |                                                      | Low      |             |
| Support DB_HOST option                                                | Done                    | Done[12]             |                                                      |          |             |
| Support DB_PORT option                                                | Done                    | Done[13]             |                                                      |          |             |
| Support DB_ADMIN option                                               | Done                    | Done                 |                                                      |          |             |
| Support DB_REMOTE_PASS option                                        | Done                    | Done                 |                                                      |          |             |
| Support DB_SECURE_CONNECTION option                                  | Done                    | Done [14]            |                                                      |          |             |
| Support local DB creation                                              | Done                    | Done                 | Alex Lourie (AlexLourie)           |          |             |
| Support NFS_MP option                                                 | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Support ISO_DOMAIN_NAME option                                       | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Support CONFIG_NFS option                                             | Done                    | Done[15]             | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Display summary in interactive mode                                    | Done                    | Done                 |                                                      | Low      |             |
| Initialize MiniYum                                                     | Done                    | Done                 |                                                      | Medium   |             |
| Handle second execution warning                                        | Done                    | Not required[16]     | [Sandro Bonazzola](https://github.com/sandrobonazzola) | Medium   |             |
| Handle loading and validating params from answer file                  | Done                    | Done[17]             |                                                      |          |             |
| Mask input sets                                                        | Done                    | Done                 |                                                      | Low      |             |
| Log masked configuration                                               | Done                    | Done                 |                                                      | Low      |             |
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
| Start / Stop rhevm-etl / ovirt-engine-dwhd service when needed         | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Start / Stop rhevm-notifierd / engine-notifierd service when needed    | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Upgrade engine database if already exist                               | Done                    | Done                 |                                                      |          |             |
| Install engine database if doesn't exist                               | Done                    | Done                 |                                                      |          |             |
| Set Application Mode (Both, Virt, Gluster)                             | Done                    | Done                 |                                                      |          |             |
| Update VDC Options                                                     | Done                    | Done                 |                                                      |          |             |
| Update default data center storage type                                | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | Medium   |             |
| Configure engine-log-collector                                         | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Configure engine-iso-uploader                                          | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Configure engine-image-uploader                                        | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Configure PostgreSQL max_connections if using local DB                | Done                    | Done                 | Alex Lourie (AlexLourie)           | Low      |             |
| Configure NFS exports for ISO Domain if requested                      | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | Medium   |             |
| Allow importing existing NFS ISO Domain                                | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Create new NFS ISO Domain                                              | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Migrate existing NFS ISO exports from /etc/exports to /etc/exports.d/  | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | Low      |             |
| Set selinux context for NFS ISO mount points                           | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | Medium   |             |
| set NFS/portmap ports by overriding /etc/sysconfig/nfs                 | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Enable the rpcbind and nfs services                                    | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Load files (iso,vfd) from existing rpms to ISO domain                  | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Check firewall managers installed in the system                        | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | High     |             |
| Configure and enable iptables if requested                             | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | High     |             |
| Configure and enable FirewallD if requested                            | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola) | High     |             |
| Start / Stop Engine service when needed                                | Done                    | Done                 |                                                      |          |             |
| Enable httpd_can_network_connect selinux flag                       | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Backup old Apache httpd config when needed                             | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Configure Apache mod_ssl for using engine apache keys                 | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Configure Apache for listening on requested HTTP port                  | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Configure Apache for listening on requested HTTPS port                 | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Configure Apache as proxy for the requests to the jboss service        | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Enable the httpd service                                               | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Enter rpm versions into yum version-lock                               | Done                    | Done                 | Alex Lourie (Alourie)              |          |             |
| Add info message to the user finalizing the successful install         | Done                    | Done                 |                                                      | Low      |             |
| Print additional message to the user finalizing the successful install | Done                    | Done                 |                                                      | Low      |             |
| Log a summary of the parameters                                        | Done                    | Done                 |                                                      | Low      |             |


[18] [19] [20] [21] [22] [23] [24] [25] [26] [27] [28] [29] [30] [31]


### engine-cleanup

| Feature                                                        | Existing implementation | Otopi implementation | Owner                                                 | Priority | Target date |
|----------------------------------------------------------------|-------------------------|----------------------|-------------------------------------------------------|----------|-------------|
| Verify that root is the user executing the script              | Done                    | Done[32]             | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Allow unprivileged user ro run a development cleanup           | Not implemented         | Done                 |                                                       |          |             |
| Support unattended-clean option                                | Done                    | Done                 |                                                       |          |             |
| Support dont-drop-db option                                    | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Support dont-remove-ca option                                  | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Support remove-nfs-exports option                              | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Support remove-exported-content option                         | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Change working dir to the root directory                       | Done                    | Done                 |                                                       |          |             |
| Allow logging                                                  | Done                    | Done                 |                                                       |          |             |
| Ask user to proceed with cleanup in interactive mode           | Done                    | Done                 |                                                       |          |             |
| Stop Engine service when needed                                | Done                    | Done                 |                                                       |          |             |
| Backup engine database if drop requested                       | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Drop engine database if requested                              | Done                    | Done[33]             |                                                       |          |             |
| Clean pgpass if drop requested                                 | Done                    | Done                 |                                                       |          |             |
| Clean sysctl configuration                                     | Done                    | Done                 |                                                       |          |             |
| Backup CA if remove requested                                  | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Remove CA if requested                                         | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Stop engine-notifierd when needed                              | Done                    | Done                 | [Sandro Bonazzola](https://github.com/sandrobonazzola)  |          |             |
| Clean ISO domain NFS exports if requested                      | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Clean ISO domain exported directories if requested             | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Add info message to the user finalizing the successful cleanup | Done                    | Done                 | |[Sandro Bonazzola](https://github.com/sandrobonazzola) |          |             |
| Add info message on where the logs are located                 | Done                    | Done                 |                                                       |          |             |


[34] <ref name="dbdrop">database is not dropped but all objects within are dropped, should be revisit when [bug#951923](https://bugzilla.redhat.com/show_bug.cgi?id=951923) is resolved.


## Detailed Description

TBD

## Benefit to oVirt

*   Modular implementation, lower cost of maintenance.
*   Use of otopi API.
*   Be able to port engine to other distributions.
*   Be able to install engine at development mode.
*   Be able to customize installation.
*   Share installation of components (reports, dwh).
*   Code reuse of installer code for multiple purposes (host-deploy, enigne-setup).

## Dependencies / Related Features

TBD

## Documentation / External references

*   [Ovirt Host Deploy Presentation](http://resources.ovirt.org/old-site-files/wiki/Ovirt-host-deploy_3.2.pdf)
*   [Bug 911191 - Migrate ovirt-engine-setup and AIO plugin to otopi](https://bugzilla.redhat.com/show_bug.cgi?id=911191)



## Basic Testing

### Test case: setup

      Run engine-setup-2 on a clean system
       check that the procedure ends successfully
       check that the portal is reachable
       check that the engine is running as it was installed using legacy setup

### Test case: setup with AIO plugin

      On a clean system install AIO plugin and run engine-setup-2 
       check that the procedure ends successfully
       check that the portal is reachable
       check that the engine is running as it was installed using legacy setup with AIO plugin

### Test case: cleanup

      Run engine-cleanup-2 on a system installed using engine-setup-2
       check that the items you confirmed to be removed will be really removed from the system

### Test case: upgrade from previous version

      Install stable version on a supported OS (Fedora 19 is not supported by 3.2)
      Upgrade ovirt-engine-setup to 3.3.0
      Run engine-setup-2
       check that the package are upgraded to 3.3.0
       check that the DB schema is upgraded
       check that the configuration is upgraded
       check that the portal is reachable after upgrade
       check that the engine is running after upgrade

### Test case: upgrade to latest nightly from engine-setup-2

      Install beta version using engine-setup-2
      Upgrade ovirt-engine-setup to latest nightly
      Run engine-setup-2
       check that the package are upgraded to latest nightly
       check that the DB schema is upgraded
       check that the configuration is upgraded
       check that the portal is reachable after upgrade
       check that the engine is running after upgrade

### Test case: upgrade to latest nightly from legacy engine-setup

      Install beta version using legacy engine-setup
      Upgrade ovirt-engine-setup to latest nightly
      Run engine-setup-2
       check that the package are upgraded to latest nightly
       check that the DB schema is upgraded
       check that the configuration is upgraded
       check that the portal is reachable after upgrade
       check that the engine is running after upgrade

## Detailed Features Testing

### Test case: minimum hardware requirements validation

      Run engine-setup-2 on a system with less than 4 GB of memory
       Check that a warning is issued about not enough available memory on the Host

### Test case: recommended hardware requirements validation

      Run engine-setup-2 on a system with less than 16 GB of memory
      Check that a warning is issued about running on a system with less than recommended memory

### Test case: generate answer file

      Run engine-setup-2 --generate-answer=filename
      check that at the end of the execution the file was generated

      Run engine-cleanup-2 --generate-answer=filename
      check that at the end of the execution the file was generated

### Test case : use answer file

      Run engine-setup-2 --config-append=filename where filename is an answer file generated in a previous execution
      check that engine-setup-2 runs without any question

      Run engine-cleanup-2 --config-append=filename where filename is an answer file generated in a previous execution
      check that engine-cleanup-2 runs without any question

### Test case: logging

      Run engine-setup-2
       check that a log file is created in /tmp dir
       check that a summary of the configuration is logged
      Run engine-cleanup-2
       check that a log file is created in /tmp dir
       check that a summary of the configuration is logged

      Run engine-setup-2 --log=filename
       check that a log file is created at specified path
      Run engine-cleanup-2 --log=filename
       check that a log file is created at specified path

### Test case: firewall manager configuration

      Run engine-setup-2 on a clean system
       check that if only firewalld is installed, the system prompt if you want to configure it.
       check that if only iptables is installed,  the system prompt if you want to configure it.
       check that if both firewalld and iptables are installed the system prompt first for firewalld and if the answer is no it also ask for iptables.
       check that at the end of the execution only the selected firewall manager is running
       check that if no firewall manager was selected an informative message is given to the user allowing to configure the firewall manager manually.

### Test case: password masked

      Run engine-setup-2
       check that when typing a password nothing is printed on screen
       check that the entered passwords are not visible in logs

### Test case: output messages

      Run engine-setup-2
       check that there is a message telling where to find the log file
       check that a summary of the configuration is presented when running without an answer file before applying changes to the system allowing the user to abort the procedure
       check that there is an info message finalizing the successful install

      Run engine-cleanup-2
       check that there is a message telling where to find the log file
       check that there is an info message finalizing the successful cleanup

### Test case: local database configuration

      Run engine-setup-2 on a clean system
       select local database
       select automatic postgresql configuration
       check that the DB is correctly provisioned and created

      Run engine-setup-2 on a clean system
       select local database
       select manual postgresql configuration
       follow on screen instructions
       fill required connection parameters
       check that the setup completes successfully
       check that the engine is running correctly at setup end

### Test case: remote database configuration

      Run engine-setup-2 on a clean system
       select remote database
       follow on screen instructions
       fill required connection parameters
       check that the setup completes successfully
       check that the engine is running correctly at setup end

### Test case: Apache configuration

      Run engine-setup-2 on a clean system
       check that if selinux is enabled  httpd_can_network_connect flag is enabled on http and https ports
       check that existing httpd configuration were backed up
       check that mod_ssl was configured for using engine apache keys
       check that Apache was configured as proxy for the requests to the jboss service

### Test case: tools configuration

      Run engine-setup-2 on a clean system
       check that ovirt-log-collector is configured
       check that ovirt-iso-uploader is configured
       check that ovirt-image-uploader is configured

### Test case: AIO plugin Hardware requirements validation

      Install ovirt-engine-setup-plugins-allinone and run engine-setup-2
       check that you can configure vdsm if cpu hardware support for virtualization is enabled
       check that you can't configure vdsm if cpu hardware support for virtualization is disabled by bios or not supported by the CPU


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

[32] 

[33] 

[34] only if we did not install in development mode

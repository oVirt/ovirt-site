# Backing up the Self-Hosted Engine Manager Virtual Machine

It is recommended that you back up your self-hosted engine environment regularly. The supported backup method uses the `engine-backup` tool and can be performed without interrupting the `ovirt-engine` service. The `engine-backup` tool only allows you to back up the Red Hat Virtualization Manager virtual machine, but not the host that contains the Manager virtual machine or other virtual machines hosted in the environment.

**Backing up the Original Red Hat Virtualization Manager**

1. **Preparing the Failover Host**

    A failover host, one of the hosted-engine hosts in the environment, must be placed into maintenance mode so that it has no virtual load at the time of the backup. This host can then later be used to deploy the restored self-hosted engine environment. Any of the hosted-engine hosts can be used as the failover host for this backup scenario, however the restore process is more straightforward if `Host 1` is used. The default name for the `Host 1` host is `hosted_engine_1`; this was set when the hosted-engine deployment script was initially run.

    1. Log in to one of the hosted-engine hosts.

    2. Confirm that the `hosted_engine_1` host is `Host 1`:

            # hosted-engine --vm-status

    3. Log in to the Administration Portal.

    4. Click the **Hosts** tab.

    5. Select the `hosted_engine_1` host in the results list, and click **Maintenance**.

    6. Click **Ok**.

    Depending on the virual load of the host, it may take some time for all the virtual machines to be migrated. Proceed to the next step after the host status has changed to `Maintenance`.

2. **Creating a Backup of the Manager**

    On the Manager virtual machine, back up the configuration settings and database content, replacing `[EngineBackupFile]` with the file name for the backup file, and `[LogFILE]` with the file name for the backup log.

        # engine-backup --mode=backup --file=[EngineBackupFile] --log=[LogFILE]

3. **Backing up the Files to an External Server**

    Back up the files to an external server. In the following example, `[Storage.example.com]` is the fully qualified domain name of a network storage server that will store the backup until it is needed, and `/backup/` is any designated folder or path. The backup files must be accessible to restore the configuration settings and database content.

        # scp -p [EngineBackupFiles] [Storage.example.com:/backup/EngineBackupFiles]

4. **Activating the Failover Host**

    Bring the `hosted_engine_1` host out of maintenance mode.

    1. Log in to the Administration Portal.

    2. Click the **Hosts** tab.

    3. Select `hosted_engine_1` from the results list.

    4. Click **Activate**.

You have backed up the configuration settings and database content of the Red Hat Virtualization Manager virtual machine.

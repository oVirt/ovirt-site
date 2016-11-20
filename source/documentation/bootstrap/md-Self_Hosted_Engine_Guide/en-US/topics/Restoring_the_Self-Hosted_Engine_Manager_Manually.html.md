# Restoring the Self-Hosted Engine Manager Manually

The following procedure outlines how to manually restore the configuration settings and database content for a backed-up self-hosted engine Manager virtual machine.

**Restoring the Self-Hosted Engine Manager**

1. Manually create an empty database to which the database content in the backup can be restored. The following steps must be performed on the machine where the database is to be hosted.

    1. If the database is to be hosted on a machine other than the Manager virtual machine, install the `postgresql-server` package. This step is not required if the database is to be hosted on the Manager virtual machine because this package is included with the `rhevm` package.

            # yum install postgresql-server

    2. Initialize the `postgresql` database, start the `postgresql` service, and ensure this service starts on boot:

            # postgresql-setup initdb
            # systemctl start postgresql.service
            # systemctl enable postgresql.service

    3. Enter the postgresql command line:

            # su postgres
            $ psql

    4. Create the `engine` user: 

            postgres=# create role engine with login encrypted password 'password';

        If you are also restoring Data Warehouse, create the `ovirt_engine_history` user on the relevant host: 

            postgres=# create role ovirt_engine_history with login encrypted password 'password';

    5. Create the new database:

            postgres=# create database database_name owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

        If you are also restoring the Data Warehouse, create the database on the relevant host:

            postgres=# create database database_name owner ovirt_engine_history template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

    6. Exit the postgresql command line and log out of the postgres user: 

            postgres=# \q
            $ exit

    7. Edit the `/var/lib/pgsql/data/pg_hba.conf` file as follows:

        * For each local database, replace the existing directives in the section starting with `local` at the bottom of the file with the following directives:

                host    database_name    user_name    0.0.0.0/0  md5
                host    database_name    user_name    ::0/0      md5
        * For each remote database:

            * Add the following line immediately underneath the line starting with `Local` at the bottom of the file, replacing `X.X.X.X` with the IP address of the Manager:

                    host    database_name    user_name    X.X.X.X/32   md5
            * Allow TCP/IP connections to the database. Edit the `/var/lib/pgsql/data/postgresql.conf` file and add the following line:
                    listen_addresses='*'

                This example configures the `postgresql` service to listen for connections on all interfaces. You can specify an interface by giving its IP address.

            * Open the default port used for PostgreSQL database connections, and save the updated firewall rules:

                    # iptables -I INPUT 5 -p tcp -s Manager_IP_Address --dport 5432 -j ACCEPT
                    # service iptables save
    8. Restart the `postgresql` service:

            # systemctl restart postgresql.service

2. Secure copy the backup files to the new Manager virtual machine. This example copies the files from a network storage server to which the files were copied in [Backing up the Self-Hosted Engine Manager Virtual Machine](Backing_up_the_Self-Hosted_Engine_Manager_Virtual_Machine). In this example, `Storage.example.com` is the fully qualified domain name of the storage server, `/backup/EngineBackupFiles` is the designated file path for the backup files on the storage server, and `/backup/` is the path to which the files will be copied on the new Manager.

        # scp -p Storage.example.com:/backup/EngineBackupFiles /backup/

3. Restore a complete backup or a database-only backup with the `--change-db-credentials` parameter to pass the credentials of the new database. The `database_location` for a database local to the Manager is `localhost`.

    **Note:** The following examples use a `--*password` option for each database without specifying a password, which will prompt for a password for each database. Passwords can be supplied for these options in the command itself, however this is not recommended as the password will then be stored in the shell history. Alternatively, `--*passfile=password_file` options can be used for each database to securely pass the passwords to the `engine-backup` tool without the need for interactive prompts.

    * Restore a complete backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password

        If Data Warehouse is also being restored as part of the complete backup, include the revised credentials for the additional database:

            engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password

    * Restore a database-only backup restoring the configuration files and the database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password

        The example above restores a backup of the Manager database.

            # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=file_name --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password

        The example above restores a backup of the Data Warehouse database.

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

4. Configure the restored Manager virtual machine. This process identifies the existing configuration settings and database content. Confirm the settings. Upon completion, the setup provides an SSH fingerprint and an internal Certificate Authority hash.

        # engine-setup
        [ INFO  ] Stage: Initializing
        [ INFO  ] Stage: Environment setup
        Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging.conf', '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf']
        Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140304075238.log
        Version: otopi-1.1.2 (otopi-1.1.2-1.el6ev)
        [ INFO  ] Stage: Environment packages setup
        [ INFO  ] Yum Downloading: rhel-65-zstream/primary_db 2.8 M(70%)
        [ INFO  ] Stage: Programs detection
        [ INFO  ] Stage: Environment setup
        [ INFO  ] Stage: Environment customization
        
                  --== PACKAGES ==--
        
        [ INFO  ] Checking for product updates...
        [ INFO  ] No product updates found
        
                  --== NETWORK CONFIGURATION ==--
        
        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]: 
        [ INFO  ] iptables will be configured as firewall manager.
        
                  --== DATABASE CONFIGURATION ==--
        
        
                  --== OVIRT ENGINE CONFIGURATION ==--
        
                  Skipping storing options as database already prepared
        
                  --== PKI CONFIGURATION ==--
        
                  PKI is already configured
        
                  --== APACHE CONFIGURATION ==--
        
        
                  --== SYSTEM CONFIGURATION ==--
        
        
                  --== END OF CONFIGURATION ==--
        
        [ INFO  ] Stage: Setup validation
        [ INFO  ] Cleaning stale zombie tasks
        
                  --== CONFIGURATION PREVIEW ==--
        
                  Database name                      : engine
                  Database secured connection        : False
                  Database host                      : X.X.X.X
                  Database user name                 : engine
                  Database host name validation      : False
                  Database port                      : 5432
                  NFS setup                          : True
                  Firewall manager                   : iptables
                  Update Firewall                    : True
                  Configure WebSocket Proxy          : True
                  Host FQDN                          : Manager.example.com
                  NFS mount point                    : /var/lib/exports/iso
                  Set application as default page    : True
                  Configure Apache SSL               : True
        
                  Please confirm installation settings (OK, Cancel) [OK]:

5. **Removing the Host from the Restored Environment

    If the deployment of the restored self-hosted engine is on new hardware that has a unique name not present in the backed-up engine, skip this step. This step is only applicable to deployments occurring on the failover host, `hosted_engine_1`. Because this host was present in the environment at time the backup was created, it maintains a presence in the restored engine and must first be removed from the environment before final synchronization can take place.

    1. Log in to the Administration Portal.

    2. Click the **Hosts** tab. The failover host, `hosted_engine_1`, will be in maintenance mode and without a virtual load, as this was how it was prepared for the backup.

    3. Click **Remove**.

    4. Click **Ok**.

6. **Synchronizing the Host and the Manager

    Return to the host and continue the `hosted-engine` deployment script by selecting option 1: 

        (1) Continue setup - engine installation is complete

        [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
        [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
        [ INFO  ] Still waiting for VDSM host to become operational...

    At this point, `hosted_engine_1` will become visible in the Administration Portal with **Installing** and **Initializing** states before entering a **Non Operational** state. The host will continue to wait for the VDSM host to become operational until it eventually times out. This happens because another host in the environment maintains the Storage Pool Manager (SPM) role and `hosted_engine_1` cannot interact with the storage domain because the SPM host is in a **Non Responsive** state. When this process times out, you are prompted to shut down the virtual machine to complete the deployment. When deployment is complete, the host can be manually placed into maintenance mode and activated through the Administration Portal.

        [ INFO  ] Still waiting for VDSM host to become operational...
        [ ERROR ] Timed out while waiting for host to start. Please check the logs.
        [ ERROR ] Unable to add hosted_engine_2 to the manager
                  Please shutdown the VM allowing the system to launch it as a monitored service.
                  The system will wait until the VM is down.

7. Shut down the new Manager virtual machine.

        # shutdown -h now

8. Return to the host to confirm it has detected that the Manager virtual machine is down.

        [ INFO  ] Enabling and starting HA services
                  Hosted Engine successfully set up
        [ INFO  ] Stage: Clean up
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination

9. Activate the host.

    1. Log in to the Administration Portal.

    2. Click the **Hosts** tab.

    3. Select `hosted_engine_1` and click the **Maintenance** button. The host may take several minutes before it enters maintenance mode.

    4. Click the **Activate** button.

    Once active, `hosted_engine_1` immediately contends for SPM, and the storage domain and data center become active.

10. Migrate virtual machines to the active host by manually fencing the **Non Responsive** hosts. In the Administration Portal, right-click the hosts and select **Confirm 'Host has been Rebooted'**.

    Any virtual machines that were running on that host at the time of the backup will now be removed from that host, and move from an **Unknown** state to a **Down** state. These virtual machines can now be run on `hosted_engine_1`. The host that was fenced can now be forcefully removed using the REST API.

The environment has now been restored to a point where `hosted_engine_1` is active and is able to run virtual machines in the restored environment. The remaining hosted-engine hosts in **Non Operational** state can now be removed by following the steps in [Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment](Removing_Non-Operational_Hosts_from_a_Restored_Self-Hosted_Engine_Environment) and then re-installed into the environment by following the steps in [Installing Additional Hosts to a Self-Hosted Environment](chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment).

**Note:** If the Manager database is restored successfully, but the Manager virtual machine appears to be **Down** and cannot be migrated to another self-hosted engine host, you can enable a new Manager virtual machine and remove the dead Manager virtual machine from the environment by following the steps provided in [https://access.redhat.com/solutions/1517683](https://access.redhat.com/solutions/1517683). 

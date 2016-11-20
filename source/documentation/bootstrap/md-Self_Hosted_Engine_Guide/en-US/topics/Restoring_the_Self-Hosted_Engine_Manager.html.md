# Restoring the Self-Hosted Engine Manager

The following procedure outlines how to use the `engine-backup` tool to automate the restore of the configuration settings and database content for a backed-up self-hosted engine Manager virtual machine and Data Warehouse. The procedure only applies to components that were configured automatically during the initial `engine-setup`. If you configured the database(s) manually during `engine-setup`, follow the instructions at [Restoring the Self-Hosted Engine Manager Manually](Restoring_the_Self-Hosted_Engine_Manager_Manually) to restore the back-up environment manually.

**Restoring the Self-Hosted Engine Manager**

1. Secure copy the backup files to the new Manager virtual machine. This example copies the files from a network storage server to which the files were copied in [Backing up the Self-Hosted Engine Manager Virtual Machine](Backing_up_the_Self-Hosted_Engine_Manager_Virtual_Machine). In this example, `Storage.example.com` is the fully qualified domain name of the storage server, `/backup/EngineBackupFiles` is the designated file path for the backup files on the storage server, and `/backup/` is the path to which the files will be copied on the new Manager.

        # scp -p Storage.example.com:/backup/EngineBackupFiles /backup/

2. Use the `engine-backup` tool to restore a complete backup.

    * If you are only restoring the Manager, run:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --restore-permissions

    * If you are restoring the Manager and Data Warehouse, run:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --provision-dwh-db --restore-permissions

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

3. Configure the restored Manager virtual machine. This process identifies the existing configuration settings and database content. Confirm the settings. Upon completion, the setup provides an SSH fingerprint and an internal Certificate Authority hash.

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

4. **Removing the Host from the Restored Environment**

    If the deployment of the restored self-hosted engine is on new hardware that has a unique name not present in the backed-up engine, skip this step. This step is only applicable to deployments occurring on the failover host, `hosted_engine_1`. Because this host was present in the environment at time the backup was created, it maintains a presence in the restored engine and must first be removed from the environment before final synchronization can take place.

    1. Log in to the Administration Portal.

    2. Click the **Hosts** tab. The failover host, `hosted_engine_1`, will be in maintenance mode and without a virtual load, as this was how it was prepared for the backup.

    3. Click **Remove**.

    4. Click **Ok**.

    **Note:** If the host you are trying to remove becomes non-operational, see [Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment](Removing_Non-Operational_Hosts_from_a_Restored_Self-Hosted_Engine_Environment) for instructions on how to force the removal of a host.

5. **Synchronizing the Host and the Manager**

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

6. Shut down the new Manager virtual machine.

        # shutdown -h now

7. Return to the host to confirm it has detected that the Manager virtual machine is down.

        [ INFO  ] Enabling and starting HA services
                  Hosted Engine successfully set up
        [ INFO  ] Stage: Clean up
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination

8. Activate the host.

    1. Log in to the Administration Portal.

    2. Click the **Hosts** tab.

    3. Select `hosted_engine_1` and click the **Maintenance** button. The host may take several minutes before it enters maintenance mode.

    4. Click the **Activate** button.

    Once active, `hosted_engine_1` immediately contends for SPM, and the storage domain and data center become active.

8. Migrate virtual machines to the active host by manually fencing the **Non Responsive** hosts. In the Administration Portal, right-click the hosts and select **Confirm 'Host has been Rebooted'**.

    Any virtual machines that were running on that host at the time of the backup will now be removed from that host, and move from an **Unknown** state to a **Down** state. These virtual machines can now be run on `hosted_engine_1`. The host that was fenced can now be forcefully removed using the REST API.

The environment has now been restored to a point where `hosted_engine_1` is active and is able to run virtual machines in the restored environment. The remaining hosted-engine hosts in **Non Operational** state can now be removed by following the steps in [Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment](Removing_Non-Operational_Hosts_from_a_Restored_Self-Hosted_Engine_Environment) and then re-installed into the environment by following the steps in [Installing Additional Hosts to a Self-Hosted Environment](chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment).

**Note:** If the Manager database is restored successfully, but the Manager virtual machine appears to be **Down** and cannot be migrated to another self-hosted engine host, you can enable a new Manager virtual machine and remove the dead Manager virtual machine from the environment by following the steps provided in [https://access.redhat.com/solutions/1517683](https://access.redhat.com/solutions/1517683). 





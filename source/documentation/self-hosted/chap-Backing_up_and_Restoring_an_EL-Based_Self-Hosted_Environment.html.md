---
title: Backing up and Restoring an EL-Based Self-Hosted Environment
---

# Chapter 6: Backing up and Restoring an EL-Based Self-Hosted Environment

The nature of the self-hosted engine, and the relationship between the hosts and the hosted-engine virtual machine, means that backing up and restoring a self-hosted engine environment requires additional considerations to that of a standard oVirt environment. In particular, the hosted-engine hosts remain in the environment at the time of backup, which can result in a failure to synchronize the new host and hosted-engine virtual machine after the environment has been restored.

To address this, it is recommended that one of the hosts be placed into maintenance mode prior to backup, thereby freeing it from a virtual load. This failover host can then be used to deploy the new self-hosted engine.

If a hosted-engine host is carrying a virtual load at the time of backup, then a host with any of the matching identifiers - IP address, FQDN, or name - cannot be used to deploy a restored self-hosted engine. Conflicts in the database will prevent the host from synchronizing with the restored hosted-engine virtual machine. The failover host, however, can be removed from the restored hosted-engine virtual machine prior to synchronization.

**Note:** A failover host at the time of backup is not strictly necessary if a new host is used to deploy the self-hosted engine. The new host must have a unique IP address, FQDN, and name so that it does not conflict with any of the hosts present in the database backup.

**Workflow for Backing Up the Self-Hosted Engine Environment**

This procedure provides an example of the workflow for backing up a self-hosted engine using a failover host. This host can then be used later to deploy the restored self-hosted engine environment. For more information on backing up the self-hosted engine, see the Backing up the Self-Hosted Engine Virtual Machine section below.

1. The engine virtual machine is running on `Host 2` and the six regular virtual machines in the environment are balanced across the three hosts.

    ![](/images/self-hosted/RHEV_SHE_bkup_00.png)

    Place `Host 1` into maintenance mode. This will migrate the virtual machines on `Host 1` to the other hosts, freeing it of any virtual load and enabling it to be used as a failover host for the backup.

2. `Host 1` is in maintenance mode. The two virtual machines it previously hosted have been migrated to Host 3.

    ![](/images/self-hosted/RHEV_SHE_bkup_01.png)

    Use `engine-backup` to create backups of the environment. After the backup has been taken, `Host 1` can be activated again to host virtual machines, including the engine virtual machine.

**Workflow for Restoring the Self-Hosted Engine Environment**

This procedure provides an example of the workflow for restoring the self-hosted engine environment from a backup. The failover host deploys the new engine virtual machine, which then restores the backup. Directly after the backup has been restored, the failover host is still present in the oVirt Engine because it was in the environment when the backup was created. Removing the old failover host from the Engine enables the new host to synchronize with the engine virtual machine and finalize deployment.

1. `Host 1` has been used to deploy a new self-hosted engine and has restored the backup taken in the previous example procedure. Deploying the restored environment involves additional steps to that of a regular self-hosted engine deployment:

    * After oVirt Engine has been installed on the engine virtual machine, but before `engine-setup` is first run, restore the backup using the `engine-backup` tool.

    * After `engine-setup` has configured and restored the Engine, log in to the Administration Portal and remove `Host 1`, which will be present from the backup. If old `Host 1` is not removed, and is still present in the Engine when finalizing deployment on new `Host 1`, the engine virtual machine will not be able to synchronize with new `Host 1` and the deployment will fail.

    ![](/images/self-hosted/RHEV_SHE_bkup_02.png)

    After `Host 1` and the engine virtual machine have synchronized and the deployment has been finalized, the environment can be considered operational on a basic level. With only one hosted-engine host, the engine virtual machine is not highly available. However, if necessary, high-priority virtual machines can be started on `Host 1`.

    Any standard RHEL-based hosts - hosts that are present in the environment but are not self-hosted engine hosts - that are operational will become active, and the virtual machines that were active at the time of backup will now be running on these hosts and available in the Engine.

2. `Host 2` and `Host 3` are not recoverable in their current state. These hosts need to be removed from the environment, and then added again to the environment using the hosted-engine deployment script. For more information on these actions, see the Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment section below and [Chapter 7: Installing Additional Hosts to a Self-Hosted Environment](../chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment).

    ![](/images/self-hosted/RHEV_SHE_bkup_03.png)

    `Host 2` and `Host 3` have been re-deployed into the restored environment. The environment is now as it was in the first image, before the backup was taken, with the exception that the engine virtual machine is hosted on `Host 1`.

### Backing up the Self-Hosted Engine Virtual Machine

It is recommended that you back up your self-hosted engine environment regularly. The supported backup method uses the `engine-backup` tool and can be performed without interrupting the `ovirt-engine` service. The `engine-backup` tool only allows you to back up the oVirt Engine virtual machine, but not the host that contains the Engine virtual machine or other virtual machines hosted in the environment.

**Backing up the Original oVirt Engine**

1. **Preparing the Failover Host**

    A failover host, one of the hosted-engine hosts in the environment, must be placed into maintenance mode so that it has no virtual load at the time of the backup. This host can then later be used to deploy the restored self-hosted engine environment. Any of the hosted-engine hosts can be used as the failover host for this backup scenario, however the restore process is more straightforward if `Host 1` is used. The default name for the `Host 1` host is `hosted_engine_1`; this was set when the hosted-engine deployment script was initially run.

    a. Log in to one of the hosted-engine hosts.

    b. Confirm that the `hosted_engine_1` host is `Host 1`:

            # hosted-engine --vm-status

    c. Log in to the Administration Portal.

    d. Click the **Hosts** tab.

    e. Select the `hosted_engine_1` host in the results list, and click **Maintenance**.

    f. Click **Ok**.

    Depending on the virtual load of the host, it may take some time for all the virtual machines to be migrated. Proceed to the next step after the host status has changed to `Maintenance`.

2. **Creating a Backup of the Engine**

    On the Engine virtual machine, back up the configuration settings and database content, replacing `[EngineBackupFile]` with the file name for the backup file, and `[LogFILE]` with the file name for the backup log.

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

You have backed up the configuration settings and database content of the oVirt Engine virtual machine.

## Restoring the Self-Hosted Engine Environment

This section explains how to restore a self-hosted engine environment from a backup on a newly installed host. The supported restore method uses the `engine-backup` tool.

Restoring a self-hosted engine environment involves the following key actions:

1. Create a newly installed Enterprise Linux host and run the hosted-engine deployment script.

2. Restore the oVirt Engine configuration settings and database content in the new Engine virtual machine.

3. Remove hosted-engine hosts in a <guilabel>Non Operational</guilabel> state and re-install them into the restored self-hosted engine environment.

**Prerequisites**

* To restore a self-hosted engine environment, you must prepare a newly installed Enterprise Linux system on a physical host.

* The operating system version of the new host and Engine must be the same as that of the original host and Engine.

* The fully qualified domain name of the new Engine must be the same fully qualified domain name as that of the original Engine. Forward and reverse lookup records must both be set in DNS.

### Creating a New Self-Hosted Engine Environment to be Used as the Restored Environment

You can restore a self-hosted engine on hardware that was used in the backed-up environment. However, you must use the failover host for the restored deployment. The failover host, `Host 1`, used in Backing up the Self-Hosted Engine Virtual Machine section above uses the default hostname of `hosted_engine_1`, which is also used in this procedure. Due to the nature of the restore process for the self-hosted engine, before the final synchronization of the restored engine can take place, this failover host will need to be removed, and this can only be achieved if the host had no virtual load when the backup was taken. You can also restore the backup on a separate hardware which was not used in the backed up environment and this is not a concern.

**Creating a New Self-Hosted Environment to be Used as the Restored Environment**

1. **Updating DNS**

    Update your DNS so that the fully qualified domain name of the oVirt environment correlates to the IP address of the new Engine. In this procedure, fully qualified domain name was set as `Engine.example.com`. The fully qualified domain name provided for the engine must be identical to that given in the engine setup of the original engine that was backed up.

2. **Initiating Hosted Engine Deployment**

    On the newly installed Red Hat Enterprise Linux host, run the `hosted-engine` deployment script. To escape the script at any time, use the **CTRL** + **D** keyboard combination to abort deployment. If running the `hosted-engine` deployment script over a network, it is recommended to use the `screen` window manager to avoid losing the session in case of network or terminal disruption. Install the `screen` package first if not installed.

        # screen
        # hosted-engine --deploy

3. **Preparing for Initialization**

    The script begins by requesting confirmation to use the host as a hypervisor for use in a self-hosted engine environment.

        Continuing will configure this host for serving as hypervisor and create a VM where you have to install oVirt Engine afterwards.
        Are you sure you want to continue? (Yes, No)[Yes]:

4. **Configuring Storage**

    Select the type of storage to use.

        During customization use CTRL-D to abort.
        Please specify the storage you would like to use (glusterfs, iscsi, fc, nfs3, nfs4)[nfs3]:

    * For NFS storage types, specify the full address, using either the FQDN or IP address, and path name of the shared storage domain.

            Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/nfs

    * For iSCSI, specify the iSCSI portal IP address, port, user name and password, and select a target name from the auto-detected list. You can only select one iSCSI target during the deployment.

            Please specify the iSCSI portal IP address:           
            Please specify the iSCSI portal port [3260]:           
            Please specify the iSCSI portal user:           
            Please specify the iSCSI portal password:
            Please specify the target name (auto-detected values) [default]:

    * For Gluster storage, specify the full address, using either the FQDN or IP address, and path name of the shared storage domain.

        **Important:** Only replica 3 Gluster storage is supported. Ensure the following configuration has been made:

        * In the `/etc/glusterfs/glusterd.vol` file on all three Gluster servers, set `rpc-auth-allow-insecure` to `on`.

                option rpc-auth-allow-insecure on

        * Configure the volume as follows:

                gluster volume set volume cluster.quorum-type auto
                gluster volume set volume network.ping-timeout 10
                gluster volume set volume auth.allow \*
                gluster volume set volume group virt
                gluster volume set volume storage.owner-uid 36
                gluster volume set volume storage.owner-gid 36
                gluster volume set volume server.allow-insecure on

        <!-- comment ends list so next line is pre -->

            Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/gluster_volume

    * For Fibre Channel, the host bus adapters must be configured and connected, and the `hosted-engine` script will auto-detect the LUNs available. The LUNs must not contain any existing data.

            The following luns have been found on the requested target:
            [1]     3514f0c5447600351       30GiB   XtremIO XtremApp
                                    status: used, paths: 2 active

            [2]     3514f0c5447600352       30GiB   XtremIO XtremApp
                                    status: used, paths: 2 active

            Please select the destination LUN (1, 2) [1]:

5. **Configuring the Network**

    The script detects possible network interface controllers (NICs) to use as a management bridge for the environment. It then checks your firewall configuration and offers to modify it for console (SPICE or VNC) access the Engine virtual machine. Provide a pingable gateway IP address, to be used by the `ovirt-ha-agent`, to help determine a host's suitability for running a Engine virtual machine.

        Please indicate a nic to set ovirtmgmt bridge on: (eth1, eth0) [eth1]:
        iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]:
        Please indicate a pingable gateway IP address [X.X.X.X]:

6. **Configuring the New Engine Virtual Machine**

    The script creates a virtual machine to be configured as the new Engine virtual machine. Specify the boot device and, if applicable, the path name of the installation media, the image alias, the CPU type, the number of virtual CPUs, and the disk size. Specify a MAC address for the Engine virtual machine, or accept a randomly generated one. The MAC address can be used to update your DHCP server prior to installing the operating system on the Engine virtual machine. Specify memory size and console connection type for the creation of Engine virtual machine.

        Please specify the device to boot the VM from (cdrom, disk, pxe) [cdrom]:
        Please specify an alias for the Hosted Engine image [hosted_engine]:  
        The following CPU types are supported by this host:
                  - model_Penryn: Intel Penryn Family
                  - model_Conroe: Intel Conroe Family
        Please specify the CPU type to be used by the VM [model_Penryn]:
        Please specify the number of virtual CPUs for the VM [Defaults to minimum requirement: 2]:
        Please specify the disk size of the VM in GB [Defaults to minimum requirement: 25]:
        You may specify a MAC address for the VM or accept a randomly generated default [00:16:3e:77:b2:a4]:
        Please specify the memory size of the VM in MB [Defaults to minimum requirement: 4096]:
        Please specify the console type you want to use to connect to the VM (vnc, spice) [vnc]:

7. **Identifying the Name of the Host**

    Specify the password for the `admin@internal` user to access the Administration Portal.

    A unique name must be provided for the name of the host, to ensure that it does not conflict with other resources that will be present when the engine has been restored from the backup. The name `hosted_engine_1` can be used in this procedure because this host was placed into maintenance mode before the environment was backed up, enabling removal of this host between the restoring of the engine and the final synchronization of the host and the engine.

        Enter engine admin password:
        Confirm engine admin password:
        Enter the name which will be used to identify this host inside the Administration Portal [hosted_engine_1]:

8. **Configuring the Hosted Engine**

    Provide the fully qualified domain name for the new Engine virtual machine. This procedure uses the fully qualified domain name `Engine.example.com`. Provide the name and TCP port number of the SMTP server, the email address used to send email notifications, and a comma-separated list of email addresses to receive these notifications.


    **Important:** The fully qualified domain name provided for the engine (`Engine.example.com`) must be the same fully qualified domain name provided when original Engine was initially set up.

        Please provide the FQDN for the engine you would like to use.
        This needs to match the FQDN that you will use for the engine installation within the VM.
         Note: This will be the FQDN of the VM you are now going to create,
         it should not point to the base host or to any other existing machine.
         Engine FQDN: Engine.example.com
        Please provide the name of the SMTP server through which we will send notifications [localhost]:
        Please provide the TCP port number of the SMTP server [25]:
        Please provide the email address from which notifications will be sent [root@localhost]:
        Please provide a comma-separated list of email addresses which will get notifications [root@localhost]:

9. **Configuration Preview**

    Before proceeding, the `hosted-engine` deployment script displays the configuration values you have entered, and prompts for confirmation to proceed with these values.

        Bridge interface                   : eth1
        Engine FQDN                        : Engine.example.com
        Bridge name                        : ovirtmgmt
        SSH daemon port                    : 22
        Firewall manager                   : iptables
        Gateway address                    : X.X.X.X
        Host name for web application      : hosted_engine_1
        Host ID                            : 1
        Image alias                        : hosted_engine
        Image size GB                      : 25
        Storage connection                 : storage.example.com:/hosted_engine/nfs
        Console type                       : vnc
        Memory size MB                     : 4096
        MAC address                        : 00:16:3e:77:b2:a4
        Boot type                          : pxe
        Number of CPUs                     : 2
        CPU Type                           : model_Penryn

        Please confirm installation settings (Yes, No)[Yes]:

10. **Creating the New Engine Virtual Machine**

    The script creates the virtual machine to be configured as the Engine virtual machine and provides connection details. You must install an operating system on it before the `hosted-engine` deployment script can proceed on Hosted Engine configuration.

        [ INFO  ] Stage: Transaction setup
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Stage: Package installation
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Configuring libvirt
        [ INFO  ] Configuring VDSM
        [ INFO  ] Starting vdsmd
        [ INFO  ] Waiting for VDSM hardware info
        [ INFO  ] Waiting for VDSM hardware info
        [ INFO  ] Configuring the management bridge
        [ INFO  ] Creating Storage Domain
        [ INFO  ] Creating Storage Pool
        [ INFO  ] Connecting Storage Pool
        [ INFO  ] Verifying sanlock lockspace initialization
        [ INFO  ] Creating VM Image
        [ INFO  ] Disconnecting Storage Pool
        [ INFO  ] Start monitoring domain
        [ INFO  ] Configuring VM
        [ INFO  ] Updating hosted-engine configuration
        [ INFO  ] Stage: Transaction commit
        [ INFO  ] Stage: Closing up
        [ INFO  ] Creating VM
        You can now connect to the VM with the following command:
              /usr/bin/remote-viewer vnc://localhost:5900
        Use temporary password "3477XXAM" to connect to vnc console.
        Please note that in order to use remote-viewer you need to be able to run graphical applications.
        This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
        Otherwise you can run the command from a terminal in your preferred desktop environment.
        If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
        virsh -c qemu+tls://Test/system console HostedEngine
        If you need to reboot the VM you will need to start it manually using the command:
        hosted-engine --vm-start
        You can then set a temporary password using the command:
        hosted-engine --add-console-password
        The VM has been started.  Install the OS and shut down or reboot it.  To continue please make a selection:

          (1) Continue setup - VM installation is complete
          (2) Reboot the VM and restart installation
          (3) Abort setup
          (4) Destroy VM and abort setup

          (1, 2, 3, 4)[1]:

    Using the naming convention of this procedure, connect to the virtual machine using VNC with the following command:

        /usr/bin/remote-viewer vnc://hosted_engine_1.example.com:5900

11. **Installing the Virtual Machine Operating System**

    Connect to Engine virtual machine and install a Red Hat Enterprise Linux 7 operating system.

12. **Synchronizing the Host and the Engine**

    Return to the host and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - VM installation is complete

        Waiting for VM to shut down...
        [ INFO  ] Creating VM
        You can now connect to the VM with the following command:
              /usr/bin/remote-viewer vnc://localhost:5900
        Use temporary password "3477XXAM" to connect to vnc console.
        Please note that in order to use remote-viewer you need to be able to run graphical applications.
        This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
        Otherwise you can run the command from a terminal in your preferred desktop environment.
        If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
        virsh -c qemu+tls://Test/system console HostedEngine
        If you need to reboot the VM you will need to start it manually using the command:
        hosted-engine --vm-start
        You can then set a temporary password using the command:
        hosted-engine --add-console-password
        Please install and setup the engine in the VM.
        You may also be interested in subscribing to "agent" RHN/Satellite channel and installing ovirt-engine-guest-agent-common package in the VM.
        To continue make a selection from the options below:
          (1) Continue setup - engine installation is complete
          (2) Power off and restart the VM
          (3) Abort setup
          (4) Destroy VM and abort setup

          (1, 2, 3, 4)[1]:

13. **Installing the Engine**

    Connect to new Engine virtual machine, ensure the latest versions of all installed packages are in use, and install the `ovirt-engine` packages.

        # yum update

    **Note:** Reboot the machine if any kernel related packages have been updated.

        # yum install ovirt-engine

After the packages have completed installation, you will be able to continue with restoring the self-hosted engine Engine.

### Restoring the Self-Hosted Engine Engine

The following procedure outlines how to use the `engine-backup` tool to automate the restore of the configuration settings and database content for a backed-up self-hosted engine Engine virtual machine and Data Warehouse. The procedure only applies to components that were configured automatically during the initial `engine-setup`. If you configured the database(s) manually during `engine-setup`, follow the instructions at Restoring the Self-Hosted Engine Engine Manually section below to restore the back-up environment manually.

**Restoring the Self-Hosted Engine Engine**

1. Secure copy the backup files to the new Engine virtual machine. This example copies the files from a network storage server to which the files were copied in Backing up the Self-Hosted Engine Engine Virtual Machine section above. In this example, `Storage.example.com` is the fully qualified domain name of the storage server, `/backup/EngineBackupFiles` is the designated file path for the backup files on the storage server, and `/backup/` is the path to which the files will be copied on the new Engine.

        # scp -p Storage.example.com:/backup/EngineBackupFiles /backup/

2. Use the `engine-backup` tool to restore a complete backup.

    * If you are only restoring the Engine, run:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --restore-permissions

    * If you are restoring the Engine and Data Warehouse, run:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --provision-dwh-db --restore-permissions

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

3. Configure the restored Engine virtual machine. This process identifies the existing configuration settings and database content. Confirm the settings. Upon completion, the setup provides an SSH fingerprint and an internal Certificate Authority hash.

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
                  Host FQDN                          : Engine.example.com
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

    **Note:** If the host you are trying to remove becomes non-operational, see the Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment for instructions on how to force the removal of a host.

5. **Synchronizing the Host and the Engine**

    Return to the host and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - engine installation is complete

        [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
        [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
        [ INFO  ] Still waiting for VDSM host to become operational...

    At this point, `hosted_engine_1` will become visible in the Administration Portal with **Installing** and **Initializing** states before entering a **Non Operational** state. The host will continue to wait for the VDSM host to become operational until it eventually times out. This happens because another host in the environment maintains the Storage Pool Engine (SPM) role and `hosted_engine_1` cannot interact with the storage domain because the SPM host is in a **Non Responsive** state. When this process times out, you are prompted to shut down the virtual machine to complete the deployment. When deployment is complete, the host can be manually placed into maintenance mode and activated through the Administration Portal.

        [ INFO  ] Still waiting for VDSM host to become operational...
        [ ERROR ] Timed out while waiting for host to start. Please check the logs.
        [ ERROR ] Unable to add hosted_engine_2 to the manager
                  Please shutdown the VM allowing the system to launch it as a monitored service.
                  The system will wait until the VM is down.

6. Shut down the new Engine virtual machine.

        # shutdown -h now

7. Return to the host to confirm it has detected that the Engine virtual machine is down.

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

**Note:** If the Engine database is restored successfully, but the Engine virtual machine appears to be **Down** and cannot be migrated to another self-hosted engine host, you can enable a new Engine virtual machine and remove the dead Engine virtual machine from the environment.

### Restoring the Self-Hosted Engine Engine Manually

The following procedure outlines how to manually restore the configuration settings and database content for a backed-up self-hosted engine Engine virtual machine.

**Restoring the Self-Hosted Engine Engine**

1. Manually create an empty database to which the database content in the backup can be restored. The following steps must be performed on the machine where the database is to be hosted.

    1. If the database is to be hosted on a machine other than the Engine virtual machine, install the `postgresql-server` package. This step is not required if the database is to be hosted on the Engine virtual machine because this package is included with the `ovirt-engine` package.

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

            * Add the following line immediately underneath the line starting with `Local` at the bottom of the file, replacing `X.X.X.X` with the IP address of the Engine:

                    host    database_name    user_name    X.X.X.X/32   md5
            * Allow TCP/IP connections to the database. Edit the `/var/lib/pgsql/data/postgresql.conf` file and add the following line:
                    listen_addresses='*'

                This example configures the `postgresql` service to listen for connections on all interfaces. You can specify an interface by giving its IP address.

            * Open the default port used for PostgreSQL database connections, and save the updated firewall rules:

                    # iptables -I INPUT 5 -p tcp -s Engine_IP_Address --dport 5432 -j ACCEPT
                    # service iptables save
    8. Restart the `postgresql` service:

            # systemctl restart postgresql.service

2. Secure copy the backup files to the new Engine virtual machine. This example copies the files from a network storage server to which the files were copied in [Backing up the Self-Hosted Engine Engine Virtual Machine](Backing_up_the_Self-Hosted_Engine_Engine_Virtual_Machine). In this example, `Storage.example.com` is the fully qualified domain name of the storage server, `/backup/EngineBackupFiles` is the designated file path for the backup files on the storage server, and `/backup/` is the path to which the files will be copied on the new Engine.

        # scp -p Storage.example.com:/backup/EngineBackupFiles /backup/

3. Restore a complete backup or a database-only backup with the `--change-db-credentials` parameter to pass the credentials of the new database. The `database_location` for a database local to the Engine is `localhost`.

    **Note:** The following examples use a `--*password` option for each database without specifying a password, which will prompt for a password for each database. Passwords can be supplied for these options in the command itself, however this is not recommended as the password will then be stored in the shell history. Alternatively, `--*passfile=password_file` options can be used for each database to securely pass the passwords to the `engine-backup` tool without the need for interactive prompts.

    * Restore a complete backup:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password

        If Data Warehouse is also being restored as part of the complete backup, include the revised credentials for the additional database:

            engine-backup --mode=restore --file=file_name --log=log_file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password

    * Restore a database-only backup restoring the configuration files and the database backup:

            # engine-backup --mode=restore --scope=files --scope=db --file=file_name --log=file_name --change-db-credentials --db-host=database_location --db-name=database_name --db-user=engine --db-password

        The example above restores a backup of the Engine database.

            # engine-backup --mode=restore --scope=files --scope=dwhdb --file=file_name --log=file_name --change-dwh-db-credentials --dwh-db-host=database_location --dwh-db-name=database_name --dwh-db-user=ovirt_engine_history --dwh-db-password

        The example above restores a backup of the Data Warehouse database.

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

4. Configure the restored Engine virtual machine. This process identifies the existing configuration settings and database content. Confirm the settings. Upon completion, the setup provides an SSH fingerprint and an internal Certificate Authority hash.

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
                  Host FQDN                          : Engine.example.com
                  NFS mount point                    : /var/lib/exports/iso
                  Set application as default page    : True
                  Configure Apache SSL               : True

                  Please confirm installation settings (OK, Cancel) [OK]:

5. **Removing the Host from the Restored Environment**

    If the deployment of the restored self-hosted engine is on new hardware that has a unique name not present in the backed-up engine, skip this step. This step is only applicable to deployments occurring on the failover host, `hosted_engine_1`. Because this host was present in the environment at time the backup was created, it maintains a presence in the restored engine and must first be removed from the environment before final synchronization can take place.

    1. Log in to the Administration Portal.

    2. Click the **Hosts** tab. The failover host, `hosted_engine_1`, will be in maintenance mode and without a virtual load, as this was how it was prepared for the backup.

    3. Click **Remove**.

    4. Click **Ok**.

6. **Synchronizing the Host and the Engine**

    Return to the host and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - engine installation is complete

        [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
        [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
        [ INFO  ] Still waiting for VDSM host to become operational...

    At this point, `hosted_engine_1` will become visible in the Administration Portal with **Installing** and **Initializing** states before entering a **Non Operational** state. The host will continue to wait for the VDSM host to become operational until it eventually times out. This happens because another host in the environment maintains the Storage Pool Engine (SPM) role and `hosted_engine_1` cannot interact with the storage domain because the SPM host is in a **Non Responsive** state. When this process times out, you are prompted to shut down the virtual machine to complete the deployment. When deployment is complete, the host can be manually placed into maintenance mode and activated through the Administration Portal.

        [ INFO  ] Still waiting for VDSM host to become operational...
        [ ERROR ] Timed out while waiting for host to start. Please check the logs.
        [ ERROR ] Unable to add hosted_engine_2 to the manager
                  Please shutdown the VM allowing the system to launch it as a monitored service.
                  The system will wait until the VM is down.

7. Shut down the new Engine virtual machine.

        # shutdown -h now

8. Return to the host to confirm it has detected that the Engine virtual machine is down.

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

The environment has now been restored to a point where `hosted_engine_1` is active and is able to run virtual machines in the restored environment. The remaining hosted-engine hosts in **Non Operational** state can now be removed by following the steps in the Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment section below and then re-installed into the environment by following the steps in [Chapter 7: Installing Additional Hosts to a Self-Hosted Environment](../chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment).

**Note:** If the Engine database is restored successfully, but the Engine virtual machine appears to be **Down** and cannot be migrated to another self-hosted engine host, you can enable a new Engine virtual machine and remove the dead Engine virtual machine from the environment.

### Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment

Once a host has been fenced in the Administration Portal, it can be forcefully removed with a REST API request. This procedure will use *cURL*, a command line interface for sending requests to HTTP servers. Most Linux distributions include *cURL*. This procedure will connect to the Engine virtual machine to perform the relevant requests.

**Fencing the Non-Operational Host**

1. In the Administration Portal, right-click the hosts and select **Confirm 'Host has been Rebooted'**.

    Any virtual machines that were running on that host at the time of the backup will now be removed from that host, and move from an **Unknown** state to a **Down** state. The host that was fenced can now be forcefully removed using the REST API.

2. **Retrieving the Engine Certificate Authority**

    Connect to the Engine virtual machine and use the command line to perform the following requests with *cURL*.

    Use a `GET` request to retrieve the Engine Certificate Authority (CA) certificate for use in all future API requests. In the following example, the `--output` option is used to designate the file `hosted-engine.ca` as the output for the Engine CA certificate. The `--insecure` option means that this initial request will be without a certificate.

        # curl --output hosted-engine.ca --insecure https://[Engine.example.com]/ca.crt

3. **Retrieving the GUID of the Host to be Removed**

    Use a `GET` request on the hosts collection to retrieve the Global Unique Identifier (GUID) for the host to be removed. The following example includes the Engine CA certificate file, and uses the `admin@internal` user for authentication, the password for which will be prompted once the command is executed.

        # curl --request GET --cacert hosted-engine.ca --user admin@internal https://[Engine.example.com]/api/hosts

    This request returns the details of all of the hosts in the environment. The host GUID is a hexadecimal string associated with the host name.

4. **Removing the Fenced Host**

    Use a `DELETE` request using the GUID of the fenced host to remove the host from the environment. In addition to the previously used options this example specifies headers to specify that the request is to be sent and returned using eXtensible Markup Language (XML), and the body in XML that sets the `force` action to be `true`.

        curl --request DELETE --cacert hosted-engine.ca --user admin@internal --header "Content-Type: application/xml" --header "Accept: application/xml" --data "<action><force>true</force></action>" https://[Engine.example.com]/api/hosts/ecde42b0-de2f-48fe-aa23-1ebd5196b4a5</screen>

    This `DELETE` request can be used to remove every fenced host in the self-hosted engine environment, as long as the appropriate GUID is specified.

5. **Removing the Self-Hosted Engine Configuration from the Host**

    Remove the host's self-hosted engine configuration so it can be reconfigured when the host is re-installed to a self-hosted engine environment.

    Log in to the host and remove the configuration file:

        # rm /etc/ovirt-hosted-engine/hosted-engine.conf

The host can now be re-installed to the self-hosted engine environment.

**Prev:** [Chapter 5: Maintenance and Upgrading Resources](../chap-Maintenance_and_Upgrading_Resources) <br>
**Next:** [Chapter 7: Installing Additional Hosts to a Self-Hosted Environment](../chap-Installing_Additional_Hosts_to_a_Self-Hosted_Environment)

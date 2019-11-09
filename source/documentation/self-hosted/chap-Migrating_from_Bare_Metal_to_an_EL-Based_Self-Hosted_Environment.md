---
title: Migrating from Bare Metal to an EL-Based Self-Hosted Environment
---

# Chapter 4: Migrating from Bare Metal to an EL-Based Self-Hosted Environment

## Migrating to a Self-Hosted Environment

To migrate an existing instance of a standard oVirt to a self-hosted engine environment, use the `hosted-engine` script to assist with the task. The script asks you a series of questions, and configures your environment based on your answers. The Engine from the standard oVirt environment is referred to as the BareMetal-Engine in the following procedure.

The oVirt Engine Virtual Appliance shortens the process by reducing the required user interaction with the Engine virtual machine. However, although the appliance can automate `engine-setup` in a standard installation, in the migration process `engine-setup` must be run manually so that you can restore the BareMetal-Engine backup file on the new Engine virtual machine beforehand.

The migration involves the following key actions:

* Run the `hosted-engine` script to configure the host to be used as a self-hosted engine host and to create a new oVirt virtual machine.

* Back up the the engine database and configuration files using the `engine-backup` tool, copy the backup to the new Engine virtual machine, and restore the backup using the `--mode=restore` parameter of `engine-backup`. Run `engine-setup` to complete the Engine virtual machine configuration.

* Follow the `hosted-engine` script to complete the setup.

**Prerequisites**

* Prepare a new host with the `ovirt-hosted-engine-setup` package installed. See [Chapter 2: Deploying Self-Hosted Engine](chap-Deploying_Self-Hosted_Engine) for more information on subscriptions and package installation. The host must be a supported version of the current oVirt environment.

    **Note:** If you intend to use an existing host, place the host in maintenance and remove it from the existing environment. See "Removing a Host" in the [Administration Guide](/documentation/admin-guide/administration-guide/) for more information.

* Prepare storage for your self-hosted engine environment. The self-hosted engine requires a shared storage domain dedicated to the Engine virtual machine. This domain is created during deployment, and must be at least 68 GB.

    **Important:** If you are using iSCSI storage, do not use the same iSCSI target for the shared storage domain and data storage domain.

* Obtain the oVirt Engine Virtual Appliance by installing the `ovirt-engine-appliance` package. The oVirt Engine Virtual Appliance is always based on the latest supported Engine version. Ensure the Engine version in your current environment is updated to the latest supported Y-stream version as the Engine version needs to be the same for the migration.

* To use the oVirt Engine Virtual Appliance for the Engine installation, ensure one directory is at least 60 GB. The `hosted-engine` script first checks if `/var/tmp` has enough space to extract the appliance files. If not, you can specify a different directory or mount external storage. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

* The fully qualified domain name of the new Engine must be the same fully qualified domain name as that of the BareMetal-Engine. Forward and reverse lookup records must both be set in DNS.

* You must have access and can make changes to the BareMetal-Engine.

* The virtual machine to which the BareMetal-Engine is being migrated must have the same amount of RAM as the physical machine from which the BareMetal-Engine is being migrated.

**Migrating to a Self-Hosted Environment**

1. **Initiating a Self-Hosted Engine Deployment**

    **Note:** If your original installation was version 3.5 or earlier, and the name of the management network is **rhevm**, you must modify the answer file before running `hosted-engine --deploy --noansible`.

  Run the `hosted-engine` script. To escape the script at any time, use the **CTRL** + **D** keyboard combination to abort deployment. It is recommended to use the `screen` window manager to run the script to avoid losing the session in case of network or terminal disruption. If not already installed, install the `screen` package, which is available in the standard Red Hat Enterprise Linux repository.

        # yum install screen

        # screen

        # hosted-engine --deploy

    **Note:** In the event of session timeout or connection disruption, run `screen -d -r` to recover the `hosted-engine` deployment session.

2. **Configuring Storage**

   Select the type of storage to use.

        During customization use CTRL-D to abort.
        Please specify the storage you would like to use (glusterfs, iscsi, fc, nfs3, nfs4)[nfs3]:

    * For NFS storage types, specify the full address, using either the FQDN or IP address, and path name of the shared storage domain.

            Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/nfs

    * For iSCSI, specify the iSCSI portal IP address, port, user name and password, and select a target name from the auto-detected list. You can only select one iSCSI target during the deployment.

        **Note:** If you wish to specify more than one iSCSI target, you must enable multipathing before deploying the self-hosted engine. There is also a Multipath Helper tool that generates a script to install and configure multipath with different options.

            Please specify the iSCSI portal IP address:
            Please specify the iSCSI portal port [3260]:
            Please specify the iSCSI portal user:
            Please specify the iSCSI portal password:
            Please specify the target name (auto-detected values) [default]:

    * For Gluster storage, specify the full address, using either the FQDN or IP address, and path name of the shared storage domain.

        **Important:** Only replica 3 Gluster storage is supported. Ensure the following configuration has been made:


        * Configure the volume as follows as per [Gluster Volume Options for Virtual Machine Image Store](documentation/admin-guide/chap-Working_with_Gluster_Storage#Options set on Gluster Storage Volumes to Store Virtual Machine Images)


        <!-- comment ends bullet list so next line is parsed as pre -->

            Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/gluster_volume

    * For Fibre Channel, the host bus adapters must be configured and connected, and the `hosted-engine` script will auto-detect the LUNs available. The LUNs must not contain any existing data.

            The following luns have been found on the requested target:
            [1]     3514f0c5447600351       30GiB   XtremIO XtremApp
                                    status: used, paths: 2 active

            [2]     3514f0c5447600352       30GiB   XtremIO XtremApp
                                    status: used, paths: 2 active

            Please select the destination LUN (1, 2) [1]:

3. **Configuring the Network**

   The script detects possible network interface controllers (NICs) to use as a management bridge for the environment. It then checks your firewall configuration and offers to modify it for console (SPICE or VNC) access HostedEngine-VM. Provide a pingable gateway IP address, to be used by the `ovirt-ha-agent` to help determine a host's suitability for running HostedEngine-VM.

        Please indicate a nic to set rhvm bridge on: (eth1, eth0) [eth1]:
        iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]:
        Please indicate a pingable gateway IP address [X.X.X.X]:

4. **Configuring the Virtual Machine**

    The script creates a virtual machine to be configured as the oVirt Engine, referred to in this procedure as HostedEngine-VM. Select **disk** for the boot device type, and the script will automatically detect the oVirt Engine Appliances available. Select an appliance.

        Please specify the device to boot the VM from (choose disk for the oVirt engine appliance)
                 (cdrom, disk, pxe) [disk]:
                 Please specify the console type you would like to use to connect to the VM (vnc, spice) [vnc]: vnc
        [ INFO ] Detecting available oVirt engine appliances
                 The following appliance have been found on your system:
                       [1] - The oVirt Engine Appliance image (OVA)
                       [2] - Directly select an OVA file
                 Please select an appliance (1, 2) [1]:
        [ INFO ] Checking OVF archive content (could take a few minutes depending on archive size)

    Specify `Yes` if you want cloud-init to take care of the initial configuration of the Engine virtual machine. Specify **Generate** for cloud-init to take care of tasks like setting the root password, configuring networking, and configuring the host name. Optionally, select **Existing** if you have an existing cloud-init script to take care of more sophisticated functions of cloud-init. Specify the FQDN for the Engine virtual machine. This must be the same FQDN provided for the BareMetal-Engine.

    **Note:** For more information on cloud-init, see [https://cloudinit.readthedocs.org/en/latest/](https://cloudinit.readthedocs.org/en/latest/).

        Would you like to use cloud-init to customize the appliance on the first boot (Yes, No)[Yes]? Yes
        Would you like to generate on-fly a cloud-init no-cloud ISO image or do you have an existing one(Generate, Existing)[Generate]? Generate
        Please provide the FQDN you would like to use for the engine appliance.
        Note: This will be the FQDN of the engine VM you are now going to launch.
        It should not point to the base host or to any other existing machine.
        Engine VM FQDN: (leave it empty to skip): manager.example.com

    You must answer `No` to the following question so that you can restore the BareMetal-Engine backup file on HostedEngine-VM before running `engine-setup`.

        Automatically execute engine-setup on the engine appliance on first boot (Yes, No)[Yes]? No

    Configure the Engine domain name, root password, networking, hardware, and console access details.

        Enter root password that will be used for the engine appliance (leave it empty to skip): p@ssw0rd
        Confirm appliance root password: p@ssw0rd
        The following CPU types are supported by this host:
            - model_Penryn: Intel Penryn Family
            - model_Conroe: Intel Conroe Family
        Please specify the CPU type to be used by the VM [model_Penryn]:
        Please specify the number of virtual CPUs for the VM [Defaults to appliance OVF value: 4]:
        You may specify a MAC address for the VM or accept a randomly generated default [00:16:3e:77:b2:a4]:
        How should the engine VM network be configured (DHCP, Static)[DHCP]? Static
        Please enter the IP address to be used for the engine VM: 192.168.x.x
        Please provide a comma-separated list (max3) of IP addresses of domain name servers for the engine VM
        Engine VM DNS (leave it empty to skip):
        Add lines for the appliance itself and for this host to /etc/hosts on the engine VM?
        Note: ensuring that this host could resolve the engine VM hostname is still up to you (Yes, No)[No] Yes

5. **Configuring the Self-Hosted Engine**

    Specify the name for Host-HE1 to be identified in the oVirt environment, and the password for the `admin@internal` user to access the Administration Portal. Finally, provide the name and TCP port number of the SMTP server, the email address used to send email notifications, and a comma-separated list of email addresses to receive these notifications.

        Enter engine admin password: p@ssw0rd
        Confirm engine admin password: p@ssw0rd
        Enter the name which will be used to identify this host inside the Administrator Portal [hosted_engine_1]:
        Please provide the FQDN for the engine you would like to use.
                  This needs to match the FQDN that you will use for the engine installation within the VM.
                  Note: This will be the FQDN of the VM you are now going to create,
                  it should not point to the base host or to any other existing machine.
                  Engine FQDN:  []: manager.example.com
        Please provide the name of the SMTP server through which we will send notifications [localhost]:
        Please provide the TCP port number of the SMTP server [25]:
        Please provide the email address from which notifications will be sent [root@localhost]:
        Please provide a comma-separated list of email addresses which will get notifications [root@localhost]:

6. **Configuration Preview**

    Before proceeding, the `hosted-engine` script displays the configuration values you have entered, and prompts for confirmation to proceed with these values.

        Bridge interface                 : eth1
        Engine FQDN                      : manager.example.com
        Bridge name                      : ovirtmgmt
        Host address                     : host.example.com
        SSH daemon port                  : 22
        Firewall manager                 : iptables
        Gateway address                  : X.X.X.X
        Host name for web application    : Host-HE1
        Host ID                          : 1
        Image size GB                    : 50
        Storage connection               : storage.example.com:/hosted_engine/nfs
        Console type                     : vnc
        Memory size MB                   : 4096
        MAC address                      : 00:16:3e:77:b2:a4
        Boot type                        : pxe
        Number of CPUs                   : 2
        CPU Type                         : model_Penryn

        Please confirm installation settings (Yes, No)[Yes]:

7. **Creating HostedEngine-VM**

    The script creates the virtual machine to be configured as HostedEngine-VM and provides connection details. You must manually run `engine-setup` after restoring the backup file on HostedEngine-VM before the `hosted-engine` script can proceed on Host-HE1.

        [ INFO  ] Stage: Transaction setup
        ...
        [ INFO  ] Creating VM
                  You can now connect to the VM with the following command:
                          /bin/remote-viewer vnc://localhost:5900
                  Use temporary password "3463VnKn" to connect to vnc console.
                  Please note that in order to use remote-viewer you need to be able to run graphical applications.
                  This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
                  Otherwise you can run the command from a terminal in your preferred desktop environment.
                  If you cannot run graphical applications you can connect to the graphic console from another host or connect to the serial console using the following command:
                  socat UNIX-CONNECT:/var/run/ovirt-vmconsole-console/8f74b589-8c6f-4a32-9adf-6e615b69de07.sock,user=ovirt-vmconsole STDIO,raw,echo=0,escape=1
                  Please ensure that your Guest OS is properly configured to support serial console according to your distro documentation.
                  Follow http://www.ovirt.org/Serial_Console_Setup#I_need_to_access_the_console_the_old_way for more info.
                  If you need to reboot the VM you will need to start it manually using the command:
                  hosted-engine --vm-start
                  You can then set a temporary password using the command:
                  hosted-engine --add-console-password
                  Please install and setup the engine in the VM.
                  You may also be interested in subscribing to "agent" RHN/Satellite channel and installing rhevm-guest-agent-common package in the VM.


                  The VM has been rebooted.
                  To continue please install oVirt-Engine in the VM
                  (Follow http://www.ovirt.org/Quick_Start_Guide for more info).

                  Make a selection from the options below:
                  (1) Continue setup - oVirt-Engine installation is ready and ovirt-engine service is up
                  (2) Abort setup
                  (3) Power off and restart the VM
                  (4) Destroy VM and abort setup

                  (1, 2, 3, 4)[1]:
    Connect to the virtual machine using the VNC protocol with the following command. Replace FQDN with the fully qualified domain name or the IP address of the self-hosted engine host.

        # /bin/remote-viewer vnc://FQDN:5900

8. **Enabling SSH on HostedEngine-VM**

    SSH password authentication is not enabled by default on the oVirt Engine Virtual Appliance. Connect to HostedEngine-VM via VNC and enable SSH password authentication so that you can access the virtual machine via SSH later to restore the BareMetal-Engine backup file and configure the new Engine. Verify that the `sshd` service is running. Edit `/etc/ssh/sshd_config` and change the following two options to `yes`:

        [...]
        PermitRootLogin yes
        [...]
        PasswordAuthentication yes

    Restart the `sshd` service for the changes to take effect.

        # systemctl restart sshd.service

9. **Disabling BareMetal-Engine**

    Connect to BareMetal-Engine, the Engine of your established oVirt environment, and stop the engine and prevent it from running.

        # systemctl stop ovirt-engine.service
        # systemctl disable ovirt-engine.service

    **Note:** Though stopping BareMetal-Engine from running is not obligatory, it is recommended as it ensures no changes will be made to the environment after the backup has been created. Additionally, it prevents BareMetal-Engine and HostedEngine-VM from simultaneously managing existing resources.

10. **Updating DNS**

    Update your DNS so that the FQDN of the oVirt environment correlates to the IP address of HostedEngine-VM and the FQDN previously provided when configuring the `hosted-engine` deployment script on Host-HE1. In this procedure, FQDN was set as `manager.example.com` because in a migrated hosted-engine setup, the FQDN provided for the engine must be identical to that given in the engine setup of the original engine.

11. **Creating a Backup of BareMetal-Engine**

    Connect to BareMetal-Engine and run the `engine-backup` command with the `--mode=backup`, `--file=FILE`, and `--log=LogFILE` parameters to specify the backup mode, the name of the backup file created and used for the backup, and the name of the log file to be created to store the backup log.

        # engine-backup --mode=backup --file=FILE --log=LogFILE

12. **Copying the Backup File to HostedEngine-VM**

    On BareMetal-Engine, secure copy the backup file to HostedEngine-VM. In the following example, `manager.example.com` is the FQDN for HostedEngine-VM, and `/backup/` is any designated folder or path. If the designated folder or path does not exist, you must connect to HostedEngine-VM and create it before secure copying the backup from BareMetal-Engine.

        # scp -p FILE LogFILE manager.example.com:/backup/

13. **Restoring the Backup File on HostedEngine-VM**

    Use the `engine-backup` tool to restore a complete backup. If you configured the BareMetal-Engine database(s) manually during `engine-setup`, follow the instructions at [Restoring the Self-Hosted Engine Engine Manually](Restoring_the_Self-Hosted_Engine_Engine_Manually) to restore the backup environment manually.

     * If you are only restoring the Engine, run:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --restore-permissions

    * If you are restoring the Engine and Data Warehouse, run:

            # engine-backup --mode=restore --file=file_name --log=log_file_name --provision-db --provision-dwh-db --restore-permissions

    If successful, the following output displays:

        You should now run engine-setup.
        Done.

14. **Configuring HostedEngine-VM**

    Configure the restored Engine virtual machine. This process identifies the existing configuration settings and database content. Confirm the settings. Upon completion, the setup provides an SSH fingerprint and an internal Certificate Authority hash.

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


                  --== PKI CONFIGURATION ==--


                  --== APACHE CONFIGURATION ==--


                  --== SYSTEM CONFIGURATION ==--


                  --== END OF CONFIGURATION ==--

        [ INFO  ] Stage: Setup validation
        [ INFO  ] Cleaning stale zombie tasks

                  --== CONFIGURATION PREVIEW ==--

                  Default SAN wipe after delete           : False
                  Firewall manager                        : iptables
                  Update Firewall                         : True
                  Host FQDN                               : manager.example.com
                  Engine database secured connection      : False
                  Engine database host                    : X.X.X.X
                  Engine database user name               : engine
                  Engine database name                    : engine
                  Engine database port                    : 5432
                  Engine database host name validation    : False
                  Engine installation                     : True
                  PKI organization                        : example.com
                  NFS mount point                         : /var/lib/exports/iso
                  Configure VMConsole Proxy               : True
                  Engine Host FQDN                        : manager.example.com
                  Configure WebSocket Proxy               : True

                  Please confirm installation settings (OK, Cancel) [OK]:

15. **Synchronizing the Host and the Engine**

    Return to Host-HE1 and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - oVirt-Engine installation is ready and ovirt-engine service is up

    The script displays the internal Certificate Authority hash, and prompts you to select the cluster to which to add Host-HE1.

        [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
        [ INFO  ] Acquiring internal CA cert from the engine
        [ INFO  ] The following CA certificate is going to be used, please immediately interrupt if not correct:
        [ INFO  ] Issuer: C=US, O=example.com, CN=manager.example.com.23240, Subject: C=US, O=example.com, CN=manager.example.com.23240, Fingerprint (SHA-1): XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        [ INFO  ] Connecting to the Engine
                  Enter the name of the cluster to which you want to add the host (DB1, DB2, Default) [Default]:
        [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
        [ INFO  ] The VDSM Host is now operational
        [ INFO  ] Saving hosted-engine configuration on the shared storage domain
                  Please shutdown the VM allowing the system to launch it as a monitored service.
                  The system will wait until the VM is down.

16. **Shutting Down HostedEngine-VM**

    Shut down HostedEngine-VM.

        # shutdown -h now

17. **Setup Confirmation**

    Return to Host-HE1 to confirm it has detected that HostedEngine-VM is down.

        [ INFO  ] Enabling and starting HA services
        [ INFO  ] Stage: Clean up
        [ INFO  ] Generating answer file '/var/lib/ovirt-hosted-engine-setup/answers/answers-20160509162843.conf'
        [ INFO  ] Generating answer file '/etc/ovirt-hosted-engine/answers.conf'
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination
        [ INFO  ] Hosted Engine successfully set up

Your oVirt Engine has been migrated to a self-hosted engine setup. The Engine is now operating on a virtual machine on Host-HE1, called HostedEngine-VM in the environment. As HostedEngine-VM is highly available, it is migrated to other hosts in the environment when applicable.

**Prev:** [Chapter 3: Troubleshooting](chap-Troubleshooting) <br>
**Next:** [Chapter 5: Administering the Self-Hosted Engine](chap-Maintenance_and_Upgrading_Resources)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/self-hosted_engine_guide/chap-migrating_from_bare_metal_to_a_rhel-based_self-hosted_environment)

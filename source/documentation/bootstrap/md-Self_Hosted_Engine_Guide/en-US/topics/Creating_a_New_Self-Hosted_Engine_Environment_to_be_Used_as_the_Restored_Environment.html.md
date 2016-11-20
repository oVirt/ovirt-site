# Creating a New Self-Hosted Engine Environment to be Used as the Restored Environment

You can restore a self-hosted engine on hardware that was used in the backed-up environment. However, you must use the failover host for the restored deployment. The failover host, `Host 1`, used in [Backing up the Self-Hosted Engine Manager Virtual Machine](Backing_up_the_Self-Hosted_Engine_Manager_Virtual_Machine) uses the default hostname of `hosted_engine_1` which is also used in this procedure. Due to the nature of the restore process for the self-hosted engine, before the final synchronization of the restored engine can take place, this failover host will need to be removed, and this can only be achieved if the host had no virtual load when the backup was taken. You can also restore the backup on a separate hardware which was not used in the backed up environment and this is not a concern.

**Important:** This procedure assumes that you have a freshly installed Red Hat Enterprise Linux system on a physical host, have subscribed the host to the required entitlements, and installed the `ovirt-hosted-engine-setup` package. See [Subscribing to the Required Entitlements](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/installation-guide/72-subscribing-to-the-required-entitlements) in the *Installation Guide* and [Installing the Self-Hosted Engine](Installing_the_Self-Hosted_Engine) for more information.

**Creating a New Self-Hosted Environment to be Used as the Restored Environment**

1. **Updating DNS**

    Update your DNS so that the fully qualified domain name of the Red Hat Virtualization environment correlates to the IP address of the new Manager. In this procedure, fully qualified domain name was set as `Manager.example.com`. The fully qualified domain name provided for the engine must be identical to that given in the engine setup of the original engine that was backed up.

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

    The script detects possible network interface controllers (NICs) to use as a management bridge for the environment. It then checks your firewall configuration and offers to modify it for console (SPICE or VNC) access the Manager virtual machine. Provide a pingable gateway IP address, to be used by the `ovirt-ha-agent`, to help determine a host's suitability for running a Manager virtual machine.

        Please indicate a nic to set ovirtmgmt bridge on: (eth1, eth0) [eth1]:
        iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]: 
        Please indicate a pingable gateway IP address [X.X.X.X]: 

6. **Configuring the New Manager Virtual Machine**

    The script creates a virtual machine to be configured as the new Manager virtual machine. Specify the boot device and, if applicable, the path name of the installation media, the image alias, the CPU type, the number of virtual CPUs, and the disk size. Specify a MAC address for the Manager virtual machine, or accept a randomly generated one. The MAC address can be used to update your DHCP server prior to installing the operating system on the Manager virtual machine. Specify memory size and console connection type for the creation of Manager virtual machine.

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

    Provide the fully qualified domain name for the new Manager virtual machine. This procedure uses the fully qualified domain name `Manager.example.com`. Provide the name and TCP port number of the SMTP server, the email address used to send email notifications, and a comma-separated list of email addresses to receive these notifications.


    **Important:** The fully qualified domain name provided for the engine (`Manager.example.com`) must be the same fully qualified domain name provided when original Manager was initially set up.

        Please provide the FQDN for the engine you would like to use.
        This needs to match the FQDN that you will use for the engine installation within the VM.
         Note: This will be the FQDN of the VM you are now going to create,
         it should not point to the base host or to any other existing machine.
         Engine FQDN: Manager.example.com
        Please provide the name of the SMTP server through which we will send notifications [localhost]: 
        Please provide the TCP port number of the SMTP server [25]: 
        Please provide the email address from which notifications will be sent [root@localhost]: 
        Please provide a comma-separated list of email addresses which will get notifications [root@localhost]:

9. **Configuration Preview**

    Before proceeding, the `hosted-engine` deployment script displays the configuration values you have entered, and prompts for confirmation to proceed with these values.

        Bridge interface                   : eth1
        Engine FQDN                        : Manager.example.com
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

10. **Creating the New Manager Virtual Machine**

    The script creates the virtual machine to be configured as the Manager virtual machine and provides connection details. You must install an operating system on it before the `hosted-engine` deployment script can proceed on Hosted Engine configuration.

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

    Connect to Manager virtual machine and install a Red Hat Enterprise Linux 7 operating system.

12. **Synchronizing the Host and the Manager**

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
        You may also be interested in subscribing to "agent" RHN/Satellite channel and installing rhevm-guest-agent-common package in the VM.
        To continue make a selection from the options below:
          (1) Continue setup - engine installation is complete
          (2) Power off and restart the VM
          (3) Abort setup
          (4) Destroy VM and abort setup
        
          (1, 2, 3, 4)[1]:

13. **Installing the Manager**

    Connect to new Manager virtual machine, ensure the latest versions of all installed packages are in use, and install the `rhevm` packages.

        # yum update

    **Note:** Reboot the machine if any kernel related packages have been updated. 

        # yum install rhevm

After the packages have completed installation, you will be able to continue with restoring the self-hosted engine Manager.


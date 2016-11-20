# Configuring a RHEL-Based Self-Hosted Engine

The `hosted-engine` script is provided to assist with configuring the host, and the Manager virtual machine. The script asks you a series of questions, and configures your environment based on your answers.

Ensure that you have completed the following prerequisites: 

**Prerequisites**

* You must have a freshly installed Red Hat Enterprise Linux 7 system with the `ovirt-hosted-engine-setup` package installed.

* You must have prepared storage for your self-hosted engine environment. For more information on preparing storage for your deployment, see the [Storage chapter](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#chap-Storage) of the *Administration Guide*.

* You must have a fully qualified domain name prepared for your Manager and the host. Forward and reverse lookup records must both be set in the DNS.

* You must have prepared the RHV-M Virtual Appliance for the Manager installation. Obtain the RHV-M Virtual Appliance by installing the `rhevm-appliance` package. Other methods of installing the Manager virtual machine operating system are not supported.

* To use the RHV-M Virtual Appliance for the Manager installation, one directory must be at least 60 GB. The `hosted-engine` script first checks if `/var/tmp` has enough space to extract the appliance files. If not, you can specify a different directory or mount external storage. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

**Configuring a RHEL-based Self-Hosted Engine**

1. **Initiating Hosted Engine Deployment**

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

        <!-- comment ends list so line below is pre -->

            Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/gluster_volume

    * For Fibre Channel, the host bus adapters must be configured and connected, and the `hosted-engine` script will auto-detect the LUNs available. The LUNs must not contain any existing data.

            The following luns have been found on the requested target:
            [1]     3514f0c5447600351       30GiB   XtremIO XtremApp
                                    status: used, paths: 2 active
            
            [2]     3514f0c5447600352       30GiB   XtremIO XtremApp
                                    status: used, paths: 2 active
            
            Please select the destination LUN (1, 2) [1]:

3. **Configuring the Network**

    The script detects possible network interface controllers (NICs) to use as a management bridge for the environment. It then checks your firewall configuration and offers to modify it for console (SPICE or VNC) access.

        Please indicate a nic to set rhvm bridge on: (eth1, eth0) [eth1]:
        iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]: Yes
        Please indicate a pingable gateway IP address [X.X.X.X]:

4. **Configuring the Virtual Machine**

    Select **disk** for the boot device type, and the script will automatically detect the RHV-M Virtual Appliances available. Specify the memory size.

                 Please specify the device to boot the VM from (choose disk for the oVirt engine appliance) 
                 (cdrom, disk, pxe) [disk]: 
                 Please specify the console type you would like to use to connect to the VM (vnc, spice) [vnc]: vnc
        [ INFO ] Detecting available oVirt engine appliances
                 The following appliance have been found on your system:
                       [1] - The oVirt Engine Appliance image (OVA)
                       [2] - Directly select an OVA file
                 Please select an appliance (1, 2) [1]:
        [ INFO ] Checking OVF archive content (could take a few minutes depending on archive size)</screen>

    Specify `Yes` if you want cloud-init to take care of the initial configuration of the Manager virtual machine. Specify **Generate** for cloud-init to take care of tasks like setting the root password, configuring networking, configuring the host name, injecting an answers file for `engine-setup` to use, and running `engine-setup` on boot. Optionally, select **Existing** if you have an existing cloud-init script to take care of more sophisticated functions of cloud-init. Specify the FQDN for the Manager virtual machine. Specify a MAC address for the HostedEngine-VM, or accept a randomly generated one. The MAC address can be used to update your DHCP and DNS server prior to installing the operating system on the virtual machine.

    **Note:** For more information on cloud-init, see [https://cloudinit.readthedocs.org/en/latest/](https://cloudinit.readthedocs.org/en/latest/).

        Would you like to use cloud-init to customize the appliance on the first boot (Yes, No)[Yes]? Yes
        Would you like to generate on-fly a cloud-init ISO image (of no-cloud type)
        or do you have an existing one (Generate, Existing)[Generate]? Generate
        Please provide the FQDN you would like to use for the engine appliance.
        Note: This will be the FQDN of the engine VM you are now going to launch.
        It should not point to the base host or to any other existing machine.
        Engine VM FQDN: (leave it empty to skip): manager.example.com
        Automatically execute engine-setup on the engine appliance on first boot (Yes, No)[Yes]? Yes
        Automatically restart the engine VM as a monitored service after engine-setup (Yes, No)[Yes]? Yes
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
        Note: ensuring that this host could resolve the engine VM hostname is still up to you (Yes, No)[No] Yes</screen>

5. **Configuring the Hosted Engine**

    Specify a name for the host to be identified in the Administration Portal, and the password for the `admin@internal` user to access the Administration Portal. Provide the name and TCP port number of the SMTP server, the email address used to send email notifications, and a comma-separated list of email addresses to receive these notifications.

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
        Please provide a comma-separated list of email addresses which will get notifications [root@localhost]:</screen>

6. **Configuration Preview**

    Before proceeding, the `hosted-engine` script displays the configuration values you have entered, and prompts for confirmation to proceed with these values.

7. **Creating the Manager Virtual Machine**

    The script creates the Manager virtual machine, starts the `ovirt-engine` and high availability services, and connects the host and shared storage domain to the Manager virtual machine.

        You can now connect to the VM with the following command:
         /usr/bin/remote-viewer vnc://localhost:5900
        Use temporary password "3042QHpX" to connect to vnc console.
        Please note that in order to use remote-viewer you need to be able to run graphical applications.
        This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
        Otherwise you can run the command from a terminal in your preferred desktop environment.
        If you cannot run graphical applications you can connect to the graphic console from another host or connect to the serial console using the following command:
        socat UNIX-CONNECT:/var/run/ovirt-vmconsole-console/fabbea5a-1989-411f-8ed7-7abe0917fc66.sock,user=ovirt-vmconsole STDIO,raw,echo=0,escape=1
        If you need to reboot the VM you will need to start it manually using the command:
        hosted-engine --vm-start
        You can then set a temporary password using the command:
        hosted-engine --add-console-password
        [ INFO ] Running engine-setup on the appliance
        ...
        [ INFO ] Engine-setup successfully completed
        [ INFO ] Engine is still unreachable
        [ INFO ] Engine is still unreachable, waiting...
        [ INFO ] Engine replied: DB Up!Welcome to Health Status!
        [ INFO ] Connecting to the Engine
                 Enter the name of the cluster to which you want to add the host (Default) [Default]:
        [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes... [ INFO  ] Still waiting for VDSM host to become operational...
        [ INFO  ] The VDSM Host is now operational      
        [ INFO  ] Shutting down the engine VM
        [ INFO  ] Enabling and starting HA services
        [ INFO  ] Saving hosted-engine configuration on the shared storage domain
                  Hosted Engine successfully set up
        [ INFO  ] Stage: Clean up
        [ INFO  ] Generating answer file '/var/lib/ovirt-hosted-engine-setup/answers/answers-2015xx.conf'
        [ INFO  ] Generating answer file '/etc/ovirt-hosted-engine/answers.conf'
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination</screen>

When the `hosted-engine` deployment script completes successfully, the Red Hat Virtualization Manager is configured and running on your host. The Manager has already configured the data center, cluster, host, the Manager virtual machine, and a shared storage domain dedicated to the Manager virtual machine.

**Important:** Log in as the **admin@internal** user to continue configuring the Manager and add further resources. You must create another data domain for the data center to be initialized to host regular virtual machine data, and for the Manager virtual machine to be visible. See [Storage](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#chap-Storage) in the *Administration Guide* for different storage options and on how to add a data storage domain.

Link your Red Hat Virtualization Manager to a directory server so you can add additional users to the environment. Red Hat Virtualization supports many directory server types; for example, Red Hat Directory Server (RHDS), Red Hat Identity Management (IdM), Active Directory, and many other types. Add a directory server to your environment using the `ovirt-engine-extension-aaa-ldap-setup` interactive setup script. For more information, see [Configuring an External LDAP Provider](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#sect-Configuring_an_External_LDAP_Provider) in the *Administration Guide*.

The `ovirt-hosted-engine-setup` script also saves the answers you gave during configuration to a file, to help with disaster recovery. If a destination is not specified using the `--generate-answer=<file>` argument, the answer file is generated at `/etc/ovirt-hosted-engine/answers.conf`.

**Note:** SSH password authentication is not enabled by default on the RHV-M Virtual Appliance. You can enable SSH password authentication by accessing the Red Hat Virtualization Manager virtual machine through the SPICE or VNC console. Verify that the `sshd` service is running. Edit `/etc/ssh/sshd_config` and change the following two options to `yes`: 

* `PasswordAuthentication`
* `PermitRootLogin`

**Note:** Restart the `sshd` service for the changes to take effect.

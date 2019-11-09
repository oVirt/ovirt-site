---
title: Deploying the Self-Hosted Engine
---

# Chapter 2: Deploying the Self-Hosted Engine

You can deploy a self-hosted engine from the command line, or through the Cockpit user interface. Cockpit is available by default on oVirt Hosts, and can be installed on Enterprise Linux hosts. Both methods use Ansible to automate most of the process.

Self-hosted engine installation uses the oVirt Engine Appliance to create the Engine virtual machine. The appliance is installed during the deployment process; however, you can install it on the host before starting the deployment if required:

        # yum install ovirt-engine-appliance

If you plan to use bonded interfaces for high availability or VLANs to separate different types of traffic (for example, for storage or management connections), you should configure them before deployment.

## Deploying Self-Hosted Engine Using Cockpit

You can deploy a self-hosted engine through Cockpit using a simplified wizard to collect the details of your environment. This is the recommended method.

Cockpit is enabled by default on oVirt Nodes. If you are using a Enterprise Linux host, see Installing Cockpit on Enterprise Linux Hosts in the Installation Guide.

**Prerequisites**

* A fresh installation of oVirt Node or Enterprise Linux 7, with the required repositories enabled. See Installing oVirt Node or Enabling the Enterprise Linux Host Repositories in the Installation Guide.

* A fully qualified domain name prepared for your Engine and the host. Forward and reverse lookup records must both be set in the DNS.

* A directory of at least 5 GB on the host, for the oVirt Engine Appliance. The deployment process will check if /var/tmp has enough space to extract the appliance files. If not, you can specify a different directory or mount external storage. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

* Prepared storage for a data storage domain dedicated to the Engine virtual machine. This storage domain is created during the self-hosted engine deployment, and must be at least 74 GiB. Highly available storage is recommended. For more information on preparing storage for your deployment, see the Storage chapter of the Administration Guide.

    **Warning:** The oVirt Project strongly recommends that you have additional active data storage domains available in the same data center as the self-hosted engine storage domain.

    If you deploy the self-hosted engine in a data center with only one active data storage domain, and if that data storage domain is corrupted, you will be unable to add new data storage domains or to remove the corrupted data storage domain. You will have to redeploy the self-hosted engine.

    **Important:** If you are using iSCSI storage, do not use the same iSCSI target for the self-hosted engine storage domain and any additional storage domains.

**Procedure**

1. Log in to Cockpit at https://HostIPorFQDN:9090 and click **Virtualization** &rarr; **Hosted Engine**.

2. Click Start under the **Hosted Engine** option.

3. Enter the details for the Engine virtual machine:

  i. Enter the **Engine VM FQDN**. This is the FQDN for the Engine virtual machine, not the base host.

  ii. Enter a **MAC Address** for the Engine virtual machine, or accept a randomly generated one.

  iii. Choose either **DHCP** or **Static** from the **Network Configuration** drop-down list.

   If you choose **DHCP**, you must have a DHCP reservation for the Engine virtual machine so that its host name resolves to the address received from DHCP. Specify its MAC address in the **MAC Address** field.

   If you choose **Static**, enter the following details:

   * VM IP Address - The IP address must belong to the same subnet as the host. For example, if the host is in 10.1.1.0/24, the Engine virtual machine’s IP must be in the same subnet range (10.1.1.1-254/24).

   * Gateway Address

   * DNS Servers

  iv. Select the **Bridge Interface** from the drop-down list.

  v. Enter and confirm the virtual machine’s **Root Password**.

  vi. Specify whether to allow **Root SSH Access**.

  vii. Enter the **Number of Virtual CPUs** for the virtual machine.

  viii. Enter the **Memory Size (MiB)**. The available memory is displayed next to the input field.

4. Optionally expand the Advanced fields:

  i. Enter a **Root SSH Public Key** to use for root access to the Engine virtual machine.

  ii. Select or clear the **Edit Hosts File** check box to specify whether to add entries for the Engine virtual machine and the base host to the virtual machine’s **/etc/hosts** file. You must ensure that the host names are resolvable.

  iii. Change the management **Bridge Name**, or accept the default `ovirtmgmt`.

  iv. Enter the **Gateway Address** for the management bridge.

  v. Enter the **Host FQDN** of the first host to add to the Engine. This is the FQDN of the base host you are running the deployment on.

5. Click **Next**.

6. Enter and confirm the **Admin Portal Password** for the `admin@internal` user.

7. Configure event notifications:

i. Enter the **Server Name** and **Server Port Number** of the SMTP server.

ii. Enter the **Sender E-Mail Address**.

iii. Enter the **Recipient E-Mail Addresses**.

8. Click **Next**.

9. Review the configuration of the Engine and its virtual machine. If the details are correct, click **Prepare VM**.

10. When the virtual machine installation is complete, click **Next**.

11. Select the **Storage Type** from the drop-down list, and enter the details for the self-hosted engine storage domain:

  * For NFS:

    i. Enter the full address and path to the storage in the **Storage Connection** field.

    ii. If required, enter any **Mount Options**.

    iii. Enter the **Disk Size (GiB)**.

    iv. Select the **NFS Version** from the drop-down list.

    v. Enter the **Storage Domain Name**.

  * For iSCSI:

    i. Enter the **Portal IP Address**, **Portal Port**, **Portal Username**, and **Portal Password**.

    ii. Click **Retrieve Target** List and select a target. You can only select one iSCSI target during the deployment, but multipathing is supported to connect all portals of the same portal group.

       **Note:** To specify more than one iSCSI target, you must enable multipathing before deploying the self-hosted engine. There is also a Multipath Helper tool that generates a script to install and configure multipath with different options.

    iii. Enter the **Disk Size (GiB)**.

    iv. Enter the **Discovery Username** and **Discovery Password**.

  * For Fibre Channel:

    i. Enter the **LUN ID**. The host bus adapters must be configured and connected, and the LUN must not contain any existing data.

    ii. Enter the **Disk Size (GiB)**.

  * For Gluster Storage:

    i. Enter the full address and path to the storage in the **Storage Connection** field.

    ii. If required, enter any **Mount Options**.

    iii. Enter the **Disk Size (GiB)**.

12. Click Next.

13. Review the storage configuration. If the details are correct, click **Finish Deployment**.

14. When the deployment is complete, click **Close**.

    One data center, cluster, host, storage domain, and the Engine virtual machine are already running. You can log in to the Administration Portal to add any other resources.

15. Enable the required repositories on the Engine virtual machine.

16. Optionally, add a directory server using the `ovirt-engine-extension-aaa-ldap-setup` interactive setup script so you can add additional users to the environment.

The self-hosted engine’s status is displayed in Cockpit’s **Virtualization** &rarr; **Hosted Engine** tab. The Engine virtual machine, the host running it, and the self-hosted engine storage domain are flagged with a gold crown in the Administration Portal.

## Deploying the Self-Hosted Engine Using the Command line

You can deploy a self-hosted engine from the command line using `hosted-engine --deploy` to collect the details of your environment.

**Note:** If necessary, you can still use the non-Ansible script from previous versions of oVirt by running `hosted-engine --deploy --noansible`.

**Prerequisites**

* A fresh installation of oVirt Node or Enterprise Linux 7, with the required repositories enabled. See Installing oVirt Node or Enabling the Enterprise Linux Host Repositories in the Installation Guide.

* A fully qualified domain name prepared for your Engine and the host. Forward and reverse lookup records must both be set in the DNS.

* A directory of at least 5 GB on the host, for the oVirt Engine Appliance. The deployment process will check if /var/tmp has enough space to extract the appliance files. If not, you can specify a different directory or mount external storage. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

* Prepared storage for a data storage domain dedicated to the Engine virtual machine. This storage domain is created during the self-hosted engine deployment, and must be at least 74 GiB. Highly available storage is recommended. For more information on preparing storage for your deployment, see the Storage chapter of the Administration Guide.

    **Warning:** The oVirt Project strongly recommends that you have additional active data storage domains available in the same data center as the self-hosted engine storage domain.

     If you deploy the self-hosted engine in a data center with only one active data storage domain, and if that data storage domain is corrupted, you will be unable to add new data storage domains or to remove the corrupted data storage domain. You will have to redeploy the self-hosted engine.

    **Important:** If you are using iSCSI storage, do not use the same iSCSI target for the self-hosted engine storage domain and any additional storage domains.

**Procedure**

1. Install the deployment tool:

        # yum install ovirt-hosted-engine-setup

2. The oVirt Project recommends using the screen window manager to run the script to avoid losing the session in case of network or terminal disruption. Install and start screen:

        # yum install screen
        # screen

3. Start the deployment script:

        # hosted-engine --deploy

    **Note:** To escape the script at any time, use the `Ctrl+D` keyboard combination to abort deployment. In the event of session timeout or connection disruption, run `screen -d -r` to recover the deployment session.

4. Select **Yes** to begin the deployment:

        Continuing will configure this host for serving as hypervisor and create a local VM with a running engine.
        The locally running engine will be used to configure a storage domain and create a VM there.
        At the end the disk of the local VM will be moved to the shared storage.
        Are you sure you want to continue? (Yes, No)[Yes]:

5. Configure the network. The script detects possible NICs to use as a management bridge for the environment.

        Please indicate a pingable gateway IP address [X.X.X.X]:
        Please indicate a nic to set ovirtmgmt bridge on: (eth1, eth0) [eth1]:

6. If you want to use a custom appliance for the virtual machine installation, enter the path to the OVA archive. Otherwise, leave this field empty to use the oVirt Engine Appliance.

        If you want to deploy with a custom engine appliance image,
        please specify the path to the OVA archive you would like to use
        (leave it empty to skip, the setup will use ovirt-engine-appliance rpm installing it if missing):

7. Specify the FQDN for the Engine virtual machine:

        Please provide the FQDN you would like to use for the engine appliance.
        Note: This will be the FQDN of the engine VM you are now going to launch,
        it should not point to the base host or to any other existing machine.
        Engine VM FQDN:  manager.example.com
        Please provide the domain name you would like to use for the engine appliance.
        Engine VM domain: [example.com]

8. Enter the root password for the Engine:

        Enter root password that will be used for the engine appliance:
        Confirm appliance root password:

9. Enter an SSH public key that will allow you to log in to the Engine as the root user, and specify whether to enable SSH access for the root user:

        Enter ssh public key for the root user that will be used for the engine appliance (leave it empty to skip):
        Do you want to enable ssh access for the root user (yes, no, without-password) [yes]:

10. Enter the virtual machine’s CPU and memory configuration:

        Please specify the number of virtual CPUs for the VM (Defaults to appliance OVF value): [4]:
        Please specify the memory size of the VM in MB (Defaults to maximum available): [7267]:

11. Enter a MAC address for the Engine virtual machine, or accept a randomly generated one. If you want to provide the Engine virtual machine with an IP address via DHCP, ensure that you have a valid DHCP reservation for this MAC address. The deployment script will not configure the DHCP server for you.

        You may specify a unicast MAC address for the VM or accept a randomly generated default [00:16:3e:3d:34:47]:

12. Enter the virtual machine’s networking details:

        How should the engine VM network be configured (DHCP, Static)[DHCP]?

    If you specified **Static**, enter the IP address of the Engine:

    **Important:** The static IP address must belong to the same subnet as the host. For example, if the host is in 10.1.1.0/24, the Engine virtual machine’s IP must be in the same subnet range (10.1.1.1-254/24).

        Please enter the IP address to be used for the engine VM [x.x.x.x]:
        Please provide a comma-separated list (max 3) of IP addresses of domain name servers for the engine VM
        Engine VM DNS (leave it empty to skip):

13. Specify whether to add entries for the Engine virtual machine and the base host to the virtual machine’s /etc/hosts file. You must ensure that the host names are resolvable.

        Add lines for the appliance itself and for this host to /etc/hosts on the engine VM?
        Note: ensuring that this host could resolve the engine VM hostname is still up to you (Yes, No)[No]

14. Provide the name and TCP port number of the SMTP server, the email address used to send email notifications, and a comma-separated list of email addresses to receive these notifications:

        Please provide the name of the SMTP server through which we will send notifications [localhost]:
        Please provide the TCP port number of the SMTP server [25]:
        Please provide the email address from which notifications will be sent [root@localhost]:
        Please provide a comma-separated list of email addresses which will get notifications [root@localhost]:

15. Enter a password for the admin@internal user to access the Administration Portal:

        Enter engine admin password:
        Confirm engine admin password:

    The script creates the virtual machine. This can take some time if it needs to install the oVirt Engine Appliance.

16. Select the type of storage to use:

        Please specify the storage you would like to use (glusterfs, iscsi, fc, nfs)[nfs]:

  * For NFS, enter the version, full address and path to the storage, and any mount options:

          Please specify the nfs version you would like to use (auto, v3, v4, v4_1)[auto]:
          Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/nfs
          If needed, specify additional mount options for the connection to the hosted-engine storage domain []:

  * For iSCSI, enter the portal details and select a target and LUN from the auto-detected lists. You can only select one iSCSI target during the deployment, but multipathing is supported to connect all portals of the same portal group.

      **Note:** To specify more than one iSCSI target, you must enable multipathing before deploying the self-hosted engine. There is also a Multipath Helper tool that generates a script to install and configure multipath with different options.

          Please specify the iSCSI portal IP address:
          Please specify the iSCSI portal port [3260]:
          Please specify the iSCSI discover user:
          Please specify the iSCSI discover password:
          Please specify the iSCSI portal login user:
          Please specify the iSCSI portal login password:

          The following targets have been found:
          	[1]	iqn.2017-10.com.redhat.example:he
          		TPGT: 1, portals:
          			192.168.1.xxx:3260
          			192.168.2.xxx:3260
          			192.168.3.xxx:3260

          Please select a target (1) [1]: 1

          The following luns have been found on the requested target:
            [1] 360003ff44dc75adcb5046390a16b4beb   199GiB  MSFT   Virtual HD
                status: free, paths: 1 active

          Please select the destination LUN (1) [1]:

  * For Gluster storage, enter the full address and path to the storage, and any mount options:

      **Important:** Only replica 3 Gluster storage is supported. Ensure you have the following configuration:


        * Configure the volume as follows as per [Gluster Volume Options for Virtual Machine Image Store](documentation/admin-guide/chap-Working_with_Gluster_Storage#Options set on Gluster Storage Volumes to Store Virtual Machine Images)


          Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/gluster_volume
          If needed, specify additional mount options for the connection to the hosted-engine storage domain []:

  * For Fibre Channel, select a LUN from the auto-detected list. The host bus adapters must be configured and connected, and the deployment script will auto-detect the LUNs available, and the LUN must not contain any existing data.

          The following luns have been found on the requested target:
          [1] 3514f0c5447600351   30GiB   XtremIO XtremApp
          		status: used, paths: 2 active

          [2] 3514f0c5447600352   30GiB   XtremIO XtremApp
          		status: used, paths: 2 active

          Please select the destination LUN (1, 2) [1]:

17. Enter the Engine disk size:

        Please specify the size of the VM disk in GB: [50]:

When the deployment completes successfully, one data center, cluster, host, storage domain, and the Engine virtual machine are already running. You can log in to the Administration Portal to add any other resources.

18. Enable the required repositories on the Engine virtual machine. See Enabling the oVirt Engine Repositories in the Installation Guide.

19. Optionally, add a directory server using the ovirt-engine-extension-aaa-ldap-setup interactive setup script so you can add additional users to the environment. For more information, see Configuring an External LDAP Provider in the Administration Guide.

The Engine virtual machine, the host running it, and the self-hosted engine storage domain are flagged with a gold crown in the Administration Portal.

See [Chapter 3: Troubleshooting](chap-Troubleshooting) for more information.

**Prev:** [Chapter 1: Introduction](chap-Introduction) <br>
**Next:** [Chapter 3: Troubleshooting a Self-Hosted Engine Deployment](chap-Troubleshooting)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/self-hosted_engine_guide/chap-deploying_self-hosted_engine)

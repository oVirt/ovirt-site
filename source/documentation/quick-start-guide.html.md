---
title: Quick Start Guide
category: documentation
authors: adahms, bproffitt, didi, fab, gianluca, gshereme, jbrooks, jhernand, jonar,
  jvdwege, knesenko, mgoldboi, nkesick, oschreib, rydekull, sandrobonazzola, sgordon,
  vered, wdennis
wiki_category: Documentation
wiki_title: Quick Start Guide
wiki_revision_count: 80
wiki_last_updated: 2015-01-25
wiki_warnings: list-item?
---

# Quick Start Guide

DRAFT DRAFT DRAFT DRAFT

This quick start guide is adapted from the [RHEV 3.0 quick start guide](http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Quick_Start_Guide/index.html). The fundamentals are the same between RHEV and oVirt, but this document could use more checking against oVirt 3.1.

## Introduction

This document is a step-by-step guide for first-time users to install and configure a basic oVirt environment and create virtual machines.

### Prerequisites

The following requirements are typical for small- to medium-sized installations. Note that the exact requirements of the setup depend on the specific installation, sizing and load. Please use the following requirements as guidelines:

#### oVirt Engine

*   Minimum - Dual core server with 4 GB RAM, with 25 GB free disk space and 1 Gbps network interface.
*   Recommended - Dual Sockets/Quad core server with 16 GB RAM, 50 GB free disk space on multiple disk spindles and 1 Gbps network interface.
    The breakdown of the server requirements are as below:
    -   For the Fedora 17 operating system: minimum 1 GB RAM and 5 GB local disk space.
    -   For the oVirt Engine: minimum 3 GB RAM, 3 GB local disk space and 1 Gbps network controller bandwidth.
    -   If you wish to create an ISO domain on the Engine server, you need minimum 15 GB disk space.
*   The oVirt Engine must be configured to receive updates from the oVirt project's software repository, as provided by the [ovirt-release](http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm) package.
*   A client for connecting to oVirt Engine.

#### For each Host (oVirt Node or Fedora Host)

*   Minimum - Dual core server, 10 GB RAM and 10 GB Storage, 1 Gbps network interface.
*   Recommended - Dual socket server, 16 GB RAM and 50 GB storage, two 1 Gbps network interfaces.
    The breakdown of the server requirements are as below:
    -   For each host: AMD-V or Intel VT enabled, AMD64 or Intel 64 extensions, minimum 1 GB RAM, 3 GB free storage and 1 Gbps network interface.
    -   For virtual machines running on each host: minimum 1 GB RAM per virtual machine.

#### Storage and Networking

*   At least one of the supported storage types (NFS, iSCSI, FCP, Local, POSIX FS).
    -   For NFS storage, a valid IP address and export path is required.
    -   For iSCSI storage, a valid IP address and target information is required.
*   Static IP addresses for the oVirt Engine server and for each host server.
*   DNS service which can resolve (forward and reverse) all the IP addresses.
*   An existing DHCP server which can allocate network addresses for the virtual machines.

#### Virtual Machines

*   Installation images for creating virtual machines, depending on which operating system you wish to use.

## Install oVirt

### Install oVirt Engine

oVirt Engine is the control center of the oVirt environment. It allows you to define hosts, configure data centers, add storage, define networks, create virtual machines, manage user permissions and use templates from one central location.

1. Install Fedora 17 on a server. When prompted for the software packages to install, select the minimal install option. See the [Fedora Installation Guide](http://docs.fedoraproject.org/en-US/Fedora/17/html/Installation_Guide/index.html) for more details.

2. After you have installed your server, update all the packages on it. Run:

         # yum -y update

Reboot your server for the updates to be applied.

3. Subscribe the server to the oVirt project repository.

`   # yum localinstall `[`http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm`](http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm)

4. You are now ready to install the oVirt Engine. Run the following command:

         # yum -y install ovirt-engine

This command will download the oVirt Engine installation software and resolve all dependencies.

5. When the packages have finished downloading, run the installer:

         # engine-setup

6. The installer will take you through a series of interactive questions as listed in the following example. If you do not enter a value when prompted, the installer uses the default settings which are stated in [ ] brackets.

Example 2.1. oVirt Engine installation

         Welcome to RHEV Manager setup utility
         HTTP Port  [80] : 
         HTTPS Port  [443] : 
         Host fully qualified domain name, note that this name should be fully resolvable  [ovirt.demo.example.com] :
         Password for Administrator (admin@internal) :
         Database password (required for secure authentication with the locally created database) :
         Confirm password :
         Organization Name for the Certificate: Example
         The default storage type you will be using  ['NFS'| 'FC'| 'ISCSI']  [NFS] : ISCSI
         Should the installer configure NFS share on this server to be used as an ISO Domain? ['yes'| 'no']  [no] : yes
         Mount point path: /data/iso
         Display name for the ISO Domain: local-iso-share
         Firewall ports need to be opened.
         You can let the installer configure iptables automatically overriding the current configuration. The old configuration will be backed up.
         Alternately you can configure the firewall later using an example iptables file found under /usr/share/rhevm/conf/iptables.example
         Configure iptables ? ['yes'| 'no']: yes

Important points to note:

*   The default ports 80 and 443 must be available to access the manager on HTTP and HTTPS respectively.
*   If you elect to configure an NFS share it will be exported from the machine on which the manager is being installed.
*   The storage type that you select will be used to create a data center and cluster. You will then be able to attach storage to these from the Administration Portal.

7. You are then presented with a summary of the configurations you have selected. Type yes to accept them.

Example 2.2. Confirm Engine installation settings

         oVirt Engine will be installed using the following configuration:
         =================================================================
         http-port:                     80
         https-port:                    443
         host-fqdn:                     ovirt.demo.example.com
         auth-pass:                     ********
         db-pass:                       ********
         org-name:                      Example
         default-dc-type:               ISCSI
         nfs-mp:                        /data/iso
         iso-domain-name:               local-iso-share
         override-iptables:             yes
         Proceed with the configuration listed above? (yes|no): yes

8. The installation commences. The following message displays, indicating that the installation was successful.

Example 2.3. Successful installation

         Installing:
         Creating JBoss Profile...                                [ DONE ]
         Creating CA...                                           [ DONE ]
         Setting Database Security...                             [ DONE ]
         Creating Database...                                     [ DONE ]
         Updating the Default Data Center Storage Type...         [ DONE ]
         Editing JBoss Configuration...                           [ DONE ]
         Editing oVirt Engine Configuration...                    [ DONE ]
         Configuring the Default ISO Domain...                    [ DONE ]
         Starting JBoss Service...                                [ DONE ]
         Configuring Firewall (iptables)...                       [ DONE ]
         
         **** Installation completed successfully ******

Your oVirt Engine is now up and running. You can log in to the oVirt Engine's web administration portal with the username admin (the administrative user configured during installation) in the internal domain. Instructions to do so are provided at the end of this chapter.

The internal domain is automatically created upon installation, however no new users can be added to this domain. To authenticate new users, you need an external directory service. oVirt supports IPA and Active Directory, and provides a utility called engine-manage-domains to attach new directories to the system. Use of this tool is covered in the oVirt Installation Guide.

### Install Hosts

After you have installed the oVirt Engine, install the hosts to run your virtual machines. In oVirt, you can use either oVirt Node or Fedora as hosts.

#### Install oVirt Node

This document provides instructions for installing oVirt Node using a CD. For alternative methods including PXE networks or USB devices, see the [oVirt Node deployment documentation](oVirt Node deployment documentation).

Before installing the oVirt Node, you need to download the hypervisor image and create a bootable CD with the image.

**Download oVirt Node installation CD**

1. Download the [latest version](http://ovirt.org/releases/3.1/tools/) of oVirt Node and burn the ISO image onto a disc.

Once you have created an oVirt Node installation CD, you can use it to boot the machine designated as your Node host. For this guide you will use the interactive installation where you are prompted to configure your settings in a graphical interface. Use the following keys to navigate around the installation screen:

Menu Navigation Keys

*   Use the Up and Down arrow keys to navigate between selections. Your selections are highlighted in white.
*   The Tab key allows you to move between fields.
*   Use the Spacebar to tick checkboxes, represented by [ ] brackets. A marked checkbox displays with an asterisk (\*).
*   To proceed with the selected configurations, press the Enter key.

**To configure oVirt Node installation settings**

1.  Insert the oVirt Node installation CD into your CD-ROM drive and reboot the machine. When the boot splash screen displays, select Start oVirt Node to boot from the Node installation media. Press Enter.
2.  On the installation confirmation screen, select Install Hypervisor and press Enter.
3.  Select the appropriate keyboard layout for your system.
4.  The installer automatically detects the drives attached to the system. The selected disk for booting the hypervisor is highlighted in white. Ensure that the local disk is highlighted, otherwise use the arrow keys to select the correct disk. Select Continue and press Enter.
5.  You are prompted to confirm your selection of the local drive, which is marked with an asterisk. Select Continue and press Enter.
6.  Enter a password for local console access and confirm it. Select Install and press Enter. The oVirt Node partitions the local drive, then commences installation.
7.  Once installation is complete, a dialog prompts you to Reboot the hypervisor. Press Enter to confirm. Remove the installation disc.
8.  After the Node has rebooted, you will be taken to a login shell. Log in as the admin user with the password you provided during installation to enter the oVirt Node management console.
9.  On the Node hypervisor management console, there are eleven tabs on the left. Press the Up and Down keys to navigate between the tabs and Tab or right-arrow to access them.

a. Select the Network tab. Configure the following options:

*   Hostname: Enter the hostname in the format of hostname.domain.example.com.
*   DNS Server: Enter the Domain Name Server address in the format of 192.168.0.254. You can use up to two DNS servers.
*   NTP Server: Enter the Network Time Protocol server address in the format of ovirt.pool.ntp.org. This synchronizes the hypervisor's system clock with that of the Engine's. You can use up to two NTP servers. Select Apply and press Enter to save your network settings.
*   The installer automatically detects the available network interface devices to be used as the management network. Select the device and press Enter to access the interface configuration menu. Under IPv4 Settings, tick either the DHCP or Static checkbox. If you are using static IPv4 network configuration, fill in the IP Address, Netmask and Gateway fields.

<!-- -->

To confirm your network settings, select OK and press Enter.

<!-- -->

b. Select the oVirt Engine tab. Configure the following options:

*   Management Server: Enter the oVirt Engine domain name in the format of ovirt.demo.example.com.
*   Management Server Port: Enter the management server port number. The default is 443.
*   Connect to the oVirt Engine and Validate Certificate: Tick this checkbox if you wish to verify the oVirt Engine security certificate.
*   Set oVirt Engine Admin Password: This field allows you to specify the root password for the hypervisor, and enable SSH password authentication from the oVirt Engine. This field is optional, and is covered in more detail in the [oVirt Installation Guide](oVirt Installation Guide).

<!-- -->

Select Apply and press Enter. A dialog displays, asking you to connect the hypervisor to the oVirt Engine and validate its certificate. Select Approve and press Enter. A message will display notifying you that the manager configuration has been successfully updated.

<!-- -->

c. Accept all other default settings. For information on configuring security, logging, kdump and remote storage, refer to the [oVirt Node Deployment Guide](oVirt Node Deployment Guide).

d. Finally, select the Status tab. Select Restart and press Enter to reboot the host and apply all changes.

You have now successfully installed the oVirt Node. Repeat this procedure if you wish to use more hypervisors. The following sections will provide instructions on how to [ approve the hypervisors](#Approve_oVirt_Node_Host) for use with the oVirt Engine.

#### Install Fedora Host

You now know how to install a oVirt Node. In addition to hypervisor hosts, you can also reconfigure servers which are running Fedora to be used as virtual machine hosts.

**To install a Fedora 17 host**

*   On the machine designated as your Fedora host, install Fedora 17. A minimal installation is sufficient.
*   Log in to your Fedora host as the **root** user.
*   Install the *ovirt-release* package using **yum**, this package configures your system to receive updates from the oVirt project's software repository:

`   # yum localinstall `[`http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm`](http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm)

*   The oVirt platform uses a number of network ports for management and other virtualization features. oVirt Engine can make the necessary firewall adjustments automatically while adding your host. Alternatively, you may adjust your Fedora host's firewall settings to allow access to the required ports by configuring iptables rules. Modify the /etc/sysconfig/iptables file so it resembles the following example:

         :INPUT ACCEPT [0:0]
         :FORWARD ACCEPT [0:0]
         :OUTPUT ACCEPT [10765:598664]
         -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
         -A INPUT -p icmp -j ACCEPT 
         -A INPUT -i lo -j ACCEPT
         -A INPUT -p tcp --dport 22 -j ACCEPT
         -A INPUT -p tcp --dport 16514 -j ACCEPT
         -A INPUT -p tcp --dport 54321 -j ACCEPT
         -A INPUT -p tcp -m multiport --dports 5634:6166 -j ACCEPT
         -A INPUT -p tcp -m multiport --dports 49152:49216 -j ACCEPT  
         -A INPUT -p tcp -m state --state NEW  
         -A INPUT -j REJECT --reject-with icmp-host-prohibited 
         -A FORWARD -m physdev ! --physdev-is-bridged -j REJECT --reject-with icmp-host-prohibited 
         COMMIT

*   Ensure that the iptables service is configured to start on boot and has been restarted, or started for the first time if it was not already running. Run the following commands:

         # chkconfig iptables on
         # service iptables restart

You have now successfully installed a Fedora host. As before, repeat this procedure if you wish to use more Linux hosts. Before you can start running virtual machines on your host, you have to manually add it to the oVirt Engine via the administration portal, which you will access in the next step.

## Connect to oVirt Engine

Now that you have installed the oVirt Engine and hosts, you can log in to the Engine administration portal to start configuring your virtualization environment.

### Log In to Administration Portal

Ensure that you have the administrator password configured during installation as instructed in Example 2.1, “oVirt Engine installation”.

To connect to oVirt web management portal

1.  Open a browser and navigate to <https://domain.example.com/webadmin>. Substitute domain.example.com with the URL provided during installation.
2.  If this is your first time connecting to the administration portal, oVirt Engine will issue security certificates for your browser. Click the link labelled this certificate to trust the ca.cer certificate. A pop-up displays, click Open to launch the Certificate dialog. Click Install Certificate and select to place the certificate in Trusted Root Certification Authorities store.
3.  The portal login screen displays. Enter admin as your User Name, and enter the Password that you provided during installation. Ensure that your domain is set to Internal. Click Login.

You have now successfully logged in to the oVirt web administration portal. Here, you can configure and manage all your virtual resources. The functions of the oVirt Engine graphical user interface are described in the following figure and list:

![Figure 2.4. Administration Portal Features](admin-portal-label.png "Figure 2.4. Administration Portal Features")

1.  **Header**: This bar contains the name of the logged in user, the sign out button, the option to configure user roles.
2.  **Navigation Pane**: This pane allows you to navigate between the Tree, Bookmarks and Tags tabs. In the Tree tab, tree mode allows you to see the entire system tree and provides a visual representation your virtualization environment's architecture.
3.  **Resources Tabs**: These tabs allow you to access the resources of oVirt. You should already have a Default Data Center, a Default Cluster, a Host waiting to be approved, and available Storage waiting to be attached to the data center.
4.  **Results List**: When you select a tab, this list displays the available resources. You can perform a task on an individual item or multiple items by selecting the item(s) and then clicking the relevant action button. If an action is not possible, the button is disabled.
5.  **Details Pane**: When you select a resource, this pane displays its details in several subtabs. These subtabs also contain action buttons which you can use to make changes to the selected resource.

Once you are familiar with the layout of the administration portal, you can start configuring your virtual environment.

## Configure oVirt

Now that you have logged in to the administration portal, configure your oVirt environment by defining the data center, host cluster, networks and storage. Even though this guide makes use of the default resources configured during installation, if you are setting up a oVirt environment with completely new components, you should perform the configuration procedure in the sequence given here.

### Configure Data Centers

A data center is a logical entity that defines the set of physical and logical resources used in a managed virtual environment. Think of it as a container which houses clusters of hosts, virtual machines, storage and networks.

By default, oVirt creates a data center at installation. Its type is configured from the installation script. To access it, navigate to the Tree pane, click Expand All, and select the Default data center. On the Data Centers tab, the Default data center displays.

![Figure 3.2. Data Centers Tab](data-center-view.png "Figure 3.2. Data Centers Tab")

The Default data center is used for this document, however if you wish to create a new data center see the [oVirt Administration Guide](oVirt Administration Guide).

### Configure Cluster

A cluster is a set of physical hosts that are treated as a resource pool for a set of virtual machines. Hosts in a cluster share the same network infrastructure, the same storage and the same type of CPU. They constitute a migration domain within which virtual machines can be moved from host to host. By default, oVirt creates a cluster at installation. To access it, navigate to the Tree pane, click Expand All and select the Default cluster. On the Clusters tab, the Default cluster displays.

![Figure 3.4. Clusters Tab](cluster-view.png "Figure 3.4. Clusters Tab")

For this document, the oVirt Node and Fedora hosts will be attached to the Default host cluster. If you wish to create new clusters, or live migrate virtual machines between hosts in a cluster, see the [oVirt Evaluation Guide](oVirt Evaluation Guide).

### Configure Networking

At installation, oVirt defines a Management network for the default data center. This network is used for communication between the manager and the host. New logical networks - for example for guest data, storage or display - can be added to enhance network speed and performance. All networks used by hosts and clusters must be added to data center they belong to.

To access the Management network, click on the Clusters tab and select the default cluster. Click the Logical Networks tab in the Details pane. The ovirtmgmt network displays.

![Figure 3.6. Logical Networks Tab](logical-network-view.png "Figure 3.6. Logical Networks Tab")

The ovirtmgmt Management network is used for this document, however if you wish to create new logical networks see the [oVirt Administration Guide](oVirt Administration Guide).

### Configure Hosts

You have already installed your oVirt Node and Fedora hosts, but before they can be used, they have to be added to the Engine. The oVirt Node is specifically designed for the oVirt platform, therefore it only needs a simple click of approval. Conversely, Fedora is a general purpose operating system, therefore reprogramming it as a host requires additional configuration.

#### Approve oVirt Node Host

The Hypervisor you installed in Section 2.2.1, “Install oVirt Node” is automatically registered with the oVirt platform. It displays in the oVirt Engine, and needs to be approved for use.

**To set up a oVirt Node host**

On the Tree pane, click Expand All and select Hosts under the Default cluster. On the Hosts tab, select the name of your newly installed hypervisor.

![Figure 3.8. oVirt Node pending approval](approve-hypervisor-new.png "Figure 3.8. oVirt Node pending approval")

Click the Approve button. The Edit and Approve Host dialog displays. Accept the defaults or make changes as necessary, then click OK.

![Figure 3.9. Approve oVirt Node](edit-and-approve.png "Figure 3.9. Approve oVirt Node")

The host status will change from Non Operational to Up.

#### Attach Fedora Host

In contrast to the hypervisor host, the Fedora host you installed in Section 2.2.2, “Install Fedora Host” is not automatically detected. It has to be manually attached to the oVirt platform before it can be used.

To attach a Fedora host

1. On the Tree pane, click Expand All and select Hosts under the Default cluster. On the Hosts tab, click New.

<!-- -->

2. The New Host dialog displays.

![Figure 3.10. Attach Fedora Host](new-host.png "Figure 3.10. Attach Fedora Host")

Enter the details in the following fields:

*   Data Center: the data center to which the host belongs. Select the Default data center.
*   Host Cluster: the cluster to which the host belongs. Select the Default cluster.
*   Name: a descriptive name for the host.
*   Address: the IP address, or resolvable hostname of the host, which was provided during installation.
*   Root Password: the password of the designated host; used during installation of the host.
*   Configure iptables rules: This checkbox allows you to override the firewall settings on the host with the default rules for oVirt.

<!-- -->

3. If you wish to configure this host for Out of Band (OOB) power management, select the Power Management tab. Tick the Enable Power Management checkbox and provide the required information in the following fields:

*   Address: The address of the host.
*   User Name: A valid user name for the OOB management.
*   Password: A valid, robust password for the OOB management.
*   Type: The type of OOB management device. Select the appropriate device from the drop down list.
    -   alom Sun Advanced Lights Out Manager
    -   apc American Power Conversion Master MasterSwitch network power switch
    -   bladecenter IBM Bladecentre Remote Supervisor Adapter
    -   drac5 Dell Remote Access Controller for Dell computers
    -   eps ePowerSwitch 8M+ network power switch
    -   ilo HP Integrated Lights Out standard
    -   ilo3 HP Integrated Lights Out 3 standard
    -   ipmilan Intelligent Platform Management Interface
    -   rsa IBM Remote Supervisor Adaptor
    -   rsb Fujitsu-Siemens RSB management interface
    -   wti Western Telematic Inc Network PowerSwitch
    -   cisco_ucs Cisco Unified Computing System Integrated Management Controller
*   Options: Extra command line options for the fence agent. Detailed documentation of the options available is provided in the man page for each fence agent.

Click the Test button to test the operation of the OOB management solution.

If you do not wish to configure power management, leave the Enable Power Management checkbox unmarked.

<!-- -->

4. Click OK. If you have not configured power management, a pop-up window prompts you to confirm if you wish to proceed without power management. Select OK to continue.

<!-- -->

5. The new host displays in the list of hosts with a status of Installing. Once installation is complete, the status will update to Reboot and then Awaiting. When the host is ready for use, its status changes to Up.

You have now successfully configured your hosts to run virtual machines. The next step is to prepare data storage domains to house virtual machine disk images.

### Configure Storage

After configuring your logical networks, you need to add storage to your data center.

oVirt uses a centralized shared storage system for virtual machine disk images and snapshots. Storage can be implemented using Network File System (NFS), Internet Small Computer System Interface (iSCSI) or Fibre Channel Protocol (FCP). Storage definition, type and function, are encapsulated in a logical entity called a Storage Domain. Multiple storage domains are supported.

For this guide you will use two types of storage domains. The first is an NFS share for ISO images of installation media. You have already created this ISO domain during the oVirt Engine installation.

The second storage domain will be used to hold virtual machine disk images. For this domain, you need at least one of the supported storage types. You have already set a default storage type during installation as described in Section 2.1, “Install oVirt Engine”. Ensure that you use the same type when creating your data domain.

Select your next step by checking the storage type you should use:

1.  Navigate to the Tree pane and click the Expand All button. Under System, click Default. On the results list, the Default data center displays.
2.  On the results list, the Storage Type column displays the type you should add.
3.  Now that you have verified the storage type, create the storage domain:

    * For NFS storage, refer to Section 3.5.1, “Create an NFS Data Domain”.

    * For iSCSI storage, refer to Section 3.5.2, “Create an iSCSI Data Domain”.

    * For FCP storage, refer to Section 3.5.3, “Create an FCP Data Domain”.

Note: This document provides instructions to create a single storage domain, which is automatically attached and activated in the selected data center. If you wish to create additional storage domains within one data center, see the [oVirt Administration Guide](oVirt Administration Guide) for instructions on activating storage domains.

#### Create an NFS Data Domain

Because you have selected NFS as your default storage type during the Manager installation, you will now create an NFS storage domain. An NFS type storage domain is a mounted NFS share that is attached to a data center and used to provide storage for virtual machine disk images.

Important: If you are using NFS storage, you must first create and export the directories to be used as storage domains from the NFS server. These directories must have their numerical user and group ownership set to 36:36 on the NFS server, to correspond to the vdsm user and kvm group respectively on the oVirt Engine server. In addition, these directories must be exported with the read write options (rw). For more information see the [oVirt Installation Guide](oVirt Installation Guide).

**To add NFS storage:**

1. Navigate to the Tree pane and click the Expand All button. Under System, select the Default data center and click on Storage. The available storage domains display on the results list. Click New Domain.

2. The New Storage dialog box displays.

![Figure 3.12. Add New Storage](storage-nfs.png "Figure 3.12. Add New Storage")

Configure the following options:

*   Name: Enter a suitably descriptive name.
*   Data Center: The Default data center is already pre-selected.
*   Domain Function / Storage Type: In the drop down menu, select Data → NFS. The storage domain types not compatible with the Default data center are grayed out. After you select your domain type, the Export Path field appears.

Use Host: Select any of the hosts from the drop down menu. Only hosts which belong in the pre-selected data center will display in this list.

    * Export path: Enter the IP address or a resolvable hostname of the chosen host. The export path should be in the format of 192.168.0.10:/data or domain.example.com:/data

3. Click OK. The new NFS data domain displays on the Storage tab. It will remain with a Locked status while it is being prepared for use. When ready, it is automatically attached to the data center.

You have created an NFS storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to Section 3.5.4, “Attach and Populate ISO domain”.

#### Create an iSCSI Data Domain

Because you have selected iSCSI as your default storage type during the Manager installation, you will now create an iSCSI storage domain. oVirt platform supports iSCSI storage domains spanning multiple pre-defined Logical Unit Numbers (LUNs).

**To add iSCSI storage:**

1. On the side pane, select the Tree tab. On System, click the + icon to display the available data centers.

2. Double click on the Default data center and click on Storage. The available storage domains display on the results list. Click New Domain.

3. The New Domain dialog box displays.

![Figure 3.13. Add iSCSI Storage](storage-iscsi.png "Figure 3.13. Add iSCSI Storage")

Configure the following options:

*   Name: Enter a suitably descriptive name.
*   Data Center: The Default data center is already pre-selected.
*   Domain Function / Storage Type: In the drop down menu, select Data → iSCSI. The storage domain types which are not compatible with the Default data center are grayed out. After you select your domain type, the Use Host and Discover Targets fields display.
*   Use host: Select any of the hosts from the drop down menu. Only hosts which belong in this data center will display in this list.

<!-- -->

4. To connect to the iSCSI target, click the Discover Targets bar. This expands the menu to display further connection information fields.

![Figure 3.14. Attach LUNs to iSCSI domain](storage-iscsi-lun.png "Figure 3.14. Attach LUNs to iSCSI domain")

Enter the required information:

*   Address: Enter the address of the iSCSI target.
*   Port: Select the port to connect to. The default is 3260.
*   User Authentication: If required, enter the username and password.

<!-- -->

5. Click the Discover button to find the targets. The iSCSI targets display in the results list with a Login button for each target.

6. Click Login to display the list of existing LUNs. Tick the Add LUN checkbox to use the selected LUN as the iSCSI data domain.

7. Click OK. The new iSCSI data domain displays on the Storage tab. It will remain with a Locked status while it is being prepared for use. When ready, it is automatically attached to the data center.

You have created an iSCSI storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to Section 3.5.4, “Attach and Populate ISO domain”.

#### Create an FCP Data Domain

Because you have selected FCP as your default storage type during the Manager installation, you will now create an FCP storage domain. oVirt platform supports FCP storage domains spanning multiple pre-defined Logical Unit Numbers (LUNs).

**To add FCP storage:**

1. On the side pane, select the Tree tab. On System, click the + icon to display the available data centers.

2. Double click on the Default data center and click on Storage. The available storage domains display on the results list. Click New Domain.

3. The New Domain dialog box displays.

![Figure 3.15. Add FCP Storage](storage-fcp.png "Figure 3.15. Add FCP Storage")

Configure the following options:

*   Name: Enter a suitably descriptive name.
*   Data Center: The Default data center is already pre-selected.
*   Domain Function / Storage Type: Select FCP.
*   Use Host: Select the IP address of either the hypervisor or Red Hat Enterprise Linux host.
*   The list of existing LUNs display. On the selected LUN, tick the Add LUN checkbox to use it as the FCP data domain.

<!-- -->

4. Click OK. The new FCP data domain displays on the Storage tab. It will remain with a Locked status while it is being prepared for use. When ready, it is automatically attached to the data center.

You have created an FCP storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to Section 3.5.4, “Attach and Populate ISO domain”.

#### Attach and Populate ISO domain

You have defined your first storage domain to store virtual guest data, now it is time to configure your second storage domain, which will be used to store installation images for creating virtual machines. You have already created a local ISO domain during the installation of the oVirt Engine. To use this ISO domain, attach it to a data center.

**To attach the ISO domain**

1. Navigate to the Tree pane and click the Expand All button. Click Default. On the results list, the Default data center displays.

2. On the details pane, select the Storage tab and click the Attach ISO button.

3. The Attach ISO Library dialog appears with the available ISO domain. Select it and click OK.

![Figure 3.16. Attach ISO Library](attach-iso-library.png "Figure 3.16. Attach ISO Library")

4. The ISO domain appears in the results list of the Storage tab. It displays with the Locked status as the domain is being validated, then changes to Inactive.

5. Select the ISO domain and click the Activate button. The status changes to Locked and then to Active.

Media images (CD-ROM or DVD-ROM in the form of ISO images) must be available in the ISO repository for the virtual machines to use. To do so, oVirt provides a utility that copies the images and sets the appropriate permissions on the file. The file provided to the utility and the ISO share have to be accessible from the oVirt Engine.

Log in to the oVirt Engine server console to upload images to the ISO domain.

**To upload ISO images**

1. Create or acquire the appropriate ISO images from boot media. Ensure the path to these images is accessible from the oVirt Engine server.

2. The next step is to upload these files. First, determine the available ISO domains by running:

         # engine-iso-uploader list

You will be prompted to provide the admin user password which you use to connect to the administration portal. The tool lists the name of the ISO domain that you attached in the previous section.

         ISO Storage Domain List:
           local-iso-share

Now you have all the information required to upload the required files. On the Manager console, copy your installation images to the ISO domain. For your images, run:

         # engine-iso-uploader upload -i local-iso-share [file1] [file2] .... [fileN]

You will be prompted for the admin user password again, provide it and press Enter.

Note that the uploading process can be time consuming, depending on your storage performance.

3. After the images have been uploaded, check that they are available for use in the Manager administration portal.

*   Navigate to the Tree and click the Expand All button.
*   Under Storage, click on the name of the ISO domain. It displays in the results list. Click on it to display its details pane.
*   On the details pane, select the Images tab. The list of available images should be populated with the files which you have uploaded.

![Figure 3.17. Uploaded ISO images](iso-images-uploaded.png "Figure 3.17. Uploaded ISO images")

Now that you have successfully prepared the ISO domain for use, you are ready to start creating virtual machines.

## Manage Virtual Machines

The final stage of setting up oVirt is the virtual machine lifecycle - spanning the creation, deployment and maintenance of virtual machines; using templates; and configuring user permissions. This chapter will also show you how to log in to the user portal and connect to virtual machines.

### Create Virtual Machines

On oVirt, you can create virtual machines from an existing template, as a clone, or from scratch. Once created, virtual machines can be booted using ISO images, a network boot (PXE) server, or a hard disk. This document provides instructions for creating a virtual machine using an ISO image.

#### Create a Fedora Virtual Machine

In your current configuration, you should have at least one host available for running virtual machines, and uploaded the required installation images to your ISO domain. This section guides you through the creation of a Fedora virtual server. You will perform a normal attended installation using a virtual DVD.

**To create a Fedora server**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, click New Server.

![Figure 4.2. Create New Linux Virtual Machine](new-fedora-server.png "Figure 4.2. Create New Linux Virtual Machine")

You only need to fill in the Name field and select Red Hat Enterprise Linux 6.x as your Operating System. You may alter other settings but in this example we will retain the defaults. Click OK to create the virtual machine.

<!-- -->

2. A New Virtual Machine - Guide Me window opens. This allows you to add networks and storage disks to the virtual machine.

![Figure 4.3. Create Virtual Machines](newvm-guide.png "Figure 4.3. Create Virtual Machines")

3. Click Configure Network Interfaces to define networks for your virtual machine. The parameters in the following figure are recommended, but can be edited as necessary. When you have configured your required settings, click OK.

![Figure 4.4. New Network Interface configurations](new-network-interface.png "Figure 4.4. New Network Interface configurations")

4. You are returned to the Guide Me window. This time, click Configure Virtual Disks to add storage to the virtual machine. The parameters in the following figure are recommended, but can be edited as necessary. When you have configured your required settings, click OK.

![Figure 4.5. New Virtual Disk configurations](new-virtual-disk.png "Figure 4.5. New Virtual Disk configurations")

5. Close the Guide Me window by clicking Configure Later. Your new Fedora virtual machine will display in the Virtual Machines tab.

<!-- -->

You have now created your first Fedora virtual machine. Before you can use your virtual machine, install an operating system on it.

**To install the Fedora guest operating system**

1. Right click the virtual machine and select Run Once. Configure the following options:

![Figure 4.6. Run Linux Virtual Machine](run-fedora-vm.png "Figure 4.6. Run Linux Virtual Machine")

    * Attach CD: Fedora 17

    * Boot Sequence: CD-ROM

    * Display protocol: SPICE

Retain the default settings for the other options and click OK to start the virtual machine.

<!-- -->

2. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system. For further instructions, see the [Fedora Installation Guide](https://docs.fedoraproject.org/en-US/Fedora/17/html/Installation_Guide/index.html).

3. After the installation has completed, shut down the virtual machine and reboot from the hard drive.

You can now connect to your Fedora virtual machine and start using it.

#### Create a Windows Virtual Machine

You now know how to create a Red Hat Enterprise Linux virtual machine from scratch. The procedure of creating a Windows virtual machine is similar, except that it requires additional virtio drivers. This example uses Windows 7, but you can also use other Windows operating systems. You will perform a normal attended installation using a virtual DVD.

**To create a Windows desktop**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, click New Desktop.

![Figure 4.7. Create New Windows Virtual Machine](new-win-desktop.png "Figure 4.7. Create New Windows Virtual Machine")

You only need to fill in the Name field and select Windows 7 as your Operating System. You may alter other settings but in this example we will retain the defaults. Click OK to create the virtual machine.

<!-- -->

2. A New Virtual Machine - Guide Me window opens. This allows you to define networks for the virtual machine. Click Configure Network Interfaces. See Figure 4.4, “New Network Interface configurations” for details.

3. You are returned to the Guide Me window. This time, click Configure Virtual Disks to add storage to the virtual machine. See Figure 4.5, “New Virtual Disk configurations” for details.

4. Close the Guide Me windows. Your new Windows 7 virtual machine will display in the Virtual Machines tab.

**To install Windows guest operating system**

1. Right click the virtual machine and select Run Once. The Run Once dialog displays as in Figure 4.6, “Run Red Hat Enterprise Linux Virtual Machine”. Configure the following options:

*   Attach Floppy: virtio-win
*   Attach CD: Windows 7
*   Boot sequence: CD-ROM
*   Display protocol: SPICE

Retain the default settings for the other options and click OK to start the virtual machine.

<!-- -->

2. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system.

3. Accept the default settings and enter the required information as necessary. The only change you must make is to manually install the VirtIO drivers from the virtual floppy disk (vfd) image. To do so, select the Custom (advanced) installation option and click Load Driver. Press Ctrl and select:

*   Red Hat VirtIO Ethernet Adapter
*   Red Hat VirtIO SCSI Controller

The installation process commences, and the system will reboot itself several times.

<!-- -->

4. Back on the administration portal, when the virtual machine's status changes back to Up, right click on it and select Change CD. From the list of images, select RHEV-toolsSetup to attach the Guest Tools ISO which provides features including USB redirection and SPICE display optimization.

5. Click Console and log in to the virtual machine. Locate the CD drive to access the contents of the Guest Tools ISO, and launch the RHEV-toolsSetup executable. After the tools have been installed, you will be prompted to restart the machine for changes to be applied.

<!-- -->

You can now connect to your Windows virtual machine and start using it.

### Using Templates

Now that you know how to create a virtual machine, you can save its settings into a template. This template will retain the original virtual machine's configurations, including virtual disk and network interface settings, operating systems and applications. You can use this template to rapidly create replicas of the original virtual machine.

#### Create a Fedora Template

To make a Fedora virtual machine template, use the virtual machine you created in Section 4.1.1, “Create a Fedora Virtual Machine” as a basis. Before it can be used, it has to be sealed. This ensures that machine-specific settings are not propagated through the template.

**To prepare a Fedora virtual machine for use as a template**

1. Connect to the Fedora virtual machine to be used as a template. Flag the system for re-configuration by running the following command as root:

         # touch /.unconfigured

2. Remove ssh host keys. Run:

         # rm -rf /etc/ssh/ssh_host_*

3. Shut down the virtual machine. Run:

         # poweroff

4. The virtual machine has now been sealed, and is ready to be used as a template for Linux virtual machines.

**To create a template from a Fedora virtual machine**

1. In the administration portal, click the Virtual Machines tab. Select the sealed Red Hat Enterprise Linux 6 virtual machine. Ensure that it has a status of Down.

2. Click Make Template. The New Virtual Machine Template displays.

![Figure 4.9. Make new virtual machine template](make-template.png "Figure 4.9. Make new virtual machine template")

Enter information into the following fields:

*   Name: Name of the new template
*   Description: Description of the new template
*   Host Cluster: The Host Cluster for the virtual machines using this template.
*   Make Private: If you tick this checkbox, the template will only be available to the template's creator and the administrative user. Nobody else can use this template unless they are given permissions by the existing permitted users.

<!-- -->

3. Click OK. The virtual machine displays a status of "Image Locked" while the template is being created. The template is created and added to the Templates tab. During this time, the action buttons for the template remain disabled. Once created, the action buttons are enabled and the template is ready for use.

#### Clone a Red Hat Enterprise Linux Virtual Machine

In the previous section, you created a Fedora template complete with pre-configured storage, networking and operating system settings. Now, you will use this template to deploy a pre-installed virtual machine.

**To clone a Fedora virtual machine from a template**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, click New Server.

![Figure 4.10. Create virtual machine based on Linux template](fedora-server-clone.png "Figure 4.10. Create virtual machine based on Linux template")

    * On the General tab, select the existing Linux template from the Based on Template list.

    * Enter a suitable Name and appropriate Description, then accept the default values inherited from the template in the rest of the fields. You can change them if needed.

    * Click the Resource Allocation tab. On the Provisioning field, click the drop down menu and select the Clone option.

![Figure 4.11. Set the provisioning to Clone](new-vm-allocation.png "Figure 4.11. Set the provisioning to Clone")

2. Retain all other default settings and click OK to create the virtual machine. The virtual machine displays in the Virtual Machines list.

#### Create a Windows Template

To make a Windows virtual machine template, use the virtual machine you created in Section 4.1.2, “Create a Windows Virtual Machine” as a basis.

Before a template for Windows virtual machines can be created, it has to be sealed with sysprep. This ensures that machine-specific settings are not propagated through the template.

Note that the procedure below is applicable for creating Windows 7 and Windows 2008 R2 templates. If you wish to seal a Windows XP template, refer to the [oVirt Administration Guide](oVirt Administration Guide).

**To seal a Windows virtual machine with sysprep**

1. In the Windows virtual machine to be used as a template, open a command line terminal and type regedit.

2. The Registry Editor window displays. On the left pane, expand HKEY_LOCAL_MACHINE → SYSTEM → SETUP.

3. On the main window, right click to add a new string value using New → String Value. Right click on the file and select Modify. When the Edit String dialog box displays, enter the following information in the provided text boxes:

*   Value name: UnattendFile
*   Value data: a:\\sysprep.inf

4. Launch sysprep from C:\\Windows\\System32\\sysprep\\sysprep.exe

*   Under System Cleanup Action, select Enter System Out-of-Box-Experience (OOBE).
*   Tick the Generalize checkbox if you need to change the computer's system identification number (SID).
*   Under Shutdown Options, select Shutdown.

Click OK. The virtual machine will now go through the sealing process and shut down automatically.

**To create a template from an existing Windows machine**

1. In the administration portal, click the Virtual Machines tab. Select the sealed Windows 7 virtual machine. Ensure that it has a status of Down and click Make Template.

2. The New Virtual Machine Template displays. Enter information into the following fields:

*   Name: Name of the new template
*   Description: Description of the new template
*   Host Cluster: The Host Cluster for the virtual machines using this template.
*   Make Public: Check this box to allow all users to access this template.

3. Click OK. In the Templates tab, the template displays the "Image Locked" status icon while it is being created. During this time, the action buttons for the template remain disabled. Once created, the action buttons are enabled and the template is ready for use.

You can now create new Windows machines using this template.

#### Create a Windows Virtual Machine from a Template

This section describes how to create a Windows 7 virtual machine using the template created in Section 4.2.3, “Create a Windows Template”.

**To create a Windows virtual machine from a template**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, click New Desktop.

*   Select the existing Windows template from the Based on Template list.
*   Enter a suitable Name and appropriate Description, and accept the default values inherited from the template in the rest of the fields. You can change them if needed.

<!-- -->

2. Retain all other default setting and click OK to create the virtual machine. The virtual machine displays in the Virtual Machines list with a status of "Image Locked" until the virtual disk is created. The virtual disk and networking settings are inherited from the template, and do not have to be reconfigured.

<!-- -->

3. Click the Run icon to turn it on. This time, the Run Once steps are not required as the operating system has already been installed onto the virtual machine hard drive. Click the green Console button to connect to the virtual machine.

You have now learned how to create Fedora and Windows virtual machines with and without templates. Next, you will learn how to access these virtual machines from a user portal.

### Using Virtual Machines

Now that you have created several running virtual machines, you can assign users to access them from the user portal. You can use virtual machines the same way you would use a physical desktop.

#### Assign User Permissions

oVirt has a sophisticated multi-level administration system, in which customized permissions for each system component can be assigned to different users as necessary. For instance, to access a virtual machine from the user portal, a user must have either UserRole or PowerUserRole permissions for the virtual machine. These permissions are added from the manager administration portal. For more information on the levels of user permissions refer to the [oVirt Administration Guide](oVirt Administration Guide).

**To assign PowerUserRole permissions**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, select the virtual machine you would like to assign a user to.

<!-- -->

2. On the Details pane, navigate to the Permissions tab. Click the Add button.

<!-- -->

3. The Add Permission to User dialog displays. Enter a Name, or User Name, or part thereof in the Search textbox, and click Go. A list of possible matches display in the results list.

![Figure 4.13. Add PowerUserRole Permission](vm-add-perm.png "Figure 4.13. Add PowerUserRole Permission")

4. Select the check box of the user to be assigned the permissions. Scroll through the Assign role to user list and select PowerUserRole. Click OK.

#### Log in to the User Portal

Now that you have assigned PowerUserRole permissions on a virtual machine to the user named admin, you can access the virtual machine from the user portal. To log in to the user portal, all you need is a Linux client running Mozilla Firefox.

If you are using a Fedora client, install the SPICE plug-in before logging in to the User Portal. Run:

         # yum install spice-xpi

**To log in to the User Portal**

1. Open your browser and navigate to <https://domain.example.com/UserPortal>. Substitute domain.example.com with the oVirt Engine server address.

2. The login screen displays. Enter your User Name and Password, and click Login.

You have now logged into the user portal. As you have PowerUserRole permissions, you are taken by default to the Extended User Portal, where you can create and manage virtual machines in addition to using them. This portal is ideal if you are a system administrator who has to provision multiple virtual machines for yourself or other users in your environment. For more information, see the [oVirt Power User Portal Guide](oVirt Power User Portal Guide).

![Figure 4.15. The Extended User Portal](power-user-portal.png "Figure 4.15. The Extended User Portal")

You can also toggle to the Basic User Portal, which is the default (and only) display for users with UserRole permissions. This portal allows users to access and use virtual machines, and is ideal for everyday users who do not need to make configuration changes to the system. For more information, see the [oVirt User Portal Guide](oVirt User Portal Guide).

![Figure 4.16. The Basic User Portal](basic-user-portal.png "Figure 4.16. The Basic User Portal")

You have now completed the Quick Start Guide, and successfully set up oVirt.

<Category:Documentation>

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

## Introduction

This document is a step-by-step guide for first-time users to install and configure a basic oVirt environment and create virtual machines.

### Prerequisites

The following requirements are typical for small- to medium-sized installations. Note that the exact requirements of the setup depend on the specific installation, sizing and load. Please use the following requirements as guidelines:

#### oVirt Engine

*   Minimum - Dual core server with 4 GB RAM, with 25 GB free disk space and 1-Gbps network interface.
*   Recommended - Dual Sockets/Quad core server with 16 GB RAM, 50 GB free disk space on multiple disk spindles and 1-Gbps network interface.
    The breakdown of the server requirements are as below:
    -   For the Fedora 19 operating system: minimum 1 GB RAM and 10 GB local disk space.
    -   For the CentOS 6.5 operating system: minimum 1 GB RAM and 5 GB local disk space.
    -   For the oVirt Engine: minimum 3 GB RAM, 3 GB local disk space and 1-Gbps network controller bandwidth.
    -   If you wish to create an ISO domain on the Engine server, you need minimum 15 GB disk space.
*   The oVirt Engine must be configured to receive updates from the oVirt project's software repository, as provided by the ovirt-release package matching your OS distribution:
    -   [oVirt 3.3](http://resources.ovirt.org/pub/yum-repo/ovirt-release33.rpm)
    -   [oVirt 3.4](http://resources.ovirt.org/pub/yum-repo/ovirt-release34.rpm).
    -   [oVirt 3.5](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm).
    -   [oVirt 3.6](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm).
*   A client for connecting to oVirt Engine.

#### For each Host (oVirt Node, Fedora Host, CentOS Host)

*   Minimum - Dual-core server, 10 GB RAM and 10 GB Storage, 1-Gbps network interface.
*   Recommended - Dual-socket server, 16 GB RAM and 50 GB storage, two 1-Gbps network interfaces.
    The breakdown of the server requirements are as below:
    -   For each host: AMD-V or Intel VT enabled, AMD64 or Intel 64 extensions, minimum 1 GB RAM, 3 GB free storage and 1-Gbps network interface.
    -   For virtual machines running on each host: minimum 1 GB RAM per virtual machine.

#### Storage and Networking

*   At least one of the supported storage types (NFS, iSCSI, FCP, Local, POSIX FS, GlusterFS).
    -   For NFS storage, a valid IP address and export path is required.
    -   For iSCSI storage, a valid IP address and target information is required.
*   Static IP addresses for the oVirt Engine server and for each host server.
*   DNS service that can resolve (forward and reverse) all the IP addresses.
*   An existing DHCP server that can allocate network addresses for the virtual machines.

#### Virtual Machines

Installation images for creating virtual machines, depending on which operating system you wish to use.

*   Microsoft Windows XP, Vista, 7, 8, 2003, 2008 or 2012.
*   Red Hat Enterprise Linux 5.x or 6.x.
*   CentOS 6.x
*   Fedora 16-20
*   Ubuntu 12.04+
*   openSUSE 12.x+

## Install oVirt

The oVirt platform consists of at least one oVirt Engine and one or more Nodes.

*   oVirt Engine provides a graphical user interface to manage the physical and logical resources of the oVirt infrastructure. The Engine is installed on a Fedora 19, Red Hat Enterprise Linux 6 or CentOS 6 server, and accessed from a client running Firefox.

<!-- -->

*   oVirt Engine runs virtual machines. A physical server running Fedora 19, Red Hat Enterprise Linux 6 or CentOS 6 can also be configured as a host for virtual machines on the oVirt platform.

### Install oVirt Engine (Fedora / Red Hat Enterprise Linux / CentOS)

oVirt Engine is the control center of the oVirt environment. It allows you to define hosts, configure data centers, add storage, define networks, create virtual machines, manage user permissions and use templates from one central location.

1. Install Fedora 19 (or Red Hat Enterprise Linux 6.5 or CentOS 6.5) on a server. When prompted for the software packages to install, select the minimal install option. See the [Fedora Installation Guide](http://docs.fedoraproject.org/en-US/Fedora/19/html/Installation_Guide/index.html) or [Red Hat Enterprise Linux 6 Installation Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/index.html) for more details.

2. After you have installed your server, update all the packages on it. Run:

         # yum -y update

3. Reboot your server for the updates to be applied.

4. Subscribe the server to the oVirt project repository. For oVirt 3.6 install ovirt-release36.rpm. For oVirt 3.5 install ovirt-release35.rpm, and so on.

  `   # yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

5. You are now ready to install the oVirt Engine. Run the following command to download the oVirt Engine installation software and resolve all dependencies:

         # yum -y install ovirt-engine

6. When the packages have finished downloading, run the installer:

         # engine-setup

7. The installer will take you through a series of interactive questions as listed in the following example. If you do not enter a value when prompted, the installer uses the default settings which are stated in [ ] brackets.

Example 1: oVirt Engine installation

       [ INFO  ] Stage: Initializing
       [ INFO  ] Stage: Environment setup
               Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging.conf']
               Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140310163840.log
               Version: otopi-1.2.0_rc2 (otopi-1.2.0-0.7.rc2.fc19)
       [ INFO  ] Stage: Environment packages setup
       [ INFO  ] Stage: Programs detection
       [ INFO  ] Stage: Environment setup
       [ INFO  ] Stage: Environment customization
              
               --== PRODUCT OPTIONS ==--
               --== PACKAGES ==--
              
       [ INFO  ] Checking for product updates...
       [ INFO  ] No product updates found
          
               --== NETWORK CONFIGURATION ==--
              
               Host fully qualified DNS name of this server [server.name]: example.ovirt.org
               Setup can automatically configure the firewall on this system.
               Note: automatic configuration of the firewall may overwrite current settings.
               Do you want Setup to configure the firewall? (Yes, No) [Yes]:
       [ INFO  ] firewalld will be configured as firewall manager.
              
               --== DATABASE CONFIGURATION ==--
              
               Where is the Engine database located? (Local, Remote) [Local]: 
               Setup can configure the local postgresql server automatically for the engine to run. This may conflict with existing applications.
               Would you like Setup to automatically configure postgresql and create Engine database, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
              
               --== OVIRT ENGINE CONFIGURATION ==--
              
               Application mode (Both, Virt, Gluster) [Both]: 
               Default storage type: (NFS, FC, ISCSI, POSIXFS) [NFS]: 
               Engine admin password: 
               Confirm engine admin password: 
              
               --== PKI CONFIGURATION ==--
              
               Organization name for certificate [ovirt.org]: 
              
               --== APACHE CONFIGURATION ==--
              
               Setup can configure apache to use SSL using a certificate issued from the internal CA.
         
               Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
               Setup can configure the default page of the web server to present the application home page. This may conflict with existing applications.
               Do you wish to set the application as the default page of the web server? (Yes, No) [Yes]: 
              
               --== SYSTEM CONFIGURATION ==--
              
               Configure WebSocket Proxy on this machine? (Yes, No) [Yes]: 
               Configure an NFS share on this server to be used as an ISO Domain? (Yes, No) [Yes]: 
               Local ISO domain path [/var/lib/exports/iso-20140310143916]: 
               Local ISO domain ACL - note that the default will restrict access to example.ovirt.org only, for security reasons [example.ovirt.org(rw)]: 
               Local ISO domain name [ISO_DOMAIN]: 
              
               --== MISC CONFIGURATION ==--
         
               --== END OF CONFIGURATION ==--
              
       

Important points to note:

*   The default ports 80 and 443 must be available to access the manager on HTTP and HTTPS respectively.
*   If you elect to configure an NFS share it will be exported from the machine on which the manager is being installed.
*   The storage type that you select will be used to create a data center and cluster. You will then be able to attach storage to these from the Web Administration Portal.
*   The default ACL for the ISO_DOMAIN NFS export is allowing access to the current machine only. You need to provide read/write access to any host that will need to attach to this domain.

8. You are then presented with a summary of the configurations you have selected. Type yes to accept them.

Example 2: Confirm Engine installation settings

       [ INFO  ] Stage: Setup validation
              
                        --== CONFIGURATION PREVIEW ==--
              
               Engine database name                    : engine
               Engine database secured connection      : False
               Engine database host                    : localhost
               Engine database user name               : engine
               Engine database host name validation    : False
               Engine database port                    : 5432
               NFS setup                               : True
               PKI organization                        : ovirt.org
               Application mode                        : both
               Firewall manager                        : firewalld
               Update Firewall                         : True
               Configure WebSocket Proxy               : True
               Host FQDN                               : example.ovirt.org
               NFS export ACL                          : 0.0.0.0/0.0.0.0(rw)
               NFS mount point                         : /var/lib/exports/iso-20140310143916
               Datacenter storage type                 : nfs
               Configure local Engine database         : True
               Set application as default page         : True
               Configure Apache SSL                    : True
               Please confirm installation settings (OK, Cancel) [OK]:

9. The installation commences. The following message displays, indicating that the installation was successful.

Example 3: Successful installation

       [ INFO  ] Stage: Transaction setup
       [ INFO  ] Stopping engine service
       [ INFO  ] Stopping websocket-proxy service
       [ INFO  ] Stage: Misc configuration
       [ INFO  ] Stage: Package installation
       [ INFO  ] Stage: Misc configuration
       [ INFO  ] Creating PostgreSQL 'engine' database
       [ INFO  ] Configuring PostgreSQL
       [ INFO  ] Creating Engine database schema
       [ INFO  ] Creating CA
       [ INFO  ] Configuring WebSocket Proxy
       [ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
       [ INFO  ] Stage: Transaction commit
       [ INFO  ] Stage: Closing up
              
               --== SUMMARY ==--
              
`         SSH fingerprint: `<SSH_FINGERPRINT>
`         Internal CA: `<CA_FINGERPRINT>
               Web access is enabled at:
`             `[`http://example.ovirt.org:80/ovirt-engine`](http://example.ovirt.org:80/ovirt-engine)
`             `[`https://example.ovirt.org:443/ovirt-engine`](https://example.ovirt.org:443/ovirt-engine)
               Please use the user "admin" and password specified in order to login into oVirt Engine
              
               --== END OF SUMMARY ==--
              
       [ INFO  ] Starting engine service
       [ INFO  ] Restarting httpd
       [ INFO  ] Restarting nfs services
       [ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20140310163837-setup.conf'
       [ INFO  ] Stage: Clean up
               Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20140310163604.log
       [ INFO  ] Stage: Pre-termination
       [ INFO  ] Stage: Termination
       [ INFO  ] Execution of setup completed successfully
         
         **** Installation completed successfully ******

Your oVirt Engine is now up and running. You can log in to the oVirt Engine's web administration portal with the username admin (the administrative user configured during installation) in the internal domain. Instructions to do so are provided at the end of this chapter.

### Install Hosts

After you have installed the oVirt Engine, install the hosts to run your virtual machines. In oVirt, you can use either oVirt Node, Fedora or CentOS as hosts.

#### Install oVirt Node

This document provides instructions for installing oVirt Node using a CD. For alternative methods including PXE networks or USB devices, see the [oVirt Node deployment documentation](Vdsm-Node_Integration#Non-interactive_.28.22automatic.22.29_oVirt_installation).

Before installing the oVirt Node, you need to download the hypervisor image and create a bootable CD with the image.

**Download oVirt Node installation CD**

Download the latest version of ovirt Node from [oVirt Node release](http://resources.ovirt.org/pub/ovirt-4.0/iso/ovirt-node-ng-installer/) and burn the ISO image onto a disc.

Once you have created an oVirt Node installation CD, you can use it to boot the machine designated as your Node host. For this guide you will use the interactive installation where you are prompted to configure your settings in a graphical interface. Use the following keys to navigate around the installation screen:

Menu Navigation Keys

*   Use the Up and Down arrow keys to navigate between selections. Your selections are highlighted in white.
*   The Tab key allows you to move between fields.
*   Use the Spacebar to tick checkboxes, represented by [ ] brackets. A marked checkbox displays with an asterisk (\*).
*   To proceed with the selected configurations, press the Enter key.

**To configure oVirt Node installation settings**

1.  Insert the oVirt Node installation CD into the CD-ROM drive of the designated host machine and reboot the machine. When the boot splash screen displays, select Start oVirt Node to boot from the Node installation media. Press Enter.
2.  On the installation confirmation screen, select Install Hypervisor and press Enter.
3.  Select the appropriate keyboard layout for your system.
4.  The installer automatically detects the drives attached to the system. The selected disk for booting the hypervisor is highlighted in white. Ensure that the local disk is highlighted, or use the arrow keys to select the correct disk. Select Continue and press Enter.
5.  You are prompted to confirm your selection of the local drive, which is marked with an asterisk. Select Continue and press Enter.
6.  Enter a password for local console access and confirm it. Select Install and press Enter. The oVirt Node partitions the local drive, then commences installation.
7.  Once installation is complete, a dialog prompts you to Reboot the hypervisor. Press Enter to confirm. Remove the installation disc.
8.  After the Node has rebooted, you will be taken to a login shell. Log in as the admin user with the password you provided during installation to enter the oVirt Node management console.
9.  On the Node hypervisor management console, there are eleven tabs on the left. Press the Up and Down keys to navigate between the tabs and Tab or right-arrow to access them.

a. Select the Network tab. Configure the following options:

    * Hostname: Enter the hostname in the format of hostname.domain.example.com.

    * DNS Server: Enter the Domain Name Server address in the format of 192.168.0.254. You can use up to two DNS servers.

    * NTP Server: Enter the Network Time Protocol server address in the format of ovirt.pool.ntp.org. This synchronizes the hypervisor's system clock with that of the Engine's. You can use up to two NTP servers. Select Apply and press Enter to save your network settings.

    * The installer automatically detects the available network interface devices to be used as the management network. Select the device and press Enter to access the interface configuration menu. Under IPv4 Settings, tick either the DHCP or Static checkbox. If you are using static IPv4 network configuration, fill in the IP Address, Netmask and Gateway fields.

<!-- -->

To confirm your network settings, select OK and press Enter.

<!-- -->

b. Select the oVirt Engine tab. Configure the following options:

    * Management Server: Enter the oVirt Engine domain name in the format of ovirt.demo.example.com.

    * Management Server Port: Enter the management server port number. The default is 443.

    * Connect to the oVirt Engine and Validate Certificate: Tick this checkbox if you wish to verify the oVirt Engine security certificate.

    * Set oVirt Engine Admin Password: This field allows you to specify the root password for the hypervisor, and enable SSH password authentication from the oVirt Engine. This field is optional, and is covered in more detail in the [oVirt Installation Guide](/images/a/a9/OVirt-3.0-Installation_Guide-en-US.pdf).

<!-- -->

c. Select Apply and press Enter. A dialog displays, asking you to connect the hypervisor to the oVirt Engine and validate its certificate. Select Approve and press Enter. A message will display notifying you that the manager configuration has been successfully updated.

<!-- -->

d. Accept all other default settings. For information on configuring security, logging, kdump and remote storage, refer to the [oVirt Node deployment instructions](Vdsm-Node_Integration#Non-interactive_.28.22automatic.22.29_oVirt_installation).

e. Finally, select the Status tab. Select Restart and press Enter to reboot the host and apply all changes.

You have now successfully installed the oVirt Node. Repeat this procedure if you wish to use more hypervisors. The following sections will provide instructions on how to [ approve the hypervisors](#Approve_oVirt_Node_Host) for use with the oVirt Engine.

#### Install Fedora or CentOS Host

You now know how to install a oVirt Node. In addition to hypervisor hosts, you can also reconfigure servers which are running Fedora to be used as virtual machine hosts.

**To install a Fedora 19 host**

1. On the machine designated as your Fedora host, install Fedora 19. A minimal installation is sufficient.

2. Log in to your Fedora host as the **root** user.

3. Install the *ovirt-release36* or "ovirt-release35" package using **yum**, this package configures your system to receive updates from the oVirt project's software repository:

  `   # yum localinstall `[`http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

4. The oVirt platform uses a number of network ports for management and other virtualization features. oVirt Engine can make the necessary firewall adjustments automatically while adding your host. Alternatively, you may adjust your Fedora host's firewall settings to allow access to the required ports by configuring iptables rules. Modify the /etc/sysconfig/iptables file so it resembles the following example:

   ```
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
   ```
5. Ensure that the iptables service is configured to start on boot and has been restarted, or started for the first time if it was not already running. Run the following commands:

 `   # chkconfig iptables on`
 `   # service iptables restart`

6. Some versions of Fedora come without the **tar** command installed by default, specially if you make a minimal installation, but this command is required in order to configure the host from the engine, so install it if needed:

 `   # yum install tar`

7. Check if NetworkManager is being used for the network interface that is going to be used between the engine and this host. If it is change it to No. NetworkManager interfers with the bridge setup later when deploying vdsm. This is atleast true for Fedora 19 but might work with Fedora >19.

You have now successfully installed a Fedora host. As before, repeat this procedure if you wish to use more Linux hosts. Before you can start running virtual machines on your host, you have to manually add it to the oVirt Engine via the administration portal, which you will access in the next step.

**To install a CentOS 6.5 host**

Follow the instructions for a Fedora 19 host.

## Connect to oVirt Engine

Now that you have installed the oVirt Engine and hosts, you can log in to the Engine administration portal to start configuring your virtualization environment.

### Log in to the Administration Portal

Ensure you have the administrator password configured during installation as instructed in Example 1: “oVirt Engine installation”.

To connect to oVirt web management portal

1.  Open a browser and navigate to <https://domain.example.com/webadmin>. Substitute domain.example.com with the URL provided during installation.
2.  If this is your first time connecting to the administration portal, oVirt Engine will issue security certificates for your browser. Click the link labelled this certificate to trust the ca.cer certificate. A pop-up displays, click Open to launch the Certificate dialog. Click Install Certificate and select to place the certificate in Trusted Root Certification Authorities store.
3.  The portal login screen displays. Enter admin as your User Name, and enter the Password that you provided during installation. Ensure that your domain is set to Internal. Click Login.

You have now successfully logged in to the oVirt web administration portal. Here, you can configure and manage all your virtual resources. The functions of the oVirt Engine graphical user interface are described in the following figure and list:

![Figure 1. Administration Portal Features](admin-portal-label.png "Figure 1. Administration Portal Features")
ovirt-site/source/images/wiki/Admin-portal-label.png 

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

![Figure 2. Data Centers Tab](data-center-view.png "Figure 2. Data Centers Tab")
ovirt-site/source/images/wiki/Data-center-view.png 
 
The Default data center is used for this document, however if you wish to create a new data center see the [oVirt Administration Guide](oVirt Administration Guide).

### Configure Clusters

A cluster is a set of physical hosts that are treated as a resource pool for a set of virtual machines. Hosts in a cluster share the same network infrastructure, the same storage and the same type of CPU. They constitute a migration domain within which virtual machines can be moved from host to host. By default, oVirt creates a cluster at installation. To access it, navigate to the Tree pane, click Expand All and select the Default cluster. On the Clusters tab, the Default cluster displays.

![Figure 3. Clusters Tab](cluster-view.png "Figure 3. Clusters Tab")
ovirt-site/source/images/wiki/Cluster-view.png 

For this document, the oVirt Node and Fedora hosts will be attached to the Default host cluster. If you wish to create new clusters, or live migrate virtual machines between hosts in a cluster, see the [oVirt Administration Guide](OVirt_Administration_Guide).

### Configure Networks

At installation, oVirt defines a Management network for the default data center. This network is used for communication between the manager and the host. New logical networks - for example for guest data, storage or display - can be added to enhance network speed and performance. All networks used by hosts and clusters must be added to data center they belong to.

To access the Management network, click on the Clusters tab and select the default cluster. Click the Logical Networks tab in the Details pane. The ovirtmgmt network displays.

![Figure 4. Logical Networks Tab](logical-network-view.png "Figure 4. Logical Networks Tab")
ovirt-site/source/images/wiki/Logical-network-view.png 

The ovirtmgmt Management network is used for this document, however if you wish to create new logical networks see the [oVirt Administration Guide](oVirt Administration Guide).

### Configure Hosts

You have already installed your oVirt Node and Fedora hosts, but before they can be used, they have to be added to the Engine. The oVirt Node is specifically designed for the oVirt platform, therefore it only needs a simple click of approval. Conversely, Fedora is a general purpose operating system, therefore reprogramming it as a host requires additional configuration.

#### Approve oVirt Node Host

The Hypervisor you installed in [ Install oVirt Node](#Install_oVirt_Node) is automatically registered with the oVirt platform. It displays in the oVirt Engine, and needs to be approved for use.

**To set up a oVirt Node host**

1. On the Tree pane, click Expand All and select Hosts under the Default cluster. On the Hosts tab, select the name of your newly installed hypervisor.

2. Click the Approve button. The Edit and Approve Host dialog displays. Accept the defaults or make changes as necessary, then click OK.

3. The host status will change from Non Operational to Up.

#### Attach Fedora or CentOS Host

In contrast to the oVirt Node host, the Fedora host you installed “Install Fedora Host” is not automatically detected. It has to be manually attached to the oVirt platform before it can be used.

**To attach a Fedora host**

1. On the Tree pane, click Expand All and select Hosts under the Default cluster. On the Hosts tab, click New.

2. The New Host dialog displays.

![Figure 5. Attach Fedora Host](new-host.png "Figure 5. Attach Fedora Host")
ovirt-site/source/images/wiki/New-host.png 

Enter the details in the following fields:

*   Data Center: the data center to which the host belongs. Select the Default data center.
*   Host Cluster: the cluster to which the host belongs. Select the Default cluster.
*   Name: a descriptive name for the host.
*   Address: the IP address, or resolvable hostname of the host, which was provided during installation.
*   Root Password: the password of the designated host; used during installation of the host.
*   Configure iptables rules: This checkbox allows you to override the firewall settings on the host with the default rules for oVirt.

3. If you wish to configure this host for Out of Band (OOB) power management, select the Power Management tab. Tick the Enable Power Management checkbox and provide the required information in the following fields:

    * Address: The address of the host.

    * User Name: A valid user name for the OOB management.

    * Password: A valid, robust password for the OOB management.

    * Type: The type of OOB management device. Select the appropriate device from the drop down list.

:\*\* alom Sun Advanced Lights Out Manager

:\*\* apc American Power Conversion Master MasterSwitch network power switch

:\*\* bladecenter IBM Bladecentre Remote Supervisor Adapter

:\*\* drac5 Dell Remote Access Controller for Dell computers

:\*\* eps ePowerSwitch 8M+ network power switch

:\*\* ilo HP Integrated Lights Out standard

:\*\* ilo3 HP Integrated Lights Out 3 standard

:\*\* ipmilan Intelligent Platform Management Interface

:\*\* rsa IBM Remote Supervisor Adaptor

:\*\* rsb Fujitsu-Siemens RSB management interface

:\*\* wti Western Telematic Inc Network PowerSwitch

:\*\* cisco_ucs Cisco Unified Computing System Integrated Management Controller

    * Options: Extra command line options for the fence agent. Detailed documentation of the options available is provided in the man page for each fence agent.

Click the Test button to test the operation of the OOB management solution.

If you do not wish to configure power management, leave the Enable Power Management checkbox unmarked.

4. Click OK. If you have not configured power management, a pop-up window prompts you to confirm if you wish to proceed without power management. Select OK to continue.

5. The new host displays in the list of hosts with a status of Installing. Once installation is complete, the status will update to Reboot and then Awaiting. When the host is ready for use, its status changes to Up.

**To attach a CentOS 6.5 host**

Follow the instructions for a Fedora 19 host.

You have now successfully configured your hosts to run virtual machines. The next step is to prepare data storage domains to house virtual machine disk images.

### Configure Storage

After configuring your logical networks, you need to add storage to your data center.

oVirt uses a centralized shared storage system for virtual machine disk images and snapshots. Storage can be implemented using Network File System (NFS), Internet Small Computer System Interface (iSCSI) or Fibre Channel Protocol (FCP). Storage definition, type and function, are encapsulated in a logical entity called a Storage Domain. Multiple storage domains are supported.

For this guide you will use two types of storage domains. The first is an NFS share for ISO images of installation media. You have already created this ISO domain during the oVirt Engine installation.

The second storage domain will be used to hold virtual machine disk images. For this domain, you need at least one of the supported storage types. You have already set a default storage type during installation as described in [ Install oVirt Engine](#Install_oVirt_Engine). Ensure that you use the same type when creating your data domain.

**Select your next step by checking the storage type you should use:**

1.  Navigate to the Tree pane and click the Expand All button. Under System, click Default. On the results list, the Default data center displays.
2.  On the results list, the Storage Type column displays the type you should add.
3.  Now that you have verified the storage type, create the storage domain - see one of:

    * [ Create an NFS Data Domain](#Create_an_NFS_Data_Domain).

    * [ Create an iSCSI Data Domain](#Create_an_iSCSI_Data_Domain).

    * [ Create an FCP Data Domain](#Create_an_FCP_Data_Domain).

#### Create an NFS Data Domain

Because you have selected NFS as your default storage type during the Manager installation, you will now create an NFS storage domain. An NFS type storage domain is a mounted NFS share that is attached to a data center and used to provide storage for virtual machine disk images.

Information on how to create NFS exports can be found at <http://fedoraproject.org/wiki/Administration_Guide_Draft/NFS>.

A sample /etc/exports configuration might look like:

         # Please refer to the NFS documentation for your operating system on how to setup NFS security.
         # As they exist here, these shares have no access restrictions.
         /export/iso            *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)
         /export/data           *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)
         /export/import_export  *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)

Once you have setup the NFS exports, you can now add them in oVirt.

**To add NFS storage:**

1. Navigate to the Tree pane and click the Expand All button. Under System, select the Default data center and click on Storage. The available storage domains display on the results list. Click New Domain.

2. The New Storage dialog box displays.

Configure the following options:

*   Name: Enter a suitably descriptive name.
*   Data Center: The Default data center is already pre-selected.
*   Domain Function / Storage Type: In the drop down menu, select Data → NFS. The storage domain types not compatible with the Default data center are grayed out. After you select your domain type, the Export Path field appears.

Use Host: Select any of the hosts from the drop down menu. Only hosts which belong in the pre-selected data center will display in this list.

    * Export path: Enter the IP address or a resolvable hostname of the NFS server. The export path should be in the format of 192.168.0.10:/data or domain.example.com:/data

3. Click OK. The new NFS data domain displays on the Storage tab. It will remain with a Locked status while it is being prepared for use. When ready, it is automatically attached to the data center.

You have created an NFS storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to [ Attach an ISO domain](#Attach_an_ISO_domain).

#### Create an iSCSI Data Domain

Because you have selected iSCSI as your default storage type during the Manager installation, you will now create an iSCSI storage domain. oVirt platform supports iSCSI storage domains spanning multiple pre-defined Logical Unit Numbers (LUNs).

**To add iSCSI storage:**

1. On the side pane, select the Tree tab. On System, click the + icon to display the available data centers.

2. Double click on the Default data center and click on Storage. The available storage domains display on the results list. Click New Domain.

3. The New Domain dialog box displays.

Configure the following options:

*   Name: Enter a suitably descriptive name.
*   Data Center: The Default data center is already pre-selected.
*   Domain Function / Storage Type: In the drop down menu, select Data → iSCSI. The storage domain types which are not compatible with the Default data center are grayed out. After you select your domain type, the Use Host and Discover Targets fields display.
*   Use host: Select any of the hosts from the drop down menu. Only hosts which belong in this data center will display in this list.

4. To connect to the iSCSI target, click the Discover Targets bar. This expands the menu to display further connection information fields.

Enter the required information:

*   Address: Enter the address of the iSCSI target.
*   Port: Select the port to connect to. The default is 3260.
*   User Authentication: If required, enter the username and password.

5. Click the Discover button to find the targets. The iSCSI targets display in the results list with a Login button for each target.

6. Click Login to display the list of existing LUNs. Tick the Add LUN checkbox to use the selected LUN as the iSCSI data domain.

7. Click OK. The new iSCSI data domain displays on the Storage tab. It will remain with a Locked status while it is being prepared for use. When ready, it is automatically attached to the data center.

You have created an iSCSI storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to [ Attach an ISO domain](#Attach_an_ISO_domain).

#### Create an FCP Data Domain

Because you have selected FCP as your default storage type during the Manager installation, you will now create an FCP storage domain. oVirt platform supports FCP storage domains spanning multiple pre-defined Logical Unit Numbers (LUNs).

**To add FCP storage:**

1. On the side pane, select the Tree tab. On System, click the + icon to display the available data centers.

2. Double click on the Default data center and click on Storage. The available storage domains display on the results list. Click New Domain.

3. The New Domain dialog box displays.

Configure the following options:

*   Name: Enter a suitably descriptive name.
*   Data Center: The Default data center is already pre-selected.
*   Domain Function / Storage Type: Select FCP.
*   Use Host: Select the IP address of either the hypervisor or Red Hat Enterprise Linux host.
*   The list of existing LUNs display. On the selected LUN, tick the Add LUN checkbox to use it as the FCP data domain.

4. Click OK. The new FCP data domain displays on the Storage tab. It will remain with a Locked status while it is being prepared for use. When ready, it is automatically attached to the data center.

You have created an FCP storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to [ Attach an ISO domain](#Attach_an_ISO_domain)

#### Attach an ISO domain

You have defined your first storage domain to store virtual guest data, now it is time to configure your second storage domain, which will be used to store installation images for creating virtual machines. You have already created a local ISO domain during the installation of the oVirt Engine. To use this ISO domain, attach it to a data center.

**To attach the ISO domain**

1. Navigate to the Tree pane and click the Expand All button. Click Default. On the results list, the Default data center displays.

2. On the details pane, select the Storage tab and click the Attach ISO button.

3. The Attach ISO Library dialog appears with the available ISO domain. Select it and click OK.

4. The ISO domain appears in the results list of the Storage tab. It displays with the Locked status as the domain is being validated, then changes to Inactive.

5. Select the ISO domain and click the Activate button. The status changes to Locked and then to Active.

#### Uploading ISO images

Media images (CD-ROM or DVD-ROM in the form of ISO images) must be available in the ISO repository for the virtual machines to use. To do so, oVirt provides a utility that copies the images and sets the appropriate permissions on the file. The file provided to the utility and the ISO share have to be accessible from the oVirt Engine.

Log in to the oVirt Engine server console to upload images to the ISO domain.

**To upload ISO images**

1. Create or acquire the appropriate ISO images from boot media. Ensure the path to these images is accessible from the oVirt Engine server.

2. The next step is to upload these files. First, determine the available ISO domains by running:

         # engine-iso-uploader list

You will be prompted to provide the admin user password which you use to connect to the administration portal. The tool lists the name of the ISO domain that you attached in the previous section.

         ISO Storage Domain List:
           local-iso-share

Now you have all the information required to upload the required files. On the Engine console, copy your installation images to the ISO domain. For your images, run:

         # engine-iso-uploader upload -i local-iso-share [file1] [file2] .... [fileN]

You will be prompted for the admin user password again. Provide it and press Enter.

Note that the uploading process can be time consuming, depending on your storage performance.

3. After the images have been uploaded, check that they are available for use in the Manager administration portal.

a. Navigate to the Tree and click the Expand All button.

b. Under Storage, click on the name of the ISO domain. It displays in the results list. Click on it to display its details pane.

c. On the details pane, select the Images tab. The list of available images should be populated with the files that you have uploaded.

Now that you have successfully prepared the ISO domain for use, you are ready to start creating virtual machines.

## Create Virtual Machines

The final stage of setting up oVirt is the virtual machine lifecycle--spanning the creation, deployment and maintenance of virtual machines; using templates; and configuring user permissions. This section will also show you how to log in to the user portal and connect to virtual machines.

On oVirt, you can create virtual machines from an existing template, as a clone, or from scratch. Once created, virtual machines can be booted using ISO images, a network boot (PXE) server, or a hard disk. This document provides instructions for creating a virtual machine using an ISO image.

### Create a Fedora Virtual Machine

1. From the navigation tabs, select Virtual Machines. On the Virtual Machines tab, click New VM.

2. The “New Virtual Machine” popup appears.
![Figure 6: Create new linux virtual machine](New_VM_Fedora.png "Figure 6: Create new linux virtual machine")
ovirt-site/source/images/wiki/New-fedora-server.png 

3. Under General, your default Cluster and Template will be fine.

4. For Operating System, choose Red Hat Enterprise Linux (for i386/i686 Fedora) or Red Hat Enterprise Linux x64 (for x86_64 Fedora).

5. Under Optimized For, choose Desktop if you are creating a desktop VM, or Server if you are creating a server VM.

6. Add a Name (required) and a comment or description (optional).

7. Finally, attach a Network Interface (optional) to the VM by selecting one from the dropdown.

8. Click OK.

9. A New Virtual Machine - Guide Me window opens. This allows you to add storage disks to the virtual machine.

![Figure 7. New Virtual Machine](Guide_Me.png "Figure 7. New Virtual Machine")
ovirt-site/source/images/wiki/Guide_Me.png 

10. Click Configure Virtual Disks to add storage to the virtual machine.

11. Enter a Size for the disk.

12. Click OK.

The parameters in the following figure such as Interface and Allocation Policy are recommended, but can be edited as necessary.

![Figure 8. Add Virtual Disk configurations](Add_Virtual_Disk_Fedora.png "Figure 8. Add Virtual Disk configurations")
ovirt-site/source/images/wiki/Add_Virtual_Disk_Fedora.png 

13. Close the Guide Me window by clicking Configure Later. Your new Fedora virtual machine will display in the Virtual Machines tab.

You have now created your Fedora virtual machine. Before you can use your virtual machine, install an operating system on it.

**To install the Fedora guest operating system:**

1. Right click the virtual machine and select Run Once.

2. Check “Attach CD” and choose a disk from the list

3. Click OK.

![Figure 9. Run once menu](Run_Once_Fedora.png "Figure 9. Run once menu")
ovirt-site/source/images/wiki/Run_Once_Fedora.png 

Retain the default settings for the other options and click OK to start the virtual machine.

4. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system. For further instructions, see the [Fedora Installation Guide](https://docs.fedoraproject.org/en-US/Fedora/19/html/Installation_Guide/index.html).

5. After the installation has completed, shut down the virtual machine and reboot from the hard drive.

You can now connect to your Fedora virtual machine and start using it.

**Post Install Additions**

Adding a few guest tools may improve your experience.

*   oVirt Guest Agent allows oVirt to show the Memory and Network utilization of the VM, the IP address of the VM, the installed Applications, Enable Single Sign On (SSO) and more.
*   Spice-vdagent allows for copy and paste support (text & image), better mouse functionality, and automatic adjustment of the screen resolution based on the size of your window.

Add the oVirt Guest Agent by following the directions at [How to install the guest agent in Fedora](How_to_install_the_guest_agent_in_Fedora)

#### Creating a Windows 7 VM

1. From the navigation tabs, select Virtual Machines. On the Virtual Machines tab, click New VM.

![Figure 10. The navigation tabs](Navigation_Tabs.png "Figure 10. The navigation tabs")
 ovirt-site/source/images/wiki/Navigation_Tabs.png 

2. The “New Virtual Machine” popup appears.

![Figure 11. Create new Windows virtual machine](New_VM_Win7.png "Figure 11. Create new Windows virtual machine")
ovirt-site/source/images/wiki/New_VM_Win7.png 

3. Under General, your default Cluster and Template will be fine.

4. For Operating System, choose Windows 7 (for 32-bit Windows) or Windows7 x64 (for 64-bit Windows).

5. Under Optimized For, choose Desktop.

6. Add a Name (required) and a comment or description (optional).

7. Finally, attach a Network Interface (optional) to the VM by selecting one from the dropdown.

8. Click OK

9. A New Virtual Machine - Guide Me window opens. This allows you to add storage disks to the virtual machine.

![Figure 12. New Virtual Machine – Guide Me](Guide_Me.png "Figure 12. New Virtual Machine – Guide Me")
ovirt-site/source/images/wiki/Guide_Me.png 

10. Click Configure Virtual Disks to add storage to the virtual machine.

11. Enter a Size for the disk.

12. Click OK.

The parameters in the following figure such as Interface and Allocation Policy are recommended, but can be edited as necessary.

![Figure 13. Add Virtual Disk configurations](Add_Virtual_Disk_Win7.png "Figure 13. Add Virtual Disk configurations")
ovirt-site/source/images/wiki/Add_Virtual_Disk_Win7.png


13. Close the Guide Me window by clicking Configure Later. Your new Windows 7 virtual machine will display in the Virtual Machines tab.

You have now created your Windows 7 virtual machine. Before you can use your virtual machine you need to install an operating system on it.

**To install Windows guest operating system**

1. Right click the virtual machine and select Run Once.

2. Check “Attach CD” and choose a disk from the list

3. Click OK.

![Figure 14. Run once menu](Run_Once_Win7.jpg "Figure 14. Run once menu")
ovirt-site/source/images/wiki/Run_Once_Win7.png 


Retain the default settings for the other options and click OK to start the virtual machine.

4. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system.

5. Continue with the Windows 7 install as normal until you reach "Where do you want to install Windows?"

##### Installing with a VirtIO interface

<div class="toccolours mw-collapsible mw-collapsed" style="width:800px">
"Where do you want to install Windows?" does not show any disks. Click to expand this section.

<div class="mw-collapsible-content">
![No disks available](Install_Windows7_VirtIO_Disk.png "fig:No disks available")
ovirt-site/source/images/wiki/Install_Windows7_VirtIO_Disk.png  
 
You need to load the VirtIO driver. 1. On the Navigation Tabs, click Change CD
![Change CD](Navigation_Tabs_Change_CD.png "fig:Change CD")
ovirt-site/source/images/wiki/Navigation_Tabs_Change_CD.png

2. From the drop down list select the virtio CD and click ok.
![VirtIO CD](Change_CD_virtio.png "fig:VirtIO CD")
ovirt-site/source/images/wiki/Change_CD_virtio.png 

3. On the console, click "Load Drivers"

4. On the "Load Driver" popup, click Browse

5. Browse to the CD, Win7 folder. Choose the appropriate architecture (AMD64 for 64-bit, x86 for 32-bit) and click OK.

6. The VirtIO Drivers should appear. Choose "Red Hat VirtIO SCSI Controller", and then click Next
![Drivers Available](Install_Windows7_VirtIO_Drivers.jpg "fig:Drivers Available")
ovirt-site/source/images/wiki/Install_Windows7_VirtIO_Drivers.png 

7. The driver should install and return to the "Where do you want to install Windows?" screen now showing a disk to install to. Note that a message has appeared that "Windows cannot be installed to this disk"

8. On the Navigation Tabs, click Change CD

9. From the drop down list select the Windows 7 install media and click ok.

10. On the console, click "Refresh". The "Windows cannot be installed to this disk" message should disappear as the system can see the Windows install media again.

11. Continue with the install as normal

</div>
</div>
##### Installing with a IDE interface

"Where do you want to install Windows?" shows a disk to install to. Continue as normal.

#### Post Install Additions

##### Drivers

If you choose to use the VirtIO disk interface, the VirtIO network interface, or wish to use the oVirt Guest Tools through the VirtIO-Serial interface, you need to install additional drivers. 
![Device Manager](Device_Manager_Win7_Missing_Drivers_VirtIO.jpg "fig:Device Manager") 1. On the console, open the Device Manger
ovirt-site/source/images/wiki/Device_Manager_Win7_Missing_Drivers_VirtIO.png 

2. On the Navigation Tabs, click Change CD
![Change CD](Navigation_Tabs_Change_CD.jpg "fig:Change CD")
ovirt-site/source/images/wiki/Navigation_Tabs_Change_CD.png

3. From the drop down list select the virtio CD and click ok.
![VirtIO CD](Change_CD_virtio.png "fig:VirtIO CD")
ovirt-site/source/images/wiki/Change_CD_virtio.png 

4. On the console, right click the first device that is missing drivers

5. Select "Update Driver Software", and then "Browse my computer for driver software"

6. Browse to the CD, Win7 folder. Choose the appropriate architecture (AMD64 for 64-bit, x86 for 32-bit) and click OK.

7. When prompted to install the driver, check "Always trust software from Red Hat, Inc" and click Install.

8. Repeat the above for the remaining missing drivers.

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

![Figure 15. Make new virtual machine template](Make-template.png  "Figure 15. Make new virtual machine template")
 ovirt-site/source/images/wiki/Make-template.png 
Enter information into the following fields:

    * Name: Name of the new template

    * Description: Description of the new template

    * Host Cluster: The Host Cluster for the virtual machines using this template.

    * Make Private: If you tick this checkbox, the template will only be available to the template's creator and the administrative user. Nobody else can use this template unless they are given permissions by the existing permitted users.

3. Click OK. The virtual machine displays a status of "Image Locked" while the template is being created. The template is created and added to the Templates tab. During this time, the action buttons for the template remain disabled. Once created, the action buttons are enabled and the template is ready for use.

#### Clone a Red Hat Enterprise Linux Virtual Machine

In the previous section, you created a Fedora template complete with pre-configured storage, networking and operating system settings. Now, you will use this template to deploy a pre-installed virtual machine.

**To clone a Fedora virtual machine from a template**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, click New Server.

![Figure 16. Create virtual machine based on Linux template](Fedora-server-clone.png "Figure 16. Create virtual machine based on Linux template")
ovirt-site/source/images/wiki/Fedora-server-clone.png 

    * On the General tab, select the existing Linux template from the Based on Template list.

    * Enter a suitable Name and appropriate Description, then accept the default values inherited from the template in the rest of the fields. You can change them if needed.

    * Click the Resource Allocation tab. On the Provisioning field, click the drop down menu and select the Clone option.

![Figure 17. Set the provisioning to Clone](New-vm-allocation.png "Figure 17. Set the provisioning to Clone")
ovirt-site/source/images/wiki/New-vm-allocation.png 

2. Retain all other default settings and click OK to create the virtual machine. The virtual machine displays in the Virtual Machines list.

#### Create a Windows Template

To make a Windows virtual machine template, use the virtual machine you created [ Create a Windows Virtual Machine](#Create_a_Windows_Virtual_Machine) as a basis.

Before a template for Windows virtual machines can be created, it has to be sealed with sysprep. This ensures that machine-specific settings are not propagated through the template.

Note that the procedure below is applicable for creating Windows 7 and Windows 2008 R2 templates. If you wish to seal a Windows XP template, refer to the [oVirt Administration Guide](oVirt Administration Guide).

**To seal a Windows virtual machine with sysprep**

1. In the Windows virtual machine to be used as a template, open a command line terminal and type regedit.

2. The Registry Editor window displays. On the left pane, expand HKEY_LOCAL_MACHINE → SYSTEM → SETUP.

3. On the main window, right click to add a new string value using New → String Value. Right click on the file and select Modify. When the Edit String dialog box displays, enter the following information in the provided text boxes:

    * Value name: UnattendFile

    * Value data: a:\\sysprep.inf

4. Launch sysprep from C:\\Windows\\System32\\sysprep\\sysprep.exe

    * Under System Cleanup Action, select Enter System Out-of-Box-Experience (OOBE).

    * Tick the Generalize checkbox if you need to change the computer's system identification number (SID).

    * Under Shutdown Options, select Shutdown.

5. Click OK. The virtual machine will now go through the sealing process and shut down automatically.

**To create a template from an existing Windows machine**

1. In the administration portal, click the Virtual Machines tab. Select the sealed Windows 7 virtual machine. Ensure that it has a status of Down and click Make Template.

2. The New Virtual Machine Template displays. Enter information into the following fields:

    * Name: Name of the new template

    * Description: Description of the new template

    * Host Cluster: The Host Cluster for the virtual machines using this template.

    * Make Public: Check this box to allow all users to access this template.

3. Click OK. In the Templates tab, the template displays the "Image Locked" status icon while it is being created. During this time, the action buttons for the template remain disabled. Once created, the action buttons are enabled and the template is ready for use.

You can now create new Windows machines using this template.

#### Create a Windows Virtual Machine from a Template

This section describes how to create a Windows 7 virtual machine using the template created in [ Create a Windows Template](#Create_a_Windows_Template).

**To create a Windows virtual machine from a template**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, click New Desktop.

    * Select the existing Windows template from the Based on Template list.

    * Enter a suitable Name and appropriate Description, and accept the default values inherited from the template in the rest of the fields. You can change them if needed.

2. Retain all other default setting and click OK to create the virtual machine. The virtual machine displays in the Virtual Machines list with a status of "Image Locked" until the virtual disk is created. The virtual disk and networking settings are inherited from the template, and do not have to be reconfigured.

3. Click the Run icon to turn it on. This time, the Run Once steps are not required as the operating system has already been installed onto the virtual machine hard drive. Click the green Console button to connect to the virtual machine.

You have now learned how to create Fedora and Windows virtual machines with and without templates. Next, you will learn how to access these virtual machines from a user portal.

### Using Virtual Machines

Now that you have created several running virtual machines, you can assign users to access them from the user portal. You can use virtual machines the same way you would use a physical desktop.

#### Assign User Permissions

oVirt has a sophisticated multi-level administration system, in which customized permissions for each system component can be assigned to different users as necessary. For instance, to access a virtual machine from the user portal, a user must have either UserRole or PowerUserRole permissions for the virtual machine. These permissions are added from the manager administration portal. For more information on the levels of user permissions refer to the [oVirt Administration Guide](oVirt Administration Guide).

**To assign PowerUserRole permissions**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, select the virtual machine you would like to assign a user to.

2. On the Details pane, navigate to the Permissions tab. Click the Add button.

3. The Add Permission to User dialog displays. Enter a Name, or User Name, or part thereof in the Search textbox, and click Go. A list of possible matches display in the results list.

![Figure 18. Add PowerUserRole Permission](vm-add-perm.png "Figure 18. Add PowerUserRole Permission")

4. Select the check box of the user to be assigned the permissions. Scroll through the Assign role to user list and select PowerUserRole. Click OK.

#### Log in to the User Portal

Now that you have assigned PowerUserRole permissions on a virtual machine to the user named admin, you can access the virtual machine from the user portal. To log in to the user portal, all you need is a Linux client running Mozilla Firefox.

If you are using a Fedora client, install the SPICE plug-in before logging in to the User Portal. Run:

         # yum install spice-xpi

**To log in to the User Portal**

1. Open your browser and navigate to <https://domain.example.com/UserPortal>. Substitute domain.example.com with the oVirt Engine server address.

2. The login screen displays. Enter your User Name and Password, and click Login.

You have now logged into the user portal. As you have PowerUserRole permissions, you are taken by default to the Extended User Portal, where you can create and manage virtual machines in addition to using them. This portal is ideal if you are a system administrator who has to provision multiple virtual machines for yourself or other users in your environment.

![Figure 19. The Extended User Portal](Power-user-portal.png "Figure 19. The Extended User Portal")

You can also toggle to the Basic User Portal, which is the default (and only) display for users with UserRole permissions. This portal allows users to access and use virtual machines, and is ideal for everyday users who do not need to make configuration changes to the system. For more information, see the [oVirt User Portal Guide](oVirt User Portal Guide).

![Figure 20. The Basic User Portal](Basic-user-portal.png "Figure 20. The Basic User Portal")
ovirt-site/source/images/wiki/Basic-user-portal.png 

You have now completed the Quick Start Guide, and successfully set up oVirt.


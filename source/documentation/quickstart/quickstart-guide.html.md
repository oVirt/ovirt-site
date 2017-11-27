---
title: Quick Start Guide
category: documentation
layout: toc
authors: adahms, bproffitt, didi, fab, gianluca, gshereme, jbrooks, jhernand, jonar,
  jvdwege, knesenko, mgoldboi, nkesick, oschreib, rydekull, sandrobonazzola, sgordon,
  vered, wdennis
---

# Quick Start Guide

## Introduction

This step-by-step guide shows first-time users how to install and configure a basic
oVirt environment and create virtual machines.

### Prerequisites

Before starting, please check the [System Requirements](/documentation/install-guide/chap-System_Requirements/)
for both oVirt Engine and oVirt nodes and hosts .

#### oVirt Engine

*   The host running ovirt-engine must be configured to receive updates from the oVirt project's software
    repository, as provided by the ovirt-release package matching your OS distribution:
    -   [oVirt 4.1](http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm).
*   A client for connecting to oVirt Engine.

#### For each Host

*   All CPUs must have support for the Intel® 64 or AMD64 CPU extensions, and the
    AMD-V™ or Intel VT® hardware virtualization extensions should be enabled. Support
    for the No eXecute flag (NX) is also required.
*   The host must be configured to receive updates from the oVirt project's software
    repository, as provided by the ovirt-release package matching your OS distribution:
    -   [oVirt 4.1](http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm).
*   If you are running Red Hat Enterprise Linux, make sure to enable the Extras channel. It is
    enabled by default on CentOS Linux.

#### Storage and Networking

*   At least one of the supported storage types (NFS, iSCSI, FCP, Local, POSIX FS, GlusterFS).
    -   For NFS storage, a valid IP address and export path is required.
    -   For iSCSI storage, a valid IP address and target information is required.
*   Static IP addresses for the oVirt Engine server and for each host server.
*   DNS service that can resolve (forward and reverse) all the IP addresses.
*   An existing DHCP server that can allocate network addresses for the virtual machines.
*   If you need to use the storage from your hosts instead of using storage provided by SAN / NAS,
    consider moving to [oVirt-Gluster Hyperconvergence](/documentation/gluster-hyperconverged/Gluster_Hyperconverged_Guide/).

#### Virtual Machines

Installation images for creating virtual machines, depending on which operating system you wish to use.
A list of supported guest distribution is available on our [Download](/download/#supported-guest-distributions) page.

## Install oVirt

The oVirt platform consists of at least one node and an oVirt Engine which may
be deployed in a virtual machine as Self-Hosted Engine
(See the [Self-Hosted Engine guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/) for more infromation).

*   oVirt Engine provides a graphical user interface to manage the physical and
    logical resources of the oVirt infrastructure.
    The Engine is installed on an Enterprise Linux 7 server, and accessed
    from a client running Firefox.

<!-- -->

*   oVirt Engine runs virtual machines. A physical server running an oVirt node or Enterprise Linux 7
    can be configured as a host for virtual machines on the oVirt platform.

### Install oVirt Engine

oVirt Engine is the control center of the oVirt environment.
It allows you to define hosts, configure data centers, add storage, define networks,
create virtual machines, manage user permissions and use templates from one central location.

1. Install the operating system on a server.
   When prompted for the software packages to install, select the minimal install option.
   See the  [Red Hat Enterprise Linux 7 Installation Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/index) for more details.

2. After you have installed your server, update all the packages on it. Run:

         # yum -y update

3. Reboot your server for the updates to be applied.

4. Subscribe the server to the oVirt project repository.
   For oVirt 4.1:

  `   # yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm)

5. You are now ready to install the oVirt Engine. Run the following command to download the oVirt Engine installation software and resolve all dependencies:

         # yum -y install ovirt-engine

6. When the packages have finished downloading, run the installer:

         # engine-setup

7. The installer will take you through a series of interactive questions.
   If you do not enter a value when prompted, the installer uses the default settings which are stated in [ ] brackets.

Important points to note:

*   The default ports 80 and 443 must be available to access the manager on HTTP and HTTPS respectively.
*   If you select to configure an NFS share it will be exported from the machine on which the manager is being installed.
*   The storage type that you select will be used to create a data center and cluster.
    You will then be able to attach storage to these from the Web Administration Portal.
*   The default ACL for the ISO_DOMAIN NFS export is allowing access to the current machine only.
    You need to provide read/write access to any host that will need to attach to this domain.

8. You are then presented with a summary of the configurations you have selected. Type yes to accept them.

9. The installation commences. Messages will be displayed during the process, indicating that the installation was successful.


Your oVirt Engine is now up and running.
You can log in to the oVirt Engine's Web Administration Portal with the username
admin (the administrative user configured during installation) in the internal domain.
Instructions to do so are provided at the end of this chapter.

### Install Hosts

After you have installed the oVirt Engine, install the hosts to run your virtual machines.
In oVirt, you can use either oVirt Node or Enterprise Linux 7 as hosts.

#### Install oVirt Node

Please refer to [Installing oVirt Node](/documentation/install-guide/chap-oVirt_Nodes/)
guide within the [oVirt Installation Guide](/documentation/install-guide/Installation_Guide/)

#### Install Enterprise Linux Host

Please refer to [Installing Enterprise Linux Hosts](/documentation/install-guide/chap-Enterprise_Linux_Hosts/)
guide within the [oVirt Installation Guide](/documentation/install-guide/Installation_Guide/)


## Configure oVirt

Now that you have logged in to the Administration Portal, configure your oVirt
environment by defining the data center, host cluster, networks and storage.
Even though this guide makes use of the default resources configured during installation,
if you are setting up a oVirt environment with completely new components,
you should perform the configuration procedure in the sequence given here.

### Configure Data Centers

A data center is a logical entity that defines the set of physical and logical
resources used in a managed virtual environment.
Think of it as a container which houses clusters of hosts, virtual machines, storage and networks.

By default, oVirt creates a data center at installation.
Its type is configured from the installation script.
To access it, navigate to the Tree pane, click Expand All, and select the Default data center.
On the Data Centers tab, the Default data center displays.

![Figure 2. Data Centers Tab](/images/wiki/Data-center-view.png "Figure 2. Data Centers Tab")

The Default data center is used for this document, however if you wish to create
a new data center see the [oVirt Administration Guide](/documentation/admin-guide/administration-guide/).

### Configure Clusters

A cluster is a set of physical hosts that are treated as a resource pool for a
set of virtual machines. Hosts in a cluster share the same network infrastructure,
the same storage and the same type of CPU.
They constitute a migration domain within which virtual machines can be moved from host to host.
By default, oVirt creates a cluster at installation.
To access it, navigate to the Tree pane, click Expand All and select the Default cluster.
On the Clusters tab, the Default cluster displays.

![Figure 3. Clusters Tab](/images/wiki/Cluster-view.png "Figure 3. Clusters Tab")

For this document, the oVirt Node and Enterprise Linux hosts will be attached to the Default host cluster.
If you wish to create new clusters, or live migrate virtual machines between hosts in a cluster,
see the [oVirt Administration Guide](/documentation/admin-guide/administration-guide/).

### Configure Networks

At installation, oVirt defines a Management network for the default data center.
This network is used for communication between the manager and the host.
New logical networks - for example for guest data, storage or display - can be
added to enhance network speed and performance.
All networks used by hosts and clusters must be added to the data center they belong to.

To access the Management network, click on the Clusters tab and select the default cluster.
Click the Logical Networks tab in the Details pane.
The ovirtmgmt network displays.

![Figure 4. Logical Networks Tab](/images/wiki/Logical-network-view.png "Figure 4. Logical Networks Tab")

The ovirtmgmt Management network is used for this document, however if you wish
to create new logical networks see the [oVirt Administration Guide](/documentation/admin-guide/administration-guide/).

#### Attach oVirt Node or Enterprise Linux Host

1. On the Tree pane, click Expand All and select Hosts under the Default cluster. On the Hosts tab, click New.

2. The New Host dialog displays.

![Figure 5. Attach a Host](/images/wiki/New-host.png "Figure 5. Attach a Host")

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


### Configure Storage

After configuring your logical networks, you need to add storage to your data center.

oVirt uses a centralized shared storage system for virtual machine disk images and snapshots.
Storage can be implemented using Network File System (NFS),
Internet Small Computer System Interface (iSCSI) or Fibre Channel Protocol (FCP).
Storage definition, type and function, are encapsulated in a logical entity called
a Storage Domain. Multiple storage domains are supported.

For this guide you will use two types of storage domains.
The first is an NFS share for ISO images of installation media.
You have already created this ISO domain during the oVirt Engine installation.

The second storage domain will be used to hold virtual machine disk images.
For this domain, you need at least one of the supported storage types.
You have already set a default storage type during installation as described in [Install oVirt Engine](/documentation/quickstart/quickstart-guide/#install-ovirt-engine).
Ensure that you use the same type when creating your data domain.

**Select your next step by checking the storage type you should use:**

1.  Navigate to the Tree pane and click the Expand All button. Under System, click Default. On the results list, the Default data center displays.
2.  On the results list, the Storage Type column displays the type you should add.
3.  Now that you have verified the storage type, create the storage domain - see one of:

    * [ Create an NFS Data Domain](/documentation/quickstart/quickstart-guide/#create-an-nfs-data-domain).

    * [ Create an iSCSI Data Domain](/documentation/quickstart/quickstart-guide/#create-an-iscsi-data-domain).

    * [ Create an FCP Data Domain](/documentation/quickstart/quickstart-guide/#create-an-fcp-data-domain).

#### Create an NFS Data Domain

Because you have selected NFS as your default storage type during the Manager installation,
you will now create an NFS storage domain.
An NFS type storage domain is a mounted NFS share that is attached to a data center and used to provide storage for virtual machine disk images.

Information on how to create NFS exports can be found at <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-nfs>.

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

You have created an NFS storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to [Attach an ISO domain](/documentation/quickstart/quickstart-guide/#attach-an-iso-domain).

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

You have created an iSCSI storage domain. Now, you need to attach an ISO domain to the data center and upload installation images so you can use them to create virtual machines. Proceed to [Attach an ISO domain](/documentation/quickstart/quickstart-guide/#attach-an-iso-domain).

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

You have created an FCP storage domain.
Now, you need to attach an ISO domain to the data center and upload installation
images so you can use them to create virtual machines.
Proceed to [Attach an ISO domain](/documentation/quickstart/quickstart-guide/#attach-an-iso-domain)

#### Attach an ISO Domain

You have defined your first storage domain to store virtual guest data, now it
is time to configure your second storage domain, which will be used to store
installation images for creating virtual machines.
You have already created a local ISO domain during the installation of the oVirt Engine.
To use this ISO domain, attach it to a data center.

**To attach the ISO domain**

1. Navigate to the Tree pane and click the Expand All button. Click Default. On the results list, the Default data center displays.

2. On the details pane, select the Storage tab and click the Attach ISO button.

3. The Attach ISO Library dialog appears with the available ISO domain. Select it and click OK.

4. The ISO domain appears in the results list of the Storage tab. It displays with the Locked status as the domain is being validated, then changes to Inactive.

5. Select the ISO domain and click the Activate button. The status changes to Locked and then to Active.

#### Uploading ISO Images

Media images (CD-ROM or DVD-ROM in the form of ISO images) must be available
in the ISO repository for the virtual machines to use.
To do so, oVirt provides a utility that copies the images and sets the appropriate permissions on the file.
The file provided to the utility and the ISO share have to be accessible from the oVirt Engine.

Log in to the oVirt Engine server console to upload images to the ISO domain.

**To upload ISO images**

1. Create or acquire the appropriate ISO images from boot media. Ensure the path to these images is accessible from the oVirt Engine server.

2. The next step is to upload these files. First, determine the available ISO domains by running:

         # engine-iso-uploader list

You will be prompted to provide the admin user password which you use to connect to the administration portal.
The tool lists the name of the ISO domain that you attached in the previous section.

         ISO Storage Domain List:
           local-iso-share

Now you have all the information required to upload the required files.
On the Engine console, copy your installation images to the ISO domain. For your images, run:

         # engine-iso-uploader upload -i local-iso-share [file1] [file2] .... [fileN]

You will be prompted for the admin user password again. Provide it and press Enter.

Note that the uploading process can be time consuming, depending on your storage performance.

3. After the images have been uploaded, check that they are available for use in the Manager administration portal.

a. Navigate to the Tree and click the Expand All button.

b. Under Storage, click on the name of the ISO domain. It displays in the results list. Click on it to display its details pane.

c. On the details pane, select the Images tab. The list of available images should be populated with the files that you have uploaded.

Now that you have successfully prepared the ISO domain for use, you are ready to start creating virtual machines.

## Create Virtual Machines

The final stage of setting up oVirt is the virtual machine lifecycle--spanning
the creation, deployment and maintenance of virtual machines; using templates;
and configuring user permissions.
This section will also show you how to log in to the user portal and connect to virtual machines.

On oVirt, you can create virtual machines from an existing template, as a clone, or from scratch.
Once created, virtual machines can be booted using ISO images, a network boot (PXE) server, or a hard disk.
This document provides instructions for creating a virtual machine using an ISO image.

### Create a Fedora Virtual Machine

1. From the navigation tabs, select Virtual Machines. On the Virtual Machines tab, click New VM.

2. The “New Virtual Machine” popup appears.
![Figure 6: Create new linux virtual machine](/images/wiki/New_VM_Fedora.png "Figure 6: Create new linux virtual machine")

3. Under General, your default Cluster and Template will be fine.

4. For Operating System, choose Red Hat Enterprise Linux (for i386/i686 Fedora) or Red Hat Enterprise Linux x64 (for x86_64 Fedora).

5. Under Optimized For, choose Desktop if you are creating a desktop VM, or Server if you are creating a server VM.

6. Add a Name (required) and a comment or description (optional).

7. Finally, attach a Network Interface (optional) to the VM by selecting one from the dropdown.

8. Click OK.

9. A New Virtual Machine - Guide Me window opens. This allows you to add storage disks to the virtual machine.

![Figure 7. New Virtual Machine](/images/wiki/Guide_Me.png "Figure 7. New Virtual Machine")

10. Click Configure Virtual Disks to add storage to the virtual machine.

11. Enter a Size for the disk.

12. Click OK.

The parameters in the following figure such as Interface and Allocation Policy are recommended, but can be edited as necessary.

![Figure 8. Add Virtual Disk configurations](/images/wiki/Add_Virtual_Disk_Fedora.png "Figure 8. Add Virtual Disk configurations")

13. Close the Guide Me window by clicking Configure Later. Your new Fedora virtual machine will display in the Virtual Machines tab.

You have now created your Fedora virtual machine. Before you can use your virtual machine, install an operating system on it.

**To install the Fedora guest operating system:**

1. Right click the virtual machine and select Run Once.

2. Check “Attach CD” and choose a disk from the list

3. Click OK.

![Figure 9. Run once menu](/images/wiki/Run_Once_Fedora.png "Figure 9. Run once menu")

Retain the default settings for the other options and click OK to start the virtual machine.

4. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system. For further instructions, see the Fedora Installation Guide.

5. After the installation has completed, shut down the virtual machine and reboot from the hard drive.

You can now connect to your Fedora virtual machine and start using it.

**Post Install Additions**

Adding a few guest tools may improve your experience.

*   oVirt Guest Agent allows oVirt to show the Memory and Network utilization of the VM, the IP address of the VM, the installed Applications, Enable Single Sign On (SSO) and more.
*   Spice-vdagent allows for copy and paste support (text & image), better mouse functionality, and automatic adjustment of the screen resolution based on the size of your window.

See [how to install the guest agent in Fedora](/documentation/how-to/guest-agent/install-the-guest-agent-in-fedora/)


#### Creating a Windows 7 VM

1. From the navigation tabs, select Virtual Machines. On the Virtual Machines tab, click New VM.

![Figure 10. The navigation tabs](/images/wiki/Navigation_Tabs.png "Figure 10. The navigation tabs")

2. The “New Virtual Machine” popup appears.

![Figure 11. Create new Windows virtual machine](/images/wiki/New_VM_Win7.png "Figure 11. Create new Windows virtual machine")

3. Under General, your default Cluster and Template will be fine.

4. For Operating System, choose Windows 7 (for 32-bit Windows) or Windows7 x64 (for 64-bit Windows).

5. Under Optimized For, choose Desktop.

6. Add a Name (required) and a comment or description (optional).

7. Finally, attach a Network Interface (optional) to the VM by selecting one from the dropdown.

8. Click OK

9. A New Virtual Machine - Guide Me window opens. This allows you to add storage disks to the virtual machine.

![Figure 12. New Virtual Machine – Guide Me](/images/wiki/Guide_Me.png "Figure 12. New Virtual Machine – Guide Me")

10. Click Configure Virtual Disks to add storage to the virtual machine.

11. Enter a Size for the disk.

12. Click OK.

The parameters in the following figure such as Interface and Allocation Policy are recommended, but can be edited as necessary.

![Figure 13. Add Virtual Disk configurations](images/wiki/Add_Virtual_Disk_Win7.png "Figure 13. Add Virtual Disk configurations")

13. Close the Guide Me window by clicking Configure Later. Your new Windows 7 virtual machine will display in the Virtual Machines tab.

You have now created your Windows 7 virtual machine. Before you can use your virtual machine you need to install an operating system on it.

**To install Windows guest operating system**

1. Right click the virtual machine and select Run Once.

2. Check “Attach CD” and choose a disk from the list

3. Click OK.

![Figure 14. Run once menu](/images/wiki/Run_Once_Win7.jpg "Figure 14. Run once menu")

Retain the default settings for the other options and click OK to start the virtual machine.

4. Select the virtual machine and click the Console ( ) icon. This displays a window to the virtual machine, where you will be prompted to begin installing the operating system.

5. Continue with the Windows 7 install as normal until you reach "Where do you want to install Windows?"

##### Installing with a VirtIO Interface

<div class="toccolours mw-collapsible mw-collapsed" style="width:800px">
"Where do you want to install Windows?" does not show any disks. Click to expand this section.

<div class="mw-collapsible-content">
![No disks available](/images/wiki/Install_Windows7_VirtIO_Disk.png "fig:No disks available")

You need to load the VirtIO driver. 1. On the Navigation Tabs, click Change CD
![Change CD](/images/wiki/Navigation_Tabs_Change_CD.png "fig:Change CD")

2. From the drop down list select the virtio CD and click ok.
![VirtIO CD](/images/wiki/Change_CD_virtio.png "fig:VirtIO CD")

3. On the console, click "Load Drivers"

4. On the "Load Driver" popup, click Browse

5. Browse to the CD, Win7 folder. Choose the appropriate architecture (AMD64 for 64-bit, x86 for 32-bit) and click OK.

6. The VirtIO Drivers should appear. Choose "Red Hat VirtIO SCSI Controller", and then click Next
![Drivers Available](/images/wiki/Install_Windows7_VirtIO_Drivers.jpg "fig:Drivers Available")

7. The driver should install and return to the "Where do you want to install Windows?" screen now showing a disk to install to. Note that a message has appeared that "Windows cannot be installed to this disk"

8. On the Navigation Tabs, click Change CD

9. From the drop down list select the Windows 7 install media and click ok.

10. On the console, click "Refresh". The "Windows cannot be installed to this disk" message should disappear as the system can see the Windows install media again.

11. Continue with the install as normal

</div>
</div>
##### Installing with a IDE Interface

"Where do you want to install Windows?" shows a disk to install to. Continue as normal.

#### Post Install Additions

##### Drivers

If you choose to use the VirtIO disk interface, the VirtIO network interface, or wish to use the oVirt Guest Tools through the VirtIO-Serial interface, you need to install additional drivers.
![Device Manager](/images/wiki/Device_Manager_Win7_Missing_Drivers_VirtIO.jpg "fig:Device Manager") 1. On the console, open the Device Manger

2. On the Navigation Tabs, click Change CD
![Change CD](/images/wiki/Navigation_Tabs_Change_CD.jpg "fig:Change CD")

3. From the drop down list select the virtio CD and click ok.
![VirtIO CD](/images/wiki/Change_CD_virtio.png "fig:VirtIO CD")

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

![Figure 15. Make new virtual machine template](/images/wiki/Make-template.png "Figure 15. Make new virtual machine template")

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

![Figure 16. Create virtual machine based on Linux template](/images/wiki/Fedora-server-clone.png "Figure 16. Create virtual machine based on Linux template")

    * On the General tab, select the existing Linux template from the Based on Template list.

    * Enter a suitable Name and appropriate Description, then accept the default values inherited from the template in the rest of the fields. You can change them if needed.

    * Click the Resource Allocation tab. On the Provisioning field, click the drop down menu and select the Clone option.

![Figure 17. Set the provisioning to Clone](/images/wiki/New-vm-allocation.png "Figure 17. Set the provisioning to Clone")

2. Retain all other default settings and click OK to create the virtual machine. The virtual machine displays in the Virtual Machines list.

#### Create a Windows Template

To make a Windows virtual machine template, use the virtual machine you created [ Create a Windows Virtual Machine](#Create_a_Windows_Virtual_Machine) as a basis.

Before a template for Windows virtual machines can be created, it has to be sealed with sysprep. This ensures that machine-specific settings are not propagated through the template.

Note that the procedure below is applicable for creating Windows 7 and Windows 2008 R2 templates. If you wish to seal a Windows XP template, refer to the [oVirt Administration Guide](/documentation/admin-guide/administration-guide/).

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

This section describes how to create a Windows 7 virtual machine using the template created in [ Create a Windows Template](/documentation/quickstart/quickstart-guide/#create-a-windows-template).

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

oVirt has a sophisticated multi-level administration system, in which customized permissions for each system component can be assigned to different users as necessary. For instance, to access a virtual machine from the user portal, a user must have either UserRole or PowerUserRole permissions for the virtual machine. These permissions are added from the manager administration portal. For more information on the levels of user permissions refer to the [oVirt Administration Guide](/documentation/admin-guide/administration-guide/).

**To assign PowerUserRole permissions**

1. Navigate to the Tree pane and click Expand All. Click the VMs icon under the Default cluster. On the Virtual Machines tab, select the virtual machine you would like to assign a user to.

2. On the Details pane, navigate to the Permissions tab. Click the Add button.

3. The Add Permission to User dialog displays. Enter a Name, or User Name, or part thereof in the Search textbox, and click Go. A list of possible matches display in the results list.

![Figure 18. Add PowerUserRole Permission](/images/wiki/Vm-add-perm.png "Figure 18. Add PowerUserRole Permission")

4. Select the check box of the user to be assigned the permissions. Scroll through the Assign role to user list and select PowerUserRole. Click OK.

#### Log in to the User Portal

Now that you have assigned PowerUserRole permissions on a virtual machine to the user named admin, you can access the virtual machine from the user portal. To log in to the user portal, all you need is a Linux client running Mozilla Firefox.

If you are using a Fedora client, install the SPICE plug-in before logging in to the User Portal. Run:

         # yum install spice-xpi

**To log in to the User Portal**

1. Open your browser and navigate to **<<https://domain.example.com/UserPortal>>**, substituting domain.example.com with the oVirt Engine server address.

2. The login screen displays. Enter your User Name and Password, and click Login.

You have now logged into the user portal. As you have PowerUserRole permissions, you are taken by default to the Extended User Portal, where you can create and manage virtual machines in addition to using them. This portal is ideal if you are a system administrator who has to provision multiple virtual machines for yourself or other users in your environment.

![Figure 19. The Extended User Portal](/images/wiki/Power-user-portal.png "Figure 19. The Extended User Portal")

You can also toggle to the Basic User Portal, which is the default (and only) display for users with UserRole permissions. This portal allows users to access and use virtual machines, and is ideal for everyday users who do not need to make configuration changes to the system. For more information, see the [oVirt User Portal Guide](/documentation/user-guide/user-guide/#accessing-the-user-portal).

![Figure 20. The Basic User Portal](/images/wiki/Basic-user-portal.png "Figure 20. The Basic User Portal")

You have now completed the Quick Start Guide, and successfully set up oVirt.

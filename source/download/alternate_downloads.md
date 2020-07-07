---
title: Download
authors: gshereme, sandrobonazzola
---

# Alternate Installation Methods

For production installations, we recommend installing oVirt using the graphical Cockpit installer in the
[Self-Hosted Engine configuration](/download). In this configuration, oVirt Engine and a Host are installed
together with the Engine running as a Virtual Machine on that Host. This configuration is
preferred because the Engine Virtual Machine will be highly available (once a second Host is added).

However, if you prefer to run oVirt Engine standalone on physical hardware or another virtualization provider, you can install oVirt Engine
and Nodes / Hosts separately.

oVirt 4.4.0 is intended for production use and is available for the following platforms:

Engine:
- Red Hat Enterprise Linux 8.1
- CentOS Linux 8.1

Hosts:
- Red Hat Enterprise Linux 8.1
- CentOS Linux 8.1
- oVirt Node (based on CentOS Linux 8.1)

See the [Release Notes for oVirt 4.4.0](/release/4.4.0/).

<div class="row"></div>

## Install oVirt Engine using RPM

oVirt Engine is installed using RPM packages on a supported Enterprise Linux 8 distribution,
such as CentOS Linux or Red Hat Enterprise Linux.

{:.alert.alert-warning}
Users can also compile from source, using the guides found under the [Developers](/develop) section. This is not recommended
unless you are a developer or need to customize the source code.

{:.alert.alert-warning}
**Important:** You cannot skip a version when updating oVirt Engine. For example, if you are updating from
3.6 to 4.4, you first need to update to 4.0, then to 4.1, 4.2, 4.3 and finally to 4.4. (Host upgrades can use the
[oVirt Fast Forward Upgrade tool](https://github.com/oVirt/ovirt-fast-forward-upgrade).)
If you are updating from 4.3, please note you'll need to migrate your engine from el7 to el8.

### Upgrading from previous releases

For a standalone engine this means basically:

1. backup engine data on 4.3.9 with:
   `engine-backup --scope=all --mode=backup --file=backup.bck --log=backuplog.log`
2. copy the backup to a safe location
3. reinstall engine host with EL 8
4. enable repos with:
   `dnf install https://resources.ovirt.org/pub/yum-repo/ovirt-release44.rpm`
5. `dnf update` (reboot if needed)
6. enable modules with:
   `dnf module enable -y javapackages-tools pki-deps postgresql:12 389-ds`
7. install engine rpms with:
   `dnf install ovirt-engine`    
8. restore the engine data with:
   `engine-backup --mode=restore --file=backup.bck --log=restore.log --provision-db --provision-dwh-db --restore-permissions --provision-dwh-db`
9. run `engine-setup`.

#### Red Hat Enterprise Linux, CentOS Linux

{:.instructions}
1.  Enable the Base, Optional, and Extra repositories (Red Hat Enterprise Linux only):

        # RHEL only -- they are enabled by default on CentOS and oVirt Node
        sudo subscription-manager repos --enable="rhel-8-for-x86_64-baseos-rpms"
        sudo subscription-manager repos --enable="rhel-8-for-x86_64-appstream-rpms"
        sudo subscription-manager repos --enable="ansible-2-for-rhel-8-x86_64-rpms"

2.  Add the official oVirt repository.

        sudo dnf install https://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm
        sudo dnf module enable -y javapackages-tools pki-deps postgresql:12 389-ds

3.  Install oVirt Engine.

        sudo dnf install -y ovirt-engine

4.  Set up oVirt Engine.

        sudo engine-setup

5.  Follow the prompts to configure and install the Engine.

6.  Once the installation completes, oVirt's web UI management interface will start and the URL will be printed
    to the screen. Browse to this URL to begin using oVirt!

    See [Browsers and Mobile Clients](/download/browsers_and_mobile.html) for supported browsers and
    mobile client information.

## Download oVirt Node or Setup Hosts

You must now install at least one Node or Host to act as hypervisors. Enterprise features like migration and high availability
require more than one Host.

oVirt supports two types of [Hosts](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/#Installing_Hosts_for_RHV_SHE_cockpit_deploy):

* [oVirt Node](/download/node.html) and
* [Enterprise Linux (such as CentOS or RHEL)](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/#Red_Hat_Enterprise_Linux_hosts_SHE_cockpit_deploy)

Depending on your environment requirements, you may want to use only oVirt Nodes, only EL Hosts, or both.

#### Download oVirt Node

[oVirt Node](/download/node.html) is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a
physical machine to act as a hypervisor in an oVirt environment.

{:.instructions}
1.  Download the oVirt Node Installation ISO (current stable is [oVirt Node 4.4 - Stable Release - Installation ISO](https://resources.ovirt.org/pub/ovirt-4.4/iso/ovirt-node-ng-installer/))

2.  Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

3.  Boot your physical machine from that media and install oVirt Node.

#### Or Setup a Host

Instead of or in addition to oVirt Node, you can use a standard Enterprise Linux installation as a Host.

An Enterprise Linux Host (such as CentOS or RHEL), also known as an EL-based hypervisor or EL-based Host, is a standard
basic installation of an Enterprise Linux operating system on a physical server upon which the hypervisor
packages are installed.

{:.instructions}
1.  Install one of the supported operating systems (CentOS, RHEL) on your Host and update it:

        sudo dnf update -y
        # reboot if the kernel was updated

2.  Add the official oVirt repository:

        sudo dnf install https://resources.ovirt.org/pub/yum-repo/ovirt-release44.rpm

See [Chapter 7: Enterprise Linux Hosts](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/#Red_Hat_Enterprise_Linux_hosts_SHE_cockpit_deploy) for full installation
instructions.

#### Attaching your Hosts

Once you have installed additional oVirt Nodes or EL Hosts, use the oVirt Administration Portal to add them to the Engine.
Navigate to Compute → Hosts → New and enter the Host details. See
[Adding a Host to the oVirt Engine](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/#Adding_standard_hosts_to_the_Manager_SHE_cockpit_deploy) for detailed instructions.

## Storage

oVirt uses a centralized storage system for Virtual Machine disk images, ISO files, and snapshots. Before you can install a Virtual Machine,
storage must be attached.

Storage can be implemented using:

 * Network File System (NFS)

 * GlusterFS exports

 * iSCSI (Internet Small Computer System Interface)

 * Local storage attached directly to the virtualization Hosts

 * Fibre Channel Protocol (FCP)

 * Parallel NFS (pNFS)

 * Other POSIX compliant file systems

Using the oVirt Administration Portal, navigate to Storage → Domains → New and enter the Storage details.
See [Configuring Storage](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/#Adding_Storage_Domains_to_RHV_SHE_cockpit_deploy) and
[Storage Administration](/documentation/administration_guide/#chap-Storage) for guidance on configuring storage for your
environment.

## Install Virtual Machines

Once oVirt Engine is installed and you have added Hosts and [configured storage](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_cockpit_web_interface/#Adding_Storage_Domains_to_RHV_SHE_cockpit_deploy),
you can now install Virtual Machines!

See the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide.html) for complete
instructions.

For best Virtual Machine performance and accurate dashboard statistics, be sure to install the
[oVirt Guest Agent and Drivers for Linux](/documentation/vmm-guide/chap-Installing_Linux_Virtual_Machines.html#installing-the-guest-agents-and-drivers-on-enterprise-linux)
\[for [Windows](/documentation/vmm-guide/chap-Installing_Windows_Virtual_Machines.html#installing-the-guest-agents-and-drivers-on-windows)\]
in each Virtual Machine.

The following virtual machine guest operating systems are supported:

|Operating System|Architecture|SPICE support [1]|
|:---------------|:-----------|:------------|
|Red Hat Enterprise Linux 3 - 6|32-bit, 64-bit|Yes|
|Red Hat Enterprise Linux 7+|64-bit|Yes|
|SUSE Linux Enterprise Server 10+ [2]|32-bit, 64-bit|No|
|Ubuntu 12.04 (Precise Pangolin LTS)+ [3]|32-bit, 64-bit|Yes|
|Windows XP Service Pack 3 and newer|32-bit|Yes|
|Windows 7|32-bit, 64-bit|Yes|
|Windows 8|32-bit, 64-bit|No|
|Windows 10|64-bit|Yes|
|Windows Server 2003 Service Pack 2 and newer|32-bit, 64-bit|Yes|
|Windows Server 2008|32-bit, 64-bit|Yes|
|Windows Server 2008 R2|64-bit|Yes|
|Windows Server 2012 R2|64-bit|No|
|Windows Server 2016|64-bit|No|

[1] SPICE drivers (QXL) are not supplied by Red Hat. Distribution's vendor may provide SPICE drivers.<br/>
[2] select Other Linux for the guest type in the user interface<br/>
[3] not tested recently (?)<br/>

## Consoles

The console is a graphical window that allows you to view and interact with the screen of a Virtual Machine.
In oVirt, you can use a web-based console viewer or a desktop application (we recommend 
[Remote Viewer](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-graphic_user_interface_tools_for_guest_virtual_machine_management-remote_viewer)).
For Windows virtual machines, Remote Desktop Protocol is also available. See [Installing Console Components](/documentation/vmm-guide/chap-Introduction.html#installing-console-components),
[VNC Console Options](/documentation/vmm-guide/chap-Additional_Configuration.html#vnc-console-options), and
and [Browser Support and Mobile Clients](/download/browsers_and_mobile.html) for more information.

<hr/>

## RPM Repositories and GPG keys

[RPM repository for oVirt 4.4 - Latest stable release](https://resources.ovirt.org/pub/ovirt-4.4/)

See [RPMs and GPG](/download/rpms_and_gpg.html) for older releases, nightlies, mirrors, and GPG keys.

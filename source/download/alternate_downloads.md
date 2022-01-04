---
title: Download
authors:
  - gshereme
  - sandrobonazzola
page_classes: download
---

# Alternate Installation Methods

<img class="screenshot" src="download_1.png">

For production installations, we recommend installing oVirt in the
[Self-Hosted Engine configuration](/download). In this configuration, oVirt Engine and a Host are installed
together with the Engine running as a Virtual Machine on that Host. This configuration is
preferred because the Engine Virtual Machine will be highly available (once a second Host is added).

However, if you prefer to run the oVirt Engine standalone on physical hardware or another virtualization provider, you can install oVirt Engine
and Nodes / Hosts separately.

oVirt 4.4.9 is intended for production use and is available for the following platforms:

Engine:
- Red Hat Enterprise Linux 8.4
- CentOS Linux 8.4
- CentOS Stream

Hosts:
- Red Hat Enterprise Linux 8.5 beta (or similar)
- oVirt Node (based on CentOS Stream)
- CentOS Stream

See the [Release Notes for oVirt 4.4.9](/release/4.4.9/).

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

1. backup engine data on 4.3.10 with:
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

        # RHEL beta releases only
        sudo subscription-manager repos --enable="rhel-8-for-x86_64-baseos-beta-rpms"
        sudo subscription-manager repos --enable="rhel-8-for-x86_64-appstream-beta-rpms"

2.  Add the official oVirt repository.

        sudo dnf install https://resources.ovirt.org/pub/yum-repo/ovirt-release44.rpm
        sudo dnf module enable -y javapackages-tools pki-deps postgresql:12 389-ds

3.  Install oVirt Engine.

        sudo dnf install -y ovirt-engine

4.  Set up oVirt Engine.

        sudo engine-setup

5.  Follow the prompts to configure and install the Engine.

6.  Once the installation completes, oVirt's web UI management interface will start and the URL will be printed
    to the screen. Browse to this URL to begin using oVirt!

    See [Browsers Support](/download/browsers_and_mobile.html) for supported browsers.

## Download oVirt Node or Setup Hosts

You must now install at least one Node or Host to act as hypervisors. Enterprise features like migration and high availability
require more than one Host.

oVirt supports two types of [Hosts](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Installing_Hosts_for_RHV_SHE_cli_deploy):

* [oVirt Node](/download/node.html) and
* [Enterprise Linux (such as CentOS or RHEL)](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Red_Hat_Enterprise_Linux_hosts_SHE_cli_deploy)

Depending on your environment requirements, you may want to use only oVirt Nodes, only EL Hosts, or both.

#### Download oVirt Node

[oVirt Node](/download/node.html) is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a
physical machine to act as a hypervisor in an oVirt environment.

{:.instructions}
1.  Download the oVirt Node Installation ISO (current stable is [oVirt Node 4.4 - Stable Release - Installation ISO](https://resources.ovirt.org/pub/ovirt-4.4/iso/ovirt-node-ng-installer/))

2.  Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

3.  Boot your physical machine from that media and install the oVirt Node minimal operating system.

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

See [Enterprise Linux Hosts](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Red_Hat_Enterprise_Linux_hosts_SHE_cli_deploy) for full installation
instructions.

#### Attaching your Hosts

Once you have installed additional oVirt Nodes or EL Hosts, use the oVirt Administration Portal to add them to the Engine.
Navigate to Compute → Hosts → New and enter the Host details. See
[Adding a Host to the oVirt Engine](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Adding_standard_hosts_to_the_Manager_SHE_cli_deploy) for detailed instructions.

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
See [Configuring Storage](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Adding_Storage_Domains_to_RHV_SHE_cli_deploy) and
[Storage Administration](/documentation/administration_guide/#chap-Storage) for guidance on configuring storage for your
environment.

## Install Virtual Machines

Once oVirt Engine is installed and you have added Hosts and [configured storage](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Adding_Storage_Domains_to_RHV_SHE_cli_deploy),
you can now install Virtual Machines!

See the [Virtual Machine Management Guide](/documentation/virtual_machine_management_guide/) for complete
instructions.

For best Virtual Machine performance and accurate dashboard statistics, be sure to install the
[oVirt Guest Agent and Drivers for Linux](/documentation/virtual_machine_management_guide/#Installing_the_Guest_Agents_and_Drivers_on_Red_Hat_Enterprise_Linux)
\[for [Windows](/documentation/virtual_machine_management_guide/#Installing_the_Guest_Agents_and_Drivers_on_Windows)\]
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
[Virt Viewer](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/getting-started-with-virtualization-in-rhel-8_configuring-and-managing-virtualization#proc_opening-a-virtual-machine-graphical-console-using-virt-viewer_assembly_connecting-to-virtual-machines)).
For Windows virtual machines, Remote Desktop Protocol is also available. See [Installing Console Components](/documentation/virtual_machine_management_guide/#sect-Installing_Console_Components),
[VNC Console Options](/documentation/virtual_machine_management_guide/#VNC_Console_Options), and
and [Browser Support](/download/browsers_and_mobile.html) for more information.

<hr/>

## RPM Repositories and GPG keys

[RPM repository for oVirt 4.4 - Latest stable release](https://resources.ovirt.org/pub/ovirt-4.4/)

See [RPMs and GPG](/download/rpms_and_gpg.html) for older releases, nightlies, mirrors, and GPG keys.

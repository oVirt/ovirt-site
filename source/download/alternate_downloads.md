---
title: Download
authors:
  - gshereme
  - sandrobonazzola
page_classes: download
---

# Alternate Installation Methods

<img class="screenshot" src="download_1.png">

oVirt 4.5.0 is intended for production use and is available for the following platforms:

Engine:
- Red Hat Enterprise Linux 8.6 (or similar)
- CentOS Stream

Hosts:
- Red Hat Enterprise Linux 8.6 (or similar)
- oVirt Node (based on CentOS Stream)
- CentOS Stream

See the [Release Notes for oVirt 4.5.0](/release/4.5.0/).

<div class="row"></div>

## Install oVirt Engine using RPM

oVirt Engine is installed using RPM packages on a supported Enterprise Linux 8 distribution,
such as CentOS Stream or Red Hat Enterprise Linux.

{:.alert.alert-warning}
Users can also compile from source, using the guides found under the [Developers](/develop) section. This is not recommended
unless you are a developer or need to customize the source code.

{:.alert.alert-warning}
**Important:** You cannot skip a version when updating oVirt Engine. For example, if you are updating from
3.6 to 4.5, you first need to update to 4.0, then to 4.1, 4.2, 4.3 before updating to 4.4 or 4.5.

As an exception you can upgrade from 4.3 to 4.5 without upgrading to 4.4 first.


## Upgrade to 4.5 from 4.4

### On oVirt Engine side:

```bash
dnf install -y centos-release-ovirt45
dnf update -y --nobest
engine-setup
```

### on oVirt Node side:

```bash
dnf install -y centos-release-ovirt45 --enablerepo=extras
```

and then upgrade the host from the oVirt Engine administation portal.


## Upgrading from 4.3

For a standalone engine this means basically:

1. backup engine data on 4.3.10 with:
   `engine-backup --scope=all --mode=backup --file=backup.bck --log=backuplog.log`
2. copy the backup to a safe location
3. reinstall engine host with EL 8 as described in next section
4. restore the engine data with:
   `engine-backup --mode=restore --file=backup.bck --log=restore.log --provision-db --provision-dwh-db --restore-permissions --provision-dwh-db`
5. run `engine-setup`.

#### Red Hat Enterprise Linux, CentOS Linux

{:.instructions}
1.  If you are going to install on Red Hat Enterprise Linux 8.6 Beta,
    please read [Installing on RHEL](/download/install_on_rhel.html) first.

2.  Add the official oVirt repository.
    ```bash
    sudo dnf install -y centos-release-ovirt45
    sudo dnf module enable -y javapackages-tools pki-deps postgresql:12 389-ds mod_auth_openidc
    ```

3.  Install oVirt Engine.
    ```bash
    sudo dnf install -y ovirt-engine
    ```

4.  Set up oVirt Engine.
    ```bash
    sudo engine-setup
    ```

5.  Follow the prompts to configure and install the Engine.

6.  Once the installation completes, oVirt's web UI management interface will start and the URL will be printed
    to the screen. Browse to this URL to begin using oVirt!

    See [Browsers Support](/download/browsers_and_mobile.html) for supported browsers.

## Download oVirt Node or Setup Hosts

You must now install at least one Node or Host to act as hypervisors. Enterprise features like migration and high availability
require more than one Host.

oVirt supports two types of [Hosts](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Installing_Hosts_for_RHV_SHE_cli_deploy):

* [oVirt Node](/download/node.html) and
* [Enterprise Linux (such as CentOS Stream or RHEL)](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Red_Hat_Enterprise_Linux_hosts_SHE_cli_deploy)

Depending on your environment requirements, you may want to use only oVirt Nodes, only EL Hosts, or both.

#### Download oVirt Node

[oVirt Node](/download/node.html) is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a
physical machine to act as a hypervisor in an oVirt environment.

{:.instructions}
1.  Download the oVirt Node Installation ISO (current stable is [oVirt Node 4.5 - Stable Release - Installation ISO](https://resources.ovirt.org/pub/ovirt-4.5/iso/ovirt-node-ng-installer/))

2.  Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

3.  Boot your physical machine from that media and install the oVirt Node minimal operating system.

#### Or Setup a Host

Instead of or in addition to oVirt Node, you can use a standard Enterprise Linux installation as a Host.

An Enterprise Linux Host (such as CentOS or RHEL), also known as an EL-based hypervisor or EL-based Host, is a standard
basic installation of an Enterprise Linux operating system on a physical server upon which the hypervisor
packages are installed.

{:.instructions}
1.  Install one of the supported operating systems (CentOS, RHEL) on your Host and update it. If you are going to install on RHEL 8.6 Beta please follow [Installing on RHEL](/download/install_on_rhel.html) first.
    ```bash
    sudo dnf update -y
    # reboot if the kernel was updated
    ```

2.  Add the official oVirt repository:
    ```bash
    sudo dnf install -y centos-release-ovirt45
    ```

See [Enterprise Linux Hosts](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Red_Hat_Enterprise_Linux_hosts_SHE_cli_deploy) for full installation instructions.

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

See the [Virtual Machine Management Guide](/documentation/virtual_machine_management_guide/)
for complete instructions.

For best Virtual Machine performance and accurate dashboard statistics, be sure to install the
[oVirt Guest Agent and Drivers for Linux](/documentation/virtual_machine_management_guide/#Installing_the_Guest_Agents_and_Drivers_on_Red_Hat_Enterprise_Linux)
\[for [Windows](/documentation/virtual_machine_management_guide/#Installing_the_Guest_Agents_and_Drivers_on_Windows)\]
in each Virtual Machine.

The following virtual machine guest operating systems are supported:

|Operating System|Architecture       |SPICE support [1]|
|:---------------|:------------------|:------------|
|Red Hat Enterprise Linux 3 - 6      |32-bit, 64-bit|Yes|
|Red Hat Atomic 7.x                  |64-bit|No|
|Red Hat Enterprise Linux 7 - 8      |64-bit|Yes|
|Red Hat Enterprise Linux 9          |64-bit|No|
|Red Hat Enterprise Linux CoreOS     |64-bit|No|
|SUSE Linux Enterprise Server 10+ [2]|32-bit, 64-bit|No|
|Ubuntu 12.04 (Precise Pangolin LTS)+ [3]|32-bit, 64-bit|Yes|
|Windows XP Service Pack 3 and newer|32-bit|Yes|
|Windows 7|32-bit, 64-bit|Yes|
|Windows 8|32-bit, 64-bit|No|
|Windows 10|64-bit|Yes|
|Windows 11|64-bit|Yes|
|Windows Server 2003 Service Pack 2 and newer|32-bit, 64-bit|Yes|
|Windows Server 2008|32-bit, 64-bit|Yes|
|Windows Server 2008 R2|64-bit|Yes|
|Windows Server 2012 R2|64-bit|No|
|Windows Server 2016|64-bit|No|
|Windows Server 2019|64-bit|No|
|Windows Server 2022|64-bit|No|
|FreeBSD 9.2|32-bit, 64-bit|No|
{: .bordered}

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

### oVirt 4.5

oVirt 4.5 is shipped via CentOS repositories.
If you are going to install on RHEL 8.6 Beta please follow [Installing on RHEL](/download/install_on_rhel.html) first.

In order to enable oVirt 4.5 repositories on CentOS Stream you need to execute:
```bash
dnf install -y centos-release-ovirt45
```

See [RPMs and GPG](/download/rpms_and_gpg.html) for older releases, nightlies, mirrors, and GPG keys.

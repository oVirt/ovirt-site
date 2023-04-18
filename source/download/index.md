---
title: Download
authors:
  - gshereme
  - sandrobonazzola
page_classes: download
---

# Download oVirt

<img class="screenshot" src="download_1.png" alt="oVirt Engine Administration panel screenshot">

oVirt 4.5.4 is intended for production use and is available for the following platforms:

Engine:
- Red Hat Enterprise Linux 8.7 (or similar)
- CentOS Stream 8

Hosts:
- Red Hat Enterprise Linux 8.7 (or similar)
- oVirt Node based on CentOS Stream 8
- CentOS Stream 8
- Red Hat Enterprise Linux 9.1 (or similar, non UEFI hosts)
- oVirt Node based on CentOS Stream 9 (non UEFI hosts)
- CentOS Stream 9 (non UEFI hosts)

See the [Release Notes for oVirt 4.5.4](/release/4.5.4/).

<div class="row"></div>

## Suggestion to use nightly

As [discussed in oVirt Users mailing list](https://lists.ovirt.org/archives/list/users@ovirt.org/thread/DMCC5QCHL6ECXN674JOLABH36U2LVJLJ/)
we suggest the user community to use [oVirt master snapshot repositories](/develop/dev-process/install-nightly-snapshot.html)
ensuring that the latest fixes for the platform regressions will be promptly available.


## Upgrade to 4.5 from 4.4

Please follow the [upgrade guide](/documentation/upgrade_guide/index.html#Upgrading_from_4-4)


## Install oVirt using the command line

oVirt is installed using the command line.

See [Installing oVirt as a self-hosted engine using the command line](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line)

oVirt Engine and a Host are installed together with the Engine running as a Virtual Machine on that Host.
Once you install a second Host, the Engine Virtual Machine will be highly available. See the
[oVirt documentation](/documentation/index.html) for full details.

[Alternate download options](/download/alternate_downloads.html)

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
1.  Install one of the supported operating systems (CentOS, RHEL) on your Host and update it. If you are going to install on RHEL or derivatives please follow [Installing on RHEL or derivatives](/download/install_on_rhel.html) first.
    ```bash
    sudo dnf update -y
    # reboot if the kernel was updated
    ```

2.  Add the official oVirt repository:
    ```bash
    sudo dnf install -y centos-release-ovirt45
    ```

## Install oVirt using the command line

See the instructions in:
* [Installing the self-hosted engine deployment host](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Installing_the_self-hosted_engine_deployment_host_SHE_cli_deploy)

* [Installing the oVirt Engine](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Installing_the_Red_Hat_Virtualization_Manager_SHE_cli_deploy)

## Setup Additional Hosts

Once the Engine is installed, you must install at least one additional Host for advanced features like migration
and high-availability.

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
If you are going to install on RHEL or derivatives please follow [Installing on RHEL or derivatives](/download/install_on_rhel.html) first.

In order to enable oVirt 4.5 repositories on CentOS Stream you need to execute:
```bash
dnf install -y centos-release-ovirt45
```

See [RPMs and GPG](/download/rpms_and_gpg.html) for older releases, nightlies, mirrors, and GPG keys.

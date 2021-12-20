---
title: Download
authors:
  - gshereme
  - sandrobonazzola
page_classes: download
---

# Download oVirt

<img class="screenshot" src="download_1.png">

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


## Install oVirt using the command line

oVirt is installed using the command line. See [Installing oVirt as a self-hosted engine using the command line](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line)

oVirt Engine and a Host are installed together with the Engine running as a Virtual Machine on that Host.
Once you install a second Host, the Engine Virtual Machine will be highly available. See the
[oVirt documentation](/documentation/index.html) for full details.

[Alternate download options](/download/alternate_downloads.html)

oVirt supports two types of [Hosts](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Installing_Red_Hat_Virtualization_Hosts_SHE_cli_deploy):

* [oVirt Node](/download/node.html), a minimal hypervisor operating system based on CentOS
* [Enterprise Linux (such as CentOS or RHEL)](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Red_Hat_Enterprise_Linux_hosts_SHE_cli_deploy)

Depending on your environment requirements, you may want to use only oVirt Nodes, only EL Hosts, or both.

#### Download oVirt Node

{:.instructions}
1.  Download the oVirt Node Installation ISO (current stable is [oVirt Node 4.4 - Stable Release - Installation ISO](https://resources.ovirt.org/pub/ovirt-4.4/iso/ovirt-node-ng-installer/))

2.  Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

3.  Boot your physical machine from that media and install the oVirt Node minimal operating system.

#### Or Setup a Host

Instead of or in addition to oVirt Node, you can use a standard Enterprise Linux installation as a Host.

{:.instructions}
1.  Install one of the supported operating systems (CentOS, RHEL) on your Host and update it:

        sudo dnf update -y
        # reboot if the kernel was updated

2.  Add the official oVirt repository:

        sudo dnf install https://resources.ovirt.org/pub/yum-repo/ovirt-release44.rpm

## Install oVirt using the command line

See the instructions in:
* [Installing the self-hosted engine deployment host](documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/index.html#Installing_the_self-hosted_engine_deployment_host_SHE_cli_deploy)

* [Installing the oVirt Engine](documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/index.html#Installing_the_Red_Hat_Virtualization_Manager_SHE_cli_deploy)

## Setup Additional Hosts

Once the Engine is installed, you must install at least one additional Host for advanced features like migration
and high-availability.

Once you have installed additional oVirt Nodes or EL Hosts, use the oVirt Administration Portal to add them to the Engine.
Navigate to Compute → Hosts → New and enter the Host details. See
[Adding a Host to the oVirt Engine](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line#Adding_standard_hosts_to_the_Manager_SHE_cli_deploy) for detailed instructions.

## Install Virtual Machines

Once oVirt Engine is installed and you have added Hosts and [configured storage](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/index#Adding_Storage_Domains_to_RHV_SHE_cli_deploy),
you can now install Virtual Machines! See the [Virtual Machine Management Guide](/documentation/virtual_machine_management_guide/)
for complete instructions.

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

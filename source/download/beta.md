---
title: Download Beta
authors: sandrobonazzola
---

<style>
h1, h2, h3, h4, h5, h6, li, a, p {
    font-family: 'Open Sans', sans-serif !important;
}
.instructions li {
    margin-top: 20px;
}
.screenshot {
    float: right;
    width: 55%;
    padding-left: 40px;
    padding-bottom: 40px;
}
.install-start {
    width: 245px;
    padding-left: 40px;
}
</style>

# Download oVirt 4.4 Beta

<img class="screenshot" src="download_1.png">

oVirt 4.4.0 Beta is intended for testing only use and is available for the following platforms:

Engine:
- Red Hat Enterprise Linux 8.1
- CentOS Linux 8.1

Hosts:
- Red Hat Enterprise Linux 8.1
- CentOS Linux 8.1
- oVirt Node (based on CentOS Linux 8.1)

See the [Release Notes for oVirt 4.4.0](/release/4.4.0/).


## Install oVirt with Cockpit

oVirt is installed using a graphical installer in Cockpit.

oVirt Engine and a Host are installed together with the Engine running as a Virtual Machine on that Host.
Once you install a second Host, the Engine Virtual Machine will be highly available. See the
[Self-Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide.html) for full details.

[Alternate download options](/download/alternate_downloads.html)

oVirt supports two types of [Hosts](/documentation/install-guide/chap-Introduction_to_Hosts.html):

* [oVirt Node](/download/node.html), a minimal hypervisor operating system based on CentOS
* [Enterprise Linux (such as CentOS or RHEL)](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html)

Depending on your environment requirements, you may want to use only oVirt Nodes, only EL Hosts, or both.

#### Download oVirt Node

{:.instructions}
1.  Download the oVirt Node Installation ISO (current stable is [oVirt Node 4.4 - Beta - Installation ISO](https://resources.ovirt.org/pub/ovirt-4.4-pre/iso/ovirt-node-ng-installer/))

2.  Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

3.  Boot your physical machine from that media and install the oVirt Node minimal operating system.

#### Or Setup a Host

Instead of or in addition to oVirt Node, you can use a standard Enterprise Linux installation as a Host.

{:.instructions}
1.  Install one of the supported operating systems (CentOS, RHEL, or Scientific Linux) on your Host and update it:

        sudo yum update -y
        # reboot if the kernel was updated

2.  Add the official oVirt repository:

        sudo yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release44-pre.rpm

## Install oVirt using the Cockpit wizard

{:.instructions}
1.  Enable the Base, Appstream, and Ansible repositories (Red Hat Enterprise Linux only):

        # RHEL only -- they are enabled by default on CentOS and oVirt Node
        sudo subscription-manager repos --enable="rhel-8-for-x86_64-baseos-rpms"
        sudo subscription-manager repos --enable="rhel-8-for-x86_64-appstream-rpms"
        sudo subscription-manager repos --enable="ansible-2-for-rhel-8-x86_64-rpms"

2.  Install Cockpit and the cockpit-ovirt-dashboard plugin:

        sudo yum install cockpit cockpit-ovirt-dashboard -y
        
3.  Enable Cockpit:

        sudo systemctl enable --now cockpit.socket

4.  Open the firewall:

        sudo firewall-cmd --add-service=cockpit
        sudo firewall-cmd --add-service=cockpit --permanent

5.  Log in to Cockpit as root at https://\[Host IP or FQDN\]:9090 and click Virtualization → Hosted Engine.

6.  Click Start under the Hosted Engine option.

    <img class="install-start" src="download_2.png">

7.  Complete the setup wizard. As part of the setup, you will enter the Hosted Engine's name.

8.  As part of the setup wizard, you will need to provide the location of your storage. oVirt requires a central
    shared storage system for Virtual Machine disk images, ISO files, and snapshots.

9. Once the installation completes, oVirt's web UI management interface will start. Browse to
    https://\[Hosted Engine's name\]/ to begin using oVirt!

    See [Browsers and Mobile Clients](/download/browsers_and_mobile.html) for supported browsers and
    mobile client information.

## Setup Additional Hosts

Once the Engine is installed, you must install at least one additional Host for advanced features like migration
and high-availability.

Once you have installed additional oVirt Nodes or EL Hosts, use the oVirt Administration Portal to add them to the Engine.
Navigate to Compute → Hosts → New and enter the Host details. See
[Adding a Host to the oVirt Engine](/documentation/install-guide/chap-Adding_a_Host_to_the_oVirt_Engine.html) for detailed instructions.

## Install Virtual Machines

Once oVirt Engine is installed and you have added Hosts and [configured storage](/documentation/install-guide/chap-Configuring_Storage.html),
you can now install Virtual Machines! See the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide.html)
for complete instructions.

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

[RPM repository for oVirt 4.4 Beta](https://resources.ovirt.org/pub/ovirt-4.4-pre/)

See [RPMs and GPG](/download/rpms_and_gpg.html) for older releases, nightlies, mirrors, and GPG keys.

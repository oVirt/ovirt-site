---
title: Download
authors: bproffitt, dneary, knesenko, mburns, sandrobonazzola, theron, gshereme
---

<style>
.button-container {
  min-height: 40px;
  padding: 10px;
  margin: 10px;
  text-align: center;
  vertical-align: middle;
}
.instructions li {
    margin-top: 20px;
}
</style>

# Download oVirt

oVirt 4.2.8 is intended for production use and is available for the following platforms:

- Red Hat Enterprise Linux 7.6 or later
- CentOS Linux 7.6 or later
- Scientific Linux 7.6 or later

See the [Release Notes for oVirt 4.2.8](/release/4.2.8/) and the [Installation Guide](/documentation/install-guide/Installation_Guide.html).

oVirt can be downloaded and installed two primary ways: Self-Hosted Engine or separate Engine and Hosts.

For production installations, we recommend installing oVirt using the Self-Hosted Engine configuration. In this configuration,
oVirt Engine and a Host are installed together with the Engine running as a Virtual Machine on that Host. This configuration is
more resilent because the Engine Virtual Machine will be highly available (once a second Host is added). See the
[Self-Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide.html) for full installation instructions
for this configuration.

If you prefer to run oVirt Engine standalone on physical hardware, you can install oVirt Engine and Nodes / Hosts separately.
See the [oVirt Installation Guide](/documentation/install-guide/Installation_Guide.html) for full installation instructions
for this configuration.

<div class="row">
<div class="col-sm-3">
<div class="button-container">
<a href="#download-and-install-ovirt-self-hosted-engine" class="btn btn-primary">Install oVirt Self-Hosted Engine</a>
</div>
</div>
<div class="col-sm-2">
<div class="button-container">
or
</div>
</div>
<div class="col-sm-6">
<div class="col-sm-5">
<div class="button-container">
<a href="#download-ovirt-engine" class="btn btn-primary">Download oVirt Engine</a>
</div>
</div>
<div class="col-sm-2">
<div class="button-container">
and
</div>
</div>
<div class="col-sm-4">
<div class="button-container">
<a href="#download-ovirt-node-or-setup-hosts" class="btn btn-primary">Download oVirt Node or Setup Hosts</a>
</div>
</div>
</div>
</div>

<div class="row"></div>

## Download and Install oVirt Self-Hosted Engine

For production installations, we recommend installing oVirt using the Self-Hosted Engine configuration. In this configuration,
oVirt Engine and a Host are installed together with the Engine running as a Virtual Machine on that Host. This configuration is
more resilent because the Engine Virtual Machine will be highly available (once a second Host is added). See the
[Self-Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide.html) for full installation instructions
for this configuration.

oVirt Self-Hosted Engine is installed using a graphical installer in Cockpit.
Cockpit is enabled by default on [oVirt Nodes](/download/node.html) (see below). If you are using a Enterprise Linux Host,
see [Installing Cockpit on Enterprise Linux Hosts](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html#installing-cockpit-on-enterprise-linux-hosts)
in the [Installation Guide](/documentation/install-guide/Installation_Guide.html).

#### Red Hat Enterprise Linux, CentOS Linux {#RHEL_Installation_Instructions}

{:.instructions}
1.  Enable the Base, Optional, and Extra repositories (they are enabled by default on CentOS).

    On Red Hat Enterprise Linux you'll need a valid subscription and the following repositories enabled:

    - rhel-7-server-rpms
    - rhel-7-server-optional-rpms
    - rhel-7-server-extras-rpms

2.  Add the official oVirt repository.

        sudo yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

3.  Enable Cockpit.

        # enable cockpit if necessary:
        sudo systemctl enable --now cockpit.socket

        # open the firewall if necessary:
        sudo firewall-cmd --add-service=cockpit
        sudo firewall-cmd --add-service=cockpit --permanent

4.  Install cockpit-ovirt-dashboard.

        sudo yum install cockpit-ovirt-dashboard

#### Install oVirt Self-Hosted Engine

{:.instructions}
1.  Log in to Cockpit at https://\[Host IP or FQDN\]:9090 and click Virtualization → Hosted Engine.

2.  Click Start under the Hosted Engine option.

3.  Complete the setup wizard. As part of the setup, you will enter the Hosted Engine's name.

4.  Once the installation completes, oVirt's web UI management interface will start. Browse to
    https://\[Hosted Engine's name\]/ to begin using oVirt!

    See [Browsers and Mobile Clients](/download/browsers_and_mobile.html) for supported browsers and
    mobile client information.

## Download oVirt Engine

If you prefer not to use oVirt Self-Hosted Engine, you can install oVirt Engine and Nodes / Hosts separately.

Our recommended method of installing oVirt Engine is to use the software packages for a supported Enterprise Linux 7 distribution,
such as CentOS Linux or Red Hat Enterprise Linux.

{:.alert.alert-warning}
Experienced users can also compile from source, using the guides found under the [Developers](/develop) section. This is not recommended
unless you are a developer or need to customize the source code.

{:.alert.alert-warning}
**Important:** You cannot skip a version when updating oVirt Engine. For example, if you are updating from
3.6 to 4.2, you first need to update to 4.0, then to 4.1, and finally to 4.2.
If you're updating from a previous version, be sure to have the latest release repository installed
by running <br/>
`sudo yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm`.

#### Red Hat Enterprise Linux, CentOS Linux {#RHEL_Installation_Instructions}

{:.instructions}
1.  Enable the Base, Optional, and Extra repositories (they are enabled by default on CentOS).

    On Red Hat Enterprise Linux you'll need a valid subscription and the following repositories enabled:

    - rhel-7-server-rpms
    - rhel-7-server-optional-rpms
    - rhel-7-server-extras-rpms

2.  Add the official oVirt repository.

        sudo yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

3.  Install oVirt Engine.

        sudo yum install -y ovirt-engine

4.  Set up oVirt Engine.

        sudo engine-setup

5.  Follow the on screen prompts to configure and install the Engine.

6.  Once the installation completes, oVirt's web UI management interface will start and the URL will be printed
    to the screen. Browse to this URL to begin using oVirt!

    See [Browsers and Mobile Clients](/download/browsers_and_mobile.html) for supported browsers and
    mobile client information.

## Download oVirt Node or Setup Hosts

If you installed standalone oVirt Engine, you'll now need to install at least one Node or Host. If you installed
oVirt Self-Hosted Engine, you already have one Host, but you may want another for access to enterprise features
like migration and high availability.

oVirt supports two types of [Hosts](/documentation/install-guide/chap-Introduction_to_Hosts.html):

* [oVirt Node](/download/node.html) and
* [Enterprise Linux (such as CentOS or RHEL)](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html)

Depending on your environment requirements, you may want to use one type only or both in your oVirt environment. It is
recommended that you install and attach at least two Hosts to the oVirt environment. If you attach only one Host, you
will be unable to access features such as migration and high availability.

#### Download oVirt Node

[oVirt Node](/download/node.html) is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a
physical machine to act as a hypervisor in an oVirt environment.

See [Chapter 6: oVirt Nodes](/documentation/install-guide/chap-oVirt_Nodes.html) in the [Installation Guide](/documentation/install-guide/)
for full installation instructions.

Installing [oVirt Node](/download/node.html) on a physical machine and adding it to the Engine involves four steps:

 * Download the oVirt Node Installation ISO (current stable is [oVirt Node 4.2 - Stable Release - Installation ISO](http://jenkins.ovirt.org/job/ovirt-node-ng_ovirt-4.2_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html))

 * Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

 * Boot your physical machine from that media and install the oVirt Node minimal operating system.

 * Follow the instructions in [Adding a Host to the oVirt Engine](/documentation/install-guide/chap-Adding_a_Host_to_the_oVirt_Engine.html)
   to add your Node to the Engine.

#### Setup a Host

Instead of or in addition to oVirt Node, you can use a standard Enterprise Linux installation as a Host.
An Enterprise Linux Host (such as CentOS or RHEL), also known as an EL-based hypervisor or EL-based Host, is a standard
basic installation of an Enterprise Linux operating system on a physical server upon which the hypervisor
packages are installed.

See [Chapter 7: Enterprise Linux Hosts](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html) for full installation
instructions.

Installing and adding an EL Host involves four steps:

 * make sure the Host meets the [Hypervisor Requirements](/documentation/install-guide/chap-System_Requirements.html#hypervisor-requirements)

 * update the Host operating system via `yum update -y` and reboot

 * Add the official oVirt repository

   `sudo yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm`

 * Follow the instructions in [Adding a Host to the oVirt Engine](/documentation/install-guide/chap-Adding_a_Host_to_the_oVirt_Engine.html)
   to add your Host to the Engine. This will automatically install the hypervisor packages on the Host.

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

See [Configuring Storage](/documentation/install-guide/chap-Configuring_Storage.html) and
[Storage Administration](/documentation/admin-guide/chap-Storage.html) for guidance on configuring storage for your
environment.

## Install Virtual Machines

Once oVirt Engine is installed and you have added Hosts and [configured storage](/documentation/install-guide/chap-Configuring_Storage.html),
you can now install Virtual Machines!

See the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide.html) for complete
instructions.

For best Virtual Machine performance and accurate dashboard statistics, install the
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

A console is a graphical window that allows you to view the start up screen, shut down screen, and desktop of a
Virtual Machine, and to interact with that Virtual Machine in a similar way to a physical machine. In oVirt,
the default application for opening a console to a virtual machine is Remote Viewer, which must be installed on
the client machine (for example, the end user or administrator's laptop). For Windows virtual machines, Remote
Desktop Protocol is also available.

See [Installing Console Components](/documentation/vmm-guide/chap-Introduction.html#installing-console-components)
for installation instructions.

#### Browser based

There is also a browser-based console available. In the Console Options dialog for the Virtual Machine, select `noVNC`.
See [VNC Console Options](/documentation/vmm-guide/chap-Additional_Configuration.html#vnc-console-options) and
and [Browser Support and Mobile Clients](/download/browsers_and_mobile.html) for more information.

<hr/>

## RPM Repositories and GPG keys

[RPM repository for oVirt 4.2 - Latest stable release](https://resources.ovirt.org/pub/ovirt-4.2/)

See [RPMs and GPG](/download/rpms_and_gpg.html) for older releases, nightlies, mirrors, and GPG keys.

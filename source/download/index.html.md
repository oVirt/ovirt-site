---
title: Download
authors: bproffitt, dneary, knesenko, mburns, sandrobonazzola, theron, gshereme
---

<style>
.deployment {
  width: 55%;
  float: left;
}
.requirements {
  width: 42%;
  float: right;
}
.clear-left {
  clear: left;
}
.button-container {
  min-height: 40px;
  padding: 10px;
  margin: 10px;
  text-align: center;
  vertical-align: middle;
}
</style>

# Download oVirt

oVirt has two components to install -- the oVirt engine and its hosts. Alternatively, you can install an engine and a host
together with the engine as a VM on the host -- this configuration is known as Self-Hosted Engine.

See the [oVirt Installation Guide](/documentation/install-guide/Installation_Guide/) for full installation instructions.

<div class="row">
<div class="col-sm-3">
<div class="button-container">
<a href="#download-ovirt-engine" class="btn btn-primary">Download oVirt Engine</a>
</div>
</div>
<div class="col-sm-3">
<div class="button-container">
<a href="#download-ovirt-node-or-setup-hosts" class="btn btn-primary">Download oVirt Node or Setup Hosts</a>
</div>
</div>
<div class="col-sm-2">
<div class="button-container">
or
</div>
</div>
<div class="col-sm-3">
<div class="button-container">
<a href="/documentation/self-hosted/Self-Hosted_Engine_Guide.html" class="btn btn-primary">Install oVirt Self-Hosted Engine</a>
</div>
</div>
</div>
<div class="row"></div>

## Download oVirt Engine

oVirt engine 4.2.7 is intended for production use and is available for the following platforms:

- Red Hat Enterprise Linux 7.5 or later
- CentOS Linux 7.5 or later
- Scientific Linux 7.5 or later

See the [Release Notes for oVirt 4.2.7](/release/4.2.7/) and the [Installation Guide](/documentation/install-guide/Installation_Guide.html).

Our recommended method of installing oVirt engine is to use the software packages for a supported Enterprise Linux 7 distribution,
such as CentOS Linux or Red Hat Enterprise Linux.

{:.alert.alert-warning}
**Important:** Please note you can not skip a version when upgrading oVirt engine. If you are updating from e.g. 3.6,
you first need to update to 4.0, then to 4.1 and finally to 4.2.
If you're upgrading from a previous version, please update ovirt-release42 and verify
you have the correct repositories enabled by running the following commands before upgrading.

#### Red Hat Enterprise Linux, CentOS Linux {#RHEL_Installation_Instructions}

1.  Ensure that you have required repositories for your distribution.

    On CentOS the Base, Optional and Extras repositories are already enabled by default and must be enabled.

    On Red Hat Enterprise Linux you'll need a valid subscription and the following repositories enabled:

    - rhel-7-server-rpms
    - rhel-7-server-optional-rpms
    - rhel-7-server-extras-rpms

2.  Add the official oVirt repository.

        sudo yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

    -   This will add repositories from ovirt.org to your host allowing you to get the latest oVirt rpms.
    -   It will also enable any other needed repository

3.  Install oVirt Engine.

        sudo yum install -y ovirt-engine

4.  Set up oVirt Engine.

        sudo engine-setup

5.  Follow the on screen prompts to configure and install the engine
6.  Once you have successfully installed oVirt Engine, you will be provided with instructions to access oVirt's web-based management interface.
7.  Congratulations! oVirt Engine is now installed!

{:.alert.alert-warning}
Experienced users can also compile from source, using the guides found under the [Developers](/develop) section.

## Download oVirt Node or Setup Hosts

oVirt supports two types of [hosts](/documentation/install-guide/chap-Introduction_to_Hosts.html):

* [oVirt Node](/download/node.html) and
* [Enterprise Linux (such as CentOS or RHEL)](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html)

Depending on your environment requirements, you may want to use one type only or both in your oVirt environment. It is
recommended that you install and attach at least two hosts to the oVirt environment. If you attach only one host, you
will be unable to access features such as migration and high availability.

#### Download oVirt Node

oVirt Node is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a
physical machine to act as a hypervisor in an oVirt environment. The minimal operating system contains only the packages
required for the machine to act as a hypervisor, and features a Cockpit user interface for monitoring the host and
performing administrative tasks. See [http://cockpit-project.org/running.html](http://cockpit-project.org/running.html)
for the minimum browser requirements.

See [Chapter 6: oVirt Nodes](/documentation/install-guide/chap-oVirt_Nodes.html) in the [Installation Guide](/documentation/install-guide/)
for installation instructions.

Also see [Chapter 5: Introduction to Hosts](/documentation/install-guide/chap-Introduction_to_Hosts.html) and
[Chapter 7: Enterprise Linux Hosts](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html)

Installing oVirt Node on a physical machine involves three key steps:

 * Download the oVirt Node Installation ISO below (probably [oVirt Node 4.2 - Stable Release - Installation ISO](http://jenkins.ovirt.org/job/ovirt-node-ng_ovirt-4.2_build-artifacts-el7-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/latest-installation-iso.html))

 * Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

 * Boot your physical machine from that media and install the oVirt Node minimal operating system.

#### Setup a Host

An Enterprise Linux host (such as CentOS or RHEL), also known as an EL-based hypervisor, is based on a standard basic
installation of an Enterprise Linux operating system on a physical server.

See [Chapter 7: Enterprise Linux Hosts](/documentation/install-guide/chap-Enterprise_Linux_Hosts.html) for installation
instructions.

## Supported Guest Distributions

Once oVirt Engine is installed and you have added a Host, you can proceed to install any number of supported operating systems as guest virtual machines.

|Operating System|Architecture|SPICE support|
|:---------------|:-----------|:------------|
|Red Hat Enterprise Linux 3|32-bit, 64-bit|Yes|
|Red Hat Enterprise Linux 4|32-bit, 64-bit|Yes|
|Red Hat Enterprise Linux 5|32-bit, 64-bit|Yes|
|Red Hat Enterprise Linux 6|32-bit, 64-bit|Yes|
|Red Hat Enterprise Linux 7|64-bit|Yes|
|SUSE Linux Enterprise Server 10 [1]|32-bit, 64-bit|No|
|SUSE Linux Enterprise Server 11 [2]|32-bit, 64-bit|No|
|Ubuntu 12.04 (Precise Pangolin LTS)|32-bit, 64-bit|Yes|
|Ubuntu 12.10 (Quantal Quetzal)|32-bit, 64-bit|Yes|
|Ubuntu 13.04 (Raring Ringtail)|32-bit, 64-bit|Yes|
|Ubuntu 13.10 (Saucy Salamander)|32-bit, 64-bit|Yes|
|Windows XP Service Pack 3 and newer|32-bit|Yes|
|Windows 7|32-bit, 64-bit|Yes|
|Windows 8|32-bit, 64-bit|No|
|Windows 10[3]|32-bit, 64-bit|Yes|
|Windows Server 2003 Service Pack 2 and newer|32-bit, 64-bit|Yes|
|Windows Server 2008|32-bit, 64-bit|Yes|
|Windows Server 2008 R2|64-bit|Yes|
|Windows Server 2012 R2|64-bit|No|
|Windows Server 2016|64-bit|No|

[1] select Other Linux for the guest type in the user interface<br/>
[2] SPICE drivers (QXL) are not supplied by Red Hat. Distribution's vendor may provide SPICE drivers.<br/>
[3] 64-bit only. SPICE upstream drivers are also [available](https://www.spice-space.org/download/windows/qxl-wddm-dod/qxl-wddm-dod-0.18/)

## RPM Repositories for oVirt

-   **[ovirt-4.2 - Latest stable release](https://resources.ovirt.org/pub/ovirt-4.2/)**

### Older unsupported version releases of oVirt

-   [ovirt-4.1](https://resources.ovirt.org/pub/ovirt-4.1/)
-   [ovirt-4.0](https://resources.ovirt.org/pub/ovirt-4.0/)
-   [ovirt-3.6](https://resources.ovirt.org/pub/ovirt-3.6/)
-   [ovirt-3.5](https://resources.ovirt.org/pub/ovirt-3.5/)
-   [ovirt-3.4](https://resources.ovirt.org/pub/ovirt-3.4/)
-   [ovirt-3.3](https://resources.ovirt.org/pub/ovirt-3.3/)

### Nightly builds of oVirt

-   [ovirt-4.3 Nightly](https://resources.ovirt.org/pub/ovirt-master-snapshot)
-   [ovirt-4.2 Nightly](https://resources.ovirt.org/pub/ovirt-4.2-snapshot)

## Mirrors for oVirt Downloads

### Europe

- [NLUUG](https://ftp.nluug.nl/os/Linux/virtual/ovirt/) (
[oVirt 4.2](https://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-4.2/)
[oVirt 4.1](https://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-4.1/)
[oVirt 4.0](https://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-4.0/)
[oVirt 4.2 Development Nightly](http://ftp.nluug.nl/os/Linux/virtual/ovirt/ovirt-master-snapshot/))
- [Plus.line AG](http://www.plusline.net/en/) (
[oVirt 4.2](http://ftp.plusline.net/ovirt/ovirt-4.2/)
[oVirt 4.1](http://ftp.plusline.net/ovirt/ovirt-4.1/)
[oVirt 4.0](http://ftp.plusline.net/ovirt/ovirt-4.0/)
[oVirt 4.2 Development Nightly](http://ftp.plusline.net/ovirt/ovirt-master-snapshot/))
- [SNT - University of Twente](http://ftp.snt.utwente.nl/pub/software/ovirt/) (
[oVirt 4.2](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-4.2/)
[oVirt 4.1](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-4.1/)
[oVirt 4.0](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-4.0/)
[oVirt 4.2 Development Nightly](http://ftp.snt.utwente.nl/pub/software/ovirt/ovirt-master-snapshot/))

### North America

- [Duke University](http://archive.linux.duke.edu/ovirt/) (
[oVirt 4.2](http://archive.linux.duke.edu/ovirt/pub/ovirt-4.2/)
[oVirt 4.1](http://archive.linux.duke.edu/ovirt/pub/ovirt-4.1/)
[oVirt 4.0](http://archive.linux.duke.edu/ovirt/pub/ovirt-4.0/)
[oVirt 4.2 Development Nightly](http://archive.linux.duke.edu/ovirt/pub/ovirt-master-snapshot/))
- [Georgia Institute of Technology](http://www.gtlib.gatech.edu/pub/oVirt) (
[oVirt 4.2](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-4.2/)
[oVirt 4.1](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-4.1/)
[oVirt 4.0](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-4.0/)
[oVirt 4.2 Development Nightly](http://www.gtlib.gatech.edu/pub/oVirt/pub/ovirt-master-snapshot/)
[FTP Site](ftp://ftp.gtlib.gatech.edu/pub/oVirt))
- [ibiblio](http://mirrors.ibiblio.org/ovirt/) (
[oVirt 4.2](http://mirrors.ibiblio.org/ovirt/pub/ovirt-4.2/)
[oVirt 4.1](http://mirrors.ibiblio.org/ovirt/pub/ovirt-4.1/)
[oVirt 4.0](http://mirrors.ibiblio.org/ovirt/pub/ovirt-4.0/)
[oVirt 4.2 Development Nightly](http://mirrors.ibiblio.org/ovirt/pub/ovirt-master-snapshot/))

### Asia

- [Hamakor](http://mirror.isoc.org.il/pub/ovirt/) (
[ovirt 4.2](http://mirror.isoc.org.il/pub/ovirt/ovirt-4.2/)
[ovirt 4.1](http://mirror.isoc.org.il/pub/ovirt/ovirt-4.1/)
[ovirt 4.0](http://mirror.isoc.org.il/pub/ovirt/ovirt-4.0/)
[oVirt 4.2 Development Nightly](http://mirror.isoc.org.il/pub/ovirt/ovirt-master-snapshot/))

## GPG Keys used by oVirt

**Important:** We are going to sign RPMs only from next release. Please wait for the announcement email

How does oVirt Project use GPG keys to sign packages? Each stable RPM package that is published by oVirt Project is signed with a GPG signature. By default, yum and the graphical update tools will verify these signatures and refuse to install any packages that are not signed or have bad signatures. You should always verify the signature of a package before you install it. These signatures ensure that the packages you install are what was produced by the oVirt Project and have not been altered (accidentally or maliciously) by any mirror or website that is providing the packages. Nightly repositories wont be signed.

### Importing Keys Manually

For some repositories, such as repositories with stable in default configuration, yum is able to find a proper key for the repository and asks the user for confirmation before importing the key if the key is not already imported into the rpm database.

To get the public key:

    $ gpg --recv-keys FE590CB7
    $ gpg --list-keys --with-fingerprint FE590CB7
    ---
    pub   2048R/FE590CB7 2014-03-30 [expires: 2021-04-03]
          Key fingerprint = 31A5 D783 7FAD 7CB2 86CD  3469 AB8C 4F9D FE59 0CB7
    uid                  oVirt <infra@ovirt.org>
    sub   2048R/004BC303 2014-03-30 [expires: 2021-04-03]
    ---
    $ gpg --export --armor FE590CB7 > ovirt-infra.pub
    # rpm --import ovirt-infra.pub

Importing keys Automatically

    yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

**Important:** yum will prompt sysadmin to acknowledge import of key, make sure key id is FE590CB7.

### Verifying a package

When using default configuration of yum package updating and installation tool in stable releases, signature of each package is verified before it is installed. Signature verification can be turned off and on globally or for specific repository with gpgcheck directive. Do not override the default setting of this directive unless you have a very good reason to do so. If you do not use yum, you can check the signature of the package using the following command

    rpm {-K|--checksig} PACKAGE_FILE ...

### Currently used keys

| Key ID     | Key Type     | Key Fingerprint                                     | Key Description | Created    | Expires    | Revoked | Notes |
|------------|--------------|-----------------------------------------------------|-----------------|------------|------------|---------|-------|
| `FE590CB7` | 2048-bit RSA | `31A5 D783 7FAD 7CB2 86CD 3469 AB8C 4F9D FE59 0CB7` | oVirt           | 2014-03-30 | 2021-04-03 |         |       |

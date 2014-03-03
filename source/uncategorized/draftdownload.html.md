---
title: DraftDownload
authors: abonas, bproffitt
wiki_title: DraftDownload
wiki_revision_count: 64
wiki_last_updated: 2014-03-25
wiki_warnings: list-item?
---

# Draft Download

__NOTOC__

<div class="row">
<div class="span6 pad-left pad-right-small">
## oVirt Deployment Options

oVirt is a virtual datacenter manager that delivers powerful management of multiple virtual machines on multiple hosts. Using KVM and libvirt, oVirt can be installed on Fedora, CentOS, or Red Hat Enterprise Linux hosts to set up and manage your virtual data center.

If you are absolutely new to oVirt, try our [ Live version](OVirt_Live) where you can test-drive oVirt on CentOS without installing it on your machine.

If you have some knowledge of installing packages on Linux, you should install our All-in-One solution using the [ Quick Start](#Quick_Start_Guide) instructions below.

Experienced users can also compile from source, using the guides on [ the oVirt engine](Building oVirt engine) and [ oVirt Node](Node Building).

</div>
<div class="span6 pad-left-small pad-right">
<div class="well">
### System Requirements

<div class="row-fluid">
<div class="span6">
Versions of oVirt  
*   Stable (**Recommended**)

*   Current Development

*   Future Development

<!-- -->

Minimum Hardware:  

    * 4 GB memory

    * 20 GB disk space

Optional Hardware:  

    * Network storage

</div>
<div class="span6">
Supported Hosts:  

    * Fedora 19

    * CentOS 6.4

    * Red Hat Enterprise Linux 6.4

    * [Gentoo](//wiki.gentoo.org/wiki/OVirt) (experimental)

    * [ Debian](ovirt build on debian/ubuntu) (experimental)

Recommended Web Browsers for Engine:  

    * Mozilla Firefox 17 or later

    * Internet Explorer 9 or later

</div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="span10 offset1">
### Supported Guest Distributions

| Operating System                                                                                                                                                               | Architecture   | SPICE support |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------------|
| Red Hat Enterprise Linux 3                                                                                                                                                     | 32-bit, 64-bit | Yes           |
| Red Hat Enterprise Linux 4                                                                                                                                                     | 32-bit, 64-bit | Yes           |
| Red Hat Enterprise Linux 5                                                                                                                                                     | 32-bit, 64-bit | Yes           |
| Red Hat Enterprise Linux 6                                                                                                                                                     | 32-bit, 64-bit | Yes           |
| SUSE Linux Enterprise Server 10 (select Other Linux for the guest type in the user interface)                                                                                  | 32-bit, 64-bit | No            |
| SUSE Linux Enterprise Server 11 (SPICE drivers (QXL) are not supplied by Red Hat. However, the distribution's vendor may provide spice drivers as part of their distribution.) | 32-bit, 64-bit | No            |
| Ubuntu 12.04 (Precise Pangolin LTS)                                                                                                                                            | 32-bit, 64-bit | Yes           |
| Ubuntu 12.10 (Quantal Quetzal)                                                                                                                                                 | 32-bit, 64-bit | Yes           |
| Ubuntu 13.04 (Raring Ringtail)                                                                                                                                                 | 32-bit, 64-bit | Yes           |
| Ubuntu 13.10 (Saucy Salamander)                                                                                                                                                | 32-bit, 64-bit | Yes           |
| Windows XP Service Pack 3 and newer                                                                                                                                            | 32-bit         | Yes           |
| Windows 7                                                                                                                                                                      | 32-bit, 64-bit | Yes           |
| Windows 8                                                                                                                                                                      | 32-bit, 64-bit | No            |
| Windows Server 2003 Service Pack 2 and newer                                                                                                                                   | 32-bit, 64-bit | Yes           |
| Windows Server 2008                                                                                                                                                            | 32-bit, 64-bit | Yes           |
| Windows Server 2008 R2                                                                                                                                                         | 64-bit         | Yes           |
| Windows Server 2012 R2                                                                                                                                                         | 64-bit         | No            |

### Quick Start Guide

<div class="alert alert-info">
IMPORTANT NOTE: If you're upgrading from a previous version, please update ovirt-release to the latest version (10) and verify you have the correct repositories enabled by running the following commands

    # yum update ovirt-release
    # yum repolist enabled

before upgrading with the usual procedure. You should see the ovirt-3.3.2 and ovirt-stable repositories listed in the output of the repolist command.

</div>
Our recommended method of installing oVirt is to use the pre-built packages for Fedora or an EL6 distribution. It makes installing oVirt very easy. Naturally, you can run any Linux distribution or several other operating systems (e.g. Windows) as guests inside of oVirt instances.

If you are looking to preview the project without permanently dedicating a machine, you can also try the LiveCD image. This image will appear under the [tools](http://resources.ovirt.org/releases/stable/tools) directory. This generally appears a week or two after a release, due to the need to have final release packages available.

#### [Fedora 19](http://fedoraproject.org/en/download-splash?file=http://download.fedoraproject.org/pub/fedora/linux/releases/19/Live/x86_64/Fedora-Live-Desktop-x86_64-19-1.iso)

1.  Add the official oVirt repository for Fedora. <kbd>
        sudo yum localinstall http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm

    </kbd>

    -   This will add repositories from ovirt.org to your host allowing you to get the latest and greatest oVirt rpms.
    -   It will also enable the [virt-preview](http://fedoraproject.org/wiki/Virtualization_Preview_Repository) repository on your machine giving you access to the latest versions of things like libvirt and KVM.

2.  Install oVirt Engine. <kbd>
        sudo yum install -y ovirt-engine

    </kbd>

3.  Optionally install the All-In-One plugin if you want to host VMs on your Engine Host <kbd>
        sudo yum install -y ovirt-engine-setup-plugin-allinone

    </kbd>

4.  Set up oVirt Engine. <kbd>
        sudo engine-setup

    </kbd>

5.  Follow the on screen prompts to configure and install the engine
6.  Once you have successfully installed oVirt Engine, you will be provided with instructions to access oVirt's web-based management interface.
7.  Congratulations! oVirt Engine is now installed!
8.  For every virtualization server you'd like to manage, you can now [ set them up as oVirt hosts](Quick Start Guide#Install_Hosts) .

#### Enterprise Linux 6

These instructions should work for both Red Hat Enterprise Linux and CentOS. They will likely work with other binary compatible EL6 version as well, but they were not tested. It is strongly recommended that you use at least version 6.4.

<div class="alert alert-info">
Warning: Native GlusterFS support will not work with Red Hat Enterprise Linux 6.4 at this time

</div>
1.  Add the official oVirt repository for EL6. <kbd>
        sudo yum localinstall http://ovirt.org/releases/ovirt-release-el.noarch.rpm

    </kbd>

    -   This will add repositories from ovirt.org to your host allowing you to get the latest and greatest oVirt rpms.
    -   It will also enable the gluster repository for their 3.4.0 release, so you will get those updates correctly as well

2.  Add (or enable) the [EPEL yum repository](http://dl.fedoraproject.org/pub/epel/6/x86_64/)
3.  Install oVirt Engine. <kbd>
        sudo yum install -y ovirt-engine

    </kbd>

4.  Optionally install the All-In-One plugin if you want to host VMs on your Engine Host <kbd>
        sudo yum install -y ovirt-engine-setup-plugin-allinone

    </kbd>

5.  Set up oVirt Engine. <kbd>
        sudo engine-setup

    </kbd>

6.  Follow the on screen prompts to configure and install the engine
7.  Once you have successfully installed oVirt Engine, you will be provided with instructions to access oVirt's web-based management interface.
8.  Congratulations! oVirt Engine is now installed!
9.  For every virtualization server you'd like to manage, you can now [ set them up as oVirt nodes](Quick Start Guide#Install_Hosts) .

------------------------------------------------------------------------

Now that you have oVirt running, check out the [ documentation section](documentation) and be sure to [ join our community](community)!

Help [ develop the software](develop), take part in discussions on the [mailing lists](mailing lists) and join us [ on IRC](communication#IRC).

</div>
</div>

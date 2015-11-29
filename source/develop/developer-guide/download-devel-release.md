---
title: Download devel release
authors: dneary
wiki_title: Download devel release
wiki_revision_count: 1
wiki_last_updated: 2014-01-13
wiki_warnings: list-item?
---

# Download devel release

__NOTOC__

<div class="row">
<div class="col-md-6 pad-left pad-right-small">
## Help test oVirt prereleases

We’re working hard to make oVirt easy to install and available everywhere. As part of our efforts, we release early, and release often. We appreciate the help our our community in testing prereleases of oVirt, and [ reporting bugs](Community#Find_and_file_bugs) you find in new releases.

Right now, oVirt runs best on Fedora or CentOS/RHEL on x86-64, but we're adding new distributions and new hardware platforms all the time. We particularly want to make it easier for people to use [ovirt build on debian/ubuntu | [oVirt Engine on Ubuntu and Debian]]. And if you’re not afraid of compiling from source, we also have guides on how to install [ the oVirt engine](Building oVirt engine) and [ oVirt Node](Node Building) from source.

You can also [ help us make oVirt easier to install everywhere](porting oVirt) too.

</div>
<div class="col-md-6 pad-left-small pad-right">
<div class="well">
### You’ll need the following…

<div class="row-fluid">
<div class="col-md-6">
Minimum hardware:  

    * 4 GB memory

    * 20 GB disk space

Optional:  

    * Network storage

Software:  

    * Fedora 19 or Red Hat Enterprise Linux 6.5 (or similar)

</div>
<div class="col-md-6">
Recommended web browsers for Engine:  

    * Mozilla Firefox 17 or later

    * Internet Explorer 9 or later

Advanced; install [ Engine](Building oVirt engine) and [ Node](Node Building) from source:  
Help [ port oVirt](porting oVirt) to [Debian](http://www.debian.org), [Ubuntu](http://www.ubuntu.com), [OpenSuse](http://www.opensuse.org) and other distributions, or help [ support Chrome for the Engine](supporting Chrome)

</div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-10 col-md-offset-1">
### Quickstart guide

<div class="alert alert-info">
Warning: These instructions are still being checked against the 3.4.0 alpha release

</div>
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

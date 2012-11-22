---
title: Download
authors: bproffitt, dneary, knesenko, mburns, sandrobonazzola, theron
wiki_title: Download
wiki_revision_count: 60
wiki_last_updated: 2015-01-21
wiki_warnings: list-item?
---

# Download

__NOTOC__

<div class="row">
<div class="span6 pad-left pad-right-small">
## Get started with oVirt

We’re working hard to make oVirt easy to install and available everywhere.

Since oVirt is a relatively young project, setting it up is still a little tricky… but it’s getting easier with every release.

Right now, oVirt runs best on Fedora — and we tailored our quickstart guide to reflect this fact — but if you’re not afraid of compiling from source, we also have guides on [how to install oVirt for many distributions](how to install oVirt for many distributions).

You can also [help us make oVirt easier to install everywhere](help us make oVirt easier to install everywhere) too.

</div>
<div class="span6 pad-left-small pad-right">
<div class="well">
### You’ll need the following…

<div class="row-fluid">
<div class="span6">
Minimum hardware:  

    * 4 GB memory

    * 20 GB disk space

Optional:  

    * Network storage

</div>
<div class="span6">
Software:  

    * Fedora 17 (for easy installation)

Advanced; install from source:  
[Debian](http://www.debian.org), [Fedora](http://www.fedoraproject.org), [Ubuntu](http://www.ubuntu.com), [ other](porting oVirt)

</div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="span10 offset1">
### Quickstart guide ([Fedora 17](http://fedoraproject.org/download-splash?file=http://download.fedoraproject.org/pub/fedora/linux/releases/17/Live/x86_64/Fedora-17-x86_64-Live-Desktop.iso))

Our recommended method of installing oVirt is to use the pre-built packages for Fedora. It makes installing oVirt very easy. Naturally, you can run any Linux distribution or several other operating systems (e.g. Windows) as guests inside of oVirt instances.

1.  Add the official oVirt repository for Fedora. <kbd>
        sudo yum localinstall http://ovirt.org/releases/ovirt-release-fedora.noarch.rpm

    </kbd>

2.  Install oVirt Engine. <kbd>
        sudo yum install -y ovirt-engine

    </kbd>

3.  Set up oVirt Engine. <kbd>
        sudo engine-setup

    </kbd>

4.  Once you have successfully installed oVirt Engine, you will be provided with instructions to access oVirt's web-based management interface.
5.  Congratulations! oVirt Engine is now installed!
6.  You can now [download and install oVirt Node](download and install oVirt Node) for every virtualization server you'd like to set up.

------------------------------------------------------------------------

Now that you have oVirt running, check out the [ documentation section](documentation) and be sure to [ join our community](community)!

Help [ develop the software](develop), take part in discussions on the [mailing lists](mailing lists) and join us [ on IRC](communication#IRC).

</div>
</div>

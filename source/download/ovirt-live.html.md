---
title: oVirt Live
category: integration
authors: apevec, bproffitt, dneary, jvandewege, mgoldboi, obasan, sandrobonazzola,
  stirabos
wiki_category: Integration
wiki_title: OVirt Live
wiki_revision_count: 58
wiki_last_updated: 2015-10-28
---

# oVirt Live

## What is it?

oVirt Live is an unofficial [Fedora spin](http://spins.fedoraproject.org/about) of [Fedora Live CD](http://fedoraproject.org/wiki/FedoraLiveCD) and [CentOS Live CD](https://projects.centos.org/trac/livecd/), based on oVirt stable releases using [All In One](AllInOne) plugin.

## Why do we need it?

oVirt Live can be used for POC or demos, and for giving a sneak preview on the working product operation. It simplifies the installation for new users, and will allow users to experiment with oVirt before installing it.

## How can I use it?

oVirt Live comes as a live os, you can either use it:

### DVD

read only (all changes will be gone upon reboot)

### USB

can be used either as read only or with persistent storage

[How to create and use Live USB](http://fedoraproject.org/wiki/How_to_create_and_use_Live_USB)

[liveusb-creator](https://fedorahosted.org/liveusb-creator)

Be aware that using these tools can lead to a kernel panic when the stick is booted. Using dd on linux and for example WinImage when on Windows seems to work better.

### VM

you can run this iso on a vm, using nested virtualization you can run nested vms within it.

the flow which worked for me:

       # cat /sys/module/kvm_intel/parameters/nested
       N
       # vi /etc/default/grub
       GRUB_CMDLINE_LINUX="rd.md=0 rd.dm=0  KEYTABLE=us SYSFONT=True rd.lvm.lv=vg/lv_root rd.luks=0 rd.lvm.lv=vg/lv_swap LANG=en_US.UTF-8 rhgb quiet kvm-intel.nested=1" #Add kvm-intel.nested=1 in the end of the boot options
       # grub2-mkconfig -o /boot/grub2/grub.cfg

       Instead of modifying grub config, you can: echo "options kvm-intel nested=1" > /etc/modprobe.d/kvm-intel.conf

       #reboot
       # virsh capabilities  (collecting data from hypervisor)
        ...
          <cpu>
            <model>Penryn</model>
            <vendor>Intel</vendor>
            <feature policy='require' name='vmx'/>
          </cpu>
        ....
       

create a vm with your favourite manager (ovirt ;) add the <cpu> output from virsh to your vm xml adding match='exact' to <cpu>

       # vi /etc/libvirt/qemu/your_vm_name
       <cpu match='exact'>
       ...
       </cpu>
       

[Nested_KVM](http://wiki.ovirt.org/wiki/Vdsm_Developers#Running_Node_as_guest_-_Nested_KVM)

## Testing

You can get latest nightly build of oVirt Live based on CentOS 7 and oVirt master here:

[`http://jenkins.ovirt.org/job/ovirt_live_create_iso/`](http://jenkins.ovirt.org/job/ovirt_live_create_iso/)

Nighlty builds of oVirt Live based on CentOS 7 and oVirt 3.6 are also available here:

[`http://jenkins.ovirt.org/job/ovirt-live_3.6-create-iso/`](http://jenkins.ovirt.org/job/ovirt-live_3.6-create-iso/)

If you're testing oVirt Live and you find issues please open a bug: <https://bugzilla.redhat.com/enter_bug.cgi?product=ovirt-live>

## Releases
### oVirt Live 3.6.5 - Apr 21st 2016

**Download**

*   EL7.2 based: [Download oVirt Live 3.6.5](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/ovirt-live-el7-3.6.5.iso)

**ChangeLog**

*   Based on oVirt 3.6.5 final, see [oVirt 3.6.5 Release Notes](http://www.ovirt.org/release/3.6.5/)

### oVirt Live 3.6.4 - Mar 29th 2016

**Download**

*   EL7.2 based: [Download oVirt Live 3.6.4](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/ovirt-live-el7-3.6.4.iso)

**ChangeLog**

*   Based on oVirt 3.6.4 final, see [oVirt 3.6.4 Release Notes](http://www.ovirt.org/release/3.6.4/)


### oVirt Live 3.6.3 - Mar 1st 2016

**Download**

*   EL7.2 based: [Download oVirt Live 3.6.3](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/ovirt-live-el7-3.6.3.iso)

**ChangeLog**

*   Based on oVirt 3.6.3 final, see [oVirt 3.6.3 Release Notes](http://www.ovirt.org/release/3.6.3/)

### oVirt Live 3.6.2 - Jan 26th 2016

**Download**

*   EL7.2 based: [Download oVirt Live 3.6.2](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/ovirt-live-el7-3.6.2.iso)

**ChangeLog**

*   Based on oVirt 3.6.2 final, see [oVirt 3.6.2 Release Notes](oVirt 3.6.2 Release Notes)

### oVirt Live 3.6.1 - Dec 17th 2015

**Download**

*   EL7.2 based: [Download oVirt Live 3.6.1](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/ovirt-live-el7-3.6.1.iso)

**ChangeLog**

*   Based on oVirt 3.6.1 final, see [oVirt 3.6.1 Release Notes](oVirt 3.6.1 Release Notes)

### oVirt Live 3.6.0 - Nov 4th 2015

**Download**

*   EL7.1 based: [Download oVirt Live 3.6.0](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/ovirt-live-el7-3.6.0.iso)

**ChangeLog**

*   Based on oVirt 3.6.0 final, see [oVirt 3.6 Release Notes](oVirt 3.6 Release Notes)

### oVirt Live 3.5.6 - Dec 1st 2015

**Download**

*   EL6 based: [Download oVirt Live 3.5.6](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.6/ovirt-live-el6-3.5.6.iso)

**ChangeLog**

*   Based on oVirt 3.5.6 final, see [oVirt 3.5.6 Release Notes](oVirt 3.5.6 Release Notes)

### oVirt Live 3.5.5 - Oct 26th 2015

**Download**

*   EL6 based: [Download oVirt Live 3.5.5](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.5/ovirt-live-el6-3.5.5.iso)

**ChangeLog**

*   Based on oVirt 3.5.5 final, see [oVirt 3.5.5 Release Notes](oVirt 3.5.5 Release Notes)

### oVirt Live 3.5.4 - Sep 3rd 2015

**Download**

*   EL6 based: [Download oVirt Live 3.5.4](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.4/ovirt-live-el6-3.5.4.iso)

**ChangeLog**

*   Based on oVirt 3.5.4 final, see [oVirt 3.5.4 Release Notes](oVirt 3.5.4 Release Notes)

### oVirt Live 3.5.3 - Jun 15th 2015

**Download**

*   EL6 based: [Download oVirt Live 3.5.3](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.3/ovirt-live-el6-3.5.3.iso)

**ChangeLog**

*   Based on oVirt 3.5.3 final, see [oVirt 3.5.3 Release Notes](oVirt 3.5.3 Release Notes)

### oVirt Live 3.5.2 - Apr 28th 2015

**Download**

*   EL6 based: [Download oVirt Live 3.5.2](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live/el6-3.5.2/ovirt-live-el6-3.5.2.iso)

**ChangeLog**

*   Based on oVirt 3.5.2 final, see [oVirt 3.5.2 Release Notes](oVirt 3.5.2 Release Notes)

### oVirt Live 3.5.1.1 - Feb 2nd 2015

**Download**

*   EL6 based: [Download oVirt Live 3.5.1.1](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live-el6-3.5.1.1.iso)

**ChangeLog**

*   Based on oVirt 3.5.1.1 final, see [oVirt 3.5.1 Release Notes](oVirt 3.5.1 Release Notes)

### oVirt Live 3.5.1 - Jan 22th 2015

**Download**

*   EL6 based: [Download oVirt Live 3.5.1](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live-el6-3.5.1.iso)

**ChangeLog**

*   Based on oVirt 3.5.1 final, see [oVirt 3.5.1 Release Notes](oVirt 3.5.1 Release Notes)

### oVirt Live 3.5.0 - Oct 17th 2014

**Download**

*   EL6 based: [Download oVirt Live 3.5.0](http://resources.ovirt.org/pub/ovirt-3.5/iso/ovirt-live-el6-3.5.0.iso)

**ChangeLog**

*   Based on oVirt 3.5.0 final, see [oVirt 3.5 Release Notes](oVirt 3.5 Release Notes)

### oVirt Live 3.4.4 - Sep 23rd 2014

**Download**

*   EL6 based: [Download oVirt Live 3.4.4](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.4.iso)

**ChangeLog**

*   Based on oVirt 3.4.4 final, see [oVirt 3.4.4 Release Notes](oVirt 3.4.4 Release Notes)

### oVirt Live 3.4.3 - Jul 18th 2014

**Download**

*   EL6 based: [Download oVirt Live 3.4.3](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.3-1.iso)

**ChangeLog**

*   Based on oVirt 3.4.3 final, see [oVirt 3.4.3 Release Notes](oVirt 3.4.3 Release Notes)

### oVirt Live 3.4.2 - Jun 10th 2014

**Download**

*   EL6 based: [Download oVirt Live 3.4.2](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-el6-3.4.2.iso)

**ChangeLog**

*   Based on oVirt 3.4.2 final, see [oVirt 3.4.2 Release Notes](oVirt 3.4.2 Release Notes)

### oVirt Live 3.4.1 - May 8th 2014

**Download**

*   EL6 based: [Download oVirt Live 3.4.1](http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-live-3.4.1.el6ev.iso)

**ChangeLog**

*   Based on oVirt 3.4.1 final, see [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes)

### oVirt-Live-3.4.iso - Mar 30 2014

**Download**

*   EL6 based: [Download oVirt Live 3.4](http://resources.ovirt.org/releases/3.4/iso/ovirt-live-3.4.0.el6ev.iso)

**ChangeLog**

*   Based on oVirt 3.4 final

### oVirt-Live-1.1.iso - Oct 14th 2013

**Download**

*   EL6 based: [Download oVirt Live 1.1](http://resources.ovirt.org/releases/3.3/tools/ovirt-live-el6.iso)

**ChangeLog**

*   Based on oVirt 3.3 final

### oVirt-Live-1.0.iso - Feb 21th 2013

**Download**

*   Fedora 18 based: [Download oVirt Live 1.0](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-1.0.iso)
*   EL6 based: [Download oVirt Live 1.0](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-el6.iso)

**ChangeLog**

*   Based on oVirt 3.2 final

### oVirt-Live-0.97.iso - beta version Feb 1th 2013

**Download**

*   [Download oVirt Live 0.97](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-0.97.iso)

**ChangeLog**

*   Based on ovirt 3.2 beta
*   Fedora 18
*   workaround for <https://bugzilla.redhat.com/show_bug.cgi?id=878119>

### oVirt-Live-0.9.iso - beta version Jan 9th 2013

**Download**

*   [Download oVirt Live 0.9](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-0.9.iso)

**ChangeLog**

*   Based on ovirt 3.2 nightly (git1a60fea)
*   Fedora 18 beta

**Known-Issues**

*   On some chipsets one could encounter the following bug: which will cause the storage domain to fail. In case of a failure a workaround is to append "-w /dev/watchdog1" to WDMDOPTS in /etc/sysconfig/wdmd and run systemctl start wdmd.service

### oVirt-Live-0.8.iso - beta version Nov 15th 2012

**Download**

*   [download oVirt-Live-0.8.iso](http://ovirt.org/releases/3.1/tools/oVirt-Live.0.8.iso)

**ChangeLog**

*   mostly changes to make installation work when no Ethernet interface connected

### oVirt-Live-0.7.iso - beta version Oct 23th 2012

**ChangeLog**

*   changed wallpapers (thanks Garrett)
*   oVirt-setup autostart added
*   oVirt-enigne welcome screen (via firefox) after successful setup
*   oVirt-setup terminal window stays open after setup (for debug needs)
*   Disconnected installs - setup works without outside network connection (packages wouldn't be updated by vsdm-bootstrap, yum reinstall vdsm-bootstrap to workaround)
*   wlan0 support in vdsm enabled (need someone to test it...)

### oVirt-Live-0.6.iso - alpha version Oct 12th 2012

**ChangeLog**

*   selinux disabled - workaround to sanlock problem
*   added ovirt_live plugin - performs attachment of iso domain to the DC, and creating vm with disk and network - Thanks to Ofer
*   changed ovirt-setup icons
*   shorten host installation time by around 4 minutes

### oVirt-Live-0.5.iso - alpha version Oct 10th 2012

**Status**

*   **functionality/usage**
    -   system boots and performs auto-login to oVirtuser
    -   ovirt setup needs to be run from gnome favourites
    -   user can choose either automatic/interactive install
    -   when setup is finished the user can open welcome page in firefox using ovirt-engine application from gnome favourites

<!-- -->

*   **branding**
    -   basic background is there
    -   basic icons are there

<!-- -->

*   **func**
*   change vm boot order to cd - 0.8

<!-- -->

*   **branding**
    -   wide/normal background - v1.0
    -   custom logos - v1.0

<!-- -->

*   **features/usage**
    -   add a python IDE to play with sdk - v0.8

<!-- -->

*   **maintenance**
    -   git build env

<!-- -->

*   **Problems/Bugs**
    -   persistent storage is slow - bigger it gets - slower it does
    -   need to add all workarounds to ovirt code base.
    -   currently working with selinux in permissive - problem running vms (sanlock)

<Category:Integration>

---
title: OVirt Live
category: integration
authors: apevec, bproffitt, dneary, jvandewege, mgoldboi, obasan, sandrobonazzola,
  stirabos
wiki_category: Integration
wiki_title: OVirt Live
wiki_revision_count: 54
wiki_last_updated: 2015-06-15
---

# OVirt Live

## What is it?

oVirt Live is an unofficial spin of live fedora 17[1,2], based on oVirt 3.1 release using allInOne[3] plugin.

[1] [fedora spins](http://spins.fedoraproject.org/about)

[2] [FedoraLiveCD](http://fedoraproject.org/wiki/FedoraLiveCD)

[3] [AllInOne](http://wiki.ovirt.org/wiki/Feature/AllInOne)

## Why do we need it?

This version can be used for POC or demos, and suppose to give a sneak preview for the working product operation.

simplify the the installation for new users, and will allow users to experiment with oVirt before later installing it.

## How can I use it?

oVirt Live comes as a live os, you can either use it:

### DVD

read only (all changes will be gone upon reboot)

### USB

can be used either as read only or with persistent storage

[How to create and use Live USB](http://fedoraproject.org/wiki/How_to_create_and_use_Live_USB)

[liveusb-creator](https://fedorahosted.org/liveusb-creator)

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

## Releases

### oVirt-Live-1.0.iso - Feb 21th 2013

#### Download

*   Fedora 18 based: [Download oVirt Live 1.0](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-1.0.iso)
*   EL6 based: [Download oVirt Live 1.0](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-el6.iso)

#### change-log

Based on oVirt 3.2 final

### oVirt-Live-0.97.iso - beta version Feb 1th 2013

#### Download

[Download oVirt Live 0.97](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-0.97.iso)

#### change-log

Based on ovirt 3.2 beta

Fedora 18

workaround for <https://bugzilla.redhat.com/show_bug.cgi?id=878119>

### oVirt-Live-0.9.iso - beta version Jan 9th 2013

#### Download

[Download oVirt Live 0.9](http://resources.ovirt.org/releases/3.2/tools/ovirt-live-0.9.iso)

#### change-log

Based on ovirt 3.2 nightly (git1a60fea) Fedora 18 beta

### Known-Issues

On some chipsets one could encounter the following bug: <https://bugzilla.redhat.com/show_bug.cgi?id=878119> which will cause the storage domain to fail. In case of a failure a workaround is to append "-w /dev/watchdog1" to WDMDOPTS in /etc/sysconfig/wdmd and run systemctl start wdmd.service

### oVirt-Live-0.8.iso - beta version Nov 15th 2012

#### Download

[download oVirt-Live-0.8.iso](http://ovirt.org/releases/3.1/tools/oVirt-Live.0.8.iso)

#### change-log

-mostly changes to make installation work when no Ethernet interface connected

### oVirt-Live-0.7.iso - beta version Oct 23th 2012

#### change-log

-changed wallpapers (thanks Garrett)

-oVirt-setup autostart added

-oVirt-enigne welcome screen (via firefox) after successful setup

-oVirt-setup terminal window stays open after setup (for debug needs)

-Disconnected installs - setup works without outside network connection (packages wouldn't be updated by vsdm-bootstrap, yum reinstall vdsm-bootstrap to workaround)

-wlan0 support in vdsm enabled (need someone to test it...)

### oVirt-Live-0.6.iso - alpha version Oct 12th 2012

#### change-log

-selinux disabled - workaround to sanlock problem

-added ovirt_live plugin - performs attachment of iso domain to the DC, and creating vm with disk and network - Thanks to Ofer

-changed ovirt-setup icons

-shorten host installation time by around 4 minutes

### oVirt-Live-0.5.iso - alpha version Oct 10th 2012

#### Status

##### functionality/usage

-system boots and performs auto-login to oVirtuser

-ovirt setup needs to be run from gnome favourites

-user can choose either automatic/interactive install

-when setup is finished the user can open welcome page in firefox using ovirt-engine application from gnome favourites

##### branding

-basic background is there

-basic icons are there

##### ToDo

###### func

-change vm boot order to cd - 0.8

###### branding

-wide/normal background - v1.0

-custom logos - v1.0

###### features/usage

-add a python IDE to play with sdk - v0.8

###### maintenance

-git build env

##### Problems/Bugs

-persistent storage is slow - bigger it gets - slower it does

-need to add all workarounds to ovirt code base.

-currently working with selinux in permissive - problem running vms (sanlock)

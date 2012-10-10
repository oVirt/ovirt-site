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

### oVirt-Live-0.5.iso - alpha version Oct 10th 2012

=

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

-create a following plugin to allInOne to configure and run vm, create template etc. -in progress

-shorten host installation time

###### branding

-wide/normal background

###### features/usage

-add a python IDE to play with sdk

###### maintenance

-git build env

##### Problems/Bugs

-persistent storage is slow - bigger it gets - slower it is

-need to add all workarounds to ovirt code base.

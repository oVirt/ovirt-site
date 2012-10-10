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

This version can be used for POC or demos, and suppose to give a sneak preview for the working product operation. and provide an easy installation flow for the product.

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

[Nested_KVM](http://wiki.ovirt.org/wiki/Vdsm_Developers#Running_Node_as_guest_-_Nested_KVM)

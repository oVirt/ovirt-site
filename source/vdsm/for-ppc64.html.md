---
title: Vdsm for PPC64
category: vdsm
authors: bpradipt, danken, gustavo.pedrosa, lbianc, sandrobonazzola, vitordelima
wiki_category: Feature|Vdsm_for_PPC64
wiki_title: Features/Vdsm for PPC64
wiki_revision_count: 34
wiki_last_updated: 2015-02-05
---

# Vdsm for PPC64

## Summary

This feature provides support for managing KVM on IBM POWER processors via oVirt.

Qemu and Libvirt support for KVM on IBM POWER processors is already available and is part of the respective upstream versions of the packages

All POWER Linux distributions (RHEL 6.x, SLES 11.x, Debian 6.x, Fedora 16+) that support Power7 native mode are supported as KVM guests. This limits older distributions, such as SUSE 10 and RHEL 5.x

## Owner

*   Feature owner: Pradipta Kr. Banerjee <bpradip@in.ibm.com>
    -   REST Component owner: Ricardo Marin Matinata <rmm@br.ibm.com>
    -   Engine Component owner: Ricardo Marin Matinata <rmm@br.ibm.com>
    -   VDSM Component owner: Pradipta Kr. Banerjee <bpradip@in.ibm.com>
    -   QA Owner: Li AG Zhang <zhlbj@cn.ibm.com>

## Current Status

*   Status: Design Stage

## Detailed Description

This feature will introduce the capability of managing KVM on IBM POWER processors via oVirt. Administrators will be able to perform management fuctionalities like:

*   Add/Activate KVM on IBM POWER host
*   Create cluster of KVM on IBM POWER hosts
*   Perform VM lifecycle management on any IBM POWER host
    -   create
    -   start
    -   stop
    -   edit
    -   remove
    -   pause
    -   migrate

Migrate is still work in progress for KVM on IBM POWER processor

### Approach

Managing KVM on IBM POWER processors requires changes to both vdsm and ovirt-engine. However the intent is to keep ovirt-engine changes to the minimum

Following are the key changes that will be required

*   Enhancing the bootstrapping mechanism in VDSM to handle IBM POWER processor and ppc64 specifics (like cpuid, cpu speed, cpu flags)
*   Adding a new CPU type (IBM POWER) to ovirt-engine
*   Enhancing the VM templates based on guest device models (disk, network, video) supported by KVM on IBM POWER

KVM on IBM POWER supports the following device models for guest

*   virt-io, spapr-vscsi for disk
*   virt-io, e1000, rtl and spapr-vlan for network
*   vga device is supported for guest video
*   Only VNC backend is supported for guest console access.

There is currently no support for SPICE protocol and USB support in guests.

Both NFS and SAN storage is supported for the hosts. iSCSI support is currently work in progress

### User Interface

No new user interfaces are required to be added. However few of the existing interfaces needs to be updated to reflect KVM on IBM POWER related specifics.

At the minimum following user interfaces will be affected

*   New Server/New Desktop Virtual Machine in userportal
*   New Server/New Desktop Virtual Machine in webadmin
*   Make Template in userportal and webadmin
*   Editing Virtual Disks and Editing Network Interfaces in webadmin
*   New Cluster in webadmin

## DEMO Version

There is a branch of VDSM with PPC64 support at: <https://bitbucket.org/gustavo_temple/ovirtvdsmmultiplatform> (Oct 14, 2013)

You can follow these steps to test the PPC64 code using the QEMU emulated mode in x86-64 hosts:

*   Configure the bridge Interface:

<http://www.ovirt.org/Installing_VDSM_from_rpm#Configuring_the_bridge_Interface>

*   Install required packages (with libvirt version <= 1.1.0):

<http://www.ovirt.org/Vdsm_Developers#Installing_required_packages>

*   Get the source:

<http://www.ovirt.org/Vdsm_Developers#Getting_the_source>

*   Checkout:

<http://gerrit.ovirt.org/#/c/18718>

*   Build a Vdsm RPM:

<http://www.ovirt.org/Vdsm_Developers#Building_a_Vdsm_RPM>

*   Install:

<http://www.ovirt.org/Vdsm_Developers#Basic_installation>

*   Create the '50-fake.conf' file:

<https://github.com/oVirt/ovirt-host-deploy/blob/master/README> /etc/ovirt-host-deploy.conf.d/50-fake.conf [environment:enforce] VDSM/checkVirtHardware=bool:False VDSM/configOverride=bool:False

*   Create the file '50-development.conf':

<https://github.com/oVirt/ovirt-host-deploy/blob/master/README> /etc/ovirt-host-deploy.conf.d/50-development.conf [environment:enforce] VDSM/configOverride=bool:False

*   Enable the fake mode in the vdsm.conf file:

/etc/vdsm/vdsm.conf fake_kvm_support = True fake_kvm_architecture = ppc64

*   Execute the command:

systemctl restart vdsmd.service

## Benefits to oVirt

oVirt would be able to support KVM running on IBM POWER processor based systems

## Dependencies / Related Features and Projects

Affected oVirt projects:

*   Engine-core
*   VDSM

## Documentation / External references

KVM on IBM POWER : <http://www.linux-kvm.org/wiki/images/5/5d/2011-forum-KVM_on_the_IBM_POWER7_Processor.pdf>

## Comments and Discussion

## Future Work

## Open Issues

<Category:Feature>

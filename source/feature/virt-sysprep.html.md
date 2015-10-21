---
title: virt-sysprep
authors: shaharh
wiki_title: Features/virt-sysprep
wiki_revision_count: 9
wiki_last_updated: 2015-11-02
feature_name: Virtual Sysprep
feature_modules: engine,vdsm
feature_status: Design
---

# Virt-Sysprep

### Summary

This feature will enable user to run [virt-sysprep](http://libguestfs.org/virt-sysprep.1.html) on Virtual Machine. virt-sysprep enable user to set and rested OS feature such as reset host name and network address and ssh keys as well as copy files, inject ssh keys to a given user, run scripts, run on next boot and more.

This feature will include

*   Automatic reset network, ssh etc on cloning VM
*   Automatic reset network, ssh etc on import VM
*   Virt-Sysprep page that will have extend operations such as: injecting ssh keys, running scripts etc.

Note that currently virt-sysprep support Linux only guest and only tested on major distributions.

### Owner

*   Name: [ Shahar Havivi](User:Shaharh)
*   Email: <shavivi@redhat.com>

### Detailed Design

=

#### vdsm

add a virt-sysprep module with general interface for running virt-sysprep utility.

*   api will get full drive path of the VM to manipulate
*   api will accept key-value object for setting virt-sysprep actions and a dictionary parameter for operations

action (injecting data) {'user-password': {'John' : {'123456'}, 'hostname': 'mynewvm'} operations (enable/disable opetions): ['delete-ssh-keys', 'dhcp-client']

#### engine

*   Clone VM:

automatic erase the following:

\*# dhcp-client-state

\*# net-hostname

\*# net-hwaddr

\*# ssh-hostkeys

\*# udev-persistent-net

*   Virt-Sysprep Tab:
    1.  run a startup script
    2.  set hostname
    3.  set user password
    4.  set root password
    5.  remove user account
    6.  inject ssh public key for user
    7.  set timezone

<!-- -->

*   UI desing:

TBD.

### Current status

*   engine: Design
*   vdsm: Design

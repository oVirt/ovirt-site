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

#### vdsm

add a virt-sysprep module with general interface for running virt-sysprep utility.

*   api will get full drive path of the VM to manipulate
*   api will accept named parameters as well as kwargs such as: virt-sysprep(firewall=False, resetNetwork=True, rootPassword=pass, \*\*kwargs)
*   acquire a sanlock on the VM image

#### engine

All the engines operations are stateless and do not need database persistence.

*   Clone VM:

Erase the following: (with checkboxes which are on by default)

\*# dhcp-client-state

\*# net-hostname

\*# net-hwaddr

\*# ssh-hostkeys

\*# udev-persistent-net

*   bash-history
*   logs
*   yum key

<!-- -->

*   Virt-Sysprep Tab:
    1.  run a startup script
    2.  set hostname
    3.  set user password
    4.  set root password
    5.  remove user account
    6.  inject ssh public key for user
    7.  set timezone
    8.  perform package update
    9.  install specific package

<!-- -->

*   UI desing:

TBD.

### Notes

*   All actions are related to multiple VMs.
    1.  all of the action of virt-sysprep tab can be run on multiple VMs
    2.  all the virt-sysprep tab options can be run on a VM-Pool. (ie on all of its VMs)
    3.  all actions will be enabled for Templates as well
*   Consider adding support for creating VM from template
*   VM must be down in order to run virt-sysprep
*   When adding/update package need to check that the storage domain have free space

### Current status

*   engine: Design
*   vdsm: Design

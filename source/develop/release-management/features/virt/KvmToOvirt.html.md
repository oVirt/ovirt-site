---
title: Importing Libvirt KVM VMs to oVirt
category: feature
authors: Shahar Havivi
wiki_category: Feature|v2v
wiki_title: Features/KvmToOvirt
wiki_revision_count: 1
wiki_last_updated: 2017-03-20
feature_name: 'v2v: Importing Libvirt Kvm Vms to oVirt'
feature_modules: all
feature_status: Released in oVirt 4.1
---

# Importing Libvirt KVM VMs to oVirt

## Summary
Import KVM based VMs from Libvirt management via the oVirt admin portal.
There is no need to disk conversion since both oVirt and Libvirt support KVM based VMs.
Importing VMs with file and block device disks are supported - snapshots are currently not supported but please note that if you want to import VM with snapshots the current snapshot is the one that will be       imported.
The import process is done via the utility kvm2ovirt, located at '/usr/libexec/vdsm/kvm2ovirt' (kvm2ovirt is a tool that come with VDSM installation).
Please note that the VMs that you want to import must be in status Down at Libvirt management.

## Libvirt Configuration
In order to import VM from Libvirt, Libvirt needs to listen on a public port or via ssh protocol.
ssh protocol uses the 'qemu+ssh://username@host1.example.org/system' and tcp uses 'qemu+tcp://username@host1.example.org/system'
- to setup via ssh please follow the following link: [ssh-setup](https://wiki.libvirt.org/page/SSHSetup)
- to setup via tcp please follow the following link: [tcp-setup](http://wiki.libvirt.org/page/Libvirt_daemon_is_not_listening_on_tcp_ports_although_configured_to)

## Importing VM
Importing VM is done by the VM uniq Libvirt name that can identify via:
$ virsh -c qemu+tcp://username@host1.example.org/system
$ virsh # list --all
For example lets say we want to import VM named 'rhel' from 'qemu+tcp://username@host1.example.org/system'
- Login to the admin portal and navigate to the VMs tab
- Press the 'Import' button on the toolbar
- in the Source box select 'KVM (via libvirt)' option
- enter 'qemu+tcp://username@host1.example.org/system' in the URI box
- press the 'Requires Authentication' checkbox if authentication needed and enter username/password
- press the 'Load' button
- in the box 'Virtual Machines on Source' you should see all the VMs that are down
- select the VM 'rhel' and press the right arrow -> to move it to the 'Virtual Machines to Import' box
- Press the 'Next' button
- In this dialog you can adjust the VM properties such as 'Operating System' and 'Allocation Policy'
- Press the 'OK' button
- You should see the 'rhel' VM listed in the VMs tab and the progress should start shortly

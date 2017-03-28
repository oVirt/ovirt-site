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
There is no need for disk conversion since both oVirt and Libvirt support KVM based VMs.
Importing VMs with file and block device disks are supported - snapshots are currently not supported but please note that if you want to import VM with snapshots the current snapshot is the one that will be imported.
The import process is done via the utility kvm2ovirt, located at '/usr/libexec/vdsm/kvm2ovirt' (kvm2ovirt is a tool that come with VDSM installation).
Please note that the VMs that you want to import must be in status Down at Libvirt management.

## Libvirt Configuration
In order to import VM from Libvirt, Libvirt needs to listen on a public port or over ssh protocol.
ssh protocol uses the 'qemu+ssh://username@host1.example.org/system' and tcp uses 'qemu+tcp://username@host1.example.org/system'
- to setup via ssh please follow the following link: [ssh-setup](https://wiki.libvirt.org/page/SSHSetup)
- to setup via tcp please follow the following link: [tcp-setup](http://wiki.libvirt.org/page/Libvirt_daemon_is_not_listening_on_tcp_ports_although_configured_to)

## Importing VM
Importing VM is done by the VM uniq Libvirt name that can be identify via:
$ virsh -r -c qemu+tcp://username@host1.example.org/system
$ virsh # list --all
For example if we want to import a VM named 'rhel1_local' from 'qemu+tcp://username@host1.example.org/system'
- Login to the 'Admin Portal' and navigate to the VMs tab
- Press the 'Import' button on the toolbar ![](/images/wiki/ImportFromKvm1.png)
- In the Source box select 'KVM (via libvirt)' option ![](/images/wiki/ImportFromKvm2.png)
- Enter 'qemu+tcp://username@host1.example.org/system' in the URI box
- Press the 'Requires Authentication' checkbox if authentication is needed and enter username/password
- Press the 'Load' button ![](/images/wiki/ImportFromKvm3.png)
- In the box 'Virtual Machines on Source' you should see all the VMs that are in 'down status'
- Select the VM 'rhel1_local' and press the right arrow -> to move it to the 'Virtual Machines to Import' box ![](/images/wiki/ImportFromKvm4.png)
- Press the 'Next' button ![](/images/wiki/ImportFromKvm5.png)
- In this dialog you can adjust the VM properties such as 'Operating System' and 'Allocation Policy'
- Press the 'OK' button ![](/images/wiki/ImportFromKvm6.png)
- You should see the 'rhel1_local' VM listed in the VMs tab and the progress should start shortly

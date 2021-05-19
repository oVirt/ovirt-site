---
title: Importing Xen on REHL 5.x to oVirt
category: feature
authors: Shahar Havivi
---

# Importing Xen on EL 5.x VMs to oVirt

## Summary
oVirt has the ability to import VMs from other hypervisor including **Xen** on EL 5.x (not yet for Citrix Xen)
The Import process uses [virt-v2v](http://libguestfs.org/virt-v2v.1.html) (under the "INPUT FROM EL 5 XEN" section) which explain the prerequisites that are needed in order to import Xen VMs.

## Importing VM
In order to import VMs password-less SSH access has to be enabled between VDSM host and the Xen host.
The following steps needed to be done at the VDSM host:

- Generate ssh kes for vdsm user `sudo -u vdsm ssh-keygen`
- Copy vdsm's public key to the Xen host `sudo -u vdsm ssh-copy-id user@xenhost`
- Login to the remote host (in order to test the connection and add the Xen host to the `known_hosts` file `sudo -u vdsm ssh user@xenhost`
- Exit the remote Xen host `logout`

We are logging to the Xen host after we copy the ssh key in order to check that the ssh-copy-id succeeded and in order to set the host's public key in the `~/.ssh/known_hosts`.

## Import VMs from Xen
- Login to oVirt admin portal
- In VM tab click the 'Import' button in the toolbar
- Select **'XEN (via EL)'** in the source select box
- Select VDSM host from the 'Proxy Host' select box
- Enter valid URI such as: `xen+ssh://user@xenhost`

## Import VMs with Block disks
Currently it is not possible to import Xen VMs with block disks via the webadmin.
As a workaround please follow these steps:
- Make sure you have an active export domain
- Run the commands:
- `virt-v2v-copy-to-local -ic xen+ssh://root@xenserver.com vmname`
- `virt-v2v -i libvirtxml vmname.xml -o rhev -of raw -os servername:/path/to/export/domain`
- The VM should be present at your export domain, now you can import the Vm to a data domain

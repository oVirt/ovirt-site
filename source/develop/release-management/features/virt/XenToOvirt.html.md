---
title: Importing Xen on REHL 5.x to oVirt
category: feature
authors: Shahar Havivi
wiki_category: Feature|v2v
wiki_title: Features/XenToOvirt
wiki_revision_count: 1
wiki_last_updated: 2015-06-02
feature_name: 'v2v: Importing Xen on EL to oVirt'
feature_modules: all
feature_status: Released in oVirt 4.0
---

# Importing Xen on EL 5.x VMs to oVirt

## Summary
oVirt has the ability to import VMs from other hypervisor including **Xen** on EL 5.x (not yet for Citrix Xen)
The Import process uses [virt-v2v](http://libguestfs.org/virt-v2v.1.html) (under the "INPUT FROM EL 5 XEN" section) which explain the prerequisites that are needed in order to import Xen VMs.

## Importing VM
In order to import VMs password-less SSH access has to be enabled between VDSM host and the Xen host.
The following steps needed to be done at the VDSM host:

- Generate ssh kes for vdsm user `sudo -u vdsm ssh-keygen`
- Copy vdsms public key to the Xen host `sudo -u vdsm ssh-copy-id user@xenhost`
- Login to the remote host (in order to test the connection and add the Xen host to the `known_hosts` file `sudo -u vdsm ssh user@xenhost`
- Exit the remote Xen host `logout`

We are logging to the xenhost after we copy the ssh key in order to check that the ssh-copy-id succeeded and in order to set the host public key in the `~/.ssh/known_hosts`.

## Import VMs from Xen
- Login to oVirt admin portal
- In VM tab click the 'Import' button in the toolbar
- Select **'XEN (via EL)'** in the source select box
- Select VDSM host from the 'Proxy Host' select box
- Enter valid URI such as: `xen+ssh://user@xenhost`

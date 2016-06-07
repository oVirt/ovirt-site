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
---

# Importing Xen on EL 5.x VMs to oVirt
-----------------------------------------------------------
### Summary
oVirt has the ability to import VMs from other hypervisor including **Xen** on EL 5.x (not yet for Citrix Xen)
The Import process uses [virt-v2v][1] (under the "INPUT FROM EL 5 XEN" section) which explain the prerequisites that are needed in order to import Xen VMs.
[1]: http://libguestfs.org/virt-v2v.1.html

### Importing VM
In order to import VMs  password-less SSH access has to be enabled between VDSM host and the Xen host.
The following steps must be taken under vdsm user in the VDSM host.
- You need to enable vdsm user, log in as root and run the following:
 ```

$ mkdir /home/vdsm
$ chown vdsm:kvm /home/vdsm
$ usermod -s /bin/bash -d /home/vdsm vdsm

 ```
- Log in as vdsm user and goto to vdsm home directory:```$ su - vdsm```
- Generate ssh keys for vdsm user:
 ```$ ssh-keygen```
- Login to the Xen server via ssh in order to exchange keys with the Xen host:
 ```$ sudo -u vdsm ssh root@xenhost```
- Transfer public key to allow the access to Xen host:
 ```$ sudo -u vdsm ssh-copy-id root@xenhost```
- Test that you can login without password
 ```$ ssh vdsm@xenhost```

### Import VMs from Xen
- Login to oVirt admin portal
- In VM tab click the 'Import' button in the toolbar
- Select **'XEN (via EL)'** in the source select box
- Select VDSM host from the 'Proxy Host' select box
- Enter valid URI such as: ```xen+ssh://root@xenhost```

### Restoring vdsm settings
- ```usermod -s /sbin/nologin -d /var/lib vdsm```
- ```rm -rf /home/vdsm```

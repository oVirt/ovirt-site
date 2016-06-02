# Importing Xen on RHEL 5.x VMs to oVirt
-----------------------------------------------------------
### Summary
oVirt had the ability to import VMs from other hypervisory including **Xen** on RHEL 5.x (not yet for Citrix Xen)
The Import process uses [virt-v2v][1] (under the "INPUT FROM RHEL 5 XEN" section) which explain the prerequisite that are needed in order to import Xen VMs.
[1]: http://libguestfs.org/virt-v2v.1.html

### Importing VM
In order to import VMs  password-less SSH access has to be enabled between VDSM host and the Xen host.
The following steps must be taken under vdsm user in the VDSM host.
- You need to enable vdsm user, log in as root and run the following:
 ```
$ mkdir /home/vdsm
$ chown 36:36 /home/vdsm 
$ vi /etc/passwd

# Make sure that vdsm user is enable (the default is disabled)
# Find the line that start with 'vdsm:' like the following:
# vdsm:x:36:36:Node Virtualization Manager:/home/vdsm:/sbin/nologin`
# and change it to:
# vdsm:x:36:36:Node Virtualization Manager:/home/vdsm:/bin/bash
 ```
- Log in as vdsm user and goto to vdsm home directory:```$ su - vdsm```
- Generate ssh keys for vdsm user:
 ```$ sudo -u vdsm ssh-keygen```
- Login to the Xen server via ssh in order to exchange keys with the Xen host:
 ```$ sudo -u vdsm ssh root@xenhost```
- Transfer public key to allow the access to Xen host:
 ```$ sudo -u vdsm ssh-copy-id root@xenhost```
- Test that you can login without password
 ```$ ssh vdsm@xenhost```

### Imort VMs from Xen
- Login to oVirt admin portal
- In VM tab click the 'Import' button in the toolbar
- Select **'XEN (via RHEL)'** in the source select box
- Select VDSM host from the 'Proxy Host' select box
- Enter valid URI such as: ```xen+ssh://root@xenhost```

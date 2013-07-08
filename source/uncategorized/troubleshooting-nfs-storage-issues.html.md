---
title: Troubleshooting NFS Storage Issues
authors: adahms, didi, dougsland, dpkshetty, jbrooks, nkesick, rharper, sgordon, suppentopf,
  wdennis
wiki_title: Troubleshooting NFS Storage Issues
wiki_revision_count: 24
wiki_last_updated: 2015-01-31
---

# Troubleshooting NFS Storage Issues

### Introduction

oVirt currently requires that NFS exports be configured in a specific way. This page is an attempt to list those requirements and assist with troubleshooting issues encountered when trying to attach an NFS storage domain to the oVirt environment for the first time.

*   The NFS server must support NFSv3. oVirt 3.0 does not support NFSv4, while oVirt 4.0 does support NFSv4. To force an NFS client to use NFSv3, add this option to the configuration file (**/etc/nfsmount.conf**):

      Nfsvers=3

*   To disable NFSv4 on an NFS server, add this option to the configuration file (**/etc/sysconfig/nfs**):

      NFS4_SUPPORT="no"

### Permissions

*   The exported directory must be readable and writeable to the user/group with uid **36** which is the **vdsm** user. There are two ways to ensure this:
    -   Chown the directory being exported 36:36.
    -   Add the **anonuid=36** and **anongid=36** options on the export in **/etc/exports**.

      /exports/iso       *(rw,anonuid=36,anongid=36)

*   The exported directory should have permissions **0755**:
*   The NFS server must actually be running.
    -   Ensure that the **nfs** and **rpcbind** services are running on the NFS server, Fedora 16 users should instead look for the **netfs** service.
    -   Ensure that **showmount -e *<nfs_server_ip>*** shows the expected export(s).

#### SELinux

*   Ensure that selinux is not interfering with NFS access.
    -   getsebool -a | grep virt_use_nfs should show virt_use_nfs --> on, if not then do \`setsebool virt_use_nfs 1\` to allow NFS access for VMs
    -   One can also use \`setsebool -P virt_use_nfs 1\` to make this setting persistent across reboots.

The easiest way to definitively test that an NFS export is ready for use by oVirt is to:

*   Create the **vdsm** user with uid **36** on the ovirt-engine host if it does not already exist.
*   Change to the **vdsm** user using **su - vdsm**. If vdsm user was not hand-created, then chances are su - vdsm might fail. Do **su - vdsm -s /bin/bash**
*   Attempt to mount the export to a temporary directory and touch a file on it.

### nfs-check program

A new nfs check script is now available to test whether an NFS export is ready for use by oVirt :

*   **nfs-check.py** is a python script to validate nfs targets to use with oVirt project. Some operations includes: mount the nfs target, create a file as vdsm:kvm and remove it.
*   **nfs-check.py** available in **vdsm/contrib/** directory of the vdsm source
*   Run it as **python nfs-check.py server:/target**

       $ git clone http://gerrit.ovirt.org/p/vdsm.git
       $ cd vdsm/contrib
       $ python nfs-check.py myNFSServer:/nfsTarget

### Setting NFS Server

#### Debian Squeeze

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # cat /etc/exports
      /storage    *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)

      # /etc/init.d/nfs-kernel-server restart 

#### Fedora 16 or higher

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # yum -y install nfs-utils

      # cat /etc/exports
      /storage    *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)

      # systemctl start rpcbind.service
      # systemctl start nfs-server.service
      # systemctl start nfs-lock.service 

      # systemctl enable rpcbind.service
      # systemctl enable nfs-server.service
      # systemctl enable nfs-lock.service

#### RHEL6 based distro

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # cat /etc/exports
      /storage    *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)

      # /etc/init.d/nfs restart 

## Workarounds

### NFS Storage Domain Failure on Fedora 17

In the past, nodes running Fedora 17 kernels newer than 3.4 have trouble with NFS storage domains.
This issue has been fixed in: vdsm-4.10.0-10.fc17
Download: <http://koji.fedoraproject.org/koji/buildinfo?buildID=358280>
More info: <https://bugzilla.redhat.com/show_bug.cgi?id=845660#c29>
 In case, you still use vdsm < 4.10.0-10, the workaround is to use the 3.4 kernel in F17.
You can use grub2's SAVEDEFAULT option to keep the endpoint booted on 3.4.

*   Confirm you have a 3.4 kernel

       # rpm -qa | grep kernel-3.4
      kernel-3.4.0-1.fc17.x86_64 

*   Update default grub config to ensure 'saved default' works

      $EDITOR /etc/default/grub
       

*   Ensure you have the following two lines

      GRUB_SAVEDEFAULT=true
      GRUB_DEFAULT=saved
       

*   Generate new grub config

      # grub2-mkconfig -o /boot/grub2/grub.cfg
       

*   Reboot your system

      # reboot
       

*   Interrupt boot sequence and select the 3.4 kernel under the 'Advanced' menu.
*   Login and confirm you're running 3.4

      # uname -a
      Linux ichigo-dom228 3.4.0-1.fc17.x86_64 #1 SMP Sun Jun 3 06:35:17 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
       

*   Reboot once more and let it boot back up by itself and confirm it selected the 3.4 kernel
